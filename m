Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 398C2C38159
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:19:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbjASBTH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:19:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbjASBRM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:17:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD3A5689D2
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:15:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7CCC4B81F6C
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:15:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25E84C433F1;
        Thu, 19 Jan 2023 01:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090921;
        bh=Y/DykVzeU7SFQSDUMivQnR1FhL3V2fW7EDDSQcIEb6E=;
        h=Date:To:From:Subject:From;
        b=T//y1YAzRYUrvfsZEB7yM/FCwneR+BNLKu3haIZmF14v0FmtFfKBVh1Cxv/JrEDEX
         kayq8LeOEfkzk/TKmHcky97r9G6Cij6nrV5XQ3PddL2w7oZzP0SP5pVCQCs6IzF3LG
         6u6kwFfDB4sky87nVP6ysqD+mYH2DSZfH+vKpwZI=
Date:   Wed, 18 Jan 2023 17:15:20 -0800
To:     mm-commits@vger.kernel.org, surenb@google.com, rppt@kernel.org,
        roman.gushchin@linux.dev, Michael@MichaelLarabel.com,
        mhocko@kernel.org, hannes@cmpxchg.org, corbet@lwn.net,
        yuzhao@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-multi-gen-lru-remove-eviction-fairness-safeguard.patch removed from -mm tree
Message-Id: <20230119011521.25E84C433F1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: multi-gen LRU: remove eviction fairness safeguard
has been removed from the -mm tree.  Its filename was
     mm-multi-gen-lru-remove-eviction-fairness-safeguard.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yu Zhao <yuzhao@google.com>
Subject: mm: multi-gen LRU: remove eviction fairness safeguard
Date: Wed, 21 Dec 2022 21:19:01 -0700

Recall that the eviction consumes the oldest generation: first it
bucket-sorts folios whose gen counters were updated by the aging and
reclaims the rest; then it increments lrugen->min_seq.

The current eviction fairness safeguard for global reclaim has a
dilemma: when there are multiple eligible memcgs, should it continue
or stop upon meeting the reclaim goal? If it continues, it overshoots
and increases direct reclaim latency; if it stops, it loses fairness
between memcgs it has taken memory away from and those it has yet to.

With memcg LRU, the eviction, while ensuring eventual fairness, will
stop upon meeting its goal. Therefore the current eviction fairness
safeguard for global reclaim will not be needed.

Note that memcg LRU only applies to global reclaim. For memcg reclaim,
the eviction will continue, even if it is overshooting. This becomes
unconditional due to code simplification.

Link: https://lkml.kernel.org/r/20221222041905.2431096-4-yuzhao@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Michael Larabel <Michael@MichaelLarabel.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   81 ++++++++++++++------------------------------------
 1 file changed, 23 insertions(+), 58 deletions(-)

--- a/mm/vmscan.c~mm-multi-gen-lru-remove-eviction-fairness-safeguard
+++ a/mm/vmscan.c
@@ -449,6 +449,11 @@ static bool cgroup_reclaim(struct scan_c
 	return sc->target_mem_cgroup;
 }
 
+static bool global_reclaim(struct scan_control *sc)
+{
+	return !sc->target_mem_cgroup || mem_cgroup_is_root(sc->target_mem_cgroup);
+}
+
 /**
  * writeback_throttling_sane - is the usual dirty throttling mechanism available?
  * @sc: scan_control in question
@@ -499,6 +504,11 @@ static bool cgroup_reclaim(struct scan_c
 	return false;
 }
 
+static bool global_reclaim(struct scan_control *sc)
+{
+	return true;
+}
+
 static bool writeback_throttling_sane(struct scan_control *sc)
 {
 	return true;
@@ -5006,8 +5016,7 @@ static int isolate_folios(struct lruvec
 	return scanned;
 }
 
-static int evict_folios(struct lruvec *lruvec, struct scan_control *sc, int swappiness,
-			bool *need_swapping)
+static int evict_folios(struct lruvec *lruvec, struct scan_control *sc, int swappiness)
 {
 	int type;
 	int scanned;
@@ -5096,9 +5105,6 @@ retry:
 		goto retry;
 	}
 
-	if (need_swapping && type == LRU_GEN_ANON)
-		*need_swapping = true;
-
 	return scanned;
 }
 
@@ -5138,67 +5144,26 @@ done:
 	return min_seq[!can_swap] + MIN_NR_GENS <= max_seq ? nr_to_scan : 0;
 }
 
-static bool should_abort_scan(struct lruvec *lruvec, unsigned long seq,
-			      struct scan_control *sc, bool need_swapping)
+static unsigned long get_nr_to_reclaim(struct scan_control *sc)
 {
-	int i;
-	DEFINE_MAX_SEQ(lruvec);
-
-	if (!current_is_kswapd()) {
-		/* age each memcg at most once to ensure fairness */
-		if (max_seq - seq > 1)
-			return true;
-
-		/* over-swapping can increase allocation latency */
-		if (sc->nr_reclaimed >= sc->nr_to_reclaim && need_swapping)
-			return true;
-
-		/* give this thread a chance to exit and free its memory */
-		if (fatal_signal_pending(current)) {
-			sc->nr_reclaimed += MIN_LRU_BATCH;
-			return true;
-		}
-
-		if (cgroup_reclaim(sc))
-			return false;
-	} else if (sc->nr_reclaimed - sc->last_reclaimed < sc->nr_to_reclaim)
-		return false;
-
-	/* keep scanning at low priorities to ensure fairness */
-	if (sc->priority > DEF_PRIORITY - 2)
-		return false;
-
-	/*
-	 * A minimum amount of work was done under global memory pressure. For
-	 * kswapd, it may be overshooting. For direct reclaim, the allocation
-	 * may succeed if all suitable zones are somewhat safe. In either case,
-	 * it's better to stop now, and restart later if necessary.
-	 */
-	for (i = 0; i <= sc->reclaim_idx; i++) {
-		unsigned long wmark;
-		struct zone *zone = lruvec_pgdat(lruvec)->node_zones + i;
-
-		if (!managed_zone(zone))
-			continue;
-
-		wmark = current_is_kswapd() ? high_wmark_pages(zone) : low_wmark_pages(zone);
-		if (wmark > zone_page_state(zone, NR_FREE_PAGES))
-			return false;
-	}
+	/* don't abort memcg reclaim to ensure fairness */
+	if (!global_reclaim(sc))
+		return -1;
 
-	sc->nr_reclaimed += MIN_LRU_BATCH;
+	/* discount the previous progress for kswapd */
+	if (current_is_kswapd())
+		return sc->nr_to_reclaim + sc->last_reclaimed;
 
-	return true;
+	return max(sc->nr_to_reclaim, compact_gap(sc->order));
 }
 
 static void lru_gen_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 {
 	struct blk_plug plug;
 	bool need_aging = false;
-	bool need_swapping = false;
 	unsigned long scanned = 0;
 	unsigned long reclaimed = sc->nr_reclaimed;
-	DEFINE_MAX_SEQ(lruvec);
+	unsigned long nr_to_reclaim = get_nr_to_reclaim(sc);
 
 	lru_add_drain();
 
@@ -5222,7 +5187,7 @@ static void lru_gen_shrink_lruvec(struct
 		if (!nr_to_scan)
 			goto done;
 
-		delta = evict_folios(lruvec, sc, swappiness, &need_swapping);
+		delta = evict_folios(lruvec, sc, swappiness);
 		if (!delta)
 			goto done;
 
@@ -5230,7 +5195,7 @@ static void lru_gen_shrink_lruvec(struct
 		if (scanned >= nr_to_scan)
 			break;
 
-		if (should_abort_scan(lruvec, max_seq, sc, need_swapping))
+		if (sc->nr_reclaimed >= nr_to_reclaim)
 			break;
 
 		cond_resched();
@@ -5677,7 +5642,7 @@ static int run_eviction(struct lruvec *l
 		if (sc->nr_reclaimed >= nr_to_reclaim)
 			return 0;
 
-		if (!evict_folios(lruvec, sc, swappiness, NULL))
+		if (!evict_folios(lruvec, sc, swappiness))
 			return 0;
 
 		cond_resched();
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-multi-gen-lru-fix-crash-during-cgroup-migration.patch

