Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526B2152DE7
	for <mm-commits@vger.kernel.org>; Sun,  1 Jun 2025 05:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748756828; cv=none; b=MHMFX+c7Lya+RLGw14Hz5C1F25u1153VIWl3Eil+RE8C6OXG7aKnS0CxtdllHtWCAgwC22FYuUPs5xJmYfhWy1vkrnUmwZM/kyyogrw90fLEJBEiuqErG8z4ihSYpFml+UfA92PYD+llypbS/9dU6e7PRcDb2DCH28GhMrmZFFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748756828; c=relaxed/simple;
	bh=sgzjRsjbFSXJvq/IQVJfFu1saaEFunUmF3mcm76EqGw=;
	h=Date:To:From:Subject:Message-Id; b=KxU+VPuPHKsASKapA2AJvlI6xZ42Q8tocLd7M28kGpgX7ZcaBpFjRfV+GiWUXX2O/WCAoXguNQ2phFROy7J1RAGtzYOVJVbWPuA9bNK8sj/YaG3SPr1BMUqSBSDYu9GF5sV+jTsXM6hmCY3WQBVPr9mA/fu4aEjV9ORoycwjoxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HZpvsCMw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HZpvsCMw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DF79C4CEED;
	Sun,  1 Jun 2025 05:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748756828;
	bh=sgzjRsjbFSXJvq/IQVJfFu1saaEFunUmF3mcm76EqGw=;
	h=Date:To:From:Subject:From;
	b=HZpvsCMwy+zPdXZqjk3Q0lolLhPAwfRDFBkLxiwWSVkoGQ9IrrO5fnfklBxZbTZml
	 KI3CJxz/EzU9BRGncSaEWPXGWPNOPZUQvwqRFcfoywGwOglNCJpFjRi76Rh5Bz/xje
	 9tbynuR3zHKI0CbrDqSLAfrMYgszcq9gYuHLeYYc=
Date: Sat, 31 May 2025 22:47:07 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,tj@kernel.org,roman.gushchin@linux.dev,peterz@infradead.org,muchun.song@linux.dev,mhocko@kernel.org,mathieu.desnoyers@efficios.com,hannes@cmpxchg.org,bigeasy@linutronix.de,ast@kernel.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-nmi-safe-slab-stats-updates.patch removed from -mm tree
Message-Id: <20250601054708.0DF79C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: nmi-safe slab stats updates
has been removed from the -mm tree.  Its filename was
     memcg-nmi-safe-slab-stats-updates.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: nmi-safe slab stats updates
Date: Sun, 18 May 2025 23:31:41 -0700

The objcg based kmem [un]charging can be called in nmi context and it may
need to update NR_SLAB_[UN]RECLAIMABLE_B stats.  So, let's correctly
handle the updates of these stats in the nmi context.

Link: https://lkml.kernel.org/r/20250519063142.111219-5-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   36 +++++++++++++++++++++++++++++++++---
 1 file changed, 33 insertions(+), 3 deletions(-)

--- a/mm/memcontrol.c~memcg-nmi-safe-slab-stats-updates
+++ a/mm/memcontrol.c
@@ -2515,17 +2515,47 @@ static void commit_charge(struct folio *
 	folio->memcg_data = (unsigned long)memcg;
 }
 
+#ifdef CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC
+static inline void account_slab_nmi_safe(struct mem_cgroup *memcg,
+					 struct pglist_data *pgdat,
+					 enum node_stat_item idx, int nr)
+{
+	struct lruvec *lruvec;
+
+	if (likely(!in_nmi())) {
+		lruvec = mem_cgroup_lruvec(memcg, pgdat);
+		mod_memcg_lruvec_state(lruvec, idx, nr);
+	} else {
+		struct mem_cgroup_per_node *pn = memcg->nodeinfo[pgdat->node_id];
+
+		/* TODO: add to cgroup update tree once it is nmi-safe. */
+		if (idx == NR_SLAB_RECLAIMABLE_B)
+			atomic_add(nr, &pn->slab_reclaimable);
+		else
+			atomic_add(nr, &pn->slab_unreclaimable);
+	}
+}
+#else
+static inline void account_slab_nmi_safe(struct mem_cgroup *memcg,
+					 struct pglist_data *pgdat,
+					 enum node_stat_item idx, int nr)
+{
+	struct lruvec *lruvec;
+
+	lruvec = mem_cgroup_lruvec(memcg, pgdat);
+	mod_memcg_lruvec_state(lruvec, idx, nr);
+}
+#endif
+
 static inline void mod_objcg_mlstate(struct obj_cgroup *objcg,
 				       struct pglist_data *pgdat,
 				       enum node_stat_item idx, int nr)
 {
 	struct mem_cgroup *memcg;
-	struct lruvec *lruvec;
 
 	rcu_read_lock();
 	memcg = obj_cgroup_memcg(objcg);
-	lruvec = mem_cgroup_lruvec(memcg, pgdat);
-	mod_memcg_lruvec_state(lruvec, idx, nr);
+	account_slab_nmi_safe(memcg, pgdat, idx, nr);
 	rcu_read_unlock();
 }
 
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are


