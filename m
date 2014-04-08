From: akpm@linux-foundation.org
Subject: [merged]
 mm-compaction-do-not-call-suitable_migration_target-on-every-page.patch
 removed from -mm tree
Date: Tue, 08 Apr 2014 13:35:55 -0700
Message-ID: <53445dab.N/F91jJVISAHTvTK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56241 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756586AbaDHUf4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 16:35:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, riel@redhat.com, mgorman@suse.de, iamjoonsoo.kim@lge.com

Subject: [merged] mm-compaction-do-not-call-suitable_migration_target-on-every-page.patch removed from -mm tree
To: iamjoonsoo.kim@lge.com,mgorman@suse.de,riel@redhat.com,vbabka@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 13:35:55 -0700


The patch titled
     Subject: mm/compaction: do not call suitable_migration_target() on every page
has been removed from the -mm tree.  Its filename was
     mm-compaction-do-not-call-suitable_migration_target-on-every-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/compaction: do not call suitable_migration_target() on every page

suitable_migration_target() checks that pageblock is suitable for
migration target.  In isolate_freepages_block(), it is called on every
page and this is inefficient.  So make it called once per pageblock.

suitable_migration_target() also checks if page is highorder or not, but
it's criteria for highorder is pageblock order.  So calling it once within
pageblock range has no problem.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff -puN mm/compaction.c~mm-compaction-do-not-call-suitable_migration_target-on-every-page mm/compaction.c
--- a/mm/compaction.c~mm-compaction-do-not-call-suitable_migration_target-on-every-page
+++ a/mm/compaction.c
@@ -244,6 +244,7 @@ static unsigned long isolate_freepages_b
 	struct page *cursor, *valid_page = NULL;
 	unsigned long flags;
 	bool locked = false;
+	bool checked_pageblock = false;
 
 	cursor = pfn_to_page(blockpfn);
 
@@ -275,8 +276,16 @@ static unsigned long isolate_freepages_b
 			break;
 
 		/* Recheck this is a suitable migration target under lock */
-		if (!strict && !suitable_migration_target(page))
-			break;
+		if (!strict && !checked_pageblock) {
+			/*
+			 * We need to check suitability of pageblock only once
+			 * and this isolate_freepages_block() is called with
+			 * pageblock range, so just check once is sufficient.
+			 */
+			checked_pageblock = true;
+			if (!suitable_migration_target(page))
+				break;
+		}
 
 		/* Recheck this is a buddy page under lock */
 		if (!PageBuddy(page))
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
linux-next.patch
page-owners-correct-page-order-when-to-free-page.patch

