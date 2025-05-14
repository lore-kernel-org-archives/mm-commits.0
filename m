Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 651F21FA15E
	for <mm-commits@vger.kernel.org>; Wed, 14 May 2025 05:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747202334; cv=none; b=ZJgafJRb9CspZDrIHvZYs6C9G9U5GbTA2+CKhQMzmLXN570RW8gbEh8OevGChdFMGx2BUWqEMI5n1BWCVBrBj8ln94TWv0lvba11zA1qeaUDqrsgdQTeH00ELULOvj469eRyddfWrmXB4+D0TgYWcHGkU6NYS3zepMxFR1f2IPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747202334; c=relaxed/simple;
	bh=IAxBvNP69F/ReSXBWFU0ZAo25JOBE2pnIeRq7JdOMYY=;
	h=Date:To:From:Subject:Message-Id; b=hOv/uAZuD0nyg2L8sjr9HNrrcxY1ELY/qMifiiQyPZDnEtPmUJvmVh341xFuL2ojziTK02ecjD4iMjjlUTUtfTx9ldBe6pXqmO4oZQYZwqLku15gE4GoxxHt/VSYT/JVxczA5ZAjKbqVRi/n81/MYlvNmXjMfnkAmG69/uUr/yM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=F6PQHqur; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F6PQHqur"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27C12C4CEE9;
	Wed, 14 May 2025 05:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747202334;
	bh=IAxBvNP69F/ReSXBWFU0ZAo25JOBE2pnIeRq7JdOMYY=;
	h=Date:To:From:Subject:From;
	b=F6PQHqurqe10/5PFoTCSfP3qvOkxUlirH12waoio3ow8rVi/itio11l3wokZHRm9V
	 hGSeOMokVf8/figRTHRm4LXJDtmwThG6zNTu44GmDq6dF+o22RumZvs+rfVrDMDwJ6
	 S0tBBU5NuiB8suYU/AjLLusnZNbU/lX6p5T+lP/w=
Date: Tue, 13 May 2025 22:58:53 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,bigeasy@linutronix.de,ast@kernel.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-make-count_memcg_events-re-entrant-safe-against-irqs.patch added to mm-new branch
Message-Id: <20250514055854.27C12C4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: make count_memcg_events re-entrant safe against irqs
has been added to the -mm mm-new branch.  Its filename is
     memcg-make-count_memcg_events-re-entrant-safe-against-irqs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-make-count_memcg_events-re-entrant-safe-against-irqs.patch

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
Subject: memcg: make count_memcg_events re-entrant safe against irqs
Date: Tue, 13 May 2025 22:08:10 -0700

Let's make count_memcg_events re-entrant safe against irqs.  The only
thing needed is to convert the usage of __this_cpu_add() to
this_cpu_add().  In addition, with re-entrant safety, there is no need to
disable irqs.  Also add warnings for in_nmi() as it is not safe against
nmi context.

Link: https://lkml.kernel.org/r/20250514050813.2526843-5-shakeel.butt@linux.dev
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

 include/linux/memcontrol.h |   21 ++-------------------
 mm/memcontrol-v1.c         |    6 +++---
 mm/memcontrol.c            |    6 +++---
 mm/swap.c                  |    8 ++++----
 mm/vmscan.c                |   14 +++++++-------
 5 files changed, 19 insertions(+), 36 deletions(-)

--- a/include/linux/memcontrol.h~memcg-make-count_memcg_events-re-entrant-safe-against-irqs
+++ a/include/linux/memcontrol.h
@@ -942,19 +942,8 @@ static inline void mod_lruvec_kmem_state
 	local_irq_restore(flags);
 }
 
-void __count_memcg_events(struct mem_cgroup *memcg, enum vm_event_item idx,
-			  unsigned long count);
-
-static inline void count_memcg_events(struct mem_cgroup *memcg,
-				      enum vm_event_item idx,
-				      unsigned long count)
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-	__count_memcg_events(memcg, idx, count);
-	local_irq_restore(flags);
-}
+void count_memcg_events(struct mem_cgroup *memcg, enum vm_event_item idx,
+			unsigned long count);
 
 static inline void count_memcg_folio_events(struct folio *folio,
 		enum vm_event_item idx, unsigned long nr)
@@ -1418,12 +1407,6 @@ static inline void mod_lruvec_kmem_state
 }
 
 static inline void count_memcg_events(struct mem_cgroup *memcg,
-				      enum vm_event_item idx,
-				      unsigned long count)
-{
-}
-
-static inline void __count_memcg_events(struct mem_cgroup *memcg,
 					enum vm_event_item idx,
 					unsigned long count)
 {
--- a/mm/memcontrol.c~memcg-make-count_memcg_events-re-entrant-safe-against-irqs
+++ a/mm/memcontrol.c
@@ -825,12 +825,12 @@ void __mod_lruvec_kmem_state(void *p, en
 }
 
 /**
- * __count_memcg_events - account VM events in a cgroup
+ * count_memcg_events - account VM events in a cgroup
  * @memcg: the memory cgroup
  * @idx: the event item
  * @count: the number of events that occurred
  */
-void __count_memcg_events(struct mem_cgroup *memcg, enum vm_event_item idx,
+void count_memcg_events(struct mem_cgroup *memcg, enum vm_event_item idx,
 			  unsigned long count)
 {
 	int i = memcg_events_index(idx);
@@ -844,7 +844,7 @@ void __count_memcg_events(struct mem_cgr
 
 	cpu = get_cpu();
 
-	__this_cpu_add(memcg->vmstats_percpu->events[i], count);
+	this_cpu_add(memcg->vmstats_percpu->events[i], count);
 	memcg_rstat_updated(memcg, count, cpu);
 	trace_count_memcg_events(memcg, idx, count);
 
--- a/mm/memcontrol-v1.c~memcg-make-count_memcg_events-re-entrant-safe-against-irqs
+++ a/mm/memcontrol-v1.c
@@ -512,9 +512,9 @@ static void memcg1_charge_statistics(str
 {
 	/* pagein of a big page is an event. So, ignore page size */
 	if (nr_pages > 0)
-		__count_memcg_events(memcg, PGPGIN, 1);
+		count_memcg_events(memcg, PGPGIN, 1);
 	else {
-		__count_memcg_events(memcg, PGPGOUT, 1);
+		count_memcg_events(memcg, PGPGOUT, 1);
 		nr_pages = -nr_pages; /* for event */
 	}
 
@@ -689,7 +689,7 @@ void memcg1_uncharge_batch(struct mem_cg
 	unsigned long flags;
 
 	local_irq_save(flags);
-	__count_memcg_events(memcg, PGPGOUT, pgpgout);
+	count_memcg_events(memcg, PGPGOUT, pgpgout);
 	__this_cpu_add(memcg->events_percpu->nr_page_events, nr_memory);
 	memcg1_check_events(memcg, nid);
 	local_irq_restore(flags);
--- a/mm/swap.c~memcg-make-count_memcg_events-re-entrant-safe-against-irqs
+++ a/mm/swap.c
@@ -309,7 +309,7 @@ static void lru_activate(struct lruvec *
 	trace_mm_lru_activate(folio);
 
 	__count_vm_events(PGACTIVATE, nr_pages);
-	__count_memcg_events(lruvec_memcg(lruvec), PGACTIVATE, nr_pages);
+	count_memcg_events(lruvec_memcg(lruvec), PGACTIVATE, nr_pages);
 }
 
 #ifdef CONFIG_SMP
@@ -581,7 +581,7 @@ static void lru_deactivate_file(struct l
 
 	if (active) {
 		__count_vm_events(PGDEACTIVATE, nr_pages);
-		__count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE,
+		count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE,
 				     nr_pages);
 	}
 }
@@ -599,7 +599,7 @@ static void lru_deactivate(struct lruvec
 	lruvec_add_folio(lruvec, folio);
 
 	__count_vm_events(PGDEACTIVATE, nr_pages);
-	__count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE, nr_pages);
+	count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE, nr_pages);
 }
 
 static void lru_lazyfree(struct lruvec *lruvec, struct folio *folio)
@@ -625,7 +625,7 @@ static void lru_lazyfree(struct lruvec *
 	lruvec_add_folio(lruvec, folio);
 
 	__count_vm_events(PGLAZYFREE, nr_pages);
-	__count_memcg_events(lruvec_memcg(lruvec), PGLAZYFREE, nr_pages);
+	count_memcg_events(lruvec_memcg(lruvec), PGLAZYFREE, nr_pages);
 }
 
 /*
--- a/mm/vmscan.c~memcg-make-count_memcg_events-re-entrant-safe-against-irqs
+++ a/mm/vmscan.c
@@ -2028,7 +2028,7 @@ static unsigned long shrink_inactive_lis
 	item = PGSCAN_KSWAPD + reclaimer_offset(sc);
 	if (!cgroup_reclaim(sc))
 		__count_vm_events(item, nr_scanned);
-	__count_memcg_events(lruvec_memcg(lruvec), item, nr_scanned);
+	count_memcg_events(lruvec_memcg(lruvec), item, nr_scanned);
 	__count_vm_events(PGSCAN_ANON + file, nr_scanned);
 
 	spin_unlock_irq(&lruvec->lru_lock);
@@ -2048,7 +2048,7 @@ static unsigned long shrink_inactive_lis
 	item = PGSTEAL_KSWAPD + reclaimer_offset(sc);
 	if (!cgroup_reclaim(sc))
 		__count_vm_events(item, nr_reclaimed);
-	__count_memcg_events(lruvec_memcg(lruvec), item, nr_reclaimed);
+	count_memcg_events(lruvec_memcg(lruvec), item, nr_reclaimed);
 	__count_vm_events(PGSTEAL_ANON + file, nr_reclaimed);
 	spin_unlock_irq(&lruvec->lru_lock);
 
@@ -2138,7 +2138,7 @@ static void shrink_active_list(unsigned
 
 	if (!cgroup_reclaim(sc))
 		__count_vm_events(PGREFILL, nr_scanned);
-	__count_memcg_events(lruvec_memcg(lruvec), PGREFILL, nr_scanned);
+	count_memcg_events(lruvec_memcg(lruvec), PGREFILL, nr_scanned);
 
 	spin_unlock_irq(&lruvec->lru_lock);
 
@@ -2195,7 +2195,7 @@ static void shrink_active_list(unsigned
 	nr_deactivate = move_folios_to_lru(lruvec, &l_inactive);
 
 	__count_vm_events(PGDEACTIVATE, nr_deactivate);
-	__count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE, nr_deactivate);
+	count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE, nr_deactivate);
 
 	__mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
 	spin_unlock_irq(&lruvec->lru_lock);
@@ -4616,8 +4616,8 @@ static int scan_folios(unsigned long nr_
 		__count_vm_events(item, isolated);
 		__count_vm_events(PGREFILL, sorted);
 	}
-	__count_memcg_events(memcg, item, isolated);
-	__count_memcg_events(memcg, PGREFILL, sorted);
+	count_memcg_events(memcg, item, isolated);
+	count_memcg_events(memcg, PGREFILL, sorted);
 	__count_vm_events(PGSCAN_ANON + type, isolated);
 	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, MAX_LRU_BATCH,
 				scanned, skipped, isolated,
@@ -4769,7 +4769,7 @@ retry:
 	item = PGSTEAL_KSWAPD + reclaimer_offset(sc);
 	if (!cgroup_reclaim(sc))
 		__count_vm_events(item, reclaimed);
-	__count_memcg_events(memcg, item, reclaimed);
+	count_memcg_events(memcg, item, reclaimed);
 	__count_vm_events(PGSTEAL_ANON + type, reclaimed);
 
 	spin_unlock_irq(&lruvec->lru_lock);
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-memcg_rstat_updated-re-entrant-safe-against-irqs.patch
memcg-move-preempt-disable-to-callers-of-memcg_rstat_updated.patch
memcg-make-mod_memcg_state-re-entrant-safe-against-irqs.patch
memcg-make-count_memcg_events-re-entrant-safe-against-irqs.patch
memcg-make-__mod_memcg_lruvec_state-re-entrant-safe-against-irqs.patch
memcg-no-stock-lock-for-cpu-hot-unplug.patch
memcg-objcg-stock-trylock-without-irq-disabling.patch

