From: akpm@linux-foundation.org
Subject: +
 mm-compaction-reset-cached-scanner-pfns-before-reading-them.patch added to
 -mm tree
Date: Wed, 11 Dec 2013 15:43:09 -0800
Message-ID: <52a8f88d.DaeAomPXmWaKHQXP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50466 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276Ab3LKXnK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Dec 2013 18:43:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, mgorman@suse.de, iamjoonsoo.kim@lge.com, vbabka@suse.cz

Subject: + mm-compaction-reset-cached-scanner-pfns-before-reading-them.patch added to -mm tree
To: vbabka@suse.cz,iamjoonsoo.kim@lge.com,mgorman@suse.de,riel@redhat.com
From: akpm@linux-foundation.org
Date: Wed, 11 Dec 2013 15:43:09 -0800


The patch titled
     Subject: mm: compaction: reset cached scanner pfn's before reading them
has been added to the -mm tree.  Its filename is
     mm-compaction-reset-cached-scanner-pfns-before-reading-them.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-reset-cached-scanner-pfns-before-reading-them.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-reset-cached-scanner-pfns-before-reading-them.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm: compaction: reset cached scanner pfn's before reading them

Compaction caches pfn's for its migrate and free scanners to avoid
scanning the whole zone each time.  In compact_zone(), the cached values
are read to set up initial values for the scanners.  There are several
situations when these cached pfn's are reset to the first and last pfn of
the zone, respectively.  One of these situations is when a compaction has
been deferred for a zone and is now being restarted during a direct
compaction, which is also done in compact_zone().

However, compact_zone() currently reads the cached pfn's *before*
resetting them.  This means the reset doesn't affect the compaction that
performs it, and with good chance also subsequent compactions, as
update_pageblock_skip() is likely to be called and update the cached pfn's
to those being processed.  Another chance for a successful reset is when a
direct compaction detects that migration and free scanners meet (which has
its own problems addressed by another patch) and sets
update_pageblock_skip flag which kswapd uses to do the reset because it
goes to sleep.

This is clearly a bug that results in non-deterministic behavior, so this
patch moves the cached pfn reset to be performed *before* the values are
read.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN mm/compaction.c~mm-compaction-reset-cached-scanner-pfns-before-reading-them mm/compaction.c
--- a/mm/compaction.c~mm-compaction-reset-cached-scanner-pfns-before-reading-them
+++ a/mm/compaction.c
@@ -943,6 +943,14 @@ static int compact_zone(struct zone *zon
 	}
 
 	/*
+	 * Clear pageblock skip if there were failures recently and compaction
+	 * is about to be retried after being deferred. kswapd does not do
+	 * this reset as it'll reset the cached information when going to sleep.
+	 */
+	if (compaction_restarting(zone, cc->order) && !current_is_kswapd())
+		__reset_isolation_suitable(zone);
+
+	/*
 	 * Setup to move all movable pages to the end of the zone. Used cached
 	 * information on where the scanners should start but check that it
 	 * is initialised by ensuring the values are within zone boundaries.
@@ -958,14 +966,6 @@ static int compact_zone(struct zone *zon
 		zone->compact_cached_migrate_pfn = cc->migrate_pfn;
 	}
 
-	/*
-	 * Clear pageblock skip if there were failures recently and compaction
-	 * is about to be retried after being deferred. kswapd does not do
-	 * this reset as it'll reset the cached information when going to sleep.
-	 */
-	if (compaction_restarting(zone, cc->order) && !current_is_kswapd())
-		__reset_isolation_suitable(zone);
