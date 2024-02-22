Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC7DFEBE
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560212; cv=none; b=Lo4XeNDWXOIdNPKKSAh80Z3CWq44R7eM4NGlhyVgINcUroTFjsnZdtVSEM4UDo2ITDIXZhu+NYzrb3q5w7+cjCpxcTqUefHA34cSz92qFOrOIsDtiuQzR4J7KcPb6tymQzv7zp7m9yTzzyouXaZootzyalD/Z3zDSTNOzs792Qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560212; c=relaxed/simple;
	bh=DtoIOVw2MY8XhMjiJ/DcmVmN1TU5tFE+m500r6n8qgQ=;
	h=Date:To:From:Subject:Message-Id; b=cZTSyz+cLPpTGNeGc2LLNoA5cx9sIc0OOEfDjLdw7+MJGG5K4QHsrqjBw4wuzUqQ4BflTRKs/6IpIC1QPYHKOn6W4kCqgMPMUEHdqIQlrMIanVCx6viugxWcUYMTb/vr3mAPqJhe6evalQ3vxiVT2VUQI7IbiP6LH6cuN+LvX6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vxnGYBQ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vxnGYBQ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98396C433C7;
	Thu, 22 Feb 2024 00:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560212;
	bh=DtoIOVw2MY8XhMjiJ/DcmVmN1TU5tFE+m500r6n8qgQ=;
	h=Date:To:From:Subject:From;
	b=vxnGYBQ8l0VDBS0x/HM4uuqOEjybRB0hodZ927c2kI8gltbn59fiQ4+tyNwomfkWB
	 3wwPJ1nh4A2m5q8IQdphSYCtGtuG0AZYdYk+IJvlfpYQoAJjqMWCZ48wFWGaOXEQuA
	 b+zs+9ym2AGnJS77ftNcwTLuwbRnemE8CrrD+zT8=
Date: Wed, 21 Feb 2024 16:03:32 -0800
To: mm-commits@vger.kernel.org,baolin.wang@linux.alibaba.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-compaction-refactor-compact_node.patch removed from -mm tree
Message-Id: <20240222000332.98396C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: compaction: refactor compact_node()
has been removed from the -mm tree.  Its filename was
     mm-compaction-refactor-compact_node.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: compaction: refactor compact_node()
Date: Thu, 8 Feb 2024 09:36:07 +0800

Refactor compact_node() to handle both proactive and synchronous compact
memory, which cleanups code a bit.

Link: https://lkml.kernel.org/r/20240208013607.1731817-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   65 ++++++++++++++--------------------------------
 1 file changed, 21 insertions(+), 44 deletions(-)

--- a/mm/compaction.c~mm-compaction-refactor-compact_node
+++ a/mm/compaction.c
@@ -2796,25 +2796,27 @@ enum compact_result try_to_compact_pages
 }
 
 /*
- * Compact all zones within a node till each zone's fragmentation score
- * reaches within proactive compaction thresholds (as determined by the
- * proactiveness tunable).
+ * compact_node() - compact all zones within a node
+ * @pgdat: The node page data
+ * @proactive: Whether the compaction is proactive
  *
- * It is possible that the function returns before reaching score targets
- * due to various back-off conditions, such as, contention on per-node or
- * per-zone locks.
+ * For proactive compaction, compact till each zone's fragmentation score
+ * reaches within proactive compaction thresholds (as determined by the
+ * proactiveness tunable), it is possible that the function returns before
+ * reaching score targets due to various back-off conditions, such as,
+ * contention on per-node or per-zone locks.
  */
-static void proactive_compact_node(pg_data_t *pgdat)
+static void compact_node(pg_data_t *pgdat, bool proactive)
 {
 	int zoneid;
 	struct zone *zone;
 	struct compact_control cc = {
 		.order = -1,
-		.mode = MIGRATE_SYNC_LIGHT,
+		.mode = proactive ? MIGRATE_SYNC_LIGHT : MIGRATE_SYNC,
 		.ignore_skip_hint = true,
 		.whole_zone = true,
 		.gfp_mask = GFP_KERNEL,
-		.proactive_compaction = true,
+		.proactive_compaction = proactive,
 	};
 
 	for (zoneid = 0; zoneid < MAX_NR_ZONES; zoneid++) {
@@ -2826,41 +2828,16 @@ static void proactive_compact_node(pg_da
 
 		compact_zone(&cc, NULL);
 
-		count_compact_events(KCOMPACTD_MIGRATE_SCANNED,
-				     cc.total_migrate_scanned);
-		count_compact_events(KCOMPACTD_FREE_SCANNED,
-				     cc.total_free_scanned);
-	}
-}
-
-/* Compact all zones within a node */
-static void compact_node(int nid)
-{
-	pg_data_t *pgdat = NODE_DATA(nid);
-	int zoneid;
-	struct zone *zone;
-	struct compact_control cc = {
-		.order = -1,
-		.mode = MIGRATE_SYNC,
-		.ignore_skip_hint = true,
-		.whole_zone = true,
-		.gfp_mask = GFP_KERNEL,
-	};
-
-
-	for (zoneid = 0; zoneid < MAX_NR_ZONES; zoneid++) {
-
-		zone = &pgdat->node_zones[zoneid];
-		if (!populated_zone(zone))
-			continue;
-
-		cc.zone = zone;
-
-		compact_zone(&cc, NULL);
+		if (proactive) {
+			count_compact_events(KCOMPACTD_MIGRATE_SCANNED,
+					     cc.total_migrate_scanned);
+			count_compact_events(KCOMPACTD_FREE_SCANNED,
+					     cc.total_free_scanned);
+		}
 	}
 }
 
-/* Compact all nodes in the system */
+/* Compact all zones of all nodes in the system */
 static void compact_nodes(void)
 {
 	int nid;
@@ -2869,7 +2846,7 @@ static void compact_nodes(void)
 	lru_add_drain_all();
 
 	for_each_online_node(nid)
-		compact_node(nid);
+		compact_node(NODE_DATA(nid), false);
 }
 
 static int compaction_proactiveness_sysctl_handler(struct ctl_table *table, int write,
@@ -2931,7 +2908,7 @@ static ssize_t compact_store(struct devi
 		/* Flush pending updates to the LRU lists */
 		lru_add_drain_all();
 
-		compact_node(nid);
+		compact_node(NODE_DATA(nid), false);
 	}
 
 	return count;
@@ -3140,7 +3117,7 @@ static int kcompactd(void *p)
 			unsigned int prev_score, score;
 
 			prev_score = fragmentation_score_node(pgdat);
-			proactive_compact_node(pgdat);
+			compact_node(pgdat, true);
 			score = fragmentation_score_node(pgdat);
 			/*
 			 * Defer proactive compaction if the fragmentation
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-compaction-early-termination-in-compact_nodes.patch

