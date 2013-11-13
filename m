From: akpm@linux-foundation.org
Subject: [merged] mm-clear-n_cpu-from-node_states-at-cpu-offline.patch
 removed from -mm tree
Date: Wed, 13 Nov 2013 12:39:08 -0800
Message-ID: <5283e36c.sRDP7LgSvD1P2ZNx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42763 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab3KMUjJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:39:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, isimatu.yasuaki@jp.fujitsu.com, cl@linux.com, toshi.kani@hp.com

Subject: [merged] mm-clear-n_cpu-from-node_states-at-cpu-offline.patch removed from -mm tree
To: toshi.kani@hp.com,cl@linux.com,isimatu.yasuaki@jp.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:39:08 -0800


The patch titled
     Subject: mm: clear N_CPU from node_states at CPU offline
has been removed from the -mm tree.  Its filename was
     mm-clear-n_cpu-from-node_states-at-cpu-offline.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Toshi Kani <toshi.kani@hp.com>
Subject: mm: clear N_CPU from node_states at CPU offline

vmstat_cpuup_callback() is a CPU notifier callback, which marks N_CPU to a
node at CPU online event.  However, it does not update this N_CPU info at
CPU offline event.

Changed vmstat_cpuup_callback() to clear N_CPU when the last CPU in the
node is put into offline, i.e.  the node no longer has any online CPU.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
Acked-by: Christoph Lameter <cl@linux.com>
Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Tested-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff -puN mm/vmstat.c~mm-clear-n_cpu-from-node_states-at-cpu-offline mm/vmstat.c
--- a/mm/vmstat.c~mm-clear-n_cpu-from-node_states-at-cpu-offline
+++ a/mm/vmstat.c
@@ -1229,6 +1229,20 @@ static void start_cpu_timer(int cpu)
 	schedule_delayed_work_on(cpu, work, __round_jiffies_relative(HZ, cpu));
 }
 
+static void vmstat_cpu_dead(int node)
+{
+	int cpu;
+
+	get_online_cpus();
+	for_each_online_cpu(cpu)
+		if (cpu_to_node(cpu) == node)
+			goto end;
+
+	node_clear_state(node, N_CPU);
+end:
+	put_online_cpus();
+}
+
 /*
  * Use the cpu notifier to insure that the thresholds are recalculated
  * when necessary.
@@ -1258,6 +1272,7 @@ static int vmstat_cpuup_callback(struct
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
 		refresh_zone_stat_thresholds();
+		vmstat_cpu_dead(cpu_to_node(cpu));
 		break;
 	default:
 		break;
_

Patches currently in -mm which might be from toshi.kani@hp.com are

origin.patch
linux-next.patch

