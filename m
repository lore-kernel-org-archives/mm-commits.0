From: akpm@linux-foundation.org
Subject: + mm-compaction-clean-up-unused-code-lines.patch added to -mm
 tree
Date: Mon, 21 Apr 2014 12:41:54 -0700
Message-ID: <53557482.6eSFuZx8BPmdDMCP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36549 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754453AbaDUTl4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Apr 2014 15:41:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, sunghwan.yun@samsung.com, riel@redhat.com, n-horiguchi@ah.jp.nec.com, minchan@kernel.org, mina86@mina86.com, mgorman@suse.de, iamjoonsoo.kim@lge.com, d.j.shin@samsung.com, cl@linux.com, b.zolnierkie@samsung.com, heesub.shin@samsung.com

Subject: + mm-compaction-clean-up-unused-code-lines.patch added to -mm tree
To: heesub.shin@samsung.com,b.zolnierkie@samsung.com,cl@linux.com,d.j.shin@samsung.com,iamjoonsoo.kim@lge.com,mgorman@suse.de,mina86@mina86.com,minchan@kernel.org,n-horiguchi@ah.jp.nec.com,riel@redhat.com,sunghwan.yun@samsung.com,vbabka@suse.cz
From: akpm@linux-foundation.org
Date: Mon, 21 Apr 2014 12:41:54 -0700


The patch titled
     Subject: mm/compaction: clean up unused code lines
has been added to the -mm tree.  Its filename is
     mm-compaction-clean-up-unused-code-lines.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-clean-up-unused-code-lines.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-clean-up-unused-code-lines.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Heesub Shin <heesub.shin@samsung.com>
Subject: mm/compaction: clean up unused code lines

Remove code lines currently not in use or never called.

Signed-off-by: Heesub Shin <heesub.shin@samsung.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Dongjun Shin <d.j.shin@samsung.com>
Cc: Sunghwan Yun <sunghwan.yun@samsung.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Dongjun Shin <d.j.shin@samsung.com>
Cc: Sunghwan Yun <sunghwan.yun@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   10 ----------
 1 file changed, 10 deletions(-)

diff -puN mm/compaction.c~mm-compaction-clean-up-unused-code-lines mm/compaction.c
--- a/mm/compaction.c~mm-compaction-clean-up-unused-code-lines
+++ a/mm/compaction.c
@@ -208,12 +208,6 @@ static bool compact_checklock_irqsave(sp
 	return true;
 }
 
-static inline bool compact_trylock_irqsave(spinlock_t *lock,
-			unsigned long *flags, struct compact_control *cc)
-{
-	return compact_checklock_irqsave(lock, flags, false, cc);
-}
-
 /* Returns true if the page is within a block suitable for migration to */
 static bool suitable_migration_target(struct page *page)
 {
@@ -733,7 +727,6 @@ static void isolate_freepages(struct zon
 			continue;
 
 		/* Found a block suitable for isolating free pages from */
-		isolated = 0;
 
 		/*
 		 * Take care when isolating in last pageblock of a zone which
@@ -1162,9 +1155,6 @@ static void __compact_pgdat(pg_data_t *p
 			if (zone_watermark_ok(zone, cc->order,
 						low_wmark_pages(zone), 0, 0))
 				compaction_defer_reset(zone, cc->order, false);
-			/* Currently async compaction is never deferred. */
-			else if (cc->sync)
-				defer_compaction(zone, cc->order);
 		}
 
 		VM_BUG_ON(!list_empty(&cc->freepages));
_

Patches currently in -mm which might be from heesub.shin@samsung.com are

mm-compaction-make-isolate_freepages-start-at-pageblock-boundary.patch
mm-compaction-clean-up-unused-code-lines.patch

