Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ADAB22D7B1
	for <mm-commits@vger.kernel.org>; Wed, 21 May 2025 16:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747846627; cv=none; b=rXzuX/NFtAI1mrxWpP1QvJ/ZjY/RqK9iv9y5CIvcyLN4DJyZDwQlDX0JbxwGJNB+ua7rQvgYWRW5nc5s8EeC0N0yqqadfCZhw2EkvWsJBih1oQ4UK6yKQAE2xFIPhy+BqNgFHM2s5gLsMKEQ+xlPs8eov4GD8G2jcVXhpVHUabU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747846627; c=relaxed/simple;
	bh=iFwTh3HbtmJBEGrWJS8EL15YicYjLfgMd30xBtoBYUM=;
	h=Date:To:From:Subject:Message-Id; b=VA4ZolL4ORFB3Wum0AcssclvxXfeBESWRLM94a5xthtOuaaJBsJ75Fx3aAiBmx/E2YjuBObH1wCMKkziReIm5hwAZicU9/t4nVCWFAOEFbUIjM6QJeob040MJISd58+XblHzkxW7mIrNlGYU+XYyghxhweULS57yLU/WvylANwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oxXcFzeh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oxXcFzeh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4C1AC4CEE4;
	Wed, 21 May 2025 16:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747846625;
	bh=iFwTh3HbtmJBEGrWJS8EL15YicYjLfgMd30xBtoBYUM=;
	h=Date:To:From:Subject:From;
	b=oxXcFzehPYF8YHU0g5P1gQElXU6OUc1TwKzpW1+Q6Dzwaq8v1eUK9BYdJy7YF7j6p
	 cmPrS7sH+oDr/xkITeNIukwWB7ReKctGOKS1SfFY5wdZzy20amFEXBjC3b0TBHMxjQ
	 1f76a+C31zWXbsuPbPJCXKz81DwX8KLJLJcUvhwc=
Date: Wed, 21 May 2025 09:57:05 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,tursulin@ursulin.net,tglx@linutronix.de,rostedt@goodmis.org,rodrigo.vivi@intel.com,peterz@infradead.org,peterx@redhat.com,mingo@kernel.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,luto@kernel.org,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,joonas.lahtinen@linux.intel.com,jannh@google.com,jani.nikula@linux.intel.com,hpa@zytor.com,bp@alien8.de,airlied@gmail.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-convert-track_pfn_insert-to-pfnmap_setup_cachemode.patch removed from -mm tree
Message-Id: <20250521165705.B4C1AC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: convert track_pfn_insert() to pfnmap_setup_cachemode*()
has been removed from the -mm tree.  Its filename was
     mm-convert-track_pfn_insert-to-pfnmap_setup_cachemode.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm: convert track_pfn_insert() to pfnmap_setup_cachemode*()
Date: Mon, 12 May 2025 14:34:15 +0200

...  by factoring it out from track_pfn_remap() into
pfnmap_setup_cachemode() and provide pfnmap_setup_cachemode_pfn() as a
replacement for track_pfn_insert().

For PMDs/PUDs, we keep checking a single pfn only.  Add some
documentation, and also document why it is valid to not check the whole
pfn range.

We'll reuse pfnmap_setup_cachemode() from core MM next.

Link: https://lkml.kernel.org/r/20250512123424.637989-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Ingo Molnar <mingo@kernel.org>	[x86 bits]
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Dave Airlie <airlied@gmail.com>
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

 arch/x86/mm/pat/memtype.c |   24 +++++-----------
 include/linux/pgtable.h   |   52 ++++++++++++++++++++++++++++++------
 mm/huge_memory.c          |    5 ++-
 mm/memory.c               |    4 +-
 4 files changed, 57 insertions(+), 28 deletions(-)

--- a/arch/x86/mm/pat/memtype.c~mm-convert-track_pfn_insert-to-pfnmap_setup_cachemode
+++ a/arch/x86/mm/pat/memtype.c
@@ -1031,7 +1031,6 @@ int track_pfn_remap(struct vm_area_struc
 		    unsigned long pfn, unsigned long addr, unsigned long size)
 {
 	resource_size_t paddr = (resource_size_t)pfn << PAGE_SHIFT;
-	enum page_cache_mode pcm;
 
 	/* reserve the whole chunk starting from paddr */
 	if (!vma || (addr == vma->vm_start
@@ -1044,13 +1043,17 @@ int track_pfn_remap(struct vm_area_struc
 		return ret;
 	}
 
+	return pfnmap_setup_cachemode(pfn, size, prot);
+}
+
+int pfnmap_setup_cachemode(unsigned long pfn, unsigned long size, pgprot_t *prot)
+{
+	resource_size_t paddr = (resource_size_t)pfn << PAGE_SHIFT;
+	enum page_cache_mode pcm;
+
 	if (!pat_enabled())
 		return 0;
 
-	/*
-	 * For anything smaller than the vma size we set prot based on the
-	 * lookup.
-	 */
 	pcm = lookup_memtype(paddr);
 
 	/* Check memtype for the remaining pages */
@@ -1065,17 +1068,6 @@ int track_pfn_remap(struct vm_area_struc
 	return 0;
 }
 
-void track_pfn_insert(struct vm_area_struct *vma, pgprot_t *prot, pfn_t pfn)
-{
-	enum page_cache_mode pcm;
-
-	if (!pat_enabled())
-		return;
-
-	pcm = lookup_memtype(pfn_t_to_phys(pfn));
-	pgprot_set_cachemode(prot, pcm);
-}
-
 /*
  * untrack_pfn is called while unmapping a pfnmap for a region.
  * untrack can be called for a specific region indicated by pfn and size or
--- a/include/linux/pgtable.h~mm-convert-track_pfn_insert-to-pfnmap_setup_cachemode
+++ a/include/linux/pgtable.h
@@ -1496,13 +1496,10 @@ static inline int track_pfn_remap(struct
 	return 0;
 }
 
-/*
- * track_pfn_insert is called when a _new_ single pfn is established
- * by vmf_insert_pfn().
- */
-static inline void track_pfn_insert(struct vm_area_struct *vma, pgprot_t *prot,
-				    pfn_t pfn)
+static inline int pfnmap_setup_cachemode(unsigned long pfn, unsigned long size,
+		pgprot_t *prot)
 {
+	return 0;
 }
 
 /*
@@ -1552,8 +1549,32 @@ static inline void untrack_pfn_clear(str
 extern int track_pfn_remap(struct vm_area_struct *vma, pgprot_t *prot,
 			   unsigned long pfn, unsigned long addr,
 			   unsigned long size);
-extern void track_pfn_insert(struct vm_area_struct *vma, pgprot_t *prot,
-			     pfn_t pfn);
+
+/**
+ * pfnmap_setup_cachemode - setup the cachemode in the pgprot for a pfn range
+ * @pfn: the start of the pfn range
+ * @size: the size of the pfn range in bytes
+ * @prot: the pgprot to modify
+ *
+ * Lookup the cachemode for the pfn range starting at @pfn with the size
+ * @size and store it in @prot, leaving other data in @prot unchanged.
+ *
+ * This allows for a hardware implementation to have fine-grained control of
+ * memory cache behavior at page level granularity. Without a hardware
+ * implementation, this function does nothing.
+ *
+ * Currently there is only one implementation for this - x86 Page Attribute
+ * Table (PAT). See Documentation/arch/x86/pat.rst for more details.
+ *
+ * This function can fail if the pfn range spans pfns that require differing
+ * cachemodes. If the pfn range was previously verified to have a single
+ * cachemode, it is sufficient to query only a single pfn. The assumption is
+ * that this is the case for drivers using the vmf_insert_pfn*() interface.
+ *
+ * Returns 0 on success and -EINVAL on error.
+ */
+int pfnmap_setup_cachemode(unsigned long pfn, unsigned long size,
+		pgprot_t *prot);
 extern int track_pfn_copy(struct vm_area_struct *dst_vma,
 		struct vm_area_struct *src_vma, unsigned long *pfn);
 extern void untrack_pfn_copy(struct vm_area_struct *dst_vma,
@@ -1563,6 +1584,21 @@ extern void untrack_pfn(struct vm_area_s
 extern void untrack_pfn_clear(struct vm_area_struct *vma);
 #endif
 
+/**
+ * pfnmap_setup_cachemode_pfn - setup the cachemode in the pgprot for a pfn
+ * @pfn: the pfn
+ * @prot: the pgprot to modify
+ *
+ * Lookup the cachemode for @pfn and store it in @prot, leaving other
+ * data in @prot unchanged.
+ *
+ * See pfnmap_setup_cachemode() for details.
+ */
+static inline void pfnmap_setup_cachemode_pfn(unsigned long pfn, pgprot_t *prot)
+{
+	pfnmap_setup_cachemode(pfn, PAGE_SIZE, prot);
+}
+
 #ifdef CONFIG_MMU
 #ifdef __HAVE_COLOR_ZERO_PAGE
 static inline int is_zero_pfn(unsigned long pfn)
--- a/mm/huge_memory.c~mm-convert-track_pfn_insert-to-pfnmap_setup_cachemode
+++ a/mm/huge_memory.c
@@ -1455,7 +1455,8 @@ vm_fault_t vmf_insert_pfn_pmd(struct vm_
 			return VM_FAULT_OOM;
 	}
 
-	track_pfn_insert(vma, &pgprot, pfn);
+	pfnmap_setup_cachemode_pfn(pfn_t_to_pfn(pfn), &pgprot);
+
 	ptl = pmd_lock(vma->vm_mm, vmf->pmd);
 	error = insert_pfn_pmd(vma, addr, vmf->pmd, pfn, pgprot, write,
 			pgtable);
@@ -1577,7 +1578,7 @@ vm_fault_t vmf_insert_pfn_pud(struct vm_
 	if (addr < vma->vm_start || addr >= vma->vm_end)
 		return VM_FAULT_SIGBUS;
 
-	track_pfn_insert(vma, &pgprot, pfn);
+	pfnmap_setup_cachemode_pfn(pfn_t_to_pfn(pfn), &pgprot);
 
 	ptl = pud_lock(vma->vm_mm, vmf->pud);
 	insert_pfn_pud(vma, addr, vmf->pud, pfn, write);
--- a/mm/memory.c~mm-convert-track_pfn_insert-to-pfnmap_setup_cachemode
+++ a/mm/memory.c
@@ -2564,7 +2564,7 @@ vm_fault_t vmf_insert_pfn_prot(struct vm
 	if (!pfn_modify_allowed(pfn, pgprot))
 		return VM_FAULT_SIGBUS;
 
-	track_pfn_insert(vma, &pgprot, __pfn_to_pfn_t(pfn, PFN_DEV));
+	pfnmap_setup_cachemode_pfn(pfn, &pgprot);
 
 	return insert_pfn(vma, addr, __pfn_to_pfn_t(pfn, PFN_DEV), pgprot,
 			false);
@@ -2627,7 +2627,7 @@ static vm_fault_t __vm_insert_mixed(stru
 	if (addr < vma->vm_start || addr >= vma->vm_end)
 		return VM_FAULT_SIGBUS;
 
-	track_pfn_insert(vma, &pgprot, pfn);
+	pfnmap_setup_cachemode_pfn(pfn_t_to_pfn(pfn), &pgprot);
 
 	if (!pfn_modify_allowed(pfn_t_to_pfn(pfn), pgprot))
 		return VM_FAULT_SIGBUS;
_

Patches currently in -mm which might be from david@redhat.com are


