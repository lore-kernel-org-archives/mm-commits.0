From: akpm@linux-foundation.org
Subject: + kernel-remove-fastcall-in-kernel.patch added to -mm tree
Date: Thu, 20 Dec 2007 16:48:19 -0800
Message-ID: <200712210048.lBL0mKv9021815@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48277 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754795AbXLUAts (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Dec 2007 19:49:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, mingo@elte.hu


The patch titled
     kernel: remove fastcall in kernel/*
has been added to the -mm tree.  Its filename is
     kernel-remove-fastcall-in-kernel.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kernel: remove fastcall in kernel/*
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c        |    4 ++--
 kernel/fork.c        |    2 +-
 kernel/irq/chip.c    |   10 +++++-----
 kernel/irq/handle.c  |    4 ++--
 kernel/mutex-debug.c |    2 +-
 kernel/mutex.c       |   28 ++++++++++++++--------------
 kernel/pid.c         |   18 +++++++++---------
 kernel/sched.c       |   16 ++++++++--------
 kernel/softirq.c     |    8 ++++----
 kernel/timer.c       |    6 +++---
 kernel/wait.c        |   26 +++++++++++++-------------
 kernel/workqueue.c   |   10 +++++-----
 12 files changed, 67 insertions(+), 67 deletions(-)

diff -puN kernel/exit.c~kernel-remove-fastcall-in-kernel kernel/exit.c
--- a/kernel/exit.c~kernel-remove-fastcall-in-kernel
+++ a/kernel/exit.c
@@ -458,7 +458,7 @@ struct files_struct *get_files_struct(st
 	return files;
 }
 
-void fastcall put_files_struct(struct files_struct *files)
+void put_files_struct(struct files_struct *files)
 {
 	struct fdtable *fdt;
 
@@ -905,7 +905,7 @@ static inline void exit_child_reaper(str
 	zap_pid_ns_processes(tsk->nsproxy->pid_ns);
 }
 
-fastcall NORET_TYPE void do_exit(long code)
+NORET_TYPE void do_exit(long code)
 {
 	struct task_struct *tsk = current;
 	int group_dead;
diff -puN kernel/fork.c~kernel-remove-fastcall-in-kernel kernel/fork.c
--- a/kernel/fork.c~kernel-remove-fastcall-in-kernel
+++ a/kernel/fork.c
@@ -385,7 +385,7 @@ struct mm_struct * mm_alloc(void)
  * is dropped: either by a lazy thread or by
  * mmput. Free the page directory and the mm.
  */
-void fastcall __mmdrop(struct mm_struct *mm)
+void __mmdrop(struct mm_struct *mm)
 {
 	BUG_ON(mm == &init_mm);
 	mm_free_pgd(mm);
diff -puN kernel/irq/chip.c~kernel-remove-fastcall-in-kernel kernel/irq/chip.c
--- a/kernel/irq/chip.c~kernel-remove-fastcall-in-kernel
+++ a/kernel/irq/chip.c
@@ -286,7 +286,7 @@ static inline void mask_ack_irq(struct i
  *	Note: The caller is expected to handle the ack, clear, mask and
  *	unmask issues if necessary.
  */
-void fastcall
+void
 handle_simple_irq(unsigned int irq, struct irq_desc *desc)
 {
 	struct irqaction *action;
@@ -327,7 +327,7 @@ out_unlock:
  *	it after the associated handler has acknowledged the device, so the
  *	interrupt line is back to inactive.
  */
-void fastcall
+void
 handle_level_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int cpu = smp_processor_id();
@@ -375,7 +375,7 @@ out_unlock:
  *	for modern forms of interrupt handlers, which handle the flow
  *	details in hardware, transparently.
  */
-void fastcall
+void
 handle_fasteoi_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int cpu = smp_processor_id();
@@ -434,7 +434,7 @@ out:
  *	the handler was running. If all pending interrupts are handled, the
  *	loop is left.
  */
-void fastcall
+void
 handle_edge_irq(unsigned int irq, struct irq_desc *desc)
 {
 	const unsigned int cpu = smp_processor_id();
@@ -505,7 +505,7 @@ out_unlock:
  *
  *	Per CPU interrupts on SMP machines without locking requirements
  */
-void fastcall
+void
 handle_percpu_irq(unsigned int irq, struct irq_desc *desc)
 {
 	irqreturn_t action_ret;
diff -puN kernel/irq/handle.c~kernel-remove-fastcall-in-kernel kernel/irq/handle.c
--- a/kernel/irq/handle.c~kernel-remove-fastcall-in-kernel
+++ a/kernel/irq/handle.c
@@ -25,7 +25,7 @@
  *
  * Handles spurious and unhandled IRQ's. It also prints a debugmessage.
  */
-void fastcall
+void
 handle_bad_irq(unsigned int irq, struct irq_desc *desc)
 {
 	print_irq_desc(irq, desc);
@@ -163,7 +163,7 @@ irqreturn_t handle_IRQ_event(unsigned in
  * This is the original x86 implementation which is used for every
  * interrupt type.
  */
-fastcall unsigned int __do_IRQ(unsigned int irq)
+unsigned int __do_IRQ(unsigned int irq)
 {
 	struct irq_desc *desc = irq_desc + irq;
 	struct irqaction *action;
diff -puN kernel/mutex-debug.c~kernel-remove-fastcall-in-kernel kernel/mutex-debug.c
--- a/kernel/mutex-debug.c~kernel-remove-fastcall-in-kernel
+++ a/kernel/mutex-debug.c
@@ -107,7 +107,7 @@ void debug_mutex_init(struct mutex *lock
  * use of the mutex is forbidden. The mutex must not be locked when
  * this function is called.
  */
-void fastcall mutex_destroy(struct mutex *lock)
+void mutex_destroy(struct mutex *lock)
 {
 	DEBUG_LOCKS_WARN_ON(mutex_is_locked(lock));
 	lock->magic = NULL;
diff -puN kernel/mutex.c~kernel-remove-fastcall-in-kernel kernel/mutex.c
--- a/kernel/mutex.c~kernel-remove-fastcall-in-kernel
+++ a/kernel/mutex.c
@@ -58,7 +58,7 @@ EXPORT_SYMBOL(__mutex_init);
  * We also put the fastpath first in the kernel image, to make sure the
  * branch is predicted by the CPU as default-untaken.
  */
-static void fastcall noinline __sched
+static void noinline __sched
 __mutex_lock_slowpath(atomic_t *lock_count);
 
 /***
@@ -82,7 +82,7 @@ __mutex_lock_slowpath(atomic_t *lock_cou
  *
  * This function is similar to (but not equivalent to) down().
  */
-void inline fastcall __sched mutex_lock(struct mutex *lock)
+void inline __sched mutex_lock(struct mutex *lock)
 {
 	might_sleep();
 	/*
@@ -95,7 +95,7 @@ void inline fastcall __sched mutex_lock(
 EXPORT_SYMBOL(mutex_lock);
 #endif
 
-static void fastcall noinline __sched
+static void noinline __sched
 __mutex_unlock_slowpath(atomic_t *lock_count);
 
 /***
@@ -109,7 +109,7 @@ __mutex_unlock_slowpath(atomic_t *lock_c
  *
  * This function is similar to (but not equivalent to) up().
  */
-void fastcall __sched mutex_unlock(struct mutex *lock)
+void __sched mutex_unlock(struct mutex *lock)
 {
 	/*
 	 * The unlocking fastpath is the 0->1 transition from 'locked'
@@ -234,7 +234,7 @@ EXPORT_SYMBOL_GPL(mutex_lock_interruptib
 /*
  * Release the lock, slowpath:
  */
-static fastcall inline void
+static inline void
 __mutex_unlock_common_slowpath(atomic_t *lock_count, int nested)
 {
 	struct mutex *lock = container_of(lock_count, struct mutex, count);
@@ -271,7 +271,7 @@ __mutex_unlock_common_slowpath(atomic_t 
 /*
  * Release the lock, slowpath:
  */
-static fastcall noinline void
+static noinline void
 __mutex_unlock_slowpath(atomic_t *lock_count)
 {
 	__mutex_unlock_common_slowpath(lock_count, 1);
@@ -282,10 +282,10 @@ __mutex_unlock_slowpath(atomic_t *lock_c
  * Here come the less common (and hence less performance-critical) APIs:
  * mutex_lock_interruptible() and mutex_trylock().
  */
-static int fastcall noinline __sched
+static int noinline __sched
 __mutex_lock_killable_slowpath(atomic_t *lock_count);
 
-static noinline int fastcall __sched
+static noinline int __sched
 __mutex_lock_interruptible_slowpath(atomic_t *lock_count);
 
 /***
@@ -299,7 +299,7 @@ __mutex_lock_interruptible_slowpath(atom
  *
  * This function is similar to (but not equivalent to) down_interruptible().
  */
-int fastcall __sched mutex_lock_interruptible(struct mutex *lock)
+int __sched mutex_lock_interruptible(struct mutex *lock)
 {
 	might_sleep();
 	return __mutex_fastpath_lock_retval
@@ -308,7 +308,7 @@ int fastcall __sched mutex_lock_interrup
 
 EXPORT_SYMBOL(mutex_lock_interruptible);
 
-int fastcall __sched mutex_lock_killable(struct mutex *lock)
+int __sched mutex_lock_killable(struct mutex *lock)
 {
 	might_sleep();
 	return __mutex_fastpath_lock_retval
@@ -316,7 +316,7 @@ int fastcall __sched mutex_lock_killable
 }
 EXPORT_SYMBOL(mutex_lock_killable);
 
-static void fastcall noinline __sched
+static void noinline __sched
 __mutex_lock_slowpath(atomic_t *lock_count)
 {
 	struct mutex *lock = container_of(lock_count, struct mutex, count);
@@ -324,7 +324,7 @@ __mutex_lock_slowpath(atomic_t *lock_cou
 	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE, 0, _RET_IP_);
 }
 
-static int fastcall noinline __sched
+static int noinline __sched
 __mutex_lock_killable_slowpath(atomic_t *lock_count)
 {
 	struct mutex *lock = container_of(lock_count, struct mutex, count);
@@ -332,7 +332,7 @@ __mutex_lock_killable_slowpath(atomic_t 
 	return __mutex_lock_common(lock, TASK_KILLABLE, 0, _RET_IP_);
 }
 
-static noinline int fastcall __sched
+static noinline int __sched
 __mutex_lock_interruptible_slowpath(atomic_t *lock_count)
 {
 	struct mutex *lock = container_of(lock_count, struct mutex, count);
@@ -381,7 +381,7 @@ static inline int __mutex_trylock_slowpa
  * This function must not be used in interrupt context. The
  * mutex must be released by the same task that acquired it.
  */
-int fastcall __sched mutex_trylock(struct mutex *lock)
+int __sched mutex_trylock(struct mutex *lock)
 {
 	return __mutex_fastpath_trylock(&lock->count,
 					__mutex_trylock_slowpath);
diff -puN kernel/pid.c~kernel-remove-fastcall-in-kernel kernel/pid.c
--- a/kernel/pid.c~kernel-remove-fastcall-in-kernel
+++ a/kernel/pid.c
@@ -112,7 +112,7 @@ EXPORT_SYMBOL(is_container_init);
 
 static  __cacheline_aligned_in_smp DEFINE_SPINLOCK(pidmap_lock);
 
-static fastcall void free_pidmap(struct pid_namespace *pid_ns, int pid)
+static void free_pidmap(struct pid_namespace *pid_ns, int pid)
 {
 	struct pidmap *map = pid_ns->pidmap + pid / BITS_PER_PAGE;
 	int offset = pid & BITS_PER_PAGE_MASK;
@@ -199,7 +199,7 @@ static int next_pidmap(struct pid_namesp
 	return -1;
 }
 
-fastcall void put_pid(struct pid *pid)
+void put_pid(struct pid *pid)
 {
 	struct pid_namespace *ns;
 
@@ -221,7 +221,7 @@ static void delayed_put_pid(struct rcu_h
 	put_pid(pid);
 }
 
-fastcall void free_pid(struct pid *pid)
+void free_pid(struct pid *pid)
 {
 	/* We can be called with write_lock_irq(&tasklist_lock) held */
 	int i;
@@ -287,7 +287,7 @@ out_free:
 	goto out;
 }
 
-struct pid * fastcall find_pid_ns(int nr, struct pid_namespace *ns)
+struct pid * find_pid_ns(int nr, struct pid_namespace *ns)
 {
 	struct hlist_node *elem;
 	struct upid *pnr;
@@ -317,7 +317,7 @@ EXPORT_SYMBOL_GPL(find_pid);
 /*
  * attach_pid() must be called with the tasklist_lock write-held.
  */
-int fastcall attach_pid(struct task_struct *task, enum pid_type type,
+int attach_pid(struct task_struct *task, enum pid_type type,
 		struct pid *pid)
 {
 	struct pid_link *link;
@@ -329,7 +329,7 @@ int fastcall attach_pid(struct task_stru
 	return 0;
 }
 
-void fastcall detach_pid(struct task_struct *task, enum pid_type type)
+void detach_pid(struct task_struct *task, enum pid_type type)
 {
 	struct pid_link *link;
 	struct pid *pid;
@@ -349,7 +349,7 @@ void fastcall detach_pid(struct task_str
 }
 
 /* transfer_pid is an optimization of attach_pid(new), detach_pid(old) */
-void fastcall transfer_pid(struct task_struct *old, struct task_struct *new,
+void transfer_pid(struct task_struct *old, struct task_struct *new,
 			   enum pid_type type)
 {
 	new->pids[type].pid = old->pids[type].pid;
@@ -357,7 +357,7 @@ void fastcall transfer_pid(struct task_s
 	old->pids[type].pid = NULL;
 }
 
-struct task_struct * fastcall pid_task(struct pid *pid, enum pid_type type)
+struct task_struct * pid_task(struct pid *pid, enum pid_type type)
 {
 	struct task_struct *result = NULL;
 	if (pid) {
@@ -408,7 +408,7 @@ struct pid *get_task_pid(struct task_str
 	return pid;
 }
 
-struct task_struct *fastcall get_pid_task(struct pid *pid, enum pid_type type)
+struct task_struct *get_pid_task(struct pid *pid, enum pid_type type)
 {
 	struct task_struct *result;
 	rcu_read_lock();
diff -puN kernel/rcupdate.c~kernel-remove-fastcall-in-kernel kernel/rcupdate.c
diff -puN kernel/sched.c~kernel-remove-fastcall-in-kernel kernel/sched.c
--- a/kernel/sched.c~kernel-remove-fastcall-in-kernel
+++ a/kernel/sched.c
@@ -1650,13 +1650,13 @@ out:
 	return success;
 }
 
-int fastcall wake_up_process(struct task_struct *p)
+int wake_up_process(struct task_struct *p)
 {
 	return try_to_wake_up(p, TASK_ALL, 0);
 }
 EXPORT_SYMBOL(wake_up_process);
 
-int fastcall wake_up_state(struct task_struct *p, unsigned int state)
+int wake_up_state(struct task_struct *p, unsigned int state)
 {
 	return try_to_wake_up(p, state, 0);
 }
@@ -1743,7 +1743,7 @@ void sched_fork(struct task_struct *p, i
  * that must be done for every newly created context, then puts the task
  * on the runqueue and wakes it.
  */
-void fastcall wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
+void wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
 {
 	unsigned long flags;
 	struct rq *rq;
@@ -3508,7 +3508,7 @@ void scheduler_tick(void)
 
 #if defined(CONFIG_PREEMPT) && defined(CONFIG_DEBUG_PREEMPT)
 
-void fastcall add_preempt_count(int val)
+void add_preempt_count(int val)
 {
 	/*
 	 * Underflow?
@@ -3524,7 +3524,7 @@ void fastcall add_preempt_count(int val)
 }
 EXPORT_SYMBOL(add_preempt_count);
 
-void fastcall sub_preempt_count(int val)
+void sub_preempt_count(int val)
 {
 	/*
 	 * Underflow?
@@ -3824,7 +3824,7 @@ static void __wake_up_common(wait_queue_
  * @nr_exclusive: how many wake-one or wake-many threads to wake up
  * @key: is directly passed to the wakeup function
  */
-void fastcall __wake_up(wait_queue_head_t *q, unsigned int mode,
+void __wake_up(wait_queue_head_t *q, unsigned int mode,
 			int nr_exclusive, void *key)
 {
 	unsigned long flags;
@@ -3838,7 +3838,7 @@ EXPORT_SYMBOL(__wake_up);
 /*
  * Same as __wake_up but called with the spinlock in wait_queue_head_t held.
  */
-void fastcall __wake_up_locked(wait_queue_head_t *q, unsigned int mode)
+void __wake_up_locked(wait_queue_head_t *q, unsigned int mode)
 {
 	__wake_up_common(q, mode, 1, 0, NULL);
 }
@@ -3856,7 +3856,7 @@ void fastcall __wake_up_locked(wait_queu
  *
  * On UP it can prevent extra preemption.
  */
-void fastcall
+void
 __wake_up_sync(wait_queue_head_t *q, unsigned int mode, int nr_exclusive)
 {
 	unsigned long flags;
diff -puN kernel/softirq.c~kernel-remove-fastcall-in-kernel kernel/softirq.c
--- a/kernel/softirq.c~kernel-remove-fastcall-in-kernel
+++ a/kernel/softirq.c
@@ -320,7 +320,7 @@ void irq_exit(void)
 /*
  * This function must run with irqs disabled!
  */
-inline fastcall void raise_softirq_irqoff(unsigned int nr)
+inline void raise_softirq_irqoff(unsigned int nr)
 {
 	__raise_softirq_irqoff(nr);
 
@@ -337,7 +337,7 @@ inline fastcall void raise_softirq_irqof
 		wakeup_softirqd();
 }
 
-void fastcall raise_softirq(unsigned int nr)
+void raise_softirq(unsigned int nr)
 {
 	unsigned long flags;
 
@@ -363,7 +363,7 @@ struct tasklet_head
 static DEFINE_PER_CPU(struct tasklet_head, tasklet_vec) = { NULL };
 static DEFINE_PER_CPU(struct tasklet_head, tasklet_hi_vec) = { NULL };
 
-void fastcall __tasklet_schedule(struct tasklet_struct *t)
+void __tasklet_schedule(struct tasklet_struct *t)
 {
 	unsigned long flags;
 
@@ -376,7 +376,7 @@ void fastcall __tasklet_schedule(struct 
 
 EXPORT_SYMBOL(__tasklet_schedule);
 
-void fastcall __tasklet_hi_schedule(struct tasklet_struct *t)
+void __tasklet_hi_schedule(struct tasklet_struct *t)
 {
 	unsigned long flags;
 
diff -puN kernel/timer.c~kernel-remove-fastcall-in-kernel kernel/timer.c
--- a/kernel/timer.c~kernel-remove-fastcall-in-kernel
+++ a/kernel/timer.c
@@ -327,7 +327,7 @@ static void timer_stats_account_timer(st
  * init_timer() must be done to a timer prior calling *any* of the
  * other timer functions.
  */
-void fastcall init_timer(struct timer_list *timer)
+void init_timer(struct timer_list *timer)
 {
 	timer->entry.next = NULL;
 	timer->base = __raw_get_cpu_var(tvec_bases);
@@ -339,7 +339,7 @@ void fastcall init_timer(struct timer_li
 }
 EXPORT_SYMBOL(init_timer);
 
-void fastcall init_timer_deferrable(struct timer_list *timer)
+void init_timer_deferrable(struct timer_list *timer)
 {
 	init_timer(timer);
 	timer_set_deferrable(timer);
@@ -1041,7 +1041,7 @@ static void process_timeout(unsigned lon
  *
  * In all cases the return value is guaranteed to be non-negative.
  */
-fastcall signed long __sched schedule_timeout(signed long timeout)
+signed long __sched schedule_timeout(signed long timeout)
 {
 	struct timer_list timer;
 	unsigned long expire;
diff -puN kernel/wait.c~kernel-remove-fastcall-in-kernel kernel/wait.c
--- a/kernel/wait.c~kernel-remove-fastcall-in-kernel
+++ a/kernel/wait.c
@@ -18,7 +18,7 @@ void init_waitqueue_head(wait_queue_head
 
 EXPORT_SYMBOL(init_waitqueue_head);
 
-void fastcall add_wait_queue(wait_queue_head_t *q, wait_queue_t *wait)
+void add_wait_queue(wait_queue_head_t *q, wait_queue_t *wait)
 {
 	unsigned long flags;
 
@@ -29,7 +29,7 @@ void fastcall add_wait_queue(wait_queue_
 }
 EXPORT_SYMBOL(add_wait_queue);
 
-void fastcall add_wait_queue_exclusive(wait_queue_head_t *q, wait_queue_t *wait)
+void add_wait_queue_exclusive(wait_queue_head_t *q, wait_queue_t *wait)
 {
 	unsigned long flags;
 
@@ -40,7 +40,7 @@ void fastcall add_wait_queue_exclusive(w
 }
 EXPORT_SYMBOL(add_wait_queue_exclusive);
 
-void fastcall remove_wait_queue(wait_queue_head_t *q, wait_queue_t *wait)
+void remove_wait_queue(wait_queue_head_t *q, wait_queue_t *wait)
 {
 	unsigned long flags;
 
@@ -63,7 +63,7 @@ EXPORT_SYMBOL(remove_wait_queue);
  * stops them from bleeding out - it would still allow subsequent
  * loads to move into the critical region).
  */
-void fastcall
+void
 prepare_to_wait(wait_queue_head_t *q, wait_queue_t *wait, int state)
 {
 	unsigned long flags;
@@ -82,7 +82,7 @@ prepare_to_wait(wait_queue_head_t *q, wa
 }
 EXPORT_SYMBOL(prepare_to_wait);
 
-void fastcall
+void
 prepare_to_wait_exclusive(wait_queue_head_t *q, wait_queue_t *wait, int state)
 {
 	unsigned long flags;
@@ -101,7 +101,7 @@ prepare_to_wait_exclusive(wait_queue_hea
 }
 EXPORT_SYMBOL(prepare_to_wait_exclusive);
 
-void fastcall finish_wait(wait_queue_head_t *q, wait_queue_t *wait)
+void finish_wait(wait_queue_head_t *q, wait_queue_t *wait)
 {
 	unsigned long flags;
 
@@ -157,7 +157,7 @@ EXPORT_SYMBOL(wake_bit_function);
  * waiting, the actions of __wait_on_bit() and __wait_on_bit_lock() are
  * permitted return codes. Nonzero return codes halt waiting and return.
  */
-int __sched fastcall
+int __sched
 __wait_on_bit(wait_queue_head_t *wq, struct wait_bit_queue *q,
 			int (*action)(void *), unsigned mode)
 {
@@ -173,7 +173,7 @@ __wait_on_bit(wait_queue_head_t *wq, str
 }
 EXPORT_SYMBOL(__wait_on_bit);
 
-int __sched fastcall out_of_line_wait_on_bit(void *word, int bit,
+int __sched out_of_line_wait_on_bit(void *word, int bit,
 					int (*action)(void *), unsigned mode)
 {
 	wait_queue_head_t *wq = bit_waitqueue(word, bit);
@@ -183,7 +183,7 @@ int __sched fastcall out_of_line_wait_on
 }
 EXPORT_SYMBOL(out_of_line_wait_on_bit);
 
-int __sched fastcall
+int __sched
 __wait_on_bit_lock(wait_queue_head_t *wq, struct wait_bit_queue *q,
 			int (*action)(void *), unsigned mode)
 {
@@ -201,7 +201,7 @@ __wait_on_bit_lock(wait_queue_head_t *wq
 }
 EXPORT_SYMBOL(__wait_on_bit_lock);
 
-int __sched fastcall out_of_line_wait_on_bit_lock(void *word, int bit,
+int __sched out_of_line_wait_on_bit_lock(void *word, int bit,
 					int (*action)(void *), unsigned mode)
 {
 	wait_queue_head_t *wq = bit_waitqueue(word, bit);
@@ -211,7 +211,7 @@ int __sched fastcall out_of_line_wait_on
 }
 EXPORT_SYMBOL(out_of_line_wait_on_bit_lock);
 
-void fastcall __wake_up_bit(wait_queue_head_t *wq, void *word, int bit)
+void __wake_up_bit(wait_queue_head_t *wq, void *word, int bit)
 {
 	struct wait_bit_key key = __WAIT_BIT_KEY_INITIALIZER(word, bit);
 	if (waitqueue_active(wq))
@@ -236,13 +236,13 @@ EXPORT_SYMBOL(__wake_up_bit);
  * may need to use a less regular barrier, such fs/inode.c's smp_mb(),
  * because spin_unlock() does not guarantee a memory barrier.
  */
-void fastcall wake_up_bit(void *word, int bit)
+void wake_up_bit(void *word, int bit)
 {
 	__wake_up_bit(bit_waitqueue(word, bit), word, bit);
 }
 EXPORT_SYMBOL(wake_up_bit);
 
-fastcall wait_queue_head_t *bit_waitqueue(void *word, int bit)
+wait_queue_head_t *bit_waitqueue(void *word, int bit)
 {
 	const int shift = BITS_PER_LONG == 32 ? 5 : 6;
 	const struct zone *zone = page_zone(virt_to_page(word));
diff -puN kernel/workqueue.c~kernel-remove-fastcall-in-kernel kernel/workqueue.c
--- a/kernel/workqueue.c~kernel-remove-fastcall-in-kernel
+++ a/kernel/workqueue.c
@@ -161,7 +161,7 @@ static void __queue_work(struct cpu_work
  * We queue the work to the CPU it was submitted, but there is no
  * guarantee that it will be processed by that CPU.
  */
-int fastcall queue_work(struct workqueue_struct *wq, struct work_struct *work)
+int queue_work(struct workqueue_struct *wq, struct work_struct *work)
 {
 	int ret = 0;
 
@@ -192,7 +192,7 @@ void delayed_work_timer_fn(unsigned long
  *
  * Returns 0 if @work was already on a queue, non-zero otherwise.
  */
-int fastcall queue_delayed_work(struct workqueue_struct *wq,
+int queue_delayed_work(struct workqueue_struct *wq,
 			struct delayed_work *dwork, unsigned long delay)
 {
 	timer_stats_timer_set_start_info(&dwork->timer);
@@ -388,7 +388,7 @@ static int flush_cpu_workqueue(struct cp
  * This function used to run the workqueues itself.  Now we just wait for the
  * helper threads to do it.
  */
-void fastcall flush_workqueue(struct workqueue_struct *wq)
+void flush_workqueue(struct workqueue_struct *wq)
 {
 	const cpumask_t *cpu_map = wq_cpu_map(wq);
 	int cpu;
@@ -546,7 +546,7 @@ static struct workqueue_struct *keventd_
  *
  * This puts a job in the kernel-global workqueue.
  */
-int fastcall schedule_work(struct work_struct *work)
+int schedule_work(struct work_struct *work)
 {
 	return queue_work(keventd_wq, work);
 }
@@ -560,7 +560,7 @@ EXPORT_SYMBOL(schedule_work);
  * After waiting for a given time this puts a job in the kernel-global
  * workqueue.
  */
-int fastcall schedule_delayed_work(struct delayed_work *dwork,
+int schedule_delayed_work(struct delayed_work *dwork,
 					unsigned long delay)
 {
 	timer_stats_timer_set_start_info(&dwork->timer);
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

git-net.patch
git-sh.patch
git-x86.patch
mm-remove-fastcall-from-mm.patch
mm-remove-fastcall-from-mm-checkpatch-fixes.patch
fs-remove-fastcall-it-is-always-empty.patch
fs-remove-fastcall-it-is-always-empty-checkpatch-fixes.patch
kernel-remove-fastcall-in-kernel.patch
