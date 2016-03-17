From: akpm@linux-foundation.org
Subject: [folded-merged] mm-compaction-introduce-kcompactd-fix-3.patch
 removed from -mm tree
Date: Thu, 17 Mar 2016 13:51:14 -0700
Message-ID: <56eb18c2.0p+PAMqmwZILAIEj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44296 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965007AbcCQUvP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Mar 2016 16:51:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-compaction-introduce-kcompactd-fix-3
has been removed from the -mm tree.  Its filename was
     mm-compaction-introduce-kcompactd-fix-3.patch

This patch was dropped because it was folded into mm-compaction-introduce-kcompactd.patch

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm-compaction-introduce-kcompactd-fix-3

Remove extraneous check for sync compaction before deferring.
Correctly adjust kcompactd's classzone_idx instead of kswapd's.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff -puN mm/compaction.c~mm-compaction-introduce-kcompactd-fix-3 mm/compaction.c
--- a/mm/compaction.c~mm-compaction-introduce-kcompactd-fix-3
+++ a/mm/compaction.c
@@ -1811,8 +1811,11 @@ static void kcompactd_do_work(pg_data_t
 						cc.classzone_idx, 0)) {
 			success = true;
 			compaction_defer_reset(zone, cc.order, false);
-		} else if (cc.mode != MIGRATE_ASYNC &&
-						status == COMPACT_COMPLETE) {
+		} else if (status == COMPACT_COMPLETE) {
+			/*
+			 * We use sync migration mode here, so we defer like
+			 * sync direct compaction does.
+			 */
 			defer_compaction(zone, cc.order);
 		}
 
@@ -1827,8 +1830,8 @@ static void kcompactd_do_work(pg_data_t
 	 */
 	if (pgdat->kcompactd_max_order <= cc.order)
 		pgdat->kcompactd_max_order = 0;
-	if (pgdat->classzone_idx >= cc.classzone_idx)
-		pgdat->classzone_idx = pgdat->nr_zones - 1;
+	if (pgdat->kcompactd_classzone_idx >= cc.classzone_idx)
+		pgdat->kcompactd_classzone_idx = pgdat->nr_zones - 1;
 }
 
 void wakeup_kcompactd(pg_data_t *pgdat, int order, int classzone_idx)
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-kswapd-remove-bogus-check-of-balance_classzone_idx.patch
mm-compaction-introduce-kcompactd.patch
mm-compaction-introduce-kcompactd-fix-4.patch
mm-memory-hotplug-small-cleanup-in-online_pages.patch
mm-kswapd-replace-kswapd-compaction-with-waking-up-kcompactd.patch
mm-tracing-refresh-__def_vmaflag_names-fix.patch
mm-use-radix_tree_iter_retry-fix.patch

