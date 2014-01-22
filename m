From: akpm@linux-foundation.org
Subject: [merged]
 introduce-for_each_thread-to-replace-the-buggy-while_each_thread.patch
 removed from -mm tree
Date: Wed, 22 Jan 2014 12:13:36 -0800
Message-ID: <52e02670.8qdVUo6IWP3wXGtO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54615 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756093AbaAVUNh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jan 2014 15:13:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xindong.ma@intel.com, xiaobing.tu@intel.com, snanda@chromium.org, rientjes@google.com, msb@chromium.org, mhocko@suse.cz, fweisbec@gmail.com, ebiederm@xmission.com, dserrg@gmail.com, oleg@redhat.com

Subject: [merged] introduce-for_each_thread-to-replace-the-buggy-while_each_thread.patch removed from -mm tree
To: oleg@redhat.com,dserrg@gmail.com,ebiederm@xmission.com,fweisbec@gmail.com,mhocko@suse.cz,msb@chromium.org,rientjes@google.com,snanda@chromium.org,xiaobing.tu@intel.com,xindong.ma@intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 Jan 2014 12:13:36 -0800


The patch titled
     Subject: introduce for_each_thread() to replace the buggy while_each_thread()
has been removed from the -mm tree.  Its filename was
     introduce-for_each_thread-to-replace-the-buggy-while_each_thread.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: introduce for_each_thread() to replace the buggy while_each_thread()

while_each_thread() and next_thread() should die, almost every lockless
usage is wrong.

1. Unless g == current, the lockless while_each_thread() is not safe.

   while_each_thread(g, t) can loop forever if g exits, next_thread()
   can't reach the unhashed thread in this case. Note that this can
   happen even if g is the group leader, it can exec.

2. Even if while_each_thread() itself was correct, people often use
   it wrongly.

   It was never safe to just take rcu_read_lock() and loop unless
   you verify that pid_alive(g) == T, even the first next_thread()
   can point to the already freed/reused memory.

This patch adds signal_struct->thread_head and task->thread_node to create
the normal rcu-safe list with the stable head.  The new for_each_thread(g,
t) helper is always safe under rcu_read_lock() as long as this task_struct
can't go away.

Note: of course it is ugly to have both task_struct->thread_node and the
old task_struct->thread_group, we will kill it later, after we change the
users of while_each_thread() to use for_each_thread().

Perhaps we can kill it even before we convert all users, we can
reimplement next_thread(t) using the new thread_head/thread_node.  But we
can't do this right now because this will lead to subtle behavioural
changes.  For example, do/while_each_thread() always sees at least one
task, while for_each_thread() can do nothing if the whole thread group has
died.  Or thread_group_empty(), currently its semantics is not clear
unless thread_group_leader(p) and we need to audit the callers before we
can change it.

So this patch adds the new interface which has to coexist with the old one
for some time, hopefully the next changes will be more or less
straightforward and the old one will go away soon.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Sergey Dyasly <dserrg@gmail.com>
Tested-by: Sergey Dyasly <dserrg@gmail.com>
Reviewed-by: Sameer Nanda <snanda@chromium.org>
Acked-by: David Rientjes <rientjes@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mandeep Singh Baines <msb@chromium.org>
Cc: "Ma, Xindong" <xindong.ma@intel.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: "Tu, Xiaobing" <xiaobing.tu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/init_task.h |    2 ++
 include/linux/sched.h     |   12 ++++++++++++
 kernel/exit.c             |    1 +
 kernel/fork.c             |    7 +++++++
 4 files changed, 22 insertions(+)

diff -puN include/linux/init_task.h~introduce-for_each_thread-to-replace-the-buggy-while_each_thread include/linux/init_task.h
--- a/include/linux/init_task.h~introduce-for_each_thread-to-replace-the-buggy-while_each_thread
+++ a/include/linux/init_task.h
@@ -41,6 +41,7 @@ extern struct fs_struct init_fs;
 
 #define INIT_SIGNALS(sig) {						\
 	.nr_threads	= 1,						\
+	.thread_head	= LIST_HEAD_INIT(init_task.thread_node),	\
 	.wait_chldexit	= __WAIT_QUEUE_HEAD_INITIALIZER(sig.wait_chldexit),\
 	.shared_pending	= { 						\
 		.list = LIST_HEAD_INIT(sig.shared_pending.list),	\
@@ -222,6 +223,7 @@ extern struct task_group root_task_group
 		[PIDTYPE_SID]  = INIT_PID_LINK(PIDTYPE_SID),		\
 	},								\
 	.thread_group	= LIST_HEAD_INIT(tsk.thread_group),		\
+	.thread_node	= LIST_HEAD_INIT(init_signals.thread_head),	\
 	INIT_IDS							\
 	INIT_PERF_EVENTS(tsk)						\
 	INIT_TRACE_IRQFLAGS						\
diff -puN include/linux/sched.h~introduce-for_each_thread-to-replace-the-buggy-while_each_thread include/linux/sched.h
--- a/include/linux/sched.h~introduce-for_each_thread-to-replace-the-buggy-while_each_thread
+++ a/include/linux/sched.h
@@ -549,6 +549,7 @@ struct signal_struct {
 	atomic_t		sigcnt;
 	atomic_t		live;
 	int			nr_threads;
+	struct list_head	thread_head;
 
 	wait_queue_head_t	wait_chldexit;	/* for wait4() */
 
@@ -1271,6 +1272,7 @@ struct task_struct {
 	/* PID/PID hash table linkage. */
 	struct pid_link pids[PIDTYPE_MAX];
 	struct list_head thread_group;
+	struct list_head thread_node;
 
 	struct completion *vfork_done;		/* for vfork() */
 	int __user *set_child_tid;		/* CLONE_CHILD_SETTID */
@@ -2341,6 +2343,16 @@ extern bool current_is_single_threaded(v
 #define while_each_thread(g, t) \
 	while ((t = next_thread(t)) != g)
 
+#define __for_each_thread(signal, t)	\
+	list_for_each_entry_rcu(t, &(signal)->thread_head, thread_node)
+
+#define for_each_thread(p, t)		\
+	__for_each_thread((p)->signal, t)
+
+/* Careful: this is a double loop, 'break' won't work as expected. */
+#define for_each_process_thread(p, t)	\
+	for_each_process(p) for_each_thread(p, t)
+
 static inline int get_nr_threads(struct task_struct *tsk)
 {
 	return tsk->signal->nr_threads;
diff -puN kernel/exit.c~introduce-for_each_thread-to-replace-the-buggy-while_each_thread kernel/exit.c
--- a/kernel/exit.c~introduce-for_each_thread-to-replace-the-buggy-while_each_thread
+++ a/kernel/exit.c
@@ -74,6 +74,7 @@ static void __unhash_process(struct task
 		__this_cpu_dec(process_counts);
 	}
 	list_del_rcu(&p->thread_group);
+	list_del_rcu(&p->thread_node);
 }
 
 /*
diff -puN kernel/fork.c~introduce-for_each_thread-to-replace-the-buggy-while_each_thread kernel/fork.c
--- a/kernel/fork.c~introduce-for_each_thread-to-replace-the-buggy-while_each_thread
+++ a/kernel/fork.c
@@ -1035,6 +1035,11 @@ static int copy_signal(unsigned long clo
 	sig->nr_threads = 1;
 	atomic_set(&sig->live, 1);
 	atomic_set(&sig->sigcnt, 1);
+
+	/* list_add(thread_node, thread_head) without INIT_LIST_HEAD() */
+	sig->thread_head = (struct list_head)LIST_HEAD_INIT(tsk->thread_node);
+	tsk->thread_node = (struct list_head)LIST_HEAD_INIT(sig->thread_head);
+
 	init_waitqueue_head(&sig->wait_chldexit);
 	sig->curr_target = tsk;
 	init_sigpending(&sig->shared_pending);
@@ -1474,6 +1479,8 @@ static struct task_struct *copy_process(
 			atomic_inc(&current->signal->sigcnt);
 			list_add_tail_rcu(&p->thread_group,
 					  &p->group_leader->thread_group);
+			list_add_tail_rcu(&p->thread_node,
+					  &p->signal->thread_head);
 		}
 		attach_pid(p, PIDTYPE_PID);
 		nr_threads++;
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
mm-fix-the-theoretical-compound_lock-vs-prep_new_page-race.patch
autofs4-allow-autofs-to-work-outside-the-initial-pid-namespace.patch
autofs4-translate-pids-to-the-right-namespace-for-the-daemon.patch
coredump-set_dumpable-fix-the-theoretical-race-with-itself.patch
coredump-kill-mmf_dumpable-and-mmf_dump_securely.patch
coredump-make-__get_dumpable-get_dumpable-inline-kill-fs-coredumph.patch
proc-cleanup-simplify-get_task_state-task_state_array.patch
proc-fix-the-potential-use-after-free-in-first_tid.patch
proc-change-first_tid-to-use-while_each_thread-rather-than-next_thread.patch
proc-dont-abuse-group_leader-in-proc_task_readdir-paths.patch
proc-fix-f_pos-overflows-in-first_tid.patch
kernel-forkc-remove-redundant-null-check-in-dup_mm.patch
exec-check_unsafe_exec-use-while_each_thread-rather-than-next_thread.patch
exec-check_unsafe_exec-kill-the-dead-eagain-and-clear_in_exec-logic.patch
exec-move-the-final-allow_write_access-fput-into-free_bprm.patch
exec-kill-task_struct-did_exec.patch
fs-proc-arrayc-change-do_task_stat-to-use-while_each_thread.patch
kernel-sysc-k_getrusage-can-use-while_each_thread.patch
kernel-signalc-change-do_signal_stop-do_sigaction-to-use-while_each_thread.patch
exec-avoid-propagating-pf_no_setaffinity-into-userspace-child.patch
linux-next.patch

