From: akpm@linux-foundation.org
Subject: [merged] mm-mmzone-clarify-the-usage-of-zone-padding.patch
 removed from -mm tree
Date: Fri, 29 Jul 2016 11:54:32 -0700
Message-ID: <579ba668.2oO2W5FwLI3pyHM2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37094 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbcG2Syd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2016 14:54:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, iamjoonsoo.kim@lge.com, mhocko@kernel.org, minchan@kernel.org, riel@surriel.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, mmzone: clarify the usage of zone padding
has been removed from the -mm tree.  Its filename was
     mm-mmzone-clarify-the-usage-of-zone-padding.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, mmzone: clarify the usage of zone padding

Zone padding separates write-intensive fields used by page allocation,
compaction and vmstats but the comments are a little misleading and
need clarification.

Link: http://lkml.kernel.org/r/1467970510-21195-5-git-send-email-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN include/linux/mmzone.h~mm-mmzone-clarify-the-usage-of-zone-padding include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-mmzone-clarify-the-usage-of-zone-padding
+++ a/include/linux/mmzone.h
@@ -477,20 +477,21 @@ struct zone {
 	unsigned long		wait_table_hash_nr_entries;
 	unsigned long		wait_table_bits;
 
+	/* Write-intensive fields used from the page allocator */
 	ZONE_PADDING(_pad1_)
+
 	/* free areas of different sizes */
 	struct free_area	free_area[MAX_ORDER];
 
 	/* zone flags, see below */
 	unsigned long		flags;
 
-	/* Write-intensive fields used from the page allocator */
+	/* Primarily protects free_area */
 	spinlock_t		lock;
 
+	/* Write-intensive fields used by compaction and vmstats. */
 	ZONE_PADDING(_pad2_)
 
-	/* Write-intensive fields used by page reclaim */
