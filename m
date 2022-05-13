Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66481C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:21:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356231AbiEMTVk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:21:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383832AbiEMTVM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:21:12 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D639E71
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:21:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8395ECE330B
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:21:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E428DC34100;
        Fri, 13 May 2022 19:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469668;
        bh=HXM/jjwGA8gIRnZeRa9vt0pBcjXIsq07oyr1H8rTpZQ=;
        h=Date:To:From:Subject:From;
        b=IvkHWBmnRKFUulpYZ5fcp/yJAtSIKrZ/i3JZbqIBoC/VZZB3JDDr8dM0d0A8PjZlC
         /VjgEJ2xwOre0INw+UAwaTwqj9qt1fQ7/sGDmdaNUBsGidXuRA2MyxDpWISuQU9ZmA
         A+e+VJDpIgnmaPTusmncqO4HSzp48/QA4ZBJv8vw=
Date:   Fri, 13 May 2022 12:21:07 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rppt@linux.vnet.ibm.com, nadav.amit@gmail.com,
        mike.kravetz@oracle.com, kirill@shutemov.name, jglisse@redhat.com,
        hughd@google.com, david@redhat.com, axelrasmussen@google.com,
        apopple@nvidia.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-handle-uffd-wp-during-fork.patch removed from -mm tree
Message-Id: <20220513192107.E428DC34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: handle uffd-wp during fork()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-handle-uffd-wp-during-fork.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/hugetlb: handle uffd-wp during fork()

Firstly, we'll need to pass in dst_vma into copy_hugetlb_page_range()
because for uffd-wp it's the dst vma that matters on deciding how we
should treat uffd-wp protected ptes.

We should recognize pte markers during fork and do the pte copy if needed.

[lkp@intel.com: vma_needs_copy can be static]
  Link: https://lkml.kernel.org/r/Ylb0CGeFJlc4EzLk@7ec4ff11d4ae
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
 mm/memory.c             |    4 +--
 3 files changed, 35 insertions(+), 18 deletions(-)

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
@@ -4719,23 +4719,24 @@ hugetlb_install_page(struct vm_area_stru
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
@@ -4749,12 +4750,12 @@ int copy_hugetlb_page_range(struct mm_st
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
@@ -4789,6 +4790,7 @@ again:
 		} else if (unlikely(is_hugetlb_entry_migration(entry) ||
 				    is_hugetlb_entry_hwpoisoned(entry))) {
 			swp_entry_t swp_entry = pte_to_swp_entry(entry);
+			bool uffd_wp = huge_pte_uffd_wp(entry);
 
 			if (!is_readable_migration_entry(swp_entry) && cow) {
 				/*
@@ -4798,10 +4800,21 @@ again:
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
@@ -4819,20 +4832,21 @@ again:
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
 
@@ -4842,13 +4856,13 @@ again:
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
@@ -1234,7 +1234,7 @@ copy_p4d_range(struct vm_area_struct *ds
  * false when we can speed up fork() by allowing lazy page faults later until
  * when the child accesses the memory range.
  */
-bool
+static bool
 vma_needs_copy(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma)
 {
 	/*
@@ -1278,7 +1278,7 @@ copy_page_range(struct vm_area_struct *d
 		return 0;
 
 	if (is_vm_hugetlb_page(src_vma))
-		return copy_hugetlb_page_range(dst_mm, src_mm, src_vma);
+		return copy_hugetlb_page_range(dst_mm, src_mm, dst_vma, src_vma);
 
 	if (unlikely(src_vma->vm_flags & VM_PFNMAP)) {
 		/*
_

Patches currently in -mm which might be from peterx@redhat.com are


