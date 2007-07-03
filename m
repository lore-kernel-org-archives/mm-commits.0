From: akpm@linux-foundation.org
Subject: + usb-make-the-usb_device-numa_node-to-get-assigned-from.patch added to -mm tree
Date: Tue, 03 Jul 2007 11:35:42 -0700
Message-ID: <200707031835.l63IZg4w008194@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53472 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755009AbXGCSg1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jul 2007 14:36:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Yinghai.Lu@Sun.COM, ak@suse.de, clameter@sgi.com, greg@kroah.com, rientjes@google.com, yinghai.lu@Sun.COM


The patch titled
     usb: make the usb_device numa_node get assigned from controller
has been added to the -mm tree.  Its filename is
     usb-make-the-usb_device-numa_node-to-get-assigned-from.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: usb: make the usb_device numa_node get assigned from controller
From: Yinghai Lu <Yinghai.Lu@Sun.COM>

So we can use dev_to_node(&usb_dev->dev) later in kmalloc_node to dma buffer

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/core/usb.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN drivers/usb/core/usb.c~usb-make-the-usb_device-numa_node-to-get-assigned-from drivers/usb/core/usb.c
--- a/drivers/usb/core/usb.c~usb-make-the-usb_device-numa_node-to-get-assigned-from
+++ a/drivers/usb/core/usb.c
@@ -253,6 +253,7 @@ usb_alloc_dev(struct usb_device *parent,
 	dev->dev.bus = &usb_bus_type;
 	dev->dev.type = &usb_device_type;
 	dev->dev.dma_mask = bus->controller->dma_mask;
+	set_dev_node(&dev->dev, dev_to_node(bus->controller));
 	dev->state = USB_STATE_ATTACHED;
 
 	INIT_LIST_HEAD(&dev->ep0.urb_list);
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
serial-convert-early_uart-to-earlycon-for-8250-fix.patch
serial-convert-early_uart-to-earlycon-for-8250-ia64-fix.patch
serial-convert-early_uart-to-earlycon-for-8250-fix-3-alias.patch
