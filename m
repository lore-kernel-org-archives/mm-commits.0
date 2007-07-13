From: akpm@linux-foundation.org
Subject: - fix-i-oat-for-kexec.patch removed from -mm tree
Date: Fri, 13 Jul 2007 15:33:06 -0700
Message-ID: <200707132233.l6DMX6oG025052@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52662 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934655AbXGMWpY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 18:45:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: da-x@monatomic.org, christopher.leech@intel.com, ebiederm@xmission.com, shannon.nelson@intel.com, vgoyal@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     fix I/OAT for kexec
has been removed from the -mm tree.  Its filename was
     fix-i-oat-for-kexec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/ioatdma.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN drivers/dma/ioatdma.c~fix-i-oat-for-kexec drivers/dma/ioatdma.c
--- a/drivers/dma/ioatdma.c~fix-i-oat-for-kexec
+++ a/drivers/dma/ioatdma.c
@@ -42,6 +42,7 @@
 
 /* internal functions */
 static int __devinit ioat_probe(struct pci_dev *pdev, const struct pci_device_id *ent);
+static void ioat_shutdown(struct pci_dev *pdev);
 static void __devexit ioat_remove(struct pci_dev *pdev);
 
 static int enumerate_dma_channels(struct ioat_device *device)
@@ -518,6 +519,7 @@ static struct pci_driver ioat_pci_driver
 	.name 	= "ioatdma",
 	.id_table = ioat_pci_tbl,
 	.probe	= ioat_probe,
+	.shutdown = ioat_shutdown,
 	.remove	= __devexit_p(ioat_remove),
 };
 
@@ -754,9 +756,20 @@ err_request_regions:
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

origin.patch
drivers-acpi-pci_linkc-lower-printk-severity.patch
arch-x86_64-kernel-processc-lower-printk-severity.patch
arch-x86_64-kernel-aperturec-lower-printk-severity.patch
arch-x86_64-kernel-e820c-lower-printk-severity.patch
mm-page_allocc-lower-printk-severity.patch
drivers-char-ipmi-ipmi_poweroffc-lower-printk-severity.patch
drivers-char-ipmi-ipmi_si_intfc-lower-printk-severity.patch
drivers-block-rdc-lower-printk-severity.patch
