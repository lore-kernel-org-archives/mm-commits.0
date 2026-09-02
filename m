Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE203BFAC8
	for <mm-commits@vger.kernel.org>; Wed,  2 Sep 2026 19:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788377608; cv=none; b=eW80d57ooKrgodDkZtQIHVzkMak/4yQShjTf1tY0lkkWtIRiHJwVIDS55oi0lB5QBZnx6GeTRk0ZWfXCb0jrkqTaaxnRUDZDm/WwBPgHpgg3L8ilgXZoYyX6ExTkH4T8ti4/eIB5Qr5zAWl9TboySBQiLHl6dpxogj+VonYys8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788377608; c=relaxed/simple;
	bh=XIsD0PBu5sc2SrPjf/NM80CDuiqxqqjBqqM5SLCU7EM=;
	h=Date:To:From:Subject:Message-Id; b=fFkbStcExrde8eVP4sW5eGOv+Cj3O0vlIbRcXIMJq7gDrz5uZJDeO2jryLfBQdRVgDtxvPmKmXxBCW++j3+wCLV6JIE4/7DCs4Lwqj9FNT77WaFTltIlY/V6nV9uQIYet/rKKJjHJnoGRHpMpqT9osxg7wNpvMAUqUyybUc//ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gXUihWYI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gXUihWYI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABC1C1F00ACF;
	Wed,  2 Sep 2026 19:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788377595;
	bh=fhzGpQBx/panL+ATx9xsVHaMp8zmN62zQytNb8jjdRs=;
	h=Date:To:From:Subject;
	b=gXUihWYI2Wd2+8ode1CZmLP47HTAs62mmf8+938y4BdJ2cza3dJOb1kESG1xAB3Gk
	 Hrf5c/IV7jCS4doJxpPYDZUyeqN1f8zeiIm4u3c3oTGOgTVJQkaY09x76hpCXd+Gma
	 4C6qkIDzaPgT8DK9S1Zralp9qVRXlR4IWzFr6qT8=
Date: Wed, 02 Sep 2026 12:33:15 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] memcg-simplify-v1-event-ratelimiting.patch removed from -mm tree
Message-Id: <20260902193315.ABC1C1F00ACF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: simplify v1 event ratelimiting
has been removed from the -mm tree.  Its filename was
     memcg-simplify-v1-event-ratelimiting.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: simplify v1 event ratelimiting
Date: Tue, 11 Aug 2026 13:32:03 -0700

Thresholds are the only periodic v1 event left, so the target enum, the
per-cpu target array and the switch in memcg1_event_ratelimit() all
collapse to a single counter.

memcg1_check_events() no longer needs a node id either, which lets
memcg1_uncharge_batch() drop its nid argument and struct uncharge_gather
drop the field feeding it.

Link: https://lore.kernel.org/20260811203203.3456029-10-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: T.J. Mercier <tjmercier@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol-v1.c |   43 +++++++++++--------------------------------
 mm/memcontrol-v1.h |    4 ++--
 mm/memcontrol.c    |    4 +---
 3 files changed, 14 insertions(+), 37 deletions(-)

--- a/mm/memcontrol.c~memcg-simplify-v1-event-ratelimiting
+++ a/mm/memcontrol.c
@@ -5328,7 +5328,6 @@ struct uncharge_gather {
 	unsigned long nr_memory;
 	unsigned long pgpgout;
 	unsigned long nr_kmem;
-	int nid;
 };
 
 static inline void uncharge_gather_clear(struct uncharge_gather *ug)
@@ -5351,7 +5350,7 @@ static void uncharge_batch(const struct
 		memcg1_oom_recover(memcg);
 	}
 
-	memcg1_uncharge_batch(memcg, ug->pgpgout, ug->nr_memory, ug->nid);
+	memcg1_uncharge_batch(memcg, ug->pgpgout, ug->nr_memory);
 	rcu_read_unlock();
 
 	/* drop reference from uncharge_folio */
@@ -5380,7 +5379,6 @@ static void uncharge_folio(struct folio
 			uncharge_gather_clear(ug);
 		}
 		ug->objcg = objcg;
-		ug->nid = folio_nid(folio);
 
 		/* pairs with obj_cgroup_put in uncharge_batch */
 		obj_cgroup_get(objcg);
--- a/mm/memcontrol-v1.c~memcg-simplify-v1-event-ratelimiting
+++ a/mm/memcontrol-v1.c
@@ -200,15 +200,9 @@ static void mem_cgroup_threshold(struct
  * to trigger some periodic events. This is straightforward and better
  * than using jiffies etc. to handle periodic memcg event.
  */
-enum mem_cgroup_events_target {
-	MEM_CGROUP_TARGET_THRESH,
-	MEM_CGROUP_TARGET_SOFTLIMIT,
-	MEM_CGROUP_NTARGETS,
-};
-
 struct memcg1_events_percpu {
 	unsigned long nr_page_events;
-	unsigned long targets[MEM_CGROUP_NTARGETS];
+	unsigned long threshold_target;
 };
 
 static void memcg1_charge_statistics(struct mem_cgroup *memcg, int nr_pages)
@@ -225,43 +219,28 @@ static void memcg1_charge_statistics(str
 }
 
 #define THRESHOLDS_EVENTS_TARGET 128
-#define SOFTLIMIT_EVENTS_TARGET 1024
 
-static bool memcg1_event_ratelimit(struct mem_cgroup *memcg,
-				enum mem_cgroup_events_target target)
+static bool memcg1_event_ratelimit(struct mem_cgroup *memcg)
 {
 	unsigned long val, next;
 
 	val = __this_cpu_read(memcg->events_percpu->nr_page_events);
-	next = __this_cpu_read(memcg->events_percpu->targets[target]);
+	next = __this_cpu_read(memcg->events_percpu->threshold_target);
 	/* from time_after() in jiffies.h */
 	if ((long)(next - val) < 0) {
-		switch (target) {
-		case MEM_CGROUP_TARGET_THRESH:
-			next = val + THRESHOLDS_EVENTS_TARGET;
-			break;
-		case MEM_CGROUP_TARGET_SOFTLIMIT:
-			next = val + SOFTLIMIT_EVENTS_TARGET;
-			break;
-		default:
-			break;
-		}
-		__this_cpu_write(memcg->events_percpu->targets[target], next);
+		__this_cpu_write(memcg->events_percpu->threshold_target,
+				 val + THRESHOLDS_EVENTS_TARGET);
 		return true;
 	}
 	return false;
 }
 
-/*
- * Check events in order.
- *
- */
-static void memcg1_check_events(struct mem_cgroup *memcg, int nid)
+static void memcg1_check_events(struct mem_cgroup *memcg)
 {
 	if (IS_ENABLED(CONFIG_PREEMPT_RT))
 		return;
 
-	if (unlikely(memcg1_event_ratelimit(memcg, MEM_CGROUP_TARGET_THRESH)))
+	if (unlikely(memcg1_event_ratelimit(memcg)))
 		mem_cgroup_threshold(memcg);
 }
 
@@ -271,7 +250,7 @@ void memcg1_commit_charge(struct folio *
 
 	local_irq_save(flags);
 	memcg1_charge_statistics(memcg, folio_nr_pages(folio));
-	memcg1_check_events(memcg, folio_nid(folio));
+	memcg1_check_events(memcg);
 	local_irq_restore(flags);
 }
 
@@ -344,7 +323,7 @@ void __memcg1_swapout(struct folio *foli
 	VM_WARN_ON_IRQS_ENABLED();
 	memcg1_charge_statistics(memcg, -folio_nr_pages(folio));
 	preempt_enable_nested();
-	memcg1_check_events(memcg, folio_nid(folio));
+	memcg1_check_events(memcg);
 
 	rcu_read_unlock();
 	obj_cgroup_put(objcg);
@@ -398,14 +377,14 @@ void memcg1_swapin(struct folio *folio)
 #endif
 
 void memcg1_uncharge_batch(struct mem_cgroup *memcg, unsigned long pgpgout,
-			   unsigned long nr_memory, int nid)
+			   unsigned long nr_memory)
 {
 	unsigned long flags;
 
 	local_irq_save(flags);
 	count_memcg_events(memcg, PGPGOUT, pgpgout);
 	__this_cpu_add(memcg->events_percpu->nr_page_events, nr_memory);
-	memcg1_check_events(memcg, nid);
+	memcg1_check_events(memcg);
 	local_irq_restore(flags);
 }
 
--- a/mm/memcontrol-v1.h~memcg-simplify-v1-event-ratelimiting
+++ a/mm/memcontrol-v1.h
@@ -59,7 +59,7 @@ void memcg1_oom_recover(struct mem_cgrou
 
 void memcg1_commit_charge(struct folio *folio, struct mem_cgroup *memcg);
 void memcg1_uncharge_batch(struct mem_cgroup *memcg, unsigned long pgpgout,
-			   unsigned long nr_memory, int nid);
+			   unsigned long nr_memory);
 
 void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s);
 void reparent_memcg1_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent);
@@ -107,7 +107,7 @@ static inline void memcg1_commit_charge(
 
 static inline void memcg1_uncharge_batch(struct mem_cgroup *memcg,
 					 unsigned long pgpgout,
-					 unsigned long nr_memory, int nid) {}
+					 unsigned long nr_memory) {}
 
 static inline void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s) {}
 
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-avoid-charging-the-root-memcg-from-obj_cgroup_charge_pages.patch
mm-mlock-use-the-irq-safe-accessor-for-nr_mlock-in-__munlock_folio.patch
memcg-clear-flushing_cached_charge-on-cpu-offline.patch
memcg-trim-the-per-cpu-charge-stock-instead-of-draining-it.patch
a.patch

