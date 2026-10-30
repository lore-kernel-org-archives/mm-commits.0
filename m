Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793331992;
	b=VDJ+EQJXvv0hydrQR6IZ0lg9mBAg4j2AEIWcOw7nPwLwe9+EDXW/s8/TuJu53is0kZE8
	 LxF/uZAwinH42p5E68S1RTZRCbnblhG0BrfNdXD9vP8oopqeMltAuyNRDI4X7CA5qBaUd
	 RH4JDt4fJboBimJwvDHFbxPWTEj4UWLJH5fWVm5EfxTF10V4MvIWuPG5xh1BZoCL0IyqK
	 gSlt/XLpKr9sEdTtdza9dwZ2+pdGf6WT8x0xGadOHrmLVieJ0FnqsE6SD9I+APcCcUbS/
	 efMjydQLAAsj/ETpfztOFTpqW7VTEjkMfjxXnXY5H+ZOfMWxrMO4TeYlyiGXdAIns3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793331992;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=dVTU+uGC1JnalqV9q+RN7nyRXP2rlMYgW+78hWIZ96U=;
	b=t73nQdKJ0es7i+o7zs3Q6itB1sPkchSkSLgV5GwKyKYGSmO4W0RfBCnoPbbiuFKxSU/M
	 GO7a5FVns49Jy1iDfICo4UhZjWyOlmkNFErlZ0UCYelXsC6CkcSEwOFCFVYqLCoFGZMjL
	 f46N5JSaMqPRMALkFs4jNsB3LPnQv1oUENpfqRNv7/u/qJUuyUCnVitZ35RIZGAcYr9+p
	 +LM+RdpRxPUkO3JMpXsyna6I9eiYFvWmEKf02xveumW2g2U8IPGDWtCgsi8LepA7yXmk9
	 WOByfk4IKpJ7S8hkGH0+Cq+O5hfp52/solWP/Bp/wfKK10dlFR3DfEO46McvDQm/xQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=DOOAokWk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B468B606A31A
	for <mm-commits@vger.kernel.org>; Fri, 30 Oct 2026 03:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=DOOAokWk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A8F91F000C1;
	Fri, 30 Oct 2026 03:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793331991;
	bh=dVTU+uGC1JnalqV9q+RN7nyRXP2rlMYgW+78hWIZ96U=;
	h=Date:To:From:Subject;
	b=DOOAokWkeuB5SoGsiVHS32LR2RseRFqHK5gXWToNChGta8rjBNfY7SGzq2xq6Gl9P
	 ixJ7j0q5CA0LHrnwKgW1VJEL2oUYHgeaTQbHtT8UDV3JC/s17IWrB4UM3LSvseXoS0
	 kSrsmDuCk8FjC/YPWOb5EWG6k0+tVMITqussbmgI=
Date: Thu, 29 Oct 2026 20:46:30 -0700
To: mm-commits@vger.kernel.org,yosry@kernel.org,shakeel.butt@linux.dev,
	roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,
	mhocko@kernel.org,hannes@cmpxchg.org,joannelkoong@gmail.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-dont-go-through-the-lruvec-for-folio-and-kmem-lruvec-stat-updates.patch added to mm-new branch
Message-Id: <20261030034631.1A8F91F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: memcg: don't go through the lruvec for folio and kmem lruvec stat updates
has been added to the -mm mm-new branch.  Its filename is
     memcg-dont-go-through-the-lruvec-for-folio-and-kmem-lruvec-stat-updates.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-dont-go-through-the-lruvec-for-folio-and-kmem-lruvec-stat-updates.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Joanne Koong <joannelkoong@gmail.com>
Subject: memcg: don't go through the lruvec for folio and kmem lruvec stat updates
Date: Fri, 23 Oct 2026 12:54:17 -0700

lruvec_stat_mod_folio() and mod_lruvec_kmem_state() already know the memcg
and the node, but look up the lruvec with mem_cgroup_lruvec() and update
the stats through mod_lruvec_state(), which reads lruvec->pgdat and
mem_cgroup_per_node->memcg to get them back. lruvec->pgdat shares a
128-byte cacheline pair with lines that the lru_lock holder writes
constantly (lru_lock or lru_zone_size[], depending on the alignment of
struct mem_cgroup_per_node), so on CPUs that do spatial prefetching
these per-folio stat updates contend with the lru_lock holder.

Pass the memcg and node they already know to mod_memcg_node_state()
instead.

On top of the mem_cgroup_per_node rearrangement, on a 2-socket Skylake
(80 CPUs) with threads faulting in and freeing shmem in a single memcg,
this improves throughput by about 3% at 20 threads (5.59M -> 5.77M
pages/sec) and 2% at 80 threads (8.66M -> 8.82M).

Link: https://lore.kernel.org/20261023195417.1391216-3-joannelkoong@gmail.com
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Yosry Ahmed <yosry@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>
---

 mm/memcontrol.c |   71 ++++++++++++++++++----------------------------
 1 file changed, 29 insertions(+), 42 deletions(-)

--- a/mm/memcontrol.c~memcg-dont-go-through-the-lruvec-for-folio-and-kmem-lruvec-stat-updates
+++ a/mm/memcontrol.c
@@ -587,7 +587,7 @@ unsigned long lruvec_page_state_local(co
 	return x;
 }
 
-static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
+static void __mod_memcg_lruvec_state(struct mem_cgroup *memcg, int nid,
 				     enum node_stat_item idx, long val);
 
 void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
@@ -596,16 +596,11 @@ void reparent_memcg_lruvec_state_local(s
 	int nid;
 
 	for_each_node(nid) {
-		struct lruvec *child_lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
-		struct lruvec *parent_lruvec = mem_cgroup_lruvec(parent, NODE_DATA(nid));
-		unsigned long value = lruvec_page_state_local(child_lruvec, idx);
-		struct mem_cgroup_per_node *child_pn, *parent_pn;
+		struct lruvec *lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
+		unsigned long value = lruvec_page_state_local(lruvec, idx);
 
-		child_pn = container_of(child_lruvec, struct mem_cgroup_per_node, lruvec);
-		parent_pn = container_of(parent_lruvec, struct mem_cgroup_per_node, lruvec);
-
-		__mod_memcg_lruvec_state(child_pn, idx, -value);
-		__mod_memcg_lruvec_state(parent_pn, idx, value);
+		__mod_memcg_lruvec_state(memcg, nid, idx, -value);
+		__mod_memcg_lruvec_state(parent, nid, idx, value);
 	}
 }
 
@@ -990,10 +985,10 @@ void reparent_memcg_state_local(struct m
 }
 #endif
 
-static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
+static void __mod_memcg_lruvec_state(struct mem_cgroup *memcg, int nid,
 				     enum node_stat_item idx, long val)
 {
-	struct mem_cgroup *memcg = pn->memcg;
+	struct mem_cgroup_per_node *pn = memcg->nodeinfo[nid];
 	int i = memcg_stats_index(idx);
 	int cpu;
 
@@ -1015,21 +1010,23 @@ static void __mod_memcg_lruvec_state(str
 	put_cpu();
 }
 
+static void mod_memcg_node_state(struct mem_cgroup *memcg, int nid,
+				 enum node_stat_item idx, int val)
+{
+	bool rcu_locked = false;
+
+	memcg = get_non_dying_memcg_start(memcg, &rcu_locked);
+	__mod_memcg_lruvec_state(memcg, nid, idx, val);
+	get_non_dying_memcg_end(rcu_locked);
+}
+
 void mod_memcg_lruvec_state(struct lruvec *lruvec,
 			    enum node_stat_item idx, int val)
 {
-	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 	struct mem_cgroup_per_node *pn;
-	struct mem_cgroup *memcg;
-	bool rcu_locked = false;
 
 	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
-	memcg = get_non_dying_memcg_start(pn->memcg, &rcu_locked);
-	pn = memcg->nodeinfo[pgdat->node_id];
-
-	__mod_memcg_lruvec_state(pn, idx, val);
-
-	get_non_dying_memcg_end(rcu_locked);
+	mod_memcg_node_state(pn->memcg, lruvec_pgdat(lruvec)->node_id, idx, val);
 }
 
 /**
@@ -1058,19 +1055,13 @@ void lruvec_stat_mod_folio(struct folio
 {
 	struct mem_cgroup *memcg;
 	pg_data_t *pgdat = folio_pgdat(folio);
-	struct lruvec *lruvec;
+
+	mod_node_page_state(pgdat, idx, val);
 
 	rcu_read_lock();
 	memcg = folio_memcg(folio);
-	/* Untracked pages have no memcg, no lruvec. Update only the node */
-	if (!memcg) {
-		rcu_read_unlock();
-		mod_node_page_state(pgdat, idx, val);
-		return;
-	}
-
-	lruvec = mem_cgroup_lruvec(memcg, pgdat);
-	mod_lruvec_state(lruvec, idx, val);
+	if (memcg)
+		mod_memcg_node_state(memcg, pgdat->node_id, idx, val);
 	rcu_read_unlock();
 }
 EXPORT_SYMBOL(lruvec_stat_mod_folio);
@@ -1079,23 +1070,19 @@ void mod_lruvec_kmem_state(void *p, enum
 {
 	pg_data_t *pgdat = page_pgdat(virt_to_page(p));
 	struct mem_cgroup *memcg;
-	struct lruvec *lruvec;
+
+	mod_node_page_state(pgdat, idx, val);
 
 	rcu_read_lock();
 	memcg = mem_cgroup_from_virt(p);
 
 	/*
-	 * Untracked pages have no memcg, no lruvec. Update only the
-	 * node. If we reparent the slab objects to the root memcg,
-	 * when we free the slab object, we need to update the per-memcg
-	 * vmstats to keep it correct for the root memcg.
+	 * If we reparent the slab objects to the root memcg, when we free the
+	 * slab object, we need to update the per-memcg vmstats to keep it
+	 * correct for the root memcg.
 	 */
-	if (!memcg) {
-		mod_node_page_state(pgdat, idx, val);
-	} else {
-		lruvec = mem_cgroup_lruvec(memcg, pgdat);
-		mod_lruvec_state(lruvec, idx, val);
-	}
+	if (memcg)
+		mod_memcg_node_state(memcg, pgdat->node_id, idx, val);
 	rcu_read_unlock();
 }
 
_

Patches currently in -mm which might be from joannelkoong@gmail.com are

mm-unqueue-deferred-split-folios-outside-the-lruvec-lock.patch
memcg-reduce-cacheline-contention-between-lruvec-stat-updates-and-lru-lists.patch
memcg-dont-go-through-the-lruvec-for-folio-and-kmem-lruvec-stat-updates.patch

