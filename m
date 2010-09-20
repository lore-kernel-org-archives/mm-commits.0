From: akpm@linux-foundation.org
Subject: + kernel-extract-thread-types-from-task_struct-flags.patch added to -mm tree
Date: Mon, 20 Sep 2010 12:14:55 -0700
Message-ID: <201009201914.o8KJEtxe008043@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56486 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757230Ab0ITTQF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Sep 2010 15:16:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, avi@redhat.com, axboe@kernel.dk, mingo@elte.hu, tglx@linutronix.de, tj@kernel.org


The patch titled
     kernel: extract thread types from task_struct::flags
has been added to the -mm tree.  Its filename is
     kernel-extract-thread-types-from-task_struct-flags.patch

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
Subject: kernel: extract thread types from task_struct::flags
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Free up a few more PF_flags by moving thread types out to their own
variable.

Initially I compressed the types into less bits inside task_struct::flags,
but Thomas suggested I move them to their own field.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>
Cc: Avi Kivity <avi@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c                   |    4 -
 fs/xfs/linux-2.6/xfs_aops.c |    2 
 include/linux/init_task.h   |    3 -
 include/linux/kvm_host.h    |    4 -
 include/linux/sched.h       |   79 +++++++++++++++++++++-------------
 include/linux/swap.h        |    2 
 kernel/exit.c               |    3 -
 kernel/fork.c               |   12 ++++-
 kernel/ptrace.c             |    2 
 kernel/rtmutex-tester.c     |    2 
 kernel/rtmutex_common.h     |    2 
 kernel/sched.c              |    7 +--
 kernel/workqueue.c          |    4 -
 lib/is_single_threaded.c    |    2 
 mm/oom_kill.c               |    2 
 mm/vmscan.c                 |    3 -
 16 files changed, 82 insertions(+), 51 deletions(-)

diff -puN fs/exec.c~kernel-extract-thread-types-from-task_struct-flags fs/exec.c
--- a/fs/exec.c~kernel-extract-thread-types-from-task_struct-flags
+++ a/fs/exec.c
@@ -1406,7 +1406,7 @@ int do_execve(const char * filename,
 	if (retval < 0)
 		goto out;
 
-	current->flags &= ~PF_KTHREAD;
+	task_set_type(current, tt_user);
 	retval = search_binary_handler(bprm,regs);
 	if (retval < 0)
 		goto out;
@@ -1656,7 +1656,7 @@ static inline int zap_threads(struct tas
 	for_each_process(g) {
 		if (g == tsk->group_leader)
 			continue;
-		if (g->flags & PF_KTHREAD)
+		if (task_type(g) >= tt_kernel)
 			continue;
 		p = g;
 		do {
diff -puN fs/xfs/linux-2.6/xfs_aops.c~kernel-extract-thread-types-from-task_struct-flags fs/xfs/linux-2.6/xfs_aops.c
--- a/fs/xfs/linux-2.6/xfs_aops.c~kernel-extract-thread-types-from-task_struct-flags
+++ a/fs/xfs/linux-2.6/xfs_aops.c
@@ -1067,7 +1067,7 @@ xfs_vm_writepage(
 	 * filesystems like XFS, btrfs and ext4 have to take care of this
 	 * by themselves.
 	 */
-	if ((current->flags & (PF_MEMALLOC|PF_KSWAPD)) == PF_MEMALLOC)
+	if (task_type(current) != tt_kswapd && (current->flags & PF_MEMALLOC))
 		goto redirty;
 
 	/*
diff -puN include/linux/init_task.h~kernel-extract-thread-types-from-task_struct-flags include/linux/init_task.h
--- a/include/linux/init_task.h~kernel-extract-thread-types-from-task_struct-flags
+++ a/include/linux/init_task.h
@@ -117,7 +117,8 @@ extern struct cred init_cred;
 	.state		= 0,						\
 	.stack		= &init_thread_info,				\
 	.usage		= ATOMIC_INIT(2),				\
-	.flags		= PF_KTHREAD,					\
+	.flags		= 0,						\
+	.threadtype	= tt_kernel,					\
 	.lock_depth	= -1,						\
 	.prio		= MAX_PRIO-20,					\
 	.static_prio	= MAX_PRIO-20,					\
diff -puN include/linux/kvm_host.h~kernel-extract-thread-types-from-task_struct-flags include/linux/kvm_host.h
--- a/include/linux/kvm_host.h~kernel-extract-thread-types-from-task_struct-flags
+++ a/include/linux/kvm_host.h
@@ -514,13 +514,13 @@ static inline int kvm_deassign_device(st
 static inline void kvm_guest_enter(void)
 {
 	account_system_vtime(current);
-	current->flags |= PF_VCPU;
+	task_set_type(current, tt_vcpu);
 }
 
 static inline void kvm_guest_exit(void)
 {
 	account_system_vtime(current);
-	current->flags &= ~PF_VCPU;
+	task_set_type(current, tt_user);
 }
 
 static inline unsigned long gfn_to_hva_memslot(struct kvm_memory_slot *slot,
diff -puN include/linux/sched.h~kernel-extract-thread-types-from-task_struct-flags include/linux/sched.h
--- a/include/linux/sched.h~kernel-extract-thread-types-from-task_struct-flags
+++ a/include/linux/sched.h
@@ -1168,12 +1168,26 @@ enum perf_event_task_context {
 	perf_nr_task_contexts,
 };
 
+/*
+ * Types >= tt_kernel imply the old PF_KTHREAD
+ */
+enum thread_type {
+	tt_user	= 0,		/* I'm a normal userspace thread */
+	tt_vcpu,		/* I'm a VCPU */
+	tt_kernel,		/* I'm a normal kernel thread */
+	tt_worker,		/* I'm a workqueue worker thread */
+	tt_kswapd,		/* I'm a kswap daemon thread */
+	tt_mutex_tester,	/* I'm a mutex tester thread */
+	tt_nr_max,
+};
+
 struct task_struct {
 	volatile long state;	/* -1 unrunnable, 0 runnable, >0 stopped */
 	void *stack;
 	atomic_t usage;
 	unsigned int flags;	/* per process flags, defined below */
 	unsigned int ptrace;
+	enum thread_type threadtype;
 
 	int lock_depth;		/* BKL lock depth */
 
@@ -1691,36 +1705,41 @@ extern void thread_group_times(struct ta
 /*
  * Per process flags
  */
-#define PF_STARTING	0x00000002	/* being created */
-#define PF_EXITING	0x00000004	/* getting shut down */
-#define PF_EXITPIDONE	0x00000008	/* pi exit done on shut down */
-#define PF_VCPU		0x00000010	/* I'm a virtual CPU */
-#define PF_WQ_WORKER	0x00000020	/* I'm a workqueue worker */
-#define PF_FORKNOEXEC	0x00000040	/* forked but didn't exec */
-#define PF_MCE_PROCESS  0x00000080      /* process policy on mce errors */
-#define PF_SUPERPRIV	0x00000100	/* used super-user privileges */
-#define PF_DUMPCORE	0x00000200	/* dumped core */
-#define PF_SIGNALED	0x00000400	/* killed by a signal */
-#define PF_MEMALLOC	0x00000800	/* Allocating memory */
-#define PF_USED_MATH	0x00002000	/* if unset the fpu must be initialized before use */
-#define PF_FREEZING	0x00004000	/* freeze in progress. do not account to load */
-#define PF_NOFREEZE	0x00008000	/* this thread should not be frozen */
-#define PF_FROZEN	0x00010000	/* frozen for system suspend */
-#define PF_FSTRANS	0x00020000	/* inside a filesystem transaction */
-#define PF_KSWAPD	0x00040000	/* I am kswapd */
-#define PF_OOM_ORIGIN	0x00080000	/* Allocating much memory to others */
-#define PF_LESS_THROTTLE 0x00100000	/* Throttle me less: I clean memory */
-#define PF_KTHREAD	0x00200000	/* I am a kernel thread */
-#define PF_RANDOMIZE	0x00400000	/* randomize virtual address space */
-#define PF_SWAPWRITE	0x00800000	/* Allowed to write to swap */
-#define PF_SPREAD_PAGE	0x01000000	/* Spread page cache over cpuset */
-#define PF_SPREAD_SLAB	0x02000000	/* Spread some slab caches over cpuset */
-#define PF_THREAD_BOUND	0x04000000	/* Thread bound to specific cpu */
-#define PF_MCE_EARLY    0x08000000      /* Early kill for mce process policy */
-#define PF_MEMPOLICY	0x10000000	/* Non-default NUMA mempolicy */
-#define PF_MUTEX_TESTER	0x20000000	/* Thread belongs to the rt mutex tester */
-#define PF_FREEZER_SKIP	0x40000000	/* Freezer should not count it as freezeable */
-#define PF_FREEZER_NOSIG 0x80000000	/* Freezer won't send signals to it */
+#define PF_STARTING	 0x00000001	/* being created */
+#define PF_EXITING	 0x00000002	/* getting shut down */
+#define PF_EXITPIDONE	 0x00000004	/* pi exit done on shut down */
+#define PF_FORKNOEXEC	 0x00000008	/* forked but didn't exec */
+#define PF_MCE_PROCESS   0x00000010	/* process policy on mce errors */
+#define PF_SUPERPRIV	 0x00000020	/* used super-user privileges */
+#define PF_DUMPCORE	 0x00000040	/* dumped core */
+#define PF_SIGNALED	 0x00000080	/* killed by a signal */
+#define PF_MEMALLOC	 0x00000100	/* Allocating memory */
+#define PF_USED_MATH	 0x00000200	/* if unset the fpu must be initialized before use */
+#define PF_FREEZING	 0x00000400	/* freeze in progress. do not account to load */
+#define PF_NOFREEZE	 0x00000800	/* this thread should not be frozen */
+#define PF_FROZEN	 0x00001000	/* frozen for system suspend */
+#define PF_FREEZER_SKIP	 0x00002000	/* Freezer should not count it as freezeable */
+#define PF_FREEZER_NOSIG 0x00004000	/* Freezer won't send signals to it */
+#define PF_FSTRANS	 0x00008000	/* inside a filesystem transaction */
+#define PF_OOM_ORIGIN	 0x00010000	/* Allocating much memory to others */
+#define PF_LESS_THROTTLE 0x00020000	/* Throttle me less: I clean memory */
+#define PF_RANDOMIZE	 0x00040000	/* randomize virtual address space */
+#define PF_SWAPWRITE	 0x00080000	/* Allowed to write to swap */
+#define PF_SPREAD_PAGE	 0x00100000	/* Spread page cache over cpuset */
+#define PF_SPREAD_SLAB	 0x00200000	/* Spread some slab caches over cpuset */
+#define PF_THREAD_BOUND	 0x00400000	/* Thread bound to specific cpu */
+#define PF_MCE_EARLY     0x00800000	/* Early kill for mce process policy */
+#define PF_MEMPOLICY	 0x01000000	/* Non-default NUMA mempolicy */
+
+static inline void task_set_type(struct task_struct *p, enum thread_type type)
+{
+	p->threadtype = type;
+}
+
+static inline enum thread_type task_type(struct task_struct *p)
+{
+	return p->threadtype;
+}
 
 /*
  * Only the _current_ task can read/write to tsk->flags, but other
diff -puN include/linux/swap.h~kernel-extract-thread-types-from-task_struct-flags include/linux/swap.h
--- a/include/linux/swap.h~kernel-extract-thread-types-from-task_struct-flags
+++ a/include/linux/swap.h
@@ -23,7 +23,7 @@ struct bio;
 
 static inline int current_is_kswapd(void)
 {
-	return current->flags & PF_KSWAPD;
+	return task_type(current) == tt_kswapd;
 }
 
 /*
diff -puN kernel/exit.c~kernel-extract-thread-types-from-task_struct-flags kernel/exit.c
--- a/kernel/exit.c~kernel-extract-thread-types-from-task_struct-flags
+++ a/kernel/exit.c
@@ -432,7 +432,8 @@ void daemonize(const char *name, ...)
 	 * We don't want to have TIF_FREEZE set if the system-wide hibernation
 	 * or suspend transition begins right now.
 	 */
-	current->flags |= (PF_NOFREEZE | PF_KTHREAD);
+	task_set_type(current, tt_kernel);
+	current->flags |= PF_NOFREEZE;
 
 	if (current->nsproxy != &init_nsproxy) {
 		get_nsproxy(&init_nsproxy);
diff -puN kernel/fork.c~kernel-extract-thread-types-from-task_struct-flags kernel/fork.c
--- a/kernel/fork.c~kernel-extract-thread-types-from-task_struct-flags
+++ a/kernel/fork.c
@@ -572,7 +572,7 @@ struct mm_struct *get_task_mm(struct tas
 	task_lock(task);
 	mm = task->mm;
 	if (mm) {
-		if (task->flags & PF_KTHREAD)
+		if (task_type(task) >= tt_kernel)
 			mm = NULL;
 		else
 			atomic_inc(&mm->mm_users);
@@ -914,8 +914,16 @@ static int copy_signal(unsigned long clo
 static void copy_flags(unsigned long clone_flags, struct task_struct *p)
 {
 	unsigned long new_flags = p->flags;
+	unsigned long new_type;
 
-	new_flags &= ~(PF_SUPERPRIV | PF_WQ_WORKER);
+	if (task_type(p) >= tt_kernel)
+		new_type = tt_kernel;
+	else
+		new_type = tt_user;
+
+	task_set_type(p, new_type);
+
+	new_flags &= ~PF_SUPERPRIV;
 	new_flags |= PF_FORKNOEXEC;
 	new_flags |= PF_STARTING;
 	p->flags = new_flags;
diff -puN kernel/ptrace.c~kernel-extract-thread-types-from-task_struct-flags kernel/ptrace.c
--- a/kernel/ptrace.c~kernel-extract-thread-types-from-task_struct-flags
+++ a/kernel/ptrace.c
@@ -170,7 +170,7 @@ int ptrace_attach(struct task_struct *ta
 	audit_ptrace(task);
 
 	retval = -EPERM;
-	if (unlikely(task->flags & PF_KTHREAD))
+	if (unlikely(task_type(task) >= tt_kernel))
 		goto out;
 	if (same_thread_group(task, current))
 		goto out;
diff -puN kernel/rtmutex-tester.c~kernel-extract-thread-types-from-task_struct-flags kernel/rtmutex-tester.c
--- a/kernel/rtmutex-tester.c~kernel-extract-thread-types-from-task_struct-flags
+++ a/kernel/rtmutex-tester.c
@@ -265,7 +265,7 @@ static int test_func(void *data)
 	struct test_thread_data *td = data;
 	int ret;
 
-	current->flags |= PF_MUTEX_TESTER;
+	task_set_type(current, tt_mutex_tester);
 	set_freezable();
 	allow_signal(SIGHUP);
 
diff -puN kernel/rtmutex_common.h~kernel-extract-thread-types-from-task_struct-flags kernel/rtmutex_common.h
--- a/kernel/rtmutex_common.h~kernel-extract-thread-types-from-task_struct-flags
+++ a/kernel/rtmutex_common.h
@@ -26,7 +26,7 @@ extern void schedule_rt_mutex_test(struc
 
 #define schedule_rt_mutex(_lock)				\
   do {								\
-	if (!(current->flags & PF_MUTEX_TESTER))		\
+	if (task_type(current) != tt_mutex_tester)		\
 		schedule();					\
 	else							\
 		schedule_rt_mutex_test(_lock);			\
diff -puN kernel/sched.c~kernel-extract-thread-types-from-task_struct-flags kernel/sched.c
--- a/kernel/sched.c~kernel-extract-thread-types-from-task_struct-flags
+++ a/kernel/sched.c
@@ -2322,7 +2322,7 @@ static inline void ttwu_post_activation(
 	}
 #endif
 	/* if a worker is waking up, notify workqueue */
-	if ((p->flags & PF_WQ_WORKER) && success)
+	if (task_type(p) == tt_worker && success)
 		wq_worker_waking_up(p, cpu_of(rq));
 }
 
@@ -3380,7 +3380,8 @@ void account_system_time(struct task_str
 	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
 	cputime64_t tmp;
 
-	if ((p->flags & PF_VCPU) && (irq_count() - hardirq_offset == 0)) {
+
+	if (task_type(p) == tt_vcpu && (irq_count() - hardirq_offset == 0)) {
 		account_guest_time(p, cputime, cputime_scaled);
 		return;
 	}
@@ -3772,7 +3773,7 @@ need_resched_nonpreemptible:
 			 * task to maintain concurrency.  If so, wake
 			 * up the task.
 			 */
-			if (prev->flags & PF_WQ_WORKER) {
+			if (task_type(prev) == tt_worker) {
 				struct task_struct *to_wakeup;
 
 				to_wakeup = wq_worker_sleeping(prev, cpu);
diff -puN kernel/workqueue.c~kernel-extract-thread-types-from-task_struct-flags kernel/workqueue.c
--- a/kernel/workqueue.c~kernel-extract-thread-types-from-task_struct-flags
+++ a/kernel/workqueue.c
@@ -1888,14 +1888,14 @@ static int worker_thread(void *__worker)
 	struct global_cwq *gcwq = worker->gcwq;
 
 	/* tell the scheduler that this is a workqueue worker */
-	worker->task->flags |= PF_WQ_WORKER;
+	task_set_type(worker->task, tt_worker);
 woke_up:
 	spin_lock_irq(&gcwq->lock);
 
 	/* DIE can be set only while we're idle, checking here is enough */
 	if (worker->flags & WORKER_DIE) {
 		spin_unlock_irq(&gcwq->lock);
-		worker->task->flags &= ~PF_WQ_WORKER;
+		task_set_type(worker->task, tt_kernel);
 		return 0;
 	}
 
diff -puN lib/is_single_threaded.c~kernel-extract-thread-types-from-task_struct-flags lib/is_single_threaded.c
--- a/lib/is_single_threaded.c~kernel-extract-thread-types-from-task_struct-flags
+++ a/lib/is_single_threaded.c
@@ -31,7 +31,7 @@ bool current_is_single_threaded(void)
 	ret = false;
 	rcu_read_lock();
 	for_each_process(p) {
-		if (unlikely(p->flags & PF_KTHREAD))
+		if (unlikely(task_type(p) >= tt_kernel))
 			continue;
 		if (unlikely(p == task->group_leader))
 			continue;
diff -puN mm/oom_kill.c~kernel-extract-thread-types-from-task_struct-flags mm/oom_kill.c
--- a/mm/oom_kill.c~kernel-extract-thread-types-from-task_struct-flags
+++ a/mm/oom_kill.c
@@ -126,7 +126,7 @@ static bool oom_unkillable_task(struct t
 {
 	if (is_global_init(p))
 		return true;
-	if (p->flags & PF_KTHREAD)
+	if (task_type(p) >= tt_kernel)
 		return true;
 
 	/* When mem_cgroup_out_of_memory() and p is not member of the group */
diff -puN mm/vmscan.c~kernel-extract-thread-types-from-task_struct-flags mm/vmscan.c
--- a/mm/vmscan.c~kernel-extract-thread-types-from-task_struct-flags
+++ a/mm/vmscan.c
@@ -2439,7 +2439,8 @@ static int kswapd(void *p)
 	 * us from recursively trying to free more memory as we're
 	 * trying to free the first piece of memory in the first place).
 	 */
-	tsk->flags |= PF_MEMALLOC | PF_SWAPWRITE | PF_KSWAPD;
+	task_set_type(tsk, tt_kswapd);
+	tsk->flags |= PF_MEMALLOC | PF_SWAPWRITE;
 	set_freezable();
 
 	order = 0;
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

origin.patch
linux-next.patch
gcc-46-perf-fix-set-but-unused-variables-in-perf.patch
kernel-remove-pf_flusher.patch
kernel-extract-thread-types-from-task_struct-flags.patch

