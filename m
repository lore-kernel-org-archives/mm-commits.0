From: akpm@linux-foundation.org
Subject: + cpusetmm-use-rwlock-to-protect-task-mempolicy-and-mems_allowed.patch added to -mm tree
Date: Wed, 03 Mar 2010 15:50:13 -0800
Message-ID: <201003032350.o23NoDCZ006031@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56474 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753153Ab0CCXwf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Mar 2010 18:52:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: miaox@cn.fujitsu.com, lee.schermerhorn@hp.com, menage@google.com, mingo@elte.hu, npiggin@suse.de, rientjes@google.com


The patch titled
     cpuset,mm: use rwlock to protect task->mempolicy and mems_allowed
has been added to the -mm tree.  Its filename is
     cpusetmm-use-rwlock-to-protect-task-mempolicy-and-mems_allowed.patch

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
Subject: cpuset,mm: use rwlock to protect task->mempolicy and mems_allowed
From: Miao Xie <miaox@cn.fujitsu.com>

If MAX_NUMNODES > BITS_PER_LONG, loading/storing task->mems_allowed or
mems_allowed in task->mempolicy are not atomic operations, and the kernel
page allocator gets an empty mems_allowed when updating task->mems_allowed
or mems_allowed in task->mempolicy.  So we use a rwlock to protect them to
fix this problem.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Paul Menage <menage@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpuset.h    |  104 +++++++++++++++++++++++-
 include/linux/init_task.h |    8 +
 include/linux/mempolicy.h |   24 ++++-
 include/linux/sched.h     |   17 +++-
 kernel/cpuset.c           |  113 +++++++++++++++++++++-----
 kernel/exit.c             |    4 
 kernel/fork.c             |   13 ++-
 mm/hugetlb.c              |    3 
 mm/mempolicy.c            |  153 +++++++++++++++++++++++++++---------
 mm/slab.c                 |   27 +++++-
 mm/slub.c                 |   10 ++
 11 files changed, 403 insertions(+), 73 deletions(-)

diff -puN include/linux/cpuset.h~cpusetmm-use-rwlock-to-protect-task-mempolicy-and-mems_allowed include/linux/cpuset.h
--- a/include/linux/cpuset.h~cpusetmm-use-rwlock-to-protect-task-mempolicy-and-mems_allowed
+++ a/include/linux/cpuset.h
@@ -53,8 +53,8 @@ static inline int cpuset_zone_allowed_ha
 	return cpuset_node_allowed_hardwall(zone_to_nid(z), gfp_mask);
 }
 
-extern int cpuset_mems_allowed_intersects(const struct task_struct *tsk1,
-					  const struct task_struct *tsk2);
+extern int cpuset_mems_allowed_intersects(struct task_struct *tsk1,
+					  struct task_struct *tsk2);
 
 #define cpuset_memory_pressure_bump() 				\
 	do {							\
@@ -90,9 +90,92 @@ extern void rebuild_sched_domains(void);
 
 extern void cpuset_print_task_mems_allowed(struct task_struct *p);
 
+# if MAX_NUMNODES > BITS_PER_LONG
+/*
+ * Be used to protect task->mempolicy and mems_allowed when reading them for
+ * page allocation.
+ *
+ * we don't care that the kernel page allocator allocate a page on a node in
+ * the old mems_allowed, which isn't a big deal, especially since it was
+ * previously allowed.
+ *
+ * We just worry whether the kernel page allocator gets an empty mems_allowed
+ * or not. But
+ *   if MAX_NUMNODES <= BITS_PER_LONG, loading/storing task->mems_allowed are
+ *   atomic operations. So we needn't do anything to protect the loading of
+ *   task->mems_allowed.
+ *
+ *   if MAX_NUMNODES > BITS_PER_LONG, loading/storing task->mems_allowed are
+ *   not atomic operations. So we use a rwlock to protect the loading of
+ *   task->mems_allowed.
+ */
+#define read_mem_lock_irqsave(p, flags)				\
+	do {							\
+		read_lock_irqsave(&p->mem_rwlock, flags);	\
+	} while (0)
+
+#define read_mem_unlock_irqrestore(p, flags)			\
+	do {							\
+		read_unlock_irqrestore(&p->mem_rwlock, flags);	\
+	} while (0)
+
+/* Used to protect task->mempolicy and mems_allowed when user get mempolciy */
+#define read_mempolicy_lock_irqsave(p, flags)			\
+	do {							\
+		read_lock_irqsave(&p->mem_rwlock, flags);	\
+	} while (0)
+
+#define read_mempolicy_unlock_irqrestore(p, flags)		\
+	do {							\
+		read_unlock_irqrestore(&p->mem_rwlock, flags);	\
+	} while (0)
+
+#define write_mem_lock_irqsave(p, flags)			\
+	do {							\
+		write_lock_irqsave(&p->mem_rwlock, flags);	\
+	} while (0)
+
+#define write_mem_unlock_irqrestore(p, flags)			\
+	do {							\
+		write_unlock_irqrestore(&p->mem_rwlock, flags);	\
+	} while (0)
+# else
+#define read_mem_lock_irqsave(p, flags)		do { (void)(flags); } while (0)
+
+#define read_mem_unlock_irqrestore(p, flags)	do { (void)(flags); } while (0)
+
+/* Be used to protect task->mempolicy and mems_allowed when user reads them */
+#define read_mempolicy_lock_irqsave(p, flags)			\
+	do {							\
+		task_lock(p);					\
+		(void)(flags);					\
+	} while (0)
+
+#define read_mempolicy_unlock_irqrestore(p, flags)		\
+	do {							\
+		task_unlock(p);					\
+		(void)(flags);					\
+	} while (0)
+
+#define write_mem_lock_irqsave(p, flags)			\
+	do {							\
+		task_lock(p);					\
+		(void)(flags);					\
+	} while (0)
+
+#define write_mem_unlock_irqrestore(p, flags)			\
+	do {							\
+		task_unlock(p);					\
+		(void)(flags);					\
+	} while (0)
+# endif
+
 static inline void set_mems_allowed(nodemask_t nodemask)
 {
+	unsigned long flags;
+	write_mem_lock_irqsave(current, flags);
 	current->mems_allowed = nodemask;
+	write_mem_unlock_irqrestore(current, flags);
 }
 
 #else /* !CONFIG_CPUSETS */
@@ -144,8 +227,8 @@ static inline int cpuset_zone_allowed_ha
 	return 1;
 }
 
-static inline int cpuset_mems_allowed_intersects(const struct task_struct *tsk1,
-						 const struct task_struct *tsk2)
+static inline int cpuset_mems_allowed_intersects(struct task_struct *tsk1,
+						 struct task_struct *tsk2)
 {
 	return 1;
 }
@@ -193,6 +276,19 @@ static inline void set_mems_allowed(node
 {
 }
 
+#define read_mem_lock_irqsave(p, flags)		do { (void)(flags); } while (0)
+
+#define read_mem_unlock_irqrestore(p, flags)	do { (void)(flags); } while (0)
+
+#define read_mempolicy_lock_irqsave(p, flags)	do { (void)(flags); } while (0)
+
+#define read_mempolicy_unlock_irqrestore(p, flags)	\
+	do { (void)(flags); } while (0)
+
+#define write_mem_lock_irqsave(p, flags)	do { (void)(flags); } while (0)
+
+#define write_mem_unlock_irqrestore(p, flags)	do { (void)(flags); } while (0)
+
 #endif /* !CONFIG_CPUSETS */
 
 #endif /* _LINUX_CPUSET_H */
diff -puN include/linux/init_task.h~cpusetmm-use-rwlock-to-protect-task-mempolicy-and-mems_allowed include/linux/init_task.h
--- a/include/linux/init_task.h~cpusetmm-use-rwlock-to-protect-task-mempolicy-and-mems_allowed
+++ a/include/linux/init_task.h
@@ -110,6 +110,13 @@ extern struct cred init_cred;
 # define INIT_PERF_EVENTS(tsk)
 #endif
 
+#if defined(CONFIG_CPUSETS) && MAX_NUMNODES > BITS_PER_LONG
+# define INIT_MEM_RWLOCK(tsk)						\
+	.mem_rwlock	= __RW_LOCK_UNLOCKED(tsk.mem_rwlock),
+#else
+# define INIT_MEM_RWLOCK(tsk)
+#endif
+
 /*
  *  INIT_TASK is used to set up the first task table, touch at
  * your own risk!. Base=0, limit=0x1fffff (=2MB)
@@ -179,6 +186,7 @@ extern struct cred init_cred;
 	INIT_FTRACE_GRAPH						\
 	INIT_TRACE_RECURSION						\
 	INIT_TASK_RCU_PREEMPT(tsk)					\
+	INIT_MEM_RWLOCK(tsk)						\
 }
 
 
diff -puN include/linux/mempolicy.h~cpusetmm-use-rwlock-to-protect-task-mempolicy-and-mems_allowed include/linux/mempolicy.h
--- a/include/linux/mempolicy.h~cpusetmm-use-rwlock-to-protect-task-mempolicy-and-mems_allowed
+++ a/include/linux/mempolicy.h
@@ -51,6 +51,7 @@ enum {
  */
 #define MPOL_F_SHARED  (1 << 0)	/* identify shared policies */
 #define MPOL_F_LOCAL   (1 << 1)	/* preferred local allocation */
+#define MPOL_F_TASK    (1 << 2)	/* identify tasks' policies */
 
 #ifdef __KERNEL__
 
@@ -107,6 +108,12 @@ struct mempolicy {
  * The default fast path of a NULL MPOL_DEFAULT policy is always inlined.
  */
 
+extern struct mempolicy *__mpol_alloc(void);
+static inline struct mempolicy *mpol_alloc(void)
+{
+	return __mpol_alloc();
+}
+
 extern void __mpol_put(struct mempolicy *pol);
 static inline void mpol_put(struct mempolicy *pol)
 {
@@ -125,7 +132,7 @@ static inline int mpol_needs_cond_ref(st
 
 static inline void mpol_cond_put(struct mempolicy *pol)
 {
-	if (mpol_needs_cond_ref(pol))
+	if (mpol_needs_cond_ref(pol) || (pol && (pol->flags & MPOL_F_TASK)))
 		__mpol_put(pol);
 }
 
@@ -193,8 +200,8 @@ struct mempolicy *mpol_shared_policy_loo
 
 extern void numa_default_policy(void);
 extern void numa_policy_init(void);
-extern void mpol_rebind_task(struct task_struct *tsk,
-					const nodemask_t *new);
+extern int mpol_rebind_task(struct task_struct *tsk, const nodemask_t *new,
+				struct mempolicy *newpol);
 extern void mpol_rebind_mm(struct mm_struct *mm, nodemask_t *new);
 extern void mpol_fix_fork_child_flag(struct task_struct *p);
 
@@ -249,6 +256,11 @@ static inline int mpol_equal(struct memp
 	return 1;
 }
 
+static inline struct mempolicy *mpol_alloc(void)
+{
+	return NULL;
+}
+
 static inline void mpol_put(struct mempolicy *p)
 {
 }
@@ -307,9 +319,11 @@ static inline void numa_default_policy(v
 {
 }
 
-static inline void mpol_rebind_task(struct task_struct *tsk,
-					const nodemask_t *new)
+static inline int mpol_rebind_task(struct task_struct *tsk,
+					const nodemask_t *new,
+					struct mempolicy *newpol)
 {
+	return 0;
 }
 
 static inline void mpol_rebind_mm(struct mm_struct *mm, nodemask_t *new)
diff -puN include/linux/sched.h~cpusetmm-use-rwlock-to-protect-task-mempolicy-and-mems_allowed include/linux/sched.h
--- a/include/linux/sched.h~cpusetmm-use-rwlock-to-protect-task-mempolicy-and-mems_allowed
+++ a/include/linux/sched.h
@@ -1351,8 +1351,9 @@ struct task_struct {
 /* Thread group tracking */
    	u32 parent_exec_id;
    	u32 self_exec_id;
-/* Protection of (de-)allocation: mm, files, fs, tty, keyrings, mems_allowed,
- * mempolicy */
+/* Protection of (de-)allocation: mm, files, fs, tty, keyrings.
+ * if MAX_NUMNODES <= BITS_PER_LONG,it will protect mems_allowed and mempolicy.
+ * Or we use other rwlock - mem_rwlock to protect them. */
 	spinlock_t alloc_lock;
 
 #ifdef CONFIG_GENERIC_HARDIRQS
@@ -1420,7 +1421,13 @@ struct task_struct {
 	cputime_t acct_timexpd;	/* stime + utime since last update */
 #endif
 #ifdef CONFIG_CPUSETS
-	nodemask_t mems_allowed;	/* Protected by alloc_lock */
+# if MAX_NUMNODES > BITS_PER_LONG
+	/* Protection of mems_allowed, and mempolicy */
+	rwlock_t mem_rwlock;
+# endif
+	/* if MAX_NUMNODES <= BITS_PER_LONG, Protected by alloc_lock;
+	 * else Protected by mem_rwlock */
+	nodemask_t mems_allowed;
 	int cpuset_mem_spread_rotor;
 #endif
 #ifdef CONFIG_CGROUPS
@@ -1443,7 +1450,9 @@ struct task_struct {
 	struct list_head perf_event_list;
 #endif
 #ifdef CONFIG_NUMA
-	struct mempolicy *mempolicy;	/* Protected by alloc_lock */
+	/* if MAX_NUMNODES <= BITS_PER_LONG, Protected by alloc_lock;
+	 * else Protected by mem_rwlock */
+	struct mempolicy *mempolicy;
 	short il_next;
 #endif
 	atomic_t fs_excl;	/* holding fs exclusive resources */
diff -puN kernel/cpuset.c~cpusetmm-use-rwlock-to-protect-task-mempolicy-and-mems_allowed kernel/cpuset.c
--- a/kernel/cpuset.c~cpusetmm-use-rwlock-to-protect-task-mempolicy-and-mems_allowed
+++ a/kernel/cpuset.c
@@ -198,12 +198,13 @@ static struct cpuset top_cpuset = {
  * from one of the callbacks into the cpuset code from within
  * __alloc_pages().
  *
- * If a task is only holding callback_mutex, then it has read-only
- * access to cpusets.
+ * If a task is only holding callback_mutex or cgroup_mutext, then it has
+ * read-only access to cpusets.
  *
  * Now, the task_struct fields mems_allowed and mempolicy may be changed
- * by other task, we use alloc_lock in the task_struct fields to protect
- * them.
+ * by other task, we use alloc_lock(if MAX_NUMNODES <= BITS_PER_LONG) or
+ * mem_rwlock(if MAX_NUMNODES > BITS_PER_LONG) in the task_struct fields
+ * to protect them.
  *
  * The cpuset_common_file_read() handlers only hold callback_mutex across
  * small pieces of code, such as when reading out possibly multi-word
@@ -920,6 +921,10 @@ static int update_cpumask(struct cpuset 
  *    call to guarantee_online_mems(), as we know no one is changing
  *    our task's cpuset.
  *
+ *    As the above comment said, no one can change current task's mems_allowed
+ *    except itself. so we needn't hold lock to protect task's mems_allowed
+ *    during this call.
+ *
  *    While the mm_struct we are migrating is typically from some
  *    other task, the task_struct mems_allowed that we are hacking
  *    is for our current task, which must allocate new pages for that
@@ -961,15 +966,19 @@ static void cpuset_migrate_mm(struct mm_
  * we structure updates as setting all new allowed nodes, then clearing newly
  * disallowed ones.
  *
- * Called with task's alloc_lock held
+ * Called with write_mem_lock held
  */
-static void cpuset_change_task_nodemask(struct task_struct *tsk,
-					nodemask_t *newmems)
+static int cpuset_change_task_nodemask(struct task_struct *tsk,
+					nodemask_t *newmems,
+					struct mempolicy *newpol)
 {
+	int retval;
+
 	nodes_or(tsk->mems_allowed, tsk->mems_allowed, *newmems);
-	mpol_rebind_task(tsk, &tsk->mems_allowed);
-	mpol_rebind_task(tsk, newmems);
+	retval = mpol_rebind_task(tsk, newmems, newpol);
 	tsk->mems_allowed = *newmems;
+
+	return retval;
 }
 
 /*
@@ -984,17 +993,31 @@ static void cpuset_change_nodemask(struc
 	struct cpuset *cs;
 	int migrate;
 	const nodemask_t *oldmem = scan->data;
+	unsigned long flags;
+	struct mempolicy *newpol = NULL;
+	int retval;
 	NODEMASK_ALLOC(nodemask_t, newmems, GFP_KERNEL);
 
 	if (!newmems)
 		return;
 
+#if MAX_NUMNODES > BITS_PER_LONG
+	newpol = mpol_alloc();
+	if (newpol == NULL) {
+		NODEMASK_FREE(newmems);
+		return;
+	}
+#endif
+
 	cs = cgroup_cs(scan->cg);
 	guarantee_online_mems(cs, newmems);
 
-	task_lock(p);
-	cpuset_change_task_nodemask(p, newmems);
-	task_unlock(p);
+	write_mem_lock_irqsave(p, flags);
+	retval = cpuset_change_task_nodemask(p, newmems, newpol);
+	write_mem_unlock_irqrestore(p, flags);
+
+	if (retval)
+		mpol_put(newpol);
 
 	NODEMASK_FREE(newmems);
 
@@ -1389,6 +1412,8 @@ static int cpuset_can_attach(struct cgro
 static void cpuset_attach_task(struct task_struct *tsk, nodemask_t *to,
 			       struct cpuset *cs)
 {
+	struct mempolicy *newpol = NULL;
+	unsigned long flags;
 	int err;
 	/*
 	 * can_attach beforehand should guarantee that this doesn't fail.
@@ -1397,9 +1422,19 @@ static void cpuset_attach_task(struct ta
 	err = set_cpus_allowed_ptr(tsk, cpus_attach);
 	WARN_ON_ONCE(err);
 
-	task_lock(tsk);
-	cpuset_change_task_nodemask(tsk, to);
-	task_unlock(tsk);
+#if MAX_NUMNODES > BITS_PER_LONG
+	newpol = mpol_alloc();
+	if (newpol == NULL)
+		return;
+#endif
+
+	write_mem_lock_irqsave(tsk, flags);
+	err = cpuset_change_task_nodemask(tsk, to, newpol);
+	write_mem_unlock_irqrestore(tsk, flags);
+
+	if (err)
+		mpol_put(newpol);
+
 	cpuset_update_task_spread_flag(cs, tsk);
 
 }
@@ -2242,7 +2277,14 @@ nodemask_t cpuset_mems_allowed(struct ta
  */
 int cpuset_nodemask_valid_mems_allowed(nodemask_t *nodemask)
 {
-	return nodes_intersects(*nodemask, current->mems_allowed);
+	unsigned long flags;
+	int retval;
+
+	read_mem_lock_irqsave(current, flags);
+	retval = nodes_intersects(*nodemask, current->mems_allowed);
+	read_mem_unlock_irqrestore(current, flags);
+
+	return retval;
 }
 
 /*
@@ -2323,11 +2365,17 @@ int __cpuset_node_allowed_softwall(int n
 {
 	const struct cpuset *cs;	/* current cpuset ancestors */
 	int allowed;			/* is allocation in zone z allowed? */
+	unsigned long flags;
 
 	if (in_interrupt() || (gfp_mask & __GFP_THISNODE))
 		return 1;
 	might_sleep_if(!(gfp_mask & __GFP_HARDWALL));
-	if (node_isset(node, current->mems_allowed))
+
+	read_mem_lock_irqsave(current, flags);
+	allowed = node_isset(node, current->mems_allowed);
+	read_mem_unlock_irqrestore(current, flags);
+
+	if (allowed)
 		return 1;
 	/*
 	 * Allow tasks that have access to memory reserves because they have
@@ -2378,9 +2426,17 @@ int __cpuset_node_allowed_softwall(int n
  */
 int __cpuset_node_allowed_hardwall(int node, gfp_t gfp_mask)
 {
+	int allowed;
+	unsigned long flags;
+
 	if (in_interrupt() || (gfp_mask & __GFP_THISNODE))
 		return 1;
-	if (node_isset(node, current->mems_allowed))
+
+	read_mem_lock_irqsave(current, flags);
+	allowed = node_isset(node, current->mems_allowed);
+	read_mem_unlock_irqrestore(current, flags);
+
+	if (allowed)
 		return 1;
 	/*
 	 * Allow tasks that have access to memory reserves because they have
@@ -2447,11 +2503,14 @@ void cpuset_unlock(void)
 int cpuset_mem_spread_node(void)
 {
 	int node;
+	unsigned long flags;
 
+	read_mem_lock_irqsave(current, flags);
 	node = next_node(current->cpuset_mem_spread_rotor, current->mems_allowed);
 	if (node == MAX_NUMNODES)
 		node = first_node(current->mems_allowed);
 	current->cpuset_mem_spread_rotor = node;
+	read_mem_unlock_irqrestore(current, flags);
 	return node;
 }
 EXPORT_SYMBOL_GPL(cpuset_mem_spread_node);
@@ -2467,10 +2526,19 @@ EXPORT_SYMBOL_GPL(cpuset_mem_spread_node
  * to the other.
  **/
 
-int cpuset_mems_allowed_intersects(const struct task_struct *tsk1,
-				   const struct task_struct *tsk2)
+int cpuset_mems_allowed_intersects(struct task_struct *tsk1,
+				   struct task_struct *tsk2)
 {
-	return nodes_intersects(tsk1->mems_allowed, tsk2->mems_allowed);
+	unsigned long flags1, flags2;
+	int retval;
+
+	read_mem_lock_irqsave(tsk1, flags1);
+	read_mem_lock_irqsave(tsk2, flags2);
+	retval = nodes_intersects(tsk1->mems_allowed, tsk2->mems_allowed);
+	read_mem_unlock_irqrestore(tsk2, flags2);
+	read_mem_unlock_irqrestore(tsk1, flags1);
+
+	return retval;
 }
 
 /**
@@ -2483,14 +2551,17 @@ int cpuset_mems_allowed_intersects(const
  */
 void cpuset_print_task_mems_allowed(struct task_struct *tsk)
 {
+	unsigned long flags;
 	struct dentry *dentry;
 
 	dentry = task_cs(tsk)->css.cgroup->dentry;
 	spin_lock(&cpuset_buffer_lock);
 	snprintf(cpuset_name, CPUSET_NAME_LEN,
 		 dentry ? (const char *)dentry->d_name.name : "/");
+	read_mem_lock_irqsave(tsk, flags);
 	nodelist_scnprintf(cpuset_nodelist, CPUSET_NODELIST_LEN,
 			   tsk->mems_allowed);
+	read_mem_unlock_irqrestore(tsk, flags);
 	printk(KERN_INFO "%s cpuset=%s mems_allowed=%s\n",
 	       tsk->comm, cpuset_name, cpuset_nodelist);
 	spin_unlock(&cpuset_buffer_lock);
diff -puN kernel/exit.c~cpusetmm-use-rwlock-to-protect-task-mempolicy-and-mems_allowed kernel/exit.c
--- a/kernel/exit.c~cpusetmm-use-rwlock-to-protect-task-mempolicy-and-mems_allowed
+++ a/kernel/exit.c
@@ -16,6 +16,7 @@
 #include <linux/key.h>
 #include <linux/security.h>
 #include <linux/cpu.h>
+#include <linux/cpuset.h>
 #include <linux/acct.h>
 #include <linux/tsacct_kern.h>
 #include <linux/file.h>
@@ -901,6 +902,7 @@ NORET_TYPE void do_exit(long code)
 {
 	struct task_struct *tsk = current;
 	int group_dead;
+	unsigned long flags;
 
 	profile_task_exit(tsk);
 
@@ -1002,8 +1004,10 @@ NORET_TYPE void do_exit(long code)
 
 	exit_notify(tsk, group_dead);
 #ifdef CONFIG_NUMA
+	write_mem_lock_irqsave(tsk, flags);
 	mpol_put(tsk->mempolicy);
 	tsk->mempolicy = NULL;
+	write_mem_unlock_irqrestore(tsk, flags);
 #endif
 #ifdef CONFIG_FUTEX
 	if (unlikely(current->pi_state_cache))
diff -puN kernel/fork.c~cpusetmm-use-rwlock-to-protect-task-mempolicy-and-mems_allowed kernel/fork.c
--- a/kernel/fork.c~cpusetmm-use-rwlock-to-protect-task-mempolicy-and-mems_allowed
+++ a/kernel/fork.c
@@ -32,6 +32,7 @@
 #include <linux/capability.h>
 #include <linux/cpu.h>
 #include <linux/cgroup.h>
+#include <linux/cpuset.h>
 #include <linux/security.h>
 #include <linux/hugetlb.h>
 #include <linux/swap.h>
@@ -991,6 +992,8 @@ static struct task_struct *copy_process(
 	int retval;
 	struct task_struct *p;
 	int cgroup_callbacks_done = 0;
+	struct mempolicy *pol;
+	unsigned long flags;
 
 	if ((clone_flags & (CLONE_NEWNS|CLONE_FS)) == (CLONE_NEWNS|CLONE_FS))
 		return ERR_PTR(-EINVAL);
@@ -1096,8 +1099,16 @@ static struct task_struct *copy_process(
 	p->io_context = NULL;
 	p->audit_context = NULL;
 	cgroup_fork(p);
+#if defined(CONFIG_CPUSETS) && MAX_NUMNODES > BITS_PER_LONG
+	rwlock_init(&p->mem_rwlock);
+#endif
 #ifdef CONFIG_NUMA
-	p->mempolicy = mpol_dup(p->mempolicy);
+	read_mem_lock_irqsave(current, flags);
+	pol = current->mempolicy;
+	mpol_get(pol);
+	read_mem_unlock_irqrestore(current, flags);
+	p->mempolicy = mpol_dup(pol);
+	mpol_put(pol);
  	if (IS_ERR(p->mempolicy)) {
  		retval = PTR_ERR(p->mempolicy);
  		p->mempolicy = NULL;
diff -puN mm/hugetlb.c~cpusetmm-use-rwlock-to-protect-task-mempolicy-and-mems_allowed mm/hugetlb.c
--- a/mm/hugetlb.c~cpusetmm-use-rwlock-to-protect-task-mempolicy-and-mems_allowed
+++ a/mm/hugetlb.c
@@ -1836,9 +1836,12 @@ static unsigned int cpuset_mems_nr(unsig
 {
 	int node;
 	unsigned int nr = 0;
+	unsigned long flags;
 
+	read_mem_lock_irqsave(current, flags);
 	for_each_node_mask(node, cpuset_current_mems_allowed)
 		nr += array[node];
+	read_mem_unlock_irqrestore(current, flags);
 
 	return nr;
 }
diff -puN mm/mempolicy.c~cpusetmm-use-rwlock-to-protect-task-mempolicy-and-mems_allowed mm/mempolicy.c
--- a/mm/mempolicy.c~cpusetmm-use-rwlock-to-protect-task-mempolicy-and-mems_allowed
+++ a/mm/mempolicy.c
@@ -190,8 +190,9 @@ static int mpol_new_bind(struct mempolic
  * parameter with respect to the policy mode and flags.  But, we need to
  * handle an empty nodemask with MPOL_PREFERRED here.
  *
- * Must be called holding task's alloc_lock to protect task's mems_allowed
- * and mempolicy.  May also be called holding the mmap_semaphore for write.
+ * Must be called using write_mem_lock_irqsave()/write_mem_unlock_irqrestore()
+ * to protect task's mems_allowed and mempolicy.  May also be called holding
+ * the mmap_semaphore for write.
  */
 static int mpol_set_nodemask(struct mempolicy *pol,
 		     const nodemask_t *nodes, struct nodemask_scratch *nsc)
@@ -270,6 +271,16 @@ static struct mempolicy *mpol_new(unsign
 	return policy;
 }
 
+struct mempolicy *__mpol_alloc(void)
+{
+	struct mempolicy *pol;
+
+	pol = kmem_cache_alloc(policy_cache, GFP_KERNEL);
+	if (pol)
+		atomic_set(&pol->refcnt, 1);
+	return pol;
+}
+
 /* Slow path of a mpol destructor. */
 void __mpol_put(struct mempolicy *p)
 {
@@ -347,12 +358,30 @@ static void mpol_rebind_policy(struct me
  * Wrapper for mpol_rebind_policy() that just requires task
  * pointer, and updates task mempolicy.
  *
- * Called with task's alloc_lock held.
+ * if task->pol==NULL, it will return -1, and tell us it is unnecessary to
+ * rebind task's mempolicy.
+ *
+ * Using write_mem_lock_irqsave()/write_mem_unlock_irqrestore() to protect it.
  */
-
-void mpol_rebind_task(struct task_struct *tsk, const nodemask_t *new)
+int mpol_rebind_task(struct task_struct *tsk, const nodemask_t *new,
+						struct mempolicy *newpol)
 {
+#if MAX_NUMNODES > BITS_PER_LONG
+	struct mempolicy *pol = tsk->mempolicy;
+
+	if (!pol)
+		return -1;
+
+	*newpol = *pol;
+	atomic_set(&newpol->refcnt, 1);
+
+	mpol_rebind_policy(newpol, new);
+	tsk->mempolicy = newpol;
+	mpol_put(pol);
+#else
 	mpol_rebind_policy(tsk->mempolicy, new);
+#endif
+	return 0;
 }
 
 /*
@@ -647,12 +676,13 @@ static long do_set_mempolicy(unsigned sh
 	struct mempolicy *new, *old;
 	struct mm_struct *mm = current->mm;
 	NODEMASK_SCRATCH(scratch);
+	unsigned long irqflags;
 	int ret;
 
 	if (!scratch)
 		return -ENOMEM;
 
-	new = mpol_new(mode, flags, nodes);
+	new = mpol_new(mode, flags | MPOL_F_TASK, nodes);
 	if (IS_ERR(new)) {
 		ret = PTR_ERR(new);
 		goto out;
@@ -665,10 +695,10 @@ static long do_set_mempolicy(unsigned sh
 	 */
 	if (mm)
 		down_write(&mm->mmap_sem);
-	task_lock(current);
+	write_mem_lock_irqsave(current, irqflags);
 	ret = mpol_set_nodemask(new, nodes, scratch);
 	if (ret) {
-		task_unlock(current);
+		write_mem_unlock_irqrestore(current, irqflags);
 		if (mm)
 			up_write(&mm->mmap_sem);
 		mpol_put(new);
@@ -680,7 +710,7 @@ static long do_set_mempolicy(unsigned sh
 	if (new && new->mode == MPOL_INTERLEAVE &&
 	    nodes_weight(new->v.nodes))
 		current->il_next = first_node(new->v.nodes);
-	task_unlock(current);
+	write_mem_unlock_irqrestore(current, irqflags);
 	if (mm)
 		up_write(&mm->mmap_sem);
 
@@ -694,7 +724,9 @@ out:
 /*
  * Return nodemask for policy for get_mempolicy() query
  *
- * Called with task's alloc_lock held
+ * Must be called using read_mempolicy_lock_irqsave()/
+ * read_mempolicy_unlock_irqrestore() to
+ * protect it.
  */
 static void get_policy_nodemask(struct mempolicy *p, nodemask_t *nodes)
 {
@@ -738,7 +770,8 @@ static long do_get_mempolicy(int *policy
 	int err;
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma = NULL;
-	struct mempolicy *pol = current->mempolicy;
+	struct mempolicy *pol = NULL;
+	unsigned long irqflags;
 
 	if (flags &
 		~(unsigned long)(MPOL_F_NODE|MPOL_F_ADDR|MPOL_F_MEMS_ALLOWED))
@@ -748,9 +781,10 @@ static long do_get_mempolicy(int *policy
 		if (flags & (MPOL_F_NODE|MPOL_F_ADDR))
 			return -EINVAL;
 		*policy = 0;	/* just so it's initialized */
-		task_lock(current);
+
+		read_mempolicy_lock_irqsave(current, irqflags);
 		*nmask  = cpuset_current_mems_allowed;
-		task_unlock(current);
+		read_mempolicy_unlock_irqrestore(current, irqflags);
 		return 0;
 	}
 
@@ -773,6 +807,13 @@ static long do_get_mempolicy(int *policy
 	} else if (addr)
 		return -EINVAL;
 
+	if (!pol) {
+		read_mempolicy_lock_irqsave(current, irqflags);
+		pol = current->mempolicy;
+		mpol_get(pol);
+		read_mempolicy_unlock_irqrestore(current, irqflags);
+	}
+
 	if (!pol)
 		pol = &default_policy;	/* indicates default behavior */
 
@@ -782,9 +823,11 @@ static long do_get_mempolicy(int *policy
 			if (err < 0)
 				goto out;
 			*policy = err;
-		} else if (pol == current->mempolicy &&
+		} else if (pol->flags & MPOL_F_TASK &&
 				pol->mode == MPOL_INTERLEAVE) {
+			read_mempolicy_lock_irqsave(current, irqflags);
 			*policy = current->il_next;
+			read_mempolicy_unlock_irqrestore(current, irqflags);
 		} else {
 			err = -EINVAL;
 			goto out;
@@ -806,9 +849,17 @@ static long do_get_mempolicy(int *policy
 
 	err = 0;
 	if (nmask) {
-		task_lock(current);
+		/* Maybe task->mempolicy was updated by cpuset, so we must get
+		 * a new one. */
+		mpol_cond_put(pol);
+		read_mempolicy_lock_irqsave(current, irqflags);
+		pol = current->mempolicy;
+		if (pol)
+			mpol_get(pol);
+		else
+			pol = &default_policy;
 		get_policy_nodemask(pol, nmask);
-		task_unlock(current);
+		read_mempolicy_unlock_irqrestore(current, irqflags);
 	}
 
  out:
@@ -1007,6 +1058,7 @@ static long do_mbind(unsigned long start
 	struct mempolicy *new;
 	unsigned long end;
 	int err;
+	unsigned long irqflags;
 	LIST_HEAD(pagelist);
 
 	if (flags & ~(unsigned long)(MPOL_MF_STRICT |
@@ -1054,9 +1106,9 @@ static long do_mbind(unsigned long start
 		NODEMASK_SCRATCH(scratch);
 		if (scratch) {
 			down_write(&mm->mmap_sem);
-			task_lock(current);
+			write_mem_lock_irqsave(current, irqflags);
 			err = mpol_set_nodemask(new, nmask, scratch);
-			task_unlock(current);
+			write_mem_unlock_irqrestore(current, irqflags);
 			if (err)
 				up_write(&mm->mmap_sem);
 		} else
@@ -1396,7 +1448,8 @@ asmlinkage long compat_sys_mbind(compat_
 static struct mempolicy *get_vma_policy(struct task_struct *task,
 		struct vm_area_struct *vma, unsigned long addr)
 {
-	struct mempolicy *pol = task->mempolicy;
+	struct mempolicy *pol = NULL;
+	unsigned long irqflags;
 
 	if (vma) {
 		if (vma->vm_ops && vma->vm_ops->get_policy) {
@@ -1407,8 +1460,16 @@ static struct mempolicy *get_vma_policy(
 		} else if (vma->vm_policy)
 			pol = vma->vm_policy;
 	}
+	if (!pol) {
+		read_mem_lock_irqsave(task, irqflags);
+		pol = task->mempolicy;
+		mpol_get(pol);
+		read_mem_unlock_irqrestore(task, irqflags);
+	}
+
 	if (!pol)
 		pol = &default_policy;
+
 	return pol;
 }
 
@@ -1610,11 +1671,15 @@ bool init_nodemask_of_mempolicy(nodemask
 {
 	struct mempolicy *mempolicy;
 	int nid;
+	unsigned long irqflags;
 
 	if (!(mask && current->mempolicy))
 		return false;
 
+	read_mempolicy_lock_irqsave(current, irqflags);
 	mempolicy = current->mempolicy;
+	mpol_get(mempolicy);
+
 	switch (mempolicy->mode) {
 	case MPOL_PREFERRED:
 		if (mempolicy->flags & MPOL_F_LOCAL)
@@ -1634,6 +1699,9 @@ bool init_nodemask_of_mempolicy(nodemask
 		BUG();
 	}
 
+	read_mempolicy_unlock_irqrestore(current, irqflags);
+	mpol_cond_put(mempolicy);
+
 	return true;
 }
 #endif
@@ -1680,6 +1748,7 @@ alloc_page_vma(gfp_t gfp, struct vm_area
 {
 	struct mempolicy *pol = get_vma_policy(current, vma, addr);
 	struct zonelist *zl;
+	struct page *page;
 
 	if (unlikely(pol->mode == MPOL_INTERLEAVE)) {
 		unsigned nid;
@@ -1693,15 +1762,17 @@ alloc_page_vma(gfp_t gfp, struct vm_area
 		/*
 		 * slow path: ref counted shared policy
 		 */
-		struct page *page =  __alloc_pages_nodemask(gfp, 0,
-						zl, policy_nodemask(gfp, pol));
+		page =  __alloc_pages_nodemask(gfp, 0, zl,
+					policy_nodemask(gfp, pol));
 		__mpol_put(pol);
 		return page;
 	}
 	/*
 	 * fast path:  default or task policy
 	 */
-	return __alloc_pages_nodemask(gfp, 0, zl, policy_nodemask(gfp, pol));
+	page = __alloc_pages_nodemask(gfp, 0, zl, policy_nodemask(gfp, pol));
+	mpol_cond_put(pol);
+	return page;
 }
 
 /**
@@ -1718,26 +1789,36 @@ alloc_page_vma(gfp_t gfp, struct vm_area
  *	Allocate a page from the kernel page pool.  When not in
  *	interrupt context and apply the current process NUMA policy.
  *	Returns NULL when no page can be allocated.
- *
- *	Don't call cpuset_update_task_memory_state() unless
- *	1) it's ok to take cpuset_sem (can WAIT), and
- *	2) allocating for current task (not interrupt).
  */
 struct page *alloc_pages_current(gfp_t gfp, unsigned order)
 {
-	struct mempolicy *pol = current->mempolicy;
+	struct mempolicy *pol;
+	struct page *page;
+	unsigned long irqflags;
+
+	read_mem_lock_irqsave(current, irqflags);
+	pol = current->mempolicy;
+	mpol_get(pol);
+	read_mem_unlock_irqrestore(current, irqflags);
 
-	if (!pol || in_interrupt() || (gfp & __GFP_THISNODE))
+	if (!pol || in_interrupt() || (gfp & __GFP_THISNODE)) {
+		mpol_put(pol);
 		pol = &default_policy;
+	}
 
 	/*
 	 * No reference counting needed for current->mempolicy
 	 * nor system default_policy
 	 */
 	if (pol->mode == MPOL_INTERLEAVE)
-		return alloc_page_interleave(gfp, order, interleave_nodes(pol));
-	return __alloc_pages_nodemask(gfp, order,
-			policy_zonelist(gfp, pol), policy_nodemask(gfp, pol));
+		page = alloc_page_interleave(gfp, order, interleave_nodes(pol));
+	else
+		page =  __alloc_pages_nodemask(gfp, order,
+					policy_zonelist(gfp, pol),
+					policy_nodemask(gfp, pol));
+
+	mpol_cond_put(pol);
+	return page;
 }
 EXPORT_SYMBOL(alloc_pages_current);
 
@@ -1987,6 +2068,7 @@ restart:
  */
 void mpol_shared_policy_init(struct shared_policy *sp, struct mempolicy *mpol)
 {
+	unsigned long irqflags;
 	int ret;
 
 	sp->root = RB_ROOT;		/* empty tree == default mempolicy */
@@ -2007,9 +2089,9 @@ void mpol_shared_policy_init(struct shar
 			return;		/* no valid nodemask intersection */
 		}
 
-		task_lock(current);
+		write_mem_lock_irqsave(current, irqflags);
 		ret = mpol_set_nodemask(new, &mpol->w.user_nodemask, scratch);
-		task_unlock(current);
+		write_mem_unlock_irqrestore(current, irqflags);
 		mpol_put(mpol);	/* drop our ref on sb mpol */
 		if (ret) {
 			NODEMASK_SCRATCH_FREE(scratch);
@@ -2160,6 +2242,7 @@ int mpol_parse_str(char *str, struct mem
 	char *nodelist = strchr(str, ':');
 	char *flags = strchr(str, '=');
 	int i;
+	unsigned long irqflags;
 	int err = 1;
 
 	if (nodelist) {
@@ -2241,9 +2324,9 @@ int mpol_parse_str(char *str, struct mem
 		int ret;
 		NODEMASK_SCRATCH(scratch);
 		if (scratch) {
-			task_lock(current);
+			write_mem_lock_irqsave(current, irqflags);
 			ret = mpol_set_nodemask(new, &nodes, scratch);
-			task_unlock(current);
+			write_mem_unlock_irqrestore(current, irqflags);
 		} else
 			ret = -ENOMEM;
 		NODEMASK_SCRATCH_FREE(scratch);
diff -puN mm/slab.c~cpusetmm-use-rwlock-to-protect-task-mempolicy-and-mems_allowed mm/slab.c
--- a/mm/slab.c~cpusetmm-use-rwlock-to-protect-task-mempolicy-and-mems_allowed
+++ a/mm/slab.c
@@ -3144,14 +3144,25 @@ static inline void *____cache_alloc(stru
 static void *alternate_node_alloc(struct kmem_cache *cachep, gfp_t flags)
 {
 	int nid_alloc, nid_here;
+	struct mempolicy *pol;
+	unsigned long lflags;
 
 	if (in_interrupt() || (flags & __GFP_THISNODE))
 		return NULL;
+
+	read_mem_lock_irqsave(current, lflags);
+	pol = current->mempolicy;
+	mpol_get(pol);
+	read_mem_unlock_irqrestore(current, lflags);
+
 	nid_alloc = nid_here = numa_node_id();
 	if (cpuset_do_slab_mem_spread() && (cachep->flags & SLAB_MEM_SPREAD))
 		nid_alloc = cpuset_mem_spread_node();
-	else if (current->mempolicy)
-		nid_alloc = slab_node(current->mempolicy);
+	else if (pol)
+		nid_alloc = slab_node(pol);
+
+	mpol_put(pol);
+
 	if (nid_alloc != nid_here)
 		return ____cache_alloc_node(cachep, flags, nid_alloc);
 	return NULL;
@@ -3174,11 +3185,21 @@ static void *fallback_alloc(struct kmem_
 	enum zone_type high_zoneidx = gfp_zone(flags);
 	void *obj = NULL;
 	int nid;
+	struct mempolicy *pol;
+	unsigned long lflags;
 
 	if (flags & __GFP_THISNODE)
 		return NULL;
 
-	zonelist = node_zonelist(slab_node(current->mempolicy), flags);
+	read_mem_lock_irqsave(current, lflags);
+	pol = current->mempolicy;
+	mpol_get(pol);
+	read_mem_unlock_irqrestore(current, lflags);
+
+	zonelist = node_zonelist(slab_node(pol), flags);
+
+	mpol_put(pol);
+
 	local_flags = flags & (GFP_CONSTRAINT_MASK|GFP_RECLAIM_MASK);
 
 retry:
diff -puN mm/slub.c~cpusetmm-use-rwlock-to-protect-task-mempolicy-and-mems_allowed mm/slub.c
--- a/mm/slub.c~cpusetmm-use-rwlock-to-protect-task-mempolicy-and-mems_allowed
+++ a/mm/slub.c
@@ -1345,6 +1345,8 @@ static struct page *get_any_partial(stru
 	struct zone *zone;
 	enum zone_type high_zoneidx = gfp_zone(flags);
 	struct page *page;
+	struct mempolicy *pol;
+	unsigned long lflags
 
 	/*
 	 * The defrag ratio allows a configuration of the tradeoffs between
@@ -1368,7 +1370,15 @@ static struct page *get_any_partial(stru
 			get_cycles() % 1024 > s->remote_node_defrag_ratio)
 		return NULL;
 
+	read_mem_lock_irqsave(current, lflags);
+	pol = current->mempolicy;
+	mpol_get(pol);
+	read_mem_unlock_irqrestore(current, lflags);
+
 	zonelist = node_zonelist(slab_node(current->mempolicy), flags);
+
+	mpol_put(pol);
+
 	for_each_zone_zonelist(zone, z, zonelist, high_zoneidx) {
 		struct kmem_cache_node *n;
 
_

Patches currently in -mm which might be from miaox@cn.fujitsu.com are

cpuset-fix-the-problem-that-cpuset_mem_spread_node-returns-an-offline-node.patch
nodemask-fix-the-declaration-of-nodemask_alloc.patch
cpuset-alloc-nodemask_t-at-heap-not-stack.patch
cpusetmm-use-rwlock-to-protect-task-mempolicy-and-mems_allowed.patch

