From: akpm@linux-foundation.org
Subject: - extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch removed from -mm tree
Date: Mon, 05 Mar 2007 17:02:12 -0800
Message-ID: <200703060102.l2612Dxo007076@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43930 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932854AbXCFBCp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 20:02:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ego@in.ibm.com, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Fix extend notifier_call_chain to count nr_calls made
has been removed from the -mm tree.  Its filename was
     extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch

This patch was dropped because it was folded into extend-notifier_call_chain-to-count-nr_calls-made.patch

------------------------------------------------------
Subject: Fix extend notifier_call_chain to count nr_calls made
From: Gautham R Shenoy <ego@in.ibm.com>

* Corrects the type of nr_calls to int * from unsigned int * in
  notifier_call_chain and it's subsequent callers.

* Converts comments of notifier_call_chain to be compliant with
  kernel-docs standards.

* Reverts the changes made to the comments of other
  *_notifier_call_chain.

* Adds parameter names to a few functions prototypes in
  include/linux/notifier.h .

Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/notifier.h |   58 ++++++++++++++++++-------------------
 kernel/sys.c             |   22 +++++---------
 2 files changed, 38 insertions(+), 42 deletions(-)

diff -puN include/linux/notifier.h~extend-notifier_call_chain-to-count-nr_calls-made-fixes include/linux/notifier.h
--- a/include/linux/notifier.h~extend-notifier_call_chain-to-count-nr_calls-made-fixes
+++ a/include/linux/notifier.h
@@ -112,40 +112,40 @@ extern void srcu_init_notifier_head(stru
 
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
-extern int __atomic_notifier_call_chain(struct atomic_notifier_head *,
-	unsigned long val, void *v, int nr_to_call, unsigned int *nr_calls);
-extern int blocking_notifier_call_chain(struct blocking_notifier_head *,
+extern int __atomic_notifier_call_chain(struct atomic_notifier_head *nh,
+	unsigned long val, void *v, int nr_to_call, int *nr_calls);
+extern int blocking_notifier_call_chain(struct blocking_notifier_head *nh,
 		unsigned long val, void *v);
-extern int __blocking_notifier_call_chain(struct blocking_notifier_head *,
-	unsigned long val, void *v, int nr_to_call, unsigned int *nr_calls);
-extern int raw_notifier_call_chain(struct raw_notifier_head *,
+extern int __blocking_notifier_call_chain(struct blocking_notifier_head *nh,
+	unsigned long val, void *v, int nr_to_call, int *nr_calls);
+extern int raw_notifier_call_chain(struct raw_notifier_head *nh,
 		unsigned long val, void *v);
-extern int __raw_notifier_call_chain(struct raw_notifier_head *,
-	unsigned long val, void *v, int nr_to_call, unsigned int *nr_calls);
-extern int srcu_notifier_call_chain(struct srcu_notifier_head *,
+extern int __raw_notifier_call_chain(struct raw_notifier_head *nh,
+	unsigned long val, void *v, int nr_to_call, int *nr_calls);
+extern int srcu_notifier_call_chain(struct srcu_notifier_head *nh,
 		unsigned long val, void *v);
-extern int __srcu_notifier_call_chain(struct srcu_notifier_head *,
-	unsigned long val, void *v, int nr_to_call, unsigned int *nr_calls);
+extern int __srcu_notifier_call_chain(struct srcu_notifier_head *nh,
+	unsigned long val, void *v, int nr_to_call, int *nr_calls);
 
 #define NOTIFY_DONE		0x0000		/* Don't care */
 #define NOTIFY_OK		0x0001		/* Suits me */
diff -puN kernel/sys.c~extend-notifier_call_chain-to-count-nr_calls-made-fixes kernel/sys.c
--- a/kernel/sys.c~extend-notifier_call_chain-to-count-nr_calls-made-fixes
+++ a/kernel/sys.c
@@ -134,9 +134,8 @@ static int notifier_chain_unregister(str
 	return -ENOENT;
 }
 
-/*
+/**
  * notifier_call_chain - Informs the registered notifiers about an event.
- *
  *	@nl:		Pointer to head of the blocking notifier chain
  *	@val:		Value passed unmodified to notifier function
  *	@v:		Pointer passed unmodified to notifier function
@@ -144,14 +143,13 @@ static int notifier_chain_unregister(str
  *		     	value of this parameter is -1.
  *	@nr_calls:	Records the number of notifications sent. Don't care
  *		   	value of this field is NULL.
- *
- * 	RETURN VALUE:	notifier_call_chain returns the value returned by the
+ * 	@returns:	notifier_call_chain returns the value returned by the
  *			last notifier function called.
  */
 
 static int __kprobes notifier_call_chain(struct notifier_block **nl,
 					unsigned long val, void *v,
-					int nr_to_call,	unsigned int *nr_calls)
+					int nr_to_call,	int *nr_calls)
 {
 	int ret = NOTIFY_DONE;
 	struct notifier_block *nb, *next_nb;
@@ -227,8 +225,7 @@ int atomic_notifier_chain_unregister(str
 EXPORT_SYMBOL_GPL(atomic_notifier_chain_unregister);
 
 /**
- *	__atomic_notifier_call_chain - Call functions in an atomic notifier
- *				       chain
+ *	__atomic_notifier_call_chain - Call functions in an atomic notifier chain
  *	@nh: Pointer to head of the atomic notifier chain
  *	@val: Value passed unmodified to notifier function
  *	@v: Pointer passed unmodified to notifier function
@@ -249,7 +246,7 @@ EXPORT_SYMBOL_GPL(atomic_notifier_chain_
  
 int __kprobes __atomic_notifier_call_chain(struct atomic_notifier_head *nh,
 					unsigned long val, void *v,
-					int nr_to_call, unsigned int *nr_calls)
+					int nr_to_call, int *nr_calls)
 {
 	int ret;
 
@@ -337,8 +334,7 @@ int blocking_notifier_chain_unregister(s
 EXPORT_SYMBOL_GPL(blocking_notifier_chain_unregister);
 
 /**
- *	__blocking_notifier_call_chain - Call functions in a blocking notifier
- *					 chain
+ *	__blocking_notifier_call_chain - Call functions in a blocking notifier chain
  *	@nh: Pointer to head of the blocking notifier chain
  *	@val: Value passed unmodified to notifier function
  *	@v: Pointer passed unmodified to notifier function
@@ -448,7 +444,7 @@ EXPORT_SYMBOL_GPL(raw_notifier_chain_unr
 
 int __raw_notifier_call_chain(struct raw_notifier_head *nh,
 			      unsigned long val, void *v,
-			      int nr_to_call, unsigned int *nr_calls)
+			      int nr_to_call, int *nr_calls)
 {
 	return notifier_call_chain(&nh->head, val, v, nr_to_call, nr_calls);
 }
@@ -533,7 +529,7 @@ int srcu_notifier_chain_unregister(struc
 EXPORT_SYMBOL_GPL(srcu_notifier_chain_unregister);
 
 /**
- *	srcu_notifier_call_chain - Call functions in an SRCU notifier chain
+ *	__srcu_notifier_call_chain - Call functions in an SRCU notifier chain
  *	@nh: Pointer to head of the SRCU notifier chain
  *	@val: Value passed unmodified to notifier function
  *	@v: Pointer passed unmodified to notifier function
@@ -553,7 +549,7 @@ EXPORT_SYMBOL_GPL(srcu_notifier_chain_un
 
 int __srcu_notifier_call_chain(struct srcu_notifier_head *nh,
 			       unsigned long val, void *v,
-			       int nr_to_call, unsigned int *nr_calls)
+			       int nr_to_call, int *nr_calls)
 {
 	int ret;
 	int idx;
_

Patches currently in -mm which might be from ego@in.ibm.com are

flush_workqueue-use-preempt_disable-to-hold-off-cpu-hotplug.patch
flush_cpu_workqueue-dont-flush-an-empty-worklist.patch
extend-notifier_call_chain-to-count-nr_calls-made.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes-2.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release-fix.patch
eliminate-lock_cpu_hotplug-in-kernel-schedc.patch
eliminate-lock_cpu_hotplug-in-kernel-schedc-fix.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed.patch
slab-use-cpu_lock_.patch
workqueue-fix-freezeable-workqueues-implementation.patch
workqueue-fix-flush_workqueue-vs-cpu_dead-race.patch
workqueue-dont-clear-cwq-thread-until-it-exits.patch
workqueue-dont-migrate-pending-works-from-the-dead-cpu.patch
freezer-read-pf_borrowed_mm-in-a-nonracy-way.patch
freezer-close-theoretical-race-between-refrigerator-and-thaw_tasks.patch
freezer-remove-pf_nofreeze-from-rcutorture-thread.patch
freezer-remove-pf_nofreeze-from-bluetooth-threads.patch
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
freezer-fix-vfork-problem.patch
freezer-take-kernel_execve-into-consideration.patch
