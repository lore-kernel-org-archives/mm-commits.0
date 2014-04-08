From: akpm@linux-foundation.org
Subject: [merged]
 mm-compaction-disallow-high-order-page-for-migration-target.patch removed
 from -mm tree
Date: Tue, 08 Apr 2014 13:35:23 -0700
Message-ID: <53445d8b.vDbLsvUSVK2V0bLE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56113 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756207AbaDHUfY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 16:35:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, riel@redhat.com, mgorman@suse.de, iamjoonsoo.kim@lge.com

Subject: [merged] mm-compaction-disallow-high-order-page-for-migration-target.patch removed from -mm tree
To: iamjoonsoo.kim@lge.com,mgorman@suse.de,riel@redhat.com,vbabka@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 13:35:23 -0700


The patch titled
     Subject: mm/compaction: disallow high-order page for migration target
has been removed from the -mm tree.  Its filename was
     mm-compaction-disallow-high-order-page-for-migration-target.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/compaction: disallow high-order page for migration target

Purpose of compaction is to get a high order page.  Currently, if we find
high-order page while searching migration target page, we break it to
order-0 pages and use them as migration target.  It is contrary to purpose
of compaction, so disallow high-order page to be used for migration
target.

Additionally, clean-up logic in suitable_migration_target() to simplify
the code.  There is no functional changes from this clean-up.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff -puN mm/compaction.c~mm-compaction-disallow-high-order-page-for-migration-target mm/compaction.c
--- a/mm/compaction.c~mm-compaction-disallow-high-order-page-for-migration-target
+++ a/mm/compaction.c
@@ -217,21 +217,12 @@ static inline bool compact_trylock_irqsa
 /* Returns true if the page is within a block suitable for migration to */
 static bool suitable_migration_target(struct page *page)
 {
-	int migratetype = get_pageblock_migratetype(page);
-
-	/* Don't interfere with memory hot-remove or the min_free_kbytes blocks */
-	if (migratetype == MIGRATE_RESERVE)
-		return false;
-
-	if (is_migrate_isolate(migratetype))
-		return false;
