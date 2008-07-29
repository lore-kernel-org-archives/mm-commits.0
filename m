From: akpm@linux-foundation.org
Subject: + vmscan-dont-accumulate-scan-pressure-on-unrelated-lists.patch added to -mm tree
Date: Tue, 29 Jul 2008 16:51:41 -0700
Message-ID: <200807292351.m6TNpfpE028672@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56987 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752560AbYG2XwH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 19:52:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@saeurebad.de, riel@redhat.com


The patch titled
     vmscan: don't accumulate scan pressure on unrelated lists
has been added to the -mm tree.  Its filename is
     vmscan-dont-accumulate-scan-pressure-on-unrelated-lists.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: don't accumulate scan pressure on unrelated lists
From: Johannes Weiner <hannes@saeurebad.de>

During each reclaim scan we accumulate scan pressure on unrelated lists
which will result in bogus scans and unwanted reclaims eventually.

Scanning lists with few reclaim candidates results in a lot of rotation
and therefor also disturbs the list balancing, putting even more
pressure on the wrong lists.

In a test-case with much streaming IO, and therefor a crowded inactive
file page list, swapping started because

  a) anon pages were reclaimed after swap_cluster_max reclaim
  invocations -- nr_scan of this list has just accumulated

  b) active file pages were scanned because *their* nr_scan has also
  accumulated through the same logic.  And this in return created a
  lot of rotation for file pages and resulted in a decrease of file
  list priority, again increasing the pressure on anon pages.

The result was an evicted working set of anon pages while there were
tons of inactive file pages that should have been taken instead.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN mm/vmscan.c~vmscan-dont-accumulate-scan-pressure-on-unrelated-lists mm/vmscan.c
--- a/mm/vmscan.c~vmscan-dont-accumulate-scan-pressure-on-unrelated-lists
+++ a/mm/vmscan.c
@@ -1451,16 +1451,13 @@ static unsigned long shrink_zone(int pri
 		if (scan_global_lru(sc)) {
 			int file = is_file_lru(l);
 			int scan;
-			/*
-			 * Add one to nr_to_scan just to make sure that the
-			 * kernel will slowly sift through each list.
-			 */
+
 			scan = zone_page_state(zone, NR_LRU_BASE + l);
 			if (priority) {
 				scan >>= priority;
 				scan = (scan * percent[file]) / 100;
 			}
-			zone->lru[l].nr_scan += scan + 1;
+			zone->lru[l].nr_scan += scan;
 			nr[l] = zone->lru[l].nr_scan;
 			if (nr[l] >= sc->swap_cluster_max)
 				zone->lru[l].nr_scan = 0;
_

Patches currently in -mm which might be from hannes@saeurebad.de are

linux-next.patch
git-xtensa.patch
vmscan-dont-accumulate-scan-pressure-on-unrelated-lists.patch
mm-more-likely-reclaim-madv_sequential-mappings.patch

