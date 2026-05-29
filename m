Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 152EF36EAB0
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027621; cv=none; b=lB3z/ISFXGpn2lIMEvhyD7svvDvVHGmgytT5nxRJCJ3HjqZapKN1lLW3f7Ix6ugws9/hrubWv4BNeccOLUTUMqC+EbhC9o1wBUG+vpe+LG0Avda4C4TONe3LCwPhB34rwbIRlyhoY9f8Ta2k6uKogCxvh4hCKStJacRaN+64mLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027621; c=relaxed/simple;
	bh=tthM1S1VJhf7yrWpo49yZkmXOx10Sd54WLaaZNSB2Ck=;
	h=Date:To:From:Subject:Message-Id; b=Udbpawy6I4R2WmXJ55Ha3g0PdVd1raN/E+CUbdvVwqmI8ehWk1g0etzoHs8VP1eWH5AZUrhHRIQujhhx9sbeZbHpGR1LNjK5VasqX9NJ3j9ozWsisg+ymTM43tMtPNnDfvU71KK9ls4W+tNnqUXJtTNfYAv9uRY0Q90urmGFN70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rp2T5sDQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rp2T5sDQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAF701F00893;
	Fri, 29 May 2026 04:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027620;
	bh=ctexj0i5ligFGSRmNkNdeouM/mGcThjXWOwHYrDYxAA=;
	h=Date:To:From:Subject;
	b=rp2T5sDQN4OCqfNlHWkS1al02h3irMb6retdaopDH0nkiVl9cMGtiTlBneyAx/rFj
	 8Oe477vtBXS3XreEHbc6PiDPVhbi8MraBiN4e0OZNcFv6C27cwp9ewJCP70wo4cens
	 GXGu4C3cYQhHM/eBNbDp03Z4b3SY+FRGhyEmNmic=
Date: Thu, 28 May 2026 21:06:59 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,shakeel.butt@linux.dev,pmladek@suse.com,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,rientjes@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-reintroduce-page-allocation-stall-warning.patch removed from -mm tree
Message-Id: <20260529040659.DAF701F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, page_alloc: reintroduce page allocation stall warning
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-reintroduce-page-allocation-stall-warning.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, page_alloc: reintroduce page allocation stall warning
Date: Mon, 30 Mar 2026 18:20:57 -0700 (PDT)

Previously, we had warnings when a single page allocation took longer than
reasonably expected.  This was introduced in commit 63f53dea0c98 ("mm:
warn about allocations which stall for too long").

The warning was subsequently reverted in commit 400e22499dd9 ("mm: don't
warn about allocations which stall for too long") because it was possible
to generate memory pressure that would effectively stall further progress
through printk execution.

Page allocation stalls in excess of 10 seconds are always useful to debug
because they can result in severe userspace unresponsiveness.  Adding this
artifact can be used to correlate with userspace going out to lunch and to
understand the state of memory at the time.

There should be a reasonable expectation that this warning will never
trigger given it is very passive, it will only be emitted when a page
allocation takes longer than 10 seconds.  If it does trigger, this reveals
an issue that should be fixed: a single page allocation should never loop
for more than 10 seconds without oom killing to make memory available.

Unlike the original implementation, this implementation only reports
stalls once for the system every 10 seconds.  Otherwise, many concurrent
reclaimers could spam the kernel log unnecessarily.  Stalls are only
reported when calling into direct reclaim.

Link: https://lore.kernel.org/371c86c8-1d47-bd70-b74c-769842718b1f@google.com
Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

--- a/mm/page_alloc.c~mm-page_alloc-reintroduce-page-allocation-stall-warning
+++ a/mm/page_alloc.c
@@ -285,6 +285,14 @@ EXPORT_SYMBOL(nr_node_ids);
 EXPORT_SYMBOL(nr_online_nodes);
 #endif
 
+/*
+ * When page allocations stall for longer than a threshold,
+ * ALLOC_STALL_WARN_MSECS, leave a warning in the kernel log.  Only one warning
+ * will be printed during this duration for the entire system.
+ */
+#define ALLOC_STALL_WARN_MSECS (10 * 1000UL)
+static unsigned long alloc_stall_warn_jiffies = INITIAL_JIFFIES;
+
 static bool page_contains_unaccepted(struct page *page, unsigned int order);
 static bool cond_accept_memory(struct zone *zone, unsigned int order,
 			       int alloc_flags);
@@ -4688,6 +4696,40 @@ check_retry_cpuset(int cpuset_mems_cooki
 	return false;
 }
 
+static void check_alloc_stall_warn(gfp_t gfp_mask, nodemask_t *nodemask,
+				unsigned int order, unsigned long alloc_start_time)
+{
+	static DEFINE_SPINLOCK(alloc_stall_lock);
+	unsigned long stall_msecs = jiffies_to_msecs(jiffies - alloc_start_time);
+
+	if (likely(stall_msecs < ALLOC_STALL_WARN_MSECS))
+		return;
+	if (time_is_after_jiffies(READ_ONCE(alloc_stall_warn_jiffies)))
+		return;
+	if (gfp_mask & __GFP_NOWARN)
+		return;
+
+	if (!spin_trylock(&alloc_stall_lock))
+		return;
+
+	/* Check again, this time under the lock */
+	if (time_is_after_jiffies(alloc_stall_warn_jiffies)) {
+		spin_unlock(&alloc_stall_lock);
+		return;
+	}
+
+	WRITE_ONCE(alloc_stall_warn_jiffies, jiffies + msecs_to_jiffies(ALLOC_STALL_WARN_MSECS));
+	spin_unlock(&alloc_stall_lock);
+
+	pr_warn("%s: page allocation stall for %lu secs: order:%d, mode:%#x(%pGg) nodemask=%*pbl",
+		current->comm, stall_msecs / MSEC_PER_SEC, order, gfp_mask, &gfp_mask,
+		nodemask_pr_args(nodemask));
+	cpuset_print_current_mems_allowed();
+	pr_cont("\n");
+	dump_stack();
+	warn_alloc_show_mem(gfp_mask, nodemask);
+}
+
 static inline struct page *
 __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 						struct alloc_context *ac)
@@ -4708,6 +4750,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 	int reserve_flags;
 	bool compact_first = false;
 	bool can_retry_reserves = true;
+	unsigned long alloc_start_time = jiffies;
 
 	if (unlikely(nofail)) {
 		/*
@@ -4823,6 +4866,9 @@ retry:
 	if (current->flags & PF_MEMALLOC)
 		goto nopage;
 
+	/* If allocation has taken excessively long, warn about it */
+	check_alloc_stall_warn(gfp_mask, ac->nodemask, order, alloc_start_time);
+
 	/* Try direct reclaim and then allocating */
 	if (!compact_first) {
 		page = __alloc_pages_direct_reclaim(gfp_mask, order, alloc_flags,
_

Patches currently in -mm which might be from rientjes@google.com are


