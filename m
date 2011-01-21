From: akpm@linux-foundation.org
Subject: + kthread-numa-aware-kthread_create_on_cpu-update.patch added to -mm tree
Date: Fri, 21 Jan 2011 14:32:34 -0800
Message-ID: <201101212232.p0LMWYAs004900@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52594 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751242Ab1AUWdm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Jan 2011 17:33:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eric.dumazet@gmail.com, andi@firstfloor.org, davem@davemloft.net, rusty@rustcorp.com.au, tj@kernel.org


The patch titled
     kthread-numa-aware-kthread_create_on_cpu-update
has been added to the -mm tree.  Its filename is
     kthread-numa-aware-kthread_create_on_cpu-update.patch

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
Subject: kthread-numa-aware-kthread_create_on_cpu-update
From: Eric Dumazet <eric.dumazet@gmail.com>

People told me kthread_create_on_cpu() was a wrong name and prefer
kthread_create_on_node()

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Miller <davem@davemloft.net>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Tejun Heo <tj@kernel.org>
Cc: linux-arch@vger.kernel.org
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kthread.h |   10 +++++-----
 kernel/kthread.c        |   27 +++++++++++++--------------
 2 files changed, 18 insertions(+), 19 deletions(-)

diff -puN include/linux/kthread.h~kthread-numa-aware-kthread_create_on_cpu-update include/linux/kthread.h
--- a/include/linux/kthread.h~kthread-numa-aware-kthread_create_on_cpu-update
+++ a/include/linux/kthread.h
@@ -4,14 +4,14 @@
 #include <linux/err.h>
 #include <linux/sched.h>
 
-struct task_struct *kthread_create_on_cpu(int (*threadfn)(void *data),
-					  void *data,
-					  int cpu,
-					  const char namefmt[], ...)
+struct task_struct *kthread_create_on_node(int (*threadfn)(void *data),
+					   void *data,
+					   int node,
+					   const char namefmt[], ...)
 	__attribute__((format(printf, 4, 5)));
 
 #define kthread_create(threadfn, data, namefmt, arg...) \
-	kthread_create_on_cpu(threadfn, data, -1, namefmt, ##arg)
+	kthread_create_on_node(threadfn, data, -1, namefmt, ##arg)
 
 
 /**
diff -puN kernel/kthread.c~kthread-numa-aware-kthread_create_on_cpu-update kernel/kthread.c
--- a/kernel/kthread.c~kthread-numa-aware-kthread_create_on_cpu-update
+++ a/kernel/kthread.c
@@ -27,7 +27,7 @@ struct kthread_create_info
 	/* Information passed to kthread() from kthreadd. */
 	int (*threadfn)(void *data);
 	void *data;
-	int cpu;
+	int node;
 
 	/* Result passed back to kthread_create() from kthreadd. */
 	struct task_struct *result;
@@ -114,8 +114,7 @@ static void create_kthread(struct kthrea
 	int pid;
 
 #ifdef CONFIG_NUMA
-	current->pref_node_fork = (create->cpu != -1) ?
-		cpu_to_node(create->cpu) : -1;
+	current->pref_node_fork = create->node;
 #endif
 	/* We want our own signal handler (we take no signals by default). */
 	pid = kernel_thread(kthread, create, CLONE_FS | CLONE_FILES | SIGCHLD);
@@ -126,18 +125,18 @@ static void create_kthread(struct kthrea
 }
 
 /**
- * kthread_create_on_cpu - create a kthread.
+ * kthread_create_on_node - create a kthread.
  * @threadfn: the function to run until signal_pending(current).
  * @data: data ptr for @threadfn.
- * @cpu: cpu number.
+ * @node: memory node number.
  * @namefmt: printf-style name for the thread.
  *
  * Description: This helper function creates and names a kernel
  * thread.  The thread will be stopped: use wake_up_process() to start
  * it.  See also kthread_run().
  *
- * If thread is going to be bound on a particular cpu, give its number
- * in @cpu, to get NUMA affinity for kthread stack, or else give -1.
+ * If thread is going to be bound on a particular cpu, give its node
+ * in @node, to get NUMA affinity for kthread stack, or else give -1.
  * When woken, the thread will run @threadfn() with @data as its
  * argument. @threadfn() can either call do_exit() directly if it is a
  * standalone thread for which noone will call kthread_stop(), or
@@ -147,17 +146,17 @@ static void create_kthread(struct kthrea
  *
  * Returns a task_struct or ERR_PTR(-ENOMEM).
  */
-struct task_struct *kthread_create_on_cpu(int (*threadfn)(void *data),
-					  void *data,
-					  int cpu,
-					  const char namefmt[],
-					  ...)
+struct task_struct *kthread_create_on_node(int (*threadfn)(void *data),
+					   void *data,
+					   int node,
+					   const char namefmt[],
+					   ...)
 {
 	struct kthread_create_info create;
 
 	create.threadfn = threadfn;
 	create.data = data;
-	create.cpu = cpu;
+	create.node = node;
 	init_completion(&create.done);
 
 	spin_lock(&kthread_create_lock);
@@ -184,7 +183,7 @@ struct task_struct *kthread_create_on_cp
 	}
 	return create.result;
 }
-EXPORT_SYMBOL(kthread_create_on_cpu);
+EXPORT_SYMBOL(kthread_create_on_node);
 
 /**
  * kthread_bind - bind a just-created kthread to a cpu.
_

Patches currently in -mm which might be from eric.dumazet@gmail.com are

origin.patch
mm-numa-aware-alloc_task_struct_node.patch
mm-numa-aware-alloc_thread_info_node.patch
kthread-numa-aware-kthread_create_on_cpu.patch
kthread-numa-aware-kthread_create_on_cpu-update.patch
kthread-use-kthread_create_on_cpu.patch
kthread-use-kthread_create_on_cpu-update.patch
net-convert-%p-usage-to-%pk.patch

