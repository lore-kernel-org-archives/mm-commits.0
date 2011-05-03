From: akpm@linux-foundation.org
Subject: + mm-filter-unevictable-page-out-in-deactivate_page.patch added to -mm tree
Date: Tue, 03 May 2011 14:33:49 -0700
Message-ID: <201105032133.p43LXnbM011614@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39869 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755133Ab1ECVd4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 May 2011 17:33:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan.kim@gmail.com, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com


The patch titled
     mm: filter unevictable page out in deactivate_page()
has been added to the -mm tree.  Its filename is
     mm-filter-unevictable-page-out-in-deactivate_page.patch

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
Subject: mm: filter unevictable page out in deactivate_page()
From: Minchan Kim <minchan.kim@gmail.com>

It's pointless that deactive_page's operates on unevictable pages.  This
patch removes unnecessary overhead which might be a bit problem in case
that there are many unevictable page in system(ex, mprotect workload)

Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: Rik van Riel<riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN mm/swap.c~mm-filter-unevictable-page-out-in-deactivate_page mm/swap.c
--- a/mm/swap.c~mm-filter-unevictable-page-out-in-deactivate_page
+++ a/mm/swap.c
@@ -476,6 +476,15 @@ static void drain_cpu_pagevecs(int cpu)
  */
 void deactivate_page(struct page *page)
 {
+
+	/*
+	 * In workload which system has many unevictable page(ex, mprotect),
+	 * unevictable page deactivation for accelerating reclaim
+	 * is pointless.
+	 */
+	if (PageUnevictable(page))
+		return;
+
 	if (likely(get_page_unless_zero(page))) {
 		struct pagevec *pvec = &get_cpu_var(lru_deactivate_pvecs);
 
_

Patches currently in -mm which might be from minchan.kim@gmail.com are

origin.patch
mm-check-pageunevictable-in-lru_deactivate_fn.patch
linux-next.patch
mm-introduce-wait_on_page_locked_killable.patch
x86mm-make-pagefault-killable.patch
mm-mem-hotplug-fix-section-mismatch-setup_per_zone_inactive_ratio-should-be-__meminit.patch
mm-mem-hotplug-recalculate-lowmem_reserve-when-memory-hotplug-occur.patch
oom-replace-pf_oom_origin-with-toggling-oom_score_adj.patch
oom-replace-pf_oom_origin-with-toggling-oom_score_adj-update.patch
mm-thp-optimize-memcg-charge-in-khugepaged.patch
readahead-readahead-page-allocations-are-ok-to-fail.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control-fix.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control-fix-2.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-2.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix-fix.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix-fix-fix.patch
writeback-elevate-queue_io-into-wb_writeback.patch
mm-filter-unevictable-page-out-in-deactivate_page.patch
mm-filter-unevictable-page-out-in-deactivate_page-fix.patch
mm-batch-activate_page-to-reduce-lock-contention.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
memcg-count-the-soft_limit-reclaim-in-global-background-reclaim.patch
memcg-add-stats-to-monitor-soft_limit-reclaim.patch
add-the-pagefault-count-into-memcg-stats.patch
add-the-pagefault-count-into-memcg-stats-fix.patch

