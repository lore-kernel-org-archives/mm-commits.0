Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71BA4431A22
	for <mm-commits@vger.kernel.org>; Sat, 29 Aug 2026 23:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788045542; cv=none; b=OAA3Qo63jndixyn1KcvwPnyJ9c5CcdbSmCkh5PVXCgkTWLoa0GPRs6xD20KFD3FX+NpoR7sc/PCxcUALbcLDKF3C1gwa5she+qyUQlyRq4scJczvTXZZt39FoV4JU4WVboY4Zro33IGjuu3KRazY1UBxFDeQThgcMWc5ZUO6jjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788045542; c=relaxed/simple;
	bh=Ke3c6CORu7KH/hQXTeOe263WHBJeFL6QH/Ozz8eEluc=;
	h=Date:To:From:Subject:Message-Id; b=bcUsR6EgtDOTnJqBtesJHs9tfY3hFu9h6EzYZu01el6rEl225mwnLyN832F5JY0CSztPlMH+/ybxYeuc3q5EtUKM2yTAYtPmL0tae9a6EsvTS1quLGdqOxbFFA9a7Y66g8I0EkPSYc10VzjgpcuHdvCdlX7TTjTGmBrCoxIYxd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=C0a4TIkA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="C0a4TIkA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEEDA1F000E9;
	Sat, 29 Aug 2026 23:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788045540;
	bh=+hW6zBmnbjMrp70GwFtIZ/D0Kd/nI4o6Tt8PLsEPB2I=;
	h=Date:To:From:Subject;
	b=C0a4TIkABSHP8mopJF6i59TPXo1mcZ4dSYZzdmtXGSWhZWAOhh/i7Ken66D9jOmn0
	 fDpkZdRxoEGqugVTk/1IKy5k9Jnp0FybiHhjpqN54+koj5zpVNMO1ITUbtpgT0qnSv
	 cBxqaLd1WVZnRh4AX4iKWEhjJBxSlOMgtASyeQlA=
Date: Sat, 29 Aug 2026 16:18:59 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,willy@infradead.org,urezki@gmail.com,rakie.kim@sk.com,joshua.hahnjy@gmail.com,david@kernel.org,chenwandun@huawei.com,byungchul@sk.com,apopple@nvidia.com,akpm@linux-foundation.org,gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mempolicy-use-srcu-for-the-weighted-interleave-state.patch added to mm-new branch
Message-Id: <20260829231859.DEEDA1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mempolicy: use SRCU for the weighted interleave state
has been added to the -mm mm-new branch.  Its filename is
     mm-mempolicy-use-srcu-for-the-weighted-interleave-state.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mempolicy-use-srcu-for-the-weighted-interleave-state.patch

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
From: Gregory Price <gourry@gourry.net>
Subject: mm/mempolicy: use SRCU for the weighted interleave state
Date: Fri, 28 Aug 2026 21:59:42 -0400

Patch series "mm/mempolicy: stop copying state in the interleave paths".

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

Link: https://lore.kernel.org/20260829015943.1258774-1-gourry@gourry.net
Link: https://lore.kernel.org/20260829015943.1258774-2-gourry@gourry.net
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Assisted-by: Claude:claude-opus-5
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Chenwandun <chenwandun@huawei.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

