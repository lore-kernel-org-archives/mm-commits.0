From: akpm@linux-foundation.org
Subject: + i2c-add-support-for-new-amd-smbus-devices.patch added to -mm tree
Date: Thu, 23 Jul 2009 15:22:16 -0700
Message-ID: <200907232222.n6NMMGvl015458@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47546 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754709AbZGWWWT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Jul 2009 18:22:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: crane.cai@amd.com


The patch titled
     i2c: add support for new AMD SMBus devices
has been added to the -mm tree.  Its filename is
     i2c-add-support-for-new-amd-smbus-devices.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: i2c: add support for new AMD SMBus devices
From: Crane Cai <crane.cai@amd.com>

Use driver to detect SMBus devices with Vendor ID AMD and class code is
SMBus.

Signed-off-by: Crane Cai <crane.cai@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/i2c/busses/i2c-piix4.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN drivers/i2c/busses/i2c-piix4.c~i2c-add-support-for-new-amd-smbus-devices drivers/i2c/busses/i2c-piix4.c
--- a/drivers/i2c/busses/i2c-piix4.c~i2c-add-support-for-new-amd-smbus-devices
+++ a/drivers/i2c/busses/i2c-piix4.c
@@ -479,6 +479,10 @@ static struct pci_device_id piix4_ids[] 
 	{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP300_SMBUS) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP400_SMBUS) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_SBX00_SMBUS) },
+	/* AMD Generic, PCI class code and Vendor ID for SMBus */
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_ANY_ID),
+	  .class = PCI_CLASS_SERIAL_SMBUS << 8,
+	  .class_mask = 0xffffff },
 	{ PCI_DEVICE(PCI_VENDOR_ID_SERVERWORKS,
 		     PCI_DEVICE_ID_SERVERWORKS_OSB4) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_SERVERWORKS,
@@ -499,9 +503,10 @@ static int __devinit piix4_probe(struct 
 {
 	int retval;
 
-	if ((dev->vendor == PCI_VENDOR_ID_ATI) &&
+	if (((dev->vendor == PCI_VENDOR_ID_ATI) &&
 	    (dev->device == PCI_DEVICE_ID_ATI_SBX00_SMBUS) &&
-	    (dev->revision >= 0x40))
+	    (dev->revision >= 0x40)) ||
+	    dev->vendor == PCI_VENDOR_ID_AMD)
 		/* base address location etc changed in SB800 */
 		retval = piix4_setup_sb800(dev, id);
 	else
_

Patches currently in -mm which might be from crane.cai@amd.com are

i2c-add-support-for-new-amd-smbus-devices.patch

