From: akpm@linux-foundation.org
Subject: + pci-quirks-fix-msi-disabling-on-rs400-200-and-rs480.patch added to -mm tree
Date: Thu, 24 May 2007 16:08:31 -0700
Message-ID: <200705242308.l4ON8VcO005852@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:60026 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750702AbXEXXIn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 May 2007 19:08:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: htejun@gmail.com, greg@kroah.com, jeff@garzik.org, torresmat@gmail.com


The patch titled
     pci-quirks: fix MSI disabling on RS400-200 and RS480
has been added to the -mm tree.  Its filename is
     pci-quirks-fix-msi-disabling-on-rs400-200-and-rs480.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pci-quirks: fix MSI disabling on RS400-200 and RS480
From: Tejun Heo <htejun@gmail.com>

Commit c0affe9db42bf85f4a606b3262c35ec59a5d3788 doesn't work because
the host controller is being quirked not a PCI bridge.  This patch
reverts the commit, rename quirk_svw_msi() to quirk_disable_all_msi()
and use it instead.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Matias Alejandro Torres <torresmat@gmail.com>
Cc: Greg K-H <greg@kroah.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/quirks.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff -puN drivers/pci/quirks.c~pci-quirks-fix-msi-disabling-on-rs400-200-and-rs480 drivers/pci/quirks.c
--- a/drivers/pci/quirks.c~pci-quirks-fix-msi-disabling-on-rs400-200-and-rs480
+++ a/drivers/pci/quirks.c
@@ -1625,18 +1625,20 @@ DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_N
 			quirk_nvidia_ck804_pcie_aer_ext_cap);
 
 #ifdef CONFIG_PCI_MSI
-/* The Serverworks PCI-X chipset does not support MSI. We cannot easily rely
- * on setting PCI_BUS_FLAGS_NO_MSI in its bus flags because there are actually
- * some other busses controlled by the chipset even if Linux is not aware of it.
- * Instead of setting the flag on all busses in the machine, simply disable MSI
- * globally.
+/* Some chipsets do not support MSI. We cannot easily rely on setting
+ * PCI_BUS_FLAGS_NO_MSI in its bus flags because there are actually
+ * some other busses controlled by the chipset even if Linux is not
+ * aware of it.  Instead of setting the flag on all busses in the
+ * machine, simply disable MSI globally.
  */
-static void __init quirk_svw_msi(struct pci_dev *dev)
+static void __init quirk_disable_all_msi(struct pci_dev *dev)
 {
 	pci_no_msi();
 	printk(KERN_WARNING "PCI: MSI quirk detected. MSI deactivated.\n");
 }
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_SERVERWORKS, PCI_DEVICE_ID_SERVERWORKS_GCNB_LE, quirk_svw_msi);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_SERVERWORKS, PCI_DEVICE_ID_SERVERWORKS_GCNB_LE, quirk_disable_all_msi);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_RS400_200, quirk_disable_all_msi);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_RS480, quirk_disable_all_msi);
 
 /* Disable MSI on chipsets that are known to not support it */
 static void __devinit quirk_disable_msi(struct pci_dev *dev)
@@ -1649,8 +1651,6 @@ static void __devinit quirk_disable_msi(
 	}
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_8131_BRIDGE, quirk_disable_msi);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_RS400_200, quirk_disable_msi);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_RS480, quirk_disable_msi);
 
 /* Go through the list of Hypertransport capabilities and
  * return 1 if a HT MSI capability is found and enabled */
_

Patches currently in -mm which might be from htejun@gmail.com are

origin.patch
pci-quirks-fix-msi-disabling-on-rs400-200-and-rs480.patch
fix-gregkh-driver-sysfs-fix-error-handling-in-binattr-write.patch
git-libata-all.patch
pata_acpi-restore-driver.patch
optional-led-trigger-for-libata.patch
libata-add-support-for-ata_16-on-atapi.patch
fix-build-failure-for-drivers-ata-pata_sccc.patch
libata-implement-ata_wait_after_reset.patch
drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61.patch
hpt3x2n-correct-revision-boundary.patch
pata_sis-fix-and-clean-up-some-timing-setups.patch
git-scsi-misc.patch
libata-enodev-during-prereset-isnt-an-error.patch
