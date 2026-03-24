Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B0EE365A0B
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388669; cv=none; b=ZF8YEAjrQLEH12ws6y7VSgT3zxh9By96o5bv4NybnnjkhBYH5vxESXIepBOCy7vvVjdLVc1c3OBFA51ykjVlQX53oTHxDnxo8jSSL31K5CPSXttShs7/CzNfB8DSMlqpWPe4vI8Am871ht7KkPbkDQj9q9Dzeqo/XkBSGf66+7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388669; c=relaxed/simple;
	bh=qYbaMqDwVc04e4UZI7t8TM1NpaULDi3Qnjv8knXN8GY=;
	h=Date:To:From:Subject:Message-Id; b=hrKNnI0WAPokkrYaRsYOQqbFg6zbFwik6Gz1Rsbtqy9bKOrpO7M8cl/LF6F+VEe5/OYFsE/ig1XvOdd1pBPfJqdWK4rAst5Tvew9Tc+4x1kIbKWRn4o7x55/u2unPv7/J3Ysxh9adxgTyAr55YQYVpzXJMD9J+JIhBfhcGjuJtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WpXy5URW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WpXy5URW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72309C2BC9E;
	Tue, 24 Mar 2026 21:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388669;
	bh=qYbaMqDwVc04e4UZI7t8TM1NpaULDi3Qnjv8knXN8GY=;
	h=Date:To:From:Subject:From;
	b=WpXy5URWhMwhvD9AtpUi+pKSDsYt5MBpvz+AajBeS8G9/ruJjDLE7Lsz6+aikPZNi
	 npqDxkY3VgtbehGAMAWqosAxF+oQNUaDUDF00aInL0yS4MNvreAFPrUXFnB7nrPWPN
	 lJxR6l7aSZaTNKSxlcFflgF/dp0i5GH7+PesAq80=
Date: Tue, 24 Mar 2026 14:44:28 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,surenb@google.com,rostedt@goodmis.org,mhocko@suse.com,mgorman@techsingularity.net,jackmanb@google.com,hannes@cmpxchg.org,david@kernel.org,bigeasy@linutronix.de,vbabka@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-remove-irq-saving-restoring-from-pcp-locking.patch removed from -mm tree
Message-Id: <20260324214429.72309C2BC9E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: remove IRQ saving/restoring from pcp locking
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-remove-irq-saving-restoring-from-pcp-locking.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Vlastimil Babka <vbabka@kernel.org>
Subject: mm/page_alloc: remove IRQ saving/restoring from pcp locking
Date: Fri, 27 Feb 2026 18:07:59 +0100

Effectively revert commit 038a102535eb ("mm/page_alloc: prevent pcp
corruption with SMP=n").  The original problem is now avoided by
pcp_spin_trylock() always failing on CONFIG_SMP=n, so we do not need to
disable IRQs anymore.

It's not a complete revert, because keeping the pcp_spin_(un)lock()
wrappers is useful.  Rename them from _maybe_irqsave/restore to _nopin. 
The difference from pcp_spin_trylock()/pcp_spin_unlock() is that the
_nopin variants don't perform pcpu_task_pin/unpin().

Link: https://lkml.kernel.org/r/20260227-b4-pcp-locking-cleanup-v1-2-f7e22e603447@kernel.org
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   46 ++++++++++++++++------------------------------
 1 file changed, 16 insertions(+), 30 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-remove-irq-saving-restoring-from-pcp-locking
+++ a/mm/page_alloc.c
@@ -154,24 +154,14 @@ static DEFINE_MUTEX(pcp_batch_high_lock)
 		BUG_ON(1)
 #endif
 
-#if defined(CONFIG_SMP) || defined(CONFIG_PREEMPT_RT)
-static inline void __flags_noop(unsigned long *flags) { }
-#define pcp_spin_lock_maybe_irqsave(ptr, flags)		\
-({							\
-	 __flags_noop(&(flags));			\
-	 spin_lock(&(ptr)->lock);			\
-})
-#define pcp_spin_unlock_maybe_irqrestore(ptr, flags)	\
-({							\
-	 spin_unlock(&(ptr)->lock);			\
-	 __flags_noop(&(flags));			\
-})
-#else
-#define pcp_spin_lock_maybe_irqsave(ptr, flags)		\
-		spin_lock_irqsave(&(ptr)->lock, flags)
-#define pcp_spin_unlock_maybe_irqrestore(ptr, flags)	\
-		spin_unlock_irqrestore(&(ptr)->lock, flags)
-#endif
+/*
+ * In some cases we do not need to pin the task to the CPU because we are
+ * already given a specific cpu's pcp pointer.
+ */
+#define pcp_spin_lock_nopin(ptr)			\
+		spin_lock(&(ptr)->lock)
+#define pcp_spin_unlock_nopin(ptr)			\
+		spin_unlock(&(ptr)->lock)
 
 #ifdef CONFIG_USE_PERCPU_NUMA_NODE_ID
 DEFINE_PER_CPU(int, numa_node);
@@ -2568,7 +2558,6 @@ static int rmqueue_bulk(struct zone *zon
 bool decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp)
 {
 	int high_min, to_drain, to_drain_batched, batch;
-	unsigned long UP_flags;
 	bool todo = false;
 
 	high_min = READ_ONCE(pcp->high_min);
@@ -2588,9 +2577,9 @@ bool decay_pcp_high(struct zone *zone, s
 	to_drain = pcp->count - pcp->high;
 	while (to_drain > 0) {
 		to_drain_batched = min(to_drain, batch);
-		pcp_spin_lock_maybe_irqsave(pcp, UP_flags);
+		pcp_spin_lock_nopin(pcp);
 		free_pcppages_bulk(zone, to_drain_batched, pcp, 0);
-		pcp_spin_unlock_maybe_irqrestore(pcp, UP_flags);
+		pcp_spin_unlock_nopin(pcp);
 		todo = true;
 
 		to_drain -= to_drain_batched;
@@ -2607,15 +2596,14 @@ bool decay_pcp_high(struct zone *zone, s
  */
 void drain_zone_pages(struct zone *zone, struct per_cpu_pages *pcp)
 {
-	unsigned long UP_flags;
 	int to_drain, batch;
 
 	batch = READ_ONCE(pcp->batch);
 	to_drain = min(pcp->count, batch);
 	if (to_drain > 0) {
-		pcp_spin_lock_maybe_irqsave(pcp, UP_flags);
+		pcp_spin_lock_nopin(pcp);
 		free_pcppages_bulk(zone, to_drain, pcp, 0);
-		pcp_spin_unlock_maybe_irqrestore(pcp, UP_flags);
+		pcp_spin_unlock_nopin(pcp);
 	}
 }
 #endif
@@ -2626,11 +2614,10 @@ void drain_zone_pages(struct zone *zone,
 static void drain_pages_zone(unsigned int cpu, struct zone *zone)
 {
 	struct per_cpu_pages *pcp = per_cpu_ptr(zone->per_cpu_pageset, cpu);
-	unsigned long UP_flags;
 	int count;
 
 	do {
-		pcp_spin_lock_maybe_irqsave(pcp, UP_flags);
+		pcp_spin_lock_nopin(pcp);
 		count = pcp->count;
 		if (count) {
 			int to_drain = min(count,
@@ -2639,7 +2626,7 @@ static void drain_pages_zone(unsigned in
 			free_pcppages_bulk(zone, to_drain, pcp, 0);
 			count -= to_drain;
 		}
-		pcp_spin_unlock_maybe_irqrestore(pcp, UP_flags);
+		pcp_spin_unlock_nopin(pcp);
 	} while (count);
 }
 
@@ -6123,7 +6110,6 @@ static void zone_pcp_update_cacheinfo(st
 {
 	struct per_cpu_pages *pcp;
 	struct cpu_cacheinfo *cci;
-	unsigned long UP_flags;
 
 	pcp = per_cpu_ptr(zone->per_cpu_pageset, cpu);
 	cci = get_cpu_cacheinfo(cpu);
@@ -6134,12 +6120,12 @@ static void zone_pcp_update_cacheinfo(st
 	 * This can reduce zone lock contention without hurting
 	 * cache-hot pages sharing.
 	 */
-	pcp_spin_lock_maybe_irqsave(pcp, UP_flags);
+	pcp_spin_lock_nopin(pcp);
 	if ((cci->per_cpu_data_slice_size >> PAGE_SHIFT) > 3 * pcp->batch)
 		pcp->flags |= PCPF_FREE_HIGH_BATCH;
 	else
 		pcp->flags &= ~PCPF_FREE_HIGH_BATCH;
-	pcp_spin_unlock_maybe_irqrestore(pcp, UP_flags);
+	pcp_spin_unlock_nopin(pcp);
 }
 
 void setup_pcp_cacheinfo(unsigned int cpu)
_

Patches currently in -mm which might be from vbabka@kernel.org are

maintainers-add-mm-related-procfs-files-to-mm-sections.patch

