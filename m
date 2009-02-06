From: akpm@linux-foundation.org
Subject: + swsusp-clean-up-shrink_all_zones.patch added to -mm tree
Date: Fri, 06 Feb 2009 13:01:53 -0800
Message-ID: <200902062101.n16L1sPL027947@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52408 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751825AbZBFVCq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Feb 2009 16:02:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, pavel@ucw.cz, riel@redhat.com, rjw@sisk.pl


The patch titled
     swsusp: clean up shrink_all_zones()
has been added to the -mm tree.  Its filename is
     swsusp-clean-up-shrink_all_zones.patch

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
Subject: swsusp: clean up shrink_all_zones()
From: Johannes Weiner <hannes@cmpxchg.org>

Move local variables to innermost possible scopes and use local
variables to cache calculations/reads done more than once.

No change in functionality (intended).

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff -puN mm/vmscan.c~swsusp-clean-up-shrink_all_zones mm/vmscan.c
--- a/mm/vmscan.c~swsusp-clean-up-shrink_all_zones
+++ a/mm/vmscan.c
@@ -2057,31 +2057,31 @@ static unsigned long shrink_all_zones(un
 				      int pass, struct scan_control *sc)
 {
 	struct zone *zone;
-	unsigned long nr_to_scan, ret = 0;
-	enum lru_list l;
+	unsigned long ret = 0;
 
 	for_each_zone(zone) {
+		enum lru_list l;
 
 		if (!populated_zone(zone))
 			continue;
-
 		if (zone_is_all_unreclaimable(zone) && prio != DEF_PRIORITY)
 			continue;
 
 		for_each_evictable_lru(l) {
+			enum zone_stat_item ls = NR_LRU_BASE + l;
+			unsigned long lru_pages = zone_page_state(zone, ls);
+
 			/* For pass = 0, we don't shrink the active list */
-			if (pass == 0 &&
-				(l == LRU_ACTIVE || l == LRU_ACTIVE_FILE))
+			if (pass == 0 && (l == LRU_ACTIVE_ANON ||
+						l == LRU_ACTIVE_FILE))
 				continue;
 
-			zone->lru[l].nr_scan +=
-				(zone_page_state(zone, NR_LRU_BASE + l)
-								>> prio) + 1;
+			zone->lru[l].nr_scan += (lru_pages >> prio) + 1;
 			if (zone->lru[l].nr_scan >= nr_pages || pass > 3) {
+				unsigned long nr_to_scan;
+
 				zone->lru[l].nr_scan = 0;
-				nr_to_scan = min(nr_pages,
-					zone_page_state(zone,
-							NR_LRU_BASE + l));
+				nr_to_scan = min(nr_pages, lru_pages);
 				ret += shrink_list(l, nr_to_scan, zone,
 								sc, prio);
 				if (ret >= nr_pages)
@@ -2089,7 +2089,6 @@ static unsigned long shrink_all_zones(un
 			}
 		}
 	}
