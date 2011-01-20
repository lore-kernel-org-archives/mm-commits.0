From: akpm@linux-foundation.org
Subject: + kernel-smpc-fix-smp_call_function_many-smp-race.patch added to -mm tree
Date: Wed, 19 Jan 2011 16:46:56 -0800
Message-ID: <201101200046.p0K0kvJh013302@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34917 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753052Ab1ATAro (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Jan 2011 19:47:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anton@samba.org, miltonm@bga.com, mingo@elte.hu, paulmck@linux.vnet.ibm.com, stable@kernel.org


The patch titled
     kernel/smp.c: fix smp_call_function_many() SMP race
has been added to the -mm tree.  Its filename is
     kernel-smpc-fix-smp_call_function_many-smp-race.patch

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
Subject: kernel/smp.c: fix smp_call_function_many() SMP race
From: Anton Blanchard <anton@samba.org>

I noticed a failure where we hit the following WARN_ON in
generic_smp_call_function_interrupt:

                if (!cpumask_test_and_clear_cpu(cpu, data->cpumask))
                        continue;

                data->csd.func(data->csd.info);

                refs = atomic_dec_return(&data->refs);
                WARN_ON(refs < 0);      <-------------------------

We atomically tested and cleared our bit in the cpumask, and yet the
number of cpus left (ie refs) was 0.  How can this be?

It turns out commit 54fdade1c3332391948ec43530c02c4794a38172
("generic-ipi: make struct call_function_data lockless") is at fault.  It
removes locking from smp_call_function_many and in doing so creates a
rather complicated race.

The problem comes about because:

- The smp_call_function_many interrupt handler walks call_function.queue
  without any locking.
- We reuse a percpu data structure in smp_call_function_many.
- We do not wait for any RCU grace period before starting the next
  smp_call_function_many.

Imagine a scenario where CPU A does two smp_call_functions back to back,
and CPU B does an smp_call_function in between.  We concentrate on how CPU
C handles the calls:

CPU A            CPU B                  CPU C              CPU D

smp_call_function
                                        smp_call_function_interrupt
                                            walks
					call_function.queue sees
					data from CPU A on list

                 smp_call_function

                                        smp_call_function_interrupt
                                            walks

                                        call_function.queue sees
                                          (stale) CPU A on list
							   smp_call_function int
							   clears last ref on A
							   list_del_rcu, unlock
smp_call_function reuses
percpu *data A
                                         data->cpumask sees and
                                         clears bit in cpumask
                                         might be using old or new fn!
                                         decrements refs below 0

set data->refs (too late!)

The important thing to note is since the interrupt handler walks a
potentially stale call_function.queue without any locking, then another
cpu can view the percpu *data structure at any time, even when the owner
is in the process of initialising it.

The following test case hits the WARN_ON 100% of the time on my PowerPC
box (having 128 threads does help :)

#include <linux/module.h>
#include <linux/init.h>

#define ITERATIONS 100

static void do_nothing_ipi(void *dummy)
{
}

static void do_ipis(struct work_struct *dummy)
{
	int i;

	for (i = 0; i < ITERATIONS; i++)
		smp_call_function(do_nothing_ipi, NULL, 1);

	printk(KERN_DEBUG "cpu %d finished\n", smp_processor_id());
}

static struct work_struct work[NR_CPUS];

static int __init testcase_init(void)
{
	int cpu;

	for_each_online_cpu(cpu) {
		INIT_WORK(&work[cpu], do_ipis);
		schedule_work_on(cpu, &work[cpu]);
	}

	return 0;
}

static void __exit testcase_exit(void)
{
}

module_init(testcase_init)
module_exit(testcase_exit)
MODULE_LICENSE("GPL");
MODULE_AUTHOR("Anton Blanchard");

I tried to fix it by ordering the read and the write of ->cpumask and
->refs.  In doing so I missed a critical case but Paul McKenney was able
to spot my bug thankfully :) To ensure we arent viewing previous
iterations the interrupt handler needs to read ->refs then ->cpumask then
->refs _again_.

Thanks to Milton Miller and Paul McKenney for helping to debug this issue.

[miltonm@bga.com: add WARN_ON and BUG_ON, remove extra read of refs before initial read of mask that doesn't help (also noted by Peter Zijlstra), adjust comments, hopefully clarify scenario ]
[miltonm@bga.com: remove excess tests]
Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Milton Miller <miltonm@bga.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: <stable@kernel.org> [2.6.32+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/smp.c |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff -puN kernel/smp.c~kernel-smpc-fix-smp_call_function_many-smp-race kernel/smp.c
--- a/kernel/smp.c~kernel-smpc-fix-smp_call_function_many-smp-race
+++ a/kernel/smp.c
@@ -195,6 +195,24 @@ void generic_smp_call_function_interrupt
 	list_for_each_entry_rcu(data, &call_function.queue, csd.list) {
 		int refs;
 
+		/*
+		 * Since we walk the list without any locks, we might
+		 * see an entry that was completed, removed from the
+		 * list and is in the process of being reused.
+		 *
+		 * We must check that the cpu is in the cpumask before
+		 * checking the refs, and both must be set before
+		 * executing the callback on this cpu.
+		 */
+
+		if (!cpumask_test_cpu(cpu, data->cpumask))
+			continue;
+
+		smp_rmb();
+
+		if (atomic_read(&data->refs) == 0)
+			continue;
+
 		if (!cpumask_test_and_clear_cpu(cpu, data->cpumask))
 			continue;
 
@@ -203,6 +221,8 @@ void generic_smp_call_function_interrupt
 		refs = atomic_dec_return(&data->refs);
 		WARN_ON(refs < 0);
 		if (!refs) {
+			WARN_ON(!cpumask_empty(data->cpumask));
+
 			raw_spin_lock(&call_function.lock);
 			list_del_rcu(&data->csd.list);
 			raw_spin_unlock(&call_function.lock);
@@ -454,11 +474,21 @@ void smp_call_function_many(const struct
 
 	data = &__get_cpu_var(cfd_data);
 	csd_lock(&data->csd);
+	BUG_ON(atomic_read(&data->refs) || !cpumask_empty(data->cpumask));
 
 	data->csd.func = func;
 	data->csd.info = info;
 	cpumask_and(data->cpumask, mask, cpu_online_mask);
 	cpumask_clear_cpu(this_cpu, data->cpumask);
+
+	/*
+	 * To ensure the interrupt handler gets an complete view
+	 * we order the cpumask and refs writes and order the read
+	 * of them in the interrupt handler.  In addition we may
+	 * only clear our own cpu bit from the mask.
+	 */
+	smp_wmb();
+
 	atomic_set(&data->refs, cpumask_weight(data->cpumask));
 
 	raw_spin_lock_irqsave(&call_function.lock, flags);
_

Patches currently in -mm which might be from anton@samba.org are

kernel-smpc-fix-smp_call_function_many-smp-race.patch
kernel-smpc-consolidate-writes-in-smp_call_function_interrupt.patch

