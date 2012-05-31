From: akpm@linux-foundation.org
Subject: [merged] mm-vmscan-push-lruvec-pointer-into-putback_inactive_pages.patch removed from -mm tree
Date: Thu, 31 May 2012 12:17:27 -0700
Message-ID: <20120531191727.5F3F3A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:45514 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932980Ab2EaTR2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:17:28 -0400
Received: by mail-fa0-f74.google.com with SMTP id a25so75299faa.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:17:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@openvz.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: push lruvec pointer into putback_inactive_pages()
has been removed from the -mm tree.  Its filename was
     mm-vmscan-push-lruvec-pointer-into-putback_inactive_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: mm/vmscan: push lruvec pointer into putback_inactive_pages()

As zone_reclaim_stat is now located in the lruvec, we can reach it
directly.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-push-lruvec-pointer-into-putback_inactive_pages mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-push-lruvec-pointer-into-putback_inactive_pages
+++ a/mm/vmscan.c
@@ -1155,11 +1155,11 @@ static int too_many_isolated(struct zone
 }
 
 static noinline_for_stack void
-putback_inactive_pages(struct mem_cgroup_zone *mz,
+putback_inactive_pages(struct lruvec *lruvec,
 		       struct list_head *page_list)
 {
-	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(mz);
-	struct zone *zone = mz->zone;
+	struct zone_reclaim_stat *reclaim_stat = &lruvec->reclaim_stat;
+	struct zone *zone = lruvec_zone(lruvec);
 	LIST_HEAD(pages_to_free);
 
 	/*
@@ -1278,7 +1278,7 @@ shrink_inactive_list(unsigned long nr_to
 					       nr_reclaimed);
 	}
 
-	putback_inactive_pages(mz, &page_list);
+	putback_inactive_pages(lruvec, &page_list);
 
 	__mod_zone_page_state(zone, NR_ISOLATED_ANON + file, -nr_taken);
 
_

Patches currently in -mm which might be from khlebnikov@openvz.org are

origin.patch
linux-next.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
proc-report-file-anon-bit-in-proc-pid-pagemap.patch
proc-smaps-carefully-handle-migration-entries.patch
proc-smaps-show-amount-of-nonlinear-ptes-in-vma.patch
proc-smaps-show-amount-of-hwpoison-pages.patch
fork-call-complete_vfork_done-after-clearing-child_tid-and-flushing-rss-counters.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-num_exe_file_vmas-removal.patch

