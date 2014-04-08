From: akpm@linux-foundation.org
Subject: [merged]
 mm-compaction-clean-up-code-on-success-of-ballon-isolation.patch removed
 from -mm tree
Date: Tue, 08 Apr 2014 13:37:31 -0700
Message-ID: <53445e0b.q9zD5QmIRYa9IeOy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56260 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756598AbaDHUhc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 16:37:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, riel@redhat.com, mgorman@suse.de, iamjoonsoo.kim@lge.com

Subject: [merged] mm-compaction-clean-up-code-on-success-of-ballon-isolation.patch removed from -mm tree
To: iamjoonsoo.kim@lge.com,mgorman@suse.de,riel@redhat.com,vbabka@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 13:37:31 -0700


The patch titled
     Subject: mm/compaction: clean-up code on success of ballon isolation
has been removed from the -mm tree.  Its filename was
     mm-compaction-clean-up-code-on-success-of-ballon-isolation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/compaction: clean-up code on success of ballon isolation

It is just for clean-up to reduce code size and improve readability. 
There is no functional change.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff -puN mm/compaction.c~mm-compaction-clean-up-code-on-success-of-ballon-isolation mm/compaction.c
--- a/mm/compaction.c~mm-compaction-clean-up-code-on-success-of-ballon-isolation
+++ a/mm/compaction.c
@@ -562,11 +562,7 @@ isolate_migratepages_range(struct zone *
 			if (unlikely(balloon_page_movable(page))) {
 				if (locked && balloon_page_isolate(page)) {
 					/* Successfully isolated */
-					cc->finished_update_migrate = true;
-					list_add(&page->lru, migratelist);
-					cc->nr_migratepages++;
-					nr_isolated++;
-					goto check_compact_cluster;
+					goto isolate_success;
 				}
 			}
 			continue;
@@ -627,13 +623,14 @@ isolate_migratepages_range(struct zone *
 		VM_BUG_ON_PAGE(PageTransCompound(page), page);
 
 		/* Successfully isolated */
-		cc->finished_update_migrate = true;
 		del_page_from_lru_list(page, lruvec, page_lru(page));
+
+isolate_success:
+		cc->finished_update_migrate = true;
 		list_add(&page->lru, migratelist);
 		cc->nr_migratepages++;
 		nr_isolated++;
 
-check_compact_cluster:
 		/* Avoid isolating too much */
 		if (cc->nr_migratepages == COMPACT_CLUSTER_MAX) {
 			++low_pfn;
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
linux-next.patch
page-owners-correct-page-order-when-to-free-page.patch

