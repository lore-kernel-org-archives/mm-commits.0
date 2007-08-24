From: akpm@linux-foundation.org
Subject: + update-gregkh-pci-pci-unhide-smbus-on-compaq-deskpro-ep-401963-001-motherboard-with-i810-chipset.patch added to -mm tree
Date: Thu, 23 Aug 2007 17:08:13 -0700
Message-ID: <200708240008.l7O08DuV001422@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40649 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760211AbXHXAJH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Aug 2007 20:09:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gw.kernel@tnode.com, greg@kroah.com, khali@linux-fr.org


The patch titled
     update gregkh-pci-pci-unhide-smbus-on-compaq-deskpro-ep-401963-001-motherboard-with-i810-chipset
has been added to the -mm tree.  Its filename is
     update-gregkh-pci-pci-unhide-smbus-on-compaq-deskpro-ep-401963-001-motherboard-with-i810-chipset.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: update gregkh-pci-pci-unhide-smbus-on-compaq-deskpro-ep-401963-001-motherboard-with-i810-chipset
From: Greg White <gw.kernel@tnode.com>

undescribed alterations to
gregkh-pci-pci-unhide-smbus-on-compaq-deskpro-ep-401963-001-motherboard-with-i810-chipset.patch

Signed-off-by: Greg White <gw.kernel@tnode.com>
Acked-by: Jean Delvare <khali@linux-fr.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/quirks.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff -puN drivers/pci/quirks.c~update-gregkh-pci-pci-unhide-smbus-on-compaq-deskpro-ep-401963-001-motherboard-with-i810-chipset drivers/pci/quirks.c
--- a/drivers/pci/quirks.c~update-gregkh-pci-pci-unhide-smbus-on-compaq-deskpro-ep-401963-001-motherboard-with-i810-chipset
+++ a/drivers/pci/quirks.c
@@ -972,8 +972,8 @@ DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_V
  *
  * The SMBus PCI Device can be activated by setting a bit in the ICH LPC 
  * bridge. Unfortunately, this device has no subvendor/subdevice ID. So it 
- * becomes necessary to do this tweak in two steps -- I've chosen the Host
- * bridge as trigger.
+ * becomes necessary to do this tweak in two steps -- the chosen trigger
+ * is either the Host bridge (preferred) or on-board VGA controller.
  *
  * Note that we used to unhide the SMBus that way on Toshiba laptops
  * (Satellite A40 and Tecra M2) but then found that the thermal management
@@ -1070,10 +1070,12 @@ static void __init asus_hides_smbus_host
 			case 0x0058: /* Compaq Evo N620c */
 				asus_hides_smbus = 1;
 			}
-	} else if (unlikely(dev->subsystem_vendor == PCI_CLASS_NOT_DEFINED)) {
-		if (dev->device == PCI_DEVICE_ID_INTEL_82810_MC3)
+		else if (dev->device == PCI_DEVICE_ID_INTEL_82810_IG3)
 			switch(dev->subsystem_device) {
-			case 0x0000: /* Compaq Deskpro EP 401963-001 (PCA# 010174) motherboard with i810 chipset doesn't have subsystem identification */
+			case 0xB16C: /* Compaq Deskpro EP 401963-001 (PCA# 010174) */
+				/* Motherboard doesn't have Host bridge
+				 * subvendor/subdevice IDs, therefore checking
+				 * its on-board VGA controller */
 				asus_hides_smbus = 1;
 			}
 	}
@@ -1087,7 +1089,8 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_I
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_82855PM_HB,	asus_hides_smbus_hostbridge );
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_82855GM_HB,	asus_hides_smbus_hostbridge );
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_82915GM_HB, asus_hides_smbus_hostbridge );
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_82810_MC3,	asus_hides_smbus_hostbridge );
+
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_82810_IG3,	asus_hides_smbus_hostbridge );
 
 static void asus_hides_smbus_lpc(struct pci_dev *dev)
 {
_

Patches currently in -mm which might be from gw.kernel@tnode.com are

update-gregkh-pci-pci-unhide-smbus-on-compaq-deskpro-ep-401963-001-motherboard-with-i810-chipset.patch
