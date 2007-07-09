From: akpm@linux-foundation.org
Subject: - serial-convert-early_uart-to-earlycon-for-8250-ia64-fix.patch removed from -mm tree
Date: Mon, 09 Jul 2007 13:25:14 -0700
Message-ID: <200707092025.l69KPFcs009243@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57653 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754210AbXGIUZ5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 16:25:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Yinghai.Lu@Sun.COM, ak@suse.de, bjorn.helgaas@hp.com, kraxel@suse.de, rmk@arm.linux.org.uk, yinghai.lu@Sun.COM, mm-commits@vger.kernel.org


The patch titled
     serial-convert-early_uart-to-earlycon-for-8250 ia64 fix
has been removed from the -mm tree.  Its filename was
     serial-convert-early_uart-to-earlycon-for-8250-ia64-fix.patch

This patch was dropped because it was folded into serial-convert-early_uart-to-earlycon-for-8250.patch

------------------------------------------------------
Subject: serial-convert-early_uart-to-earlycon-for-8250 ia64 fix
From: Yinghai Lu <Yinghai.Lu@Sun.COM>

ia64: add extra preferred console for HCDP serial console

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Gerd Hoffmann <kraxel@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/pcdp.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN drivers/firmware/pcdp.c~serial-convert-early_uart-to-earlycon-for-8250-ia64-fix drivers/firmware/pcdp.c
--- a/drivers/firmware/pcdp.c~serial-convert-early_uart-to-earlycon-for-8250-ia64-fix
+++ a/drivers/firmware/pcdp.c
@@ -42,6 +42,7 @@ setup_serial_console(struct pcdp_uart *u
 		}
 	}
 
+	add_preferred_console("uart", 8250, &options[9]);
 	return setup_early_serial8250_console(options);
 #else
 	return -ENODEV;
diff -puN /dev/null /dev/null
_

Patches currently in -mm which might be from Yinghai.Lu@Sun.COM are

serial-assert-dtr-for-serial-console-devices.patch
usb-make-the-usb_device-numa_node-to-get-assigned-from.patch
x86-64-disable-the-gart-in-shutdown.patch
x86_84-move-iommu-declaration-from-proto-to-iommuh.patch
x86_64-change-_map_single-to-static-in-pci_gartc-etc.patch
x86_64-geode-hw-random-number-generator-depend-on-x86_3.patch
x86_64-get-mp_bus_to_node-as-early.patch
console-more-buf-for-index-parsing.patch
console-console-handover-to-preferred-console.patch
serial-convert-early_uart-to-earlycon-for-8250.patch
serial-convert-early_uart-to-earlycon-for-8250-ia64-fix.patch
serial-convert-early_uart-to-earlycon-for-8250-fix-3-alias.patch
dma-make-dma-pool-to-use-kmalloc_node.patch
