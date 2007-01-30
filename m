From: akpm@osdl.org
Subject: + fix-i-oat-for-kexec.patch added to -mm tree
Date: Mon, 29 Jan 2007 17:11:59 -0800
Message-ID: <200701300111.l0U1BxPm005160@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36332 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752641AbXA3BMM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Jan 2007 20:12:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: da-x@monatomic.org, christopher.leech@intel.com, ebiederm@xmission.com, vgoyal@in.ibm.com


The patch titled
     fix I/OAT for kexec
has been added to the -mm tree.  Its filename is
     fix-i-oat-for-kexec.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix I/OAT for kexec
From: Dan Aloni <da-x@monatomic.org>

Under kexec, I/OAT initialization breaks over busy resources because the
previous kernel did not release them.

I'm not sure this fix can be considered a complete one but it works for me.
 I guess something similar to the *_remove method should occur there..

Signed-off-by: Dan Aloni <da-x@monatomic.org>
Cc: Chris Leech <christopher.leech@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Vivek Goyal <vgoyal@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/dma/ioatdma.c |   13 +++++++++++++
 1 files changed, 13 insertions(+)

diff -puN drivers/dma/ioatdma.c~fix-i-oat-for-kexec drivers/dma/ioatdma.c
--- a/drivers/dma/ioatdma.c~fix-i-oat-for-kexec
+++ a/drivers/dma/ioatdma.c
@@ -41,6 +41,7 @@
 
 /* internal functions */
 static int __devinit ioat_probe(struct pci_dev *pdev, const struct pci_device_id *ent);
+static void ioat_shutdown(struct pci_dev *pdev);
 static void __devexit ioat_remove(struct pci_dev *pdev);
 
 static int enumerate_dma_channels(struct ioat_device *device)
@@ -557,6 +558,7 @@ static struct pci_driver ioat_pci_drv = 
 	.name 	= "ioatdma",
 	.id_table = ioat_pci_tbl,
 	.probe	= ioat_probe,
+	.shutdown = ioat_shutdown,
 	.remove	= __devexit_p(ioat_remove),
 };
 
@@ -781,9 +783,20 @@ err_request_regions:
 err_set_dma_mask:
 	pci_disable_device(pdev);
 err_enable_device:
+
+	printk(KERN_ERR "Intel(R) I/OAT DMA Engine initialization failed\n");
+
 	return err;
 }
 
+static void ioat_shutdown(struct pci_dev *pdev)
+{
+	struct ioat_device *device;
+	device = pci_get_drvdata(pdev);
+
+	dma_async_device_unregister(&device->common);
+}
+
 static void __devexit ioat_remove(struct pci_dev *pdev)
 {
 	struct ioat_device *device;
_

Patches currently in -mm which might be from da-x@monatomic.org are

fix-i-oat-for-kexec.patch
