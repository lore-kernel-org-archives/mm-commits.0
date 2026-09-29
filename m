Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FB5439FCCD
	for <mm-commits@vger.kernel.org>; Tue, 29 Sep 2026 20:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790712834; cv=none; b=O7ooaas2q8uT+zdpe5Pgb28FmlBHZp1olKacZUSjgry68o7kxbu/RbTqxTLnsnhzGEmCjtj/pm8OlqFoXy1y/ICKP5v8kAx5oxY1PF2t5LngcjukeYK8Qi1E/Qu6acm7vhFZwXQ1V2KkrkHtTzOJoAxVbaICbwNHllaHIlq0FkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790712834; c=relaxed/simple;
	bh=ZXqIwZyuOMryJSheiILGkDD2PrIbJUcr6lc5omLqaWE=;
	h=Date:To:From:Subject:Message-Id; b=BfWnKcYTsZG/wTqfa7VuCCGlHjzgUXBH9qhLH01xjcozrBLOdn+DLK6yPSbPhd4WzUEq/0YiheUijiAoi86lXFUk6r2Tdg6zoVok4HzTg51EHq6wS2L2chArbks4XZD2/DIOEPgKMRyF/RJfmoz1q3CG1tRatLqlZsrBbvAr5/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=A7nn/b4J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="A7nn/b4J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23D1F1F000FF;
	Tue, 29 Sep 2026 20:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790712832;
	bh=h9SCCJwSIvrKuYpjv9b0dh1yi4QxS/JA2K2EA0IMEfE=;
	h=Date:To:From:Subject;
	b=A7nn/b4JM93HQX3+onYRQJZ64+eZ82sNRhIj0XszkTS/QBb+Mt6Dzc2Ygv/1K5bjH
	 Gsl5uvOGah9BTiWGTnT16ANyE1MxO3ugAwnPwhPbyqIKp672Bm+879qRQbBX10OXGp
	 TgRrwfkjKZWwv3QXMXTLTpS7F65qJcaOefEjzxLo=
Date: Tue, 29 Sep 2026 13:13:51 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,ekffu200098@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-remove-unused-vmf_insert_mixed_mkwrite.patch added to mm-new branch
Message-Id: <20260929201352.23D1F1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory: remove unused vmf_insert_mixed_mkwrite()
has been added to the -mm mm-new branch.  Its filename is
     mm-memory-remove-unused-vmf_insert_mixed_mkwrite.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-remove-unused-vmf_insert_mixed_mkwrite.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: mm/memory: remove unused vmf_insert_mixed_mkwrite()
Date: Tue, 29 Sep 2026 23:37:06 +0900

Since commit 38607c62b34b ("fs/dax: properly refcount fs dax pages"),
vmf_insert_mixed_mkwrite() has no callers, so the mkwrite argument of
__vm_insert_mixed() and insert_pfn() is always false.

So remove the function, the mkwrite argument and the unreachable mkwrite
branches.  Also merge __vm_insert_mixed() into vmf_insert_mixed().

No functional change.

Link: https://lore.kernel.org/20260929143707.450805-1-ekffu200098@gmail.com
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 include/linux/mm.h |    2 -
 mm/memory.c        |   76 ++++++++++---------------------------------
 2 files changed, 19 insertions(+), 59 deletions(-)

--- a/include/linux/mm.h~mm-memory-remove-unused-vmf_insert_mixed_mkwrite
+++ a/include/linux/mm.h
@@ -5008,8 +5008,6 @@ vm_fault_t vmf_insert_pfn_prot(struct vm
 			unsigned long pfn, pgprot_t pgprot);
 vm_fault_t vmf_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
 			unsigned long pfn);
-vm_fault_t vmf_insert_mixed_mkwrite(struct vm_area_struct *vma,
-		unsigned long addr, unsigned long pfn);
 int vm_iomap_memory(struct vm_area_struct *vma, phys_addr_t start, unsigned long len);
 
 static inline vm_fault_t vmf_insert_page(struct vm_area_struct *vma,
--- a/mm/memory.c~mm-memory-remove-unused-vmf_insert_mixed_mkwrite
+++ a/mm/memory.c
@@ -2453,7 +2453,14 @@ static int insert_page_into_pte_locked(s
 		if (!mkwrite)
 			return -EBUSY;
 
-		/* see insert_pfn(). */
+		/*
+		 * For read faults on private mappings the PFN passed in may
+		 * not match the PFN we have mapped if the mapped PFN is a
+		 * writeable COW page.  In the mkwrite case we are creating a
+		 * writable PTE for a shared mapping and we expect the PFNs to
+		 * match. If they don't match, we are likely racing with block
+		 * allocation and mapping invalidation.
+		 */
 		if (pte_pfn(pteval) != page_to_pfn(page)) {
 			WARN_ON_ONCE(!is_zero_pfn(pte_pfn(pteval)));
 			return -EFAULT;
@@ -2858,7 +2865,7 @@ int vm_map_pages_zero(struct vm_area_str
 EXPORT_SYMBOL(vm_map_pages_zero);
 
 static vm_fault_t insert_pfn(struct vm_area_struct *vma, unsigned long addr,
-			unsigned long pfn, pgprot_t prot, bool mkwrite)
+			unsigned long pfn, pgprot_t prot)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	pte_t *pte, entry;
@@ -2868,38 +2875,12 @@ static vm_fault_t insert_pfn(struct vm_a
 	if (!pte)
 		return VM_FAULT_OOM;
 	entry = ptep_get(pte);
-	if (!pte_none(entry)) {
-		if (mkwrite) {
-			/*
-			 * For read faults on private mappings the PFN passed
-			 * in may not match the PFN we have mapped if the
-			 * mapped PFN is a writeable COW page.  In the mkwrite
-			 * case we are creating a writable PTE for a shared
-			 * mapping and we expect the PFNs to match. If they
-			 * don't match, we are likely racing with block
-			 * allocation and mapping invalidation so just skip the
-			 * update.
-			 */
-			if (pte_pfn(entry) != pfn) {
-				WARN_ON_ONCE(!is_zero_pfn(pte_pfn(entry)));
-				goto out_unlock;
-			}
-			entry = pte_mkyoung(entry);
-			entry = maybe_mkwrite(pte_mkdirty(entry), vma);
-			if (ptep_set_access_flags(vma, addr, pte, entry, 1))
-				update_mmu_cache(vma, addr, pte);
-		}
+	if (!pte_none(entry))
 		goto out_unlock;
-	}
 
 	/* Ok, finally just insert the thing.. */
 	entry = pte_mkspecial(pfn_pte(pfn, prot));
 
-	if (mkwrite) {
-		entry = pte_mkyoung(entry);
-		entry = maybe_mkwrite(pte_mkdirty(entry), vma);
-	}
-
 	set_pte_at(mm, addr, pte, entry);
 	update_mmu_cache(vma, addr, pte); /* XXX: why not for insert_page? */
 
@@ -2967,7 +2948,7 @@ vm_fault_t vmf_insert_pfn_prot(struct vm
 
 	pfnmap_setup_cachemode_pfn(pfn, &pgprot);
 
-	return insert_pfn(vma, addr, pfn, pgprot, false);
+	return insert_pfn(vma, addr, pfn, pgprot);
 }
 EXPORT_SYMBOL(vmf_insert_pfn_prot);
 
@@ -2998,11 +2979,9 @@ vm_fault_t vmf_insert_pfn(struct vm_area
 }
 EXPORT_SYMBOL(vmf_insert_pfn);
 
-static bool vm_mixed_ok(struct vm_area_struct *vma, unsigned long pfn,
-			bool mkwrite)
+static bool vm_mixed_ok(struct vm_area_struct *vma, unsigned long pfn)
 {
-	if (unlikely(is_zero_pfn(pfn)) &&
-	    (mkwrite || !vm_mixed_zeropage_allowed(vma)))
+	if (unlikely(is_zero_pfn(pfn)) && !vm_mixed_zeropage_allowed(vma))
 		return false;
 	/* these checks mirror the abort conditions in vm_normal_page */
 	if (vma->vm_flags & VM_MIXEDMAP)
@@ -3012,13 +2991,13 @@ static bool vm_mixed_ok(struct vm_area_s
 	return false;
 }
 
-static vm_fault_t __vm_insert_mixed(struct vm_area_struct *vma,
-		unsigned long addr, unsigned long pfn, bool mkwrite)
+vm_fault_t vmf_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
+		unsigned long pfn)
 {
 	pgprot_t pgprot = vma->vm_page_prot;
 	int err;
 
-	if (!vm_mixed_ok(vma, pfn, mkwrite))
+	if (!vm_mixed_ok(vma, pfn))
 		return VM_FAULT_SIGBUS;
 
 	if (addr < vma->vm_start || addr >= vma->vm_end)
@@ -3045,9 +3024,9 @@ static vm_fault_t __vm_insert_mixed(stru
 		 * result in pfn_t_has_page() == false.
 		 */
 		page = pfn_to_page(pfn);
-		err = insert_page(vma, addr, page, pgprot, mkwrite);
+		err = insert_page(vma, addr, page, pgprot, false);
 	} else {
-		return insert_pfn(vma, addr, pfn, pgprot, mkwrite);
+		return insert_pfn(vma, addr, pfn, pgprot);
 	}
 
 	if (err == -ENOMEM)
@@ -3057,6 +3036,7 @@ static vm_fault_t __vm_insert_mixed(stru
 
 	return VM_FAULT_NOPAGE;
 }
+EXPORT_SYMBOL(vmf_insert_mixed);
 
 vm_fault_t vmf_insert_page_mkwrite(struct vm_fault *vmf, struct page *page,
 			bool write)
@@ -3078,24 +3058,6 @@ vm_fault_t vmf_insert_page_mkwrite(struc
 }
 EXPORT_SYMBOL_GPL(vmf_insert_page_mkwrite);
 
-vm_fault_t vmf_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
-		unsigned long pfn)
-{
-	return __vm_insert_mixed(vma, addr, pfn, false);
-}
-EXPORT_SYMBOL(vmf_insert_mixed);
-
-/*
- *  If the insertion of PTE failed because someone else already added a
- *  different entry in the mean time, we treat that as success as we assume
- *  the same entry was actually inserted.
- */
-vm_fault_t vmf_insert_mixed_mkwrite(struct vm_area_struct *vma,
-		unsigned long addr, unsigned long pfn)
-{
-	return __vm_insert_mixed(vma, addr, pfn, true);
-}
-
 /*
  * maps a range of physical memory into the requested pages. the old
  * mappings are removed. any references to nonexistent pages results
_

Patches currently in -mm which might be from ekffu200098@gmail.com are

percpu-fix-the-comment-about-which-sizes-share-a-slot.patch
percpu-remove-redundant-assignments-to-bits.patch
percpu-remove-unnecessary-initialization-in-pcpu_build_alloc_info.patch
percpu-remove-unnecessary-cpumask_clear-in-pcpu_build_alloc_info.patch
percpu-remove-unnecessary-return-in-pcpu_populate_pte.patch
mm-swapops-remove-unused-is_hwpoison_entry.patch
mm-memory-remove-unused-vmf_insert_mixed_mkwrite.patch
bootconfig-remove-redundant-assignment-in-xbc_parse_array.patch
init-mainc-remove-unreachable-check-in-obsolete_checksetup.patch

