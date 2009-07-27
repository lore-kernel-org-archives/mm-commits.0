From: akpm@linux-foundation.org
Subject: + generic-ipi-make-struct-call_function_data-lockless.patch added to -mm tree
Date: Mon, 27 Jul 2009 15:00:41 -0700
Message-ID: <200907272200.n6RM0fLf024415@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55534 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755280AbZG0WBn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Jul 2009 18:01:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiaoguangrong@cn.fujitsu.com, jens.axboe@oracle.com, mingo@elte.hu, nickpiggin@yahoo.com.au, peterz@infradead.org, rusty@rustcorp.com.au


The patch titled
     generic-ipi: make struct call_function_data lockless
has been added to the -mm tree.  Its filename is
     generic-ipi-make-struct-call_function_data-lockless.patch

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
Subject: generic-ipi: make struct call_function_data lockless
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>

This patch can remove spinlock from struct call_function_data, the
reasons are below:

1: add a new interface for cpumask named cpumask_test_and_clear_cpu(),
   it can atomically test and clear specific cpu, we can use it instead
   of cpumask_test_cpu() and cpumask_clear_cpu() and no need data->lock
   to protect those in generic_smp_call_function_interrupt().

2: in smp_call_function_many(), after csd_lock() return, the current's
   cfd_data is deleted from call_function list, so it not have race
   between other cpus, then cfs_data is only used in
   smp_call_function_many() that must disable preemption and not from
   a hardware interrupthandler or from a bottom half handler to call,
   only the correspond cpu can use it, so it not have race in current
   cpu, no need cfs_data->lock to protect it.

3: after 1 and 2, cfs_data->lock is only use to protect cfs_data->refs in
   generic_smp_call_function_interrupt(), so we can define cfs_data->refs
   to atomic_t, and no need cfs_data->lock any more.

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpumask.h |   12 ++++++++++++
 kernel/smp.c            |   29 ++++++++---------------------
 2 files changed, 20 insertions(+), 21 deletions(-)

diff -puN include/linux/cpumask.h~generic-ipi-make-struct-call_function_data-lockless include/linux/cpumask.h
--- a/include/linux/cpumask.h~generic-ipi-make-struct-call_function_data-lockless
+++ a/include/linux/cpumask.h
@@ -273,6 +273,18 @@ static inline int cpumask_test_and_set_c
 }
 
 /**
+ * cpumask_test_and_clear_cpu - atomically test and clear a cpu in a cpumask
+ * @cpu: cpu number (< nr_cpu_ids)
+ * @cpumask: the cpumask pointer
+ *
+ * test_and_clear_bit wrapper for cpumasks.
+ */
+static inline int cpumask_test_and_clear_cpu(int cpu, struct cpumask *cpumask)
+{
+	return test_and_clear_bit(cpumask_check(cpu), cpumask_bits(cpumask));
+}
+
+/**
  * cpumask_setall - set all cpus (< nr_cpu_ids) in a cpumask
  * @dstp: the cpumask pointer
  */
diff -puN kernel/smp.c~generic-ipi-make-struct-call_function_data-lockless kernel/smp.c
--- a/kernel/smp.c~generic-ipi-make-struct-call_function_data-lockless
+++ a/kernel/smp.c
@@ -29,8 +29,7 @@ enum {
 
 struct call_function_data {
 	struct call_single_data	csd;
-	spinlock_t		lock;
-	unsigned int		refs;
+	atomic_t		refs;
 	cpumask_var_t		cpumask;
 };
 
@@ -39,9 +38,7 @@ struct call_single_queue {
 	spinlock_t		lock;
 };
 
-static DEFINE_PER_CPU(struct call_function_data, cfd_data) = {
-	.lock			= __SPIN_LOCK_UNLOCKED(cfd_data.lock),
-};
+static DEFINE_PER_CPU(struct call_function_data, cfd_data);
 
 static int
 hotplug_cfd(struct notifier_block *nfb, unsigned long action, void *hcpu)
@@ -191,25 +188,18 @@ void generic_smp_call_function_interrupt
 	list_for_each_entry_rcu(data, &call_function.queue, csd.list) {
 		int refs;
 
-		spin_lock(&data->lock);
-		if (!cpumask_test_cpu(cpu, data->cpumask)) {
-			spin_unlock(&data->lock);
+		if (!cpumask_test_and_clear_cpu(cpu, data->cpumask))
 			continue;
-		}
-		cpumask_clear_cpu(cpu, data->cpumask);
-		spin_unlock(&data->lock);
 
 		data->csd.func(data->csd.info);
 
-		spin_lock(&data->lock);
-		WARN_ON(data->refs == 0);
-		refs = --data->refs;
+		refs = atomic_sub_return(1, &data->refs);
+		WARN_ON(refs < 0);
 		if (!refs) {
 			spin_lock(&call_function.lock);
 			list_del_rcu(&data->csd.list);
 			spin_unlock(&call_function.lock);
 		}
-		spin_unlock(&data->lock);
 
 		if (refs)
 			continue;
@@ -424,23 +414,20 @@ void smp_call_function_many(const struct
 	data = &__get_cpu_var(cfd_data);
 	csd_lock(&data->csd);
 
-	spin_lock_irqsave(&data->lock, flags);
 	data->csd.func = func;
 	data->csd.info = info;
 	cpumask_and(data->cpumask, mask, cpu_online_mask);
 	cpumask_clear_cpu(this_cpu, data->cpumask);
-	data->refs = cpumask_weight(data->cpumask);
+	atomic_set(&data->refs, cpumask_weight(data->cpumask));
 
-	spin_lock(&call_function.lock);
+	spin_lock_irqsave(&call_function.lock, flags);
 	/*
 	 * Place entry at the _HEAD_ of the list, so that any cpu still
 	 * observing the entry in generic_smp_call_function_interrupt()
 	 * will not miss any other list entries:
 	 */
 	list_add_rcu(&data->csd.list, &call_function.queue);
-	spin_unlock(&call_function.lock);
