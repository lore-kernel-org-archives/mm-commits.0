From: akpm@linux-foundation.org
Subject: - extend-notifier_call_chain-to-count-nr_calls-made.patch removed from -mm tree
Date: Wed, 09 May 2007 14:51:22 -0700
Message-ID: <200705092151.l49LpMmi002872@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49094 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752141AbXEIVvw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:51:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ego@in.ibm.com, akpm@linux-foundation.org, michal.k.k.piotrowski@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Extend notifier_call_chain to count nr_calls made
has been removed from the -mm tree.  Its filename was
     extend-notifier_call_chain-to-count-nr_calls-made.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Extend notifier_call_chain to count nr_calls made
From: Gautham R Shenoy <ego@in.ibm.com>

Since 2.6.18-something, the community has been bugged by the problem to
provide a clean and a stable mechanism to postpone a cpu-hotplug event as
lock_cpu_hotplug was badly broken.

This is another proposal towards solving that problem.  This one is along the
lines of the solution provided in kernel/workqueue.c

Instead of having a global mechanism like lock_cpu_hotplug, we allow the
subsytems to define their own per-subsystem hot cpu mutexes.  These would be
taken(released) where ever we are currently calling
lock_cpu_hotplug(unlock_cpu_hotplug).

Also, in the per-subsystem hotcpu callback function,we take this mutex before
we handle any pre-cpu-hotplug events and release it once we finish handling
the post-cpu-hotplug events.  A standard means for doing this has been
provided in [PATCH 2/4] and demonstrated in [PATCH 3/4].

The ordering of these per-subsystem mutexes might still prove to be a
problem, but hopefully lockdep should help us get out of that muddle.

The patch set to be applied against linux-2.6.19-rc5 is as follows:

[PATCH 1/4] :	Extend notifier_call_chain with an option to specify the
		number of notifications to be sent and also count the
		number of notifications actually sent.
		
[PATCH 2/4] :	Define events CPU_LOCK_ACQUIRE and CPU_LOCK_RELEASE
		and send out notifications for these in _cpu_up and
		_cpu_down. This would help us standardise the acquire and
		release of the subsystem locks in the hotcpu 
		callback functions of these subsystems.
		
[PATCH 3/4] :	Eliminate lock_cpu_hotplug from kernel/sched.c.
		
[PATCH 4/4] :	In workqueue_cpu_callback function, acquire(release) the
		workqueue_mutex while handling 
		CPU_LOCK_ACQUIRE(CPU_LOCK_RELEASE).

If the per-subsystem-locking approach survives the test of time, we can expect
a slow phasing out of lock_cpu_hotplug, which has not yet been eliminated in
these patches :)



This patch:


Provide notifier_call_chain with an option to call only a specified number of
notifiers and also record the number of call to notifiers made.

The need for this enhancement was identified in the post entitled
"Slab - Eliminate lock_cpu_hotplug from slab"
(http://lkml.org/lkml/2006/10/28/92) by Ravikiran G Thirumalai and
Andrew Morton.

This patch adds two additional parameters to notifier_call_chain API namely
 - int nr_to_calls : Number of notifier_functions to be called.
 		     The don't care value is -1.

 - unsigned int *nr_calls : Records the total number of notifier_funtions
			    called by notifier_call_chain. The don't care
			    value is NULL.

[michal.k.k.piotrowski@gmail.com: build fix]
Credit: Andrew Morton <akpm@osdl.org>
Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/notifier.h |   50 +++++++++++--------
 kernel/sys.c             |   94 ++++++++++++++++++++++++++++++-------
 2 files changed, 106 insertions(+), 38 deletions(-)

diff -puN include/linux/notifier.h~extend-notifier_call_chain-to-count-nr_calls-made include/linux/notifier.h
--- a/include/linux/notifier.h~extend-notifier_call_chain-to-count-nr_calls-made
+++ a/include/linux/notifier.h
@@ -112,32 +112,40 @@ extern void srcu_init_notifier_head(stru
 
 #ifdef __KERNEL__
 
-extern int atomic_notifier_chain_register(struct atomic_notifier_head *,
-		struct notifier_block *);
-extern int blocking_notifier_chain_register(struct blocking_notifier_head *,
-		struct notifier_block *);
-extern int raw_notifier_chain_register(struct raw_notifier_head *,
-		struct notifier_block *);
-extern int srcu_notifier_chain_register(struct srcu_notifier_head *,
-		struct notifier_block *);
-
-extern int atomic_notifier_chain_unregister(struct atomic_notifier_head *,
-		struct notifier_block *);
-extern int blocking_notifier_chain_unregister(struct blocking_notifier_head *,
-		struct notifier_block *);
-extern int raw_notifier_chain_unregister(struct raw_notifier_head *,
-		struct notifier_block *);
-extern int srcu_notifier_chain_unregister(struct srcu_notifier_head *,
-		struct notifier_block *);
+extern int atomic_notifier_chain_register(struct atomic_notifier_head *nh,
+		struct notifier_block *nb);
+extern int blocking_notifier_chain_register(struct blocking_notifier_head *nh,
+		struct notifier_block *nb);
+extern int raw_notifier_chain_register(struct raw_notifier_head *nh,
+		struct notifier_block *nb);
+extern int srcu_notifier_chain_register(struct srcu_notifier_head *nh,
+		struct notifier_block *nb);
+
+extern int atomic_notifier_chain_unregister(struct atomic_notifier_head *nh,
+		struct notifier_block *nb);
+extern int blocking_notifier_chain_unregister(struct blocking_notifier_head *nh,
+		struct notifier_block *nb);
+extern int raw_notifier_chain_unregister(struct raw_notifier_head *nh,
+		struct notifier_block *nb);
+extern int srcu_notifier_chain_unregister(struct srcu_notifier_head *nh,
+		struct notifier_block *nb);
 
-extern int atomic_notifier_call_chain(struct atomic_notifier_head *,
+extern int atomic_notifier_call_chain(struct atomic_notifier_head *nh,
 		unsigned long val, void *v);
-extern int blocking_notifier_call_chain(struct blocking_notifier_head *,
+extern int __atomic_notifier_call_chain(struct atomic_notifier_head *nh,
+	unsigned long val, void *v, int nr_to_call, int *nr_calls);
+extern int blocking_notifier_call_chain(struct blocking_notifier_head *nh,
 		unsigned long val, void *v);
-extern int raw_notifier_call_chain(struct raw_notifier_head *,
+extern int __blocking_notifier_call_chain(struct blocking_notifier_head *nh,
+	unsigned long val, void *v, int nr_to_call, int *nr_calls);
+extern int raw_notifier_call_chain(struct raw_notifier_head *nh,
 		unsigned long val, void *v);
-extern int srcu_notifier_call_chain(struct srcu_notifier_head *,
+extern int __raw_notifier_call_chain(struct raw_notifier_head *nh,
+	unsigned long val, void *v, int nr_to_call, int *nr_calls);
+extern int srcu_notifier_call_chain(struct srcu_notifier_head *nh,
 		unsigned long val, void *v);
+extern int __srcu_notifier_call_chain(struct srcu_notifier_head *nh,
+	unsigned long val, void *v, int nr_to_call, int *nr_calls);
 
 #define NOTIFY_DONE		0x0000		/* Don't care */
 #define NOTIFY_OK		0x0001		/* Suits me */
diff -puN kernel/sys.c~extend-notifier_call_chain-to-count-nr_calls-made kernel/sys.c
--- a/kernel/sys.c~extend-notifier_call_chain-to-count-nr_calls-made
+++ a/kernel/sys.c
@@ -134,19 +134,39 @@ static int notifier_chain_unregister(str
 	return -ENOENT;
 }
 
+/**
+ * notifier_call_chain - Informs the registered notifiers about an event.
+ *	@nl:		Pointer to head of the blocking notifier chain
+ *	@val:		Value passed unmodified to notifier function
+ *	@v:		Pointer passed unmodified to notifier function
+ *	@nr_to_call:	Number of notifier functions to be called. Don't care
+ *		     	value of this parameter is -1.
+ *	@nr_calls:	Records the number of notifications sent. Don't care
+ *		   	value of this field is NULL.
+ * 	@returns:	notifier_call_chain returns the value returned by the
+ *			last notifier function called.
+ */
+
 static int __kprobes notifier_call_chain(struct notifier_block **nl,
-		unsigned long val, void *v)
+					unsigned long val, void *v,
+					int nr_to_call,	int *nr_calls)
 {
 	int ret = NOTIFY_DONE;
 	struct notifier_block *nb, *next_nb;
 
 	nb = rcu_dereference(*nl);
-	while (nb) {
+
+	while (nb && nr_to_call) {
 		next_nb = rcu_dereference(nb->next);
 		ret = nb->notifier_call(nb, val, v);
+
+		if (nr_calls)
+			(*nr_calls)++;
+
 		if ((ret & NOTIFY_STOP_MASK) == NOTIFY_STOP_MASK)
 			break;
 		nb = next_nb;
+		nr_to_call--;
 	}
 	return ret;
 }
@@ -205,10 +225,12 @@ int atomic_notifier_chain_unregister(str
 EXPORT_SYMBOL_GPL(atomic_notifier_chain_unregister);
 
 /**
- *	atomic_notifier_call_chain - Call functions in an atomic notifier chain
+ *	__atomic_notifier_call_chain - Call functions in an atomic notifier chain
  *	@nh: Pointer to head of the atomic notifier chain
  *	@val: Value passed unmodified to notifier function
  *	@v: Pointer passed unmodified to notifier function
+ *	@nr_to_call: See the comment for notifier_call_chain.
+ *	@nr_calls: See the comment for notifier_call_chain.
  *
  *	Calls each function in a notifier chain in turn.  The functions
  *	run in an atomic context, so they must not block.
@@ -222,19 +244,27 @@ EXPORT_SYMBOL_GPL(atomic_notifier_chain_
  *	of the last notifier function called.
  */
  
-int __kprobes atomic_notifier_call_chain(struct atomic_notifier_head *nh,
-		unsigned long val, void *v)
+int __kprobes __atomic_notifier_call_chain(struct atomic_notifier_head *nh,
+					unsigned long val, void *v,
+					int nr_to_call, int *nr_calls)
 {
 	int ret;
 
 	rcu_read_lock();
-	ret = notifier_call_chain(&nh->head, val, v);
+	ret = notifier_call_chain(&nh->head, val, v, nr_to_call, nr_calls);
 	rcu_read_unlock();
 	return ret;
 }
 
-EXPORT_SYMBOL_GPL(atomic_notifier_call_chain);
+EXPORT_SYMBOL_GPL(__atomic_notifier_call_chain);
+
+int __kprobes atomic_notifier_call_chain(struct atomic_notifier_head *nh,
+		unsigned long val, void *v)
+{
+	return __atomic_notifier_call_chain(nh, val, v, -1, NULL);
+}
 
+EXPORT_SYMBOL_GPL(atomic_notifier_call_chain);
 /*
  *	Blocking notifier chain routines.  All access to the chain is
  *	synchronized by an rwsem.
@@ -304,10 +334,12 @@ int blocking_notifier_chain_unregister(s
 EXPORT_SYMBOL_GPL(blocking_notifier_chain_unregister);
 
 /**
- *	blocking_notifier_call_chain - Call functions in a blocking notifier chain
+ *	__blocking_notifier_call_chain - Call functions in a blocking notifier chain
  *	@nh: Pointer to head of the blocking notifier chain
  *	@val: Value passed unmodified to notifier function
  *	@v: Pointer passed unmodified to notifier function
+ *	@nr_to_call: See comment for notifier_call_chain.
+ *	@nr_calls: See comment for notifier_call_chain.
  *
  *	Calls each function in a notifier chain in turn.  The functions
  *	run in a process context, so they are allowed to block.
@@ -320,8 +352,9 @@ EXPORT_SYMBOL_GPL(blocking_notifier_chai
  *	of the last notifier function called.
  */
  
-int blocking_notifier_call_chain(struct blocking_notifier_head *nh,
-		unsigned long val, void *v)
+int __blocking_notifier_call_chain(struct blocking_notifier_head *nh,
+				   unsigned long val, void *v,
+				   int nr_to_call, int *nr_calls)
 {
 	int ret = NOTIFY_DONE;
 
@@ -332,12 +365,19 @@ int blocking_notifier_call_chain(struct 
 	 */
 	if (rcu_dereference(nh->head)) {
 		down_read(&nh->rwsem);
-		ret = notifier_call_chain(&nh->head, val, v);
+		ret = notifier_call_chain(&nh->head, val, v, nr_to_call,
+					nr_calls);
 		up_read(&nh->rwsem);
 	}
 	return ret;
 }
+EXPORT_SYMBOL_GPL(__blocking_notifier_call_chain);
 
+int blocking_notifier_call_chain(struct blocking_notifier_head *nh,
+		unsigned long val, void *v)
+{
+	return __blocking_notifier_call_chain(nh, val, v, -1, NULL);
+}
 EXPORT_SYMBOL_GPL(blocking_notifier_call_chain);
 
 /*
@@ -383,10 +423,12 @@ int raw_notifier_chain_unregister(struct
 EXPORT_SYMBOL_GPL(raw_notifier_chain_unregister);
 
 /**
- *	raw_notifier_call_chain - Call functions in a raw notifier chain
+ *	__raw_notifier_call_chain - Call functions in a raw notifier chain
  *	@nh: Pointer to head of the raw notifier chain
  *	@val: Value passed unmodified to notifier function
  *	@v: Pointer passed unmodified to notifier function
+ *	@nr_to_call: See comment for notifier_call_chain.
+ *	@nr_calls: See comment for notifier_call_chain
  *
  *	Calls each function in a notifier chain in turn.  The functions
  *	run in an undefined context.
@@ -400,10 +442,19 @@ EXPORT_SYMBOL_GPL(raw_notifier_chain_unr
  *	of the last notifier function called.
  */
 
+int __raw_notifier_call_chain(struct raw_notifier_head *nh,
+			      unsigned long val, void *v,
+			      int nr_to_call, int *nr_calls)
+{
+	return notifier_call_chain(&nh->head, val, v, nr_to_call, nr_calls);
+}
+
+EXPORT_SYMBOL_GPL(__raw_notifier_call_chain);
+
 int raw_notifier_call_chain(struct raw_notifier_head *nh,
 		unsigned long val, void *v)
 {
-	return notifier_call_chain(&nh->head, val, v);
+	return __raw_notifier_call_chain(nh, val, v, -1, NULL);
 }
 
 EXPORT_SYMBOL_GPL(raw_notifier_call_chain);
@@ -478,10 +529,12 @@ int srcu_notifier_chain_unregister(struc
 EXPORT_SYMBOL_GPL(srcu_notifier_chain_unregister);
 
 /**
- *	srcu_notifier_call_chain - Call functions in an SRCU notifier chain
+ *	__srcu_notifier_call_chain - Call functions in an SRCU notifier chain
  *	@nh: Pointer to head of the SRCU notifier chain
  *	@val: Value passed unmodified to notifier function
  *	@v: Pointer passed unmodified to notifier function
+ *	@nr_to_call: See comment for notifier_call_chain.
+ *	@nr_calls: See comment for notifier_call_chain
  *
  *	Calls each function in a notifier chain in turn.  The functions
  *	run in a process context, so they are allowed to block.
@@ -494,18 +547,25 @@ EXPORT_SYMBOL_GPL(srcu_notifier_chain_un
  *	of the last notifier function called.
  */
 
-int srcu_notifier_call_chain(struct srcu_notifier_head *nh,
-		unsigned long val, void *v)
+int __srcu_notifier_call_chain(struct srcu_notifier_head *nh,
+			       unsigned long val, void *v,
+			       int nr_to_call, int *nr_calls)
 {
 	int ret;
 	int idx;
 
 	idx = srcu_read_lock(&nh->srcu);
-	ret = notifier_call_chain(&nh->head, val, v);
+	ret = notifier_call_chain(&nh->head, val, v, nr_to_call, nr_calls);
 	srcu_read_unlock(&nh->srcu, idx);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(__srcu_notifier_call_chain);
 
+int srcu_notifier_call_chain(struct srcu_notifier_head *nh,
+		unsigned long val, void *v)
+{
+	return __srcu_notifier_call_chain(nh, val, v, -1, NULL);
+}
 EXPORT_SYMBOL_GPL(srcu_notifier_call_chain);
 
 /**
_

Patches currently in -mm which might be from ego@in.ibm.com are

origin.patch
freezer-read-pf_borrowed_mm-in-a-nonracy-way.patch
freezer-close-theoretical-race-between-refrigerator-and-thaw_tasks.patch
freezer-remove-pf_nofreeze-from-rcutorture-thread.patch
freezer-remove-pf_nofreeze-from-bluetooth-threads.patch
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
freezer-fix-vfork-problem.patch
freezer-take-kernel_execve-into-consideration.patch
fix-pf_nofreeze-and-freezeable-race-2.patch
freezer-document-task_lock-in-thaw_process.patch
move-frozen_process-to-kernel-power-processc.patch
separate-freezer-from-pm-code-rev-2.patch
introduce-freezer-flags-rev-2.patch
