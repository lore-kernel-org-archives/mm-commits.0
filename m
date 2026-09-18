Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEACF348C5D
	for <mm-commits@vger.kernel.org>; Fri, 18 Sep 2026 21:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789768227; cv=none; b=ivzgHAmyAxwqBbrhKAd/qHy+DW77WvIrqnsu1iGCvJqI9raFMKFmzBVJSmFyYGnrSnbC9ovbTaR1Xd7s7Lz4KbCPNQZmyAaYPq9nOgJzufPzObMKeZrrChJ3kEqxG6GqAfcuV8l5Ic2G68md9y5kd7TlTqPxgDUGSQxuorAYFxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789768227; c=relaxed/simple;
	bh=azImi0nNLJ6uXJaBPizbvutEFnvxbpWvuG+SpTZo7OQ=;
	h=Date:To:From:Subject:Message-Id; b=Q8NAFuc/TDWaZPXuYN0aApj8+wEl04axqQq82PuKX5//WaO3cRZkjk+9uBNcGYnA3HEC3voBZ4q8VBenchryOFopUjl7KCWoZ3rbbudrNj+76gIf34pwwMuKboSjjnDNvbIR6NCRrVFIbeCCWzfHYZrw/TNYVMMI27zs9MWHG1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VMsCW9bA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VMsCW9bA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3706F1F000FF;
	Fri, 18 Sep 2026 21:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789768225;
	bh=xOHDcBaCs1lRbamlpU58A7Ugq1r3AT9eFT9eFEK8nsM=;
	h=Date:To:From:Subject;
	b=VMsCW9bAm00RDGkJm3krARi+ppNzUWRM0sdpiVvNUvQ3us2acSkkJiMHstm5+Q20n
	 fy+8rmpdC7oxJbabGe1tQeckqS/LsTPT4pbabUqD6gvy0f+VenlXDY/IWbLq0bdVUo
	 gLUviADrRQiKiK6xz/xWDKvxKlUNavzpk6eDeHs8=
Date: Fri, 18 Sep 2026 14:50:24 -0700
To: mm-commits@vger.kernel.org,gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mempolicy-use-srcu-for-the-weighted-interleave-state.patch added to mm-unstable branch
Message-Id: <20260918215025.3706F1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mempolicy: use SRCU for the weighted interleave state
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mempolicy-use-srcu-for-the-weighted-interleave-state.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mempolicy-use-srcu-for-the-weighted-interleave-state.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Gregory Price <gourry@gourry.net>
Subject: mm/mempolicy: use SRCU for the weighted interleave state
Date: Thu, 17 Sep 2026 20:12:02 -0400

Patch series "mm/mempolicy: stop copying state in the interleave paths", v2.

The interleave node selectors and bulk allocators take copies of nodemasks
and node weights (for weighted interleave) in the fault path.  Both of
these copies can be entirely eliminated.

For node weights, use SRCU to pin the weights in place.  This eliminates a
copy and a kmalloc from the bulk allocator path.

For nodemasks, we can operate directly on pol->nodes as long as we bounds
check the walk.  A concurrent rebind can shrink the mask, or tear the read
of it so the mask appears empty.

 - The interleave node selectors fall back to numa_node_id() when that
   happens, which is what they already did when a copy came back empty.

 - The bulk allocator simply returns what it managed to allocate.

The node count and weight totals are read separately from the nodemask
walk that consumes them - creating a time-of-check / time-of-use race. 
Just clamp the walk to a single pass (number of nodes), and clamp each
bulk allocation chunk to the space left in the request.

The cost is distribution accuracy during a rebind.  The copies never
corrected for that either - they only kept the code from dividing by zero
and overrunning the allocation request.


This patch (of 2):

alloc_pages_bulk_weighted_interleave() copies iw_table into a scratch
array on every call so it can walk the weights outside of RCU.  The copy
exists only because the loop may sleep in the page allocator and so cannot
hold rcu_read_lock().

Use SRCU to pin the global iw_table object and use it in-place instead.

Retire through both flavors - call_srcu() for the sleeping readers, then
kfree_rcu() for the reference-less ones - so writers no longer block on
synchronize_rcu() either.

Tested in a VM with KASAN, PROVE_LOCKING and DEBUG_OBJECTS_RCU_HEAD, with
a udelay() injected into the read section to widen the race against
concurrent sysfs weight writers, and placement checked against the
configured weights.

Every retired state reached its callback.  Swapping the deferred free for
a bare kfree() in the same test reports a use-after-free immediately.

Link: https://lore.kernel.org/20260918001203.3389165-1-gourry@gourry.net
Link: https://lore.kernel.org/20260918001203.3389165-2-gourry@gourry.net
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Assisted-by: LLM
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Zi Yan <ziy@nvidia.com>
---

 mm/mempolicy.c |   70 ++++++++++++++++++++++-------------------------
 1 file changed, 34 insertions(+), 36 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-use-srcu-for-the-weighted-interleave-state
+++ a/mm/mempolicy.c
@@ -112,6 +112,7 @@
 #include <linux/printk.h>
 #include <linux/leafops.h>
 #include <linux/gcd.h>
+#include <linux/srcu.h>
 
 #include <asm/tlbflush.h>
 #include <asm/tlb.h>
@@ -157,6 +158,7 @@ static const int weightiness = 32;
  */
 struct weighted_interleave_state {
 	bool mode_auto;
+	struct rcu_head rcu;
 	u8 iw_table[];
 };
 static struct weighted_interleave_state __rcu *wi_state;
@@ -168,6 +170,24 @@ static unsigned int *node_bw_table;
  */
 static DEFINE_MUTEX(wi_state_lock);
 
+/* Readers that sleep while walking iw_table hold this instead */
+DEFINE_STATIC_SRCU_FAST(wi_srcu);
+
+static void wi_state_free_rcu(struct rcu_head *head)
+{
+	struct weighted_interleave_state *state =
+		container_of(head, struct weighted_interleave_state, rcu);
+
+	kfree_rcu(state, rcu);
+}
+
+/* Retire through both flavors: sleeping readers use SRCU, the rest RCU */
+static void wi_state_retire(struct weighted_interleave_state *state)
+{
+	if (state)
+		call_srcu(&wi_srcu, &state->rcu, wi_state_free_rcu);
+}
+
 static u8 get_il_weight(int node)
 {
 	struct weighted_interleave_state *state;
@@ -266,10 +286,7 @@ int mempolicy_set_node_perf(unsigned int
 	rcu_assign_pointer(wi_state, new_wi_state);
 
 	mutex_unlock(&wi_state_lock);
-	if (old_wi_state) {
-		synchronize_rcu();
-		kfree(old_wi_state);
-	}
+	wi_state_retire(old_wi_state);
 out:
 	kfree(old_bw);
 	return 0;
@@ -2644,7 +2661,8 @@ static unsigned long alloc_pages_bulk_we
 	unsigned long nr_allocated = 0;
 	unsigned long rounds;
 	unsigned long node_pages, delta;
-	u8 *weights, weight;
+	struct srcu_ctr __percpu *scp;
+	u8 *table, weight;
 	unsigned int weight_total = 0;
 	unsigned long rem_pages = nr_pages;
 	nodemask_t nodes;
@@ -2688,25 +2706,14 @@ static unsigned long alloc_pages_bulk_we
 	me->il_weight = 0;
 	prev_node = node;
 
-	/* create a local copy of node weights to operate on outside rcu */
-	weights = kmalloc(nr_node_ids, gfp & GFP_RECLAIM_MASK);
-	if (!weights)
-		return total_allocated;
-
-	rcu_read_lock();
-	state = rcu_dereference(wi_state);
-	if (state) {
-		memcpy(weights, state->iw_table, nr_node_ids * sizeof(u8));
-		rcu_read_unlock();
-	} else {
-		rcu_read_unlock();
-		for (i = 0; i < nr_node_ids; i++)
-			weights[i] = 1;
-	}
+	/* The page allocator may sleep, pin the weight table with SRCU */
+	scp = srcu_read_lock_fast(&wi_srcu);
+	state = srcu_dereference(wi_state, &wi_srcu);
+	table = state ? state->iw_table : NULL;
 
 	/* calculate total, detect system default usage */
 	for_each_node_mask(node, nodes)
-		weight_total += weights[node];
+		weight_total += table ? table[node] : 1;
 
 	/*
 	 * Calculate rounds/partial rounds to minimize __alloc_pages_bulk calls.
@@ -2718,10 +2725,10 @@ static unsigned long alloc_pages_bulk_we
 	rounds = rem_pages / weight_total;
 	delta = rem_pages % weight_total;
 	resume_node = next_node_in(prev_node, nodes);
-	resume_weight = weights[resume_node];
+	resume_weight = table ? table[resume_node] : 1;
 	for (i = 0; i < nnodes; i++) {
 		node = next_node_in(prev_node, nodes);
-		weight = weights[node];
+		weight = table ? table[node] : 1;
 		node_pages = weight * rounds;
 		/* If a delta exists, add this node's portion of the delta */
 		if (delta > weight) {
@@ -2747,7 +2754,7 @@ static unsigned long alloc_pages_bulk_we
 	}
 	me->il_prev = resume_node;
 	me->il_weight = resume_weight;
-	kfree(weights);
+	srcu_read_unlock_fast(&wi_srcu, scp);
 	return total_allocated;
 }
 
@@ -3673,10 +3680,7 @@ static ssize_t node_store(struct kobject
 
 	rcu_assign_pointer(wi_state, new_wi_state);
 	mutex_unlock(&wi_state_lock);
-	if (old_wi_state) {
-		synchronize_rcu();
-		kfree(old_wi_state);
-	}
+	wi_state_retire(old_wi_state);
 	return count;
 }
 
@@ -3742,10 +3746,7 @@ static ssize_t weighted_interleave_auto_
 update_wi_state:
 	rcu_assign_pointer(wi_state, new_wi_state);
 	mutex_unlock(&wi_state_lock);
-	if (old_wi_state) {
-		synchronize_rcu();
-		kfree(old_wi_state);
-	}
+	wi_state_retire(old_wi_state);
 	return count;
 }
 
@@ -3789,10 +3790,7 @@ static void wi_state_free(void)
 	rcu_assign_pointer(wi_state, NULL);
 	mutex_unlock(&wi_state_lock);
 
-	if (old_wi_state) {
-		synchronize_rcu();
-		kfree(old_wi_state);
-	}
+	wi_state_retire(old_wi_state);
 }
 
 static struct kobj_attribute wi_auto_attr = {
_

Patches currently in -mm which might be from gourry@gourry.net are

mm-mempolicy-take-a-cpuset-cookie-for-the-interleave-node-count.patch
mm-mempolicy-use-srcu-for-the-weighted-interleave-state.patch
mm-mempolicy-stop-copying-the-nodemask-in-the-interleave-paths.patch
mm-huge_memory-skip-zone-device-folios-in-madvise_free_huge_pmd.patch
mm-madvise-skip-zone-device-folios-in-cold-pageout-pmd-range.patch
mm-mempolicy-skip-zone-device-folios-when-queueing-folios.patch
mm-memory_hotplug-factor-out-node_is_memoryless.patch
mm-mempolicy-use-vm_normal_folio_pmd-in-queue_folios_pmd.patch
mm-madvise-use-vm_normal_folio_pmd-in-cold-pageout-pmd-range.patch
mm-refactor-find_next_best_node-to-find_next_best_node_in.patch
mm-page_alloc-refactor-build_node_zonelist-out-of-build_zonelists.patch
proc-task_mmu-handle-special-pmds-in-clear_refs-and-pagemap.patch
mm-madvise-reclaim-isolated-folios-if-pte-restart-fails.patch
mm-madvise-use-folio_trylock-in-the-cold-pageout-pmd-split.patch

