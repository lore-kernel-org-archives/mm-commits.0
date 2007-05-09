From: akpm@linux-foundation.org
Subject: - call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed.patch removed from -mm tree
Date: Wed, 09 May 2007 14:51:29 -0700
Message-ID: <200705092151.l49LpT8l002883@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38690 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758580AbXEIVwC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:52:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko.carstens@de.ibm.com, ego@in.ibm.com, oleg@tv-sign.ru, vatsa@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     call cpu_chain with CPU_DOWN_FAILED if CPU_DOWN_PREPARE failed
has been removed from the -mm tree.  Its filename was
     call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: call cpu_chain with CPU_DOWN_FAILED if CPU_DOWN_PREPARE failed
From: Heiko Carstens <heiko.carstens@de.ibm.com>

This makes cpu hotplug symmetrical: if CPU_UP_PREPARE fails we get
CPU_UP_CANCELED, so we can undo what ever happened on PREPARE.  The same
should happen for CPU_DOWN_PREPARE.

[akpm@linux-foundation.org: fix for reduce-size-of-task_struct-on-64-bit-machines]
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Gautham Shenoy <ego@in.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpu.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff -puN kernel/cpu.c~call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed kernel/cpu.c
--- a/kernel/cpu.c~call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed
+++ a/kernel/cpu.c
@@ -97,7 +97,7 @@ static inline void check_for_tasks(int c
 		    (!cputime_eq(p->utime, cputime_zero) ||
 		     !cputime_eq(p->stime, cputime_zero)))
 			printk(KERN_WARNING "Task %s (pid = %d) is on cpu %d\
-				(state = %ld, flags = %lx) \n",
+				(state = %ld, flags = %x) \n",
 				 p->comm, p->pid, cpu, p->state, p->flags);
 	}
 	write_unlock_irq(&tasklist_lock);
@@ -122,9 +122,10 @@ static int take_cpu_down(void *unused)
 /* Requires cpu_add_remove_lock to be held */
 static int _cpu_down(unsigned int cpu)
 {
-	int err;
+	int err, nr_calls = 0;
 	struct task_struct *p;
 	cpumask_t old_allowed, tmp;
+	void *hcpu = (void *)(long)cpu;
 
 	if (num_online_cpus() == 1)
 		return -EBUSY;
@@ -132,11 +133,12 @@ static int _cpu_down(unsigned int cpu)
 	if (!cpu_online(cpu))
 		return -EINVAL;
 
-	raw_notifier_call_chain(&cpu_chain, CPU_LOCK_ACQUIRE,
-						(void *)(long)cpu);
-	err = raw_notifier_call_chain(&cpu_chain, CPU_DOWN_PREPARE,
-						(void *)(long)cpu);
+	raw_notifier_call_chain(&cpu_chain, CPU_LOCK_ACQUIRE, hcpu);
+	err = __raw_notifier_call_chain(&cpu_chain, CPU_DOWN_PREPARE,
+					hcpu, -1, &nr_calls);
 	if (err == NOTIFY_BAD) {
+		__raw_notifier_call_chain(&cpu_chain, CPU_DOWN_FAILED, hcpu,
+					  nr_calls, NULL);
 		printk("%s: attempt to take down CPU %u failed\n",
 				__FUNCTION__, cpu);
 		err = -EINVAL;
@@ -156,7 +158,7 @@ static int _cpu_down(unsigned int cpu)
 	if (IS_ERR(p) || cpu_online(cpu)) {
 		/* CPU didn't die: tell everyone.  Can't complain. */
 		if (raw_notifier_call_chain(&cpu_chain, CPU_DOWN_FAILED,
-				(void *)(long)cpu) == NOTIFY_BAD)
+					    hcpu) == NOTIFY_BAD)
 			BUG();
 
 		if (IS_ERR(p)) {
@@ -178,8 +180,7 @@ static int _cpu_down(unsigned int cpu)
 	put_cpu();
 
 	/* CPU is completely dead: tell everyone.  Too late to complain. */
-	if (raw_notifier_call_chain(&cpu_chain, CPU_DEAD,
-			(void *)(long)cpu) == NOTIFY_BAD)
+	if (raw_notifier_call_chain(&cpu_chain, CPU_DEAD, hcpu) == NOTIFY_BAD)
 		BUG();
 
 	check_for_tasks(cpu);
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

origin.patch
git-s390.patch
s390-spinlock-initializer-cleanup.patch
