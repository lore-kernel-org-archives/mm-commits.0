From: akpm@linux-foundation.org
Subject: + hugetlb-modular-state-for-hugetlb-page-size-cleanup.patch added to -mm tree
Date: Fri, 27 Jun 2008 11:52:19 -0700
Message-ID: <200806271852.m5RIqJId000941@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45611 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754915AbYF0Sxs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Jun 2008 14:53:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@saeurebad.de, agl@us.ibm.com, ak@suse.de, hugh@veritas.com, nacc@us.ibm.com, npiggin@suse.de


The patch titled
     hugetlb-modular-state-for-hugetlb-page-size-cleanup
has been added to the -mm tree.  Its filename is
     hugetlb-modular-state-for-hugetlb-page-size-cleanup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb-modular-state-for-hugetlb-page-size-cleanup
From: Johannes Weiner <hannes@saeurebad.de>

vma_page_offset() has no callees: drop it.

Hugh adds: vma_pagecache_offset() has a dangerously misleading name, since
it's using hugepage units: rename it to vma_hugecache_offset().

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   21 +++++----------------
 1 file changed, 5 insertions(+), 16 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-modular-state-for-hugetlb-page-size-cleanup mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-modular-state-for-hugetlb-page-size-cleanup
+++ a/mm/hugetlb.c
@@ -36,20 +36,9 @@ static DEFINE_SPINLOCK(hugetlb_lock);
 
 /*
  * Convert the address within this vma to the page offset within
- * the mapping, in base page units.
- */
-static pgoff_t vma_page_offset(struct vm_area_struct *vma,
-				unsigned long address)
-{
-	return ((address - vma->vm_start) >> PAGE_SHIFT) +
-					(vma->vm_pgoff >> PAGE_SHIFT);
-}
-
-/*
- * Convert the address within this vma to the page offset within
  * the mapping, in pagecache page units; huge pages here.
  */
-static pgoff_t vma_pagecache_offset(struct hstate *h,
+static pgoff_t vma_hugecache_offset(struct hstate *h,
 			struct vm_area_struct *vma, unsigned long address)
 {
 	return ((address - vma->vm_start) >> huge_page_shift(h)) +
@@ -746,7 +735,7 @@ static int vma_needs_reservation(struct 
 	struct inode *inode = mapping->host;
 
 	if (vma->vm_flags & VM_SHARED) {
-		pgoff_t idx = vma_pagecache_offset(h, vma, addr);
+		pgoff_t idx = vma_hugecache_offset(h, vma, addr);
 		return region_chg(&inode->i_mapping->private_list,
 							idx, idx + 1);
 
@@ -764,7 +753,7 @@ static void vma_commit_reservation(struc
 	struct inode *inode = mapping->host;
 
 	if (vma->vm_flags & VM_SHARED) {
-		pgoff_t idx = vma_pagecache_offset(h, vma, addr);
+		pgoff_t idx = vma_hugecache_offset(h, vma, addr);
 		region_add(&inode->i_mapping->private_list, idx, idx + 1);
 	}
 }
@@ -1387,7 +1376,7 @@ static struct page *hugetlbfs_pagecache_
 	pgoff_t idx;
 
 	mapping = vma->vm_file->f_mapping;
-	idx = vma_pagecache_offset(h, vma, address);
+	idx = vma_hugecache_offset(h, vma, address);
 
 	return find_lock_page(mapping, idx);
 }
@@ -1416,7 +1405,7 @@ static int hugetlb_no_page(struct mm_str
 	}
 
 	mapping = vma->vm_file->f_mapping;
-	idx = vma_pagecache_offset(h, vma, address);
+	idx = vma_hugecache_offset(h, vma, address);
 
 	/*
 	 * Use page lock to guard against racing truncation
_

Patches currently in -mm which might be from hannes@saeurebad.de are

git-xtensa.patch
mm-move-bootmem-descriptors-definition-to-a-single-place.patch
mm-fix-free_all_bootmem_core-alignment-check.patch
mm-normalize-internal-argument-passing-of-bootmem-data.patch
mm-unexport-__alloc_bootmem_core.patch
mm-drop-unneeded-pgdat-argument-from-free_area_init_node.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-fix.patch
huge-page-private-reservation-review-cleanups.patch
huge-page-private-reservation-review-cleanups-fix.patch
mm-record-map_noreserve-status-on-vmas-and-fix-small-page-mprotect-reservations.patch
hugetlb-move-reservation-region-support-earlier.patch
hugetlb-allow-huge-page-mappings-to-be-created-without-reservations.patch
hugetlb-allow-huge-page-mappings-to-be-created-without-reservations-cleanups.patch
hugetlb-modular-state-for-hugetlb-page-size-cleanup.patch
linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
bootmem-reorder-code-to-match-new-bootmem-structure.patch
revert-linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
bootmem-clean-up-bootmemc-file-header.patch
revert-revert-linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
bootmem-add-documentation-to-api-functions.patch
revert-revert-revert-linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
bootmem-add-debugging-framework.patch
bootmem-add-debugging-framework-fix.patch
bootmem-revisit-bitmap-size-calculations.patch
bootmem-revisit-bootmem-descriptor-list-handling.patch
bootmem-clean-up-free_all_bootmem_core.patch
bootmem-clean-up-free_all_bootmem_core-fix.patch
bootmem-clean-up-alloc_bootmem_core.patch
bootmem-free-reserve-helpers.patch
bootmem-free-reserve-helpers-fix.patch
revert-revert-revert-revert-linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
bootmem-factor-out-the-marking-of-a-pfn-range.patch
bootmem-factor-out-the-marking-of-a-pfn-range-fix.patch
bootmem-respect-goal-more-likely.patch
bootmem-make-__alloc_bootmem_low_node-fall-back-to-other-nodes.patch
bootmem-revisit-alloc_bootmem_section.patch
bootmem-replace-node_boot_start-in-struct-bootmem_data.patch

