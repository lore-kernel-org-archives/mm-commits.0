From: akpm@linux-foundation.org
Subject: [merged] swsusp-dont-fiddle-with-swappiness.patch removed from -mm tree
Date: Mon, 23 Feb 2009 12:07:12 -0800
Message-ID: <200902232007.n1NK7C3h013475@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51519 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751242AbZBWUU1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Feb 2009 15:20:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, pavel@ucw.cz, riel@redhat.com, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     swsusp: dont fiddle with swappiness
has been removed from the -mm tree.  Its filename was
     swsusp-dont-fiddle-with-swappiness.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: swsusp: dont fiddle with swappiness
From: Johannes Weiner <hannes@cmpxchg.org>

sc.swappiness is not used in the swsusp memory shrinking path, do not
set it.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN mm/vmscan.c~swsusp-dont-fiddle-with-swappiness mm/vmscan.c
--- a/mm/vmscan.c~swsusp-dont-fiddle-with-swappiness
+++ a/mm/vmscan.c
@@ -2111,7 +2111,6 @@ unsigned long shrink_all_memory(unsigned
 		.may_swap = 0,
 		.swap_cluster_max = nr_pages,
 		.may_writepage = 1,
-		.swappiness = vm_swappiness,
 		.isolate_pages = isolate_pages_global,
 	};
 
@@ -2145,10 +2144,8 @@ unsigned long shrink_all_memory(unsigned
 		int prio;
 
 		/* Force reclaiming mapped pages in the passes #3 and #4 */
-		if (pass > 2) {
+		if (pass > 2)
 			sc.may_swap = 1;
-			sc.swappiness = 100;
-		}
 
 		for (prio = DEF_PRIORITY; prio >= 0; prio--) {
 			unsigned long nr_to_scan = nr_pages - ret;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

linux-next.patch
cifs-use-kzfree.patch
md-use-kzfree.patch
s390-use-kzfree.patch
usb-use-kzfree.patch
crypto-use-kzfree.patch
vmscan-rename-scmay_swap-to-may_unmap.patch
mm-introduce-for_each_populated_zone-macro.patch
mm-introduce-for_each_populated_zone-macro-cleanup.patch
mm-shrink_all_memory-use-scnr_reclaimed.patch
mm-shrink_all_memory-use-scnr_reclaimed-checkpatch-fixes.patch
vmscan-clip-swap_cluster_max-in-shrink_all_memory.patch
vmscan-respect-higher-order-in-zone_reclaim.patch
ecryptfs-use-kzfree.patch
memcg-remove-mem_cgroup_calc_mapped_ratio-take2.patch

