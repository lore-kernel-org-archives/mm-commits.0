From: akpm@osdl.org
Subject: + call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed.patch added to -mm tree
Date: Tue, 09 Jan 2007 13:19:55 -0800
Message-ID: <200701092119.l09LJtU1015585@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44896 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932330AbXAIVUb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 9 Jan 2007 16:20:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: heiko.carstens@de.ibm.com, ego@in.ibm.com, oleg@tv-sign.ru, vatsa@in.ibm.com


The patch titled
     call cpu_chain with CPU_DOWN_FAILED if CPU_DOWN_PREPARE failed
has been added to the -mm tree.  Its filename is
     call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: call cpu_chain with CPU_DOWN_FAILED if CPU_DOWN_PREPARE failed
From: Heiko Carstens <heiko.carstens@de.ibm.com>

This makes cpu hotplug symmetrical: if CPU_UP_PREPARE fails we get
CPU_UP_CANCELED, so we can undo what ever happened on PREPARE.  The same
should happen for CPU_DOWN_PREPARE.

Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Gautham Shenoy <ego@in.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/cpu.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff -puN kernel/cpu.c~call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed kernel/cpu.c
--- a/kernel/cpu.c~call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed
+++ a/kernel/cpu.c
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
fix-sparsemem-on-cell.patch
ehca-avoid-crash-on-kthread_create-failure.patch
ehca-fix-memleak-on-module-unloading.patch
git-s390.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed.patch
