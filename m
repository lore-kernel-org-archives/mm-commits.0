From: akpm@linux-foundation.org
Subject: + mm-kill-zone_is_near_oom.patch added to -mm tree
Date: Tue, 02 Dec 2008 15:49:28 -0800
Message-ID: <200812022349.mB2NnSqb018852@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37870 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753207AbYLBXuE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Dec 2008 18:50:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com


The patch titled
     mm: kill zone_is_near_oom()
has been added to the -mm tree.  Its filename is
     mm-kill-zone_is_near_oom.patch

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
Subject: mm: kill zone_is_near_oom()
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

zone_is_near_oom() is unused.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN mm/vmscan.c~mm-kill-zone_is_near_oom mm/vmscan.c
--- a/mm/vmscan.c~mm-kill-zone_is_near_oom
+++ a/mm/vmscan.c
@@ -1214,11 +1214,6 @@ static inline void note_zone_scanning_pr
 		zone->prev_priority = priority;
 }
 
-static inline int zone_is_near_oom(struct zone *zone)
-{
-	return zone->pages_scanned >= (zone_lru_pages(zone) * 3);
-}
-
 /*
  * This moves pages from the active list to the inactive list.
  *
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

vmscan-evict-streaming-io-first.patch
linux-next.patch
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
mm-kill-zone_is_near_oom.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
memcg-new-force_empty-to-free-pages-under-group-fix.patch
memcg-new-force_empty-to-free-pages-under-group-fix-fix.patch

