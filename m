Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB2E6C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 02:55:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376581AbiEMCzM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 May 2022 22:55:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376573AbiEMCzL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 12 May 2022 22:55:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AAEA27EBBB
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 19:55:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C8B1B82BCC
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 02:55:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00521C385B8;
        Fri, 13 May 2022 02:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652410508;
        bh=7qthQTP1oW5zOj0mmqjiMnLc0Io4ONq1ek17/9I1XrY=;
        h=Date:To:From:Subject:From;
        b=1k4QIaELb6EgLDGKk36Sa+R74IGOw1XhDjMBnsxlACAlUSdvlGP6hwjEd+zNZUJzV
         m0B5ErsTWMZsS7FJTCXtaTNbY4B7YwmYb1APtU6Jw3cWXc/RmOmrKL+x/oW/OVm2A2
         Yhzs/CL7XOTSPIeEJPQr5NqT/DRYaaiAbvgJoQfo=
Date:   Thu, 12 May 2022 19:55:07 -0700
To:     mm-commits@vger.kernel.org, lkp@intel.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-hugetlb-only-drop-uffd-wp-special-pte-if-required-fix.patch removed from -mm tree
Message-Id: <20220513025508.00521C385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fixup! mm/hugetlb: Only drop uffd-wp special pte if required
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-only-drop-uffd-wp-special-pte-if-required-fix.patch

This patch was dropped because it was folded into mm-hugetlb-only-drop-uffd-wp-special-pte-if-required.patch

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: fixup! mm/hugetlb: Only drop uffd-wp special pte if required

fix sparse warning

Link: https://lkml.kernel.org/r/Ylcdw8I1L5iAoWhb@xz-m1.local
Signed-off-by: Peter Xu <peterx@redhat.com>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c    |    2 +-
 include/linux/hugetlb.h |    6 +++---
 mm/hugetlb.c            |    6 +++---
 mm/memory.c             |    2 +-
 4 files changed, 8 insertions(+), 8 deletions(-)

--- a/fs/hugetlbfs/inode.c~mm-hugetlb-only-drop-uffd-wp-special-pte-if-required-fix
+++ a/fs/hugetlbfs/inode.c
@@ -406,7 +406,7 @@ static void remove_huge_page(struct page
 
 static void
 hugetlb_vmdelete_list(struct rb_root_cached *root, pgoff_t start, pgoff_t end,
-		      unsigned long zap_flags)
+		      zap_flags_t zap_flags)
 {
 	struct vm_area_struct *vma;
 
--- a/include/linux/hugetlb.h~mm-hugetlb-only-drop-uffd-wp-special-pte-if-required-fix
+++ a/include/linux/hugetlb.h
@@ -144,11 +144,11 @@ long follow_hugetlb_page(struct mm_struc
 			 int *);
 void unmap_hugepage_range(struct vm_area_struct *,
 			  unsigned long, unsigned long, struct page *,
-			  unsigned long);
+			  zap_flags_t);
 void __unmap_hugepage_range_final(struct mmu_gather *tlb,
 			  struct vm_area_struct *vma,
 			  unsigned long start, unsigned long end,
-			  struct page *ref_page, unsigned long zap_flags);
+			  struct page *ref_page, zap_flags_t zap_flags);
 void hugetlb_report_meminfo(struct seq_file *);
 int hugetlb_report_node_meminfo(char *buf, int len, int nid);
 void hugetlb_show_meminfo(void);
@@ -408,7 +408,7 @@ static inline unsigned long hugetlb_chan
 static inline void __unmap_hugepage_range_final(struct mmu_gather *tlb,
 			struct vm_area_struct *vma, unsigned long start,
 			unsigned long end, struct page *ref_page,
-			unsigned long zap_flags)
+			zap_flags_t zap_flags)
 {
 	BUG();
 }
--- a/mm/hugetlb.c~mm-hugetlb-only-drop-uffd-wp-special-pte-if-required-fix
+++ a/mm/hugetlb.c
@@ -4973,7 +4973,7 @@ int move_hugetlb_page_tables(struct vm_a
 
 static void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 				   unsigned long start, unsigned long end,
-				   struct page *ref_page, unsigned long zap_flags)
+				   struct page *ref_page, zap_flags_t zap_flags)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long address;
@@ -5107,7 +5107,7 @@ static void __unmap_hugepage_range(struc
 void __unmap_hugepage_range_final(struct mmu_gather *tlb,
 			  struct vm_area_struct *vma, unsigned long start,
 			  unsigned long end, struct page *ref_page,
-			  unsigned long zap_flags)
+			  zap_flags_t zap_flags)
 {
 	__unmap_hugepage_range(tlb, vma, start, end, ref_page, zap_flags);
 
@@ -5126,7 +5126,7 @@ void __unmap_hugepage_range_final(struct
 
 void unmap_hugepage_range(struct vm_area_struct *vma, unsigned long start,
 			  unsigned long end, struct page *ref_page,
-			  unsigned long zap_flags)
+			  zap_flags_t zap_flags)
 {
 	struct mmu_gather tlb;
 
--- a/mm/memory.c~mm-hugetlb-only-drop-uffd-wp-special-pte-if-required-fix
+++ a/mm/memory.c
@@ -1675,7 +1675,7 @@ static void unmap_single_vma(struct mmu_
 			 * safe to do nothing in this case.
 			 */
 			if (vma->vm_file) {
-				unsigned long zap_flags = details ?
+				zap_flags_t zap_flags = details ?
 				    details->zap_flags : 0;
 				i_mmap_lock_write(vma->vm_file->f_mapping);
 				__unmap_hugepage_range_final(tlb, vma, start, end,
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-introduce-pte_marker-swap-entry.patch
mm-teach-core-mm-about-pte-markers.patch
mm-check-against-orig_pte-for-finish_fault.patch
mm-uffd-pte_marker_uffd_wp.patch
mm-uffd-pte_marker_uffd_wp-fix.patch
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
mm-enable-pte-markers-by-default-fix.patch
selftests-uffd-enable-uffd-wp-for-shmem-hugetlbfs.patch
mm-uffd-move-userfaultfd-configs-into-mm.patch

