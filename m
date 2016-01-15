From: akpm@linux-foundation.org
Subject: [merged] mm-compaction-__compact_pgdat-code-cleanuup.patch
 removed from -mm tree
Date: Fri, 15 Jan 2016 14:34:18 -0800
Message-ID: <569973ea.wDdzygY0d2Bnu+it%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59566 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053AbcAOWeS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 17:34:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: js1304@gmail.com, baiyaowei@cmss.chinamobile.com, iamjoonsoo.kim@lge.com, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction.c: __compact_pgdat() code cleanuup
has been removed from the -mm tree.  Its filename was
     mm-compaction-__compact_pgdat-code-cleanuup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <js1304@gmail.com>
Subject: mm/compaction.c: __compact_pgdat() code cleanuup

This patch uses is_via_compact_memory() to distinguish compaction from
sysfs or sysctl.  And, this patch also reduces indentation on
compaction_defer_reset() by filtering these cases first before checking
watermark.

There is no functional change.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff -puN mm/compaction.c~mm-compaction-__compact_pgdat-code-cleanuup mm/compaction.c
--- a/mm/compaction.c~mm-compaction-__compact_pgdat-code-cleanuup
+++ a/mm/compaction.c
@@ -1658,14 +1658,15 @@ static void __compact_pgdat(pg_data_t *p
 				!compaction_deferred(zone, cc->order))
 			compact_zone(zone, cc);
 
-		if (cc->order > 0) {
-			if (zone_watermark_ok(zone, cc->order,
-						low_wmark_pages(zone), 0, 0))
-				compaction_defer_reset(zone, cc->order, false);
-		}
