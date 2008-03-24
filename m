From: akpm@linux-foundation.org
Subject: + usb-mem-leak-fixes-for-amd-5536-udc-high-full-speed-usb-device-controller-driver.patch added to -mm tree
Date: Mon, 24 Mar 2008 14:40:07 -0700
Message-ID: <200803242140.m2OLe7jD026535@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58547 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750772AbYCXVkt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Mar 2008 17:40:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesper.juhl@gmail.com, dbrownell@users.sourceforge.net, gregkh@suse.de


The patch titled
     usb: mem leak fixes for AMD 5536 UDC high/full speed USB device controller driver
has been added to the -mm tree.  Its filename is
     usb-mem-leak-fixes-for-amd-5536-udc-high-full-speed-usb-device-controller-driver.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

fix-small-mem-leak-in-driver_add_kobj.patch
usb-mem-leak-fixes-for-amd-5536-udc-high-full-speed-usb-device-controller-driver.patch

