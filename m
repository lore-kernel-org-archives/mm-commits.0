From: akpm@linux-foundation.org
Subject: [merged] kthread-numa-aware-kthread_create_on_cpu.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:33:45 -0700
Message-ID: <201103232037.p2NKbL9p028231__3799.28123807094$1300913847$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54002 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933540Ab1CWU5O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:57:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eric.dumazet@gmail.com, ak@linux.intel.com, davem@davemloft.net, dhowells@redhat.com, fenghua.yu@intel.com, linux-arch@vger.kernel.org, rusty@rustcorp.com.au, tj@kernel.org, tony.luck


The patch titled
     kthread: NUMA aware kthread_create_on_node()
has been removed from the -mm tree.  Its filename was
     kthread-numa-aware-kthread_create_on_cpu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kthread: NUMA aware kthread_create_on_node()
From: Eric Dumazet <eric.dumazet@gmail.com>

All kthreads being created from a single helper task, they all use memory
from a single node for their kernel stack and task struct.

This patch suite creates kthread_create_on_node(), adding a 'cpu' parameter
to parameters already used by kthread_create().

This parameter serves in allocating memory for the new kthread on its
memory node if possible.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Acked-by: David S. Miller <davem@davemloft.net>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Tejun Heo <tj@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: David Howells <dhowells@redhat.com>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kthread.h |   14 ++++++++++----
 include/linux/sched.h   |    1 +
 kernel/fork.c           |    3 ++-
 kernel/kthread.c        |   31 +++++++++++++++++++++++++------
 4 files changed, 38 insertions(+), 11 deletions(-)

diff -puN include/linux/kthread.h~kthread-numa-aware-kthread_create_on_cpu include/linux/kthread.h
--- a/include/linux/kthread.h~kthread-numa-aware-kthread_create_on_cpu
+++ a/include/linux/kthread.h
@@ -4,10 +4,15 @@
 #include <linux/err.h>
 #include <linux/sched.h>
 
-struct task_struct *kthread_create(int (*threadfn)(void *data),
-				   void *data,
-				   const char namefmt[], ...)
-	__attribute__((format(printf, 3, 4)));
+struct task_struct *kthread_create_on_node(int (*threadfn)(void *data),
+					   void *data,
+					   int node,
+					   const char namefmt[], ...)
+	__attribute__((format(printf, 4, 5)));
+
+#define kthread_create(threadfn, data, namefmt, arg...) \
+	kthread_create_on_node(threadfn, data, -1, namefmt, ##arg)
+
 
 /**
  * kthread_run - create and wake a thread.
@@ -34,6 +39,7 @@ void *kthread_data(struct task_struct *k
 
 int kthreadd(void *unused);
 extern struct task_struct *kthreadd_task;
+extern int tsk_fork_get_node(struct task_struct *tsk);
 
 /*
  * Simple work processor based on kthread.
diff -puN include/linux/sched.h~kthread-numa-aware-kthread_create_on_cpu include/linux/sched.h
--- a/include/linux/sched.h~kthread-numa-aware-kthread_create_on_cpu
+++ a/include/linux/sched.h
@@ -1471,6 +1471,7 @@ struct task_struct {
 #ifdef CONFIG_NUMA
 	struct mempolicy *mempolicy;	/* Protected by alloc_lock */
 	short il_next;
+	short pref_node_fork;
 #endif
 	atomic_t fs_excl;	/* holding fs exclusive resources */
 	struct rcu_head rcu;
diff -puN kernel/fork.c~kthread-numa-aware-kthread_create_on_cpu kernel/fork.c
--- a/kernel/fork.c~kthread-numa-aware-kthread_create_on_cpu
+++ a/kernel/fork.c
@@ -40,6 +40,7 @@
 #include <linux/tracehook.h>
 #include <linux/futex.h>
 #include <linux/compat.h>
+#include <linux/kthread.h>
 #include <linux/task_io_accounting_ops.h>
 #include <linux/rcupdate.h>
 #include <linux/ptrace.h>
@@ -254,7 +255,7 @@ static struct task_struct *dup_task_stru
 	struct task_struct *tsk;
 	struct thread_info *ti;
 	unsigned long *stackend;
-	int node = numa_node_id();
+	int node = tsk_fork_get_node(orig);
 	int err;
 
 	prepare_to_copy(orig);
diff -puN kernel/kthread.c~kthread-numa-aware-kthread_create_on_cpu kernel/kthread.c
--- a/kernel/kthread.c~kthread-numa-aware-kthread_create_on_cpu
+++ a/kernel/kthread.c
@@ -27,6 +27,7 @@ struct kthread_create_info
 	/* Information passed to kthread() from kthreadd. */
 	int (*threadfn)(void *data);
 	void *data;
+	int node;
 
 	/* Result passed back to kthread_create() from kthreadd. */
 	struct task_struct *result;
@@ -98,10 +99,23 @@ static int kthread(void *_create)
 	do_exit(ret);
 }
 
+/* called from do_fork() to get node information for about to be created task */
+int tsk_fork_get_node(struct task_struct *tsk)
+{
+#ifdef CONFIG_NUMA
+	if (tsk == kthreadd_task)
+		return tsk->pref_node_fork;
+#endif
+	return numa_node_id();
+}
+
 static void create_kthread(struct kthread_create_info *create)
 {
 	int pid;
 
+#ifdef CONFIG_NUMA
+	current->pref_node_fork = create->node;
+#endif
 	/* We want our own signal handler (we take no signals by default). */
 	pid = kernel_thread(kthread, create, CLONE_FS | CLONE_FILES | SIGCHLD);
 	if (pid < 0) {
@@ -111,15 +125,18 @@ static void create_kthread(struct kthrea
 }
 
 /**
- * kthread_create - create a kthread.
+ * kthread_create_on_node - create a kthread.
  * @threadfn: the function to run until signal_pending(current).
  * @data: data ptr for @threadfn.
+ * @node: memory node number.
  * @namefmt: printf-style name for the thread.
  *
  * Description: This helper function creates and names a kernel
  * thread.  The thread will be stopped: use wake_up_process() to start
  * it.  See also kthread_run().
  *
+ * If thread is going to be bound on a particular cpu, give its node
+ * in @node, to get NUMA affinity for kthread stack, or else give -1.
  * When woken, the thread will run @threadfn() with @data as its
  * argument. @threadfn() can either call do_exit() directly if it is a
  * standalone thread for which noone will call kthread_stop(), or
@@ -129,15 +146,17 @@ static void create_kthread(struct kthrea
  *
  * Returns a task_struct or ERR_PTR(-ENOMEM).
  */
-struct task_struct *kthread_create(int (*threadfn)(void *data),
-				   void *data,
-				   const char namefmt[],
-				   ...)
+struct task_struct *kthread_create_on_node(int (*threadfn)(void *data),
+					   void *data,
+					   int node,
+					   const char namefmt[],
+					   ...)
 {
 	struct kthread_create_info create;
 
 	create.threadfn = threadfn;
 	create.data = data;
+	create.node = node;
 	init_completion(&create.done);
 
 	spin_lock(&kthread_create_lock);
@@ -164,7 +183,7 @@ struct task_struct *kthread_create(int (
 	}
 	return create.result;
 }
-EXPORT_SYMBOL(kthread_create);
+EXPORT_SYMBOL(kthread_create_on_node);
 
 /**
  * kthread_bind - bind a just-created kthread to a cpu.
_

Patches currently in -mm which might be from eric.dumazet@gmail.com are

origin.patch
net-convert-%p-usage-to-%pk.patch

