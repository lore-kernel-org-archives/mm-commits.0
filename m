From: akpm@linux-foundation.org
Subject: + cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process.patch added to -mm tree
Date: Mon, 14 May 2007 14:39:42 -0700
Message-ID: <200705142139.l4ELdgT5026838@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37841 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754512AbXENVkN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 May 2007 17:40:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: takeuchi_satoru@jp.fujitsu.com, ashok.raj@intel.com, ego@in.ibm.com, mingo@elte.hu, oleg@tv-sign.ru, rusty@rustcorp.com.au


The patch titled
     cpu hotplug: fix ksoftirqd termination on cpu hotplug with naughty realtime process
has been added to the -mm tree.  Its filename is
     cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cpu hotplug: fix ksoftirqd termination on cpu hotplug with naughty realtime process
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

Fix ksoftirqd termination on cpu hotplug with naughty real time process.

Assuming the following case:

 - Try to hot remove CPU2 from CPU1.
 - There is a real time process on CPU2, and that process doesn't sleep at all.
 - That rt process and ksoftirqd/2 is migrated to the CPU0

Then ksoftirqd/2 can't stop becasue that rt process runs everlastingly on
CPU0, and CPU1 waiting the ksoftirqd/2's termination hangs up.  To fix this
problem, set the priority of ksoftirqd/2 to max one before kthread_stop().

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Ashok Raj <ashok.raj@intel.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/softirq.c |    2 ++
 1 files changed, 2 insertions(+)

diff -puN kernel/softirq.c~cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process kernel/softirq.c
--- a/kernel/softirq.c~cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process
+++ a/kernel/softirq.c
@@ -590,6 +590,7 @@ static int __cpuinit cpu_callback(struct
 {
 	int hotcpu = (unsigned long)hcpu;
 	struct task_struct *p;
+	struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
 
 	switch (action) {
 	case CPU_UP_PREPARE:
@@ -618,6 +619,7 @@ static int __cpuinit cpu_callback(struct
 	case CPU_DEAD_FROZEN:
 		p = per_cpu(ksoftirqd, hotcpu);
 		per_cpu(ksoftirqd, hotcpu) = NULL;
+		sched_setscheduler(p, SCHED_FIFO, &param);
 		kthread_stop(p);
 		takeover_tasklets(hotcpu);
 		break;
_

Patches currently in -mm which might be from takeuchi_satoru@jp.fujitsu.com are

fix-stop_machine_run-problem-with-naughty-real-time-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process.patch
