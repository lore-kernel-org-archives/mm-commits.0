From: akpm@linux-foundation.org
Subject: + s3fb-fix-pci-must_checks.patch added to -mm tree
Date: Fri, 06 Apr 2007 17:50:00 -0700
Message-ID: <200704070050.l370o02P024135@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40865 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964804AbXDGAuH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 6 Apr 2007 20:50:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, adaplas@pol.net


The patch titled
     s3fb: fix PCI must_checks
has been added to the -mm tree.  Its filename is
     s3fb-fix-pci-must_checks.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: s3fb: fix PCI must_checks
From: Randy Dunlap <randy.dunlap@oracle.com>

drivers/video/s3fb.c:1078: warning: ignoring return value of 'pci_enable_device', declared with attribute warn_unused_result

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/s3fb.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN drivers/video/s3fb.c~s3fb-fix-pci-must_checks drivers/video/s3fb.c
--- a/drivers/video/s3fb.c~s3fb-fix-pci-must_checks
+++ a/drivers/video/s3fb.c
@@ -1061,6 +1061,7 @@ static int s3_pci_resume(struct pci_dev*
 {
 	struct fb_info *info = pci_get_drvdata(dev);
 	struct s3fb_info *par = info->par;
+	int err;
 
 	dev_info(&(dev->dev), "resume\n");
 
@@ -1075,7 +1076,13 @@ static int s3_pci_resume(struct pci_dev*
 
 	pci_set_power_state(dev, PCI_D0);
 	pci_restore_state(dev);
-	pci_enable_device(dev);
+	err = pci_enable_device(dev);
+	if (err) {
+		mutex_unlock(&(par->open_lock));
+		release_console_sem();
+		dev_err(&(dev->dev), "error %d enabling device for resume\n", err);
+		return err;
+	}
 	pci_set_master(dev);
 
 	s3fb_set_par(info);
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
