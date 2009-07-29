From: akpm@linux-foundation.org
Subject: + generic-ipi-fix-the-race-between-generic_smp_call_function_-and-hotplug_cfd.patch added to -mm tree
Date: Wed, 29 Jul 2009 16:31:46 -0700
Message-ID: <200907292331.n6TNVk5R031629@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32915 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754813AbZG2XcG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Jul 2009 19:32:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiaoguangrong@cn.fujitsu.com, jens.axboe@oracle.com, mingo@elte.hu, nickpiggin@yahoo.com.au, peterz@infradead.org, rusty@rustcorp.com.au


The patch titled
     generic-ipi: fix the race between generic_smp_call_function_*() and hotplug_cfd()
has been added to the -mm tree.  Its filename is
     generic-ipi-fix-the-race-between-generic_smp_call_function_-and-hotplug_cfd.patch

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
Subject: generic-ipi: fix the race between generic_smp_call_function_*() and hotplug_cfd()
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>

There is a race between generic_smp_call_function_*() and hotplug_cfd() in
many cases, see below examples:

1: hotplug_cfd() can free cfd->cpumask, the system will crash if the
   cpu's cfd still in the call_function list:


      CPU A:                         CPU B

 smp_call_function_many()	    ......
   cpu_down()                      ......
  hotplug_cfd() ->                 ......
 free_cpumask_var(cfd->cpumask)  (receive function IPI interrupte)
                                /* read cfd->cpumask */
                          generic_smp_call_function_interrupt() ->
                         cpumask_test_and_clear_cpu(cpu, data->cpumask)

                         	CRASH!!!

2: It's not handle call_function list when cpu down, It's will lead to
   dead-wait if other path is waiting this cpu to execute function

    CPU A:                           CPU B

 smp_call_function_many(wait=0)
        ......			    CPU B down
   smp_call_function_many() -->  (cpu down before recevie function
    csd_lock(&data->csd);         IPI interrupte)

    DEAD-WAIT!!!!

  So, CPU A will dead-wait in csd_lock(), the same as
  smp_call_function_single()

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/smp.c |   38 ++++++++++++++++++++++++++++----------
 1 file changed, 28 insertions(+), 10 deletions(-)

diff -puN kernel/smp.c~generic-ipi-fix-the-race-between-generic_smp_call_function_-and-hotplug_cfd kernel/smp.c
--- a/kernel/smp.c~generic-ipi-fix-the-race-between-generic_smp_call_function_-and-hotplug_cfd
+++ a/kernel/smp.c
@@ -116,14 +116,10 @@ void generic_exec_single(int cpu, struct
 		csd_lock_wait(data);
 }
 
-/*
- * Invoked by arch to handle an IPI for call function. Must be called with
- * interrupts disabled.
- */
-void generic_smp_call_function_interrupt(void)
+static void
+__generic_smp_call_function_interrupt(int cpu, int run_callbacks)
 {
 	struct call_function_data *data;
-	int cpu = smp_processor_id();
 
 	/*
 	 * Ensure entry is visible on call_function_queue after we have
@@ -169,12 +165,18 @@ void generic_smp_call_function_interrupt
 }
 
 /*
- * Invoked by arch to handle an IPI for call function single. Must be
- * called from the arch with interrupts disabled.
+ * Invoked by arch to handle an IPI for call function. Must be called with
+ * interrupts disabled.
  */
-void generic_smp_call_function_single_interrupt(void)
+void generic_smp_call_function_interrupt(void)
+{
+	__generic_smp_call_function_interrupt(smp_processor_id(), 1);
+}
+
+static void
+__generic_smp_call_function_single_interrupt(int cpu, int run_callbacks)
 {
-	struct call_single_queue *q = &__get_cpu_var(call_single_queue);
+	struct call_single_queue *q = &per_cpu(call_single_queue, cpu);
 	unsigned int data_flags;
 	LIST_HEAD(list);
 
@@ -205,6 +207,15 @@ void generic_smp_call_function_single_in
 	}
 }
 
+/*
+ * Invoked by arch to handle an IPI for call function single. Must be
+ * called from the arch with interrupts disabled.
+ */
+void generic_smp_call_function_single_interrupt(void)
+{
+	__generic_smp_call_function_single_interrupt(smp_processor_id(), 1);
+}
+
 static DEFINE_PER_CPU(struct call_single_data, csd_data);
 
 /*
@@ -456,6 +467,7 @@ static int
 hotplug_cfd(struct notifier_block *nfb, unsigned long action, void *hcpu)
 {
 	long cpu = (long)hcpu;
+	unsigned long flags;
 	struct call_function_data *cfd = &per_cpu(cfd_data, cpu);
 
 	switch (action) {
@@ -472,6 +484,12 @@ hotplug_cfd(struct notifier_block *nfb, 
 
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
+		local_irq_save(flags);
+		__generic_smp_call_function_interrupt(cpu, 0);
+		__generic_smp_call_function_single_interrupt(cpu, 0);
+		local_irq_restore(flags);
+
+		csd_lock_wait(&cfd->csd);
 		free_cpumask_var(cfd->cpumask);
 		break;
 #endif
_

Patches currently in -mm which might be from xiaoguangrong@cn.fujitsu.com are

generic-ipi-fix-hotplug_cfd.patch
generic-ipi-cleanup-for-generic_smp_call_function_interrupt.patch
kernel-smpc-relocate-some-code.patch
generic-ipi-fix-the-race-between-generic_smp_call_function_-and-hotplug_cfd.patch
generic-ipi-make-struct-call_function_data-lockless.patch
generic-ipi-make-struct-call_function_data-lockless-cleanup.patch

