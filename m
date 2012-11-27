From: akpm@linux-foundation.org
Subject: [obsolete] cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved.patch removed from -mm tree
Date: Tue, 27 Nov 2012 11:59:54 -0800
Message-ID: <20121127195955.5DACB100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:60736 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754474Ab2K0T74 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Nov 2012 14:59:56 -0500
Received: by mail-qa0-f74.google.com with SMTP id g40so676018qab.1
        for <mm-commits@vger.kernel.org>; Tue, 27 Nov 2012 11:59:56 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wency@cn.fujitsu.com, hpa@zytor.com, len.brown@intel.com, mingo@redhat.com, pavel@ucw.cz, rientjes@google.com, rjw@sisk.pl, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: x86 cpu_hotplug: unmap cpu2node when the cpu is hotremoved
has been removed from the -mm tree.  Its filename was
     cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Wen Congyang <wency@cn.fujitsu.com>
Subject: x86 cpu_hotplug: unmap cpu2node when the cpu is hotremoved

When a cpu is hotplugged, we call acpi_map_cpu2node() in
_acpi_map_lsapic() to store the cpu's node.  But we don't clear the cpu's
node in acpi_unmap_lsapic() when this cpu is hotremoved.  If the node is
also hotremoved, We will get the following messages:

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

The reason is that: the cpu's node is not NUMA_NO_NODE, we will call
alloc_pages_exact_node() to alloc memory on the node, but the node is
offlined.

[akpm@linux-foundation.org: make acpi_unmap_lsapic __ref]
Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/acpi/boot.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN arch/x86/kernel/acpi/boot.c~cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved arch/x86/kernel/acpi/boot.c
--- a/arch/x86/kernel/acpi/boot.c~cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved
+++ a/arch/x86/kernel/acpi/boot.c
@@ -695,8 +695,13 @@ int __ref acpi_map_lsapic(acpi_handle ha
 }
 EXPORT_SYMBOL(acpi_map_lsapic);
 
-int acpi_unmap_lsapic(int cpu)
+int __ref acpi_unmap_lsapic(int cpu)
 {
+#ifdef CONFIG_ACPI_NUMA
+	set_apicid_to_node(per_cpu(x86_cpu_to_apicid, cpu), NUMA_NO_NODE);
+	numa_clear_node(cpu);
+#endif
+
 	per_cpu(x86_cpu_to_apicid, cpu) = -1;
 	set_cpu_present(cpu, false);
 	num_processors--;
_

Patches currently in -mm which might be from wency@cn.fujitsu.com are

mm-vmemmap-fix-wrong-use-of-virt_to_page.patch
linux-next.patch
x86-numa-dont-check-if-node-is-numa_no_node.patch
x86-make-mem=-option-to-work-for-efi-platform.patch
memory-hotplug-suppress-device-memoryx-does-not-have-a-release-function-warning.patch
memory-hotplug-skip-hwpoisoned-page-when-offlining-pages.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix.patch
memory-hotplug-auto-offline-page_cgroup-when-onlining-memory-block-failed.patch
memory-hotplug-fix-nr_free_pages-mismatch.patch
memory-hotplug-fix-nr_free_pages-mismatch-fix.patch
numa-convert-static-memory-to-dynamically-allocated-memory-for-per-node-device.patch
memory-hotplug-suppress-device-nodex-does-not-have-a-release-function-warning.patch
memory-hotplug-mm-sparsec-clear-the-memory-to-store-struct-page.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages-fix.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages-fix-2.patch
memory_hotplug-fix-possible-incorrect-node_states.patch
slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch
mm-memory_hotplugc-update-start_pfn-in-zone-and-pg_data-when-spanned_pages-==-0.patch
drivers-base-nodec-cleanup-node_state_attr.patch
mm-memory-hotplug-dynamic-configure-movable-memory-and-portion-memory.patch
mm-memory-hotplug-dynamic-configure-movable-memory-and-portion-memory-fix.patch
memory_hotplug-handle-empty-zone-when-online_movable-online_kernel.patch
memory_hotplug-ensure-every-online-node-has-normal-memory.patch
node_states-introduce-n_memory.patch
cpuset-use-n_memory-instead-n_high_memory.patch
procfs-use-n_memory-instead-n_high_memory.patch
memcontrol-use-n_memory-instead-n_high_memory.patch
oom-use-n_memory-instead-n_high_memory.patch
mmmigrate-use-n_memory-instead-n_high_memory.patch
mempolicy-use-n_memory-instead-n_high_memory.patch
hugetlb-use-n_memory-instead-n_high_memory.patch
vmstat-use-n_memory-instead-n_high_memory.patch
kthread-use-n_memory-instead-n_high_memory.patch
init-use-n_memory-instead-n_high_memory.patch
vmscan-use-n_memory-instead-n_high_memory.patch
page_alloc-use-n_memory-instead-n_high_memory-change-the-node_states-initialization.patch
hotplug-update-nodemasks-management.patch
numa-add-config_movable_node-for-movable-dedicated-node.patch
numa-add-config_movable_node-for-movable-dedicated-node-fix.patch
memory_hotplug-allow-online-offline-memory-to-result-movable-node.patch
mm-introduce-new-field-managed_pages-to-struct-zone.patch
documentation-kernel-parameterstxt-update-mem=-options-spec-according-to-its-implementation.patch

