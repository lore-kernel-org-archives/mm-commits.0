From: akpm@linux-foundation.org
Subject: + mm-clear-n_cpu-from-node_states-at-cpu-offline.patch added to
 -mm tree
Date: Tue, 15 Oct 2013 14:44:06 -0700
Message-ID: <525db726.t551k1JqSnqrJrQN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54317 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933815Ab3JOVoH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Oct 2013 17:44:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, isimatu.yasuaki@jp.fujitsu.com, cl@linux.com, toshi.kani@hp.com

Subject: + mm-clear-n_cpu-from-node_states-at-cpu-offline.patch added to -mm tree
To: toshi.kani@hp.com,cl@linux.com,isimatu.yasuaki@jp.fujitsu.com
From: akpm@linux-foundation.org
Date: Tue, 15 Oct 2013 14:44:06 -0700


The patch titled
     Subject: mm: clear N_CPU from node_states at CPU offline
has been added to the -mm tree.  Its filename is
     mm-clear-n_cpu-from-node_states-at-cpu-offline.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-clear-n_cpu-from-node_states-at-cpu-offline.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-clear-n_cpu-from-node_states-at-cpu-offline.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
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

cpu-mem-hotplug-add-try_online_node-for-cpu_up.patch
mm-sparsemem-use-pages_per_section-to-remove-redundant-nr_pages-parameter.patch
mm-sparsemem-fix-a-bug-in-free_map_bootmem-when-config_sparsemem_vmemmap.patch
mm-sparsemem-fix-a-bug-in-free_map_bootmem-when-config_sparsemem_vmemmap-v2.patch
memblock-factor-out-of-top-down-allocation.patch
memblock-introduce-bottom-up-allocation-mode.patch
x86-mm-factor-out-of-top-down-direct-mapping-setup.patch
x86-mem-hotplug-support-initialize-page-tables-in-bottom-up.patch
x86-acpi-crash-kdump-do-reserve_crashkernel-after-srat-is-parsed.patch
mem-hotplug-introduce-movable_node-boot-option.patch
mm-set-n_cpu-to-node_states-during-boot.patch
mm-clear-n_cpu-from-node_states-at-cpu-offline.patch
linux-next.patch

