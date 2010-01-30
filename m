From: akpm@linux-foundation.org
Subject: + sched-cpuacct-use-bigger-percpu-counter-batch-values-for-stats-counters.patch added to -mm tree
Date: Fri, 29 Jan 2010 16:35:34 -0800
Message-ID: <201001300035.o0U0ZYOa019115@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53329 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755081Ab0A3AgO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Jan 2010 19:36:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anton@samba.org, balbir@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu, peterz@infradead.org, schwidefsky@de.ibm.com, tony.luck@intel.com


The patch titled
     sched: cpuacct: use bigger percpu counter batch values for stats counters
has been added to the -mm tree.  Its filename is
     sched-cpuacct-use-bigger-percpu-counter-batch-values-for-stats-counters.patch

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
Subject: sched: cpuacct: use bigger percpu counter batch values for stats counters
From: Anton Blanchard <anton@samba.org>

When CONFIG_VIRT_CPU_ACCOUNTING and CONFIG_CGROUP_CPUACCT are enabled we
can call cpuacct_update_stats with values much larger than
percpu_counter_batch.  This means the call to percpu_counter_add will
always add to the global count which is protected by a spinlock and we end
up with a global spinlock in the scheduler.

Based on an idea by KOSAKI Motohiro, this patch scales the batch value by
cputime_one_jiffy such that we have the same batch limit as we would if
CONFIG_VIRT_CPU_ACCOUNTING was disabled.  His patch did this once at boot
but that initialisation happened too early on PowerPC (before time_init)
and it was never updated at runtime as a result of a hotplug cpu
add/remove.

This patch instead scales percpu_counter_batch by cputime_one_jiffy at
runtime, which keeps the batch correct even after cpu hotplug operations. 
We cap it at INT_MAX in case of overflow.

For architectures that do not support CONFIG_VIRT_CPU_ACCOUNTING,
cputime_one_jiffy is the constant 1 and gcc is smart enough to optimise
min(s32 percpu_counter_batch, INT_MAX) to just percpu_counter_batch at
least on x86 and PowerPC.  So there is no need to add an #ifdef.

On a 64 thread PowerPC box with CONFIG_VIRT_CPU_ACCOUNTING and
CONFIG_CGROUP_CPUACCT enabled, a context switch microbenchmark is 234x
faster and almost matches a CONFIG_CGROUP_CPUACCT disabled kernel:

CONFIG_CGROUP_CPUACCT disabled:		16906698 ctx switches/sec
CONFIG_CGROUP_CPUACCT enabled:		   61720 ctx switches/sec
CONFIG_CGROUP_CPUACCT + patch:		16663217 ctx switches/sec

Tested with:

wget http://ozlabs.org/~anton/junkcode/context_switch.c
make context_switch
for i in `seq 0 63`; do taskset -c $i ./context_switch & done
vmstat 1

Signed-off-by: Anton Blanchard <anton@samba.org>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Tested-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff -puN kernel/sched.c~sched-cpuacct-use-bigger-percpu-counter-batch-values-for-stats-counters kernel/sched.c
--- a/kernel/sched.c~sched-cpuacct-use-bigger-percpu-counter-batch-values-for-stats-counters
+++ a/kernel/sched.c
@@ -10898,12 +10898,30 @@ static void cpuacct_charge(struct task_s
 }
 
 /*
+ * When CONFIG_VIRT_CPU_ACCOUNTING is enabled one jiffy can be very large
+ * in cputime_t units. As a result, cpuacct_update_stats calls
+ * percpu_counter_add with values large enough to always overflow the
+ * per cpu batch limit causing bad SMP scalability.
+ *
+ * To fix this we scale percpu_counter_batch by cputime_one_jiffy so we
+ * batch the same amount of time with CONFIG_VIRT_CPU_ACCOUNTING disabled
+ * and enabled. We cap it at INT_MAX which is the largest allowed batch value.
+ */
+#ifdef CONFIG_SMP
+#define CPUACCT_BATCH	\
+	min_t(long, percpu_counter_batch * cputime_one_jiffy, INT_MAX)
+#else
+#define CPUACCT_BATCH	0
+#endif
+
+/*
  * Charge the system/user time to the task's accounting group.
  */
 static void cpuacct_update_stats(struct task_struct *tsk,
 		enum cpuacct_stat_index idx, cputime_t val)
 {
 	struct cpuacct *ca;
+	int batch = CPUACCT_BATCH;
 
 	if (unlikely(!cpuacct_subsys.active))
 		return;
@@ -10912,7 +10930,7 @@ static void cpuacct_update_stats(struct 
 	ca = task_ca(tsk);
 
 	do {
-		percpu_counter_add(&ca->cpustat[idx], val);
+		__percpu_counter_add(&ca->cpustat[idx], val, batch);
 		ca = ca->parent;
 	} while (ca);
 	rcu_read_unlock();
_

Patches currently in -mm which might be from anton@samba.org are

origin.patch
percpu_counter-make-__percpu_counter_add-an-inline-function-on-up.patch
sched-cpuacct-use-bigger-percpu-counter-batch-values-for-stats-counters.patch
zlib-make-new-optimized-inflate-endian-independent.patch

