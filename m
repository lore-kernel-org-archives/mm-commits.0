From: akpm@linux-foundation.org
Subject: +
 mm-only-force-scan-in-reclaim-when-none-of-the-lrus-are-big-enough.patch
 added to -mm tree
Date: Tue, 01 Apr 2014 12:49:29 -0700
Message-ID: <533b1849.LxGDiQkTNizJBr4v%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36561 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543AbaDATta (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Apr 2014 15:49:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yuanhan.liu@linux.intel.com, sjennings@variantweb.net, semenzato@google.com, riel@redhat.com, minchan@kernel.org, mhocko@suse.cz, mgorman@suse.de, hughd@google.com, bob.liu@oracle.com, aquini@redhat.com, suleiman@google.com

Subject: + mm-only-force-scan-in-reclaim-when-none-of-the-lrus-are-big-enough.patch added to -mm tree
To: suleiman@google.com,aquini@redhat.com,bob.liu@oracle.com,hughd@google.com,mgorman@suse.de,mhocko@suse.cz,minchan@kernel.org,riel@redhat.com,semenzato@google.com,sjennings@variantweb.net,yuanhan.liu@linux.intel.com
From: akpm@linux-foundation.org
Date: Tue, 01 Apr 2014 12:49:29 -0700


The patch titled
     Subject: mm: only force scan in reclaim when none of the LRUs are big enough.
has been added to the -mm tree.  Its filename is
     mm-only-force-scan-in-reclaim-when-none-of-the-lrus-are-big-enough.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-only-force-scan-in-reclaim-when-none-of-the-lrus-are-big-enough.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-only-force-scan-in-reclaim-when-none-of-the-lrus-are-big-enough.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Suleiman Souhlal <suleiman@google.com>
Subject: mm: only force scan in reclaim when none of the LRUs are big enough.

Prior to this change, we would decide whether to force scan a LRU during
reclaim if that LRU itself was too small for the current priority. 
However, this can lead to the file LRU getting force scanned even if there
are a lot of anonymous pages we can reclaim, leading to hot file pages
getting needlessly reclaimed.

To address this, we instead only force scan when none of the reclaimable
LRUs are big enough.

Gives huge improvements with zswap.  For example, when doing -j20 kernel
build in a 500MB container with zswap enabled, runtime (in seconds) is
greatly reduced:

x without this change
+ with this change
    N           Min           Max        Median           Avg        Stddev
x   5       700.997       790.076       763.928        754.05      39.59493
+   5       141.634       197.899       155.706         161.9     21.270224
Difference at 95.0% confidence
        -592.15 +/- 46.3521
        -78.5293% +/- 6.14709%
        (Student's t, pooled s = 31.7819)

Should also give some improvements in regular (non-zswap) swap cases.

Yes, hughd found significant speedup using regular swap, with several
memcgs under pressure; and it should also be effective in the non-memcg
case, whenever one or another zone LRU is forced too small.

Signed-off-by: Suleiman Souhlal <suleiman@google.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Suleiman Souhlal <suleiman@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Rafael Aquini <aquini@redhat.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: Seth Jennings <sjennings@variantweb.net>
Cc: Bob Liu <bob.liu@oracle.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Luigi Semenzato <semenzato@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   72 +++++++++++++++++++++++++++++---------------------
 1 file changed, 42 insertions(+), 30 deletions(-)

diff -puN mm/vmscan.c~mm-only-force-scan-in-reclaim-when-none-of-the-lrus-are-big-enough mm/vmscan.c
--- a/mm/vmscan.c~mm-only-force-scan-in-reclaim-when-none-of-the-lrus-are-big-enough
+++ a/mm/vmscan.c
@@ -1866,6 +1866,8 @@ static void get_scan_count(struct lruvec
 	bool force_scan = false;
 	unsigned long ap, fp;
 	enum lru_list lru;
+	bool some_scanned;
+	int pass;
 
 	/*
 	 * If the zone or memcg is small, nr[l] can be 0.  This
@@ -1985,39 +1987,49 @@ static void get_scan_count(struct lruvec
 	fraction[1] = fp;
 	denominator = ap + fp + 1;
 out:
-	for_each_evictable_lru(lru) {
-		int file = is_file_lru(lru);
-		unsigned long size;
-		unsigned long scan;
-
-		size = get_lru_size(lruvec, lru);
-		scan = size >> sc->priority;
-
-		if (!scan && force_scan)
-			scan = min(size, SWAP_CLUSTER_MAX);
-
-		switch (scan_balance) {
-		case SCAN_EQUAL:
-			/* Scan lists relative to size */
-			break;
-		case SCAN_FRACT:
+	some_scanned = false;
+	/* Only use force_scan on second pass. */
+	for (pass = 0; !some_scanned && pass < 2; pass++) {
+		for_each_evictable_lru(lru) {
+			int file = is_file_lru(lru);
+			unsigned long size;
+			unsigned long scan;
+
+			size = get_lru_size(lruvec, lru);
+			scan = size >> sc->priority;
+
+			if (!scan && pass && force_scan)
+				scan = min(size, SWAP_CLUSTER_MAX);
+
+			switch (scan_balance) {
+			case SCAN_EQUAL:
+				/* Scan lists relative to size */
+				break;
+			case SCAN_FRACT:
+				/*
+				 * Scan types proportional to swappiness and
+				 * their relative recent reclaim efficiency.
+				 */
+				scan = div64_u64(scan * fraction[file],
+							denominator);
+				break;
+			case SCAN_FILE:
+			case SCAN_ANON:
+				/* Scan one type exclusively */
+				if ((scan_balance == SCAN_FILE) != file)
+					scan = 0;
+				break;
+			default:
+				/* Look ma, no brain */
+				BUG();
+			}
+			nr[lru] = scan;
 			/*
-			 * Scan types proportional to swappiness and
-			 * their relative recent reclaim efficiency.
+			 * Skip the second pass and don't force_scan,
+			 * if we found something to scan.
 			 */
-			scan = div64_u64(scan * fraction[file], denominator);
-			break;
-		case SCAN_FILE:
-		case SCAN_ANON:
-			/* Scan one type exclusively */
-			if ((scan_balance == SCAN_FILE) != file)
-				scan = 0;
-			break;
-		default:
-			/* Look ma, no brain */
-			BUG();
+			some_scanned |= !!scan;
 		}
-		nr[lru] = scan;
 	}
 }
 
_

Patches currently in -mm which might be from suleiman@google.com are

mm-only-force-scan-in-reclaim-when-none-of-the-lrus-are-big-enough.patch

