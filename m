From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-vmstatc-set-n_cpu-to-node_states-during-boot.patch removed from -mm tree
Date: Tue, 15 Oct 2013 14:39:47 -0700
Message-ID: <525db623.bY6dFY8YbT3CmGu9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54286 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933181Ab3JOVjs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Oct 2013 17:39:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, isimatu.yasuaki@jp.fujitsu.com, cl@linux-foundation.org, toshi.kani@hp.com

Subject: [to-be-updated] mm-vmstatc-set-n_cpu-to-node_states-during-boot.patch removed from -mm tree
To: toshi.kani@hp.com,cl@linux-foundation.org,isimatu.yasuaki@jp.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 15 Oct 2013 14:39:47 -0700


The patch titled
     Subject: mm/vmstat.c: set N_CPU to node_states during boot
has been removed from the -mm tree.  Its filename was
     mm-vmstatc-set-n_cpu-to-node_states-during-boot.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Toshi Kani <toshi.kani@hp.com>
Subject: mm/vmstat.c: set N_CPU to node_states during boot

After a system booted, N_CPU is not set to any node as has_cpu shows an
empty line.

  # cat /sys/devices/system/node/has_cpu
  (show-empty-line)

setup_vmstat() registers its CPU notifier callback,
vmstat_cpuup_callback(), which marks N_CPU to a node when a CPU is put
into online.  However, setup_vmstat() is called after all CPUs are
launched in the boot sequence.

Change setup_vmstat() to mark N_CPU to the nodes with online
CPUs at boot.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/vmstat.c~mm-vmstatc-set-n_cpu-to-node_states-during-boot mm/vmstat.c
--- a/mm/vmstat.c~mm-vmstatc-set-n_cpu-to-node_states-during-boot
+++ a/mm/vmstat.c
@@ -1276,8 +1276,10 @@ static int __init setup_vmstat(void)
 
 	register_cpu_notifier(&vmstat_notifier);
 
-	for_each_online_cpu(cpu)
+	for_each_online_cpu(cpu) {
 		start_cpu_timer(cpu);
+		node_set_state(cpu_to_node(cpu), N_CPU);
+	}
 #endif
 #ifdef CONFIG_PROC_FS
 	proc_create("buddyinfo", S_IRUGO, NULL, &fragmentation_file_operations);
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
linux-next.patch

