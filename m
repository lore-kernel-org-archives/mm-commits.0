From: akpm@linux-foundation.org
Subject: - mm-kill-page_queue_congested.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:14:53 -0800
Message-ID: <200901072214.n07MEriS014770@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33385 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761795AbZAGWO5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:14:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     mm: kill page_queue_congested()
has been removed from the -mm tree.  Its filename was
     mm-kill-page_queue_congested.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: kill page_queue_congested()
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

page_queue_congested() was introduced in 2002, but it was never used

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   20 --------------------
 1 file changed, 20 deletions(-)

diff -puN mm/swapfile.c~mm-kill-page_queue_congested mm/swapfile.c
--- a/mm/swapfile.c~mm-kill-page_queue_congested
+++ a/mm/swapfile.c
@@ -1372,26 +1372,6 @@ out:
 	return ret;
 }
 
-#if 0	/* We don't need this yet */
-#include <linux/backing-dev.h>
-int page_queue_congested(struct page *page)
-{
-	struct backing_dev_info *bdi;
-
-	VM_BUG_ON(!PageLocked(page));	/* It pins the swap_info_struct */
-
-	if (PageSwapCache(page)) {
-		swp_entry_t entry = { .val = page_private(page) };
-		struct swap_info_struct *sis;
-
-		sis = get_swap_info_struct(swp_type(entry));
-		bdi = sis->bdev->bd_inode->i_mapping->backing_dev_info;
-	} else
-		bdi = page->mapping->backing_dev_info;
-	return bdi_write_congested(bdi);
-}
-#endif
-
 asmlinkage long sys_swapoff(const char __user * specialfile)
 {
 	struct swap_info_struct * p = NULL;
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
getrusage-fill-ru_maxrss-value.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
devices-cgroup-allow-mkfifo.patch
memcg-new-force_empty-to-free-pages-under-group-fix.patch
memcg-new-force_empty-to-free-pages-under-group-fix-fix.patch
memcg-revert-gfp-mask-fix.patch
memcg-check-group-leader-fix.patch
memcg-memoryswap-controller-fix-limit-check.patch
memcg-swapout-refcnt-fix.patch
memcg-hierarchy-avoid-unnecessary-reclaim.patch
inactive_anon_is_low-move-to-vmscan.patch
mm-introduce-zone_reclaim-struct.patch
mm-add-zone-nr_pages-helper-function.patch
mm-make-get_scan_ratio-safe-for-memcg.patch
memcg-add-null-check-to-page_cgroup_zoneinfo.patch
memcg-add-inactive_anon_is_low.patch
memcg-add-inactive_anon_is_low-vmscan-style-cleanup.patch
memcg-add-mem_cgroup_zone_nr_pages.patch
memcg-add-zone_reclaim_stat.patch
memcg-add-zone_reclaim_stat-reclaim-stat-trivial-fixes.patch
memcg-add-zone_reclaim_stat-reclaim-stat-trivial-fixes-fix.patch
memcg-remove-mem_cgroup_cal_reclaim.patch
memcg-show-reclaim-stat.patch
memcg-rename-scan-global-lru.patch
memcg-protect-prev_priority.patch
memcg-swappiness.patch
memcg-fix-calclation-of-active_ratio.patch
memcg-fix-calclation-of-active_ratio-build-error-fix.patch
memcg-show-real-limit-under-hierarchy-mode.patch
memcg-explain-details-and-test-document.patch
ia64-implement-interrupt-enabling-rwlocks-fix.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

