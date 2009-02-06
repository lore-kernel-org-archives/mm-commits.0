From: akpm@linux-foundation.org
Subject: + swsusp-dont-fiddle-with-swappiness.patch added to -mm tree
Date: Fri, 06 Feb 2009 13:01:56 -0800
Message-ID: <200902062101.n16L1u0c028030@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38306 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752278AbZBFVCx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Feb 2009 16:02:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, pavel@ucw.cz, riel@redhat.com, rjw@sisk.pl


The patch titled
     swsusp: dont fiddle with swappiness
has been added to the -mm tree.  Its filename is
     swsusp-dont-fiddle-with-swappiness.patch

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

origin.patch
migration-migrate_vmas-should-check-vma.patch
linux-next.patch
powerpc-fix-code-for-reserved-memory-spanning-across-nodes.patch
swsusp-clean-up-shrink_all_zones.patch
swsusp-dont-fiddle-with-swappiness.patch

