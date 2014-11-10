From: akpm@linux-foundation.org
Subject: + mm-compaction-prevent-infinite-loop-in-compact_zone.patch added to -mm tree
Date: Mon, 10 Nov 2014 15:10:39 -0800
Message-ID: <546145ef.9FAnRaRq6ZiGYi7S%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44975 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbaKJXKj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Nov 2014 18:10:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, iamjoonsoo.kim@lge.com, mel@csn.ul.ie, pavel@ucw.cz, preining@logic.at, rientjes@google.com, xrg@linux.gr, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: prevent infinite loop in compact_zone
has been added to the -mm tree.  Its filename is
     mm-compaction-prevent-infinite-loop-in-compact_zone.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-prevent-infinite-loop-in-compact_zone.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-prevent-infinite-loop-in-compact_zone.patch

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
Subject: mm, compaction: prevent infinite loop in compact_zone

Several people have reported occasionally seeing processes stuck in
compact_zone(), even triggering soft lockups, in 3.18-rc2+.

Testing a revert of e14c720efdd7 ("mm, compaction: remember position
within pageblock in free pages scanner") fixed the issue, although the
stuck processes do not appear to involve the free scanner.  Finally, by
code inspection, the bug was found in isolate_migratepages() which uses a
slightly different condition to detect if the migration and free scanners
have met, than compact_finished().  That has not been a problem until
commit e14c720efdd7 allowed the free scanner position between individual
invocations to be in the middle of a pageblock.

In a relatively rare case, the migration scanner position can end up at
the beginning of a pageblock, with the free scanner position in the middle
of the same pageblock.  If it's the migration scanner's turn,
isolate_migratepages() exits immediately (without updating the position),
while compact_finished() decides to continue compaction, resulting in a
potentially infinite loop.  The system can recover only if another process
creates enough high-order pages to make the watermark checks in
compact_finished() pass.

This patch fixes the immediate problem by bumping the migration scanner's
position to meet the free scanner in isolate_migratepages(), when both are
within the same pageblock.  This causes compact_finished() to terminate
properly.  A more robust check in compact_finished() is planned as a
cleanup for better future maintainability.

Fixes: e14c720efdd73 ("mm, compaction: remember position within pageblock in free pages scanner)
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: P. Christeas <xrg@linux.gr>
Tested-by: P. Christeas <xrg@linux.gr>
Link: http://marc.info/?l=linux-mm&m=141508604232522&w=2
Reported-by: Norbert Preining <preining@logic.at>
Tested-by: Norbert Preining <preining@logic.at>
Link: https://lkml.org/lkml/2014/11/4/904
Reported-by: Pavel Machek <pavel@ucw.cz>
Link: https://lkml.org/lkml/2014/11/7/164
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN mm/compaction.c~mm-compaction-prevent-infinite-loop-in-compact_zone mm/compaction.c
--- a/mm/compaction.c~mm-compaction-prevent-infinite-loop-in-compact_zone
+++ a/mm/compaction.c
@@ -1039,8 +1039,12 @@ static isolate_migrate_t isolate_migrate
 	}
 
 	acct_isolated(zone, cc);
-	/* Record where migration scanner will be restarted */
-	cc->migrate_pfn = low_pfn;
+	/*
+	 * Record where migration scanner will be restarted. If we end up in
+	 * the same pageblock as the free scanner, make the scanners fully
+	 * meet so that compact_finished() terminates compaction.
+	 */
+	cc->migrate_pfn = (end_pfn <= cc->free_pfn) ? low_pfn : cc->free_pfn;
 
 	return cc->nr_migratepages ? ISOLATE_SUCCESS : ISOLATE_NONE;
 }
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-compaction-skip-the-range-until-proper-target-pageblock-is-met.patch
mm-page_alloc-fix-incorrect-isolation-behavior-by-rechecking-migratetype.patch
mm-page_alloc-add-freepage-on-isolate-pageblock-to-correct-buddy-list.patch
mm-page_alloc-move-freepage-counting-logic-to-__free_one_page.patch
mm-page_alloc-restrict-max-order-of-merging-on-isolated-pageblock.patch
mm-compaction-prevent-infinite-loop-in-compact_zone.patch
mm-introduce-single-zone-pcplists-drain.patch
mm-page_isolation-drain-single-zone-pcplists.patch
mm-cma-drain-single-zone-pcplists.patch
mm-memory_hotplug-failure-drain-single-zone-pcplists.patch
mm-compaction-pass-classzone_idx-and-alloc_flags-to-watermark-checking.patch
mm-compaction-simplify-deferred-compaction.patch
mm-compaction-simplify-deferred-compaction-fix.patch
mm-compaction-defer-only-on-compact_complete.patch
mm-compaction-always-update-cached-scanner-positions.patch
mm-compaction-more-focused-lru-and-pcplists-draining.patch

