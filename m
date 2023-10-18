Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 325F0CDB482
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:36:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235346AbjJRVgx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:36:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235263AbjJRVgG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:36:06 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62957183
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:35:35 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E72CDC433CA;
        Wed, 18 Oct 2023 21:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697664920;
        bh=uUVCNMDoK5j5Xgv+bf95L1hMbe8HWI4VO6VFLIjm5pc=;
        h=Date:To:From:Subject:From;
        b=rmI8VBuYQQlVf3R/cjR1HvilSxjs06UZWR1gNtY4TSdqZAMiy2uaE2mZ334jXaMS5
         mRET845gUVH2cLRMDYml7hmDJzvnBukywvZtQMlB9vVNGEz8x6I6hKXgYgw04NxEax
         ojZK1+2cw9fcM4ad0EBXS3T75RrBjKh1Vrhp9YOg=
Date:   Wed, 18 Oct 2023 14:35:19 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, vbabka@suse.cz,
        tjmercier@google.com, sj@kernel.org, rostedt@goodmis.org,
        kaleshsingh@google.com, hannes@cmpxchg.org,
        jaewon31.kim@samsung.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-multi-gen-lru-reuse-some-legacy-trace-events.patch removed from -mm tree
Message-Id: <20231018213519.E72CDC433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: multi-gen LRU: reuse some legacy trace events
has been removed from the -mm tree.  Its filename was
     mm-multi-gen-lru-reuse-some-legacy-trace-events.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jaewon Kim <jaewon31.kim@samsung.com>
Subject: mm: multi-gen LRU: reuse some legacy trace events
Date: Tue, 3 Oct 2023 20:41:55 +0900

As the legacy lru provides, the mglru needs some trace events for
debugging.  Let's reuse following legacy events for the mglru.

  trace_mm_vmscan_lru_isolate
  trace_mm_vmscan_lru_shrink_inactive

Here's an example
  mm_vmscan_lru_isolate: classzone=2 order=0 nr_requested=4096 nr_scanned=64 nr_skipped=0 nr_taken=64 lru=inactive_file
  mm_vmscan_lru_shrink_inactive: nid=0 nr_scanned=64 nr_reclaimed=63 nr_dirty=0 nr_writeback=0 nr_congested=0 nr_immediate=0 nr_activate_anon=0 nr_activate_file=1 nr_ref_keep=0 nr_unmap_fail=0 priority=2 flags=RECLAIM_WB_FILE|RECLAIM_WB_ASYNC

Link: https://lkml.kernel.org/r/20231003114155.21869-1-jaewon31.kim@samsung.com
Signed-off-by: Jaewon Kim <jaewon31.kim@samsung.com>
Acked-by: Yu Zhao <yuzhao@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: T.J. Mercier <tjmercier@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

--- a/mm/vmscan.c~mm-multi-gen-lru-reuse-some-legacy-trace-events
+++ a/mm/vmscan.c
@@ -4304,6 +4304,7 @@ static int scan_folios(struct lruvec *lr
 	int sorted = 0;
 	int scanned = 0;
 	int isolated = 0;
+	int skipped = 0;
 	int remaining = MAX_LRU_BATCH;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
@@ -4317,7 +4318,7 @@ static int scan_folios(struct lruvec *lr
 
 	for (i = MAX_NR_ZONES; i > 0; i--) {
 		LIST_HEAD(moved);
-		int skipped = 0;
+		int skipped_zone = 0;
 		int zone = (sc->reclaim_idx + i) % MAX_NR_ZONES;
 		struct list_head *head = &lrugen->folios[gen][type][zone];
 
@@ -4339,16 +4340,17 @@ static int scan_folios(struct lruvec *lr
 				isolated += delta;
 			} else {
 				list_move(&folio->lru, &moved);
-				skipped += delta;
+				skipped_zone += delta;
 			}
 
-			if (!--remaining || max(isolated, skipped) >= MIN_LRU_BATCH)
+			if (!--remaining || max(isolated, skipped_zone) >= MIN_LRU_BATCH)
 				break;
 		}
 
-		if (skipped) {
+		if (skipped_zone) {
 			list_splice(&moved, head);
-			__count_zid_vm_events(PGSCAN_SKIP, zone, skipped);
+			__count_zid_vm_events(PGSCAN_SKIP, zone, skipped_zone);
+			skipped += skipped_zone;
 		}
 
 		if (!remaining || isolated >= MIN_LRU_BATCH)
@@ -4363,6 +4365,9 @@ static int scan_folios(struct lruvec *lr
 	__count_memcg_events(memcg, item, isolated);
 	__count_memcg_events(memcg, PGREFILL, sorted);
 	__count_vm_events(PGSCAN_ANON + type, isolated);
+	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, MAX_LRU_BATCH,
+				scanned, skipped, isolated,
+				type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
 
 	/*
 	 * There might not be eligible folios due to reclaim_idx. Check the
@@ -4493,6 +4498,9 @@ static int evict_folios(struct lruvec *l
 retry:
 	reclaimed = shrink_folio_list(&list, pgdat, sc, &stat, false);
 	sc->nr_reclaimed += reclaimed;
+	trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
+			scanned, reclaimed, &stat, sc->priority,
+			type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
 
 	list_for_each_entry_safe_reverse(folio, next, &list, lru) {
 		if (!folio_evictable(folio)) {
_

Patches currently in -mm which might be from jaewon31.kim@samsung.com are


