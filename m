From: akpm@linux-foundation.org
Subject: [merged] cpu_hotplug-clear-apicid-to-node-when-the-cpu-is-hotremoved.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:50:43 -0800
Message-ID: <20130225205044.1CABD5A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:46291 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757943Ab3BYUuq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:50:46 -0500
Received: by mail-qe0-f74.google.com with SMTP id 1so121744qee.5
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:50:45 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wency@cn.fujitsu.com, hpa@zytor.com, isimatu.yasuaki@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, liuj97@gmail.com, mel@csn.ul.ie, minchan.kim@gmail.com, mingo@redhat.com, peterz@infradead.org, rientjes@google.com, tangchen@cn.fujitsu.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: cpu_hotplug: clear apicid to node when the cpu is hotremoved
has been removed from the -mm tree.  Its filename was
     cpu_hotplug-clear-apicid-to-node-when-the-cpu-is-hotremoved.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wen Congyang <wency@cn.fujitsu.com>
Subject: cpu_hotplug: clear apicid to node when the cpu is hotremoved

When a cpu is hotpluged, we call acpi_map_cpu2node() in _acpi_map_lsapic()
to store the cpu's node and apicid's node.  But we don't clear the cpu's
node in acpi_unmap_lsapic() when this cpu is hotremoved.  If the node is
also hotremoved, we will get the following messages:

[ 1646.771485] kernel BUG at include/linux/gfp.h:329!
[ 1646.828729] invalid opcode: 0000 [#1] SMP
[ 1646.877872] Modules linked in: ebtable_nat ebtables ipt_MASQUERADE iptable_nat nf_nat xt_CHECKSUM iptable_mangle bridge stp llc sunrpc ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables binfmt_misc dm_mirror dm_region_hash dm_log dm_mod vhost_net macvtap macvlan tun uinput iTCO_wdt iTCO_vendor_support coretemp kvm_intel kvm crc32c_intel microcode pcspkr i2c_i801 i2c_core lpc_ich mfd_core ioatdma e1000e i7core_edac edac_core sg acpi_memhotplug igb dca sd_mod crc_t10dif megaraid_sas mptsas mptscsih mptbase scsi_transport_sas scsi_mod
[ 1647.588773] Pid: 3126, comm: init Not tainted 3.6.0-rc3-tangchen-hostbridge+ #13 FUJITSU-SV PRIMEQUEST 1800E/SB
[ 1647.711545] RIP: 0010:[<ffffffff811bc3fd>]  [<ffffffff811bc3fd>] allocate_slab+0x28d/0x300
[ 1647.810492] RSP: 0018:ffff88078a049cf8  EFLAGS: 00010246
[ 1647.874028] RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
[ 1647.959339] RDX: 0000000000000001 RSI: 0000000000000001 RDI: 0000000000000246
[ 1648.044659] RBP: ffff88078a049d38 R08: 00000000000040d0 R09: 0000000000000001
[ 1648.129953] R10: 0000000000000000 R11: 0000000000000b5f R12: 00000000000052d0
[ 1648.215259] R13: ffff8807c1417300 R14: 0000000000030038 R15: 0000000000000003
[ 1648.300572] FS:  00007fa9b1b44700(0000) GS:ffff8807c3800000(0000) knlGS:0000000000000000
[ 1648.397272] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1648.465985] CR2: 00007fa9b09acca0 CR3: 000000078b855000 CR4: 00000000000007e0
[ 1648.551265] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1648.636565] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1648.721838] Process init (pid: 3126, threadinfo ffff88078a048000, task ffff8807bb6f2650)
[ 1648.818534] Stack:
[ 1648.842548]  ffff8807c39d7fa0 ffffffff000040d0 00000000000000bb 00000000000080d0
[ 1648.931469]  ffff8807c1417300 ffff8807c39d7fa0 ffff8807c1417300 0000000000000001
[ 1649.020410]  ffff88078a049d88 ffffffff811bc4a0 ffff8807c1410c80 0000000000000000
[ 1649.109464] Call Trace:
[ 1649.138713]  [<ffffffff811bc4a0>] new_slab+0x30/0x1b0
[ 1649.199075]  [<ffffffff811bc978>] __slab_alloc+0x358/0x4c0
[ 1649.264683]  [<ffffffff810b71c0>] ? alloc_fair_sched_group+0xd0/0x1b0
[ 1649.341695]  [<ffffffff811be7d4>] kmem_cache_alloc_node_trace+0xb4/0x1e0
[ 1649.421824]  [<ffffffff8109d188>] ? hrtimer_init+0x48/0x100
[ 1649.488414]  [<ffffffff810b71c0>] ? alloc_fair_sched_group+0xd0/0x1b0
[ 1649.565402]  [<ffffffff810b71c0>] alloc_fair_sched_group+0xd0/0x1b0
[ 1649.640297]  [<ffffffff810a8bce>] sched_create_group+0x3e/0x110
[ 1649.711040]  [<ffffffff810bdbcd>] sched_autogroup_create_attach+0x4d/0x180
[ 1649.793260]  [<ffffffff81089614>] sys_setsid+0xd4/0xf0
[ 1649.854694]  [<ffffffff8167a029>] system_call_fastpath+0x16/0x1b
[ 1649.926483] Code: 89 c4 e9 73 fe ff ff 31 c0 89 de 48 c7 c7 45 de 9e 81 44 89 45 c8 e8 22 05 4b 00 85 db 44 8b 45 c8 0f 89 4f ff ff ff 0f 0b eb fe <0f> 0b 90 eb fd 0f 0b eb fe 89 de 48 c7 c7 45 de 9e 81 31 c0 44
[ 1650.161454] RIP  [<ffffffff811bc3fd>] allocate_slab+0x28d/0x300
[ 1650.232348]  RSP <ffff88078a049cf8>
[ 1650.274029] ---[ end trace adf84c90f3fea3e5 ]---

The reason is that the cpu's node is not NUMA_NO_NODE, we will call
alloc_pages_exact_node() to alloc memory on the node, but the node is
offlined.

If the node is onlined, we still need cpu's node.  For example: a task on
the cpu is sleeped when the cpu is hotremoved.  We will choose another cpu
to run this task when it is waked up.  If we know the cpu's node, we will
choose the cpu on the same node first.  So we should clear cpu-to-node
mapping when the node is offlined.

This patch only clears apicid-to-node mapping when the cpu is hotremoved.

[akpm@linux-foundation.org: fix section error]
Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
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

 arch/x86/kernel/acpi/boot.c |    4 ++++
 arch/x86/mm/numa.c          |    2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff -puN arch/x86/kernel/acpi/boot.c~cpu_hotplug-clear-apicid-to-node-when-the-cpu-is-hotremoved arch/x86/kernel/acpi/boot.c
--- a/arch/x86/kernel/acpi/boot.c~cpu_hotplug-clear-apicid-to-node-when-the-cpu-is-hotremoved
+++ a/arch/x86/kernel/acpi/boot.c
@@ -696,6 +696,10 @@ EXPORT_SYMBOL(acpi_map_lsapic);
 
 int acpi_unmap_lsapic(int cpu)
 {
+#ifdef CONFIG_ACPI_NUMA
+	set_apicid_to_node(per_cpu(x86_cpu_to_apicid, cpu), NUMA_NO_NODE);
+#endif
+
 	per_cpu(x86_cpu_to_apicid, cpu) = -1;
 	set_cpu_present(cpu, false);
 	num_processors--;
diff -puN arch/x86/mm/numa.c~cpu_hotplug-clear-apicid-to-node-when-the-cpu-is-hotremoved arch/x86/mm/numa.c
--- a/arch/x86/mm/numa.c~cpu_hotplug-clear-apicid-to-node-when-the-cpu-is-hotremoved
+++ a/arch/x86/mm/numa.c
@@ -56,7 +56,7 @@ early_param("numa", numa_setup);
 /*
  * apicid, cpu, node mappings
  */
-s16 __apicid_to_node[MAX_LOCAL_APIC] __cpuinitdata = {
+s16 __apicid_to_node[MAX_LOCAL_APIC] = {
 	[0 ... MAX_LOCAL_APIC-1] = NUMA_NO_NODE
 };
 
_

Patches currently in -mm which might be from wency@cn.fujitsu.com are

origin.patch
x86-numa-dont-check-if-node-is-numa_no_node.patch
x86-make-mem=-option-to-work-for-efi-platform.patch

