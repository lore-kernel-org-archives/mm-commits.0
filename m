From: akpm@linux-foundation.org
Subject: - scsi-fix-section-mismatch-in-aic94xx.patch removed from -mm tree
Date: Fri, 02 May 2008 12:43:48 -0700
Message-ID: <200805021943.m42JhmvI011322@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47265 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936071AbYEBTwh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 15:52:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sam@ravnborg.org, James.Bottomley@SteelEye.com, gilbert_wu@adaptec.com, mm-commits@vger.kernel.org


The patch titled
     scsi: fix section mismatch in aic94xx
has been removed from the -mm tree.  Its filename was
     scsi-fix-section-mismatch-in-aic94xx.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scsi: fix section mismatch in aic94xx
From: Sam Ravnborg <sam@ravnborg.org>

Fix following warnings:
WARNING: vmlinux.o(.data+0x17aa88): Section mismatch in reference from the variable asd_pcidev_data to the function .devinit.text:asd_aic9410_setup()
WARNING: vmlinux.o(.data+0x17aa98): Section mismatch in reference from the variable asd_pcidev_data to the function .devinit.text:asd_aic9410_setup()
WARNING: vmlinux.o(.data+0x17aaa8): Section mismatch in reference from the variable asd_pcidev_data to the function .devinit.text:asd_aic9405_setup()

asd_pcidev_data is only used by __devinit asd_pci_probe.  So mark is const and
annotate it __devinitconst to fix the warnings.

[akpm@linux-foundation.org: fix warning]
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Gilbert Wu <gilbert_wu@adaptec.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aic94xx/aic94xx_init.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/aic94xx/aic94xx_init.c~scsi-fix-section-mismatch-in-aic94xx drivers/scsi/aic94xx/aic94xx_init.c
--- a/drivers/scsi/aic94xx/aic94xx_init.c~scsi-fix-section-mismatch-in-aic94xx
+++ a/drivers/scsi/aic94xx/aic94xx_init.c
@@ -529,10 +529,10 @@ static void asd_remove_dev_attrs(struct 
 /* The first entry, 0, is used for dynamic ids, the rest for devices
  * we know about.
  */
-static struct asd_pcidev_struct {
+static const struct asd_pcidev_struct {
 	const char * name;
 	int (*setup)(struct asd_ha_struct *asd_ha);
-} asd_pcidev_data[] = {
+} asd_pcidev_data[] __devinitconst = {
 	/* Id 0 is used for dynamic ids. */
 	{ .name  = "Adaptec AIC-94xx SAS/SATA Host Adapter",
 	  .setup = asd_aic9410_setup
@@ -735,7 +735,7 @@ static int asd_unregister_sas_ha(struct 
 static int __devinit asd_pci_probe(struct pci_dev *dev,
 				   const struct pci_device_id *id)
 {
-	struct asd_pcidev_struct *asd_dev;
+	const struct asd_pcidev_struct *asd_dev;
 	unsigned asd_id = (unsigned) id->driver_data;
 	struct asd_ha_struct *asd_ha;
 	struct Scsi_Host *shost;
_

Patches currently in -mm which might be from sam@ravnborg.org are

origin.patch
git-pci-current.patch
git-sh.patch
git-scsi-misc.patch
git-watchdog.patch
documentation-build-source-files-in-documentation-sub-dir.patch

