Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F8D9C433F5
	for <mm-commits@archiver.kernel.org>; Wed,  6 Apr 2022 01:56:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389937AbiDFB4x (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Apr 2022 21:56:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379196AbiDEUk2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2022 16:40:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 596C5101F0F
        for <mm-commits@vger.kernel.org>; Tue,  5 Apr 2022 13:20:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7194EB81FDC
        for <mm-commits@vger.kernel.org>; Tue,  5 Apr 2022 20:17:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ECD7C385A1;
        Tue,  5 Apr 2022 20:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649189832;
        bh=//PFIdzUVVFBGnGU0Gr4jmbM8ONrfQJeELEunjQfLkI=;
        h=Date:To:From:Subject:From;
        b=KPAnLykQf6PUE+OoYNvX3BWgCUFN7PqmsvJlXgs08e+dVKqtUVHaAX8PoJs+ufWpe
         uzeZTicM3+jtZKbqISx9P4pvkQDFMcoBg52pUrTSpIej86CfJtQiBpK5fdk/UExn4p
         4iuqCtbRgteKTe4qqrlGlcBviIHs4EbLcK3eGDQQ=
Date:   Tue, 05 Apr 2022 13:17:11 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rppt@linux.vnet.ibm.com, nadav.amit@gmail.com,
        mike.kravetz@oracle.com, kirill@shutemov.name, jglisse@redhat.com,
        hughd@google.com, david@redhat.com, axelrasmussen@google.com,
        apopple@nvidia.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-handle-uffd-wp-during-fork.patch added to -mm tree
Message-Id: <20220405201712.2ECD7C385A1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: handle uffd-wp during fork()
has been added to the -mm tree.  Its filename is
     mm-hugetlb-handle-uffd-wp-during-fork.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-handle-uffd-wp-during-fork.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-handle-uffd-wp-during-fork.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/hugetlb: handle uffd-wp during fork()

Firstly, we'll need to pass in dst_vma into copy_hugetlb_page_range()
because for uffd-wp it's the dst vma that matters on deciding how we
should treat uffd-wp protected ptes.

We should recognize pte markers during fork and do the pte copy if needed.

Link: https://lkml.kernel.org/r/20220405014918.14932-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    7 ++++--
 mm/hugetlb.c            |   42 +++++++++++++++++++++++++-------------
 mm/memory.c             |    2 -
 3 files changed, 34 insertions(+), 17 deletions(-)

--- a/include/linux/hugetlb.h~mm-hugetlb-handle-uffd-wp-during-fork
+++ a/include/linux/hugetlb.h
@@ -137,7 +137,8 @@ int move_hugetlb_page_tables(struct vm_a
 			     struct vm_area_struct *new_vma,
 			     unsigned long old_addr, unsigned long new_addr,
 			     unsigned long len);
-int copy_hugetlb_page_range(struct mm_struct *, struct mm_struct *, struct vm_area_struct *);
+int copy_hugetlb_page_range(struct mm_struct *, struct mm_struct *,
+			    struct vm_area_struct *, struct vm_area_struct *);
 long follow_hugetlb_page(struct mm_struct *, struct vm_area_struct *,
 			 struct page **, struct vm_area_struct **,
 			 unsigned long *, unsigned long *, long, unsigned int,
@@ -269,7 +270,9 @@ static inline struct page *follow_huge_a
 }
 
 static inline int copy_hugetlb_page_range(struct mm_struct *dst,
-			struct mm_struct *src, struct vm_area_struct *vma)
+					  struct mm_struct *src,
+					  struct vm_area_struct *dst_vma,
+					  struct vm_area_struct *src_vma)
 {
 	BUG();
 	return 0;
--- a/mm/hugetlb.c~mm-hugetlb-handle-uffd-wp-during-fork
+++ a/mm/hugetlb.c
@@ -4706,23 +4706,24 @@ hugetlb_install_page(struct vm_area_stru
 }
 
 int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
-			    struct vm_area_struct *vma)
+			    struct vm_area_struct *dst_vma,
+			    struct vm_area_struct *src_vma)
 {
 	pte_t *src_pte, *dst_pte, entry, dst_entry;
 	struct page *ptepage;
 	unsigned long addr;
-	bool cow = is_cow_mapping(vma->vm_flags);
-	struct hstate *h = hstate_vma(vma);
+	bool cow = is_cow_mapping(src_vma->vm_flags);
+	struct hstate *h = hstate_vma(src_vma);
 	unsigned long sz = huge_page_size(h);
 	unsigned long npages = pages_per_huge_page(h);
-	struct address_space *mapping = vma->vm_file->f_mapping;
+	struct address_space *mapping = src_vma->vm_file->f_mapping;
 	struct mmu_notifier_range range;
 	int ret = 0;
 
 	if (cow) {
-		mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, src,
-					vma->vm_start,
-					vma->vm_end);
+		mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, src_vma, src,
+					src_vma->vm_start,
+					src_vma->vm_end);
 		mmu_notifier_invalidate_range_start(&range);
 		mmap_assert_write_locked(src);
 		raw_write_seqcount_begin(&src->write_protect_seq);
@@ -4736,12 +4737,12 @@ int copy_hugetlb_page_range(struct mm_st
 		i_mmap_lock_read(mapping);
 	}
 
-	for (addr = vma->vm_start; addr < vma->vm_end; addr += sz) {
+	for (addr = src_vma->vm_start; addr < src_vma->vm_end; addr += sz) {
 		spinlock_t *src_ptl, *dst_ptl;
 		src_pte = huge_pte_offset(src, addr, sz);
 		if (!src_pte)
 			continue;
-		dst_pte = huge_pte_alloc(dst, vma, addr, sz);
+		dst_pte = huge_pte_alloc(dst, dst_vma, addr, sz);
 		if (!dst_pte) {
 			ret = -ENOMEM;
 			break;
@@ -4776,6 +4777,7 @@ again:
 		} else if (unlikely(is_hugetlb_entry_migration(entry) ||
 				    is_hugetlb_entry_hwpoisoned(entry))) {
 			swp_entry_t swp_entry = pte_to_swp_entry(entry);
+			bool uffd_wp = huge_pte_uffd_wp(entry);
 
 			if (!is_readable_migration_entry(swp_entry) && cow) {
 				/*
@@ -4785,10 +4787,21 @@ again:
 				swp_entry = make_readable_migration_entry(
 							swp_offset(swp_entry));
 				entry = swp_entry_to_pte(swp_entry);
+				if (userfaultfd_wp(src_vma) && uffd_wp)
+					entry = huge_pte_mkuffd_wp(entry);
 				set_huge_swap_pte_at(src, addr, src_pte,
 						     entry, sz);
 			}
+			if (!userfaultfd_wp(dst_vma) && uffd_wp)
+				entry = huge_pte_clear_uffd_wp(entry);
 			set_huge_swap_pte_at(dst, addr, dst_pte, entry, sz);
+		} else if (unlikely(is_pte_marker(entry))) {
+			/*
+			 * We copy the pte marker only if the dst vma has
+			 * uffd-wp enabled.
+			 */
+			if (userfaultfd_wp(dst_vma))
+				set_huge_pte_at(dst, addr, dst_pte, entry);
 		} else {
 			entry = huge_ptep_get(src_pte);
 			ptepage = pte_page(entry);
@@ -4806,20 +4819,21 @@ again:
 			 */
 			if (!PageAnon(ptepage)) {
 				page_dup_file_rmap(ptepage, true);
-			} else if (page_try_dup_anon_rmap(ptepage, true, vma)) {
+			} else if (page_try_dup_anon_rmap(ptepage, true,
+							  src_vma)) {
 				pte_t src_pte_old = entry;
 				struct page *new;
 
 				spin_unlock(src_ptl);
 				spin_unlock(dst_ptl);
 				/* Do not use reserve as it's private owned */
-				new = alloc_huge_page(vma, addr, 1);
+				new = alloc_huge_page(dst_vma, addr, 1);
 				if (IS_ERR(new)) {
 					put_page(ptepage);
 					ret = PTR_ERR(new);
 					break;
 				}
-				copy_user_huge_page(new, ptepage, addr, vma,
+				copy_user_huge_page(new, ptepage, addr, dst_vma,
 						    npages);
 				put_page(ptepage);
 
@@ -4829,13 +4843,13 @@ again:
 				spin_lock_nested(src_ptl, SINGLE_DEPTH_NESTING);
 				entry = huge_ptep_get(src_pte);
 				if (!pte_same(src_pte_old, entry)) {
-					restore_reserve_on_error(h, vma, addr,
+					restore_reserve_on_error(h, dst_vma, addr,
 								new);
 					put_page(new);
 					/* dst_entry won't change as in child */
 					goto again;
 				}
-				hugetlb_install_page(vma, dst_pte, addr, new);
+				hugetlb_install_page(dst_vma, dst_pte, addr, new);
 				spin_unlock(src_ptl);
 				spin_unlock(dst_ptl);
 				continue;
--- a/mm/memory.c~mm-hugetlb-handle-uffd-wp-during-fork
+++ a/mm/memory.c
@@ -1278,7 +1278,7 @@ copy_page_range(struct vm_area_struct *d
 		return 0;
 
 	if (is_vm_hugetlb_page(src_vma))
-		return copy_hugetlb_page_range(dst_mm, src_mm, src_vma);
+		return copy_hugetlb_page_range(dst_mm, src_mm, dst_vma, src_vma);
 
 	if (unlikely(src_vma->vm_flags & VM_PFNMAP)) {
 		/*
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-introduce-pte_marker-swap-entry.patch
mm-teach-core-mm-about-pte-markers.patch
mm-check-against-orig_pte-for-finish_fault.patch
mm-uffd-pte_marker_uffd_wp.patch
mm-shmem-take-care-of-uffdio_copy_mode_wp.patch
mm-shmem-handle-uffd-wp-special-pte-in-page-fault-handler.patch
mm-shmem-persist-uffd-wp-bit-across-zapping-for-file-backed.patch
mm-shmem-allow-uffd-wr-protect-none-pte-for-file-backed-mem.patch
mm-shmem-allows-file-back-mem-to-be-uffd-wr-protected-on-thps.patch
mm-shmem-handle-uffd-wp-during-fork.patch
mm-hugetlb-introduce-huge-pte-version-of-uffd-wp-helpers.patch
mm-hugetlb-hook-page-faults-for-uffd-write-protection.patch
mm-hugetlb-take-care-of-uffdio_copy_mode_wp.patch
mm-hugetlb-handle-uffdio_writeprotect.patch
mm-hugetlb-handle-pte-markers-in-page-faults.patch
mm-hugetlb-allow-uffd-wr-protect-none-ptes.patch
mm-hugetlb-only-drop-uffd-wp-special-pte-if-required.patch
mm-hugetlb-handle-uffd-wp-during-fork.patch
mm-khugepaged-dont-recycle-vma-pgtable-if-uffd-wp-registered.patch
mm-pagemap-recognize-uffd-wp-bit-for-shmem-hugetlbfs.patch
mm-uffd-enable-write-protection-for-shmem-hugetlbfs.patch
mm-enable-pte-markers-by-default.patch
selftests-uffd-enable-uffd-wp-for-shmem-hugetlbfs.patch

