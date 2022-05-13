Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BE32C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:21:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383785AbiEMTVi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:21:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383817AbiEMTVJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:21:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E40EB1170
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:21:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7133A6220A
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:21:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C69FDC34100;
        Fri, 13 May 2022 19:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469666;
        bh=HexYGCr7A5N9lZZ/k0SSRLxskvxX2gdLtd7aGE1gj1w=;
        h=Date:To:From:Subject:From;
        b=aKv4ogEnymqMbn5cGBi4wnXoBpzRQB37DHlk8ozOTnT8azPN8ZlV65FBTTBbM7B7Z
         bTbjTwmDDHLcsKPhMLyrolazcdCbVlLDTIZzng7vJfbSfNiv7qUeCag0A56K9Q6H8A
         RgyTwTkgTgGC/tQrwBqeMzcuhrRF8uVaXlAIQKyw=
Date:   Fri, 13 May 2022 12:21:06 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rppt@linux.vnet.ibm.com, nadav.amit@gmail.com,
        mike.kravetz@oracle.com, kirill@shutemov.name, jglisse@redhat.com,
        hughd@google.com, david@redhat.com, axelrasmussen@google.com,
        apopple@nvidia.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-only-drop-uffd-wp-special-pte-if-required.patch removed from -mm tree
Message-Id: <20220513192106.C69FDC34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: only drop uffd-wp special pte if required
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-only-drop-uffd-wp-special-pte-if-required.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/hugetlb: only drop uffd-wp special pte if required

As with shmem uffd-wp special ptes, only drop the uffd-wp special swap pte
if unmapping an entire vma or synchronized such that faults can not race
with the unmap operation.  This requires passing zap_flags all the way to
the lowest level hugetlb unmap routine: __unmap_hugepage_range.

In general, unmap calls originated in hugetlbfs code will pass the
ZAP_FLAG_DROP_MARKER flag as synchronization is in place to prevent
faults.  The exception is hole punch which will first unmap without any
synchronization.  Later when hole punch actually removes the page from the
file, it will check to see if there was a subsequent fault and if so take
the hugetlb fault mutex while unmapping again.  This second unmap will
pass in ZAP_FLAG_DROP_MARKER.

The justification of "whether to apply ZAP_FLAG_DROP_MARKER flag when
unmap a hugetlb range" is (IMHO): we should never reach a state when a
page fault could errornously fault in a page-cache page that was
wr-protected to be writable, even in an extremely short period.  That
could happen if e.g.  we pass ZAP_FLAG_DROP_MARKER when
hugetlbfs_punch_hole() calls hugetlb_vmdelete_list(), because if a page
faults after that call and before remove_inode_hugepages() is executed,
the page cache can be mapped writable again in the small racy window, that
can cause unexpected data overwritten.

[peterx@redhat.com: fix sparse warning]
  Link: https://lkml.kernel.org/r/Ylcdw8I1L5iAoWhb@xz-m1.local
[akpm@linux-foundation.org: move zap_flags_t from mm.h to mm_types.h to fix build issues]
Link: https://lkml.kernel.org/r/20220405014915.14873-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c     |   15 +++++++++------
 include/linux/hugetlb.h  |    8 +++++---
 include/linux/mm.h       |    2 --
 include/linux/mm_types.h |    2 ++
 mm/hugetlb.c             |   33 +++++++++++++++++++++++++--------
 mm/memory.c              |    5 ++++-
 6 files changed, 45 insertions(+), 20 deletions(-)

--- a/fs/hugetlbfs/inode.c~mm-hugetlb-only-drop-uffd-wp-special-pte-if-required
+++ a/fs/hugetlbfs/inode.c
@@ -405,7 +405,8 @@ static void remove_huge_page(struct page
 }
 
 static void
-hugetlb_vmdelete_list(struct rb_root_cached *root, pgoff_t start, pgoff_t end)
+hugetlb_vmdelete_list(struct rb_root_cached *root, pgoff_t start, pgoff_t end,
+		      zap_flags_t zap_flags)
 {
 	struct vm_area_struct *vma;
 
@@ -439,7 +440,7 @@ hugetlb_vmdelete_list(struct rb_root_cac
 		}
 
 		unmap_hugepage_range(vma, vma->vm_start + v_offset, v_end,
-									NULL);
+				     NULL, zap_flags);
 	}
 }
 
@@ -517,7 +518,8 @@ static void remove_inode_hugepages(struc
 				mutex_lock(&hugetlb_fault_mutex_table[hash]);
 				hugetlb_vmdelete_list(&mapping->i_mmap,
 					index * pages_per_huge_page(h),
-					(index + 1) * pages_per_huge_page(h));
+					(index + 1) * pages_per_huge_page(h),
+					ZAP_FLAG_DROP_MARKER);
 				i_mmap_unlock_write(mapping);
 			}
 
@@ -583,7 +585,8 @@ static void hugetlb_vmtruncate(struct in
 	i_mmap_lock_write(mapping);
 	i_size_write(inode, offset);
 	if (!RB_EMPTY_ROOT(&mapping->i_mmap.rb_root))
-		hugetlb_vmdelete_list(&mapping->i_mmap, pgoff, 0);
+		hugetlb_vmdelete_list(&mapping->i_mmap, pgoff, 0,
+				      ZAP_FLAG_DROP_MARKER);
 	i_mmap_unlock_write(mapping);
 	remove_inode_hugepages(inode, offset, LLONG_MAX);
 }
@@ -616,8 +619,8 @@ static long hugetlbfs_punch_hole(struct
 		i_mmap_lock_write(mapping);
 		if (!RB_EMPTY_ROOT(&mapping->i_mmap.rb_root))
 			hugetlb_vmdelete_list(&mapping->i_mmap,
-						hole_start >> PAGE_SHIFT,
-						hole_end  >> PAGE_SHIFT);
+					      hole_start >> PAGE_SHIFT,
+					      hole_end >> PAGE_SHIFT, 0);
 		i_mmap_unlock_write(mapping);
 		remove_inode_hugepages(inode, hole_start, hole_end);
 		inode_unlock(inode);
--- a/include/linux/hugetlb.h~mm-hugetlb-only-drop-uffd-wp-special-pte-if-required
+++ a/include/linux/hugetlb.h
@@ -143,11 +143,12 @@ long follow_hugetlb_page(struct mm_struc
 			 unsigned long *, unsigned long *, long, unsigned int,
 			 int *);
 void unmap_hugepage_range(struct vm_area_struct *,
-			  unsigned long, unsigned long, struct page *);
+			  unsigned long, unsigned long, struct page *,
+			  zap_flags_t);
 void __unmap_hugepage_range_final(struct mmu_gather *tlb,
 			  struct vm_area_struct *vma,
 			  unsigned long start, unsigned long end,
-			  struct page *ref_page);
+			  struct page *ref_page, zap_flags_t zap_flags);
 void hugetlb_report_meminfo(struct seq_file *);
 int hugetlb_report_node_meminfo(char *buf, int len, int nid);
 void hugetlb_show_meminfo(void);
@@ -406,7 +407,8 @@ static inline unsigned long hugetlb_chan
 
 static inline void __unmap_hugepage_range_final(struct mmu_gather *tlb,
 			struct vm_area_struct *vma, unsigned long start,
-			unsigned long end, struct page *ref_page)
+			unsigned long end, struct page *ref_page,
+			zap_flags_t zap_flags)
 {
 	BUG();
 }
--- a/include/linux/mm.h~mm-hugetlb-only-drop-uffd-wp-special-pte-if-required
+++ a/include/linux/mm.h
@@ -3428,8 +3428,6 @@ madvise_set_anon_name(struct mm_struct *
 }
 #endif
 
-typedef unsigned int __bitwise zap_flags_t;
-
 /*
  * Whether to drop the pte markers, for example, the uffd-wp information for
  * file-backed memory.  This should only be specified when we will completely
--- a/include/linux/mm_types.h~mm-hugetlb-only-drop-uffd-wp-special-pte-if-required
+++ a/include/linux/mm_types.h
@@ -863,4 +863,6 @@ enum fault_flag {
 	FAULT_FLAG_ORIG_PTE_VALID =	1 << 11,
 };
 
+typedef unsigned int __bitwise zap_flags_t;
+
 #endif /* _LINUX_MM_TYPES_H */
--- a/mm/hugetlb.c~mm-hugetlb-only-drop-uffd-wp-special-pte-if-required
+++ a/mm/hugetlb.c
@@ -4973,7 +4973,7 @@ int move_hugetlb_page_tables(struct vm_a
 
 static void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 				   unsigned long start, unsigned long end,
-				   struct page *ref_page)
+				   struct page *ref_page, zap_flags_t zap_flags)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long address;
@@ -5029,7 +5029,18 @@ static void __unmap_hugepage_range(struc
 		 * unmapped and its refcount is dropped, so just clear pte here.
 		 */
 		if (unlikely(!pte_present(pte))) {
-			huge_pte_clear(mm, address, ptep, sz);
+			/*
+			 * If the pte was wr-protected by uffd-wp in any of the
+			 * swap forms, meanwhile the caller does not want to
+			 * drop the uffd-wp bit in this zap, then replace the
+			 * pte with a marker.
+			 */
+			if (pte_swp_uffd_wp_any(pte) &&
+			    !(zap_flags & ZAP_FLAG_DROP_MARKER))
+				set_huge_pte_at(mm, address, ptep,
+						make_pte_marker(PTE_MARKER_UFFD_WP));
+			else
+				huge_pte_clear(mm, address, ptep, sz);
 			spin_unlock(ptl);
 			continue;
 		}
@@ -5057,7 +5068,11 @@ static void __unmap_hugepage_range(struc
 		tlb_remove_huge_tlb_entry(h, tlb, ptep, address);
 		if (huge_pte_dirty(pte))
 			set_page_dirty(page);
-
+		/* Leave a uffd-wp pte marker if needed */
+		if (huge_pte_uffd_wp(pte) &&
+		    !(zap_flags & ZAP_FLAG_DROP_MARKER))
+			set_huge_pte_at(mm, address, ptep,
+					make_pte_marker(PTE_MARKER_UFFD_WP));
 		hugetlb_count_sub(pages_per_huge_page(h), mm);
 		page_remove_rmap(page, vma, true);
 
@@ -5091,9 +5106,10 @@ static void __unmap_hugepage_range(struc
 
 void __unmap_hugepage_range_final(struct mmu_gather *tlb,
 			  struct vm_area_struct *vma, unsigned long start,
-			  unsigned long end, struct page *ref_page)
+			  unsigned long end, struct page *ref_page,
+			  zap_flags_t zap_flags)
 {
-	__unmap_hugepage_range(tlb, vma, start, end, ref_page);
+	__unmap_hugepage_range(tlb, vma, start, end, ref_page, zap_flags);
 
 	/*
 	 * Clear this flag so that x86's huge_pmd_share page_table_shareable
@@ -5109,12 +5125,13 @@ void __unmap_hugepage_range_final(struct
 }
 
 void unmap_hugepage_range(struct vm_area_struct *vma, unsigned long start,
-			  unsigned long end, struct page *ref_page)
+			  unsigned long end, struct page *ref_page,
+			  zap_flags_t zap_flags)
 {
 	struct mmu_gather tlb;
 
 	tlb_gather_mmu(&tlb, vma->vm_mm);
-	__unmap_hugepage_range(&tlb, vma, start, end, ref_page);
+	__unmap_hugepage_range(&tlb, vma, start, end, ref_page, zap_flags);
 	tlb_finish_mmu(&tlb);
 }
 
@@ -5169,7 +5186,7 @@ static void unmap_ref_private(struct mm_
 		 */
 		if (!is_vma_resv_set(iter_vma, HPAGE_RESV_OWNER))
 			unmap_hugepage_range(iter_vma, address,
-					     address + huge_page_size(h), page);
+					     address + huge_page_size(h), page, 0);
 	}
 	i_mmap_unlock_write(mapping);
 }
--- a/mm/memory.c~mm-hugetlb-only-drop-uffd-wp-special-pte-if-required
+++ a/mm/memory.c
@@ -1675,8 +1675,11 @@ static void unmap_single_vma(struct mmu_
 			 * safe to do nothing in this case.
 			 */
 			if (vma->vm_file) {
+				zap_flags_t zap_flags = details ?
+				    details->zap_flags : 0;
 				i_mmap_lock_write(vma->vm_file->f_mapping);
-				__unmap_hugepage_range_final(tlb, vma, start, end, NULL);
+				__unmap_hugepage_range_final(tlb, vma, start, end,
+							     NULL, zap_flags);
 				i_mmap_unlock_write(vma->vm_file->f_mapping);
 			}
 		} else
_

Patches currently in -mm which might be from peterx@redhat.com are


