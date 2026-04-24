Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D5CF3F23BD
	for <mm-commits@vger.kernel.org>; Fri, 24 Apr 2026 19:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777059992; cv=none; b=ozc25lGfcSYWJZdfGk4ufDgFkRSRGpKlrQP6sDHxALcEoq7pll8Afs9c2sS33F2rqTmN5SKKkx5BKAwOPRWTPXKiEH+jILeq+PwB/x5VEkUx8OqP5OAvpSKOLyT442Xd8C4Jyit/mLQYUs5y1dUZWfHVIYwwLFlY9ovf7BBgxsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777059992; c=relaxed/simple;
	bh=/7/3Ugi9Xq2CE5+9Vgbqk70EK/mfWDT2QXIrmOOxNwk=;
	h=Date:To:From:Subject:Message-Id; b=K3LHU/kVYMujdBmywJ3euMj6cq+GK3QEf4+Ydx6KePA5Gc8ZREKVQSW9Jp2XCi6NcOGFGrPncrgkIaAdQWNcCjkbTpwRpqID/Tk5bA3Ls1olj/loomh0d6HJcKAnnxt3oYyEh5VXUTuOd3FlKkx+NSnJZUAGDLhMH8foIt9T5og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vjdM5D0G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vjdM5D0G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 150A2C19425;
	Fri, 24 Apr 2026 19:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777059992;
	bh=/7/3Ugi9Xq2CE5+9Vgbqk70EK/mfWDT2QXIrmOOxNwk=;
	h=Date:To:From:Subject:From;
	b=vjdM5D0G0woexIGlTsp/ZH1gfOiW/iT6Tpx1PDnzs5bBvpWlwLHrYbNZSmZpSjFXz
	 1zgR2qnWyKGHM3wBbWuLrp1893bn1897ZOyc1Itl0vp1CUQY+kisMlw0L22yQkEoeV
	 G4cCMwKGVWkvfahsegH6t1913yIYMrhCJ/Nkv8CY=
Date: Fri, 24 Apr 2026 12:46:31 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,shakeel.butt@linux.dev,pmladek@suse.com,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,rientjes@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-reintroduce-page-allocation-stall-warning.patch added to mm-new branch
Message-Id: <20260424194632.150A2C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, page_alloc: reintroduce page allocation stall warning
has been added to the -mm mm-new branch.  Its filename is
     mm-page_alloc-reintroduce-page-allocation-stall-warning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-reintroduce-page-allocation-stall-warning.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
@@ -4678,6 +4686,40 @@ check_retry_cpuset(int cpuset_mems_cooki
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
@@ -4698,6 +4740,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 	int reserve_flags;
 	bool compact_first = false;
 	bool can_retry_reserves = true;
+	unsigned long alloc_start_time = jiffies;
 
 	if (unlikely(nofail)) {
 		/*
@@ -4813,6 +4856,9 @@ retry:
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

mm-page_alloc-reintroduce-page-allocation-stall-warning.patch

