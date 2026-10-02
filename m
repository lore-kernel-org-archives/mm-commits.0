Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCA113101A9
	for <mm-commits@vger.kernel.org>; Fri,  2 Oct 2026 20:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790974123; cv=none; b=P30+7HAngxJ/UOdhw5WOVlrYEm2yAugO24JQpbygxmG8sxuFY9nGF+L/h9nilLDYGMmMm/8ZCZgAXrV9iwBXGHcyJBwx/nB3n6UsbYeT6AIiuDWcUn6EYi5VnUUQ8oSYV0DiDTwB0/9mQXeCm6r/p/3XXHNFULz3fcadewByUQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790974123; c=relaxed/simple;
	bh=QzX4YXG6dR9oeWj7E+n1/K1lgMYjnwZkQP0hQ+aDGCk=;
	h=Date:To:From:Subject:Message-Id; b=GWhXTPbzkw38GD2lIZhrKkYAkVXecbW6Hpu5FLnKL2uXSA544hfGprA+DY4cgcDpFGpY9yKgv09ICYOTCZpv9hU5VOne7L033A1yTL6/T632tuoikpPJ4/4r34Gx+5EXfXdcJan0zqSbqsT26WZlvK2nrHULw9FBm/1z2tSOL6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=splT+ZMA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="splT+ZMA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 478A21F000FF;
	Fri,  2 Oct 2026 20:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790974121;
	bh=Tvt+8aaJjy6ip4dWKaij6DAeo2TRrPbBQ5AD0bsPGD4=;
	h=Date:To:From:Subject;
	b=splT+ZMAXpogKjW9YE1Nrr/IO3aQwgKj0qM8W6GLAopv6I8zFvWbaFcWF+WMMyS7q
	 Hn6irumT0SrScYIh5FmxDYlQPAO2trRXhPGKAUjp4YTGVF+wAgu+QlXgAqLU88faO7
	 KAk5/fDZP+4Ciey2yblrRg/8EKcuddSEmXQVSSvQ=
Date: Fri, 02 Oct 2026 13:48:40 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,azpijr@gmail.com,ekffu200098@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-memory-remove-unused-vmf_insert_mixed_mkwrite.patch removed from -mm tree
Message-Id: <20261002204841.478A21F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory: remove unused vmf_insert_mixed_mkwrite()
has been removed from the -mm tree.  Its filename was
     mm-memory-remove-unused-vmf_insert_mixed_mkwrite.patch

This patch was dropped because an updated version will be issued

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
Cc: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
---

 include/linux/mm.h |    2 -
 mm/memory.c        |   76 ++++++++++---------------------------------
 2 files changed, 19 insertions(+), 59 deletions(-)

--- a/include/linux/mm.h~mm-memory-remove-unused-vmf_insert_mixed_mkwrite
+++ a/include/linux/mm.h
@@ -5015,8 +5015,6 @@ vm_fault_t vmf_insert_pfn_prot(struct vm
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
bootconfig-remove-redundant-assignment-in-xbc_parse_array.patch
init-mainc-remove-unreachable-check-in-obsolete_checksetup.patch

