From: akpm@linux-foundation.org
Subject: + pci-consolidate-duplicated-msi-enable-functions.patch added to -mm tree
Date: Fri, 29 Feb 2008 16:06:43 -0800
Message-ID: <200803010006.m2106hBj027628@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:45771 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750739AbYCAAIJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Feb 2008 19:08:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com, ebiederm@xmission.com, greg@kroah.com, mingo@elte.hu, sebastien.dugue@bull.net, tglx@linutronix.de


The patch titled
     pci: consolidate duplicated MSI enable functions
has been added to the -mm tree.  Its filename is
     pci-consolidate-duplicated-msi-enable-functions.patch

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
Subject: pci: consolidate duplicated MSI enable functions
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

Two recent patches added basically the same code to turn on HT MSI mapping:

    http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=6bae1d96c6d7dde078994f6cb98235fd46f8736b
    http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=9dc625e72309e1c919ea3e7f51d0ffca96123787

There's no need to have both, so this patch removes one copy.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Greg KH <greg@kroah.com>
Cc: Sebastien Dugue <sebastien.dugue@bull.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Ingo Molnar <mingo@elte.hu
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/quirks.c |   36 ++++++------------------------------
 1 file changed, 6 insertions(+), 30 deletions(-)

diff -puN drivers/pci/quirks.c~pci-consolidate-duplicated-msi-enable-functions drivers/pci/quirks.c
--- a/drivers/pci/quirks.c~pci-consolidate-duplicated-msi-enable-functions
+++ a/drivers/pci/quirks.c
@@ -1726,32 +1726,6 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_SE
 			quirk_msi_ht_cap);
 
 
-/*
- *  Force enable MSI mapping capability on HT bridges
- */
-static void __devinit quirk_msi_ht_cap_enable(struct pci_dev *dev)
-{
-	int pos, ttl = 48;
-
-	pos = pci_find_ht_capability(dev, HT_CAPTYPE_MSI_MAPPING);
-	while (pos && ttl--) {
-		u8 flags;
-
-		if (pci_read_config_byte(dev, pos + HT_MSI_FLAGS, &flags) == 0) {
-			printk(KERN_INFO "PCI: Enabling HT MSI Mapping on %s\n",
-			       pci_name(dev));
-
-			pci_write_config_byte(dev, pos + HT_MSI_FLAGS,
-					      flags | HT_MSI_FLAGS_ENABLE);
-		}
-		pos = pci_find_next_ht_capability(dev, pos,
-						  HT_CAPTYPE_MSI_MAPPING);
-	}
-}
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_SERVERWORKS,
-			 PCI_DEVICE_ID_SERVERWORKS_HT1000_PXB,
-			 quirk_msi_ht_cap_enable);
-
 /* The nVidia CK804 chipset may have 2 HT MSI mappings.
  * MSI are supported if the MSI capability set in any of these mappings.
  */
@@ -1778,9 +1752,8 @@ static void __devinit quirk_nvidia_ck804
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_CK804_PCIE,
 			quirk_nvidia_ck804_msi_ht_cap);
 
-/*
- *  Force enable MSI mapping capability on HT bridges  */
-static inline void ht_enable_msi_mapping(struct pci_dev *dev)
+/* Force enable MSI mapping capability on HT bridges */
+static void __devinit ht_enable_msi_mapping(struct pci_dev *dev)
 {
 	int pos, ttl = 48;
 
@@ -1799,6 +1772,9 @@ static inline void ht_enable_msi_mapping
 						  HT_CAPTYPE_MSI_MAPPING);
 	}
 }
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_SERVERWORKS,
+			 PCI_DEVICE_ID_SERVERWORKS_HT1000_PXB,
+			 ht_enable_msi_mapping);
 
 static void __devinit nv_msi_ht_cap_quirk(struct pci_dev *dev)
 {
@@ -1830,7 +1806,7 @@ static void __devinit nv_msi_ht_cap_quir
 
 		if (pci_read_config_byte(dev, pos + HT_MSI_FLAGS,
 					 &flags) == 0) {
-			dev_info(&dev->dev, "Quirk disabling HT MSI mapping");
+			dev_info(&dev->dev, "Disabling HT MSI mapping");
 			pci_write_config_byte(dev, pos + HT_MSI_FLAGS,
 					      flags & ~HT_MSI_FLAGS_ENABLE);
 		}
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

serial-add-pnp-id-gvc0303-for-archtek-3334brv-isa-modem.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
3c509-convert-to-isa_driver-and-pnp_driver-v4.patch
3c509-convert-to-isa_driver-and-pnp_driver-v4-cleanup-update.patch
3c509-convert-to-isa_driver-and-pnp_driver-v4-cleanup.patch
pci-simplify-quirk-debug-output.patch
pci-consolidate-duplicated-msi-enable-functions.patch
pci-use-dev_printk-in-quirk-messages.patch
simplify-initcall_debug-output.patch
pnp-skip-dev-protocol-null-checks.patch
pnp-simplify-quirk-debug-output.patch

