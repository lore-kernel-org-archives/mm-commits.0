From: akpm@linux-foundation.org
Subject: + mm-set-n_cpu-to-node_states-during-boot.patch added to -mm tree
Date: Tue, 15 Oct 2013 14:44:05 -0700
Message-ID: <525db725.RosR8ZveGFOUfUR5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54310 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932802Ab3JOVoG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Oct 2013 17:44:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, isimatu.yasuaki@jp.fujitsu.com, cl@linux.com, toshi.kani@hp.com

Subject: + mm-set-n_cpu-to-node_states-during-boot.patch added to -mm tree
To: toshi.kani@hp.com,cl@linux.com,isimatu.yasuaki@jp.fujitsu.com
From: akpm@linux-foundation.org
Date: Tue, 15 Oct 2013 14:44:05 -0700


The patch titled
     Subject: mm: set N_CPU to node_states during boot
has been added to the -mm tree.  Its filename is
     mm-set-n_cpu-to-node_states-during-boot.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-set-n_cpu-to-node_states-during-boot.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-set-n_cpu-to-node_states-during-boot.patch

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
Subject: mm: set N_CPU to node_states during boot

After a system booted, N_CPU is not set to any node as has_cpu shows an
empty line.

  # cat /sys/devices/system/node/has_cpu
  (show-empty-line)

setup_vmstat() registers its CPU notifier callback,
vmstat_cpuup_callback(), which marks N_CPU to a node when a CPU is put
into online.  However, setup_vmstat() is called after all CPUs are
launched in the boot sequence.

Changed setup_vmstat() to mark N_CPU to the nodes with online CPUs at
boot, which is consistent with other operations in
vmstat_cpuup_callback(), i.e.  start_cpu_timer() and
refresh_zone_stat_thresholds().

Also added get_online_cpus() to protect the for_each_online_cpu() loop.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN mm/vmstat.c~mm-set-n_cpu-to-node_states-during-boot mm/vmstat.c
--- a/mm/vmstat.c~mm-set-n_cpu-to-node_states-during-boot
+++ a/mm/vmstat.c
@@ -1276,8 +1276,12 @@ static int __init setup_vmstat(void)
 
 	register_cpu_notifier(&vmstat_notifier);
 
-	for_each_online_cpu(cpu)
+	get_online_cpus();
+	for_each_online_cpu(cpu) {
 		start_cpu_timer(cpu);
+		node_set_state(cpu_to_node(cpu), N_CPU);
+	}
+	put_online_cpus();
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
mm-set-n_cpu-to-node_states-during-boot.patch
mm-clear-n_cpu-from-node_states-at-cpu-offline.patch
linux-next.patch

