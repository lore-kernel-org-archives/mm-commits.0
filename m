From: akpm@linux-foundation.org
Subject: + cgroups-add-functionality-to-read-write-lock-clone_thread-forking-per-threadgroup.patch added to -mm tree
Date: Thu, 20 Aug 2009 14:14:22 -0700
Message-ID: <200908202114.n7KLEN5H026646@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54362 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755472AbZHTVUh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Aug 2009 17:20:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bblum@google.com, ebiederm@xmission.com, lizf@cn.fujitsu.com, matthltc@us.ibm.com, menage@google.com, oleg@redhat.com


The patch titled
     cgroups: add functionality to read/write lock CLONE_THREAD fork()ing per-threadgroup
has been added to the -mm tree.  Its filename is
     cgroups-add-functionality-to-read-write-lock-clone_thread-forking-per-threadgroup.patch

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
Subject: cgroups: add functionality to read/write lock CLONE_THREAD fork()ing per-threadgroup
From: Ben Blum <bblum@google.com>

Add an rwsem that lives in a threadgroup's sighand_struct (next to the
sighand's atomic count, to piggyback on its cacheline), and two functions
in kernel/cgroup.c (for now) for easily+safely obtaining and releasing it.

If another part of the kernel later wants to use such a locking mechanism,
the CONFIG_CGROUPS ifdefs should be changed to a higher-up flag that
CGROUPS and the other system would both depend on, and the lock/unlock
functions could be moved to sched.c or so.

Signed-off-by: Ben Blum <bblum@google.com>
Signed-off-by: Paul Menage <menage@google.com>
Acked-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Matt Helsley <matthltc@us.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup.h    |   14 ++++-
 include/linux/init_task.h |    9 +++
 include/linux/sched.h     |   15 ++++++
 kernel/cgroup.c           |   87 +++++++++++++++++++++++++++++++++++-
 kernel/fork.c             |    9 ++-
 5 files changed, 125 insertions(+), 9 deletions(-)

diff -puN include/linux/cgroup.h~cgroups-add-functionality-to-read-write-lock-clone_thread-forking-per-threadgroup include/linux/cgroup.h
--- a/include/linux/cgroup.h~cgroups-add-functionality-to-read-write-lock-clone_thread-forking-per-threadgroup
+++ a/include/linux/cgroup.h
@@ -30,10 +30,12 @@ extern int cgroup_init(void);
 extern void cgroup_lock(void);
 extern bool cgroup_lock_live_group(struct cgroup *cgrp);
 extern void cgroup_unlock(void);
-extern void cgroup_fork(struct task_struct *p);
+extern void cgroup_fork(struct task_struct *p, unsigned long clone_flags);
 extern void cgroup_fork_callbacks(struct task_struct *p);
-extern void cgroup_post_fork(struct task_struct *p);
+extern void cgroup_post_fork(struct task_struct *p, unsigned long clone_flags);
 extern void cgroup_exit(struct task_struct *p, int run_callbacks);
+extern void cgroup_fork_failed(struct task_struct *p, int run_callbacks,
+			       unsigned long clone_flags);
 extern int cgroupstats_build(struct cgroupstats *stats,
 				struct dentry *dentry);
 
@@ -568,10 +570,14 @@ unsigned short css_depth(struct cgroup_s
 
 static inline int cgroup_init_early(void) { return 0; }
 static inline int cgroup_init(void) { return 0; }
-static inline void cgroup_fork(struct task_struct *p) {}
+static inline void cgroup_fork(struct task_struct *p,
+			       unsigned long clone_flags) {}
 static inline void cgroup_fork_callbacks(struct task_struct *p) {}
-static inline void cgroup_post_fork(struct task_struct *p) {}
+static inline void cgroup_post_fork(struct task_struct *p,
+				    unsigned long clone_flags) {}
 static inline void cgroup_exit(struct task_struct *p, int callbacks) {}
+static inline void cgroup_fork_failed(struct task_struct *p, int callbacks,
+				      unsigned long clone_flags) {}
 
 static inline void cgroup_lock(void) {}
 static inline void cgroup_unlock(void) {}
diff -puN include/linux/init_task.h~cgroups-add-functionality-to-read-write-lock-clone_thread-forking-per-threadgroup include/linux/init_task.h
--- a/include/linux/init_task.h~cgroups-add-functionality-to-read-write-lock-clone_thread-forking-per-threadgroup
+++ a/include/linux/init_task.h
@@ -41,7 +41,16 @@ extern struct nsproxy init_nsproxy;
 	INIT_IPC_NS(ipc_ns)						\
 }
 
+#ifdef CONFIG_CGROUPS
+# define INIT_THREADGROUP_FORK_LOCK(sighand)				\
+	.threadgroup_fork_lock = 					\
+		__RWSEM_INITIALIZER(sighand.threadgroup_fork_lock),
+#else
+# define INIT_THREADGROUP_FORK_LOCK(sighand)
+#endif
+
 #define INIT_SIGHAND(sighand) {						\
+	INIT_THREADGROUP_FORK_LOCK(sighand)				\
 	.count		= ATOMIC_INIT(1), 				\
 	.action		= { { { .sa_handler = NULL, } }, },		\
 	.siglock	= __SPIN_LOCK_UNLOCKED(sighand.siglock),	\
diff -puN include/linux/sched.h~cgroups-add-functionality-to-read-write-lock-clone_thread-forking-per-threadgroup include/linux/sched.h
--- a/include/linux/sched.h~cgroups-add-functionality-to-read-write-lock-clone_thread-forking-per-threadgroup
+++ a/include/linux/sched.h
@@ -478,6 +478,21 @@ extern int get_dumpable(struct mm_struct
 #define MMF_INIT_MASK		(MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK)
 
 struct sighand_struct {
+#ifdef CONFIG_CGROUPS
+	/*
+	 * The threadgroup_fork_lock is used to prevent any threads in a
+	 * threadgroup from forking with CLONE_THREAD while held for writing,
+	 * used for threadgroup-wide operations that are fork-sensitive. It
+	 * lives here next to sighand.count as a cacheline optimization.
+	 *
+	 * TODO: if anybody besides cgroups uses this lock, change the
+	 * CONFIG_CGROUPS to a higher-up CONFIG_* that the other user and
+	 * cgroups would both depend upon. Also, they'll want to move where
+	 * the readlock happens - it currently lives in kernel/cgroup.c in
+	 * cgroup_{fork,post_fork,fork_failed}().
+	 */
+	struct rw_semaphore	threadgroup_fork_lock;
+#endif
 	atomic_t		count;
 	struct k_sigaction	action[_NSIG];
 	spinlock_t		siglock;
diff -puN kernel/cgroup.c~cgroups-add-functionality-to-read-write-lock-clone_thread-forking-per-threadgroup kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-add-functionality-to-read-write-lock-clone_thread-forking-per-threadgroup
+++ a/kernel/cgroup.c
@@ -1529,6 +1529,65 @@ int cgroup_path(const struct cgroup *cgr
 }
 
 /**
+ * threadgroup_fork_lock - block all CLONE_THREAD forks in the threadgroup
+ * @tsk: the task whose threadgroup should be locked
+ *
+ * Takes the threadgroup_lock_mutex in the threadgroup's sighand_struct, by
+ * means of searching the threadgroup list for a live thread in the group.
+ * Returns the sighand_struct that should be given to threadgroup_fork_unlock,
+ * or NULL if all threads in the group are exiting and have cleared their
+ * sighand pointers.
+ */
+struct sighand_struct *threadgroup_fork_lock(struct task_struct *tsk)
+{
+	struct sighand_struct *sighand;
+	struct task_struct *p;
+
+	/* tasklist lock protects sighand_struct's disappearance in exit(). */
+	read_lock(&tasklist_lock);
+	if (likely(tsk->sighand)) {
+		/* simple case - check the thread we were given first */
+		sighand = tsk->sighand;
+	} else {
+		sighand = NULL;
+		/*
+		 * tsk is exiting; try to find another thread in the group
+		 * whose sighand pointer is still alive.
+		 */
+		rcu_read_lock();
+		list_for_each_entry_rcu(p, &tsk->thread_group, thread_group) {
+			if (p->sighand) {
+				sighand = tsk->sighand;
+				break;
+			}
+		}
+		rcu_read_unlock();
+	}
+	/* prevent sighand from vanishing before we let go of tasklist_lock */
+	if (likely(sighand))
+		atomic_inc(&sighand->count);
+
+	/* done searching. */
+	read_unlock(&tasklist_lock);
+
+	if (likely(sighand))
+		down_write(&sighand->threadgroup_fork_lock);
+	return sighand;
+}
+
+/**
+ * threadgroup_fork_lock - let threadgroup resume CLONE_THREAD forks.
+ * @sighand: the threadgroup's sighand that threadgroup_fork_lock gave back
+ *
+ * Lets go of the threadgroup_fork_lock, and drops the sighand reference.
+ */
+void threadgroup_fork_unlock(struct sighand_struct *sighand)
+{
+	up_write(&sighand->threadgroup_fork_lock);
+	__cleanup_sighand(sighand);
+}
+
+/**
  * cgroup_attach_task - attach task 'tsk' to cgroup 'cgrp'
  * @cgrp: the cgroup the task is attaching to
  * @tsk: the task to be attached
@@ -3421,8 +3480,10 @@ static struct file_operations proc_cgrou
  * At the point that cgroup_fork() is called, 'current' is the parent
  * task, and the passed argument 'child' points to the child task.
  */
-void cgroup_fork(struct task_struct *child)
+void cgroup_fork(struct task_struct *child, unsigned long clone_flags)
 {
+	if (clone_flags & CLONE_THREAD)
+		down_read(&current->sighand->threadgroup_fork_lock);
 	task_lock(current);
 	child->cgroups = current->cgroups;
 	get_css_set(child->cgroups);
@@ -3459,7 +3520,7 @@ void cgroup_fork_callbacks(struct task_s
  * with the first call to cgroup_iter_start() - to guarantee that the
  * new task ends up on its list.
  */
-void cgroup_post_fork(struct task_struct *child)
+void cgroup_post_fork(struct task_struct *child, unsigned long clone_flags)
 {
 	if (use_task_css_set_links) {
 		write_lock(&css_set_lock);
@@ -3469,6 +3530,8 @@ void cgroup_post_fork(struct task_struct
 		task_unlock(child);
 		write_unlock(&css_set_lock);
 	}
+	if (clone_flags & CLONE_THREAD)
+		up_read(&current->sighand->threadgroup_fork_lock);
 }
 /**
  * cgroup_exit - detach cgroup from exiting task
@@ -3540,6 +3603,26 @@ void cgroup_exit(struct task_struct *tsk
 }
 
 /**
+ * cgroup_fork_failed - undo operations for fork failure
+ * @tsk: pointer to  task_struct of exiting process
+ * @run_callback: run exit callbacks?
+ *
+ * Description: Undo cgroup operations after cgroup_fork in fork failure.
+ *
+ * We release the read lock that was taken in cgroup_fork(), since it is
+ * supposed to be dropped in cgroup_post_fork in the success case. The other
+ * thing that wants to be done is detaching the failed child task from the
+ * cgroup, so we wrap cgroup_exit.
+ */
+void cgroup_fork_failed(struct task_struct *tsk, int run_callbacks,
+			unsigned long clone_flags)
+{
+	if (clone_flags & CLONE_THREAD)
+		up_read(&current->sighand->threadgroup_fork_lock);
+	cgroup_exit(tsk, run_callbacks);
+}
+
+/**
  * cgroup_clone - clone the cgroup the given subsystem is attached to
  * @tsk: the task to be moved
  * @subsys: the given subsystem
diff -puN kernel/fork.c~cgroups-add-functionality-to-read-write-lock-clone_thread-forking-per-threadgroup kernel/fork.c
--- a/kernel/fork.c~cgroups-add-functionality-to-read-write-lock-clone_thread-forking-per-threadgroup
+++ a/kernel/fork.c
@@ -792,6 +792,9 @@ static int copy_sighand(unsigned long cl
 		return -ENOMEM;
 	atomic_set(&sig->count, 1);
 	memcpy(sig->action, current->sighand->action, sizeof(sig->action));
+#ifdef CONFIG_CGROUPS
+	init_rwsem(&sig->threadgroup_fork_lock);
+#endif
 	return 0;
 }
 
@@ -1074,7 +1077,7 @@ static struct task_struct *copy_process(
 	monotonic_to_bootbased(&p->real_start_time);
 	p->io_context = NULL;
 	p->audit_context = NULL;
-	cgroup_fork(p);
+	cgroup_fork(p, clone_flags);
 #ifdef CONFIG_NUMA
 	p->mempolicy = mpol_dup(p->mempolicy);
  	if (IS_ERR(p->mempolicy)) {
@@ -1292,7 +1295,7 @@ static struct task_struct *copy_process(
 	spin_unlock(&current->sighand->siglock);
 	write_unlock_irq(&tasklist_lock);
 	proc_fork_connector(p);
-	cgroup_post_fork(p);
+	cgroup_post_fork(p, clone_flags);
 	perf_counter_fork(p);
 	return p;
 
@@ -1324,7 +1327,7 @@ bad_fork_cleanup_policy:
 	mpol_put(p->mempolicy);
 bad_fork_cleanup_cgroup:
 #endif
-	cgroup_exit(p, cgroup_callbacks_done);
+	cgroup_fork_failed(p, cgroup_callbacks_done, clone_flags);
 	delayacct_tsk_free(p);
 	if (p->binfmt)
 		module_put(p->binfmt->module);
_

Patches currently in -mm which might be from bblum@google.com are

cgroups-add-a-read-only-procs-file-similar-to-tasks-that-shows-only-unique-tgids.patch
cgroups-ensure-correct-concurrent-opening-reading-of-pidlists-across-pid-namespaces.patch
cgroups-use-vmalloc-for-large-cgroups-pidlist-allocations.patch
cgroups-change-css_set-freeing-mechanism-to-be-under-rcu.patch
cgroups-let-ss-can_attach-and-ss-attach-do-whole-threadgroups-at-a-time.patch
cgroups-add-functionality-to-read-write-lock-clone_thread-forking-per-threadgroup.patch
cgroups-add-functionality-to-read-write-lock-clone_thread-forking-per-threadgroup-fix.patch
cgroups-add-ability-to-move-all-threads-in-a-process-to-a-new-cgroup-atomically.patch

