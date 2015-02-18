From: akpm@linux-foundation.org
Subject: + mm-cma-change-fallback-behaviour-for-cma-freepage.patch added
 to -mm tree
Date: Wed, 18 Feb 2015 15:09:57 -0800
Message-ID: <54e51bc5.8LZtRzFbnCHHIIxj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48387 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbbBRXJ7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Feb 2015 18:09:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, mgorman@suse.de, riel@redhat.com, rientjes@google.com, vbabka@suse.cz, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/cma: change fallback behaviour for CMA freepage
has been added to the -mm tree.  Its filename is
     mm-cma-change-fallback-behaviour-for-cma-freepage.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-cma-change-fallback-behaviour-for-cma-freepage.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-cma-change-fallback-behaviour-for-cma-freepage.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/cma: change fallback behaviour for CMA freepage

Freepage with MIGRATE_CMA can be used only for MIGRATE_MOVABLE and they
should not be expanded to other migratetype buddy list to protect them
from unmovable/reclaimable allocation.  Implementing these requirements in
__rmqueue_fallback(), that is, finding largest possible block of freepage
has bad effect that high order freepage with MIGRATE_CMA are broken
continually although there are suitable order CMA freepage.  Reason is
that they are not be expanded to other migratetype buddy list and next
__rmqueue_fallback() invocation try to finds another largest block of
freepage and break it again.  So, MIGRATE_CMA fallback should be handled
separately.  This patch introduces __rmqueue_cma_fallback(), that just
wrapper of __rmqueue_smallest() and call it before __rmqueue_fallback() if
migratetype == MIGRATE_MOVABLE.

This results in unintended behaviour change that MIGRATE_CMA freepage is
always used first rather than other migratetype as movable allocation's
fallback.  But, as already mentioned above, MIGRATE_CMA can be used only
for MIGRATE_MOVABLE, so it is better to use MIGRATE_CMA freepage first as
much as possible.  Otherwise, we needlessly take up precious freepages
with other migratetype and increase chance of fragmentation.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

diff -puN mm/page_alloc.c~mm-cma-change-fallback-behaviour-for-cma-freepage mm/page_alloc.c
--- a/mm/page_alloc.c~mm-cma-change-fallback-behaviour-for-cma-freepage
+++ a/mm/page_alloc.c
@@ -1032,11 +1032,9 @@ struct page *__rmqueue_smallest(struct z
 static int fallbacks[MIGRATE_TYPES][4] = {
 	[MIGRATE_UNMOVABLE]   = { MIGRATE_RECLAIMABLE, MIGRATE_MOVABLE,     MIGRATE_RESERVE },
 	[MIGRATE_RECLAIMABLE] = { MIGRATE_UNMOVABLE,   MIGRATE_MOVABLE,     MIGRATE_RESERVE },
+	[MIGRATE_MOVABLE]     = { MIGRATE_RECLAIMABLE, MIGRATE_UNMOVABLE,   MIGRATE_RESERVE },
 #ifdef CONFIG_CMA
-	[MIGRATE_MOVABLE]     = { MIGRATE_CMA,         MIGRATE_RECLAIMABLE, MIGRATE_UNMOVABLE, MIGRATE_RESERVE },
 	[MIGRATE_CMA]         = { MIGRATE_RESERVE }, /* Never used */
-#else
-	[MIGRATE_MOVABLE]     = { MIGRATE_RECLAIMABLE, MIGRATE_UNMOVABLE,   MIGRATE_RESERVE },
 #endif
 	[MIGRATE_RESERVE]     = { MIGRATE_RESERVE }, /* Never used */
 #ifdef CONFIG_MEMORY_ISOLATION
@@ -1044,6 +1042,17 @@ static int fallbacks[MIGRATE_TYPES][4] =
 #endif
 };
 
+#ifdef CONFIG_CMA
+static struct page *__rmqueue_cma_fallback(struct zone *zone,
+					unsigned int order)
+{
+	return __rmqueue_smallest(zone, order, MIGRATE_CMA);
+}
+#else
+static inline struct page *__rmqueue_cma_fallback(struct zone *zone,
+					unsigned int order) { return NULL; }
+#endif
+
 /*
  * Move the free pages in a range to the free lists of the requested type.
  * Note that start_page and end_pages are not aligned on a pageblock
@@ -1195,19 +1204,8 @@ __rmqueue_fallback(struct zone *zone, un
 					struct page, lru);
 			area->nr_free--;
 
-			if (!is_migrate_cma(migratetype)) {
-				try_to_steal_freepages(zone, page,
-							start_migratetype,
-							migratetype);
-			} else {
-				/*
-				 * When borrowing from MIGRATE_CMA, we need to
-				 * release the excess buddy pages to CMA
-				 * itself, and we do not try to steal extra
-				 * free pages.
-				 */
-				buddy_type = migratetype;
-			}
+			try_to_steal_freepages(zone, page, start_migratetype,
+								migratetype);
 
 			/* Remove the page from the freelists */
 			list_del(&page->lru);
@@ -1249,7 +1247,11 @@ retry_reserve:
 	page = __rmqueue_smallest(zone, order, migratetype);
 
 	if (unlikely(!page) && migratetype != MIGRATE_RESERVE) {
-		page = __rmqueue_fallback(zone, order, migratetype);
+		if (migratetype == MIGRATE_MOVABLE)
+			page = __rmqueue_cma_fallback(zone, order);
+
+		if (!page)
+			page = __rmqueue_fallback(zone, order, migratetype);
 
 		/*
 		 * Use MIGRATE_RESERVE rather than fail an allocation. goto
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch
mm-nommu-fix-memory-leak.patch
zram-use-proper-type-to-update-max_used_pages.patch
mm-cma-debugfs-interface.patch
mm-cma-allocation-trigger.patch
mm-cma-release-trigger.patch
mm-cma-allocation-trigger-fix.patch
mm-cma-change-fallback-behaviour-for-cma-freepage.patch
mm-page_alloc-factor-out-fallback-freepage-checking.patch
mm-compaction-enhance-compaction-finish-condition.patch

