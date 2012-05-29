From: akpm@linux-foundation.org
Subject: [folded] mm-do_migrate_pages-calls-migrate_to_node-even-if-task-is-already-on-a-correct-node-fix.patch removed from -mm tree
Date: Tue, 29 May 2012 14:41:49 -0700
Message-ID: <20120529214149.6F71BA021B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:39029 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824Ab2E2Vlv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 May 2012 17:41:51 -0400
Received: by were53 with SMTP id e53so266045wer.1
        for <mm-commits@vger.kernel.org>; Tue, 29 May 2012 14:41:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com, lwoodman@redhat.com, mel@csn.ul.ie, mkosaki@redhat.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-do_migrate_pages-calls-migrate_to_node-even-if-task-is-already-on-a-correct-node-fix
has been removed from the -mm tree.  Its filename was
     mm-do_migrate_pages-calls-migrate_to_node-even-if-task-is-already-on-a-correct-node-fix.patch

This patch was dropped because it was folded into mm-do_migrate_pages-calls-migrate_to_node-even-if-task-is-already-on-a-correct-node.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-do_migrate_pages-calls-migrate_to_node-even-if-task-is-already-on-a-correct-node-fix

clean up comment layout

Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <mkosaki@redhat.com>
Cc: Larry Woodman <lwoodman@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN mm/mempolicy.c~mm-do_migrate_pages-calls-migrate_to_node-even-if-task-is-already-on-a-correct-node-fix mm/mempolicy.c
--- a/mm/mempolicy.c~mm-do_migrate_pages-calls-migrate_to_node-even-if-task-is-already-on-a-correct-node-fix
+++ a/mm/mempolicy.c
@@ -1014,18 +1014,18 @@ int do_migrate_pages(struct mm_struct *m
 		for_each_node_mask(s, tmp) {
 
 			/*
-			 * do_migrate_pages() tries to maintain the
-			 * relative node relationship of the pages
-			 * established between threads and memory areas.
+			 * do_migrate_pages() tries to maintain the relative
+			 * node relationship of the pages established between
+			 * threads and memory areas.
                          *
-			 * However if the number of source nodes is not
-			 * equal to the number of destination nodes we
-			 * can not preserve this node relative relationship.
-			 * In that case, skip copying memory from a node that
-			 * is in the destination mask.
+			 * However if the number of source nodes is not equal to
+			 * the number of destination nodes we can not preserve
+			 * this node relative relationship.  In that case, skip
+			 * copying memory from a node that is in the destination
+			 * mask.
 			 *
 			 * Example: [2,3,4] -> [3,4,5] moves everything.
-			 *                 [0-7] - > [3,4,5] moves only 0,1,2,6,7.
+			 *          [0-7] - > [3,4,5] moves only 0,1,2,6,7.
 			 */
 
 			if ((nodes_weight(*from_nodes) != nodes_weight(*to_nodes)) &&
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-mmapc-find_vma-remove-unnecessary-ifmm-check.patch
mm-do_migrate_pages-calls-migrate_to_node-even-if-task-is-already-on-a-correct-node.patch
mm-do_migrate_pages-rename-arguments.patch
mm-memcg-count-pte-references-from-every-member-of-the-reclaimed-hierarchy-fix.patch
mm-rename-is_mlocked_vma-to-mlocked_vma_newpage-fix.patch
mm-page_allocc-remove-pageblock_default_order.patch
mm-remove-sparsemem-allocation-details-from-the-bootmem-allocator-fix.patch
tmpfs-support-seek_data-and-seek_hole-fix.patch
mm-page_allocc-cleanups.patch
mm-fix-slab-page-flags-corruption-fix.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
mm-memcg-use-vm_swappiness-from-target-memory-cgroup-fix.patch
mm-memcg-print-statistics-from-live-counters-checkpatch-fixes.patch
memcg-always-free-struct-memcg-through-schedule_work-fix.patch
memcg-decrement-static-keys-at-real-destroy-time-v6-fix.patch
drivers-video-backlight-apple_blc-include-header-for-exported-symbol-prototypes-fix.patch
backlight-add-lm3533-backlight-driver-fix.patch
backlight-add-lm3533-backlight-driver-fix-fix.patch
backlight-use-pr_warn-and-pr_debug-instead-of-printk-fix.patch
backlight-apple_bl-use-pr_debug-pr_err-instead-of-printk-fix.patch
backlight-cr_bllcd-use-pr_err-pr_info-instead-of-printk-fix.patch
backlight-generic_bl-use-pr_info-instead-of-printk-fix.patch
backlight-jornada720-use-pr_err-pr_info-instead-of-printk-fix.patch
backlight-omap1-use-pr_info-instead-of-printk-fix.patch
backlight-progear-use-pr_err-instead-of-printk-fix.patch
leds-led-module-for-da9052-53-pmic-v2-fix.patch
leds-heartbeat-stop-on-shutdown-checkpatch-fixes.patch
drivers-leds-leds-pca955xc-fix-race-condition-while-setting-brightness-on-several-leds-fix.patch
lib-string_helpersc-make-arrays-static.patch
lib-bitmapc-fix-documentation-for-scnprintf-functions.patch
drivers-rtc-rtc-pcf8563c-add-rtc_vl_read-rtc_vl_clr-ioctl-feature-fix.patch
rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc-fix.patch

