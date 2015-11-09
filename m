From: akpm@linux-foundation.org
Subject: [to-be-updated]
 x86-numa-acpi-online-node-earlier-when-doing-cpu-hot-addition.patch removed from -mm tree
Date: Mon, 09 Nov 2015 13:52:28 -0800
Message-ID: <5641159c.kM7h0FAn1uuqO385%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60318 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbbKIVwa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 16:52:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jiang.liu@linux.intel.com, hpa@zytor.com, mgorman@suse.de, mingo@elte.hu, peterz@infradead.org, rafael.j.wysocki@intel.com, rientjes@google.com, tangchen@cn.fujitsu.com, tglx@linutronix.de, tj@kernel.org, tony.luck@intel.com, umgwanakikbuti@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: x86, NUMA, ACPI: online node earlier when doing CPU hot-addition
has been removed from the -mm tree.  Its filename was
     x86-numa-acpi-online-node-earlier-when-doing-cpu-hot-addition.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Jiang Liu <jiang.liu@linux.intel.com>
Subject: x86, NUMA, ACPI: online node earlier when doing CPU hot-addition

This is the third version to enable memoryless node support on x86
platforms.  The previous version (https://lkml.org/lkml/2014/7/11/75)
blindly replaces numa_node_id()/cpu_to_node() with numa_mem_id()/
cpu_to_mem().  That's not the right solution as pointed out by Tejun and
Peter due to:

1) We shouldn't shift the burden to normal slab users.
2) Details of memoryless node should be hidden in arch and mm code
   as much as possible.

After digging into more code and documentation, we found the rules to
deal with memoryless node should be:

1) Arch code should online corresponding NUMA node before onlining any
   CPU or memory, otherwise it may cause invalid memory access when
   accessing NODE_DATA(nid).
2) For normal memory allocations without __GFP_THISNODE setting in the
   gfp_flags, we should prefer numa_node_id()/cpu_to_node() instead of
   numa_mem_id()/cpu_to_mem() because the latter loses hardware topology
   information as pointed out by Tejun:
	   A - B - X - C - D
	Where X is the memless node.  numa_mem_id() on X would return
	either B or C, right?  If B or C can't satisfy the allocation,
	the allocator would fallback to A from B and D for C, both of
	which aren't optimal. It should first fall back to C or B
	respectively, which the allocator can't do anymoe because the
	information is lost when the caller side performs numa_mem_id().
3) For memory allocation with __GFP_THISNODE setting in gfp_flags,
   numa_node_id()/cpu_to_node() should be used if caller only wants to
   allocate from local memory, otherwise numa_mem_id()/cpu_to_mem()
   should be used if caller wants to allocate from the nearest node
   with memory.
4) numa_mem_id()/cpu_to_mem() should be used if caller wants to check
   whether a page is allocated from the nearest node.

Based on above rules, this patch set
1) Patch 1 is a bugfix to resolve a crash caused by socket hot-addition
2) Patch 2 replaces numa_mem_id() with numa_node_id() when __GFP_THISNODE
   isn't set in gfp_flags.
3) Patch 3-6 replaces numa_node_id()/cpu_to_node() with numa_mem_id()/
   cpu_to_mem() if caller wants to allocate from local node only.
4) Patch 7-9 enables support of memoryless node on x86.

With this patch set applied, on a system with two sockets enabled at boot,
one with memory and the other without memory, we got following numa
topology after boot:
root@bkd04sdp:~# numactl --hardware
available: 2 nodes (0-1)
node 0 cpus: 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44
node 0 size: 15940 MB
node 0 free: 15397 MB
node 1 cpus: 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59
node 1 size: 0 MB
node 1 free: 0 MB
node distances:
node   0   1
  0:  10  21
  1:  21  10

After hot-adding the third socket without memory, we got:
root@bkd04sdp:~# numactl --hardware
available: 3 nodes (0-2)
node 0 cpus: 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44
node 0 size: 15940 MB
node 0 free: 15142 MB
node 1 cpus: 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59
node 1 size: 0 MB
node 1 free: 0 MB
node 2 cpus:
node 2 size: 0 MB
node 2 free: 0 MB
node distances:
node   0   1   2
  0:  10  21  21
  1:  21  10  21
  2:  21  21  10



This patch (of 9):

With typical CPU hot-addition flow on x86, PCI host bridges embedded
in physical processor are always associated with NOMA_NO_NODE, which
may cause sub-optimal performance.

1) Handle CPU hot-addition notification
	acpi_processor_add()
		acpi_processor_get_info()
			acpi_processor_hotadd_init()
				acpi_map_lsapic()
1.a)					acpi_map_cpu2node()

2) Handle PCI host bridge hot-addition notification
	acpi_pci_root_add()
		pci_acpi_scan_root()
2.a)			if (node != NUMA_NO_NODE && !node_online(node)) node = NUMA_NO_NODE;

3) Handle memory hot-addition notification
	acpi_memory_device_add()
		acpi_memory_enable_device()
			add_memory()
3.a)				node_set_online();

4) Online CPUs through sysfs interfaces
	cpu_subsys_online()
		cpu_up()
			try_online_node()
4.a)				node_set_online();

So associated node is always in offline state because it is onlined
until step 3.a or 4.a.

We could improve performance by online node at step 1.a.  This change also
makes the code symmetric.  Nodes are always created when handling
CPU/memory hot-addition events instead of handling user requests from
sysfs interfaces, and are destroyed when handling CPU/memory hot-removal
events.

It also close a race window caused by kmalloc_node(cpu_to_node(cpu)),
which may cause system panic as below.
[ 3663.324476] BUG: unable to handle kernel paging request at 0000000000001f08
[ 3663.332348] IP: [<ffffffff81172219>] __alloc_pages_nodemask+0xb9/0x2d0
[ 3663.339719] PGD 82fe10067 PUD 82ebef067 PMD 0
[ 3663.344773] Oops: 0000 [#1] SMP
[ 3663.348455] Modules linked in: shpchp gpio_ich x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd microcode joydev sb_edac edac_core lpc_ich ipmi_si tpm_tis ipmi_msghandler ioatdma wmi acpi_pad mac_hid lp parport ixgbe isci mpt2sas dca ahci ptp libsas libahci raid_class pps_core scsi_transport_sas mdio hid_generic usbhid hid
[ 3663.394393] CPU: 61 PID: 2416 Comm: cron Tainted: G        W    3.14.0-rc5+ #21
[ 3663.402643] Hardware name: Intel Corporation BRICKLAND/BRICKLAND, BIOS BRIVTIN1.86B.0047.F03.1403031049 03/03/2014
[ 3663.414299] task: ffff88082fe54b00 ti: ffff880845fba000 task.ti: ffff880845fba000
[ 3663.422741] RIP: 0010:[<ffffffff81172219>]  [<ffffffff81172219>] __alloc_pages_nodemask+0xb9/0x2d0
[ 3663.432857] RSP: 0018:ffff880845fbbcd0  EFLAGS: 00010246
[ 3663.439265] RAX: 0000000000001f00 RBX: 0000000000000000 RCX: 0000000000000000
[ 3663.447291] RDX: 0000000000000000 RSI: 0000000000000a8d RDI: ffffffff81a8d950
[ 3663.455318] RBP: ffff880845fbbd58 R08: ffff880823293400 R09: 0000000000000001
[ 3663.463345] R10: 0000000000000001 R11: 0000000000000000 R12: 00000000002052d0
[ 3663.471363] R13: ffff880854c07600 R14: 0000000000000002 R15: 0000000000000000
[ 3663.479389] FS:  00007f2e8b99e800(0000) GS:ffff88105a400000(0000) knlGS:0000000000000000
[ 3663.488514] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3663.495018] CR2: 0000000000001f08 CR3: 00000008237b1000 CR4: 00000000001407e0
[ 3663.503476] Stack:
[ 3663.505757]  ffffffff811bd74d ffff880854c01d98 ffff880854c01df0 ffff880854c01dd0
[ 3663.514167]  00000003208ca420 000000075a5d84d0 ffff88082fe54b00 ffffffff811bb35f
[ 3663.522567]  ffff880854c07600 0000000000000003 0000000000001f00 ffff880845fbbd48
[ 3663.530976] Call Trace:
[ 3663.533753]  [<ffffffff811bd74d>] ? deactivate_slab+0x41d/0x4f0
[ 3663.540421]  [<ffffffff811bb35f>] ? new_slab+0x3f/0x2d0
[ 3663.546307]  [<ffffffff811bb3c5>] new_slab+0xa5/0x2d0
[ 3663.552001]  [<ffffffff81768c97>] __slab_alloc+0x35d/0x54a
[ 3663.558185]  [<ffffffff810a4845>] ? local_clock+0x25/0x30
[ 3663.564686]  [<ffffffff8177a34c>] ? __do_page_fault+0x4ec/0x5e0
[ 3663.571356]  [<ffffffff810b0054>] ? alloc_fair_sched_group+0xc4/0x190
[ 3663.578609]  [<ffffffff810c77f1>] ? __raw_spin_lock_init+0x21/0x60
[ 3663.585570]  [<ffffffff811be476>] kmem_cache_alloc_node_trace+0xa6/0x1d0
[ 3663.593112]  [<ffffffff810b0054>] ? alloc_fair_sched_group+0xc4/0x190
[ 3663.600363]  [<ffffffff810b0054>] alloc_fair_sched_group+0xc4/0x190
[ 3663.607423]  [<ffffffff810a359f>] sched_create_group+0x3f/0x80
[ 3663.613994]  [<ffffffff810b611f>] sched_autogroup_create_attach+0x3f/0x1b0
[ 3663.621732]  [<ffffffff8108258a>] sys_setsid+0xea/0x110
[ 3663.628020]  [<ffffffff8177f42d>] system_call_fastpath+0x1a/0x1f
[ 3663.634780] Code: 00 44 89 e7 e8 b9 f8 f4 ff 41 f6 c4 10 74 18 31 d2 be 8d 0a 00 00 48 c7 c7 50 d9 a8 81 e8 70 6a f2 ff e8 db dd 5f 00 48 8b 45 c8 <48> 83 78 08 00 0f 84 b5 01 00 00 48 83 c0 08 44 89 75 c0 4d 89
[ 3663.657032] RIP  [<ffffffff81172219>] __alloc_pages_nodemask+0xb9/0x2d0
[ 3663.664491]  RSP <ffff880845fbbcd0>
[ 3663.668429] CR2: 0000000000001f08
[ 3663.672659] ---[ end trace df13f08ed9de18ad ]---

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/acpi/boot.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN arch/x86/kernel/acpi/boot.c~x86-numa-acpi-online-node-earlier-when-doing-cpu-hot-addition arch/x86/kernel/acpi/boot.c
--- a/arch/x86/kernel/acpi/boot.c~x86-numa-acpi-online-node-earlier-when-doing-cpu-hot-addition
+++ a/arch/x86/kernel/acpi/boot.c
@@ -705,6 +705,11 @@ static void acpi_map_cpu2node(acpi_handl
 
 	nid = acpi_get_node(handle);
 	if (nid != -1) {
+		if (try_online_node(nid)) {
+			pr_warn("failed to online node%d for CPU%d, use node%d instead.\n",
+				nid, cpu, first_node(node_online_map));
+			nid = first_node(node_online_map);
+		}
 		set_apicid_to_node(physid, nid);
 		numa_set_node(cpu, nid);
 	}
_

Patches currently in -mm which might be from jiang.liu@linux.intel.com are

kernel-profilec-replace-cpu_to_mem-with-cpu_to_node.patch
sgi-xp-replace-cpu_to_node-with-cpu_to_mem-to-support-memoryless-node.patch
openvswitch-replace-cpu_to_node-with-cpu_to_mem-to-support-memoryless-node.patch
x86-numa-kill-useless-code-to-improve-code-readability.patch
mm-update-_mem_id_-for-every-possible-cpu-when-memory-configuration-changes.patch
mm-x86-enable-memoryless-node-support-to-better-support-cpu-memory-hotplug.patch

