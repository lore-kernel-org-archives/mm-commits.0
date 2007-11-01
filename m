From: akpm@linux-foundation.org
Subject: - pciserial_resume_one-ignored-return-value-of-pci_enable_device.patch removed from -mm tree
Date: Thu, 01 Nov 2007 16:24:51 -0700
Message-ID: <200711012325.lA1NPDHH020981@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33302 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753802AbXKAXZa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Nov 2007 19:25:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hohndel@linux.intel.com, alan@redhat.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     pciserial_resume_one() ignored return value of pci_enable_device()
has been removed from the -mm tree.  Its filename was
     pciserial_resume_one-ignored-return-value-of-pci_enable_device.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pciserial_resume_one() ignored return value of pci_enable_device()
From: Dirk Hohndel <hohndel@linux.intel.com>

Signed-off-by: Dirk Hohndel <hohndel@linux.intel.com>
Acked-by: Alan Cox <alan@redhat.com>
Acked-by: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250_pci.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/serial/8250_pci.c~pciserial_resume_one-ignored-return-value-of-pci_enable_device drivers/serial/8250_pci.c
--- a/drivers/serial/8250_pci.c~pciserial_resume_one-ignored-return-value-of-pci_enable_device
+++ a/drivers/serial/8250_pci.c
@@ -1986,6 +1986,7 @@ static int pciserial_suspend_one(struct 
 
 static int pciserial_resume_one(struct pci_dev *dev)
 {
+	int err;
 	struct serial_private *priv = pci_get_drvdata(dev);
 
 	pci_set_power_state(dev, PCI_D0);
@@ -1995,7 +1996,9 @@ static int pciserial_resume_one(struct p
 		/*
 		 * The device may have been disabled.  Re-enable it.
 		 */
-		pci_enable_device(dev);
+		err = pci_enable_device(dev);
+		if (err)
+			return err;
 
 		pciserial_resume_ports(priv);
 	}
_

Patches currently in -mm which might be from hohndel@linux.intel.com are

origin.patch
git-hid.patch
pciserial_resume_one-ignored-return-value-of-pci_enable_device.patch
