From: akpm@linux-foundation.org
Subject: + mem-hotunplug-fix-kfree-of-bootmem-memory.patch added to -mm tree
Date: Wed, 24 Apr 2013 13:37:28 -0700
Message-ID: <20130424203729.06F4931C11E@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:52461 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757971Ab3DXUha (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Apr 2013 16:37:30 -0400
Received: by mail-vc0-f201.google.com with SMTP id hz11so241237vcb.0
        for <mm-commits@vger.kernel.org>; Wed, 24 Apr 2013 13:37:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: isimatu.yasuaki@jp.fujitsu.com, hannes@cmpxchg.org, linuxram@us.ibm.com, rientjes@google.com, toshi.kani@hp.com


The patch titled
     Subject: mem hotunplug: fix kfree() of bootmem memory
has been added to the -mm tree.  Its filename is
     mem-hotunplug-fix-kfree-of-bootmem-memory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: mem hotunplug: fix kfree() of bootmem memory

When hot removing memory presented at boot time, following messages are shown:

[  296.867031] ------------[ cut here ]------------
[  296.922273] kernel BUG at mm/slub.c:3409!
[  296.970229] invalid opcode: 0000 [#1] SMP
[  297.019453] Modules linked in: ebtable_nat ebtables xt_CHECKSUM iptable_mangle bridge stp llc ipmi_devintf ipmi_msghandler sunrpc ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables binfmt_misc vfat fat dm_mirror dm_region_hash dm_log dm_mod vhost_net macvtap macvlan tun uinput iTCO_wdt iTCO_vendor_support coretemp kvm_intel kvm crc32c_intel ghash_clmulni_intel microcode pcspkr sg i2c_i801 lpc_ich mfd_core igb i2c_algo_bit i2c_core e1000e ptp pps_core tpm_infineon ioatdma dca sr_mod cdrom sd_mod crc_t10dif usb_storage megaraid_sas lpfc scsi_transport_fc scsi_tgt scsi_mod
[  297.747808] CPU 0
[  297.769764] Pid: 5091, comm: kworker/0:2 Tainted: G        W    3.9.0-rc6+ #15
[  297.897917] RIP: 0010:[<ffffffff811c41d2>]  [<ffffffff811c41d2>] kfree+0x232/0x240
[  297.988634] RSP: 0018:ffff88084678d968  EFLAGS: 00010246
[  298.052196] RAX: 0060000000000400 RBX: ffff8987fffffea0 RCX: 0000000000000000
[  298.137595] RDX: ffffffff8107a5ae RSI: 0000000000000001 RDI: ffff8987fffffea0
[  298.222994] RBP: ffff88084678d998 R08: 0000000080000200 R09: 0000000000000001
[  298.308390] R10: 0000000000000000 R11: 0000000000000000 R12: 0000030000000000
[  298.393792] R13: ffffea061fffffc0 R14: 00000303ffffffff R15: 0000000000000080
[  298.479190] FS:  0000000000000000(0000) GS:ffff88085aa00000(0000) knlGS:0000000000000000
[  298.576030] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  298.644791] CR2: 00000000025d3f78 CR3: 0000000001c0c000 CR4: 00000000001407f0
[  298.730192] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  298.815590] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  298.900997] Process kworker/0:2 (pid: 5091, threadinfo ffff88084678c000, task ffff88083928ca80)
[  299.005121] Stack:
[  299.029156]  00000303ffffffff ffff8987fffffea0 0000030000000000 ffff8987fffffe90
[  299.118116]  00000303ffffffff 0000000000000080 ffff88084678d9c8 ffffffff8107a5d4
[  299.207084]  0000000030000000 ffff8987fffb2680 0000000000000080 0000000030000000
[  299.296045] Call Trace:
[  299.325288]  [<ffffffff8107a5d4>] __release_region+0xd4/0xe0
[  299.393020]  [<ffffffff811c96f2>] __remove_pages+0x52/0x110
[  299.459707]  [<ffffffff816ada89>] arch_remove_memory+0x89/0xd0
[  299.529505]  [<ffffffff816aec94>] remove_memory+0xc4/0x100
[  299.595145]  [<ffffffff814103c5>] acpi_memory_device_remove+0x6d/0xb1
[  299.672230]  [<ffffffff813cbfe3>] acpi_device_remove+0x89/0xab
[  299.742033]  [<ffffffff81479f4c>] __device_release_driver+0x7c/0xf0
[  299.817048]  [<ffffffff8147a0cf>] device_release_driver+0x2f/0x50
[  299.889972]  [<ffffffff813cce98>] acpi_bus_device_detach+0x6c/0x70
[  299.963938]  [<ffffffff813f80f6>] acpi_ns_walk_namespace+0x11a/0x250
[  300.039982]  [<ffffffff813cce2c>] ? power_state_show+0x36/0x36
[  300.109800]  [<ffffffff813cce2c>] ? power_state_show+0x36/0x36
[  300.179612]  [<ffffffff813f874d>] acpi_walk_namespace+0xee/0x137
[  300.251492]  [<ffffffff813ccecf>] acpi_bus_trim+0x33/0x7a
[  300.316089]  [<ffffffff816c182a>] ? mutex_lock_nested+0x4a/0x60
[  300.386927]  [<ffffffff813cdca6>] acpi_bus_hot_remove_device+0xc4/0x1a1
[  300.466096]  [<ffffffff813c8009>] acpi_os_execute_deferred+0x27/0x34
[  300.542137]  [<ffffffff81093467>] process_one_work+0x1f7/0x590
[  300.611940]  [<ffffffff810933f5>] ? process_one_work+0x185/0x590
[  300.683823]  [<ffffffff81094bba>] worker_thread+0x11a/0x370
[  300.750502]  [<ffffffff81094aa0>] ? manage_workers+0x180/0x180
[  300.820308]  [<ffffffff8109adfe>] kthread+0xee/0x100
[  300.879714]  [<ffffffff810e139b>] ? __lock_release+0x12b/0x190
[  300.949512]  [<ffffffff8109ad10>] ? __init_kthread_worker+0x70/0x70
[  301.024517]  [<ffffffff816cf32c>] ret_from_fork+0x7c/0xb0
[  301.089135]  [<ffffffff8109ad10>] ? __init_kthread_worker+0x70/0x70
[  301.164138] Code: 89 ef e8 c2 2c fb ff e9 0b ff ff ff 4d 8b 6d 30 e9 5c fe ff ff 4c 89 f1 48 89 da 4c 89 ee 4c 89 e7 e8 03 f9 ff ff e9 ec fe ff ff <0f> 0b eb fe 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 48 83 ec
[  301.397214] RIP  [<ffffffff811c41d2>] kfree+0x232/0x240
[  301.459855]  RSP <ffff88084678d968>
[  301.501675] ---[ end trace 8679967aa8606ed8 ]---

The reason why the messages are shown is to release a resource structure,
allocated by bootmem, by kfree(). So when we release a resource structure,
we should check whether it is allocated by bootmem or not.

But even if we know a resource structure is allocated by bootmem, we cannot
release it since SLxB cannot treat it. So for reusing a resource structure,
this patch remembers it by using bootmem_resource as follows:

When releasing a resource structure by free_resource(), free_resource() checks
whether the resource structure is allocated by bootmem or not. If it is
allocated by bootmem, free_resource() adds it to bootmem_resource. If it is
not allocated by bootmem, free_resource() release it by kfree().

And when getting a new resource structure by get_resource(), get_resource()
checks whether bootmem_resource has released resource structures or not. If
there is a released resource structure, get_resource() returns it. If there is
not a releaed resource structure, get_resource() returns new resource structure
allocated by kzalloc().

Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Reviewed-by: Toshi Kani <toshi.kani@hp.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Ram Pai <linuxram@us.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/resource.c |   68 +++++++++++++++++++++++++++++++++++---------
 1 file changed, 55 insertions(+), 13 deletions(-)

diff -puN kernel/resource.c~mem-hotunplug-fix-kfree-of-bootmem-memory kernel/resource.c
--- a/kernel/resource.c~mem-hotunplug-fix-kfree-of-bootmem-memory
+++ a/kernel/resource.c
@@ -21,6 +21,7 @@
 #include <linux/seq_file.h>
 #include <linux/device.h>
 #include <linux/pfn.h>
+#include <linux/mm.h>
 #include <asm/io.h>
 
 
@@ -50,6 +51,14 @@ struct resource_constraint {
 
 static DEFINE_RWLOCK(resource_lock);
 
+/*
+ * For memory hotplug, there is no way to free resource entries allocated
+ * by boot mem after the system is up. So for reusing the resource entry
+ * we need to remember the resource.
+ */
+static struct resource *bootmem_resource_free;
+static DEFINE_SPINLOCK(bootmem_resource_lock);
+
 static void *r_next(struct seq_file *m, void *v, loff_t *pos)
 {
 	struct resource *p = v;
@@ -151,6 +160,40 @@ __initcall(ioresources_init);
 
 #endif /* CONFIG_PROC_FS */
 
+static void free_resource(struct resource *res)
+{
+	if (!res)
+		return;
+
+	if (!PageSlab(virt_to_head_page(res))) {
+		spin_lock(&bootmem_resource_lock);
+		res->sibling = bootmem_resource_free;
+		bootmem_resource_free = res;
+		spin_unlock(&bootmem_resource_lock);
+	} else {
+		kfree(res);
+	}
+}
+
+static struct resource *get_resource(gfp_t flags)
+{
+	struct resource *res = NULL;
+
+	spin_lock(&bootmem_resource_lock);
+	if (bootmem_resource_free) {
+		res = bootmem_resource_free;
+		bootmem_resource_free = res->sibling;
+	}
+	spin_unlock(&bootmem_resource_lock);
+
+	if (res)
+		memset(res, 0, sizeof(struct resource));
+	else
+		res = kzalloc(sizeof(struct resource), flags);
+
+	return res;
+}
+
 /* Return the conflict entry if you can't request it */
 static struct resource * __request_resource(struct resource *root, struct resource *new)
 {
@@ -771,7 +814,7 @@ static void __init __reserve_region_with
 {
 	struct resource *parent = root;
 	struct resource *conflict;
-	struct resource *res = kzalloc(sizeof(*res), GFP_ATOMIC);
+	struct resource *res = get_resource(GFP_ATOMIC);
 	struct resource *next_res = NULL;
 
 	if (!res)
@@ -796,7 +839,7 @@ static void __init __reserve_region_with
 		/* conflict covered whole area */
 		if (conflict->start <= res->start &&
 				conflict->end >= res->end) {
-			kfree(res);
+			free_resource(res);
 			WARN_ON(next_res);
 			break;
 		}
@@ -806,10 +849,9 @@ static void __init __reserve_region_with
 			end = res->end;
 			res->end = conflict->start - 1;
 			if (conflict->end < end) {
-				next_res = kzalloc(sizeof(*next_res),
-						GFP_ATOMIC);
+				next_res = get_resource(GFP_ATOMIC);
 				if (!next_res) {
-					kfree(res);
+					free_resource(res);
 					break;
 				}
 				next_res->name = name;
@@ -899,7 +941,7 @@ struct resource * __request_region(struc
 				   const char *name, int flags)
 {
 	DECLARE_WAITQUEUE(wait, current);
-	struct resource *res = kzalloc(sizeof(*res), GFP_KERNEL);
+	struct resource *res = get_resource(GFP_KERNEL);
 
 	if (!res)
 		return NULL;
@@ -933,7 +975,7 @@ struct resource * __request_region(struc
 			continue;
 		}
 		/* Uhhuh, that didn't work out.. */
-		kfree(res);
+		free_resource(res);
 		res = NULL;
 		break;
 	}
@@ -967,7 +1009,7 @@ int __check_region(struct resource *pare
 		return -EBUSY;
 
 	release_resource(res);
-	kfree(res);
+	free_resource(res);
 	return 0;
 }
 EXPORT_SYMBOL(__check_region);
@@ -1007,7 +1049,7 @@ void __release_region(struct resource *p
 			write_unlock(&resource_lock);
 			if (res->flags & IORESOURCE_MUXED)
 				wake_up(&muxed_resource_wait);
-			kfree(res);
+			free_resource(res);
 			return;
 		}
 		p = &res->sibling;
@@ -1055,8 +1097,8 @@ int release_mem_region_adjustable(struct
 	if ((start < parent->start) || (end > parent->end))
 		return ret;
 
-	/* The kzalloc() result gets checked later */
-	new_res = kzalloc(sizeof(struct resource), GFP_KERNEL);
+	/* The get_resource() result gets checked later */
+	new_res = get_resource(GFP_KERNEL);
 
 	p = &parent->child;
 	write_lock(&resource_lock);
@@ -1083,7 +1125,7 @@ int release_mem_region_adjustable(struct
 		if (res->start == start && res->end == end) {
 			/* free the whole entry */
 			*p = res->sibling;
-			kfree(res);
+			free_resource(res);
 			ret = 0;
 		} else if (res->start == start && res->end != end) {
 			/* adjust the start */
@@ -1119,7 +1161,7 @@ int release_mem_region_adjustable(struct
 	}
 
 	write_unlock(&resource_lock);
-	kfree(new_res);
+	free_resource(new_res);
 	return ret;
 }
 #endif	/* CONFIG_MEMORY_HOTREMOVE */
_

Patches currently in -mm which might be from isimatu.yasuaki@jp.fujitsu.com are

linux-next.patch
x86-make-mem=-option-to-work-for-efi-platform.patch
resource-add-__adjust_resource-for-internal-use.patch
resource-add-release_mem_region_adjustable.patch
mm-change-__remove_pages-to-call-release_mem_region_adjustable.patch
mm-hotplug-avoid-compiling-memory-hotremove-functions-when-disabled.patch
firmware-memmap-fix-firmware_map_entry-leak.patch
numa-cpu-hotplug-change-links-of-cpu-and-node-when-changing-node-number-by-onlining-cpu.patch
mem-hotunplug-fix-kfree-of-bootmem-memory.patch
mem-hotunplug-fix-kfree-of-bootmem-memory-fix.patch

