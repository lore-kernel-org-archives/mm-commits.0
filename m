From: akpm@linux-foundation.org
Subject: + memory-hotplug-consider-compound-pages-when-free-memmap.patch added to -mm tree
Date: Tue, 22 Jan 2013 13:53:05 -0800
Message-ID: <20130122215305.F01E65A41B9@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:41970 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619Ab3AVVxH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Jan 2013 16:53:07 -0500
Received: by mail-qa0-f73.google.com with SMTP id a19so22662qad.2
        for <mm-commits@vger.kernel.org>; Tue, 22 Jan 2013 13:53:06 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wency@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, jiang.liu@huawei.com, kamezawa.hiroyu@jp.fujitsu.com, laijs@cn.fujitsu.com, tangchen@cn.fujitsu.com, wujianguo@huawei.com


The patch titled
     Subject: memory-hotplug: consider compound pages when free memmap
has been added to the -mm tree.  Its filename is
     memory-hotplug-consider-compound-pages-when-free-memmap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wen Congyang <wency@cn.fujitsu.com>
Subject: memory-hotplug: consider compound pages when free memmap

usemap could also be allocated as compound pages.  Should also consider
compound pages when freeing memmap.

If we don't fix it, there could be problems when we free vmemmap
pagetables which are stored in compound pages.  The old pagetables will
not be freed properly, and when we add the memory again, no new pagetable
will be created.  And the old pagetable entry is used, than the kernel
will panic.

The call trace is like the following:

[  691.175487] BUG: unable to handle kernel paging request at ffffea0040000000
[  691.258872] IP: [<ffffffff816a483f>] sparse_add_one_section+0xef/0x166
[  691.336971] PGD 7ff7d4067 PUD 78e035067 PMD 78e11d067 PTE 0
[  691.403952] Oops: 0002 [#1] SMP
[  691.442695] Modules linked in: ip6table_filter ip6_tables ebtable_nat ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle iptable_filter ip_tables bridge stp llc sunrpc binfmt_misc dm_mirror dm_region_hash dm_log dm_mod vhost_net macvtap macvlan tun uinput iTCO_wdt iTCO_vendor_support coretemp kvm_intel kvm crc32c_intel microcode pcspkr sg lpc_ich mfd_core i2c_i801 i2c_core i7core_edac edac_core ioatdma e1000e igb dca ptp pps_core sd_mod crc_t10dif megaraid_sas mptsas mptscsih mptbase scsi_transport_sas scsi_mod
[  692.042726] CPU 0
[  692.064641] Pid: 4, comm: kworker/0:0 Tainted: G        W 3.8.0-rc3-phy-hot-remove+ #3 FUJITSU-SV PRIMEQUEST 1800E/SB
[  692.196723] RIP: 0010:[<ffffffff816a483f>]  [<ffffffff816a483f>] sparse_add_one_section+0xef/0x166
[  692.303885] RSP: 0018:ffff8807bdcb35d8  EFLAGS: 00010006
[  692.367331] RAX: 0000000000000000 RBX: 0000000000000200 RCX: 0000000000200000
[  692.452578] RDX: ffff88078df01148 RSI: 0000000000000282 RDI: ffffea0040000000
[  692.537822] RBP: ffff8807bdcb3618 R08: 4cf05005b019467a R09: 0cd98fa09631467a
[  692.623071] R10: 0000000000000000 R11: 0000000000030e20 R12: 0000000000008000
[  692.708319] R13: ffffea0040000000 R14: ffff88078df66248 R15: ffff88078ea13b10
[  692.793562] FS:  0000000000000000(0000) GS:ffff8807c1a00000(0000) knlGS:0000000000000000
[  692.890233] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  692.958870] CR2: ffffea0040000000 CR3: 0000000001c0c000 CR4: 00000000000007f0
[  693.044119] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  693.129367] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  693.214617] Process kworker/0:0 (pid: 4, threadinfo ffff8807bdcb2000, task ffff8807bde18000)
[  693.315437] Stack:
[  693.339421]  0000000000000000 0000000000000282 0000000000000000 ffff88078df40f00
[  693.428208]  0000000000000001 0000000000000200 00000000000002ff 0000000000000200
[  693.516981]  ffff8807bdcb3668 ffffffff816940e5 0000000000000000 0000000001000000
[  693.605761] Call Trace:
[  693.634949]  [<ffffffff816940e5>] __add_pages+0x85/0x120
[  693.698398]  [<ffffffff8104f1d1>] arch_add_memory+0x71/0xf0
[  693.764960]  [<ffffffff81079bff>] ? request_resource_conflict+0x8f/0xa0
[  693.843982]  [<ffffffff81694796>] add_memory+0xd6/0x1f0
[  693.906393]  [<ffffffff814044df>] acpi_memory_device_add+0x170/0x20c
[  693.982302]  [<ffffffff813c1de2>] acpi_device_probe+0x50/0x18a
[  694.051977]  [<ffffffff8125a9d3>] ? sysfs_create_link+0x13/0x20
[  694.122691]  [<ffffffff8146c31c>] really_probe+0x6c/0x320
[  694.187170]  [<ffffffff8146c617>] driver_probe_device+0x47/0xa0
[  694.257885]  [<ffffffff8146c720>] ? __driver_attach+0xb0/0xb0
[  694.326521]  [<ffffffff8146c720>] ? __driver_attach+0xb0/0xb0
[  694.395157]  [<ffffffff8146c773>] __device_attach+0x53/0x60
[  694.461719]  [<ffffffff8146a34c>] bus_for_each_drv+0x6c/0xa0
[  694.529316]  [<ffffffff8146c298>] device_attach+0xa8/0xc0
[  694.593799]  [<ffffffff8146af70>] bus_probe_device+0xb0/0xe0
[  694.661398]  [<ffffffff814699c1>] device_add+0x301/0x570
[  694.724842]  [<ffffffff81469c4e>] device_register+0x1e/0x30
[  694.791403]  [<ffffffff813c354a>] acpi_device_register+0x1d8/0x27c
[  694.865230]  [<ffffffff813c37cd>] acpi_add_single_object+0x1df/0x2b9
[  694.941140]  [<ffffffff813fa078>] ? acpi_ut_release_mutex+0xac/0xb5
[  695.016009]  [<ffffffff813c39b9>] acpi_bus_check_add+0x112/0x18f
[  695.087764]  [<ffffffff810df61d>] ? trace_hardirqs_on+0xd/0x10
[  695.157445]  [<ffffffff810a1b0f>] ? up+0x2f/0x50
[  695.212585]  [<ffffffff813bdddb>] ? acpi_os_signal_semaphore+0x6b/0x74
[  695.290573]  [<ffffffff813ec519>] acpi_ns_walk_namespace+0x105/0x255
[  695.366478]  [<ffffffff813c38a7>] ? acpi_add_single_object+0x2b9/0x2b9
[  695.444459]  [<ffffffff813c38a7>] ? acpi_add_single_object+0x2b9/0x2b9
[  695.522439]  [<ffffffff813ecb6c>] acpi_walk_namespace+0xcf/0x118
[  695.594190]  [<ffffffff813c3a91>] acpi_bus_scan+0x5b/0x7c
[  695.658676]  [<ffffffff813c3b1e>] acpi_bus_add+0x2a/0x2c
[  695.722121]  [<ffffffff81402905>] container_notify_cb+0x112/0x1a9
[  695.794914]  [<ffffffff813d5859>] acpi_ev_notify_dispatch+0x46/0x61
[  695.869781]  [<ffffffff813be072>] acpi_os_execute_deferred+0x27/0x34
[  695.945687]  [<ffffffff81091c6e>] process_one_work+0x20e/0x5c0
[  696.015361]  [<ffffffff81091bff>] ? process_one_work+0x19f/0x5c0
[  696.087113]  [<ffffffff813be04b>] ? acpi_os_wait_events_complete+0x23/0x23
[  696.169248]  [<ffffffff81093d0e>] worker_thread+0x12e/0x370
[  696.235807]  [<ffffffff81093be0>] ? manage_workers+0x180/0x180
[  696.305485]  [<ffffffff81099e4e>] kthread+0xee/0x100
[  696.364773]  [<ffffffff810e1179>] ? __lock_release+0x129/0x190
[  696.434450]  [<ffffffff81099d60>] ? __init_kthread_worker+0x70/0x70
[  696.509317]  [<ffffffff816b34ac>] ret_from_fork+0x7c/0xb0
[  696.573799]  [<ffffffff81099d60>] ? __init_kthread_worker+0x70/0x70
[  696.648662] Code: 00 00 48 89 df 48 89 45 c8 e8 3e 71 b1 ff 48 89 c2 48 8b 75 c8 b8 ef ff ff ff f6 02 01 75 4b 49 63 cc 31 c0 4c 89 ef 48 c1 e1 06 <f3> aa 48 8b 02 48 83 c8 01 48 85 d2 48 89 02 74 29 a8 01 74 25
[  696.880997] RIP  [<ffffffff816a483f>] sparse_add_one_section+0xef/0x166
[  696.960128]  RSP <ffff8807bdcb35d8>
[  697.001768] CR2: ffffea0040000000
[  697.041336] ---[ end trace e7f94e3a34c442d4 ]---
[  697.096474] Kernel panic - not syncing: Fatal exception

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: Jianguo Wu <wujianguo@huawei.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/sparse.c~memory-hotplug-consider-compound-pages-when-free-memmap mm/sparse.c
--- a/mm/sparse.c~memory-hotplug-consider-compound-pages-when-free-memmap
+++ a/mm/sparse.c
@@ -698,7 +698,7 @@ static void free_section_usemap(struct p
 	/*
 	 * Check to see if allocation came from hot-plug-add
 	 */
-	if (PageSlab(usemap_page)) {
+	if (PageSlab(usemap_page) || PageCompound(usemap_page)) {
 		kfree(usemap);
 		if (memmap)
 			__kfree_section_memmap(memmap, PAGES_PER_SECTION);
_

Patches currently in -mm which might be from wency@cn.fujitsu.com are

x86-numa-dont-check-if-node-is-numa_no_node.patch
x86-fix-the-argument-passed-to-sync_global_pgds.patch
x86-make-mem=-option-to-work-for-efi-platform.patch
memory-hotplug-try-to-offline-the-memory-twice-to-avoid-dependence.patch
memory-hotplug-check-whether-all-memory-blocks-are-offlined-or-not-when-removing-memory.patch
memory-hotplug-remove-redundant-codes.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix-fix.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix-fix-fix.patch
memory-hotplug-introduce-new-arch_remove_memory-for-removing-page-table.patch
memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap.patch
memory-hotplug-move-pgdat_resize_lock-into-sparse_remove_one_section.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix-fix-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix-fix-fix-fix.patch
memory-hotplug-remove-page-table-of-x86_64-architecture.patch
memory-hotplug-remove-page-table-of-x86_64-architecture-fix.patch
memory-hotplug-remove-memmap-of-sparse-vmemmap.patch
memory-hotplug-integrated-__remove_section-of-config_sparsemem_vmemmap.patch
memory_hotplug-clear-zone-when-removing-the-memory.patch
memory-hotplug-remove-sysfs-file-of-node.patch
memory-hotplug-free-node_data-when-a-node-is-offlined.patch
memory-hotplug-do-not-allocate-pdgat-if-it-was-not-freed-when-offline.patch
memory-hotplug-consider-compound-pages-when-free-memmap.patch
mempolicy-fix-is_valid_nodemask.patch
cpu_hotplug-clear-apicid-to-node-when-the-cpu-is-hotremoved.patch
memory-hotplug-export-the-function-try_offline_node.patch
cpu-hotplug-memory-hotplug-try-offline-the-node-when-hotremoving-a-cpu.patch
cpu-hotplugmemory-hotplug-clear-cpu_to_node-when-offlining-the-node.patch
sched-do-not-use-cpu_to_node-to-find-an-offlined-cpus-node.patch
x86-get-pg_data_ts-memory-from-other-node.patch
page_alloc-add-movable_memmap-kernel-parameter.patch
page_alloc-introduce-zone_movable_limit-to-keep-movable-limit-for-nodes.patch
page_alloc-make-movablecore_map-has-higher-priority.patch
page_alloc-bootmem-limit-with-movablecore_map.patch
mm-use-zone-present_pages-instead-of-zone-managed_pages-where-appropriate.patch
mm-set-zone-present_pages-to-number-of-existing-pages-in-the-zone.patch
mm-increase-totalram_pages-when-free-pages-allocated-by-bootmem-allocator.patch

