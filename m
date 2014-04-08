From: akpm@linux-foundation.org
Subject: [merged] mm-compaction-determine-isolation-mode-only-once.patch
 removed from -mm tree
Date: Tue, 08 Apr 2014 13:47:07 -0700
Message-ID: <5344604b.HnOGnnxvXVgTCGn6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56494 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756121AbaDHUrH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 16:47:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, riel@redhat.com, mgorman@suse.de, iamjoonsoo.kim@lge.com, rientjes@google.com

Subject: [merged] mm-compaction-determine-isolation-mode-only-once.patch removed from -mm tree
To: rientjes@google.com,iamjoonsoo.kim@lge.com,mgorman@suse.de,riel@redhat.com,vbabka@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 13:47:07 -0700


The patch titled
     Subject: mm, compaction: determine isolation mode only once
has been removed from the -mm tree.  Its filename was
     mm-compaction-determine-isolation-mode-only-once.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, compaction: determine isolation mode only once

The conditions that control the isolation mode in
isolate_migratepages_range() do not change during the iteration, so
extract them out and only define the value once.

This actually does have an effect, gcc doesn't optimize it itself because
of cc->sync.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff -puN mm/compaction.c~mm-compaction-determine-isolation-mode-only-once mm/compaction.c
--- a/mm/compaction.c~mm-compaction-determine-isolation-mode-only-once
+++ a/mm/compaction.c
@@ -460,12 +460,13 @@ isolate_migratepages_range(struct zone *
 	unsigned long last_pageblock_nr = 0, pageblock_nr;
 	unsigned long nr_scanned = 0, nr_isolated = 0;
 	struct list_head *migratelist = &cc->migratepages;
-	isolate_mode_t mode = 0;
 	struct lruvec *lruvec;
 	unsigned long flags;
 	bool locked = false;
 	struct page *page = NULL, *valid_page = NULL;
 	bool skipped_async_unsuitable = false;
+	const isolate_mode_t mode = (!cc->sync ? ISOLATE_ASYNC_MIGRATE : 0) |
+				    (unevictable ? ISOLATE_UNEVICTABLE : 0);
 
 	/*
 	 * Ensure that there are not too many pages isolated from the LRU
@@ -608,12 +609,6 @@ isolate_migratepages_range(struct zone *
 			continue;
 		}
 
-		if (!cc->sync)
-			mode |= ISOLATE_ASYNC_MIGRATE;
-
-		if (unevictable)
-			mode |= ISOLATE_UNEVICTABLE;
