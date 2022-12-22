Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64861C4167B
	for <mm-commits@archiver.kernel.org>; Thu, 22 Dec 2022 21:43:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbiLVVnq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 22 Dec 2022 16:43:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbiLVVno (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 22 Dec 2022 16:43:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC97326AE4
        for <mm-commits@vger.kernel.org>; Thu, 22 Dec 2022 13:43:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7196061DAC
        for <mm-commits@vger.kernel.org>; Thu, 22 Dec 2022 21:43:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C90CAC433D2;
        Thu, 22 Dec 2022 21:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671745421;
        bh=4fNpFpFb3Ha8xftEWvBJIo+fSJF3KN0fXGZES52rpSI=;
        h=Date:To:From:Subject:From;
        b=xG52UKTI69FPigYsYIU70IRWkSnfEwTxn4kwWuIrCtvPrhH5iVU4QJAybygsMxSZ5
         HhgYZyKsHee4yXB1O8zsewzQYR5K5RaKwY9B+KPmTHrwZ938tnKAnEm6Jpncd8zFRV
         5zYCMc0yOu1vFbqxopnPCa9rbnuQUYnR8VmgkicM=
Date:   Thu, 22 Dec 2022 13:43:41 -0800
To:     mm-commits@vger.kernel.org, surenb@google.com, rppt@kernel.org,
        roman.gushchin@linux.dev, Michael@MichaelLarabel.com,
        mhocko@kernel.org, hannes@cmpxchg.org, corbet@lwn.net,
        yuzhao@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-multi-gen-lru-remove-aging-fairness-safeguard.patch added to mm-unstable branch
Message-Id: <20221222214341.C90CAC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: multi-gen LRU: remove aging fairness safeguard
has been added to the -mm mm-unstable branch.  Its filename is
     mm-multi-gen-lru-remove-aging-fairness-safeguard.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-multi-gen-lru-remove-aging-fairness-safeguard.patch

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
From: Yu Zhao <yuzhao@google.com>
Subject: mm: multi-gen LRU: remove aging fairness safeguard
Date: Wed, 21 Dec 2022 21:19:02 -0700

Recall that the aging produces the youngest generation: first it scans
for accessed folios and updates their gen counters; then it increments
lrugen->max_seq.

The current aging fairness safeguard for kswapd uses two passes to
ensure the fairness to multiple eligible memcgs. On the first pass,
which is shared with the eviction, it checks whether all eligible
memcgs are low on cold folios. If so, it requires a second pass, on
which it ages all those memcgs at the same time.

With memcg LRU, the aging, while ensuring eventual fairness, will run
when necessary. Therefore the current aging fairness safeguard for
kswapd will not be needed.

Note that memcg LRU only applies to global reclaim. For memcg reclaim,
the aging can be unfair to different memcgs, i.e., their
lrugen->max_seq can be incremented at different paces.

Link: https://lkml.kernel.org/r/20221222041905.2431096-5-yuzhao@google.com
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


--- a/mm/vmscan.c~mm-multi-gen-lru-remove-aging-fairness-safeguard
+++ a/mm/vmscan.c
@@ -137,7 +137,6 @@ struct scan_control {
 
 #ifdef CONFIG_LRU_GEN
 	/* help kswapd make better choices among multiple memcgs */
-	unsigned int memcgs_need_aging:1;
 	unsigned long last_reclaimed;
 #endif
 
@@ -4468,7 +4467,7 @@ done:
 	return true;
 }
 
-static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq, unsigned long *min_seq,
+static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
 			     struct scan_control *sc, bool can_swap, unsigned long *nr_to_scan)
 {
 	int gen, type, zone;
@@ -4477,6 +4476,13 @@ static bool should_run_aging(struct lruv
 	unsigned long total = 0;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
+	DEFINE_MIN_SEQ(lruvec);
+
+	/* whether this lruvec is completely out of cold folios */
+	if (min_seq[!can_swap] + MIN_NR_GENS > max_seq) {
+		*nr_to_scan = 0;
+		return true;
+	}
 
 	for (type = !can_swap; type < ANON_AND_FILE; type++) {
 		unsigned long seq;
@@ -4505,8 +4511,6 @@ static bool should_run_aging(struct lruv
 	 * stalls when the number of generations reaches MIN_NR_GENS. Hence, the
 	 * ideal number of generations is MIN_NR_GENS+1.
 	 */
-	if (min_seq[!can_swap] + MIN_NR_GENS > max_seq)
-		return true;
 	if (min_seq[!can_swap] + MIN_NR_GENS < max_seq)
 		return false;
 
@@ -4525,40 +4529,54 @@ static bool should_run_aging(struct lruv
 	return false;
 }
 
-static bool age_lruvec(struct lruvec *lruvec, struct scan_control *sc, unsigned long min_ttl)
+static bool lruvec_is_sizable(struct lruvec *lruvec, struct scan_control *sc)
 {
-	bool need_aging;
-	unsigned long nr_to_scan;
-	int swappiness = get_swappiness(lruvec, sc);
+	int gen, type, zone;
+	unsigned long total = 0;
+	bool can_swap = get_swappiness(lruvec, sc);
+	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	DEFINE_MAX_SEQ(lruvec);
 	DEFINE_MIN_SEQ(lruvec);
 
-	VM_WARN_ON_ONCE(sc->memcg_low_reclaim);
+	for (type = !can_swap; type < ANON_AND_FILE; type++) {
+		unsigned long seq;
 
-	mem_cgroup_calculate_protection(NULL, memcg);
+		for (seq = min_seq[type]; seq <= max_seq; seq++) {
+			gen = lru_gen_from_seq(seq);
 
-	if (mem_cgroup_below_min(NULL, memcg))
-		return false;
+			for (zone = 0; zone < MAX_NR_ZONES; zone++)
+				total += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
+		}
+	}
 
-	need_aging = should_run_aging(lruvec, max_seq, min_seq, sc, swappiness, &nr_to_scan);
+	/* whether the size is big enough to be helpful */
+	return mem_cgroup_online(memcg) ? (total >> sc->priority) : total;
+}
 
-	if (min_ttl) {
-		int gen = lru_gen_from_seq(min_seq[LRU_GEN_FILE]);
-		unsigned long birth = READ_ONCE(lruvec->lrugen.timestamps[gen]);
+static bool lruvec_is_reclaimable(struct lruvec *lruvec, struct scan_control *sc,
+				  unsigned long min_ttl)
+{
+	int gen;
+	unsigned long birth;
+	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
+	DEFINE_MIN_SEQ(lruvec);
 
-		if (time_is_after_jiffies(birth + min_ttl))
-			return false;
+	VM_WARN_ON_ONCE(sc->memcg_low_reclaim);
 
-		/* the size is likely too small to be helpful */
-		if (!nr_to_scan && sc->priority != DEF_PRIORITY)
-			return false;
-	}
+	/* see the comment on lru_gen_folio */
+	gen = lru_gen_from_seq(min_seq[LRU_GEN_FILE]);
+	birth = READ_ONCE(lruvec->lrugen.timestamps[gen]);
 
-	if (need_aging)
-		try_to_inc_max_seq(lruvec, max_seq, sc, swappiness, false);
+	if (time_is_after_jiffies(birth + min_ttl))
+		return false;
 
-	return true;
+	if (!lruvec_is_sizable(lruvec, sc))
+		return false;
+
+	mem_cgroup_calculate_protection(NULL, memcg);
+
+	return !mem_cgroup_below_min(NULL, memcg);
 }
 
 /* to protect the working set of the last N jiffies */
@@ -4567,46 +4585,32 @@ static unsigned long lru_gen_min_ttl __r
 static void lru_gen_age_node(struct pglist_data *pgdat, struct scan_control *sc)
 {
 	struct mem_cgroup *memcg;
-	bool success = false;
 	unsigned long min_ttl = READ_ONCE(lru_gen_min_ttl);
 
 	VM_WARN_ON_ONCE(!current_is_kswapd());
 
 	sc->last_reclaimed = sc->nr_reclaimed;
 
-	/*
-	 * To reduce the chance of going into the aging path, which can be
-	 * costly, optimistically skip it if the flag below was cleared in the
-	 * eviction path. This improves the overall performance when multiple
-	 * memcgs are available.
-	 */
-	if (!sc->memcgs_need_aging) {
-		sc->memcgs_need_aging = true;
+	/* check the order to exclude compaction-induced reclaim */
+	if (!min_ttl || sc->order || sc->priority == DEF_PRIORITY)
 		return;
-	}
-
-	set_mm_walk(pgdat);
 
 	memcg = mem_cgroup_iter(NULL, NULL, NULL);
 	do {
 		struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);
 
-		if (age_lruvec(lruvec, sc, min_ttl))
-			success = true;
+		if (lruvec_is_reclaimable(lruvec, sc, min_ttl)) {
+			mem_cgroup_iter_break(NULL, memcg);
+			return;
+		}
 
 		cond_resched();
 	} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)));
 
-	clear_mm_walk();
-
-	/* check the order to exclude compaction-induced reclaim */
-	if (success || !min_ttl || sc->order)
-		return;
-
 	/*
 	 * The main goal is to OOM kill if every generation from all memcgs is
 	 * younger than min_ttl. However, another possibility is all memcgs are
-	 * either below min or empty.
+	 * either too small or below min.
 	 */
 	if (mutex_trylock(&oom_lock)) {
 		struct oom_control oc = {
@@ -5114,34 +5118,28 @@ retry:
  *    reclaim.
  */
 static unsigned long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc,
-				    bool can_swap, bool *need_aging)
+				    bool can_swap)
 {
 	unsigned long nr_to_scan;
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	DEFINE_MAX_SEQ(lruvec);
-	DEFINE_MIN_SEQ(lruvec);
 
 	if (mem_cgroup_below_min(sc->target_mem_cgroup, memcg) ||
 	    (mem_cgroup_below_low(sc->target_mem_cgroup, memcg) &&
 	     !sc->memcg_low_reclaim))
 		return 0;
 
-	*need_aging = should_run_aging(lruvec, max_seq, min_seq, sc, can_swap, &nr_to_scan);
-	if (!*need_aging)
+	if (!should_run_aging(lruvec, max_seq, sc, can_swap, &nr_to_scan))
 		return nr_to_scan;
 
 	/* skip the aging path at the default priority */
 	if (sc->priority == DEF_PRIORITY)
-		goto done;
+		return nr_to_scan;
 
-	/* leave the work to lru_gen_age_node() */
-	if (current_is_kswapd())
-		return 0;
+	try_to_inc_max_seq(lruvec, max_seq, sc, can_swap, false);
 
-	if (try_to_inc_max_seq(lruvec, max_seq, sc, can_swap, false))
-		return nr_to_scan;
-done:
-	return min_seq[!can_swap] + MIN_NR_GENS <= max_seq ? nr_to_scan : 0;
+	/* skip this lruvec as it's low on cold folios */
+	return 0;
 }
 
 static unsigned long get_nr_to_reclaim(struct scan_control *sc)
@@ -5160,9 +5158,7 @@ static unsigned long get_nr_to_reclaim(s
 static void lru_gen_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 {
 	struct blk_plug plug;
-	bool need_aging = false;
 	unsigned long scanned = 0;
-	unsigned long reclaimed = sc->nr_reclaimed;
 	unsigned long nr_to_reclaim = get_nr_to_reclaim(sc);
 
 	lru_add_drain();
@@ -5183,13 +5179,13 @@ static void lru_gen_shrink_lruvec(struct
 		else
 			swappiness = 0;
 
-		nr_to_scan = get_nr_to_scan(lruvec, sc, swappiness, &need_aging);
+		nr_to_scan = get_nr_to_scan(lruvec, sc, swappiness);
 		if (!nr_to_scan)
-			goto done;
+			break;
 
 		delta = evict_folios(lruvec, sc, swappiness);
 		if (!delta)
-			goto done;
+			break;
 
 		scanned += delta;
 		if (scanned >= nr_to_scan)
@@ -5201,10 +5197,6 @@ static void lru_gen_shrink_lruvec(struct
 		cond_resched();
 	}
 
-	/* see the comment in lru_gen_age_node() */
-	if (sc->nr_reclaimed - reclaimed >= MIN_LRU_BATCH && !need_aging)
-		sc->memcgs_need_aging = false;
-done:
 	clear_mm_walk();
 
 	blk_finish_plug(&plug);
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-multi-gen-lru-rename-lru_gen_struct-to-lru_gen_folio.patch
mm-multi-gen-lru-rename-lrugen-lists-to-lrugen-folios.patch
mm-multi-gen-lru-remove-eviction-fairness-safeguard.patch
mm-multi-gen-lru-remove-aging-fairness-safeguard.patch
mm-multi-gen-lru-shuffle-should_run_aging.patch
mm-multi-gen-lru-per-node-lru_gen_folio-lists.patch
mm-multi-gen-lru-clarify-scan_control-flags.patch
mm-multi-gen-lru-simplify-arch_has_hw_pte_young-check.patch

