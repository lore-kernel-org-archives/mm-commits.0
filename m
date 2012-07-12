From: akpm@linux-foundation.org
Subject: [merged] memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer.patch removed from -mm tree
Date: Thu, 12 Jul 2012 12:36:03 -0700
Message-ID: <20120712193605.1BAC51E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:37916 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755751Ab2GLTgG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jul 2012 15:36:06 -0400
Received: by vbnl22 with SMTP id l22so265499vbn.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jul 2012 12:36:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jiang.liu@huawei.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org, qiuxishi@huawei.com, rientjes@google.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memory hotplug: fix invalid memory access caused by stale kswapd pointer
has been removed from the -mm tree.  Its filename was
     memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <jiang.liu@huawei.com>
Subject: memory hotplug: fix invalid memory access caused by stale kswapd pointer

kswapd_stop() is called to destroy the kswapd work thread when all memory
of a NUMA node has been offlined.  But kswapd_stop() only terminates the
work thread without resetting NODE_DATA(nid)->kswapd to NULL.  The stale
pointer will prevent kswapd_run() from creating a new work thread when
adding memory to the memory-less NUMA node again.  Eventually the stale
pointer may cause invalid memory access.

An example stack dump as below. It's reproduced with 2.6.32, but latest
kernel has the same issue.

BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<ffffffff81051a94>] exit_creds+0x12/0x78
PGD 0
Oops: 0000 [#1] SMP
last sysfs file: /sys/devices/system/memory/memory391/state
CPU 11
Modules linked in: cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq microcode fuse loop dm_mod tpm_tis rtc_cmos i2c_i801 rtc_core tpm serio_raw pcspkr sg tpm_bios igb i2c_core iTCO_wdt rtc_lib mptctl iTCO_vendor_support button dca bnx2 usbhid hid uhci_hcd ehci_hcd usbcore sd_mod crc_t10dif edd ext3 mbcache jbd fan ide_pci_generic ide_core ata_generic ata_piix libata thermal processor thermal_sys hwmon mptsas mptscsih mptbase scsi_transport_sas scsi_mod
Pid: 7949, comm: sh Not tainted 2.6.32.12-qiuxishi-5-default #92 Tecal RH2285
RIP: 0010:[<ffffffff81051a94>]  [<ffffffff81051a94>] exit_creds+0x12/0x78
RSP: 0018:ffff8806044f1d78  EFLAGS: 00010202
RAX: 0000000000000000 RBX: ffff880604f22140 RCX: 0000000000019502
RDX: 0000000000000000 RSI: 0000000000000202 RDI: 0000000000000000
RBP: ffff880604f22150 R08: 0000000000000000 R09: ffffffff81a4dc10
R10: 00000000000032a0 R11: ffff880006202500 R12: 0000000000000000
R13: 0000000000c40000 R14: 0000000000008000 R15: 0000000000000001
FS:  00007fbc03d066f0(0000) GS:ffff8800282e0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 000000060f029000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process sh (pid: 7949, threadinfo ffff8806044f0000, task ffff880603d7c600)
Stack:
 ffff880604f22140 ffffffff8103aac5 ffff880604f22140 ffffffff8104d21e
<0> ffff880006202500 0000000000008000 0000000000c38000 ffffffff810bd5b1
<0> 0000000000000000 ffff880603d7c600 00000000ffffdd29 0000000000000003
Call Trace:
 [<ffffffff8103aac5>] __put_task_struct+0x5d/0x97
 [<ffffffff8104d21e>] kthread_stop+0x50/0x58
 [<ffffffff810bd5b1>] offline_pages+0x324/0x3da
 [<ffffffff8121111f>] memory_block_change_state+0x179/0x1db
 [<ffffffff8121121f>] store_mem_state+0x9e/0xbb
 [<ffffffff8111a1f1>] sysfs_write_file+0xd0/0x107
 [<ffffffff810c7fe0>] vfs_write+0xad/0x169
 [<ffffffff810c8158>] sys_write+0x45/0x6e
 [<ffffffff8100296b>] system_call_fastpath+0x16/0x1b
 [<00007fbc0344df60>] 0x7fbc0344df60
Code: ff 4d 00 0f 94 c0 84 c0 74 08 48 89 ef e8 1f fd ff ff 5b 5d 31 c0 41 5c c3 53 48 8b 87 20 06 00 00 48 89 fb 48 8b bf 18 06 00 00 <8b> 00 48 c7 83 18 06 00 00 00 00 00 00 f0 ff 0f 0f 94 c0 84 c0
RIP  [<ffffffff81051a94>] exit_creds+0x12/0x78
 RSP <ffff8806044f1d78>
CR2: 0000000000000000

[akpm@linux-foundation.org: add pglist_data.kswapd locking comments]
Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: David Rientjes <rientjes@google.com>
Reviewed-by: Minchan Kim <minchan@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 +-
 mm/vmscan.c            |    7 +++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff -puN include/linux/mmzone.h~memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer include/linux/mmzone.h
--- a/include/linux/mmzone.h~memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer
+++ a/include/linux/mmzone.h
@@ -694,7 +694,7 @@ typedef struct pglist_data {
 					     range, including holes */
 	int node_id;
 	wait_queue_head_t kswapd_wait;
-	struct task_struct *kswapd;
+	struct task_struct *kswapd;	/* Protected by lock_memory_hotplug() */
 	int kswapd_max_order;
 	enum zone_type classzone_idx;
 } pg_data_t;
diff -puN mm/vmscan.c~memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer mm/vmscan.c
--- a/mm/vmscan.c~memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer
+++ a/mm/vmscan.c
@@ -2955,14 +2955,17 @@ int kswapd_run(int nid)
 }
 
 /*
- * Called by memory hotplug when all memory in a node is offlined.
+ * Called by memory hotplug when all memory in a node is offlined.  Caller must
+ * hold lock_memory_hotplug().
  */
 void kswapd_stop(int nid)
 {
 	struct task_struct *kswapd = NODE_DATA(nid)->kswapd;
 
-	if (kswapd)
+	if (kswapd) {
 		kthread_stop(kswapd);
+		NODE_DATA(nid)->kswapd = NULL;
+	}
 }
 
 static int __init kswapd_init(void)
_

Patches currently in -mm which might be from jiang.liu@huawei.com are

origin.patch
linux-next.patch
mm-hotplug-correctly-setup-fallback-zonelists-when-creating-new-pgdat.patch
mm-hotplug-correctly-add-new-zone-to-all-other-nodes-zone-lists.patch
mm-hotplug-free-zone-pageset-when-a-zone-becomes-empty.patch
mm-hotplug-mark-memory-hotplug-code-in-page_allocc-as-__meminit.patch

