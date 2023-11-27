Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81FD2C4167B
	for <mm-commits@archiver.kernel.org>; Mon, 27 Nov 2023 20:43:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231601AbjK0Uno (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Nov 2023 15:43:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233013AbjK0Unm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Nov 2023 15:43:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65943187
        for <mm-commits@vger.kernel.org>; Mon, 27 Nov 2023 12:43:48 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01C0AC433C7;
        Mon, 27 Nov 2023 20:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701117828;
        bh=aNDqcfvuamjN7oMF1lgQl4i8Lal7hTybgLGHtTfyero=;
        h=Date:To:From:Subject:From;
        b=boU3NIsJj6r3NynG0rt0o/RMsfkrSydnF9GvfBDvf/2IqqxKMxdM4rRSHp6NDn3m2
         T8ZfpNkrE7hfPWPzLn2QYmaQz/mZjFa0FqE5RiQ/5SxawEwAK/5muMXagnUimpMotk
         hgaPXXlzihU1rmhrPEx4yL0SjL4qtGTRFIavL1Cw=
Date:   Mon, 27 Nov 2023 12:43:47 -0800
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        vitaly.wool@konsulko.com, sjenning@redhat.com, shuah@kernel.org,
        shakeelb@google.com, roman.gushchin@linux.dev,
        muchun.song@linux.dev, mhocko@kernel.org, hannes@cmpxchg.org,
        ddstreet@ieee.org, chrisl@kernel.org, cerasuolodomenico@gmail.com,
        nphamcs@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + memcontrol-allows-mem_cgroup_iter-to-check-for-onlineness.patch added to mm-unstable branch
Message-Id: <20231127204348.01C0AC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcontrol: allows mem_cgroup_iter() to check for onlineness
has been added to the -mm mm-unstable branch.  Its filename is
     memcontrol-allows-mem_cgroup_iter-to-check-for-onlineness.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcontrol-allows-mem_cgroup_iter-to-check-for-onlineness.patch

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
From: Nhat Pham <nphamcs@gmail.com>
Subject: memcontrol: allows mem_cgroup_iter() to check for onlineness
Date: Mon, 27 Nov 2023 11:36:59 -0800

The new zswap writeback scheme requires an online-only memcg hierarchy
traversal.  Add a new parameter to mem_cgroup_iter() to check for
onlineness before returning.

Link: https://lkml.kernel.org/r/20231127193703.1980089-3-nphamcs@gmail.com
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    4 ++--
 mm/memcontrol.c            |   17 ++++++++++-------
 mm/shrinker.c              |    4 ++--
 mm/vmscan.c                |   26 +++++++++++++-------------
 4 files changed, 27 insertions(+), 24 deletions(-)

--- a/include/linux/memcontrol.h~memcontrol-allows-mem_cgroup_iter-to-check-for-onlineness
+++ a/include/linux/memcontrol.h
@@ -832,7 +832,7 @@ static inline void mem_cgroup_put(struct
 
 struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *,
 				   struct mem_cgroup *,
-				   struct mem_cgroup_reclaim_cookie *);
+				   struct mem_cgroup_reclaim_cookie *, bool online);
 void mem_cgroup_iter_break(struct mem_cgroup *, struct mem_cgroup *);
 void mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
 			   int (*)(struct task_struct *, void *), void *arg);
@@ -1381,7 +1381,7 @@ static inline struct lruvec *folio_lruve
 static inline struct mem_cgroup *
 mem_cgroup_iter(struct mem_cgroup *root,
 		struct mem_cgroup *prev,
-		struct mem_cgroup_reclaim_cookie *reclaim)
+		struct mem_cgroup_reclaim_cookie *reclaim, bool online)
 {
 	return NULL;
 }
--- a/mm/memcontrol.c~memcontrol-allows-mem_cgroup_iter-to-check-for-onlineness
+++ a/mm/memcontrol.c
@@ -221,14 +221,14 @@ enum res_type {
  * be used for reference counting.
  */
 #define for_each_mem_cgroup_tree(iter, root)		\
-	for (iter = mem_cgroup_iter(root, NULL, NULL);	\
+	for (iter = mem_cgroup_iter(root, NULL, NULL, false);	\
 	     iter != NULL;				\
-	     iter = mem_cgroup_iter(root, iter, NULL))
+	     iter = mem_cgroup_iter(root, iter, NULL, false))
 
 #define for_each_mem_cgroup(iter)			\
-	for (iter = mem_cgroup_iter(NULL, NULL, NULL);	\
+	for (iter = mem_cgroup_iter(NULL, NULL, NULL, false);	\
 	     iter != NULL;				\
-	     iter = mem_cgroup_iter(NULL, iter, NULL))
+	     iter = mem_cgroup_iter(NULL, iter, NULL, false))
 
 static inline bool task_is_dying(void)
 {
@@ -1115,6 +1115,7 @@ again:
  * @root: hierarchy root
  * @prev: previously returned memcg, NULL on first invocation
  * @reclaim: cookie for shared reclaim walks, NULL for full walks
+ * @online: skip offline memcgs
  *
  * Returns references to children of the hierarchy below @root, or
  * @root itself, or %NULL after a full round-trip.
@@ -1129,7 +1130,8 @@ again:
  */
 struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
 				   struct mem_cgroup *prev,
-				   struct mem_cgroup_reclaim_cookie *reclaim)
+				   struct mem_cgroup_reclaim_cookie *reclaim,
+				   bool online)
 {
 	struct mem_cgroup_reclaim_iter *iter;
 	struct cgroup_subsys_state *css = NULL;
@@ -1199,7 +1201,8 @@ struct mem_cgroup *mem_cgroup_iter(struc
 		 * is provided by the caller, so we know it's alive
 		 * and kicking, and don't take an extra reference.
 		 */
-		if (css == &root->css || css_tryget(css)) {
+		if (css == &root->css || (!online && css_tryget(css)) ||
+				css_tryget_online(css)) {
 			memcg = mem_cgroup_from_css(css);
 			break;
 		}
@@ -1812,7 +1815,7 @@ static int mem_cgroup_soft_reclaim(struc
 	excess = soft_limit_excess(root_memcg);
 
 	while (1) {
-		victim = mem_cgroup_iter(root_memcg, victim, &reclaim);
+		victim = mem_cgroup_iter(root_memcg, victim, &reclaim, false);
 		if (!victim) {
 			loop++;
 			if (loop >= 2) {
--- a/mm/shrinker.c~memcontrol-allows-mem_cgroup_iter-to-check-for-onlineness
+++ a/mm/shrinker.c
@@ -160,7 +160,7 @@ static int expand_shrinker_info(int new_
 	new_size = shrinker_unit_size(new_nr_max);
 	old_size = shrinker_unit_size(shrinker_nr_max);
 
-	memcg = mem_cgroup_iter(NULL, NULL, NULL);
+	memcg = mem_cgroup_iter(NULL, NULL, NULL, false);
 	do {
 		ret = expand_one_shrinker_info(memcg, new_size, old_size,
 					       new_nr_max);
@@ -168,7 +168,7 @@ static int expand_shrinker_info(int new_
 			mem_cgroup_iter_break(NULL, memcg);
 			goto out;
 		}
-	} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)) != NULL);
+	} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL, false)) != NULL);
 out:
 	if (!ret)
 		shrinker_nr_max = new_nr_max;
--- a/mm/vmscan.c~memcontrol-allows-mem_cgroup_iter-to-check-for-onlineness
+++ a/mm/vmscan.c
@@ -382,10 +382,10 @@ static unsigned long drop_slab_node(int
 	unsigned long freed = 0;
 	struct mem_cgroup *memcg = NULL;
 
-	memcg = mem_cgroup_iter(NULL, NULL, NULL);
+	memcg = mem_cgroup_iter(NULL, NULL, NULL, false);
 	do {
 		freed += shrink_slab(GFP_KERNEL, nid, memcg, 0);
-	} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)) != NULL);
+	} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL, false)) != NULL);
 
 	return freed;
 }
@@ -3911,7 +3911,7 @@ static void lru_gen_age_node(struct pgli
 	if (!min_ttl || sc->order || sc->priority == DEF_PRIORITY)
 		return;
 
-	memcg = mem_cgroup_iter(NULL, NULL, NULL);
+	memcg = mem_cgroup_iter(NULL, NULL, NULL, false);
 	do {
 		struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);
 
@@ -3921,7 +3921,7 @@ static void lru_gen_age_node(struct pgli
 		}
 
 		cond_resched();
-	} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)));
+	} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL, false)));
 
 	/*
 	 * The main goal is to OOM kill if every generation from all memcgs is
@@ -5013,7 +5013,7 @@ static void lru_gen_change_state(bool en
 	else
 		static_branch_disable_cpuslocked(&lru_gen_caps[LRU_GEN_CORE]);
 
-	memcg = mem_cgroup_iter(NULL, NULL, NULL);
+	memcg = mem_cgroup_iter(NULL, NULL, NULL, false);
 	do {
 		int nid;
 
@@ -5037,7 +5037,7 @@ static void lru_gen_change_state(bool en
 		}
 
 		cond_resched();
-	} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)));
+	} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL, false)));
 unlock:
 	mutex_unlock(&state_mutex);
 	put_online_mems();
@@ -5140,7 +5140,7 @@ static void *lru_gen_seq_start(struct se
 	if (!m->private)
 		return ERR_PTR(-ENOMEM);
 
-	memcg = mem_cgroup_iter(NULL, NULL, NULL);
+	memcg = mem_cgroup_iter(NULL, NULL, NULL, false);
 	do {
 		int nid;
 
@@ -5148,7 +5148,7 @@ static void *lru_gen_seq_start(struct se
 			if (!nr_to_skip--)
 				return get_lruvec(memcg, nid);
 		}
-	} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)));
+	} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL, false)));
 
 	return NULL;
 }
@@ -5171,7 +5171,7 @@ static void *lru_gen_seq_next(struct seq
 
 	nid = next_memory_node(nid);
 	if (nid == MAX_NUMNODES) {
-		memcg = mem_cgroup_iter(NULL, memcg, NULL);
+		memcg = mem_cgroup_iter(NULL, memcg, NULL, false);
 		if (!memcg)
 			return NULL;
 
@@ -5774,7 +5774,7 @@ static void shrink_node_memcgs(pg_data_t
 	struct mem_cgroup *target_memcg = sc->target_mem_cgroup;
 	struct mem_cgroup *memcg;
 
-	memcg = mem_cgroup_iter(target_memcg, NULL, NULL);
+	memcg = mem_cgroup_iter(target_memcg, NULL, NULL, false);
 	do {
 		struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);
 		unsigned long reclaimed;
@@ -5831,7 +5831,7 @@ static void shrink_node_memcgs(pg_data_t
 				   sc->nr_scanned - scanned,
 				   sc->nr_reclaimed - reclaimed);
 
-	} while ((memcg = mem_cgroup_iter(target_memcg, memcg, NULL)));
+	} while ((memcg = mem_cgroup_iter(target_memcg, memcg, NULL, false)));
 }
 
 static void shrink_node(pg_data_t *pgdat, struct scan_control *sc)
@@ -6498,12 +6498,12 @@ static void kswapd_age_node(struct pglis
 	if (!inactive_is_low(lruvec, LRU_INACTIVE_ANON))
 		return;
 
-	memcg = mem_cgroup_iter(NULL, NULL, NULL);
+	memcg = mem_cgroup_iter(NULL, NULL, NULL, false);
 	do {
 		lruvec = mem_cgroup_lruvec(memcg, pgdat);
 		shrink_active_list(SWAP_CLUSTER_MAX, lruvec,
 				   sc, LRU_ACTIVE_ANON);
-		memcg = mem_cgroup_iter(NULL, memcg, NULL);
+		memcg = mem_cgroup_iter(NULL, memcg, NULL, false);
 	} while (memcg);
 }
 
_

Patches currently in -mm which might be from nphamcs@gmail.com are

list_lru-allows-explicit-memcg-and-numa-node-selection.patch
memcontrol-allows-mem_cgroup_iter-to-check-for-onlineness.patch
zswap-shrinks-zswap-pool-based-on-memory-pressure.patch

