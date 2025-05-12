Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15628230BC0
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 23:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747092857; cv=none; b=PXLhJJNf5EG+N2q2ox+msjwmxiDYrhVl0Ks4EPtvX6kHRzFM2pHjIzyxXvSdkdDfXN8ivdyUy5sc9adVABSxwioms28y3/1OHbSvQ7nu81RN5+pmQGwuExHCGyH2FFm8FtCeyDeeMNbqxG49YsyAOAVgtny9Rk0pFSH80kELi6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747092857; c=relaxed/simple;
	bh=XlCn/9FSRABW0/Oq+B62muztvIKmCv3ufPr3jrTbsl0=;
	h=Date:To:From:Subject:Message-Id; b=QU/Dn9KcDB1XQdS8Xfp4Xf16JOuszVcvdd5HUNvVz5QLC+1PRjyTHfvxmZPHlgn1UiYhwZHamMRYVNphLFO98v3dgOFi5MDfcdn4ttV1RNZHtGW7T45oXCLQTUMeSwHG+FbN45UFWz1baTsfkaUVfD1t6wqsWlAyGHSAIginr6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RZhWRfEY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RZhWRfEY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DF0AC4CEE7;
	Mon, 12 May 2025 23:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747092855;
	bh=XlCn/9FSRABW0/Oq+B62muztvIKmCv3ufPr3jrTbsl0=;
	h=Date:To:From:Subject:From;
	b=RZhWRfEY4o/VELd6cWjARdSI3E7UUHwBac2rcaKyZCERmliTGRYKXnRAFXhuwgu3y
	 AjG84y8kJO7soMhTGa9vl/+YdfY89fLQNFbxSFiTqwh/r2Orn7j01dUwzXL+NLZd8T
	 pFOgkgumafVzw+yCLonhPx31ldbRfRrGbgs0zoPk=
Date: Mon, 12 May 2025 16:34:14 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,tursulin@ursulin.net,tglx@linutronix.de,rostedt@goodmis.org,rodrigo.vivi@intel.com,peterz@infradead.org,peterx@redhat.com,mingo@kernel.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,luto@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,joonas.lahtinen@linux.intel.com,jannh@google.com,jani.nikula@linux.intel.com,hpa@zytor.com,bp@alien8.de,airlied@gmail.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-mm-pat-factor-out-setting-cachemode-into-pgprot_set_cachemode.patch added to mm-new branch
Message-Id: <20250512233415.5DF0AC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/mm/pat: factor out setting cachemode into pgprot_set_cachemode()
has been added to the -mm mm-new branch.  Its filename is
     x86-mm-pat-factor-out-setting-cachemode-into-pgprot_set_cachemode.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-mm-pat-factor-out-setting-cachemode-into-pgprot_set_cachemode.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Dave Airlie <airlied@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
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

selftests-mm-add-simple-vm_pfnmap-tests-based-on-mmaping-dev-mem.patch
x86-mm-pat-factor-out-setting-cachemode-into-pgprot_set_cachemode.patch
mm-convert-track_pfn_insert-to-pfnmap_setup_cachemode.patch
mm-introduce-pfnmap_track-and-pfnmap_untrack-and-use-them-for-memremap.patch
mm-convert-vm_pfnmap-tracking-to-pfnmap_track-pfnmap_untrack.patch
x86-mm-pat-remove-old-pfnmap-tracking-interface.patch
mm-remove-vm_pat.patch
x86-mm-pat-remove-strict_prot-parameter-from-reserve_pfn_range.patch
x86-mm-pat-remove-memtype__match.patch
x86-mm-pat-inline-memtype_match-into-memtype_erase.patch
drm-i915-track_pfn-pfnmap-tracking.patch
mm-io-mapping-track_pfn-pfnmap-tracking.patch

