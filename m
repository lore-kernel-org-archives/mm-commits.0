From: akpm@linux-foundation.org
Subject: + cgroups-read-write-lock-clone_thread-forking-per-threadgroup.patch added to -mm tree
Date: Tue, 12 Apr 2011 16:25:23 -0700
Message-ID: <201104122325.p3CNPOdU009132@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44554 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757048Ab1DLXZo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Apr 2011 19:25:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bblum@andrew.cmu.edu, ebiederm@xmission.com, lizf@cn.fujitsu.com, matthltc@us.ibm.com, menage@google.com, miaox@cn.fujitsu.com, oleg@redhat.com, rientjes@google.com


The patch titled
     cgroups: read-write lock CLONE_THREAD forking per threadgroup
has been added to the -mm tree.  Its filename is
     cgroups-read-write-lock-clone_thread-forking-per-threadgroup.patch

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
Subject: cgroups: read-write lock CLONE_THREAD forking per threadgroup
From: Ben Blum <bblum@andrew.cmu.edu>

Adds functionality to read/write lock CLONE_THREAD fork()ing per-threadgroup

Add an rwsem that lives in a threadgroup's signal_struct that's taken for
reading in the fork path, under CONFIG_CGROUPS.  If another part of the
kernel later wants to use such a locking mechanism, the CONFIG_CGROUPS
ifdefs should be changed to a higher-up flag that CGROUPS and the other
system would both depend on.

This is a pre-patch for cgroup-procs-write.patch.

Signed-off-by: Ben Blum <bblum@andrew.cmu.edu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Matt Helsley <matthltc@us.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Miao Xie <miaox@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/init_task.h |    9 +++++++++
 include/linux/sched.h     |   36 ++++++++++++++++++++++++++++++++++++
 kernel/fork.c             |   10 ++++++++++
 3 files changed, 55 insertions(+)

diff -puN include/linux/init_task.h~cgroups-read-write-lock-clone_thread-forking-per-threadgroup include/linux/init_task.h
--- a/include/linux/init_task.h~cgroups-read-write-lock-clone_thread-forking-per-threadgroup
+++ a/include/linux/init_task.h
@@ -22,6 +22,14 @@
 extern struct files_struct init_files;
 extern struct fs_struct init_fs;
 
+#ifdef CONFIG_CGROUPS
+#define INIT_THREADGROUP_FORK_LOCK(sig)					\
+	.threadgroup_fork_lock =					\
+		__RWSEM_INITIALIZER(sig.threadgroup_fork_lock),
+#else
+#define INIT_THREADGROUP_FORK_LOCK(sig)
+#endif
+
 #define INIT_SIGNALS(sig) {						\
 	.nr_threads	= 1,						\
 	.wait_chldexit	= __WAIT_QUEUE_HEAD_INITIALIZER(sig.wait_chldexit),\
@@ -38,6 +46,7 @@ extern struct fs_struct init_fs;
 	},								\
 	.cred_guard_mutex =						\
 		 __MUTEX_INITIALIZER(sig.cred_guard_mutex),		\
+	INIT_THREADGROUP_FORK_LOCK(sig)					\
 }
 
 extern struct nsproxy init_nsproxy;
diff -puN include/linux/sched.h~cgroups-read-write-lock-clone_thread-forking-per-threadgroup include/linux/sched.h
--- a/include/linux/sched.h~cgroups-read-write-lock-clone_thread-forking-per-threadgroup
+++ a/include/linux/sched.h
@@ -514,6 +514,7 @@ struct thread_group_cputimer {
 	spinlock_t lock;
 };
 
+#include <linux/rwsem.h>
 struct autogroup;
 
 /*
@@ -633,6 +634,16 @@ struct signal_struct {
 	unsigned audit_tty;
 	struct tty_audit_buf *tty_audit_buf;
 #endif
+#ifdef CONFIG_CGROUPS
+	/*
+	 * The threadgroup_fork_lock prevents threads from forking with
+	 * CLONE_THREAD while held for writing. Use this for fork-sensitive
+	 * threadgroup-wide operations. It's taken for reading in fork.c in
+	 * copy_process().
+	 * Currently only needed write-side by cgroups.
+	 */
+	struct rw_semaphore threadgroup_fork_lock;
+#endif
 
 	int oom_adj;		/* OOM kill score adjustment (bit shift) */
 	int oom_score_adj;	/* OOM kill score adjustment */
@@ -2305,6 +2316,31 @@ static inline void unlock_task_sighand(s
 	spin_unlock_irqrestore(&tsk->sighand->siglock, *flags);
 }
 
+/* See the declaration of threadgroup_fork_lock in signal_struct. */
+#ifdef CONFIG_CGROUPS
+static inline void threadgroup_fork_read_lock(struct task_struct *tsk)
+{
+	down_read(&tsk->signal->threadgroup_fork_lock);
+}
+static inline void threadgroup_fork_read_unlock(struct task_struct *tsk)
+{
+	up_read(&tsk->signal->threadgroup_fork_lock);
+}
+static inline void threadgroup_fork_write_lock(struct task_struct *tsk)
+{
+	down_write(&tsk->signal->threadgroup_fork_lock);
+}
+static inline void threadgroup_fork_write_unlock(struct task_struct *tsk)
+{
+	up_write(&tsk->signal->threadgroup_fork_lock);
+}
+#else
+static inline void threadgroup_fork_read_lock(struct task_struct *tsk) {}
+static inline void threadgroup_fork_read_unlock(struct task_struct *tsk) {}
+static inline void threadgroup_fork_write_lock(struct task_struct *tsk) {}
+static inline void threadgroup_fork_write_unlock(struct task_struct *tsk) {}
+#endif
+
 #ifndef __HAVE_THREAD_FUNCTIONS
 
 #define task_thread_info(task)	((struct thread_info *)(task)->stack)
diff -puN kernel/fork.c~cgroups-read-write-lock-clone_thread-forking-per-threadgroup kernel/fork.c
--- a/kernel/fork.c~cgroups-read-write-lock-clone_thread-forking-per-threadgroup
+++ a/kernel/fork.c
@@ -927,6 +927,10 @@ static int copy_signal(unsigned long clo
 	tty_audit_fork(sig);
 	sched_autogroup_fork(sig);
 
+#ifdef CONFIG_CGROUPS
+	init_rwsem(&sig->threadgroup_fork_lock);
+#endif
+
 	sig->oom_adj = current->signal->oom_adj;
 	sig->oom_score_adj = current->signal->oom_score_adj;
 	sig->oom_score_adj_min = current->signal->oom_score_adj_min;
@@ -1109,6 +1113,8 @@ static struct task_struct *copy_process(
 	monotonic_to_bootbased(&p->real_start_time);
 	p->io_context = NULL;
 	p->audit_context = NULL;
+	if (clone_flags & CLONE_THREAD)
+		threadgroup_fork_read_lock(current);
 	cgroup_fork(p);
 #ifdef CONFIG_NUMA
 	p->mempolicy = mpol_dup(p->mempolicy);
@@ -1313,6 +1319,8 @@ static struct task_struct *copy_process(
 	write_unlock_irq(&tasklist_lock);
 	proc_fork_connector(p);
 	cgroup_post_fork(p);
+	if (clone_flags & CLONE_THREAD)
+		threadgroup_fork_read_unlock(current);
 	perf_event_fork(p);
 	return p;
 
@@ -1351,6 +1359,8 @@ bad_fork_cleanup_policy:
 	mpol_put(p->mempolicy);
 bad_fork_cleanup_cgroup:
 #endif
+	if (clone_flags & CLONE_THREAD)
+		threadgroup_fork_read_unlock(current);
 	cgroup_exit(p, cgroup_callbacks_done);
 	delayacct_tsk_free(p);
 	module_put(task_thread_info(p)->exec_domain->module);
_

Patches currently in -mm which might be from bblum@andrew.cmu.edu are

cgroups-read-write-lock-clone_thread-forking-per-threadgroup.patch
cgroups-add-per-thread-subsystem-callbacks.patch
cgroups-make-procs-file-writable.patch
cgroups-use-flex_array-in-attach_proc.patch

