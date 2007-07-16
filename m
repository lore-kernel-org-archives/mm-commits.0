From: akpm@linux-foundation.org
Subject: - cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:53:21 -0700
Message-ID: <200707162053.l6GKrLL1001619@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54690 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764141AbXGPVgq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:36:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: takeuchi_satoru@jp.fujitsu.com, ashok.raj@intel.com, ego@in.ibm.com, mingo@elte.hu, oleg@tv-sign.ru, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     cpu hotplug: fix ksoftirqd termination on cpu hotplug with naughty realtime process
has been removed from the -mm tree.  Its filename was
     cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[akpm@linux-foundation.org: fix warning]
Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Ashok Raj <ashok.raj@intel.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/softirq.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN kernel/softirq.c~cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process kernel/softirq.c
--- a/kernel/softirq.c~cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process
+++ a/kernel/softirq.c
@@ -614,12 +614,16 @@ static int __cpuinit cpu_callback(struct
 		kthread_bind(per_cpu(ksoftirqd, hotcpu),
 			     any_online_cpu(cpu_online_map));
 	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
+	case CPU_DEAD_FROZEN: {
+		struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
+
 		p = per_cpu(ksoftirqd, hotcpu);
 		per_cpu(ksoftirqd, hotcpu) = NULL;
+		sched_setscheduler(p, SCHED_FIFO, &param);
 		kthread_stop(p);
 		takeover_tasklets(hotcpu);
 		break;
+	}
 #endif /* CONFIG_HOTPLUG_CPU */
  	}
 	return NOTIFY_OK;
_

Patches currently in -mm which might be from takeuchi_satoru@jp.fujitsu.com are

origin.patch
