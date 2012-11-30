From: akpm@linux-foundation.org
Subject: [merged] mm-vmemmap-fix-wrong-use-of-virt_to_page.patch removed from -mm tree
Date: Fri, 30 Nov 2012 13:28:59 -0800
Message-ID: <20121130212900.4254320004E__40856.311567086$1354310960$gmane$org@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:39772 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421Ab2K3V3E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 30 Nov 2012 16:29:04 -0500
Received: by mail-wg0-f74.google.com with SMTP id dt14so64539wgb.1
        for <mm-commits@vger.kernel.org>; Fri, 30 Nov 2012 13:29:02 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wujianguo@huawei.com, hannes@cmpxchg.org, isimatu.yasuaki@jp.fujitsu.com, jiang.liu@huawei.com, mhocko@suse.cz, stable@vger.kernel.org, wency@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmemmap: fix wrong use of virt_to_page
has been removed from the -mm tree.  Its filename was
     mm-vmemmap-fix-wrong-use-of-virt_to_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jianguo Wu <wujianguo@huawei.com>
Subject: mm/vmemmap: fix wrong use of virt_to_page

I enable CONFIG_DEBUG_VIRTUAL and CONFIG_SPARSEMEM_VMEMMAP, when doing
memory hotremove, there is a kernel BUG at arch/x86/mm/physaddr.c:20.

It is caused by free_section_usemap()->virt_to_page(), virt_to_page() is
only used for kernel direct mapping address, but sparse-vmemmap uses
vmemmap address, so it is going wrong here.

[  517.727381] ------------[ cut here ]------------
[  517.728851] kernel BUG at arch/x86/mm/physaddr.c:20!
[  517.728851] invalid opcode: 0000 [#1] SMP
[  517.740170] Modules linked in: acpihp_drv acpihp_slot edd cpufreq_conservativ
e cpufreq_userspace cpufreq_powersave acpi_cpufreq mperf fuse vfat fat loop dm_m
od coretemp kvm crc32c_intel ipv6 ixgbe igb iTCO_wdt i7core_edac edac_core pcspk
r iTCO_vendor_support ioatdma microcode joydev sr_mod i2c_i801 dca lpc_ich mfd_c
ore mdio tpm_tis i2c_core hid_generic tpm cdrom sg tpm_bios rtc_cmos button ext3
 jbd mbcache usbhid hid uhci_hcd ehci_hcd usbcore usb_common sd_mod crc_t10dif p
rocessor thermal_sys hwmon scsi_dh_alua scsi_dh_hp_sw scsi_dh_rdac scsi_dh_emc s
csi_dh ata_generic ata_piix libata megaraid_sas scsi_mod
[  517.740170] CPU 39
[  517.740170] Pid: 6454, comm: sh Not tainted 3.7.0-rc1-acpihp-final+ #45 QCI Q
SSC-S4R/QSSC-S4R
[  517.740170] RIP: 0010:[<ffffffff8103c908>]  [<ffffffff8103c908>] __phys_addr+
0x88/0x90
[  517.740170] RSP: 0018:ffff8804440d7c08  EFLAGS: 00010006
[  517.740170] RAX: 0000000000000006 RBX: ffffea0012000000 RCX: 000000000000002c

[  517.740170] RDX: 0000620012000000 RSI: 0000000000000000 RDI: ffffea0012000000

[  517.740170] RBP: ffff8804440d7c08 R08: 0070000000000400 R09: 0000000000488000

[  517.740170] R10: 0000000000000091 R11: 0000000000000001 R12: ffff88047fb87800

[  517.740170] R13: ffffea0000000000 R14: ffff88047ffb3440 R15: 0000000000480000

[  517.740170] FS:  00007f0462b49700(0000) GS:ffff8804570c0000(0000) knlGS:00000
00000000000
[  517.740170] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  517.740170] CR2: 00007f006dc5fd14 CR3: 0000000440e85000 CR4: 00000000000007e0

[  517.740170] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000

[  517.896799] DR3: 0000000000000000 DR6

Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Reviewd-by: Wen Congyang <wency@cn.fujitsu.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN mm/sparse.c~mm-vmemmap-fix-wrong-use-of-virt_to_page mm/sparse.c
--- a/mm/sparse.c~mm-vmemmap-fix-wrong-use-of-virt_to_page
+++ a/mm/sparse.c
@@ -617,7 +617,7 @@ static void __kfree_section_memmap(struc
 {
 	return; /* XXX: Not implemented yet */
 }
-static void free_map_bootmem(struct page *page, unsigned long nr_pages)
+static void free_map_bootmem(struct page *memmap, unsigned long nr_pages)
 {
 }
 #else
@@ -658,10 +658,11 @@ static void __kfree_section_memmap(struc
 			   get_order(sizeof(struct page) * nr_pages));
 }
 
-static void free_map_bootmem(struct page *page, unsigned long nr_pages)
+static void free_map_bootmem(struct page *memmap, unsigned long nr_pages)
 {
 	unsigned long maps_section_nr, removing_section_nr, i;
 	unsigned long magic;
+	struct page *page = virt_to_page(memmap);
 
 	for (i = 0; i < nr_pages; i++, page++) {
 		magic = (unsigned long) page->lru.next;
@@ -710,13 +711,10 @@ static void free_section_usemap(struct p
 	 */
 
 	if (memmap) {
-		struct page *memmap_page;
-		memmap_page = virt_to_page(memmap);
