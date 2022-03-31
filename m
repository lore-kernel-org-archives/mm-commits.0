Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80105C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 31 Mar 2022 04:33:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbiCaEfX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 31 Mar 2022 00:35:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbiCaEfH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 31 Mar 2022 00:35:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E82B5AEC3
        for <mm-commits@vger.kernel.org>; Wed, 30 Mar 2022 21:33:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 28ADE6147B
        for <mm-commits@vger.kernel.org>; Thu, 31 Mar 2022 04:33:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 750D4C340ED;
        Thu, 31 Mar 2022 04:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648701198;
        bh=Jn/CjX4dguvDfGPyUovSWJxVkk4CcB/fipGqv1UK/sc=;
        h=Date:To:From:Subject:From;
        b=hxU2jwNF2+BM9Z7qrYcuMCjQcAhO22jQo5VJqKRUrQdoZXmXgBbys7QSRmgl/6oLn
         ubsCG6tGADUf7FCdteir8T7lYnZkHnqQpDGJgpYl3WcjIpRnGGrEfImZFWFgNt5c4+
         izhGvcgkPhzuxCJCD116ibFoiJ0qcfpZK3WwfSVs=
Date:   Wed, 30 Mar 2022 21:33:17 -0700
To:     mm-commits@vger.kernel.org, zhangliang5@huawei.com,
        willy@infradead.org, vbabka@suse.cz, shy828301@gmail.com,
        shakeelb@google.com, rppt@linux.ibm.com, rientjes@google.com,
        riel@surriel.com, peterx@redhat.com, pedrodemargomes@gmail.com,
        oleg@redhat.com, oded.gabbay@gmail.com, namit@vmware.com,
        mike.kravetz@oracle.com, mhocko@kernel.org,
        kirill.shutemov@linux.intel.com, khalid.aziz@oracle.com,
        jhubbard@nvidia.com, jgg@nvidia.com, jannh@google.com,
        jack@suse.cz, hughd@google.com, hch@lst.de, guro@fb.com,
        ddutile@redhat.com, aarcange@redhat.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-trigger-fault_flag_unshare-when-r-o-pinning-a-possibly-shared-anonymous-page.patch added to -mm tree
Message-Id: <20220331043318.750D4C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: trigger FAULT_FLAG_UNSHARE when R/O-pinning a possibly shared anonymous page
has been added to the -mm tree.  Its filename is
     mm-gup-trigger-fault_flag_unshare-when-r-o-pinning-a-possibly-shared-anonymous-page.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-gup-trigger-fault_flag_unshare-when-r-o-pinning-a-possibly-shared-anonymous-page.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-gup-trigger-fault_flag_unshare-when-r-o-pinning-a-possibly-shared-anonymous-page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/gup: trigger FAULT_FLAG_UNSHARE when R/O-pinning a possibly shared anonymous page

Whenever GUP currently ends up taking a R/O pin on an anonymous page that
might be shared -- mapped R/O and !PageAnonExclusive() -- any write fault
on the page table entry will end up replacing the mapped anonymous page
due to COW, resulting in the GUP pin no longer being consistent with the
page actually mapped into the page table.

The possible ways to deal with this situation are:
 (1) Ignore and pin -- what we do right now.
 (2) Fail to pin -- which would be rather surprising to callers and
     could break user space.
 (3) Trigger unsharing and pin the now exclusive page -- reliable R/O
     pins.

Let's implement 3) because it provides the clearest semantics and allows
for checking in unpin_user_pages() and friends for possible BUGs: when
trying to unpin a page that's no longer exclusive, clearly something went
very wrong and might result in memory corruptions that might be hard to
debug.  So we better have a nice way to spot such issues.

This change implies that whenever user space *wrote* to a private mapping
(IOW, we have an anonymous page mapped), that GUP pins will always remain
consistent: reliable R/O GUP pins of anonymous pages.

As a side note, this commit fixes the COW security issue for hugetlb with
FOLL_PIN as documented in:
  https://lore.kernel.org/r/3ae33b08-d9ef-f846-56fb-645e3b9b4c66@redhat.com
The vmsplice reproducer still applies, because vmsplice uses FOLL_GET
instead of FOLL_PIN.

Note that follow_huge_pmd() doesn't apply because we cannot end up in
there with FOLL_PIN.

This commit is heavily based on prototype patches by Andrea.

Link: https://lkml.kernel.org/r/20220329160440.193848-16-david@redhat.com
Co-developed-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Don Dutile <ddutile@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Khalid Aziz <khalid.aziz@oracle.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Liang Zhang <zhangliang5@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Nadav Amit <namit@vmware.com>
Cc: Oded Gabbay <oded.gabbay@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   39 +++++++++++++++++++++++++++++++++++++++
 mm/gup.c           |   42 +++++++++++++++++++++++++++++++++++++++---
 mm/huge_memory.c   |    3 +++
 mm/hugetlb.c       |   27 ++++++++++++++++++++++++---
 4 files changed, 105 insertions(+), 6 deletions(-)

--- a/include/linux/mm.h~mm-gup-trigger-fault_flag_unshare-when-r-o-pinning-a-possibly-shared-anonymous-page
+++ a/include/linux/mm.h
@@ -3005,6 +3005,45 @@ static inline int vm_fault_to_errno(vm_f
 	return 0;
 }
 
+/*
+ * Indicates for which pages that are write-protected in the page table,
+ * whether GUP has to trigger unsharing via FAULT_FLAG_UNSHARE such that the
+ * GUP pin will remain consistent with the pages mapped into the page tables
+ * of the MM.
+ *
+ * Temporary unmapping of PageAnonExclusive() pages or clearing of
+ * PageAnonExclusive() has to protect against concurrent GUP:
+ * * Ordinary GUP: Using the PT lock
+ * * GUP-fast and fork(): mm->write_protect_seq
+ * * GUP-fast and KSM or temporary unmapping (swap, migration):
+ *   clear/invalidate+flush of the page table entry
+ *
+ * Must be called with the (sub)page that's actually referenced via the
+ * page table entry, which might not necessarily be the head page for a
+ * PTE-mapped THP.
+ */
+static inline bool gup_must_unshare(unsigned int flags, struct page *page)
+{
+	/*
+	 * FOLL_WRITE is implicitly handled correctly as the page table entry
+	 * has to be writable -- and if it references (part of) an anonymous
+	 * folio, that part is required to be marked exclusive.
+	 */
+	if ((flags & (FOLL_WRITE | FOLL_PIN)) != FOLL_PIN)
+		return false;
+	/*
+	 * Note: PageAnon(page) is stable until the page is actually getting
+	 * freed.
+	 */
+	if (!PageAnon(page))
+		return false;
+	/*
+	 * Note that PageKsm() pages cannot be exclusive, and consequently,
+	 * cannot get pinned.
+	 */
+	return !PageAnonExclusive(page);
+}
+
 typedef int (*pte_fn_t)(pte_t *pte, unsigned long addr, void *data);
 extern int apply_to_page_range(struct mm_struct *mm, unsigned long address,
 			       unsigned long size, pte_fn_t fn, void *data);
--- a/mm/gup.c~mm-gup-trigger-fault_flag_unshare-when-r-o-pinning-a-possibly-shared-anonymous-page
+++ a/mm/gup.c
@@ -506,6 +506,10 @@ retry:
 		}
 	}
 
+	if (!pte_write(pte) && gup_must_unshare(flags, page)) {
+		page = ERR_PTR(-EMLINK);
+		goto out;
+	}
 	/* try_grab_page() does nothing unless FOLL_GET or FOLL_PIN is set. */
 	if (unlikely(!try_grab_page(page, flags))) {
 		page = ERR_PTR(-ENOMEM);
@@ -732,6 +736,11 @@ static struct page *follow_p4d_mask(stru
  * When getting pages from ZONE_DEVICE memory, the @ctx->pgmap caches
  * the device's dev_pagemap metadata to avoid repeating expensive lookups.
  *
+ * When getting an anonymous page and the caller has to trigger unsharing
+ * of a shared anonymous page first, -EMLINK is returned. The caller should
+ * trigger a fault with FAULT_FLAG_UNSHARE set. Note that unsharing is only
+ * relevant with FOLL_PIN and !FOLL_WRITE.
+ *
  * On output, the @ctx->page_mask is set according to the size of the page.
  *
  * Return: the mapped (struct page *), %NULL if no mapping exists, or
@@ -855,7 +864,8 @@ unmap:
  * is, *@locked will be set to 0 and -EBUSY returned.
  */
 static int faultin_page(struct vm_area_struct *vma,
-		unsigned long address, unsigned int *flags, int *locked)
+		unsigned long address, unsigned int *flags, bool unshare,
+		int *locked)
 {
 	unsigned int fault_flags = 0;
 	vm_fault_t ret;
@@ -877,6 +887,11 @@ static int faultin_page(struct vm_area_s
 		 */
 		fault_flags |= FAULT_FLAG_TRIED;
 	}
+	if (unshare) {
+		fault_flags |= FAULT_FLAG_UNSHARE;
+		/* FAULT_FLAG_WRITE and FAULT_FLAG_UNSHARE are incompatible */
+		VM_BUG_ON(fault_flags & FAULT_FLAG_WRITE);
+	}
 
 	ret = handle_mm_fault(vma, address, fault_flags, NULL);
 	if (ret & VM_FAULT_ERROR) {
@@ -1098,8 +1113,9 @@ retry:
 		cond_resched();
 
 		page = follow_page_mask(vma, start, foll_flags, &ctx);
-		if (!page) {
-			ret = faultin_page(vma, start, &foll_flags, locked);
+		if (!page || PTR_ERR(page) == -EMLINK) {
+			ret = faultin_page(vma, start, &foll_flags,
+					   PTR_ERR(page) == -EMLINK, locked);
 			switch (ret) {
 			case 0:
 				goto retry;
@@ -2201,6 +2217,11 @@ static int gup_pte_range(pmd_t pmd, unsi
 			goto pte_unmap;
 		}
 
+		if (!pte_write(pte) && gup_must_unshare(flags, page)) {
+			gup_put_folio(folio, 1, flags);
+			goto pte_unmap;
+		}
+
 		/*
 		 * We need to make the page accessible if and only if we are
 		 * going to access its content (the FOLL_PIN case).  Please
@@ -2381,6 +2402,11 @@ static int gup_hugepte(pte_t *ptep, unsi
 		return 0;
 	}
 
+	if (!pte_write(pte) && gup_must_unshare(flags, &folio->page)) {
+		gup_put_folio(folio, refs, flags);
+		return 0;
+	}
+
 	*nr += refs;
 	folio_set_referenced(folio);
 	return 1;
@@ -2442,6 +2468,11 @@ static int gup_huge_pmd(pmd_t orig, pmd_
 		return 0;
 	}
 
+	if (!pmd_write(orig) && gup_must_unshare(flags, &folio->page)) {
+		gup_put_folio(folio, refs, flags);
+		return 0;
+	}
+
 	*nr += refs;
 	folio_set_referenced(folio);
 	return 1;
@@ -2476,6 +2507,11 @@ static int gup_huge_pud(pud_t orig, pud_
 		gup_put_folio(folio, refs, flags);
 		return 0;
 	}
+
+	if (!pud_write(orig) && gup_must_unshare(flags, &folio->page)) {
+		gup_put_folio(folio, refs, flags);
+		return 0;
+	}
 
 	*nr += refs;
 	folio_set_referenced(folio);
--- a/mm/huge_memory.c~mm-gup-trigger-fault_flag_unshare-when-r-o-pinning-a-possibly-shared-anonymous-page
+++ a/mm/huge_memory.c
@@ -1389,6 +1389,9 @@ struct page *follow_trans_huge_pmd(struc
 	page = pmd_page(*pmd);
 	VM_BUG_ON_PAGE(!PageHead(page) && !is_zone_device_page(page), page);
 
+	if (!pmd_write(*pmd) && gup_must_unshare(flags, page))
+		return ERR_PTR(-EMLINK);
+
 	if (!try_grab_page(page, flags))
 		return ERR_PTR(-ENOMEM);
 
--- a/mm/hugetlb.c~mm-gup-trigger-fault_flag_unshare-when-r-o-pinning-a-possibly-shared-anonymous-page
+++ a/mm/hugetlb.c
@@ -5964,6 +5964,25 @@ static void record_subpages_vmas(struct
 	}
 }
 
+static inline bool __follow_hugetlb_must_fault(unsigned int flags, pte_t *pte,
+					       bool *unshare)
+{
+	pte_t pteval = huge_ptep_get(pte);
+
+	*unshare = false;
+	if (is_swap_pte(pteval))
+		return true;
+	if (huge_pte_write(pteval))
+		return false;
+	if (flags & FOLL_WRITE)
+		return true;
+	if (gup_must_unshare(flags, pte_page(pteval))) {
+		*unshare = true;
+		return true;
+	}
+	return false;
+}
+
 long follow_hugetlb_page(struct mm_struct *mm, struct vm_area_struct *vma,
 			 struct page **pages, struct vm_area_struct **vmas,
 			 unsigned long *position, unsigned long *nr_pages,
@@ -5978,6 +5997,7 @@ long follow_hugetlb_page(struct mm_struc
 	while (vaddr < vma->vm_end && remainder) {
 		pte_t *pte;
 		spinlock_t *ptl = NULL;
+		bool unshare = false;
 		int absent;
 		struct page *page;
 
@@ -6028,9 +6048,8 @@ long follow_hugetlb_page(struct mm_struc
 		 * both cases, and because we can't follow correct pages
 		 * directly from any kind of swap entries.
 		 */
-		if (absent || is_swap_pte(huge_ptep_get(pte)) ||
-		    ((flags & FOLL_WRITE) &&
-		      !huge_pte_write(huge_ptep_get(pte)))) {
+		if (absent ||
+		    __follow_hugetlb_must_fault(flags, pte, &unshare)) {
 			vm_fault_t ret;
 			unsigned int fault_flags = 0;
 
@@ -6038,6 +6057,8 @@ long follow_hugetlb_page(struct mm_struc
 				spin_unlock(ptl);
 			if (flags & FOLL_WRITE)
 				fault_flags |= FAULT_FLAG_WRITE;
+			else if (unshare)
+				fault_flags |= FAULT_FLAG_UNSHARE;
 			if (locked)
 				fault_flags |= FAULT_FLAG_ALLOW_RETRY |
 					FAULT_FLAG_KILLABLE;
_

Patches currently in -mm which might be from david@redhat.com are

mm-rmap-fix-missing-swap_free-in-try_to_unmap-after-arch_unmap_one-failed.patch
mm-hugetlb-take-src_mm-write_protect_seq-in-copy_hugetlb_page_range.patch
mm-memory-slightly-simplify-copy_present_pte.patch
mm-rmap-split-page_dup_rmap-into-page_dup_file_rmap-and-page_try_dup_anon_rmap.patch
mm-rmap-convert-rmap-flags-to-a-proper-distinct-rmap_t-type.patch
mm-rmap-remove-do_page_add_anon_rmap.patch
mm-rmap-pass-rmap-flags-to-hugepage_add_anon_rmap.patch
mm-rmap-drop-compound-parameter-from-page_add_new_anon_rmap.patch
mm-rmap-use-page_move_anon_rmap-when-reusing-a-mapped-pageanon-page-exclusively.patch
mm-huge_memory-remove-outdated-vm_warn_on_once_page-from-unmap_page.patch
mm-page-flags-reuse-pg_mappedtodisk-as-pg_anon_exclusive-for-pageanon-pages.patch
mm-remember-exclusively-mapped-anonymous-pages-with-pg_anon_exclusive.patch
mm-gup-disallow-follow_pagefoll_pin.patch
mm-support-gup-triggered-unsharing-of-anonymous-pages.patch
mm-gup-trigger-fault_flag_unshare-when-r-o-pinning-a-possibly-shared-anonymous-page.patch
mm-gup-sanity-check-with-config_debug_vm-that-anonymous-pages-are-exclusive-when-unpinning.patch
mm-swap-remember-pg_anon_exclusive-via-a-swp-pte-bit.patch
mm-debug_vm_pgtable-add-tests-for-__have_arch_pte_swp_exclusive.patch
x86-pgtable-support-__have_arch_pte_swp_exclusive.patch
arm64-pgtable-support-__have_arch_pte_swp_exclusive.patch
s390-pgtable-cleanup-description-of-swp-pte-layout.patch
s390-pgtable-support-__have_arch_pte_swp_exclusive.patch
powerpc-pgtable-remove-_page_bit_swap_type-for-book3s.patch
powerpc-pgtable-support-__have_arch_pte_swp_exclusive-for-book3s.patch

