From: akpm@linux-foundation.org
Subject: - libata-acpi-try-and-stop-all-the-non-pci-devices-crashing.patch removed from -mm tree
Date: Thu, 15 Mar 2007 13:58:15 -0800
Message-ID: <200703152158.l2FLwFJY027716@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42468 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077AbXCOV63 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 17:58:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     libata-acpi: try and stop all the non PCI devices crashing
has been removed from the -mm tree.  Its filename was
     libata-acpi-try-and-stop-all-the-non-pci-devices-crashing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: libata-acpi: try and stop all the non PCI devices crashing
From: Alan Cox <alan@redhat.com>

For 2.6.20 it mostly used to just not work, for 2.6.21-rc it crashes, this
seems to be down to luck (bad or good). The libata-acpi code needs to
avoid doing PCI work on non-PCI devices. This is one hack although it's
not pretty and perhaps there is a "right" way to check if a struct device
* is PCI ?

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-acpi.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff -puN drivers/ata/libata-acpi.c~libata-acpi-try-and-stop-all-the-non-pci-devices-crashing drivers/ata/libata-acpi.c
--- a/drivers/ata/libata-acpi.c~libata-acpi-try-and-stop-all-the-non-pci-devices-crashing
+++ a/drivers/ata/libata-acpi.c
@@ -34,6 +34,16 @@ struct taskfile_array {
 	u8	tfa[REGS_PER_GTF];	/* regs. 0x1f1 - 0x1f7 */
 };
 
+/*
+ *	Helper - belongs in the PCI layer somewhere eventually
+ */
+
+static int is_pci_dev(struct device *dev)
+{
+	if (dev->bus == &pci_bus_type)
+		return 1;
+	return 0;
+}
 
 /**
  * sata_get_dev_handle - finds acpi_handle and PCI device.function
@@ -53,6 +63,9 @@ static int sata_get_dev_handle(struct de
 	struct pci_dev	*pci_dev;
 	acpi_integer	addr;
 
+	if (!is_pci_dev(dev))
+		return -ENODEV;
+
 	pci_dev = to_pci_dev(dev);	/* NOTE: PCI-specific */
 	/* Please refer to the ACPI spec for the syntax of _ADR. */
 	addr = (PCI_SLOT(pci_dev->devfn) << 16) | PCI_FUNC(pci_dev->devfn);
@@ -84,7 +97,12 @@ static int pata_get_dev_handle(struct de
 	acpi_status status;
 	struct acpi_device_info	*dinfo = NULL;
 	int ret = -ENODEV;
-	struct pci_dev *pdev = to_pci_dev(dev);
+	struct pci_dev *pdev;
+
+	if (!is_pci_dev(dev))
+		return -ENODEV;
+
+	pdev = to_pci_dev(dev);
 
 	bus = pdev->bus->number;
 	devnum = PCI_SLOT(pdev->devfn);
_

Patches currently in -mm which might be from alan@redhat.com are

origin.patch
git-libata-all.patch
pcmcia-spot-slave-decode-flaws-for-testing.patch
ata_generic-remove-all-the-crud-again-and-use-cable.patch
pata_ali-remove-all-the-crap-again-and-switch-to.patch
pata_amd-remove-all-the-crud-and-restore-the-cable-detect.patch
pata_cs5535-re-remove-all-the-crap-and-switch-to-the-cable.patch
pata_cypress-re-remove-all-the-crap-and-switch-back-to.patch
pata_netcell-re-remove-all-the-crud.patch
pata_qdi-restore-cable-detect.patch
pata_sl82c105-restore-cable-detect-method.patch
pata_winbond-restore-cable-method.patch
libata-acpi-add-infrastructure-for-drivers-to-use.patch
pata_optidma-rework-for-cable-detect-and-to-remove.patch
pata_pdc2027x-restore-various-updates-done-on-the-driver.patch
pata_acpi-restore-driver.patch
resend-iphase-64bit-cleanup.patch
pci_module_init-convertion-in-tmscsimc.patch
tty-clarify-documentation-of-write.patch
tty-i386-x86_64-arbitary-speed-support.patch
