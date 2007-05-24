From: akpm@linux-foundation.org
Subject: - pci-quirks-disable-msi-on-rs400-200-and-rs480.patch removed from -mm tree
Date: Thu, 24 May 2007 16:07:24 -0700
Message-ID: <200705242307.l4ON7OCB005824@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:56336 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752919AbXEXXHq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 May 2007 19:07:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: htejun@gmail.com, greg@kroah.com, jeff@garzik.org, stable@kernel.org, torresmat@gmail.com, mm-commits@vger.kernel.org


The patch titled
     pci-quirks: disable MSI on RS400-200 and RS480
has been removed from the -mm tree.  Its filename was
     pci-quirks-disable-msi-on-rs400-200-and-rs480.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: pci-quirks: disable MSI on RS400-200 and RS480
=46rom: Tejun Heo <htejun@gmail.com>

MSI doesn't work on RS400-200 and RS480 requiring pci=3Dnomsi kernel bo=
ot
parameter for ahci to work.  This patch renames quirk_svw_msi() to
quirk_disable_all_msi() and use it to disable MSI on those chips.

  http://thread.gmane.org/gmane.linux.ide/17820
  http://thread.gmane.org/gmane.linux.ide/17516
  https://bugzilla.novell.com/show_bug.cgi?id=3D263893

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Mat=ED-as Alejandro Torres <torresmat@gmail.com>
Cc: Greg K-H <greg@kroah.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/quirks.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff -puN drivers/pci/quirks.c~pci-quirks-disable-msi-on-rs400-200-and-=
rs480 drivers/pci/quirks.c
--- a/drivers/pci/quirks.c~pci-quirks-disable-msi-on-rs400-200-and-rs48=
0
+++ a/drivers/pci/quirks.c
@@ -1641,18 +1641,20 @@ DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_N
 			quirk_nvidia_ck804_pcie_aer_ext_cap);
=20
 #ifdef CONFIG_PCI_MSI
-/* The Serverworks PCI-X chipset does not support MSI. We cannot easil=
y rely
- * on setting PCI_BUS_FLAGS_NO_MSI in its bus flags because there are =
actually
- * some other busses controlled by the chipset even if Linux is not aw=
are of it.
- * Instead of setting the flag on all busses in the machine, simply di=
sable MSI
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
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_SERVERWORKS, PCI_DEVICE_ID_SERVE=
RWORKS_GCNB_LE, quirk_svw_msi);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_SERVERWORKS, PCI_DEVICE_ID_SERVE=
RWORKS_GCNB_LE, quirk_disable_all_msi);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_RS400_200=
, quirk_disable_all_msi);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_RS480, qu=
irk_disable_all_msi);
=20
 /* Disable MSI on chipsets that are known to not support it */
 static void __devinit quirk_disable_msi(struct pci_dev *dev)
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
pci-quirks-disable-msi-on-rs400-200-and-rs480.patch
git-scsi-misc.patch
libata-enodev-during-prereset-isnt-an-error.patch
