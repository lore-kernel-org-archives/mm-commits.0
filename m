From: akpm@linux-foundation.org
Subject: - x86_64-get-mp_bus_to_node-as-early-v3-update.patch removed from -mm tree
Date: Tue, 11 Sep 2007 14:23:04 -0700
Message-ID: <200709112123.l8BLN5ph030127@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34834 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760390AbXIKVYX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Sep 2007 17:24:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Yinghai.Lu@Sun.COM, ak@suse.de, apw@shadowen.org, clameter@sgi.com, jeff@garzik.org, yinghai.lu@Sun.COM, mm-commits@vger.kernel.org


The patch titled
     x86_64-get-mp_bus_to_node-as-early-v3 update
has been removed from the -mm tree.  Its filename was
     x86_64-get-mp_bus_to_node-as-early-v3-update.patch

This patch was dropped because it was folded into x86_64-get-mp_bus_to_node-as-early-v3.patch

------------------------------------------------------
Subject: x86_64-get-mp_bus_to_node-as-early-v3 update
From: Yinghai Lu <Yinghai.Lu@Sun.COM>

It seem the one in -mm missed changes to irq.c

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/pci/irq.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletion(-)

diff -puN arch/i386/pci/irq.c~x86_64-get-mp_bus_to_node-as-early-v3-update arch/i386/pci/irq.c
--- a/arch/i386/pci/irq.c~x86_64-get-mp_bus_to_node-as-early-v3-update
+++ a/arch/i386/pci/irq.c
@@ -136,9 +136,11 @@ static void __init pirq_peer_trick(void)
 		busmap[e->bus] = 1;
 	}
 	for(i = 1; i < 256; i++) {
+		int node;
 		if (!busmap[i] || pci_find_bus(0, i))
 			continue;
-		if (pci_scan_bus_with_sysdata(i))
+		node = get_mp_bus_to_node(i);
+		if (pci_scan_bus_on_node(i, &pci_root_ops, node))
 			printk(KERN_INFO "PCI: Discovered primary peer "
 			       "bus %02x [IRQ]\n", i);
 	}
_

Patches currently in -mm which might be from Yinghai.Lu@Sun.COM are

serial-keep-the-dtr-setting-for-serial-console.patch
x86_64-get-mp_bus_to_node-as-early-v3.patch
x86_64-get-mp_bus_to_node-as-early-v3-update.patch
x86_64-use-bus-conf-in-nb-conf-fun1-to-get-bus-range-on-node.patch
try-parent-numa_node-at-first-before-using-default.patch
net-use-numa_node-in-net_devcice-dev-instead-of-parent.patch
dma-use-dev_to_node-to-get-node-for-device-in-dma_alloc_pages.patch
x86-make-io-apic-not-connected-pin-print-complete.patch
x86-use-num_online_nodes-to-get-physical-cpus-numbers-for.patch
