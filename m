From: akpm@linux-foundation.org
Subject: [merged] mm-make-set_mempolicympol_interleav-n_high_memory-aware.patch removed from -mm tree
Date: Mon, 10 Aug 2009 12:27:15 -0700
Message-ID: <200908101927.n7AJRFql025558@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40305 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752358AbZHJT1q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Aug 2009 15:27:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, a.p.zijlstra@chello.nl, cl@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, menage@google.com, miaox@cn.fujitsu.com, ming


The patch titled
     mm: make set_mempolicy(MPOL_INTERLEAV) N_HIGH_MEMORY aware
has been removed from the -mm tree.  Its filename was
     mm-make-set_mempolicympol_interleav-n_high_memory-aware.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: make set_mempolicy(MPOL_INTERLEAV) N_HIGH_MEMORY aware
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

At first, init_task's mems_allowed is initialized as this.
 init_task->mems_allowed == node_state[N_POSSIBLE]

And cpuset's top_cpuset mask is initialized as this
 top_cpuset->mems_allowed = node_state[N_HIGH_MEMORY]

Before 2.6.29:
policy's mems_allowed is initialized as this.

  1. update tasks->mems_allowed by its cpuset->mems_allowed.
  2. policy->mems_allowed = nodes_and(tasks->mems_allowed, user's mask)

Updating task's mems_allowed in reference to top_cpuset's one.
cpuset's mems_allowed is aware of N_HIGH_MEMORY, always.


In 2.6.30: After commit 58568d2a8215cb6f55caf2332017d7bdff954e1c
("cpuset,mm: update tasks' mems_allowed in time"), policy's mems_allowed
is initialized as this.

  1. policy->mems_allowd = nodes_and(task->mems_allowed, user's mask)

Here, if task is in top_cpuset, task->mems_allowed is not updated from
init's one.  Assume user excutes command as #numactrl --interleave=all
,....

  policy->mems_allowd = nodes_and(N_POSSIBLE, ALL_SET_MASK)

Then, policy's mems_allowd can includes a possible node, which has no pgdat.

MPOL's INTERLEAVE just scans nodemask of task->mems_allowd and access this
directly.

  NODE_DATA(nid)->zonelist even if NODE_DATA(nid)==NULL


Then, what's we need is making policy->mems_allowed be aware of
N_HIGH_MEMORY.  This patch does that.  But to do so, extra nodemask will
be on statck.  Because I know cpumask has a new interface of
CPUMASK_ALLOC(), I added it to node.

This patch stands on old behavior.  But I feel this fix itself is just a
Band-Aid.  But to do fundametal fix, we have to take care of memory
hotplug and it takes time.  (task->mems_allowd should be N_HIGH_MEMORY, I
think.)




mpol_set_nodemask() should be aware of N_HIGH_MEMORY and policy's nodemask
should be includes only online nodes.

In old behavior, this is guaranteed by frequent reference to cpuset's
code.  Now, most of them are removed and mempolicy has to check it by
itself.

To do check, a few nodemask_t will be used for calculating nodemask.  But,
size of nodemask_t can be big and it's not good to allocate them on stack.

Now, cpumask_t has CPUMASK_ALLOC/FREE an easy code for get scratch area. 
NODEMASK_ALLOC/FREE shoudl be there.

[akpm@linux-foundation.org: cleanups & tweaks]
Tested-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Miao Xie <miaox@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Paul Menage <menage@google.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nodemask.h |   28 ++++++++++++
 mm/mempolicy.c           |   84 +++++++++++++++++++++++++------------
 2 files changed, 86 insertions(+), 26 deletions(-)

diff -puN include/linux/nodemask.h~mm-make-set_mempolicympol_interleav-n_high_memory-aware include/linux/nodemask.h
--- a/include/linux/nodemask.h~mm-make-set_mempolicympol_interleav-n_high_memory-aware
+++ a/include/linux/nodemask.h
@@ -82,6 +82,12 @@
  *    to generate slightly worse code.  So use a simple one-line #define
  *    for node_isset(), instead of wrapping an inline inside a macro, the
  *    way we do the other calls.
+ *
+ * NODEMASK_SCRATCH
+ * When doing above logical AND, OR, XOR, Remap operations the callers tend to
+ * need temporary nodemask_t's on the stack. But if NODES_SHIFT is large,
+ * nodemask_t's consume too much stack space.  NODEMASK_SCRATCH is a helper
+ * for such situations. See below and CPUMASK_ALLOC also.
  */
 
 #include <linux/kernel.h>
@@ -473,4 +479,26 @@ static inline int num_node_state(enum no
 #define for_each_node(node)	   for_each_node_state(node, N_POSSIBLE)
 #define for_each_online_node(node) for_each_node_state(node, N_ONLINE)
 
+/*
+ * For nodemask scrach area.(See CPUMASK_ALLOC() in cpumask.h)
+ */
+
+#if NODES_SHIFT > 8 /* nodemask_t > 64 bytes */
+#define NODEMASK_ALLOC(x, m) struct x *m = kmalloc(sizeof(*m), GFP_KERNEL)
+#define NODEMASK_FREE(m) kfree(m)
+#else
+#define NODEMASK_ALLOC(x, m) struct x _m, *m = &_m
+#define NODEMASK_FREE(m)
+#endif
+
+/* A example struture for using NODEMASK_ALLOC, used in mempolicy. */
+struct nodemask_scratch {
+	nodemask_t	mask1;
+	nodemask_t	mask2;
+};
+
+#define NODEMASK_SCRATCH(x) NODEMASK_ALLOC(nodemask_scratch, x)
+#define NODEMASK_SCRATCH_FREE(x)  NODEMASK_FREE(x)
+
+
 #endif /* __LINUX_NODEMASK_H */
diff -puN mm/mempolicy.c~mm-make-set_mempolicympol_interleav-n_high_memory-aware mm/mempolicy.c
--- a/mm/mempolicy.c~mm-make-set_mempolicympol_interleav-n_high_memory-aware
+++ a/mm/mempolicy.c
@@ -191,25 +191,27 @@ static int mpol_new_bind(struct mempolic
  * Must be called holding task's alloc_lock to protect task's mems_allowed
  * and mempolicy.  May also be called holding the mmap_semaphore for write.
  */
-static int mpol_set_nodemask(struct mempolicy *pol, const nodemask_t *nodes)
+static int mpol_set_nodemask(struct mempolicy *pol,
+		     const nodemask_t *nodes, struct nodemask_scratch *nsc)
 {
-	nodemask_t cpuset_context_nmask;
 	int ret;
 
 	/* if mode is MPOL_DEFAULT, pol is NULL. This is right. */
 	if (pol == NULL)
 		return 0;
+	/* Check N_HIGH_MEMORY */
+	nodes_and(nsc->mask1,
+		  cpuset_current_mems_allowed, node_states[N_HIGH_MEMORY]);
 
 	VM_BUG_ON(!nodes);
 	if (pol->mode == MPOL_PREFERRED && nodes_empty(*nodes))
 		nodes = NULL;	/* explicit local allocation */
 	else {
 		if (pol->flags & MPOL_F_RELATIVE_NODES)
-			mpol_relative_nodemask(&cpuset_context_nmask, nodes,
-					       &cpuset_current_mems_allowed);
+			mpol_relative_nodemask(&nsc->mask2, nodes,&nsc->mask1);
 		else
-			nodes_and(cpuset_context_nmask, *nodes,
-				  cpuset_current_mems_allowed);
+			nodes_and(nsc->mask2, *nodes, nsc->mask1);
+
 		if (mpol_store_user_nodemask(pol))
 			pol->w.user_nodemask = *nodes;
 		else
@@ -217,8 +219,10 @@ static int mpol_set_nodemask(struct memp
 						cpuset_current_mems_allowed;
 	}
 
-	ret = mpol_ops[pol->mode].create(pol,
-				nodes ? &cpuset_context_nmask : NULL);
+	if (nodes)
+		ret = mpol_ops[pol->mode].create(pol, &nsc->mask2);
+	else
+		ret = mpol_ops[pol->mode].create(pol, NULL);
 	return ret;
 }
 
@@ -620,12 +624,17 @@ static long do_set_mempolicy(unsigned sh
 {
 	struct mempolicy *new, *old;
 	struct mm_struct *mm = current->mm;
+	NODEMASK_SCRATCH(scratch);
 	int ret;
 
-	new = mpol_new(mode, flags, nodes);
-	if (IS_ERR(new))
-		return PTR_ERR(new);
+	if (!scratch)
+		return -ENOMEM;
 
+	new = mpol_new(mode, flags, nodes);
+	if (IS_ERR(new)) {
+		ret = PTR_ERR(new);
+		goto out;
+	}
 	/*
 	 * prevent changing our mempolicy while show_numa_maps()
 	 * is using it.
@@ -635,13 +644,13 @@ static long do_set_mempolicy(unsigned sh
 	if (mm)
 		down_write(&mm->mmap_sem);
 	task_lock(current);
-	ret = mpol_set_nodemask(new, nodes);
+	ret = mpol_set_nodemask(new, nodes, scratch);
 	if (ret) {
 		task_unlock(current);
 		if (mm)
 			up_write(&mm->mmap_sem);
 		mpol_put(new);
-		return ret;
+		goto out;
 	}
 	old = current->mempolicy;
 	current->mempolicy = new;
@@ -654,7 +663,10 @@ static long do_set_mempolicy(unsigned sh
 		up_write(&mm->mmap_sem);
 
 	mpol_put(old);
-	return 0;
+	ret = 0;
+out:
+	NODEMASK_SCRATCH_FREE(scratch);
+	return ret;
 }
 
 /*
@@ -1014,12 +1026,20 @@ static long do_mbind(unsigned long start
 		if (err)
 			return err;
 	}
-	down_write(&mm->mmap_sem);
-	task_lock(current);
-	err = mpol_set_nodemask(new, nmask);
-	task_unlock(current);
+	{
+		NODEMASK_SCRATCH(scratch);
+		if (scratch) {
+			down_write(&mm->mmap_sem);
+			task_lock(current);
+			err = mpol_set_nodemask(new, nmask, scratch);
+			task_unlock(current);
+			if (err)
+				up_write(&mm->mmap_sem);
+		} else
+			err = -ENOMEM;
+		NODEMASK_SCRATCH_FREE(scratch);
+	}
 	if (err) {
-		up_write(&mm->mmap_sem);
 		mpol_put(new);
 		return err;
 	}
@@ -1891,6 +1911,7 @@ restart:
  * Install non-NULL @mpol in inode's shared policy rb-tree.
  * On entry, the current task has a reference on a non-NULL @mpol.
  * This must be released on exit.
+ * This is called at get_inode() calls and we can use GFP_KERNEL.
  */
 void mpol_shared_policy_init(struct shared_policy *sp, struct mempolicy *mpol)
 {
@@ -1902,19 +1923,24 @@ void mpol_shared_policy_init(struct shar
 	if (mpol) {
 		struct vm_area_struct pvma;
 		struct mempolicy *new;
+		NODEMASK_SCRATCH(scratch);
 
+		if (!scratch)
+			return;
 		/* contextualize the tmpfs mount point mempolicy */
 		new = mpol_new(mpol->mode, mpol->flags, &mpol->w.user_nodemask);
 		if (IS_ERR(new)) {
 			mpol_put(mpol);	/* drop our ref on sb mpol */
+			NODEMASK_SCRATCH_FREE(scratch);
 			return;		/* no valid nodemask intersection */
 		}
 
 		task_lock(current);
-		ret = mpol_set_nodemask(new, &mpol->w.user_nodemask);
+		ret = mpol_set_nodemask(new, &mpol->w.user_nodemask, scratch);
 		task_unlock(current);
 		mpol_put(mpol);	/* drop our ref on sb mpol */
 		if (ret) {
+			NODEMASK_SCRATCH_FREE(scratch);
 			mpol_put(new);
 			return;
 		}
@@ -1924,6 +1950,7 @@ void mpol_shared_policy_init(struct shar
 		pvma.vm_end = TASK_SIZE;	/* policy covers entire file */
 		mpol_set_shared_policy(sp, &pvma, new); /* adds ref */
 		mpol_put(new);			/* drop initial ref */
+		NODEMASK_SCRATCH_FREE(scratch);
 	}
 }
 
@@ -2140,13 +2167,18 @@ int mpol_parse_str(char *str, struct mem
 		err = 1;
 	else {
 		int ret;
-
-		task_lock(current);
-		ret = mpol_set_nodemask(new, &nodes);
-		task_unlock(current);
-		if (ret)
+		NODEMASK_SCRATCH(scratch);
+		if (scratch) {
+			task_lock(current);
+			ret = mpol_set_nodemask(new, &nodes, scratch);
+			task_unlock(current);
+		} else
+			ret = -ENOMEM;
+		NODEMASK_SCRATCH_FREE(scratch);
+		if (ret) {
 			err = 1;
-		else if (no_context) {
+			mpol_put(new);
+		} else if (no_context) {
 			/* save for contextualization */
 			new->w.user_nodemask = nodes;
 		}
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
mm-clean-up-page_remove_rmap.patch
vmscan-throttle-direct-reclaim-when-too-many-pages-are-isolated-already.patch
mm-remove-__addsub_zone_page_state.patch
vmscan-dont-attempt-to-reclaim-anon-page-in-lumpy-reclaim-when-no-swap-space-is-avilable.patch
ksm-add-mmu_notifier-set_pte_at_notify.patch
ksm-first-tidy-up-madvise_vma.patch
ksm-define-madv_mergeable-and-madv_unmergeable.patch
ksm-the-mm-interface-to-ksm.patch
ksm-no-debug-in-page_dup_rmap.patch
ksm-identify-pageksm-pages.patch
ksm-kernel-samepage-merging.patch
ksm-prevent-mremap-move-poisoning.patch
ksm-change-copyright-message.patch
ksm-change-ksm-nice-level-to-be-5.patch
vmalloc-unmap-vmalloc-area-after-hiding-it.patch
kcore-fix-vread-vwrite-to-be-aware-of-holes.patch
kcore-fix-vread-vwrite-to-be-aware-of-holes-update.patch
kcore-proc-kcore-should-use-vread.patch
oom-move-oom_adj-to-signal_struct.patch
oom-make-oom_score-to-per-process-value.patch
oom-oom_kill-doesnt-kill-vfork-parentor-child.patch
oom-fix-oom_adjust_write-input-sanity-check.patch
oom-fix-oom_adjust_write-input-sanity-check-fix.patch
kcore-fix-proc-kcores-statst_size.patch
cgroups-support-named-cgroups-hierarchies.patch
cgroups-move-the-cgroup-debug-subsys-into-cgroupc-to-access-internal-state.patch
cgroups-add-a-back-pointer-from-struct-cg_cgroup_link-to-struct-cgroup.patch
cgroups-allow-cgroup-hierarchies-to-be-created-with-no-bound-subsystems.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix-2.patch
memcg-add-comments-explaining-memory-barriers.patch
memcg-add-comments-explaining-memory-barriers-checkpatch-fixes.patch
memory-controller-soft-limit-documentation-v9.patch
memory-controller-soft-limit-interface-v9.patch
memory-controller-soft-limit-organize-cgroups-v9.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
memory-controller-soft-limit-refactor-reclaim-flags-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix.patch

