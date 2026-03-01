Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84522244665
	for <mm-commits@vger.kernel.org>; Sun,  1 Mar 2026 01:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772327885; cv=none; b=dta95R47OVGuNIAsO71Ii3dYEOrceztZf2l3s3YiWw9c4Dk9Kdb6CdlsWVYBWNdciyLIUlSjJnj/FHd0bASL7P5bFtDuQMYqFodlRug3s+kORu7IaGQl6G+n5uSijiBwFrxgDto3yuirz1VJeyKUqoYychKIxpHmcUAKY+iDGzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772327885; c=relaxed/simple;
	bh=1MViojPsQIeIeJpCwfASa/lxTS0FsUuamThK++v24WI=;
	h=Date:To:From:Subject:Message-Id; b=sbB9YdeXGZs+mT7Kux+cjbPLJK9whkNwazVHikCF2h+QGG9NzCbxrn2IpZIEHKtys+OZ3gX3jQWRBkikkaG2BwWk4pfH0xCIgmBLX36/MAQwWpSEFvx8whCXs5Wemie7ma9RK/XFmY5HcjzCdIuu+Klw69r9JnK7Tag+jD8vT20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kp6XxaV1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kp6XxaV1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41972C19421;
	Sun,  1 Mar 2026 01:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772327885;
	bh=1MViojPsQIeIeJpCwfASa/lxTS0FsUuamThK++v24WI=;
	h=Date:To:From:Subject:From;
	b=kp6XxaV1JPJ3+f1FvM6iKsUzMy2TroQ9uGusPPnnkqyGFXYiE5jmE6U6gZ9v1V1ck
	 utDMNkhJbQwPJIAuIkgoa1CnbkVz9vXvmLpwM0TQRJSc3/lu9ORjvrckRciZ8CYwhj
	 TNnYUSgTusWK90NWaZsNrp8BvWB3amyXkwx/NMv0=
Date: Sat, 28 Feb 2026 17:18:04 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,surenb@google.com,rostedt@goodmis.org,mhocko@suse.com,mgorman@techsingularity.net,jackmanb@google.com,hannes@cmpxchg.org,david@kernel.org,bigeasy@linutronix.de,vbabka@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-remove-irq-saving-restoring-from-pcp-locking.patch added to mm-new branch
Message-Id: <20260301011805.41972C19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: remove IRQ saving/restoring from pcp locking
has been added to the -mm mm-new branch.  Its filename is
     mm-page_alloc-remove-irq-saving-restoring-from-pcp-locking.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-remove-irq-saving-restoring-from-pcp-locking.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
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
@@ -155,24 +155,14 @@ static DEFINE_MUTEX(pcp_batch_high_lock)
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
@@ -2572,7 +2562,6 @@ static int rmqueue_bulk(struct zone *zon
 bool decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp)
 {
 	int high_min, to_drain, to_drain_batched, batch;
-	unsigned long UP_flags;
 	bool todo = false;
 
 	high_min = READ_ONCE(pcp->high_min);
@@ -2592,9 +2581,9 @@ bool decay_pcp_high(struct zone *zone, s
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
@@ -2611,15 +2600,14 @@ bool decay_pcp_high(struct zone *zone, s
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
@@ -2630,11 +2618,10 @@ void drain_zone_pages(struct zone *zone,
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
@@ -2643,7 +2630,7 @@ static void drain_pages_zone(unsigned in
 			free_pcppages_bulk(zone, to_drain, pcp, 0);
 			count -= to_drain;
 		}
-		pcp_spin_unlock_maybe_irqrestore(pcp, UP_flags);
+		pcp_spin_unlock_nopin(pcp);
 	} while (count);
 }
 
@@ -6127,7 +6114,6 @@ static void zone_pcp_update_cacheinfo(st
 {
 	struct per_cpu_pages *pcp;
 	struct cpu_cacheinfo *cci;
-	unsigned long UP_flags;
 
 	pcp = per_cpu_ptr(zone->per_cpu_pageset, cpu);
 	cci = get_cpu_cacheinfo(cpu);
@@ -6138,12 +6124,12 @@ static void zone_pcp_update_cacheinfo(st
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

mm-page_alloc-effectively-disable-pcp-with-config_smp=n.patch
mm-page_alloc-remove-irq-saving-restoring-from-pcp-locking.patch
mm-page_alloc-remove-pcpu_spin_-wrappers.patch

