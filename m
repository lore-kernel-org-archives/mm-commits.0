From: akpm@linux-foundation.org
Subject: - s3fb-fix-pci-must_checks.patch removed from -mm tree
Date: Tue, 08 May 2007 20:00:16 -0700
Message-ID: <200705090300.l4930GnO010541@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54969 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032785AbXEIDAW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:00:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     s3fb: fix PCI must_checks
has been removed from the -mm tree.  Its filename was
     s3fb-fix-pci-must_checks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
