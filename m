From: akpm@linux-foundation.org
Subject: + parport_serial-fix-pci-must_checks.patch added to -mm tree
Date: Fri, 06 Apr 2007 17:49:58 -0700
Message-ID: <200704070049.l370nwQf024129@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40855 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964806AbXDGAuD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 6 Apr 2007 20:50:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     parport_serial: fix PCI must_checks
has been added to the -mm tree.  Its filename is
     parport_serial-fix-pci-must_checks.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

git-acpi.patch
git-drm.patch
git-ieee1394.patch
romfs-printk-format-warnings.patch
git-netdev-all.patch
git-scsi-misc.patch
git-unionfs.patch
git-ipwireless_cs.patch
fix-mtrr-sections.patch
scripts-kernel-doc-whitespace-cleanup.patch
reiserfs-proc-support-requires-proc_fs.patch
kprobes-fix-sparse-null-warning.patch
header-cleaning-dont-include-smp_lockh-when-not-used.patch
expose-range-checking-functions-from-arch-specific.patch
ext4-use-null-for-pointers.patch
some-grammatical-fixups-and-additions-to-atomich-kernel-doc.patch
profile-likely-unlikely-macros.patch
parport_serial-fix-pci-must_checks.patch
8250_pci-fix-pci-must_checks.patch
s3fb-fix-pci-must_checks.patch
