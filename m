Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64CAB23C506;
	Tue, 13 Jan 2026 05:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768280993; cv=none; b=gf1K1VSDYyLxM8SK8hs8286J0h04NJ9SOmPAOOy7tcc66TjseyazBGXeAXj7rlhuWc/0tC29bfZy0jzgJD0RUjLroV/PAJ4ZplInfEH0uIlLFIzH+77zOxh9KMU/rhgZ+9i+ASzwrw+6A6fDubc+WyPiwNFH89qF8bncdyUgYps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768280993; c=relaxed/simple;
	bh=2BGSO/pVt+iFYvkHiIQrw783zGNvxyG+K3S0mIdypj0=;
	h=Date:To:From:Subject:Message-Id; b=W1p6w3GuLo27t+wpCqN9MGVr08De405PAchbGwJlnAMCDV3M3xfEjQ+NWl11+t3HXDdnWKv3EK0R6h2JnoB+2DgvCV8iW69xNHd2jhIXb1FSxxkOX6h4KEttZyGtCe5pvd/MWbb6c3BS7B9U8eJxsCC5L+umdATmSo4T3G8CAog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=B4AhFhR9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="B4AhFhR9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C7B3C116C6;
	Tue, 13 Jan 2026 05:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768280993;
	bh=2BGSO/pVt+iFYvkHiIQrw783zGNvxyG+K3S0mIdypj0=;
	h=Date:To:From:Subject:From;
	b=B4AhFhR9LI+JXIwUi5S0rieLtU76knzgB7kqEYrz8v73mM0q7cw/Chd2RPDlyZoMz
	 TOavVkTUwU0w5AvCtzNz07Tqf5XOgHACWRG9CoJmo8pS1YqLAsggprinQUe8TO8lk/
	 AiInnm9rgaSj1KzCCyquTkX9pZpOHcqrEechuSg4=
Date: Mon, 12 Jan 2026 21:09:52 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,surenb@google.com,stable@vger.kernel.org,rostedt@goodmis.org,oliver.sang@intel.com,mhocko@suse.com,mgorman@techsingularity.net,jackmanb@google.com,hannes@cmpxchg.org,bigeasy@linutronix.de,vbabka@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-page_alloc-prevent-pcp-corruption-with-smp=n.patch removed from -mm tree
Message-Id: <20260113050953.3C7B3C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: prevent pcp corruption with SMP=n
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-prevent-pcp-corruption-with-smp=n.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm/page_alloc: prevent pcp corruption with SMP=n
Date: Mon, 05 Jan 2026 16:08:56 +0100

The kernel test robot has reported:

 BUG: spinlock trylock failure on UP on CPU#0, kcompactd0/28
  lock: 0xffff888807e35ef0, .magic: dead4ead, .owner: kcompactd0/28, .owner_cpu: 0
 CPU: 0 UID: 0 PID: 28 Comm: kcompactd0 Not tainted 6.18.0-rc5-00127-ga06157804399 #1 PREEMPT  8cc09ef94dcec767faa911515ce9e609c45db470
 Call Trace:
  <IRQ>
  __dump_stack (lib/dump_stack.c:95)
  dump_stack_lvl (lib/dump_stack.c:123)
  dump_stack (lib/dump_stack.c:130)
  spin_dump (kernel/locking/spinlock_debug.c:71)
  do_raw_spin_trylock (kernel/locking/spinlock_debug.c:?)
  _raw_spin_trylock (include/linux/spinlock_api_smp.h:89 kernel/locking/spinlock.c:138)
  __free_frozen_pages (mm/page_alloc.c:2973)
  ___free_pages (mm/page_alloc.c:5295)
  __free_pages (mm/page_alloc.c:5334)
  tlb_remove_table_rcu (include/linux/mm.h:? include/linux/mm.h:3122 include/asm-generic/tlb.h:220 mm/mmu_gather.c:227 mm/mmu_gather.c:290)
  ? __cfi_tlb_remove_table_rcu (mm/mmu_gather.c:289)
  ? rcu_core (kernel/rcu/tree.c:?)
  rcu_core (include/linux/rcupdate.h:341 kernel/rcu/tree.c:2607 kernel/rcu/tree.c:2861)
  rcu_core_si (kernel/rcu/tree.c:2879)
  handle_softirqs (arch/x86/include/asm/jump_label.h:36 include/trace/events/irq.h:142 kernel/softirq.c:623)
  __irq_exit_rcu (arch/x86/include/asm/jump_label.h:36 kernel/softirq.c:725)
  irq_exit_rcu (kernel/softirq.c:741)
  sysvec_apic_timer_interrupt (arch/x86/kernel/apic/apic.c:1052)
  </IRQ>
  <TASK>
 RIP: 0010:_raw_spin_unlock_irqrestore (arch/x86/include/asm/preempt.h:95 include/linux/spinlock_api_smp.h:152 kernel/locking/spinlock.c:194)
  free_pcppages_bulk (mm/page_alloc.c:1494)
  drain_pages_zone (include/linux/spinlock.h:391 mm/page_alloc.c:2632)
  __drain_all_pages (mm/page_alloc.c:2731)
  drain_all_pages (mm/page_alloc.c:2747)
  kcompactd (mm/compaction.c:3115)
  kthread (kernel/kthread.c:465)
  ? __cfi_kcompactd (mm/compaction.c:3166)
  ? __cfi_kthread (kernel/kthread.c:412)
  ret_from_fork (arch/x86/kernel/process.c:164)
  ? __cfi_kthread (kernel/kthread.c:412)
  ret_from_fork_asm (arch/x86/entry/entry_64.S:255)
  </TASK>

Matthew has analyzed the report and identified that in drain_page_zone()
we are in a section protected by spin_lock(&pcp->lock) and then get an
interrupt that attempts spin_trylock() on the same lock.  The code is
designed to work this way without disabling IRQs and occasionally fail the
trylock with a fallback.  However, the SMP=n spinlock implementation
assumes spin_trylock() will always succeed, and thus it's normally a
no-op.  Here the enabled lock debugging catches the problem, but otherwise
it could cause a corruption of the pcp structure.

The problem has been introduced by commit 574907741599 ("mm/page_alloc:
leave IRQs enabled for per-cpu page allocations").  The pcp locking scheme
recognizes the need for disabling IRQs to prevent nesting spin_trylock()
sections on SMP=n, but the need to prevent the nesting in spin_lock() has
not been recognized.  Fix it by introducing local wrappers that change the
spin_lock() to spin_lock_iqsave() with SMP=n and use them in all places
that do spin_lock(&pcp->lock).

[vbabka@suse.cz: add pcp_ prefix to the spin_lock_irqsave wrappers, per Steven]
Link: https://lkml.kernel.org/r/20260105-fix-pcp-up-v1-1-5579662d2071@suse.cz
Fixes: 574907741599 ("mm/page_alloc: leave IRQs enabled for per-cpu page allocations")
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202512101320.e2f2dd6f-lkp@intel.com
Analyzed-by: Matthew Wilcox <willy@infradead.org>
Link: https://lore.kernel.org/all/aUW05pyc9nZkvY-1@casper.infradead.org/
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   47 ++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 39 insertions(+), 8 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-prevent-pcp-corruption-with-smp=n
+++ a/mm/page_alloc.c
@@ -167,6 +167,33 @@ static inline void __pcp_trylock_noop(un
 	pcp_trylock_finish(UP_flags);					\
 })
 
+/*
+ * With the UP spinlock implementation, when we spin_lock(&pcp->lock) (for i.e.
+ * a potentially remote cpu drain) and get interrupted by an operation that
+ * attempts pcp_spin_trylock(), we can't rely on the trylock failure due to UP
+ * spinlock assumptions making the trylock a no-op. So we have to turn that
+ * spin_lock() to a spin_lock_irqsave(). This works because on UP there are no
+ * remote cpu's so we can only be locking the only existing local one.
+ */
+#if defined(CONFIG_SMP) || defined(CONFIG_PREEMPT_RT)
+static inline void __flags_noop(unsigned long *flags) { }
+#define pcp_spin_lock_maybe_irqsave(ptr, flags)		\
+({							\
+	 __flags_noop(&(flags));			\
+	 spin_lock(&(ptr)->lock);			\
+})
+#define pcp_spin_unlock_maybe_irqrestore(ptr, flags)	\
+({							\
+	 spin_unlock(&(ptr)->lock);			\
+	 __flags_noop(&(flags));			\
+})
+#else
+#define pcp_spin_lock_maybe_irqsave(ptr, flags)		\
+		spin_lock_irqsave(&(ptr)->lock, flags)
+#define pcp_spin_unlock_maybe_irqrestore(ptr, flags)	\
+		spin_unlock_irqrestore(&(ptr)->lock, flags)
+#endif
+
 #ifdef CONFIG_USE_PERCPU_NUMA_NODE_ID
 DEFINE_PER_CPU(int, numa_node);
 EXPORT_PER_CPU_SYMBOL(numa_node);
@@ -2556,6 +2583,7 @@ static int rmqueue_bulk(struct zone *zon
 bool decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp)
 {
 	int high_min, to_drain, to_drain_batched, batch;
+	unsigned long UP_flags;
 	bool todo = false;
 
 	high_min = READ_ONCE(pcp->high_min);
@@ -2575,9 +2603,9 @@ bool decay_pcp_high(struct zone *zone, s
 	to_drain = pcp->count - pcp->high;
 	while (to_drain > 0) {
 		to_drain_batched = min(to_drain, batch);
-		spin_lock(&pcp->lock);
+		pcp_spin_lock_maybe_irqsave(pcp, UP_flags);
 		free_pcppages_bulk(zone, to_drain_batched, pcp, 0);
-		spin_unlock(&pcp->lock);
+		pcp_spin_unlock_maybe_irqrestore(pcp, UP_flags);
 		todo = true;
 
 		to_drain -= to_drain_batched;
@@ -2594,14 +2622,15 @@ bool decay_pcp_high(struct zone *zone, s
  */
 void drain_zone_pages(struct zone *zone, struct per_cpu_pages *pcp)
 {
+	unsigned long UP_flags;
 	int to_drain, batch;
 
 	batch = READ_ONCE(pcp->batch);
 	to_drain = min(pcp->count, batch);
 	if (to_drain > 0) {
-		spin_lock(&pcp->lock);
+		pcp_spin_lock_maybe_irqsave(pcp, UP_flags);
 		free_pcppages_bulk(zone, to_drain, pcp, 0);
-		spin_unlock(&pcp->lock);
+		pcp_spin_unlock_maybe_irqrestore(pcp, UP_flags);
 	}
 }
 #endif
@@ -2612,10 +2641,11 @@ void drain_zone_pages(struct zone *zone,
 static void drain_pages_zone(unsigned int cpu, struct zone *zone)
 {
 	struct per_cpu_pages *pcp = per_cpu_ptr(zone->per_cpu_pageset, cpu);
+	unsigned long UP_flags;
 	int count;
 
 	do {
-		spin_lock(&pcp->lock);
+		pcp_spin_lock_maybe_irqsave(pcp, UP_flags);
 		count = pcp->count;
 		if (count) {
 			int to_drain = min(count,
@@ -2624,7 +2654,7 @@ static void drain_pages_zone(unsigned in
 			free_pcppages_bulk(zone, to_drain, pcp, 0);
 			count -= to_drain;
 		}
-		spin_unlock(&pcp->lock);
+		pcp_spin_unlock_maybe_irqrestore(pcp, UP_flags);
 	} while (count);
 }
 
@@ -6109,6 +6139,7 @@ static void zone_pcp_update_cacheinfo(st
 {
 	struct per_cpu_pages *pcp;
 	struct cpu_cacheinfo *cci;
+	unsigned long UP_flags;
 
 	pcp = per_cpu_ptr(zone->per_cpu_pageset, cpu);
 	cci = get_cpu_cacheinfo(cpu);
@@ -6119,12 +6150,12 @@ static void zone_pcp_update_cacheinfo(st
 	 * This can reduce zone lock contention without hurting
 	 * cache-hot pages sharing.
 	 */
-	spin_lock(&pcp->lock);
+	pcp_spin_lock_maybe_irqsave(pcp, UP_flags);
 	if ((cci->per_cpu_data_slice_size >> PAGE_SHIFT) > 3 * pcp->batch)
 		pcp->flags |= PCPF_FREE_HIGH_BATCH;
 	else
 		pcp->flags &= ~PCPF_FREE_HIGH_BATCH;
-	spin_unlock(&pcp->lock);
+	pcp_spin_unlock_maybe_irqrestore(pcp, UP_flags);
 }
 
 void setup_pcp_cacheinfo(unsigned int cpu)
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-page_alloc-thp-prevent-reclaim-for-__gfp_thisnode-thp-allocations.patch
mm-page_alloc-ignore-the-exact-initial-compaction-result.patch
mm-page_alloc-refactor-the-initial-compaction-handling.patch
mm-page_alloc-simplify-__alloc_pages_slowpath-flow.patch

