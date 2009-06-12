From: akpm@linux-foundation.org
Subject: [merged] pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2.patch removed from -mm tree
Date: Fri, 12 Jun 2009 11:22:35 -0700
Message-ID: <200906121822.n5CIMZfA031305@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38337 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757719AbZFLSZ5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Jun 2009 14:25:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mirq-linux@rere.qmqm.pl, jbarnes@virtuousgeek.org, norsk5@yahoo.com, mm-commits@vger.kernel.org


The patch titled
     pci-quirks: unhide 'Overflow' device on i828{6,7}5P/PE chipsets
has been removed from the -mm tree.  Its filename was
     pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci-quirks: unhide 'Overflow' device on i828{6,7}5P/PE chipsets

Michal Miroslaw <mirq-linux@rere.qmqm.pl>

Some BIOSes hide 'overflow' device (dev #6) for i82875P/PE chipsets.
The same happens for i82865P/PE. Add a quirk to enable this device.
This allows i82875 EDAC driver to bind to chipset's dev #6 and not
dev #0 as the latter is used by AGP driver.

On my laptop (i82865P based) ACPI code is disabling this device
again in \_SB.PCI0._CRS method (called at least at PNP init time).
This can be easily worked around by patching DSDT.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Michal Miroslaw <mirq-linux@rere.qmqm.pl>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Acked-by: Doug Thompson <norsk5@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/quirks.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff -puN drivers/pci/quirks.c~pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2 drivers/pci/quirks.c
--- a/drivers/pci/quirks.c~pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2
+++ a/drivers/pci/quirks.c
@@ -2017,6 +2017,28 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_BR
 			PCI_DEVICE_ID_NX2_5709S,
 			quirk_brcm_570x_limit_vpd);
 
+/* Originally in EDAC sources for i82875P:
+ * Intel tells BIOS developers to hide device 6 which
+ * configures the overflow device access containing
+ * the DRBs - this is where we expose device 6.
+ * http://www.x86-secret.com/articles/tweak/pat/patsecrets-2.htm
+ */
+static void __devinit quirk_unhide_mch_dev6(struct pci_dev *dev)
+{
+	u8 reg;
+
+	if (pci_read_config_byte(dev, 0xF4, &reg) == 0 && !(reg & 0x02)) {
+		dev_info(&dev->dev, "Enabling MCH 'Overflow' Device\n");
+		pci_write_config_byte(dev, 0xF4, reg | 0x02);
+	}
+}
+
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82865_HB,
+			quirk_unhide_mch_dev6);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82875_HB,
+			quirk_unhide_mch_dev6);
+
+
 #ifdef CONFIG_PCI_MSI
 /* Some chipsets do not support MSI. We cannot easily rely on setting
  * PCI_BUS_FLAGS_NO_MSI in its bus flags because there are actually
_

Patches currently in -mm which might be from mirq-linux@rere.qmqm.pl are

linux-next.patch

