Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2DB520311
	for <mm-commits@vger.kernel.org>; Thu,  8 Feb 2024 01:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707357191; cv=none; b=PjITgoguGaQeM9CKEGxJLD8t0tMj0zyF7UwS+sngOcwqKC4iVVUzmCPnNNxvnKQPCKH4xWpqHuQSnPe1S5g4o7hPiLod0GGhCA8kOF0tda8L73OrurVExuGeN6DZ0BTXI+6f5/rFrQp0TpV5DbQTYSAK2mbuLgKisTG2/4wd+mM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707357191; c=relaxed/simple;
	bh=O1WO44wJm1wnJ98FXBzYgKQfjm6RItd+VTRjyiZdjZM=;
	h=Date:To:From:Subject:Message-Id; b=gYSaNaF5qkiUi3dA4Hevdrb2UQfEz2ZhDGyR6BTM6VgwJyvKr2+ELXl6Vo09pC+fN+xGS6hatQYpySPsk3eXXjhhKTELoUQLc5OAF3WRaN3imtWWxlGN3zD5CEJvlI5J/UW6QHOuYE3W4WgSkWa8IhYX8CoCV7sTCs9xI8eggEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sWp10GPT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sWp10GPT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60F41C433C7;
	Thu,  8 Feb 2024 01:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707357190;
	bh=O1WO44wJm1wnJ98FXBzYgKQfjm6RItd+VTRjyiZdjZM=;
	h=Date:To:From:Subject:From;
	b=sWp10GPT6SsefpsnnnH8iZK2bRQEfE+TZ+az/ytDmwTHVl05Sc6h8fQJsv6NFCcp2
	 AMWNzo5NwYtYR10P81UXcZn7USzjLVbGtDeW6PcKAEhF/jzjWWrUTAMQONX5rkrAdd
	 +l0DIWCK3Eu3mYab7FPRqvExQJQMwMx2g8ViUkts=
Date: Wed, 07 Feb 2024 17:53:09 -0800
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-refactor-compact_node.patch added to mm-unstable branch
Message-Id: <20240208015310.60F41C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: compaction: refactor compact_node()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-refactor-compact_node.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-refactor-compact_node.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: compaction: refactor compact_node()
Date: Thu, 8 Feb 2024 09:36:07 +0800

Refactor compact_node() to handle both proactive and synchronous compact
memory, which cleanups code a bit.

Link: https://lkml.kernel.org/r/20240208013607.1731817-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   65 ++++++++++++++--------------------------------
 1 file changed, 21 insertions(+), 44 deletions(-)

--- a/mm/compaction.c~mm-compaction-refactor-compact_node
+++ a/mm/compaction.c
@@ -2885,25 +2885,27 @@ enum compact_result try_to_compact_pages
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
@@ -2915,41 +2917,16 @@ static void proactive_compact_node(pg_da
 
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
@@ -2958,7 +2935,7 @@ static void compact_nodes(void)
 	lru_add_drain_all();
 
 	for_each_online_node(nid)
-		compact_node(nid);
+		compact_node(NODE_DATA(nid), false);
 }
 
 static int compaction_proactiveness_sysctl_handler(struct ctl_table *table, int write,
@@ -3020,7 +2997,7 @@ static ssize_t compact_store(struct devi
 		/* Flush pending updates to the LRU lists */
 		lru_add_drain_all();
 
-		compact_node(nid);
+		compact_node(NODE_DATA(nid), false);
 	}
 
 	return count;
@@ -3229,7 +3206,7 @@ static int kcompactd(void *p)
 			unsigned int prev_score, score;
 
 			prev_score = fragmentation_score_node(pgdat);
-			proactive_compact_node(pgdat);
+			compact_node(pgdat, true);
 			score = fragmentation_score_node(pgdat);
 			/*
 			 * Defer proactive compaction if the fragmentation
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-memory-use-nth_page-in-clear-copy_subpage.patch
s390-use-pfn_swap_entry_folio-in-ptep_zap_swap_entry.patch
mm-use-pfn_swap_entry_folio-in-__split_huge_pmd_locked.patch
mm-use-pfn_swap_entry_to_folio-in-zap_huge_pmd.patch
mm-use-pfn_swap_entry_folio-in-copy_nonpresent_pte.patch
mm-convert-to-should_zap_page-to-should_zap_folio.patch
mm-convert-to-should_zap_page-to-should_zap_folio-fix.patch
mm-convert-mm_counter-to-take-a-folio.patch
mm-convert-mm_counter_file-to-take-a-folio.patch
mm-memory-move-mem_cgroup_charge-into-alloc_anon_folio.patch
mm-compaction-refactor-compact_node.patch

