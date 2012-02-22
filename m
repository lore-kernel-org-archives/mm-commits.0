From: akpm@linux-foundation.org
Subject: [withdrawn] mm-hugetlb-break-cow-earlier-for-resv-owner.patch removed from -mm tree
Date: Wed, 22 Feb 2012 11:35:44 -0800
Message-ID: <20120222193545.E5334A0128@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qw0-f74.google.com ([209.85.216.74]:47908 "EHLO
	mail-qw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab2BVTlh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2012 14:41:37 -0500
Received: by qadb12 with SMTP id b12so66965qad.1
        for <mm-commits@vger.kernel.org>; Wed, 22 Feb 2012 11:41:37 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhillf@gmail.com, gerald.schaefer@de.ibm.com, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: break COW earlier for resv owner
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-break-cow-earlier-for-resv-owner.patch

This patch was dropped because it was withdrawn

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Hillf Danton <dhillf@gmail.com>
Subject: mm: hugetlb: break COW earlier for resv owner

When a process owning a MAP_PRIVATE mapping fails to COW, due to
references held by a child and insufficient huge page pool, page is
unmapped from the child process to guarantee the original mappers
reliability, and the child may get SIGKILLed if it later faults.

With that guarantee, COW is broken earlier on behalf of owners, and they
will go less page faults.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-break-cow-earlier-for-resv-owner mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-break-cow-earlier-for-resv-owner
+++ a/mm/hugetlb.c
@@ -2149,10 +2149,12 @@ int copy_hugetlb_page_range(struct mm_st
 	struct page *ptepage;
 	unsigned long addr;
 	int cow;
+	int owner;
 	struct hstate *h = hstate_vma(vma);
 	unsigned long sz = huge_page_size(h);
 
 	cow = (vma->vm_flags & (VM_SHARED | VM_MAYWRITE)) == VM_MAYWRITE;
+	owner = is_vma_resv_set(vma, HPAGE_RESV_OWNER);
 
 	for (addr = vma->vm_start; addr < vma->vm_end; addr += sz) {
 		src_pte = huge_pte_offset(src, addr);
@@ -2168,10 +2170,19 @@ int copy_hugetlb_page_range(struct mm_st
 
 		spin_lock(&dst->page_table_lock);
 		spin_lock_nested(&src->page_table_lock, SINGLE_DEPTH_NESTING);
-		if (!huge_pte_none(huge_ptep_get(src_pte))) {
+		entry = huge_ptep_get(src_pte);
+		if (!huge_pte_none(entry)) {
 			if (cow)
-				huge_ptep_set_wrprotect(src, addr, src_pte);
-			entry = huge_ptep_get(src_pte);
+				if (owner) {
+					/*
+					 * Break COW for resv owner to go less
+					 * page faults later
+					 */
+					entry = huge_pte_wrprotect(entry);
+				} else {
+					huge_ptep_set_wrprotect(src, addr, src_pte);
+					entry = huge_ptep_get(src_pte);
+				}
 			ptepage = pte_page(entry);
 			get_page(ptepage);
 			page_dup_rmap(ptepage);
_

Patches currently in -mm which might be from dhillf@gmail.com are

mm-vmscanc-cleanup-with-s-reclaim_mode-isolate_mode.patch
mm-vmscan-fix-misused-nr_reclaimed-in-shrink_mem_cgroup_zone.patch
vmscan-reclaim-at-order-0-when-compaction-is-enabled.patch
vmscan-kswapd-carefully-call-compaction.patch
vmscan-kswapd-carefully-call-compaction-fix.patch
vmscan-only-defer-compaction-for-failed-order-and-higher.patch
hugetlbfs-fix-hugetlb_get_unmapped_area.patch
hugetlb-drop-prev_vma-in-hugetlb_get_unmapped_area_topdown.patch
hugetlb-try-to-search-again-if-it-is-really-needed.patch
hugetlb-try-to-search-again-if-it-is-really-needed-fix.patch
mm-do-not-reset-cached_hole_size-when-vma-is-unmapped.patch
mm-search-from-free_area_cache-for-the-bigger-size.patch
mm-hugetlb-defer-freeing-pages-when-gathering-surplus-pages.patch
mm-vmscan-handle-isolated-pages-with-lru-lock-released.patch

