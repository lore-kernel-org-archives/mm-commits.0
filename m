From: akpm@osdl.org
Subject: - vmscanc-account-for-memory-already-freed-in-seeking-to.patch removed from -mm tree
Date: Mon, 18 Dec 2006 15:17:27 -0800
Message-ID: <200612182317.kBINHRZ3015620@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57001 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754753AbWLRXRo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Dec 2006 18:17:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nigel@suspend2.net, pavel@ucw.cz, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     vmscan.c: account for memory already freed in seeking to free more
has been removed from the -mm tree.  Its filename was
     vmscanc-account-for-memory-already-freed-in-seeking-to.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: vmscan.c: account for memory already freed in seeking to free more
From: Nigel Cunningham <nigel@suspend2.net>

The current versions of shrink_all_zones and shrink_all_memory don't take
account of memory already freed when making multiple calls to seek to free
memory.  As a result, we can end up freeing far more memory than was asked
for.  This can in turn result in more (unnecessary) paging if/when the data
is later needed.

These modifications seek to alleviate this situation by modifying
swap_cluster_max by the number of pages freed by shrink_inactive_list in
shrink_all_zones before proceeding to the next zone, and in
shrink_all_memory before shrinking slab and going to the next priority.

Signed-off-by: Nigel Cunningham <nigel@suspend2.net>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/vmscan.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff -puN mm/vmscan.c~vmscanc-account-for-memory-already-freed-in-seeking-to mm/vmscan.c
--- a/mm/vmscan.c~vmscanc-account-for-memory-already-freed-in-seeking-to
+++ a/mm/vmscan.c
@@ -1473,9 +1473,12 @@ static unsigned long shrink_all_zones(un
 
 		zone->nr_scan_inactive += (zone->nr_inactive >> prio) + 1;
 		if (zone->nr_scan_inactive >= nr_pages || pass > 3) {
+			int freed;
 			zone->nr_scan_inactive = 0;
 			nr_to_scan = min(nr_pages, zone->nr_inactive);
-			ret += shrink_inactive_list(nr_to_scan, zone, sc);
+			freed = shrink_inactive_list(nr_to_scan, zone, sc);
+			ret += freed;
+			sc->swap_cluster_max -= freed;
 			if (ret >= nr_pages)
 				return ret;
 		}
@@ -1554,9 +1557,14 @@ unsigned long shrink_all_memory(unsigned
 
 		for (prio = DEF_PRIORITY; prio >= 0; prio--) {
 			unsigned long nr_to_scan = nr_pages - ret;
+			int freed;
 
 			sc.nr_scanned = 0;
-			ret += shrink_all_zones(nr_to_scan, prio, pass, &sc);
+			sc.swap_cluster_max = nr_pages - ret;
+			freed = shrink_all_zones(nr_to_scan, prio, pass, &sc);
+			ret += freed;
+			lru_pages =- freed;
+			nr_to_scan = nr_pages - ret;
 			if (ret >= nr_pages)
 				goto out;
 
_

Patches currently in -mm which might be from nigel@suspend2.net are

fix-swapped-parameters-in-mm-vmscanc.patch
vmscanc-account-for-memory-already-freed-in-seeking-to.patch

