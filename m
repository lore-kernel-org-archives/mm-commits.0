From: akpm@linux-foundation.org
Subject: - parport_serial-fix-pci-must_checks.patch removed from -mm tree
Date: Tue, 08 May 2007 19:49:06 -0700
Message-ID: <200705090249.l492n6Ul009186@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53004 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966107AbXEICtK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:49:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     parport_serial: fix PCI must_checks
has been removed from the -mm tree.  Its filename was
     parport_serial-fix-pci-must_checks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: parport_serial: fix PCI must_checks
From: Randy Dunlap <randy.dunlap@oracle.com>

drivers/parport/parport_serial.c:402: warning: ignoring return value of 'pci_enable_device', declared with attribute warn_unused_result

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/parport/parport_serial.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN drivers/parport/parport_serial.c~parport_serial-fix-pci-must_checks drivers/parport/parport_serial.c
--- a/drivers/parport/parport_serial.c~parport_serial-fix-pci-must_checks
+++ a/drivers/parport/parport_serial.c
@@ -392,6 +392,7 @@ static int parport_serial_pci_suspend(st
 static int parport_serial_pci_resume(struct pci_dev *dev)
 {
 	struct parport_serial_private *priv = pci_get_drvdata(dev);
+	int err;
 
 	pci_set_power_state(dev, PCI_D0);
 	pci_restore_state(dev);
@@ -399,7 +400,12 @@ static int parport_serial_pci_resume(str
 	/*
 	 * The device may have been disabled.  Re-enable it.
 	 */
-	pci_enable_device(dev);
+	err = pci_enable_device(dev);
+	if (err) {
+		printk(KERN_ERR "parport_serial: %s: error enabling "
+			"device for resume (%d)\n", pci_name(dev), err);
+		return err;
+	}
 
 	if (priv->serial)
 		pciserial_resume_ports(priv->serial);
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
krealloc-fix-kerneldoc-comments.patch
git-acpi.patch
git-ieee1394.patch
romfs-printk-format-warnings.patch
add-pci_try_set_mwi.patch
git-unionfs.patch
git-ipwireless_cs.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-doc-fix.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
lib-hexdump.patch
lib-hexdump-fix.patch
lib-hexdump-update-on-feedback.patch
doc-what-a-patch-series-is.patch
kernel-doc-small-kernel-doc-optimization.patch
profile-likely-unlikely-macros.patch
