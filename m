Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 068AB2222C8
	for <mm-commits@vger.kernel.org>; Wed, 21 May 2025 16:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747846669; cv=none; b=EzTyId3UP3GhIcUW83BErCBQ/+J9eOuUQncJXG/nBLmnLPE+bC9Bx+21WlUOyucgQ3RSIKyoufpU5q8uh4+rdGp4zrfBa8BznbXyh5HKMd+AY+Yg1OCWK6EXqmXUHPsTexlatlfPzlKxJ/N2C4xu9MNC5he78k44BHmgGSuqNKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747846669; c=relaxed/simple;
	bh=oLIChyfARWNb05a+eQb3ClqfCnsDncl5nu5QbZ4wm4A=;
	h=Date:To:From:Subject:Message-Id; b=BbqaAumW/SbXMZGSE1N+WRdcI7HiyHqmh/YKrxvoTj+ifTcK8XIyCYIfJpOpawCc7du885TuhV79A4U6gSrfV1RSnDLLermddCOXDMtoKGREVYdEsbFZxN3Ji2gD4Azc4D9ntgPdex9dvtNy4IVFugSCA+cWjfOCxRU+2Ix1uXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2gC6If9d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2gC6If9d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFA2DC4CEE4;
	Wed, 21 May 2025 16:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747846668;
	bh=oLIChyfARWNb05a+eQb3ClqfCnsDncl5nu5QbZ4wm4A=;
	h=Date:To:From:Subject:From;
	b=2gC6If9dhSxuJR9td4Iw1zdUQmIqqmY55pDSzHezXgePss+7GlHcAowptcS0PESFm
	 gGjqh/3HFBEIdwvrjQjhNDND2JQloMsfyC8aOczf+cSrnW3hxR5400PQgIA2wTlmgM
	 h2RfVc/Okvb6r1ZQsb3dJ4s+wPo2/KjRB36c9vRw=
Date: Wed, 21 May 2025 09:57:48 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,bigeasy@linutronix.de,ast@kernel.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-make-__mod_memcg_lruvec_state-re-entrant-safe-against-irqs.patch removed from -mm tree
Message-Id: <20250521165748.CFA2DC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: make __mod_memcg_lruvec_state re-entrant safe against irqs
has been removed from the -mm tree.  Its filename was
     memcg-make-__mod_memcg_lruvec_state-re-entrant-safe-against-irqs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: make __mod_memcg_lruvec_state re-entrant safe against irqs
Date: Wed, 14 May 2025 11:41:56 -0700

Let's make __mod_memcg_lruvec_state re-entrant safe and name it
mod_memcg_lruvec_state().  The only thing needed is to convert the usage
of __this_cpu_add() to this_cpu_add().  There are two callers of
mod_memcg_lruvec_state() and one of them i.e.  __mod_objcg_mlstate() will
be re-entrant safe as well, so, rename it mod_objcg_mlstate().  The last
caller __mod_lruvec_state() still calls __mod_node_page_state() which is
not re-entrant safe yet, so keep it as is.

Link: https://lkml.kernel.org/r/20250514184158.3471331-6-shakeel.butt@linux.dev
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

memcg-disable-kmem-charging-in-nmi-for-unsupported-arch.patch
memcg-nmi-safe-memcg-stats-for-specific-archs.patch
memcg-add-nmi-safe-update-for-memcg_kmem.patch
memcg-nmi-safe-slab-stats-updates.patch
memcg-make-memcg_rstat_updated-nmi-safe.patch

