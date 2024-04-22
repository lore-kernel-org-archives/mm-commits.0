Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 880C9154BF9
	for <mm-commits@vger.kernel.org>; Mon, 22 Apr 2024 20:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713817706; cv=none; b=KT583+z1JuXRMk271KQH2/leekfMLDpdZncNkBZXweKoz97I0EBTdoNpfcWVOagedfkrG7/ulUClGkhL12NQHwsasAdZdiibC4ji7+SL7ebnx2+d7HPNM8JYgFl6RNPTHLkkZx7ZmKC4LEveLhvqWWAJwbG3QK0BecxcydWHNKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713817706; c=relaxed/simple;
	bh=4JmKUix47ZXl58aZIQjnXuhdCMQp0fh7I5Ap1ikaC0A=;
	h=Date:To:From:Subject:Message-Id; b=GO2LtXhLwaGxL5lpjgQuPCnoN8bpqZYW7NlViTUzrugAA4ulkU4NRSGS4d94gZbmEGARZy+y/HlwTig6snu3Wc7Kzm6C1Au9L3bnm6oUH2/+KTt+CehzxCg9B9ZZKSb7+2p4+1p3CBGsGKCuUdTiwvftyzvJ4wRYaTeN6exIlqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=R2VUV7uR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="R2VUV7uR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE839C113CC;
	Mon, 22 Apr 2024 20:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713817706;
	bh=4JmKUix47ZXl58aZIQjnXuhdCMQp0fh7I5Ap1ikaC0A=;
	h=Date:To:From:Subject:From;
	b=R2VUV7uRGZB/BZsWNkgXWOB9yGWj/LLP2gT7FMjU3JVkrXSVi36YPKXTyhk98/JEP
	 VDCj6sOSy+jmlElJV765koooR/281X6MybTEyp27/J/CV/sD4oOa6Y8HnHPHutl5tD
	 syNo90X5UpYvVX8jrJdFsRa97bfbZUbyrYy8PQGA=
Date: Mon, 22 Apr 2024 13:28:25 -0700
To: mm-commits@vger.kernel.org,tjmercier@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-simple-cleanup-of-stats-update-functions.patch added to mm-unstable branch
Message-Id: <20240422202825.EE839C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: simple cleanup of stats update functions
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-simple-cleanup-of-stats-update-functions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-simple-cleanup-of-stats-update-functions.patch

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
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: simple cleanup of stats update functions
Date: Sat, 20 Apr 2024 16:25:05 -0700

mod_memcg_lruvec_state() is never called from outside of memcontrol.c and
with always irq disabled.  So, replace it with the irq disabled version
and add an assert that irq is disabled in the caller.

Similarly mod_objcg_state() is not called from outside of memcontrol.c, so
simply make it static and change it's name to __mod_objcg_state().

Link: https://lkml.kernel.org/r/20240420232505.2768428-1-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: T.J. Mercier <tjmercier@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   17 -----------------
 mm/memcontrol.c            |   31 +++++++++++++++----------------
 mm/slab.h                  |    2 --
 3 files changed, 15 insertions(+), 35 deletions(-)

--- a/include/linux/memcontrol.h~memcg-simple-cleanup-of-stats-update-functions
+++ a/include/linux/memcontrol.h
@@ -1077,8 +1077,6 @@ static inline unsigned long lruvec_page_
 void mem_cgroup_flush_stats(struct mem_cgroup *memcg);
 void mem_cgroup_flush_stats_ratelimited(struct mem_cgroup *memcg);
 
-void __mod_memcg_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
-			      int val);
 void __mod_lruvec_kmem_state(void *p, enum node_stat_item idx, int val);
 
 static inline void mod_lruvec_kmem_state(void *p, enum node_stat_item idx,
@@ -1091,16 +1089,6 @@ static inline void mod_lruvec_kmem_state
 	local_irq_restore(flags);
 }
 
-static inline void mod_memcg_lruvec_state(struct lruvec *lruvec,
-					  enum node_stat_item idx, int val)
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-	__mod_memcg_lruvec_state(lruvec, idx, val);
-	local_irq_restore(flags);
-}
-
 void __count_memcg_events(struct mem_cgroup *memcg, enum vm_event_item idx,
 			  unsigned long count);
 
@@ -1594,11 +1582,6 @@ static inline void mem_cgroup_flush_stat
 {
 }
 
-static inline void __mod_memcg_lruvec_state(struct lruvec *lruvec,
-					    enum node_stat_item idx, int val)
-{
-}
-
 static inline void __mod_lruvec_kmem_state(void *p, enum node_stat_item idx,
 					   int val)
 {
--- a/mm/memcontrol.c~memcg-simple-cleanup-of-stats-update-functions
+++ a/mm/memcontrol.c
@@ -836,8 +836,9 @@ static unsigned long memcg_page_state_lo
 	return x;
 }
 
-void __mod_memcg_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
-			      int val)
+static void __mod_memcg_lruvec_state(struct lruvec *lruvec,
+				     enum node_stat_item idx,
+				     int val)
 {
 	struct mem_cgroup_per_node *pn;
 	struct mem_cgroup *memcg;
@@ -2978,21 +2979,19 @@ void mem_cgroup_commit_charge(struct fol
 
 #ifdef CONFIG_MEMCG_KMEM
 
-/*
- * mod_objcg_mlstate() may be called with irq enabled, so
- * mod_memcg_lruvec_state() should be used.
- */
-static inline void mod_objcg_mlstate(struct obj_cgroup *objcg,
-				     struct pglist_data *pgdat,
-				     enum node_stat_item idx, int nr)
+static inline void __mod_objcg_mlstate(struct obj_cgroup *objcg,
+				       struct pglist_data *pgdat,
+				       enum node_stat_item idx, int nr)
 {
 	struct mem_cgroup *memcg;
 	struct lruvec *lruvec;
 
+	lockdep_assert_irqs_disabled();
+
 	rcu_read_lock();
 	memcg = obj_cgroup_memcg(objcg);
 	lruvec = mem_cgroup_lruvec(memcg, pgdat);
-	mod_memcg_lruvec_state(lruvec, idx, nr);
+	__mod_memcg_lruvec_state(lruvec, idx, nr);
 	rcu_read_unlock();
 }
 
@@ -3312,7 +3311,7 @@ void __memcg_kmem_uncharge_page(struct p
 	obj_cgroup_put(objcg);
 }
 
-void mod_objcg_state(struct obj_cgroup *objcg, struct pglist_data *pgdat,
+static void mod_objcg_state(struct obj_cgroup *objcg, struct pglist_data *pgdat,
 		     enum node_stat_item idx, int nr)
 {
 	struct memcg_stock_pcp *stock;
@@ -3340,12 +3339,12 @@ void mod_objcg_state(struct obj_cgroup *
 		struct pglist_data *oldpg = stock->cached_pgdat;
 
 		if (stock->nr_slab_reclaimable_b) {
-			mod_objcg_mlstate(objcg, oldpg, NR_SLAB_RECLAIMABLE_B,
+			__mod_objcg_mlstate(objcg, oldpg, NR_SLAB_RECLAIMABLE_B,
 					  stock->nr_slab_reclaimable_b);
 			stock->nr_slab_reclaimable_b = 0;
 		}
 		if (stock->nr_slab_unreclaimable_b) {
-			mod_objcg_mlstate(objcg, oldpg, NR_SLAB_UNRECLAIMABLE_B,
+			__mod_objcg_mlstate(objcg, oldpg, NR_SLAB_UNRECLAIMABLE_B,
 					  stock->nr_slab_unreclaimable_b);
 			stock->nr_slab_unreclaimable_b = 0;
 		}
@@ -3371,7 +3370,7 @@ void mod_objcg_state(struct obj_cgroup *
 		}
 	}
 	if (nr)
-		mod_objcg_mlstate(objcg, pgdat, idx, nr);
+		__mod_objcg_mlstate(objcg, pgdat, idx, nr);
 
 	local_unlock_irqrestore(&memcg_stock.stock_lock, flags);
 	obj_cgroup_put(old);
@@ -3437,13 +3436,13 @@ static struct obj_cgroup *drain_obj_stoc
 	 */
 	if (stock->nr_slab_reclaimable_b || stock->nr_slab_unreclaimable_b) {
 		if (stock->nr_slab_reclaimable_b) {
-			mod_objcg_mlstate(old, stock->cached_pgdat,
+			__mod_objcg_mlstate(old, stock->cached_pgdat,
 					  NR_SLAB_RECLAIMABLE_B,
 					  stock->nr_slab_reclaimable_b);
 			stock->nr_slab_reclaimable_b = 0;
 		}
 		if (stock->nr_slab_unreclaimable_b) {
-			mod_objcg_mlstate(old, stock->cached_pgdat,
+			__mod_objcg_mlstate(old, stock->cached_pgdat,
 					  NR_SLAB_UNRECLAIMABLE_B,
 					  stock->nr_slab_unreclaimable_b);
 			stock->nr_slab_unreclaimable_b = 0;
--- a/mm/slab.h~memcg-simple-cleanup-of-stats-update-functions
+++ a/mm/slab.h
@@ -581,8 +581,6 @@ bool __memcg_slab_post_alloc_hook(struct
 				  gfp_t flags, size_t size, void **p);
 void __memcg_slab_free_hook(struct kmem_cache *s, struct slab *slab,
 			    void **p, int objects, struct slabobj_ext *obj_exts);
-void mod_objcg_state(struct obj_cgroup *objcg, struct pglist_data *pgdat,
-		     enum node_stat_item idx, int nr);
 #endif
 
 size_t __ksize(const void *objp);
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-simple-cleanup-of-stats-update-functions.patch

