From: akpm@linux-foundation.org
Subject: + vma-page-offset-has-no-callees-drop-it.patch added to -mm tree
Date: Thu, 03 Jul 2008 15:25:16 -0700
Message-ID: <200807032225.m63MPGXu030482@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45729 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754392AbYGCWZ5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Jul 2008 18:25:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@saeurebad.de, agl@us.ibm.com, ak@suse.de, apw@shadowen.org, hugh@veritas.com, nacc@us.ibm.com, npiggin@suse.de


The patch titled
     vma_page_offset() has no callees: drop it
has been added to the -mm tree.  Its filename is
     vma-page-offset-has-no-callees-drop-it.patch

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
Subject: vma_page_offset() has no callees: drop it
From: Johannes Weiner <hannes@saeurebad.de>

Hugh adds: vma_pagecache_offset() has a dangerously misleading name, since
it's using hugepage units: rename it to vma_hugecache_offset().

[apw@shadowen.org: restack onto fixed MAP_PRIVATE reservations]
[akpm@linux-foundation.org: vma_split conversion]
Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   29 +++++++++--------------------
 1 file changed, 9 insertions(+), 20 deletions(-)

diff -puN mm/hugetlb.c~vma-page-offset-has-no-callees-drop-it mm/hugetlb.c
--- a/mm/hugetlb.c~vma-page-offset-has-no-callees-drop-it
+++ a/mm/hugetlb.c
@@ -201,20 +201,9 @@ static long region_count(struct list_hea
 
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
-static pgoff_t vma_pagecache_offset(struct vm_area_struct *vma,
+static pgoff_t vma_hugecache_offset(struct vm_area_struct *vma,
 					unsigned long address)
 {
 	return ((address - vma->vm_start) >> HPAGE_SHIFT) +
@@ -806,7 +795,7 @@ static int vma_needs_reservation(struct 
 	struct inode *inode = mapping->host;
 
 	if (vma->vm_flags & VM_SHARED) {
-		pgoff_t idx = vma_pagecache_offset(vma, addr);
+		pgoff_t idx = vma_hugecache_offset(vma, addr);
 		return region_chg(&inode->i_mapping->private_list,
 							idx, idx + 1);
 
@@ -815,7 +804,7 @@ static int vma_needs_reservation(struct 
 
 	} else  {
 		int err;
-		pgoff_t idx = vma_pagecache_offset(vma, addr);
+		pgoff_t idx = vma_hugecache_offset(vma, addr);
 		struct resv_map *reservations = vma_resv_map(vma);
 
 		err = region_chg(&reservations->regions, idx, idx + 1);
@@ -831,11 +820,11 @@ static void vma_commit_reservation(struc
 	struct inode *inode = mapping->host;
 
 	if (vma->vm_flags & VM_SHARED) {
-		pgoff_t idx = vma_pagecache_offset(vma, addr);
+		pgoff_t idx = vma_hugecache_offset(vma, addr);
 		region_add(&inode->i_mapping->private_list, idx, idx + 1);
 
 	} else if (is_vma_resv_set(vma, HPAGE_RESV_OWNER)) {
-		pgoff_t idx = vma_pagecache_offset(vma, addr);
+		pgoff_t idx = vma_hugecache_offset(vma, addr);
 		struct resv_map *reservations = vma_resv_map(vma);
 
 		/* Mark this page used in the map. */
@@ -1153,8 +1142,8 @@ static void hugetlb_vm_op_close(struct v
 	unsigned long end;
 
 	if (reservations) {
-		start = vma_pagecache_offset(vma, vma->vm_start);
-		end = vma_pagecache_offset(vma, vma->vm_end);
+		start = vma_hugecache_offset(vma, vma->vm_start);
+		end = vma_hugecache_offset(vma, vma->vm_end);
 
 		reserve = (end - start) -
 			region_count(&reservations->regions, start, end);
@@ -1470,7 +1459,7 @@ static struct page *hugetlbfs_pagecache_
 	pgoff_t idx;
 
 	mapping = vma->vm_file->f_mapping;
-	idx = vma_pagecache_offset(vma, address);
+	idx = vma_hugecache_offset(vma, address);
 
 	return find_lock_page(mapping, idx);
 }
@@ -1498,7 +1487,7 @@ static int hugetlb_no_page(struct mm_str
 	}
 
 	mapping = vma->vm_file->f_mapping;
-	idx = vma_pagecache_offset(vma, address);
+	idx = vma_hugecache_offset(vma, address);
 
 	/*
 	 * Use page lock to guard against racing truncation
_

Patches currently in -mm which might be from hannes@saeurebad.de are

linux-next.patch
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
hugetlb-reservations-fix-hugetlb-map_private-reservations-across-vma-splits-v2.patch
vma-page-offset-has-no-callees-drop-it.patch
hugetlb-fix-race-when-reading-proc-meminfo.patch
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
bootmem-clean-up-alloc_bootmem_core-fix-new-alloc_bootmem_core.patch
bootmem-free-reserve-helpers.patch
bootmem-free-reserve-helpers-fix.patch
revert-revert-revert-revert-linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
bootmem-factor-out-the-marking-of-a-pfn-range.patch
bootmem-factor-out-the-marking-of-a-pfn-range-fix.patch
bootmem-respect-goal-more-likely.patch
bootmem-make-__alloc_bootmem_low_node-fall-back-to-other-nodes.patch
bootmem-revisit-alloc_bootmem_section.patch
bootmem-replace-node_boot_start-in-struct-bootmem_data.patch
memory-hotplug-small-fixes-to-bootmem-freeing-for-memory-hotremove.patch

