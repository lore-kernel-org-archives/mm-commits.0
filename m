From: akpm@linux-foundation.org
Subject: [to-be-updated] pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets.patch removed from -mm tree
Date: Wed, 11 Feb 2009 16:20:20 -0800
Message-ID: <200902120020.n1C0KKZ4013138@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48843 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754748AbZBLAU2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Feb 2009 19:20:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mirq-linux@rere.qmqm.pl, jbarnes@virtuousgeek.org, norsk5@yahoo.com, mm-commits@vger.kernel.org


The patch titled
     pci-quirks: unhide 'Overflow' device on i828{6,7}5P/PE chipsets
has been removed from the -mm tree.  Its filename was
     pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci-quirks: unhide 'Overflow' device on i828{6,7}5P/PE chipsets
From: Michal Miroslaw <mirq-linux@rere.qmqm.pl>

As I found out from EDAC driver sources for i82875P some BIOSes for
i82875P/PE hide 'overflow' device 6.  The same thing happens for
i82865P/PE chipsets.

After testing this patch for couple of days on my laptop (i82856P) it
looks like something is resetting device 0 (MCH) config register 0xF4 to
zero and effectively disabling the device again.  The delay looks random
to me.  I can easily update the register using 'hexedit
/sys/bus/pci/devices/0000\:00\:00.0/config' and see correct values in
lspci output afterwards.

On Fri, 9 Jan 2009 13:40:02 -0800
Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> 
> This one already got a NAK until Michal can figure out a way to prevent the 
> SMM code on his machine from hiding this device periodically.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Michal Miroslaw <mirq-linux@rere.qmqm.pl>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Doug Thompson <norsk5@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/quirks.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff -puN drivers/pci/quirks.c~pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets drivers/pci/quirks.c
--- a/drivers/pci/quirks.c~pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets
+++ a/drivers/pci/quirks.c
@@ -2149,6 +2149,29 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AT
 
 #endif /* CONFIG_PCI_MSI */
 
+/* Originally in EDAC sources for i82875P:
+ * Intel tells BIOS developers to hide device 6 which
+ * configures the overflow device access containing
+ * the DRBs - this is where we expose device 6.
+ * http://www.x86-secret.com/articles/tweak/pat/patsecrets-2.htm
+ */
+static void __devinit
+quirk_unhide_mch_memory_controller_dev6(struct pci_dev *dev)
+{
+	u8 reg;
+
+	if (pci_read_config_byte(dev, 0xF4, &reg) == 0 && !(reg & 0x02)) {
+		dev_info(&dev->dev,
+			"Enabling MCH Memory Controller 'Overflow' Device");
+		pci_write_config_byte(dev, 0xF4, reg | 0x02);
+	}
+}
+
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82865_HB,
+			quirk_unhide_mch_memory_controller_dev6);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82875_HB,
+			quirk_unhide_mch_memory_controller_dev6);
+
 static void pci_do_fixups(struct pci_dev *dev, struct pci_fixup *f,
 			  struct pci_fixup *end)
 {
_

Patches currently in -mm which might be from mirq-linux@rere.qmqm.pl are

pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets.patch
pci-quirks-hp-hides-smbus-controller-in-compaq-nx9500-laptops.patch

