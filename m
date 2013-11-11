From: akpm@linux-foundation.org
Subject: [merged]
 drivers-pci-pci-driverc-warn-on-driver-probe-return-value-greater-than-zero.patch removed from -mm tree
Date: Mon, 11 Nov 2013 10:44:06 -0800
Message-ID: <52812576.ame11lmkmlPpOgZv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50201 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821Ab3KKSoH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Nov 2013 13:44:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, greg@kroah.com, bhelgaas@google.com, axboe@kernel.dk, scameron@beardog.cce.hp.com

Subject: [merged] drivers-pci-pci-driverc-warn-on-driver-probe-return-value-greater-than-zero.patch removed from -mm tree
To: scameron@beardog.cce.hp.com,axboe@kernel.dk,bhelgaas@google.com,greg@kroah.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 11 Nov 2013 10:44:06 -0800


The patch titled
     Subject: drivers/pci/pci-driver.c: warn on driver probe return value greater than zero
has been removed from the -mm tree.  Its filename was
     drivers-pci-pci-driverc-warn-on-driver-probe-return-value-greater-than-zero.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Subject: drivers/pci/pci-driver.c: warn on driver probe return value greater than zero

Ages ago, drivers could return values greater than zero from their probe
function and this would be regarded as success.  Commit f3ec4f87d607f40497
"PCI: change device runtime PM settings for probe and remove" slightly
altered this in 2010, and commit 967577b062417b4e4b8e27b ("PCI/PM: Keep
runtime PM enabled for unbound PCI devices") in late 2012 altered it more
signficantly, setting pci_dev->driver to NULL if the driver's probe
function returned a value greater than zero, which would for example
prevent the driver's remove function from being called on rmmod.

Neither of those changes would necessarily make the driver fail in an
obvious way though, and so at least a couple drivers (cciss, hpsa) fell
into this hole since they were returning 1, and this situation went
unnoticed for quite some time.

If a driver's probe function returns a value greater than zero, issue a
warning, but otherwise treat this as success.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/pci-driver.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN drivers/pci/pci-driver.c~drivers-pci-pci-driverc-warn-on-driver-probe-return-value-greater-than-zero drivers/pci/pci-driver.c
--- a/drivers/pci/pci-driver.c~drivers-pci-pci-driverc-warn-on-driver-probe-return-value-greater-than-zero
+++ a/drivers/pci/pci-driver.c
@@ -267,11 +267,19 @@ static long local_pci_probe(void *_ddi)
 	pm_runtime_get_sync(dev);
 	pci_dev->driver = pci_drv;
 	rc = pci_drv->probe(pci_dev, ddi->id);
-	if (rc) {
+	if (!rc)
+		return rc;
+	if (rc < 0) {
 		pci_dev->driver = NULL;
 		pm_runtime_put_sync(dev);
+		return rc;
 	}
-	return rc;
+	/*
+	 * Probe function should return < 0 for failure, 0 for success
+	 * Treat values > 0 as success, but warn.
+	 */
+	dev_warn(dev, "Driver probe function unexpectedly returned %d\n", rc);
+	return 0;
 }
 
 static int pci_call_probe(struct pci_driver *drv, struct pci_dev *dev,
_

Patches currently in -mm which might be from scameron@beardog.cce.hp.com are

hpsa-return-0-from-driver-probe-function-on-success-not-1.patch
drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch
linux-next.patch

