From: akpm@linux-foundation.org
Subject: [merged]
 drivers-base-memoryc-fix-show_mem_removable-to-handle-missing-sections.patch removed from -mm tree
Date: Thu, 29 Aug 2013 12:43:01 -0700
Message-ID: <521fa445.tGACyZmbpfhzcFjq%akpm__33501.0647344918$1377805393$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36288 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756218Ab3H2TnC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Aug 2013 15:43:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghai@kernel.org, stable@vger.kernel.org, rafael.j.wysocki@intel.com, isimatu.yasuaki@jp.fujitsu.com, gregkh@linuxfoundation.org, rja@sgi.com

Subject: [merged] drivers-base-memoryc-fix-show_mem_removable-to-handle-missing-sections.patch removed from -mm tree
To: rja@sgi.com,gregkh@linuxfoundation.org,isimatu.yasuaki@jp.fujitsu.com,rafael.j.wysocki@intel.com,stable@vger.kernel.org,yinghai@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 29 Aug 2013 12:43:01 -0700


The patch titled
     Subject: drivers/base/memory.c: fix show_mem_removable() to handle missing sections
has been removed from the -mm tree.  Its filename was
     drivers-base-memoryc-fix-show_mem_removable-to-handle-missing-sections.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Russ Anderson <rja@sgi.com>
Subject: drivers/base/memory.c: fix show_mem_removable() to handle missing sections

"cat /sys/devices/system/memory/memory*/removable" crashed the system.

The problem is that show_mem_removable() is passing a
bad pfn to is_mem_section_removable(), which causes
if (!node_online(page_to_nid(page))) to blow up.
Why is it passing in a bad pfn?

show_mem_removable() will loop sections_per_block times.
sections_per_block is 16, but mem->section_count is 8,
indicating holes in this memory block.  Checking that
the memory section is present before checking to see
if the memory section is removable fixes the problem.

harp5-sys:~ # cat /sys/devices/system/memory/memory*/removable
0
1
1
1
1
1
1
1
1
1
1
1
1
1
[  372.111178] BUG: unable to handle kernel paging request at ffffea00c3200000
[  372.119230] IP: [<ffffffff81117ed1>] is_pageblock_removable_nolock+0x1/0x90
[  372.127022] PGD 83ffd4067 PUD 37bdfce067 PMD 0
[  372.132109] Oops: 0000 [#1] SMP
[  372.135730] Modules linked in: autofs4 binfmt_misc rdma_ucm rdma_cm iw_cm ib_addr ib_srp scsi_transport_srp scsi_tgt ib_ipoib ib_cm ib_uverbs ib_umad iw_cxgb3 cxgb3 mdio mlx4_en mlx4_ib ib_sa mlx4_core ib_mthca ib_mad ib_core fuse nls_iso8859_1 nls_cp437 vfat fat joydev loop hid_generic usbhid hid hwperf(O) numatools(O) dm_mod iTCO_wdt ipv6 iTCO_vendor_support igb i2c_i801 ioatdma i2c_algo_bit ehci_pci pcspkr lpc_ich i2c_core ehci_hcd ptp sg mfd_core dca rtc_cmos pps_core mperf button xhci_hcd sd_mod crc_t10dif usbcore usb_common scsi_dh_emc scsi_dh_hp_sw scsi_dh_alua scsi_dh_rdac scsi_dh gru(O) xvma(O) xfs crc32c libcrc32c thermal sata_nv processor piix mptsas mptscsih scsi_transport_sas mptbase megaraid_sas fan thermal_sys hwmon ext3 jbd ata_piix ahci libahci libata scsi_mod
[  372.213536] CPU: 4 PID: 5991 Comm: cat Tainted: G           O 3.11.0-rc5-rja-uv+ #10
[  372.222173] Hardware name: SGI UV2000/ROMLEY, BIOS SGI UV 2000/3000 series BIOS 01/15/2013
[  372.231391] task: ffff88081f034580 ti: ffff880820022000 task.ti: ffff880820022000
[  372.239737] RIP: 0010:[<ffffffff81117ed1>]  [<ffffffff81117ed1>] is_pageblock_removable_nolock+0x1/0x90
[  372.250229] RSP: 0018:ffff880820023df8  EFLAGS: 00010287
[  372.256151] RAX: 0000000000040000 RBX: ffffea00c3200000 RCX: 0000000000000004
[  372.264111] RDX: ffffea00c30b0000 RSI: 00000000001c0000 RDI: ffffea00c3200000
[  372.272071] RBP: ffff880820023e38 R08: 0000000000000000 R09: 0000000000000001
[  372.280030] R10: 0000000000000000 R11: 0000000000000001 R12: ffffea00c33c0000
[  372.287987] R13: 0000160000000000 R14: 6db6db6db6db6db7 R15: 0000000000000001
[  372.295945] FS:  00007ffff7fb2700(0000) GS:ffff88083fc80000(0000) knlGS:0000000000000000
[  372.304970] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  372.311378] CR2: ffffea00c3200000 CR3: 000000081b954000 CR4: 00000000000407e0
[  372.319335] Stack:
[  372.321575]  ffff880820023e38 ffffffff81161e94 ffffffff81d9e940 0000000000000009
[  372.329872]  0000000000000000 ffff8817bb97b800 ffff88081e928000 ffff8817bb97b870
[  372.338167]  ffff880820023e68 ffffffff813730d1 fffffffffffffffb ffffffff81a97600
[  372.346463] Call Trace:
[  372.349201]  [<ffffffff81161e94>] ? is_mem_section_removable+0x84/0x110
[  372.356579]  [<ffffffff813730d1>] show_mem_removable+0x41/0x70
[  372.363094]  [<ffffffff8135be8a>] dev_attr_show+0x2a/0x60
[  372.369122]  [<ffffffff811e1817>] sysfs_read_file+0xf7/0x1c0
[  372.375441]  [<ffffffff8116e7e8>] vfs_read+0xc8/0x130
[  372.381076]  [<ffffffff8116ee5d>] SyS_read+0x5d/0xa0
[  372.386624]  [<ffffffff814bfa12>] system_call_fastpath+0x16/0x1b
[  372.393313] Code: 01 00 00 00 e9 3c ff ff ff 90 0f b6 4a 30 44 89 d8 d3 e0 89 c1 83 e9 01 48 63 c9 49 01 c8 eb 92 66 2e 0f 1f 84 00 00 00 00 00 55 <48> 8b 0f 49 89 f8 48 89 e5 48 89 ca 48 c1 ea 36 0f a3 15 d8 2f
[  372.415032] RIP  [<ffffffff81117ed1>] is_pageblock_removable_nolock+0x1/0x90
[  372.422905]  RSP <ffff880820023df8>
[  372.426792] CR2: ffffea00c3200000

Signed-off-by: Russ Anderson <rja@sgi.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/base/memory.c~drivers-base-memoryc-fix-show_mem_removable-to-handle-missing-sections drivers/base/memory.c
--- a/drivers/base/memory.c~drivers-base-memoryc-fix-show_mem_removable-to-handle-missing-sections
+++ a/drivers/base/memory.c
@@ -141,6 +141,8 @@ static ssize_t show_mem_removable(struct
 		container_of(dev, struct memory_block, dev);
 
 	for (i = 0; i < sections_per_block; i++) {
+		if (!present_section_nr(mem->start_section_nr + i))
+			continue;
 		pfn = section_nr_to_pfn(mem->start_section_nr + i);
 		ret &= is_mem_section_removable(pfn, PAGES_PER_SECTION);
 	}
_

Patches currently in -mm which might be from rja@sgi.com are

origin.patch
memblock-numa-binary-search-node-id.patch

