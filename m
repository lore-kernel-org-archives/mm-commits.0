From: akpm@linux-foundation.org
Subject: - usb-mem-leak-fixes-for-amd-5536-udc-high-full-speed-usb-device-controller-driver.patch removed from -mm tree
Date: Fri, 04 Apr 2008 12:00:33 -0700
Message-ID: <200804041900.m34J0XC3004278@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39522 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756226AbYDDTAo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2008 15:00:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.juhl@gmail.com, dbrownell@users.sourceforge.net, gregkh@suse.de, mm-commits@vger.kernel.org


The patch titled
     usb: mem leak fixes for AMD 5536 UDC high/full speed USB device controller driver
has been removed from the -mm tree.  Its filename was
     usb-mem-leak-fixes-for-amd-5536-udc-high-full-speed-usb-device-controller-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb: mem leak fixes for AMD 5536 UDC high/full speed USB device controller driver
From: Jesper Juhl <jesper.juhl@gmail.com>

In drivers/usb/gadget/amd5536udc.c::udc_pci_probe(), sizeof(struct udc)
storage is allocated for 'dev'.

There are many exit points from the function where 'dev' is not free'd but has
also not yet been used for anything.  The following patch free's 'dev' at the
return points where it has not yet been used.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/gadget/amd5536udc.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN drivers/usb/gadget/amd5536udc.c~usb-mem-leak-fixes-for-amd-5536-udc-high-full-speed-usb-device-controller-driver drivers/usb/gadget/amd5536udc.c
--- a/drivers/usb/gadget/amd5536udc.c~usb-mem-leak-fixes-for-amd-5536-udc-high-full-speed-usb-device-controller-driver
+++ a/drivers/usb/gadget/amd5536udc.c
@@ -3248,6 +3248,8 @@ static int udc_pci_probe(
 
 	/* pci setup */
 	if (pci_enable_device(pdev) < 0) {
+		kfree(dev);
+		dev = 0;
 		retval = -ENODEV;
 		goto finished;
 	}
@@ -3259,6 +3261,8 @@ static int udc_pci_probe(
 
 	if (!request_mem_region(resource, len, name)) {
 		dev_dbg(&pdev->dev, "pci device used already\n");
+		kfree(dev);
+		dev = 0;
 		retval = -EBUSY;
 		goto finished;
 	}
@@ -3267,18 +3271,24 @@ static int udc_pci_probe(
 	dev->virt_addr = ioremap_nocache(resource, len);
 	if (dev->virt_addr == NULL) {
 		dev_dbg(&pdev->dev, "start address cannot be mapped\n");
+		kfree(dev);
+		dev = 0;
 		retval = -EFAULT;
 		goto finished;
 	}
 
 	if (!pdev->irq) {
 		dev_err(&dev->pdev->dev, "irq not set\n");
+		kfree(dev);
+		dev = 0;
 		retval = -ENODEV;
 		goto finished;
 	}
 
 	if (request_irq(pdev->irq, udc_irq, IRQF_SHARED, name, dev) != 0) {
 		dev_dbg(&dev->pdev->dev, "request_irq(%d) fail\n", pdev->irq);
+		kfree(dev);
+		dev = 0;
 		retval = -EBUSY;
 		goto finished;
 	}
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

pci-hotplug-fix-leaks-in-ibm-hot-plug-controller-driver-ibmphp_init_devno.patch

