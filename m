From: akpm@linux-foundation.org
Subject: + 8250_pci-fix-pci-must_checks.patch added to -mm tree
Date: Fri, 06 Apr 2007 17:49:59 -0700
Message-ID: <200704070049.l370nxOo024132@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40856 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964804AbXDGAuF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 6 Apr 2007 20:50:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     8250_pci: fix PCI must_checks
has been added to the -mm tree.  Its filename is
     8250_pci-fix-pci-must_checks.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: 8250_pci: fix PCI must_checks
From: Randy Dunlap <randy.dunlap@oracle.com>

drivers/serial/8250_pci.c:1826: warning: ignoring return value of 'pci_enable_device', declared with attribute warn_unused_result

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250_pci.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff -puN drivers/serial/8250_pci.c~8250_pci-fix-pci-must_checks drivers/serial/8250_pci.c
--- a/drivers/serial/8250_pci.c~8250_pci-fix-pci-must_checks
+++ a/drivers/serial/8250_pci.c
@@ -1820,10 +1820,18 @@ static int pciserial_resume_one(struct p
 	pci_restore_state(dev);
 
 	if (priv) {
+		int err;
+
 		/*
 		 * The device may have been disabled.  Re-enable it.
 		 */
-		pci_enable_device(dev);
+		err = pci_enable_device(dev);
+		if (err) {
+			printk(KERN_ERR "8250_pci: %s: error %d "
+				"enabling device for resume\n",
+				pci_name(dev), err);
+			return err;
+		}
 
 		pciserial_resume_ports(priv);
 	}
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
