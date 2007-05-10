From: akpm@linux-foundation.org
Subject: + pci-quirks-disable-msi-on-rs400-200-and-rs480.patch added to -mm tree
Date: Wed, 09 May 2007 19:49:01 -0700
Message-ID: <200705100249.l4A2n1On010422@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48260 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753153AbXEJCu1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 22:50:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: htejun@gmail.com, greg@kroah.com, jeff@garzik.org, stable@kernel.org, torresmat@gmail.com


The patch titled
     pci-quirks: disable MSI on RS400-200 and RS480
has been added to the -mm tree.  Its filename is
     pci-quirks-disable-msi-on-rs400-200-and-rs480.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

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
 1 file changed, 9 insertions(+), 7 deletions(-)

diff -puN drivers/pci/quirks.c~pci-quirks-disable-msi-on-rs400-200-and-=
rs480 drivers/pci/quirks.c
--- a/drivers/pci/quirks.c~pci-quirks-disable-msi-on-rs400-200-and-rs48=
0
+++ a/drivers/pci/quirks.c
@@ -1625,18 +1625,20 @@ DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_N
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
fix-gregkh-driver-sysfs-fix-error-handling-in-binattr-write.patch
git-dvb.patch
libata-clean-up-sff-init-mess.patch
ahci-crash-fix.patch
pata_acpi-restore-driver-vs-libata-clean-up-sff-init-mess-fix.patch
optional-led-trigger-for-libata.patch
drivers-ata-remove-the-wildcard-from-sata_nv-driver.patch
add-the-combined-mode-for-ati-sb700.patch
add-the-ati-sb700-sata-controller-device-id-to-ahci-pci-table.patch
libata-add-support-for-ata_16-on-atapi.patch
pata_scc-fix-compilation.patch
sata_nv-fix-adma-freeze-thaw-irq_clear-issues.patch
sata_promise-fix-another-error-decode-regression.patch
pci-quirks-disable-msi-on-rs400-200-and-rs480.patch
