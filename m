From: akpm@osdl.org
Subject: + fix-swapped-parameters-in-mm-vmscanc.patch added to -mm tree
Date: Thu, 14 Dec 2006 16:44:55 -0800
Message-ID: <200612150044.kBF0itpe001784@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:46500 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932513AbWLOAp2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 19:45:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nigel@suspend2.net, pavel@ucw.cz, rjw@sisk.pl


The patch titled
     Fix swapped parameters in mm/vmscan.c
has been added to the -mm tree.  Its filename is
     fix-swapped-parameters-in-mm-vmscanc.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 2 insertions(+), 2 deletions(-)

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

fix-swapped-parameters-in-mm-vmscanc.patch

