Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED91D1CEEB2
	for <mm-commits@vger.kernel.org>; Wed, 21 May 2025 16:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747846625; cv=none; b=Jtmyf3ikMxEtnAHcBBpwhrDrI5+xzrm5mgms4M/q52jOfcLAAUCKgqdnu+p7OQz+8q8Rif5mYLlL3169PkGrA/cONuBxa7J5xyPXz33/dKI6VLjgYX/gkafR/AZ54nQAHFCdv24ioo+/etf/vgq+wxFhKQmmFhMtZ27A1j17NQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747846625; c=relaxed/simple;
	bh=gqe3JAK1bBhFfoDw06i/+nOFdyytCLmyLPPQyc0pNiI=;
	h=Date:To:From:Subject:Message-Id; b=K8xmqT44AYcVV1CgahlJNMw6T8xajLhBvElGC0QBIL6Wy/J07+XKR6rOuiNOgGmrAbdElw6TMruGHsYWKZKrjSuS90zg2grm9dZRIuciMrITcLAFIO0YaFhzhqPYgU2CB89+nCq9/ACQwJ3QU3c4I8fFbjGIFBRrVfdy7hwrNrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0BY6TZf9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0BY6TZf9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40B05C4CEE4;
	Wed, 21 May 2025 16:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747846624;
	bh=gqe3JAK1bBhFfoDw06i/+nOFdyytCLmyLPPQyc0pNiI=;
	h=Date:To:From:Subject:From;
	b=0BY6TZf97oWzbzDhNbqoMSv7V0P7zBx1Eby0BuGrNSjTjvNJD8mZ6UOPj9DTK1Eae
	 c8PuXK7kHnXHmiudwsAvwOsJ+J2lT2ndRLFWsN6CULCpHJOeapPgU7UBZVqmfK6oii
	 noK3Zx/G8PLr3szDGRuMRIh0hF6WPs7258qeUwOU=
Date: Wed, 21 May 2025 09:57:03 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,tursulin@ursulin.net,tglx@linutronix.de,rostedt@goodmis.org,rodrigo.vivi@intel.com,peterz@infradead.org,peterx@redhat.com,mingo@kernel.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,luto@kernel.org,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,joonas.lahtinen@linux.intel.com,jannh@google.com,jani.nikula@linux.intel.com,hpa@zytor.com,bp@alien8.de,airlied@gmail.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] x86-mm-pat-factor-out-setting-cachemode-into-pgprot_set_cachemode.patch removed from -mm tree
Message-Id: <20250521165704.40B05C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86/mm/pat: factor out setting cachemode into pgprot_set_cachemode()
has been removed from the -mm tree.  Its filename was
     x86-mm-pat-factor-out-setting-cachemode-into-pgprot_set_cachemode.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: x86/mm/pat: factor out setting cachemode into pgprot_set_cachemode()
Date: Mon, 12 May 2025 14:34:14 +0200

VM_PAT annoyed me too much and wasted too much of my time, let's clean PAT
handling up and remove VM_PAT.

This should sort out various issues with VM_PAT we discovered recently,
and will hopefully make the whole code more stable and easier to maintain.

In essence: we stop letting PAT mode mess with VMAs and instead lift what
to track/untrack to the MM core.  We remember per VMA which pfn range we
tracked in a new struct we attach to a VMA (we have space without
exceeding 192 bytes), use a kref to share it among VMAs during
split/mremap/fork, and automatically untrack once the kref drops to 0.

This implies that we'll keep tracking a full pfn range even after
partially unmapping it, until fully unmapping it; but as that case was
mostly broken before, this at least makes it work in a way that is least
intrusive to VMA handling.

Shrinking with mremap() used to work in a hacky way, now we'll similarly
keep the original pfn range tacked even after this form of partial unmap. 
Does anybody care about that?  Unlikely.  If we run into issues, we could
likely handled that (adjust the tracking) when our kref drops to 1 while
freeing a VMA.  But it adds more complexity, so avoid that for now.

Briefly tested with the new pfnmap selftests [1].


This patch (of 11):

Let's factor it out to make the code easier to grasp.  Drop one comment
where it is now rather obvious what is happening.

Use it also in pgprot_writecombine()/pgprot_writethrough() where clearing
the old cachemode might not be required, but given that we are already
doing a function call, no need to care about this micro-optimization.

Link: https://lkml.kernel.org/r/20250512123424.637989-1-david@redhat.com
Link: https://lkml.kernel.org/r/20250512123424.637989-2-david@redhat.com
Link: https://lkml.kernel.org/r/20250509153033.952746-1-david@redhat.com [1]
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Ingo Molnar <mingo@kernel.org>	[x86 bits]
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Dave Airlie <airlied@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Tvrtko Ursulin <tursulin@ursulin.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/pat/memtype.c |   33 +++++++++++++++------------------
 1 file changed, 15 insertions(+), 18 deletions(-)

--- a/arch/x86/mm/pat/memtype.c~x86-mm-pat-factor-out-setting-cachemode-into-pgprot_set_cachemode
+++ a/arch/x86/mm/pat/memtype.c
@@ -800,6 +800,12 @@ static inline int range_is_allowed(unsig
 }
 #endif /* CONFIG_STRICT_DEVMEM */
 
+static inline void pgprot_set_cachemode(pgprot_t *prot, enum page_cache_mode pcm)
+{
+	*prot = __pgprot((pgprot_val(*prot) & ~_PAGE_CACHE_MASK) |
+			 cachemode2protval(pcm));
+}
+
 int phys_mem_access_prot_allowed(struct file *file, unsigned long pfn,
 				unsigned long size, pgprot_t *vma_prot)
 {
@@ -811,8 +817,7 @@ int phys_mem_access_prot_allowed(struct
 	if (file->f_flags & O_DSYNC)
 		pcm = _PAGE_CACHE_MODE_UC_MINUS;
 
-	*vma_prot = __pgprot((pgprot_val(*vma_prot) & ~_PAGE_CACHE_MASK) |
-			     cachemode2protval(pcm));
+	pgprot_set_cachemode(vma_prot, pcm);
 	return 1;
 }
 
@@ -880,9 +885,7 @@ static int reserve_pfn_range(u64 paddr,
 				(unsigned long long)paddr,
 				(unsigned long long)(paddr + size - 1),
 				cattr_name(pcm));
-			*vma_prot = __pgprot((pgprot_val(*vma_prot) &
-					     (~_PAGE_CACHE_MASK)) |
-					     cachemode2protval(pcm));
+			pgprot_set_cachemode(vma_prot, pcm);
 		}
 		return 0;
 	}
@@ -907,9 +910,7 @@ static int reserve_pfn_range(u64 paddr,
 		 * We allow returning different type than the one requested in
 		 * non strict case.
 		 */
-		*vma_prot = __pgprot((pgprot_val(*vma_prot) &
-				      (~_PAGE_CACHE_MASK)) |
-				     cachemode2protval(pcm));
+		pgprot_set_cachemode(vma_prot, pcm);
 	}
 
 	if (memtype_kernel_map_sync(paddr, size, pcm) < 0) {
@@ -1060,9 +1061,7 @@ int track_pfn_remap(struct vm_area_struc
 			return -EINVAL;
 	}
 
-	*prot = __pgprot((pgprot_val(*prot) & (~_PAGE_CACHE_MASK)) |
-			 cachemode2protval(pcm));
-
+	pgprot_set_cachemode(prot, pcm);
 	return 0;
 }
 
@@ -1073,10 +1072,8 @@ void track_pfn_insert(struct vm_area_str
 	if (!pat_enabled())
 		return;
 
-	/* Set prot based on lookup */
 	pcm = lookup_memtype(pfn_t_to_phys(pfn));
-	*prot = __pgprot((pgprot_val(*prot) & (~_PAGE_CACHE_MASK)) |
-			 cachemode2protval(pcm));
+	pgprot_set_cachemode(prot, pcm);
 }
 
 /*
@@ -1115,15 +1112,15 @@ void untrack_pfn_clear(struct vm_area_st
 
 pgprot_t pgprot_writecombine(pgprot_t prot)
 {
-	return __pgprot(pgprot_val(prot) |
-				cachemode2protval(_PAGE_CACHE_MODE_WC));
+	pgprot_set_cachemode(&prot, _PAGE_CACHE_MODE_WC);
+	return prot;
 }
 EXPORT_SYMBOL_GPL(pgprot_writecombine);
 
 pgprot_t pgprot_writethrough(pgprot_t prot)
 {
-	return __pgprot(pgprot_val(prot) |
-				cachemode2protval(_PAGE_CACHE_MODE_WT));
+	pgprot_set_cachemode(&prot, _PAGE_CACHE_MODE_WT);
+	return prot;
 }
 EXPORT_SYMBOL_GPL(pgprot_writethrough);
 
_

Patches currently in -mm which might be from david@redhat.com are


