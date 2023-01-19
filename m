Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABF33C677F1
	for <mm-commits@archiver.kernel.org>; Fri, 20 Jan 2023 05:28:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbjATF2x (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 20 Jan 2023 00:28:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229701AbjATF23 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jan 2023 00:28:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70F79474EC
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 21:23:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DCC1BB82764
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 22:47:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EDDAC433D2;
        Thu, 19 Jan 2023 22:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674168469;
        bh=u9FP+AKmHIejUdQ9+mdN3HiHsLSGHVy4Yusud19dKDg=;
        h=Date:To:From:Subject:From;
        b=X0FfsF5ahLyHMke7jNeIZcO/UR0BghpByDX4h1R1sI3XMfb/cMbXfjqTldXbZjRZx
         fD4CBQ8b3lUjMPs0i6UF4KQ1lE7AAe2+w+aks84QhTUImq8gYvy5F2WX2CW8yFVtfI
         ILBAdsZivznwhZlw9p7ymXB4GGDJxpyRYPOMVFHE=
Date:   Thu, 19 Jan 2023 14:47:48 -0800
To:     mm-commits@vger.kernel.org, yuzhao@google.com, talumbau@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-multi-gen-lru-section-for-memcg-lru.patch added to mm-unstable branch
Message-Id: <20230119224749.6EDDAC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: multi-gen LRU: section for memcg LRU
has been added to the -mm mm-unstable branch.  Its filename is
     mm-multi-gen-lru-section-for-memcg-lru.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-multi-gen-lru-section-for-memcg-lru.patch

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
From: "T.J. Alumbaugh" <talumbau@google.com>
Subject: mm: multi-gen LRU: section for memcg LRU
Date: Wed, 18 Jan 2023 00:18:24 +0000

Move memcg LRU code into a dedicated section.  Improve the design doc to
outline its architecture.

Link: https://lkml.kernel.org/r/20230118001827.1040870-5-talumbau@google.com
Signed-off-by: T.J. Alumbaugh <talumbau@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/Documentation/mm/multigen_lru.rst~mm-multi-gen-lru-section-for-memcg-lru
+++ a/Documentation/mm/multigen_lru.rst
@@ -186,9 +186,40 @@ is false positive, the cost is an additi
 which may yield hot pages anyway. Parameters of the filter itself can
 control the false positive rate in the limit.
 
+Memcg LRU
+---------
+An memcg LRU is a per-node LRU of memcgs. It is also an LRU of LRUs,
+since each node and memcg combination has an LRU of folios (see
+``mem_cgroup_lruvec()``). Its goal is to improve the scalability of
+global reclaim, which is critical to system-wide memory overcommit in
+data centers. Note that memcg LRU only applies to global reclaim.
+
+The basic structure of an memcg LRU can be understood by an analogy to
+the active/inactive LRU (of folios):
+
+1. It has the young and the old (generations), i.e., the counterparts
+   to the active and the inactive;
+2. The increment of ``max_seq`` triggers promotion, i.e., the
+   counterpart to activation;
+3. Other events trigger similar operations, e.g., offlining an memcg
+   triggers demotion, i.e., the counterpart to deactivation.
+
+In terms of global reclaim, it has two distinct features:
+
+1. Sharding, which allows each thread to start at a random memcg (in
+   the old generation) and improves parallelism;
+2. Eventual fairness, which allows direct reclaim to bail out at will
+   and reduces latency without affecting fairness over some time.
+
+In terms of traversing memcgs during global reclaim, it improves the
+best-case complexity from O(n) to O(1) and does not affect the
+worst-case complexity O(n). Therefore, on average, it has a sublinear
+complexity.
+
 Summary
 -------
-The multi-gen LRU can be disassembled into the following parts:
+The multi-gen LRU (of folios) can be disassembled into the following
+parts:
 
 * Generations
 * Rmap walks
--- a/include/linux/mm_inline.h~mm-multi-gen-lru-section-for-memcg-lru
+++ a/include/linux/mm_inline.h
@@ -122,18 +122,6 @@ static inline bool lru_gen_in_fault(void
 	return current->in_lru_fault;
 }
 
-#ifdef CONFIG_MEMCG
-static inline int lru_gen_memcg_seg(struct lruvec *lruvec)
-{
-	return READ_ONCE(lruvec->lrugen.seg);
-}
-#else
-static inline int lru_gen_memcg_seg(struct lruvec *lruvec)
-{
-	return 0;
-}
-#endif
-
 static inline int lru_gen_from_seq(unsigned long seq)
 {
 	return seq % MAX_NR_GENS;
@@ -309,11 +297,6 @@ static inline bool lru_gen_in_fault(void
 	return false;
 }
 
-static inline int lru_gen_memcg_seg(struct lruvec *lruvec)
-{
-	return 0;
-}
-
 static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio, bool reclaiming)
 {
 	return false;
--- a/include/linux/mmzone.h~mm-multi-gen-lru-section-for-memcg-lru
+++ a/include/linux/mmzone.h
@@ -368,15 +368,6 @@ struct page_vma_mapped_walk;
 #define LRU_GEN_MASK		((BIT(LRU_GEN_WIDTH) - 1) << LRU_GEN_PGOFF)
 #define LRU_REFS_MASK		((BIT(LRU_REFS_WIDTH) - 1) << LRU_REFS_PGOFF)
 
-/* see the comment on MEMCG_NR_GENS */
-enum {
-	MEMCG_LRU_NOP,
-	MEMCG_LRU_HEAD,
-	MEMCG_LRU_TAIL,
-	MEMCG_LRU_OLD,
-	MEMCG_LRU_YOUNG,
-};
-
 #ifdef CONFIG_LRU_GEN
 
 enum {
@@ -557,7 +548,7 @@ void lru_gen_exit_memcg(struct mem_cgrou
 void lru_gen_online_memcg(struct mem_cgroup *memcg);
 void lru_gen_offline_memcg(struct mem_cgroup *memcg);
 void lru_gen_release_memcg(struct mem_cgroup *memcg);
-void lru_gen_rotate_memcg(struct lruvec *lruvec, int op);
+void lru_gen_soft_reclaim(struct lruvec *lruvec);
 
 #else /* !CONFIG_MEMCG */
 
@@ -608,7 +599,7 @@ static inline void lru_gen_release_memcg
 {
 }
 
-static inline void lru_gen_rotate_memcg(struct lruvec *lruvec, int op)
+static inline void lru_gen_soft_reclaim(struct lruvec *lruvec)
 {
 }
 
--- a/mm/memcontrol.c~mm-multi-gen-lru-section-for-memcg-lru
+++ a/mm/memcontrol.c
@@ -476,12 +476,8 @@ static void mem_cgroup_update_tree(struc
 	struct mem_cgroup_tree_per_node *mctz;
 
 	if (lru_gen_enabled()) {
-		struct lruvec *lruvec = &memcg->nodeinfo[nid]->lruvec;
-
-		/* see the comment on MEMCG_NR_GENS */
-		if (soft_limit_excess(memcg) && lru_gen_memcg_seg(lruvec) != MEMCG_LRU_HEAD)
-			lru_gen_rotate_memcg(lruvec, MEMCG_LRU_HEAD);
-
+		if (soft_limit_excess(memcg))
+			lru_gen_soft_reclaim(&memcg->nodeinfo[nid]->lruvec);
 		return;
 	}
 
--- a/mm/vmscan.c~mm-multi-gen-lru-section-for-memcg-lru
+++ a/mm/vmscan.c
@@ -4706,6 +4706,148 @@ void lru_gen_look_around(struct page_vma
 }
 
 /******************************************************************************
+ *                          memcg LRU
+ ******************************************************************************/
+
+/* see the comment on MEMCG_NR_GENS */
+enum {
+	MEMCG_LRU_NOP,
+	MEMCG_LRU_HEAD,
+	MEMCG_LRU_TAIL,
+	MEMCG_LRU_OLD,
+	MEMCG_LRU_YOUNG,
+};
+
+#ifdef CONFIG_MEMCG
+
+static int lru_gen_memcg_seg(struct lruvec *lruvec)
+{
+	return READ_ONCE(lruvec->lrugen.seg);
+}
+
+static void lru_gen_rotate_memcg(struct lruvec *lruvec, int op)
+{
+	int seg;
+	int old, new;
+	int bin = get_random_u32_below(MEMCG_NR_BINS);
+	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
+
+	spin_lock(&pgdat->memcg_lru.lock);
+
+	VM_WARN_ON_ONCE(hlist_nulls_unhashed(&lruvec->lrugen.list));
+
+	seg = 0;
+	new = old = lruvec->lrugen.gen;
+
+	/* see the comment on MEMCG_NR_GENS */
+	if (op == MEMCG_LRU_HEAD)
+		seg = MEMCG_LRU_HEAD;
+	else if (op == MEMCG_LRU_TAIL)
+		seg = MEMCG_LRU_TAIL;
+	else if (op == MEMCG_LRU_OLD)
+		new = get_memcg_gen(pgdat->memcg_lru.seq);
+	else if (op == MEMCG_LRU_YOUNG)
+		new = get_memcg_gen(pgdat->memcg_lru.seq + 1);
+	else
+		VM_WARN_ON_ONCE(true);
+
+	hlist_nulls_del_rcu(&lruvec->lrugen.list);
+
+	if (op == MEMCG_LRU_HEAD || op == MEMCG_LRU_OLD)
+		hlist_nulls_add_head_rcu(&lruvec->lrugen.list, &pgdat->memcg_lru.fifo[new][bin]);
+	else
+		hlist_nulls_add_tail_rcu(&lruvec->lrugen.list, &pgdat->memcg_lru.fifo[new][bin]);
+
+	pgdat->memcg_lru.nr_memcgs[old]--;
+	pgdat->memcg_lru.nr_memcgs[new]++;
+
+	lruvec->lrugen.gen = new;
+	WRITE_ONCE(lruvec->lrugen.seg, seg);
+
+	if (!pgdat->memcg_lru.nr_memcgs[old] && old == get_memcg_gen(pgdat->memcg_lru.seq))
+		WRITE_ONCE(pgdat->memcg_lru.seq, pgdat->memcg_lru.seq + 1);
+
+	spin_unlock(&pgdat->memcg_lru.lock);
+}
+
+void lru_gen_online_memcg(struct mem_cgroup *memcg)
+{
+	int gen;
+	int nid;
+	int bin = get_random_u32_below(MEMCG_NR_BINS);
+
+	for_each_node(nid) {
+		struct pglist_data *pgdat = NODE_DATA(nid);
+		struct lruvec *lruvec = get_lruvec(memcg, nid);
+
+		spin_lock(&pgdat->memcg_lru.lock);
+
+		VM_WARN_ON_ONCE(!hlist_nulls_unhashed(&lruvec->lrugen.list));
+
+		gen = get_memcg_gen(pgdat->memcg_lru.seq);
+
+		hlist_nulls_add_tail_rcu(&lruvec->lrugen.list, &pgdat->memcg_lru.fifo[gen][bin]);
+		pgdat->memcg_lru.nr_memcgs[gen]++;
+
+		lruvec->lrugen.gen = gen;
+
+		spin_unlock(&pgdat->memcg_lru.lock);
+	}
+}
+
+void lru_gen_offline_memcg(struct mem_cgroup *memcg)
+{
+	int nid;
+
+	for_each_node(nid) {
+		struct lruvec *lruvec = get_lruvec(memcg, nid);
+
+		lru_gen_rotate_memcg(lruvec, MEMCG_LRU_OLD);
+	}
+}
+
+void lru_gen_release_memcg(struct mem_cgroup *memcg)
+{
+	int gen;
+	int nid;
+
+	for_each_node(nid) {
+		struct pglist_data *pgdat = NODE_DATA(nid);
+		struct lruvec *lruvec = get_lruvec(memcg, nid);
+
+		spin_lock(&pgdat->memcg_lru.lock);
+
+		VM_WARN_ON_ONCE(hlist_nulls_unhashed(&lruvec->lrugen.list));
+
+		gen = lruvec->lrugen.gen;
+
+		hlist_nulls_del_rcu(&lruvec->lrugen.list);
+		pgdat->memcg_lru.nr_memcgs[gen]--;
+
+		if (!pgdat->memcg_lru.nr_memcgs[gen] && gen == get_memcg_gen(pgdat->memcg_lru.seq))
+			WRITE_ONCE(pgdat->memcg_lru.seq, pgdat->memcg_lru.seq + 1);
+
+		spin_unlock(&pgdat->memcg_lru.lock);
+	}
+}
+
+void lru_gen_soft_reclaim(struct lruvec *lruvec)
+{
+	/* see the comment on MEMCG_NR_GENS */
+	if (lru_gen_memcg_seg(lruvec) != MEMCG_LRU_HEAD)
+		lru_gen_rotate_memcg(lruvec, MEMCG_LRU_HEAD);
+}
+
+#else /* !CONFIG_MEMCG */
+
+static int lru_gen_memcg_seg(struct lruvec *lruvec)
+{
+	return 0;
+}
+
+#endif
+
+/******************************************************************************
  *                          the eviction
  ******************************************************************************/
 
@@ -5397,53 +5539,6 @@ done:
 	pgdat->kswapd_failures = 0;
 }
 
-#ifdef CONFIG_MEMCG
-void lru_gen_rotate_memcg(struct lruvec *lruvec, int op)
-{
-	int seg;
-	int old, new;
-	int bin = get_random_u32_below(MEMCG_NR_BINS);
-	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
-
-	spin_lock(&pgdat->memcg_lru.lock);
-
-	VM_WARN_ON_ONCE(hlist_nulls_unhashed(&lruvec->lrugen.list));
-
-	seg = 0;
-	new = old = lruvec->lrugen.gen;
-
-	/* see the comment on MEMCG_NR_GENS */
-	if (op == MEMCG_LRU_HEAD)
-		seg = MEMCG_LRU_HEAD;
-	else if (op == MEMCG_LRU_TAIL)
-		seg = MEMCG_LRU_TAIL;
-	else if (op == MEMCG_LRU_OLD)
-		new = get_memcg_gen(pgdat->memcg_lru.seq);
-	else if (op == MEMCG_LRU_YOUNG)
-		new = get_memcg_gen(pgdat->memcg_lru.seq + 1);
-	else
-		VM_WARN_ON_ONCE(true);
-
-	hlist_nulls_del_rcu(&lruvec->lrugen.list);
-
-	if (op == MEMCG_LRU_HEAD || op == MEMCG_LRU_OLD)
-		hlist_nulls_add_head_rcu(&lruvec->lrugen.list, &pgdat->memcg_lru.fifo[new][bin]);
-	else
-		hlist_nulls_add_tail_rcu(&lruvec->lrugen.list, &pgdat->memcg_lru.fifo[new][bin]);
-
-	pgdat->memcg_lru.nr_memcgs[old]--;
-	pgdat->memcg_lru.nr_memcgs[new]++;
-
-	lruvec->lrugen.gen = new;
-	WRITE_ONCE(lruvec->lrugen.seg, seg);
-
-	if (!pgdat->memcg_lru.nr_memcgs[old] && old == get_memcg_gen(pgdat->memcg_lru.seq))
-		WRITE_ONCE(pgdat->memcg_lru.seq, pgdat->memcg_lru.seq + 1);
-
-	spin_unlock(&pgdat->memcg_lru.lock);
-}
-#endif
-
 /******************************************************************************
  *                          state change
  ******************************************************************************/
@@ -6086,67 +6181,6 @@ void lru_gen_exit_memcg(struct mem_cgrou
 	}
 }
 
-void lru_gen_online_memcg(struct mem_cgroup *memcg)
-{
-	int gen;
-	int nid;
-	int bin = get_random_u32_below(MEMCG_NR_BINS);
-
-	for_each_node(nid) {
-		struct pglist_data *pgdat = NODE_DATA(nid);
-		struct lruvec *lruvec = get_lruvec(memcg, nid);
-
-		spin_lock(&pgdat->memcg_lru.lock);
-
-		VM_WARN_ON_ONCE(!hlist_nulls_unhashed(&lruvec->lrugen.list));
-
-		gen = get_memcg_gen(pgdat->memcg_lru.seq);
-
-		hlist_nulls_add_tail_rcu(&lruvec->lrugen.list, &pgdat->memcg_lru.fifo[gen][bin]);
-		pgdat->memcg_lru.nr_memcgs[gen]++;
-
-		lruvec->lrugen.gen = gen;
-
-		spin_unlock(&pgdat->memcg_lru.lock);
-	}
-}
-
-void lru_gen_offline_memcg(struct mem_cgroup *memcg)
-{
-	int nid;
-
-	for_each_node(nid) {
-		struct lruvec *lruvec = get_lruvec(memcg, nid);
-
-		lru_gen_rotate_memcg(lruvec, MEMCG_LRU_OLD);
-	}
-}
-
-void lru_gen_release_memcg(struct mem_cgroup *memcg)
-{
-	int gen;
-	int nid;
-
-	for_each_node(nid) {
-		struct pglist_data *pgdat = NODE_DATA(nid);
-		struct lruvec *lruvec = get_lruvec(memcg, nid);
-
-		spin_lock(&pgdat->memcg_lru.lock);
-
-		VM_WARN_ON_ONCE(hlist_nulls_unhashed(&lruvec->lrugen.list));
-
-		gen = lruvec->lrugen.gen;
-
-		hlist_nulls_del_rcu(&lruvec->lrugen.list);
-		pgdat->memcg_lru.nr_memcgs[gen]--;
-
-		if (!pgdat->memcg_lru.nr_memcgs[gen] && gen == get_memcg_gen(pgdat->memcg_lru.seq))
-			WRITE_ONCE(pgdat->memcg_lru.seq, pgdat->memcg_lru.seq + 1);
-
-		spin_unlock(&pgdat->memcg_lru.lock);
-	}
-}
-
 #endif /* CONFIG_MEMCG */
 
 static int __init init_lru_gen(void)
_

Patches currently in -mm which might be from talumbau@google.com are

mm-multi-gen-lru-section-for-working-set-protection.patch
mm-multi-gen-lru-section-for-rmap-pt-walk-feedback.patch
mm-multi-gen-lru-section-for-bloom-filters.patch
mm-multi-gen-lru-section-for-memcg-lru.patch
mm-multi-gen-lru-improve-lru_gen_exit_memcg.patch
mm-multi-gen-lru-improve-walk_pmd_range.patch
mm-multi-gen-lru-simplify-lru_gen_look_around.patch

