From: akpm@linux-foundation.org
Subject: + pciserial_resume_one-ignored-return-value-of-pci_enable_device.patch added to -mm tree
Date: Thu, 01 Nov 2007 16:23:40 -0700
Message-ID: <200711012323.lA1NNepF020955@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46739 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752771AbXKAXYI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Nov 2007 19:24:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hohndel@linux.intel.com, alan@redhat.com, jeff@garzik.org


The patch titled
     pciserial_resume_one() ignored return value of pci_enable_device()
has been added to the -mm tree.  Its filename is
     pciserial_resume_one-ignored-return-value-of-pci_enable_device.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
