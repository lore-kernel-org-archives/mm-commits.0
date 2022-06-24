Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFF63CCA473
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jun 2022 19:08:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229446AbiFXTI2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Jun 2022 15:08:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230400AbiFXTI1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jun 2022 15:08:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BA843EF31
        for <mm-commits@vger.kernel.org>; Fri, 24 Jun 2022 12:08:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 42D20621A1
        for <mm-commits@vger.kernel.org>; Fri, 24 Jun 2022 19:08:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94F9FC34114;
        Fri, 24 Jun 2022 19:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656097701;
        bh=k4XgMTvvZEBHDqrRWrc9GrGAzMgOycgf8W3OaFSfTcY=;
        h=Date:To:From:Subject:From;
        b=VDHji0yZcO/6NKZMSptBGFgcQ8LrI+YSkJI21HIY07Vbc3eQHh2lw5/d1rZW5pJ3g
         OSgrFpg5OWuqGntC3sD12o+izKUdB/G1dw4BTgFVjjc+13soB0zzr8orlH2tMBhL0F
         IG+Jwq3yTAlBUd7TN5Cu+CnqP63bQ0zu7+mYgHDs=
Date:   Fri, 24 Jun 2022 12:08:20 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, vbabka@suse.cz,
        nsaenzju@redhat.com, mtosatti@redhat.com, m.szyprowski@samsung.com,
        minchan@kernel.org, mhocko@kernel.org, hughd@google.com,
        mgorman@techsingularity.net, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-replace-local_lock-with-normal-spinlock.patch added to mm-unstable branch
Message-Id: <20220624190821.94F9FC34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: replace local_lock with normal spinlock
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-replace-local_lock-with-normal-spinlock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-replace-local_lock-with-normal-spinlock.patch

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
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/page_alloc: replace local_lock with normal spinlock
Date: Fri, 24 Jun 2022 13:54:23 +0100

struct per_cpu_pages is no longer strictly local as PCP lists can be
drained remotely using a lock for protection.  While the use of local_lock
works, it goes against the intent of local_lock which is for "pure CPU
local concurrency control mechanisms and not suited for inter-CPU
concurrency control" (Documentation/locking/locktypes.rst)

local_lock protects against migration between when the percpu pointer is
accessed and the pcp->lock acquired.  The lock acquisition is a preemption
point so in the worst case, a task could migrate to another NUMA node and
accidentally allocate remote memory.  The main requirement is to pin the
task to a CPU that is suitable for PREEMPT_RT and !PREEMPT_RT.

Replace local_lock with helpers that pin a task to a CPU, lookup the
per-cpu structure and acquire the embedded lock.  It's similar to
local_lock without breaking the intent behind the API.  It is not a
complete API as only the parts needed for PCP-alloc are implemented but in
theory, the generic helpers could be promoted to a general API if there
was demand for an embedded lock within a per-cpu struct with a guarantee
that the per-cpu structure locked matches the running CPU and cannot use
get_cpu_var due to RT concerns.  PCP requires these semantics to avoid
accidentally allocating remote memory.

Link: https://lkml.kernel.org/r/20220624125423.6126-8-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nicolas Saenz Julienne <nsaenzju@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |  139 +++++++++++++++++++++++++++++++---------------
 1 file changed, 95 insertions(+), 44 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-replace-local_lock-with-normal-spinlock
+++ a/mm/page_alloc.c
@@ -126,13 +126,6 @@ typedef int __bitwise fpi_t;
 static DEFINE_MUTEX(pcp_batch_high_lock);
 #define MIN_PERCPU_PAGELIST_HIGH_FRACTION (8)
 
-struct pagesets {
-	local_lock_t lock;
-};
-static DEFINE_PER_CPU(struct pagesets, pagesets) = {
-	.lock = INIT_LOCAL_LOCK(lock),
-};
-
 #if defined(CONFIG_SMP) || defined(CONFIG_PREEMPT_RT)
 /*
  * On SMP, spin_trylock is sufficient protection.
@@ -147,6 +140,83 @@ static DEFINE_PER_CPU(struct pagesets, p
 #define pcp_trylock_finish(flags)	local_irq_restore(flags)
 #endif
 
+/*
+ * Locking a pcp requires a PCP lookup followed by a spinlock. To avoid
+ * a migration causing the wrong PCP to be locked and remote memory being
+ * potentially allocated, pin the task to the CPU for the lookup+lock.
+ * preempt_disable is used on !RT because it is faster than migrate_disable.
+ * migrate_disable is used on RT because otherwise RT spinlock usage is
+ * interfered with and a high priority task cannot preempt the allocator.
+ */
+#ifndef CONFIG_PREEMPT_RT
+#define pcpu_task_pin()		preempt_disable()
+#define pcpu_task_unpin()	preempt_enable()
+#else
+#define pcpu_task_pin()		migrate_disable()
+#define pcpu_task_unpin()	migrate_enable()
+#endif
+
+/*
+ * Generic helper to lookup and a per-cpu variable with an embedded spinlock.
+ * Return value should be used with equivalent unlock helper.
+ */
+#define pcpu_spin_lock(type, member, ptr)				\
+({									\
+	type *_ret;							\
+	pcpu_task_pin();						\
+	_ret = this_cpu_ptr(ptr);					\
+	spin_lock(&_ret->member);					\
+	_ret;								\
+})
+
+#define pcpu_spin_lock_irqsave(type, member, ptr, flags)		\
+({									\
+	type *_ret;							\
+	pcpu_task_pin();						\
+	_ret = this_cpu_ptr(ptr);					\
+	spin_lock_irqsave(&_ret->member, flags);			\
+	_ret;								\
+})
+
+#define pcpu_spin_trylock_irqsave(type, member, ptr, flags)		\
+({									\
+	type *_ret;							\
+	pcpu_task_pin();						\
+	_ret = this_cpu_ptr(ptr);					\
+	if (!spin_trylock_irqsave(&_ret->member, flags)) {		\
+		pcpu_task_unpin();					\
+		_ret = NULL;						\
+	}								\
+	_ret;								\
+})
+
+#define pcpu_spin_unlock(member, ptr)					\
+({									\
+	spin_unlock(&ptr->member);					\
+	pcpu_task_unpin();						\
+})
+
+#define pcpu_spin_unlock_irqrestore(member, ptr, flags)			\
+({									\
+	spin_unlock_irqrestore(&ptr->member, flags);			\
+	pcpu_task_unpin();						\
+})
+
+/* struct per_cpu_pages specific helpers. */
+#define pcp_spin_lock(ptr)						\
+	pcpu_spin_lock(struct per_cpu_pages, lock, ptr)
+
+#define pcp_spin_lock_irqsave(ptr, flags)				\
+	pcpu_spin_lock_irqsave(struct per_cpu_pages, lock, ptr, flags)
+
+#define pcp_spin_trylock_irqsave(ptr, flags)				\
+	pcpu_spin_trylock_irqsave(struct per_cpu_pages, lock, ptr, flags)
+
+#define pcp_spin_unlock(ptr)						\
+	pcpu_spin_unlock(lock, ptr)
+
+#define pcp_spin_unlock_irqrestore(ptr, flags)				\
+	pcpu_spin_unlock_irqrestore(lock, ptr, flags)
 #ifdef CONFIG_USE_PERCPU_NUMA_NODE_ID
 DEFINE_PER_CPU(int, numa_node);
 EXPORT_PER_CPU_SYMBOL(numa_node);
@@ -1485,10 +1555,7 @@ static void free_pcppages_bulk(struct zo
 	/* Ensure requested pindex is drained first. */
 	pindex = pindex - 1;
 
-	/*
-	 * local_lock_irq held so equivalent to spin_lock_irqsave for
-	 * both PREEMPT_RT and non-PREEMPT_RT configurations.
-	 */
+	/* Caller must hold IRQ-safe pcp->lock so IRQs are disabled. */
 	spin_lock(&zone->lock);
 	isolated_pageblocks = has_isolate_pageblock(zone);
 
@@ -3056,10 +3123,7 @@ static int rmqueue_bulk(struct zone *zon
 {
 	int i, allocated = 0;
 
-	/*
-	 * local_lock_irq held so equivalent to spin_lock_irqsave for
-	 * both PREEMPT_RT and non-PREEMPT_RT configurations.
-	 */
+	/* Caller must hold IRQ-safe pcp->lock so IRQs are disabled. */
 	spin_lock(&zone->lock);
 	for (i = 0; i < count; ++i) {
 		struct page *page = __rmqueue(zone, order, migratetype,
@@ -3431,18 +3495,16 @@ void free_unref_page(struct page *page,
 		migratetype = MIGRATE_MOVABLE;
 	}
 
-	local_lock_irqsave(&pagesets.lock, flags);
 	zone = page_zone(page);
 	pcp_trylock_prepare(UP_flags);
-	pcp = this_cpu_ptr(zone->per_cpu_pageset);
-	if (spin_trylock(&pcp->lock)) {
+	pcp = pcpu_spin_trylock_irqsave(struct per_cpu_pages, lock, zone->per_cpu_pageset, flags);
+	if (pcp) {
 		free_unref_page_commit(zone, pcp, page, migratetype, order);
-		spin_unlock(&pcp->lock);
+		pcp_spin_unlock_irqrestore(pcp, flags);
 	} else {
 		free_one_page(zone, page, pfn, order, migratetype, FPI_NONE);
 	}
 	pcp_trylock_finish(UP_flags);
-	local_unlock_irqrestore(&pagesets.lock, flags);
 }
 
 /*
@@ -3477,17 +3539,16 @@ void free_unref_page_list(struct list_he
 		}
 	}
 
-	local_lock_irqsave(&pagesets.lock, flags);
 	list_for_each_entry_safe(page, next, list, lru) {
 		struct zone *zone = page_zone(page);
 
 		/* Different zone, different pcp lock. */
 		if (zone != locked_zone) {
 			if (pcp)
-				spin_unlock(&pcp->lock);
+				pcp_spin_unlock_irqrestore(pcp, flags);
+
 			locked_zone = zone;
-			pcp = this_cpu_ptr(zone->per_cpu_pageset);
-			spin_lock(&pcp->lock);
+			pcp = pcp_spin_lock_irqsave(locked_zone->per_cpu_pageset, flags);
 		}
 
 		/*
@@ -3506,18 +3567,14 @@ void free_unref_page_list(struct list_he
 		 * a large list of pages to free.
 		 */
 		if (++batch_count == SWAP_CLUSTER_MAX) {
-			spin_unlock(&pcp->lock);
-			local_unlock_irqrestore(&pagesets.lock, flags);
+			pcp_spin_unlock_irqrestore(pcp, flags);
 			batch_count = 0;
-			local_lock_irqsave(&pagesets.lock, flags);
-			pcp = this_cpu_ptr(locked_zone->per_cpu_pageset);
-			spin_lock(&pcp->lock);
+			pcp = pcp_spin_lock_irqsave(locked_zone->per_cpu_pageset, flags);
 		}
 	}
 
 	if (pcp)
-		spin_unlock(&pcp->lock);
-	local_unlock_irqrestore(&pagesets.lock, flags);
+		pcp_spin_unlock_irqrestore(pcp, flags);
 }
 
 /*
@@ -3732,15 +3789,13 @@ static struct page *rmqueue_pcplist(stru
 	unsigned long flags;
 	unsigned long __maybe_unused UP_flags;
 
-	local_lock_irqsave(&pagesets.lock, flags);
-
 	/*
 	 * spin_trylock may fail due to a parallel drain. In the future, the
 	 * trylock will also protect against IRQ reentrancy.
 	 */
-	pcp = this_cpu_ptr(zone->per_cpu_pageset);
 	pcp_trylock_prepare(UP_flags);
-	if (!spin_trylock(&pcp->lock)) {
+	pcp = pcp_spin_trylock_irqsave(zone->per_cpu_pageset, flags);
+	if (!pcp) {
 		pcp_trylock_finish(UP_flags);
 		return NULL;
 	}
@@ -3753,9 +3808,8 @@ static struct page *rmqueue_pcplist(stru
 	pcp->free_factor >>= 1;
 	list = &pcp->lists[order_to_pindex(migratetype, order)];
 	page = __rmqueue_pcplist(zone, order, migratetype, alloc_flags, pcp, list);
-	spin_unlock(&pcp->lock);
+	pcp_spin_unlock_irqrestore(pcp, flags);
 	pcp_trylock_finish(UP_flags);
-	local_unlock_irqrestore(&pagesets.lock, flags);
 	if (page) {
 		__count_zid_vm_events(PGALLOC, page_zonenum(page), 1);
 		zone_statistics(preferred_zone, zone, 1);
@@ -5349,10 +5403,9 @@ unsigned long __alloc_pages_bulk(gfp_t g
 		goto failed;
 
 	/* Is a parallel drain in progress? */
-	local_lock_irqsave(&pagesets.lock, flags);
 	pcp_trylock_prepare(UP_flags);
-	pcp = this_cpu_ptr(zone->per_cpu_pageset);
-	if (!spin_trylock(&pcp->lock))
+	pcp = pcp_spin_trylock_irqsave(zone->per_cpu_pageset, flags);
+	if (!pcp)
 		goto failed_irq;
 
 	/* Attempt the batch allocation */
@@ -5370,7 +5423,7 @@ unsigned long __alloc_pages_bulk(gfp_t g
 		if (unlikely(!page)) {
 			/* Try and allocate at least one page */
 			if (!nr_account) {
-				spin_unlock(&pcp->lock);
+				pcp_spin_unlock_irqrestore(pcp, flags);
 				goto failed_irq;
 			}
 			break;
@@ -5385,9 +5438,8 @@ unsigned long __alloc_pages_bulk(gfp_t g
 		nr_populated++;
 	}
 
-	spin_unlock(&pcp->lock);
+	pcp_spin_unlock_irqrestore(pcp, flags);
 	pcp_trylock_finish(UP_flags);
-	local_unlock_irqrestore(&pagesets.lock, flags);
 
 	__count_zid_vm_events(PGALLOC, zone_idx(zone), nr_account);
 	zone_statistics(ac.preferred_zoneref->zone, zone, nr_account);
@@ -5397,7 +5449,6 @@ out:
 
 failed_irq:
 	pcp_trylock_finish(UP_flags);
-	local_unlock_irqrestore(&pagesets.lock, flags);
 
 failed:
 	page = __alloc_pages(gfp, 0, preferred_nid, nodemask);
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-add-page-buddy_list-and-page-pcp_list.patch
mm-page_alloc-use-only-one-pcp-list-for-thp-sized-allocations.patch
mm-page_alloc-split-out-buddy-removal-code-from-rmqueue-into-separate-helper.patch
mm-page_alloc-remove-mistaken-page-==-null-check-in-rmqueue.patch
mm-page_alloc-protect-pcp-lists-with-a-spinlock.patch
mm-page_alloc-replace-local_lock-with-normal-spinlock.patch

