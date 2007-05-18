From: akpm@linux-foundation.org
Subject: - fix-kmalloc0-in-arch-ia64-pci-pcic.patch removed from -mm tree
Date: Thu, 17 May 2007 18:29:49 -0700
Message-ID: <200705180129.l4I1TnTX005141@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44139 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755362AbXERBbY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 May 2007 21:31:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     fix kmalloc(0) in arch/ia64/pci/pci.c
has been removed from the -mm tree.  Its filename was
     fix-kmalloc0-in-arch-ia64-pci-pcic.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
Subject: fix kmalloc(0) in arch/ia64/pci/pci.c
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Fix following kmalloc(0) message. patch is agaisnt 2.6.22-rc1-mm1.

==
BUG: at mm/slab.c:792 __find_general_cachep()

Call Trace:
 [<a000000100013f20>] show_stack+0x40/0xa0
                                sp=e000014042227b00 bsp=e000014042220f90
 [<a000000100013fb0>] dump_stack+0x30/0x60
                                sp=e000014042227cd0 bsp=e000014042220f78
 [<a00000010014fe10>] kmem_find_general_cachep+0x90/0x140
                                sp=e000014042227cd0 bsp=e000014042220f48
 [<a0000001001504f0>] __kmalloc_node+0x30/0xa0
                                sp=e000014042227cd0 bsp=e000014042220f18
 [<a0000001004eb700>] pci_acpi_scan_root+0x180/0x4a0
                                sp=e000014042227cd0 bsp=e000014042220ed0
 [<a000000100361140>] acpi_pci_root_add+0x4e0/0x700
                                sp=e000014042227cf0 bsp=e000014042220e90
 [<a00000010035b240>] acpi_device_probe+0xa0/0x160
                                sp=e000014042227d10 bsp=e000014042220e58
 [<a0000001003e4550>] driver_probe_device+0x250/0x380
                                sp=e000014042227d10 bsp=e000014042220e18
 [<a0000001003e4900>] __driver_attach+0xc0/0x160
                                sp=e000014042227d10 bsp=e000014042220de0
 [<a0000001003e2980>] bus_for_each_dev+0x80/0x100
                                sp=e000014042227d10 bsp=e000014042220da8
 [<a0000001003e4120>] driver_attach+0x40/0x60
                                sp=e000014042227d30 bsp=e000014042220d88
 [<a0000001003e3170>] bus_add_driver+0xf0/0x3c0
                                sp=e000014042227d30 bsp=e000014042220d48
 [<a0000001003e4e00>] driver_register+0x140/0x160
                                sp=e000014042227d30 bsp=e000014042220d28
 [<a00000010035ded0>] acpi_bus_register_driver+0x50/0x80
                                sp=e000014042227d30 bsp=e000014042220d08
 [<a0000001007d6000>] acpi_pci_root_init+0x20/0x60
                                sp=e000014042227d30 bsp=e000014042220cf0
 [<a0000001007a46b0>] kernel_init+0x450/0x7c0
                                sp=e000014042227d30 bsp=e000014042220ca8
 [<a000000100012550>] kernel_thread_helper+0x30/0x60
                                sp=e000014042227e30 bsp=e000014042220c80
 [<a0000001000090c0>] start_kernel_thread+0x20/0x40
                                sp=e000014042227e30 bsp=e000014042220c80
==

Fix kmalloc(0)

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/pci/pci.c |    2 ++
 1 files changed, 2 insertions(+)

diff -puN arch/ia64/pci/pci.c~fix-kmalloc0-in-arch-ia64-pci-pcic arch/ia64/pci/pci.c
--- a/arch/ia64/pci/pci.c~fix-kmalloc0-in-arch-ia64-pci-pcic
+++ a/arch/ia64/pci/pci.c
@@ -354,6 +354,8 @@ pci_acpi_scan_root(struct acpi_device *d
 
 	acpi_walk_resources(device->handle, METHOD_NAME__CRS, count_window,
 			&windows);
+	if (!windows)
+		goto out2;
 	controller->window = kmalloc_node(sizeof(*controller->window) * windows,
 			GFP_KERNEL, controller->node);
 	if (!controller->window)
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

fix-kmalloc0-in-arch-ia64-pci-pcic.patch
change-zonelist-order-zonelist-order-selection-logic.patch
change-zonelist-order-zonelist-order-selection-logic-add-check_highest_zone-to-build_zonelists_in_zone_order.patch
change-zonelist-order-v6-zonelist-fix.patch
change-zonelist-order-v6-zonelist-fix-2.patch
change-zonelist-order-auto-configuration.patch
change-zonelist-order-documentaion.patch
