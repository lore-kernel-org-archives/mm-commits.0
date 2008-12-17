From: akpm@linux-foundation.org
Subject: + mm-kill-page_queue_congested.patch added to -mm tree
Date: Wed, 17 Dec 2008 14:57:55 -0800
Message-ID: <200812172257.mBHMvtXZ029798@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44285 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752154AbYLQW63 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Dec 2008 17:58:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, peterz@infradead.org


The patch titled
     mm: kill page_queue_congested()
has been added to the -mm tree.  Its filename is
     mm-kill-page_queue_congested.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
linux-next.patch
proc-enclose-desc-variable-of-show_stat-in-config_sparse_irq.patch
mm-report-the-pagesize-backing-a-vma-in-proc-pid-smaps.patch
mm-report-the-mmu-pagesize-in-proc-pid-smaps.patch
oom-fix-zone_scan_mutex-name.patch
mm-get-rid-of-pagevec_release_nonlru.patch
cleanup-get-rid-of-ifdef-config_migration.patch
mm-more-likely-reclaim-madv_sequential-mappings.patch
mm-make-page_lock_anon_vma-static.patch
memcg-reclaim-shouldnt-change-zone-recent_rotated-statistics.patch
mm-make-init_section_page_cgroup-static.patch
mm-make-maddr-__iomem.patch
mm-make-mem_cgroup_resize_limit-static.patch
mm-make-scan_all_zones_unevictable_pages-static.patch
mm-make-scan_zone_unevictable_pages-static.patch
mm-make-setup_per_zone_inactive_ratio-static.patch
mm-make-vread-and-vwrite-declaration.patch
vmscan-bail-out-of-direct-reclaim-after-swap_cluster_max-pages.patch
vmscan-improve-reclaim-throughput-to-bail-out-patch.patch
mm-kill-zone_is_near_oom.patch
mm-make-get_user_pages-interruptible.patch
mm-make-get_user_pages-interruptible-mmotm-ignore-sigkill-in-get_user_pages-during-munlock.patch
introduce-get_mm_hiwater_xxx-fix-taskstats-hiwater_xxx-accounting.patch
mm-remove-config_out_of_line_pfn_to_page.patch
mm-kill-page_queue_congested.patch
remove-linux-hardirqh-from-asm-generic-localh-add-include-linux-irqflagsh-to-acpi-processor_idlec.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
irq-remove-unnecessary-ifdef.patch
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

