From: akpm@linux-foundation.org
Subject: [merged] sched-do-not-use-cpu_to_node-to-find-an-offlined-cpus-node.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:50:59 -0800
Message-ID: <20130225205100.0D1CB5A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:33135 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757943Ab3BYUvC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:51:02 -0500
Received: by mail-ve0-f202.google.com with SMTP id m1so346929ves.3
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:51:01 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tangchen@cn.fujitsu.com, hpa@zytor.com, isimatu.yasuaki@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, liuj97@gmail.com, mel@csn.ul.ie, minchan.kim@gmail.com, mingo@redhat.com, peterz@infradead.org, rientjes@google.com, tglx@linutronix.de, wency@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sched: do not use cpu_to_node() to find an offlined cpu's node.
has been removed from the -mm tree.  Its filename was
     sched-do-not-use-cpu_to_node-to-find-an-offlined-cpus-node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tang Chen <tangchen@cn.fujitsu.com>
Subject: sched: do not use cpu_to_node() to find an offlined cpu's node.

If a cpu is offline, its nid will be set to -1, and cpu_to_node(cpu) will
return -1.  As a result, cpumask_of_node(nid) will return NULL.  In this
case, find_next_bit() in for_each_cpu will get a NULL pointer and cause
panic.

Here is a call trace:
[  609.824017] Call Trace:
[  609.824017]  <IRQ>
[  609.824017]  [<ffffffff810b0721>] select_fallback_rq+0x71/0x190
[  609.824017]  [<ffffffff810b086e>] ? try_to_wake_up+0x2e/0x2f0
[  609.824017]  [<ffffffff810b0b0b>] try_to_wake_up+0x2cb/0x2f0
[  609.824017]  [<ffffffff8109da08>] ? __run_hrtimer+0x78/0x320
[  609.824017]  [<ffffffff810b0b85>] wake_up_process+0x15/0x20
[  609.824017]  [<ffffffff8109ce62>] hrtimer_wakeup+0x22/0x30
[  609.824017]  [<ffffffff8109da13>] __run_hrtimer+0x83/0x320
[  609.824017]  [<ffffffff8109ce40>] ? update_rmtp+0x80/0x80
[  609.824017]  [<ffffffff8109df56>] hrtimer_interrupt+0x106/0x280
[  609.824017]  [<ffffffff810a72c8>] ? sd_free_ctl_entry+0x68/0x70
[  609.824017]  [<ffffffff8167cf39>] smp_apic_timer_interrupt+0x69/0x99
[  609.824017]  [<ffffffff8167be2f>] apic_timer_interrupt+0x6f/0x80

There is a hrtimer process sleeping, whose cpu has already been offlined. 
When it is waken up, it tries to find another cpu to run, and get a -1
nid.  As a result, cpumask_of_node(-1) returns NULL, and causes ernel
panic.

This patch fixes this problem by judging if the nid is -1.  If nid is not
-1, a cpu on the same node will be picked.  Else, a online cpu on another
node will be picked.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jiang Liu <liuj97@gmail.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched/core.c |   28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff -puN kernel/sched/core.c~sched-do-not-use-cpu_to_node-to-find-an-offlined-cpus-node kernel/sched/core.c
--- a/kernel/sched/core.c~sched-do-not-use-cpu_to_node-to-find-an-offlined-cpus-node
+++ a/kernel/sched/core.c
@@ -1132,18 +1132,28 @@ EXPORT_SYMBOL_GPL(kick_process);
  */
 static int select_fallback_rq(int cpu, struct task_struct *p)
 {
-	const struct cpumask *nodemask = cpumask_of_node(cpu_to_node(cpu));
+	int nid = cpu_to_node(cpu);
+	const struct cpumask *nodemask = NULL;
 	enum { cpuset, possible, fail } state = cpuset;
 	int dest_cpu;
 
-	/* Look for allowed, online CPU in same node. */
-	for_each_cpu(dest_cpu, nodemask) {
-		if (!cpu_online(dest_cpu))
-			continue;
-		if (!cpu_active(dest_cpu))
-			continue;
-		if (cpumask_test_cpu(dest_cpu, tsk_cpus_allowed(p)))
-			return dest_cpu;
+	/*
+	 * If the node that the cpu is on has been offlined, cpu_to_node()
+	 * will return -1. There is no cpu on the node, and we should
+	 * select the cpu on the other node.
+	 */
+	if (nid != -1) {
+		nodemask = cpumask_of_node(nid);
+
+		/* Look for allowed, online CPU in same node. */
+		for_each_cpu(dest_cpu, nodemask) {
+			if (!cpu_online(dest_cpu))
+				continue;
+			if (!cpu_active(dest_cpu))
+				continue;
+			if (cpumask_test_cpu(dest_cpu, tsk_cpus_allowed(p)))
+				return dest_cpu;
+		}
 	}
 
 	for (;;) {
_

Patches currently in -mm which might be from tangchen@cn.fujitsu.com are

origin.patch
linux-next.patch

