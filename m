From: akpm@linux-foundation.org
Subject: [merged] mm-set-n_cpu-to-node_states-during-boot.patch removed
 from -mm tree
Date: Wed, 13 Nov 2013 12:39:06 -0800
Message-ID: <5283e36a.RsquOrWIIT67gOF4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42760 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab3KMUjH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:39:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, isimatu.yasuaki@jp.fujitsu.com, cl@linux.com, toshi.kani@hp.com

Subject: [merged] mm-set-n_cpu-to-node_states-during-boot.patch removed from -mm tree
To: toshi.kani@hp.com,cl@linux.com,isimatu.yasuaki@jp.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:39:06 -0800


The patch titled
     Subject: mm: set N_CPU to node_states during boot
has been removed from the -mm tree.  Its filename was
     mm-set-n_cpu-to-node_states-during-boot.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Tested-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
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

origin.patch
linux-next.patch

