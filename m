Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A68E1FAC54
	for <mm-commits@vger.kernel.org>; Wed, 14 May 2025 05:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747202338; cv=none; b=Ojm15dmnjRNFgBnQYz2Z0pzc03LRKG54vtPYYJFkegXSClp0+DikGChjp2VDzqEfqM8F5Ras9YQQVBwGL98H0Al19SsPuvqH0h9qYc+5KwH872SwRoX7gH0pCqUcW4iSC6kJ/GgdAVJ7xHkAhddIvFxyG9tbF2cXdCrDrPnekBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747202338; c=relaxed/simple;
	bh=zBI08xc5TeVw76kjsOcjREwJRb+5Cr18aUXw1hn2FKQ=;
	h=Date:To:From:Subject:Message-Id; b=DTsFCZLiWVdp2ZelxDPgU9DR3ZbFmLIvpNKfHNrNtC42x8zP6NTcAzb7cluEABpiDBzzj5raQ7g6uDSvNjYJAUbnOqoyrETfeWCxI0zG8xAT+pxaPl0nTXH5G72cuhUDydECb4Dm1dVCNCoGKwU+4Q3Y+3zlCDF8lg/uu1nZdfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HxlGASW+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HxlGASW+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3CD9C4CEE9;
	Wed, 14 May 2025 05:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747202337;
	bh=zBI08xc5TeVw76kjsOcjREwJRb+5Cr18aUXw1hn2FKQ=;
	h=Date:To:From:Subject:From;
	b=HxlGASW+AAdGWNM0kcMbrYeLpXTVyO5j+vlPcyZlfLC40ohfOgS3vSlpgE0urzFiD
	 3LjHIRzuj71RfHizgw3DHTGOm1ys+dTiu4hMaebZEFcdQmE3+cjIKM/ld98c21jMVx
	 yvRAUbZN59jD/g+X1zM4wRZZpr0hUYOXy8+z0xSA=
Date: Tue, 13 May 2025 22:58:57 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,bigeasy@linutronix.de,ast@kernel.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-make-__mod_memcg_lruvec_state-re-entrant-safe-against-irqs.patch added to mm-new branch
Message-Id: <20250514055857.B3CD9C4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: make __mod_memcg_lruvec_state re-entrant safe against irqs
has been added to the -mm mm-new branch.  Its filename is
     memcg-make-__mod_memcg_lruvec_state-re-entrant-safe-against-irqs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-make-__mod_memcg_lruvec_state-re-entrant-safe-against-irqs.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
Subject: memcg: make __mod_memcg_lruvec_state re-entrant safe against irqs
Date: Tue, 13 May 2025 22:08:11 -0700

Let's make __mod_memcg_lruvec_state re-entrant safe and name it
mod_memcg_lruvec_state().  The only thing needed is to convert the usage
of __this_cpu_add() to this_cpu_add().  There are two callers of
mod_memcg_lruvec_state() and one of them i.e.  __mod_objcg_mlstate() will
be re-entrant safe as well, so, rename it mod_objcg_mlstate().  The last
caller __mod_lruvec_state() still calls __mod_node_page_state() which is
not re-entrant safe yet, so keep it as is.

Link: https://lkml.kernel.org/r/20250514050813.2526843-6-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/mm/memcontrol.c~memcg-make-__mod_memcg_lruvec_state-re-entrant-safe-against-irqs
+++ a/mm/memcontrol.c
@@ -727,7 +727,7 @@ unsigned long memcg_page_state_local(str
 }
 #endif
 
-static void __mod_memcg_lruvec_state(struct lruvec *lruvec,
+static void mod_memcg_lruvec_state(struct lruvec *lruvec,
 				     enum node_stat_item idx,
 				     int val)
 {
@@ -745,10 +745,10 @@ static void __mod_memcg_lruvec_state(str
 	cpu = get_cpu();
 
 	/* Update memcg */
-	__this_cpu_add(memcg->vmstats_percpu->state[i], val);
+	this_cpu_add(memcg->vmstats_percpu->state[i], val);
 
 	/* Update lruvec */
-	__this_cpu_add(pn->lruvec_stats_percpu->state[i], val);
+	this_cpu_add(pn->lruvec_stats_percpu->state[i], val);
 
 	val = memcg_state_val_in_pages(idx, val);
 	memcg_rstat_updated(memcg, val, cpu);
@@ -775,7 +775,7 @@ void __mod_lruvec_state(struct lruvec *l
 
 	/* Update memcg and lruvec */
 	if (!mem_cgroup_disabled())
-		__mod_memcg_lruvec_state(lruvec, idx, val);
+		mod_memcg_lruvec_state(lruvec, idx, val);
 }
 
 void __lruvec_stat_mod_folio(struct folio *folio, enum node_stat_item idx,
@@ -2527,7 +2527,7 @@ static void commit_charge(struct folio *
 	folio->memcg_data = (unsigned long)memcg;
 }
 
-static inline void __mod_objcg_mlstate(struct obj_cgroup *objcg,
+static inline void mod_objcg_mlstate(struct obj_cgroup *objcg,
 				       struct pglist_data *pgdat,
 				       enum node_stat_item idx, int nr)
 {
@@ -2537,7 +2537,7 @@ static inline void __mod_objcg_mlstate(s
 	rcu_read_lock();
 	memcg = obj_cgroup_memcg(objcg);
 	lruvec = mem_cgroup_lruvec(memcg, pgdat);
-	__mod_memcg_lruvec_state(lruvec, idx, nr);
+	mod_memcg_lruvec_state(lruvec, idx, nr);
 	rcu_read_unlock();
 }
 
@@ -2847,12 +2847,12 @@ static void __account_obj_stock(struct o
 		struct pglist_data *oldpg = stock->cached_pgdat;
 
 		if (stock->nr_slab_reclaimable_b) {
-			__mod_objcg_mlstate(objcg, oldpg, NR_SLAB_RECLAIMABLE_B,
+			mod_objcg_mlstate(objcg, oldpg, NR_SLAB_RECLAIMABLE_B,
 					  stock->nr_slab_reclaimable_b);
 			stock->nr_slab_reclaimable_b = 0;
 		}
 		if (stock->nr_slab_unreclaimable_b) {
-			__mod_objcg_mlstate(objcg, oldpg, NR_SLAB_UNRECLAIMABLE_B,
+			mod_objcg_mlstate(objcg, oldpg, NR_SLAB_UNRECLAIMABLE_B,
 					  stock->nr_slab_unreclaimable_b);
 			stock->nr_slab_unreclaimable_b = 0;
 		}
@@ -2878,7 +2878,7 @@ static void __account_obj_stock(struct o
 		}
 	}
 	if (nr)
-		__mod_objcg_mlstate(objcg, pgdat, idx, nr);
+		mod_objcg_mlstate(objcg, pgdat, idx, nr);
 }
 
 static bool consume_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes,
@@ -2947,13 +2947,13 @@ static void drain_obj_stock(struct obj_s
 	 */
 	if (stock->nr_slab_reclaimable_b || stock->nr_slab_unreclaimable_b) {
 		if (stock->nr_slab_reclaimable_b) {
-			__mod_objcg_mlstate(old, stock->cached_pgdat,
+			mod_objcg_mlstate(old, stock->cached_pgdat,
 					  NR_SLAB_RECLAIMABLE_B,
 					  stock->nr_slab_reclaimable_b);
 			stock->nr_slab_reclaimable_b = 0;
 		}
 		if (stock->nr_slab_unreclaimable_b) {
-			__mod_objcg_mlstate(old, stock->cached_pgdat,
+			mod_objcg_mlstate(old, stock->cached_pgdat,
 					  NR_SLAB_UNRECLAIMABLE_B,
 					  stock->nr_slab_unreclaimable_b);
 			stock->nr_slab_unreclaimable_b = 0;
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-memcg_rstat_updated-re-entrant-safe-against-irqs.patch
memcg-move-preempt-disable-to-callers-of-memcg_rstat_updated.patch
memcg-make-mod_memcg_state-re-entrant-safe-against-irqs.patch
memcg-make-count_memcg_events-re-entrant-safe-against-irqs.patch
memcg-make-__mod_memcg_lruvec_state-re-entrant-safe-against-irqs.patch
memcg-no-stock-lock-for-cpu-hot-unplug.patch
memcg-objcg-stock-trylock-without-irq-disabling.patch

