From: akpm@osdl.org
Subject: - fix-swapped-parameters-in-mm-vmscanc.patch removed from -mm tree
Date: Fri, 22 Dec 2006 23:53:44 -0800
Message-ID: <200612230753.kBN7riTs010154@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:49695 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752647AbWLWHyS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Dec 2006 02:54:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nigel@suspend2.net, pavel@ucw.cz, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     Fix swapped parameters in mm/vmscan.c
has been removed from the -mm tree.  Its filename was
     fix-swapped-parameters-in-mm-vmscanc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix swapped parameters in mm/vmscan.c
From: Nigel Cunningham <nigel@suspend2.net>

The version of mm/vmscan.c in Linus' current tree has swapped parameters in
the shrink_all_zones declaration and call, used by the various
suspend-to-disk implementations.  This doesn't seem to have any great
adverse effect, but it's clearly wrong.

Signed-off-by: Nigel Cunningham <nigel@suspend2.net>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/vmscan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/vmscan.c~fix-swapped-parameters-in-mm-vmscanc mm/vmscan.c
--- a/mm/vmscan.c~fix-swapped-parameters-in-mm-vmscanc
+++ a/mm/vmscan.c
@@ -1369,8 +1369,8 @@ void wakeup_kswapd(struct zone *zone, in
  *
  * For pass > 3 we also try to shrink the LRU lists that contain a few pages
  */
-static unsigned long shrink_all_zones(unsigned long nr_pages, int pass,
-				      int prio, struct scan_control *sc)
+static unsigned long shrink_all_zones(unsigned long nr_pages, int prio,
+				      int pass, struct scan_control *sc)
 {
 	struct zone *zone;
 	unsigned long nr_to_scan, ret = 0;
_

Patches currently in -mm which might be from nigel@suspend2.net are

origin.patch
pm-change-code-ordering-in-mainc.patch
swsusp-change-code-ordering-in-diskc.patch
swsusp-change-code-ordering-in-userc.patch
swsusp-change-code-ordering-in-userc-sanity.patch
swsusp-change-pm_ops-handling-by-userland-interface.patch

