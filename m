From: akpm@linux-foundation.org
Subject: + mempolicy-restructure-rebinding-mempolicy-functions.patch added to -mm tree
Date: Tue, 04 May 2010 17:34:27 -0700
Message-ID: <201005050034.o450YRdN028048@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50529 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933808Ab0EEAf1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 May 2010 20:35:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: miaox@cn.fujitsu.com, andi@firstfloor.org, cl@linux-foundation.org, hugh.dickins@tiscali.co.uk, kiran@scalex86.org, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, menage@google.com, npiggin@suse.de, rientjes@google.com


The patch titled
     mempolicy: restructure rebinding-mempolicy functions
has been added to the -mm tree.  Its filename is
     mempolicy-restructure-rebinding-mempolicy-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mempolicy: restructure rebinding-mempolicy functions
From: Miao Xie <miaox@cn.fujitsu.com>

In order to fix no node to alloc memory, when we want to update mempolicy
and mems_allowed, we expand the set of nodes first (set all the newly
nodes) and shrink the set of nodes lazily(clean disallowed nodes), But the
mempolicy's rebind functions may breaks the expanding.

So we restructure the mempolicy's rebind functions and split the rebind
work to two steps, just like the update of cpuset's mems: The 1st step:
expand the set of the mempolicy's nodes.  The 2nd step: shrink the set of
the mempolicy's nodes.  It is used when there is no real lock to protect
the mempolicy in the read-side.  Otherwise we can do rebind work at once.

In order to implement it, we define

	enum mpol_rebind_step {
		MPOL_REBIND_ONCE,
		MPOL_REBIND_STEP1,
		MPOL_REBIND_STEP2,
		MPOL_REBIND_NSTEP,
	};

If the mempolicy needn't be updated by two steps, we can pass
MPOL_REBIND_ONCE to the rebind functions.  Or we can pass
MPOL_REBIND_STEP1 to do the first step of the rebind work and pass
MPOL_REBIND_STEP2 to do the second step work.

Besides that, it maybe long time between these two step and we have to
release the lock that protects mempolicy and mems_allowed.  If we hold the
lock once again, we must check whether the current mempolicy is under the
rebinding (the first step has been done) or not, because the task may
alloc a new mempolicy when we don't hold the lock.  So we defined the
following flag to identify it:

#define MPOL_F_REBINDING (1 << 2)

The new functions will be used in the next patch.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Paul Menage <menage@google.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Ravikiran Thirumalai <kiran@scalex86.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempolicy.h |   15 +++-
 kernel/cpuset.c           |    4 -
 mm/mempolicy.c            |  124 ++++++++++++++++++++++++++++++------
 3 files changed, 119 insertions(+), 24 deletions(-)

diff -puN include/linux/mempolicy.h~mempolicy-restructure-rebinding-mempolicy-functions include/linux/mempolicy.h
--- a/include/linux/mempolicy.h~mempolicy-restructure-rebinding-mempolicy-functions
+++ a/include/linux/mempolicy.h
@@ -23,6 +23,13 @@ enum {
 	MPOL_MAX,	/* always last member of enum */
 };
 
+enum mpol_rebind_step {
+	MPOL_REBIND_ONCE,	/* do rebind work at once(not by two step) */
+	MPOL_REBIND_STEP1,	/* first step(set all the newly nodes) */
+	MPOL_REBIND_STEP2,	/* second step(clean all the disallowed nodes)*/
+	MPOL_REBIND_NSTEP,
+};
+
 /* Flags for set_mempolicy */
 #define MPOL_F_STATIC_NODES	(1 << 15)
 #define MPOL_F_RELATIVE_NODES	(1 << 14)
@@ -51,6 +58,7 @@ enum {
  */
 #define MPOL_F_SHARED  (1 << 0)	/* identify shared policies */
 #define MPOL_F_LOCAL   (1 << 1)	/* preferred local allocation */
+#define MPOL_F_REBINDING (1 << 2)	/* identify policies in rebinding */
 
 #ifdef __KERNEL__
 
@@ -193,8 +201,8 @@ struct mempolicy *mpol_shared_policy_loo
 
 extern void numa_default_policy(void);
 extern void numa_policy_init(void);
-extern void mpol_rebind_task(struct task_struct *tsk,
-					const nodemask_t *new);
+extern void mpol_rebind_task(struct task_struct *tsk, const nodemask_t *new,
+				enum mpol_rebind_step step);
 extern void mpol_rebind_mm(struct mm_struct *mm, nodemask_t *new);
 extern void mpol_fix_fork_child_flag(struct task_struct *p);
 
@@ -310,7 +318,8 @@ static inline void numa_default_policy(v
 }
 
 static inline void mpol_rebind_task(struct task_struct *tsk,
-					const nodemask_t *new)
+				const nodemask_t *new,
+				enum mpol_rebind_step step)
 {
 }
 
diff -puN kernel/cpuset.c~mempolicy-restructure-rebinding-mempolicy-functions kernel/cpuset.c
--- a/kernel/cpuset.c~mempolicy-restructure-rebinding-mempolicy-functions
+++ a/kernel/cpuset.c
@@ -953,8 +953,8 @@ static void cpuset_change_task_nodemask(
 					nodemask_t *newmems)
 {
 	nodes_or(tsk->mems_allowed, tsk->mems_allowed, *newmems);
-	mpol_rebind_task(tsk, &tsk->mems_allowed);
-	mpol_rebind_task(tsk, newmems);
+	mpol_rebind_task(tsk, &tsk->mems_allowed, MPOL_REBIND_ONCE);
+	mpol_rebind_task(tsk, newmems, MPOL_REBIND_ONCE);
 	tsk->mems_allowed = *newmems;
 }
 
diff -puN mm/mempolicy.c~mempolicy-restructure-rebinding-mempolicy-functions mm/mempolicy.c
--- a/mm/mempolicy.c~mempolicy-restructure-rebinding-mempolicy-functions
+++ a/mm/mempolicy.c
@@ -119,7 +119,22 @@ struct mempolicy default_policy = {
 
 static const struct mempolicy_operations {
 	int (*create)(struct mempolicy *pol, const nodemask_t *nodes);
-	void (*rebind)(struct mempolicy *pol, const nodemask_t *nodes);
+	/*
+	 * If read-side task has no lock to protect task->mempolicy, write-side
+	 * task will rebind the task->mempolicy by two step. The first step is
+	 * setting all the newly nodes, and the second step is cleaning all the
+	 * disallowed nodes. In this way, we can avoid finding no node to alloc
+	 * page.
+	 * If we have a lock to protect task->mempolicy in read-side, we do
+	 * rebind directly.
+	 *
+	 * step:
+	 * 	MPOL_REBIND_ONCE - do rebind work at once
+	 * 	MPOL_REBIND_STEP1 - set all the newly nodes
+	 * 	MPOL_REBIND_STEP2 - clean all the disallowed nodes
+	 */
+	void (*rebind)(struct mempolicy *pol, const nodemask_t *nodes,
+			enum mpol_rebind_step step);
 } mpol_ops[MPOL_MAX];
 
 /* Check that the nodemask contains at least one populated zone */
@@ -274,12 +289,19 @@ void __mpol_put(struct mempolicy *p)
 	kmem_cache_free(policy_cache, p);
 }
 
-static void mpol_rebind_default(struct mempolicy *pol, const nodemask_t *nodes)
+static void mpol_rebind_default(struct mempolicy *pol, const nodemask_t *nodes,
+				enum mpol_rebind_step step)
 {
 }
 
-static void mpol_rebind_nodemask(struct mempolicy *pol,
-				 const nodemask_t *nodes)
+/*
+ * step:
+ * 	MPOL_REBIND_ONCE  - do rebind work at once
+ * 	MPOL_REBIND_STEP1 - set all the newly nodes
+ * 	MPOL_REBIND_STEP2 - clean all the disallowed nodes
+ */
+static void mpol_rebind_nodemask(struct mempolicy *pol, const nodemask_t *nodes,
+				 enum mpol_rebind_step step)
 {
 	nodemask_t tmp;
 
@@ -288,12 +310,31 @@ static void mpol_rebind_nodemask(struct 
 	else if (pol->flags & MPOL_F_RELATIVE_NODES)
 		mpol_relative_nodemask(&tmp, &pol->w.user_nodemask, nodes);
 	else {
-		nodes_remap(tmp, pol->v.nodes, pol->w.cpuset_mems_allowed,
-			    *nodes);
-		pol->w.cpuset_mems_allowed = *nodes;
+		/*
+		 * if step == 1, we use ->w.cpuset_mems_allowed to cache the
+		 * result
+		 */
+		if (step == MPOL_REBIND_ONCE || step == MPOL_REBIND_STEP1) {
+			nodes_remap(tmp, pol->v.nodes,
+					pol->w.cpuset_mems_allowed, *nodes);
+			pol->w.cpuset_mems_allowed = step ? tmp : *nodes;
+		} else if (step == MPOL_REBIND_STEP2) {
+			tmp = pol->w.cpuset_mems_allowed;
+			pol->w.cpuset_mems_allowed = *nodes;
+		} else
+			BUG();
 	}
 
-	pol->v.nodes = tmp;
+	if (nodes_empty(tmp))
+		tmp = *nodes;
+
+	if (step == MPOL_REBIND_STEP1)
+		nodes_or(pol->v.nodes, pol->v.nodes, tmp);
+	else if (step == MPOL_REBIND_ONCE || step == MPOL_REBIND_STEP2)
+		pol->v.nodes = tmp;
+	else
+		BUG();
+
 	if (!node_isset(current->il_next, tmp)) {
 		current->il_next = next_node(current->il_next, tmp);
 		if (current->il_next >= MAX_NUMNODES)
@@ -304,7 +345,8 @@ static void mpol_rebind_nodemask(struct 
 }
 
 static void mpol_rebind_preferred(struct mempolicy *pol,
-				  const nodemask_t *nodes)
+				  const nodemask_t *nodes,
+				  enum mpol_rebind_step step)
 {
 	nodemask_t tmp;
 
@@ -327,16 +369,45 @@ static void mpol_rebind_preferred(struct
 	}
 }
 
-/* Migrate a policy to a different set of nodes */
-static void mpol_rebind_policy(struct mempolicy *pol,
-			       const nodemask_t *newmask)
+/*
+ * mpol_rebind_policy - Migrate a policy to a different set of nodes
+ *
+ * If read-side task has no lock to protect task->mempolicy, write-side
+ * task will rebind the task->mempolicy by two step. The first step is
+ * setting all the newly nodes, and the second step is cleaning all the
+ * disallowed nodes. In this way, we can avoid finding no node to alloc
+ * page.
+ * If we have a lock to protect task->mempolicy in read-side, we do
+ * rebind directly.
+ *
+ * step:
+ * 	MPOL_REBIND_ONCE  - do rebind work at once
+ * 	MPOL_REBIND_STEP1 - set all the newly nodes
+ * 	MPOL_REBIND_STEP2 - clean all the disallowed nodes
+ */
+static void mpol_rebind_policy(struct mempolicy *pol, const nodemask_t *newmask,
+				enum mpol_rebind_step step)
 {
 	if (!pol)
 		return;
-	if (!mpol_store_user_nodemask(pol) &&
+	if (!mpol_store_user_nodemask(pol) && step == 0 &&
 	    nodes_equal(pol->w.cpuset_mems_allowed, *newmask))
 		return;
-	mpol_ops[pol->mode].rebind(pol, newmask);
+
+	if (step == MPOL_REBIND_STEP1 && (pol->flags & MPOL_F_REBINDING))
+		return;
+
+	if (step == MPOL_REBIND_STEP2 && !(pol->flags & MPOL_F_REBINDING))
+		BUG();
+
+	if (step == MPOL_REBIND_STEP1)
+		pol->flags |= MPOL_F_REBINDING;
+	else if (step == MPOL_REBIND_STEP2)
+		pol->flags &= ~MPOL_F_REBINDING;
+	else if (step >= MPOL_REBIND_NSTEP)
+		BUG();
+
+	mpol_ops[pol->mode].rebind(pol, newmask, step);
 }
 
 /*
@@ -346,9 +417,10 @@ static void mpol_rebind_policy(struct me
  * Called with task's alloc_lock held.
  */
 
-void mpol_rebind_task(struct task_struct *tsk, const nodemask_t *new)
+void mpol_rebind_task(struct task_struct *tsk, const nodemask_t *new,
+			enum mpol_rebind_step step)
 {
-	mpol_rebind_policy(tsk->mempolicy, new);
+	mpol_rebind_policy(tsk->mempolicy, new, step);
 }
 
 /*
@@ -363,7 +435,7 @@ void mpol_rebind_mm(struct mm_struct *mm
 
 	down_write(&mm->mmap_sem);
 	for (vma = mm->mmap; vma; vma = vma->vm_next)
-		mpol_rebind_policy(vma->vm_policy, new);
+		mpol_rebind_policy(vma->vm_policy, new, MPOL_REBIND_ONCE);
 	up_write(&mm->mmap_sem);
 }
 
@@ -1789,6 +1861,9 @@ EXPORT_SYMBOL(alloc_pages_current);
  * with the mems_allowed returned by cpuset_mems_allowed().  This
  * keeps mempolicies cpuset relative after its cpuset moves.  See
  * further kernel/cpuset.c update_nodemask().
+ *
+ * current's mempolicy may be rebinded by the other task(the task that changes
+ * cpuset's mems), so we needn't do rebind work for current task.
  */
 
 /* Slow path of a mempolicy duplicate */
@@ -1798,13 +1873,24 @@ struct mempolicy *__mpol_dup(struct memp
 
 	if (!new)
 		return ERR_PTR(-ENOMEM);
+
+	/* task's mempolicy is protected by alloc_lock */
+	if (old == current->mempolicy) {
+		task_lock(current);
+		*new = *old;
+		task_unlock(current);
+	} else
+		*new = *old;
+
 	rcu_read_lock();
 	if (current_cpuset_is_being_rebound()) {
 		nodemask_t mems = cpuset_mems_allowed(current);
-		mpol_rebind_policy(old, &mems);
+		if (new->flags & MPOL_F_REBINDING)
+			mpol_rebind_policy(new, &mems, MPOL_REBIND_STEP2);
+		else
+			mpol_rebind_policy(new, &mems, MPOL_REBIND_ONCE);
 	}
 	rcu_read_unlock();
-	*new = *old;
 	atomic_set(&new->refcnt, 1);
 	return new;
 }
_

Patches currently in -mm which might be from miaox@cn.fujitsu.com are

mempolicy-restructure-rebinding-mempolicy-functions.patch
cpusetmm-fix-no-node-to-alloc-memory-when-changing-cpusets-mems.patch

