From: akpm@linux-foundation.org
Subject: + libata-enodev-during-prereset-isnt-an-error.patch added to -mm tree
Date: Thu, 24 May 2007 13:49:08 -0700
Message-ID: <200705242049.l4OKn8AH002270@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:44639 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750841AbXEXUtP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 May 2007 16:49:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: htejun@gmail.com, lethal@linux-sh.org


The patch titled
     libata: -ENODEV during prereset isn't an error
has been added to the -mm tree.  Its filename is
     libata-enodev-during-prereset-isnt-an-error.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: libata: -ENODEV during prereset isn't an error
From: Tejun Heo <htejun@gmail.com>

During prereset, -ENODEV return from ata_wait_ready() is not an error. 
This causes unnecessary bug message on controllers which uses 0xff to
indicate empty port.  Fix it.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-core.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/ata/libata-core.c~libata-enodev-during-prereset-isnt-an-error drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~libata-enodev-during-prereset-isnt-an-error
+++ a/drivers/ata/libata-core.c
@@ -3460,7 +3460,7 @@ int ata_std_prereset(struct ata_port *ap
 	 */
 	if (!(ap->flags & ATA_FLAG_SKIP_D2H_BSY) && !ata_port_offline(ap)) {
 		rc = ata_wait_ready(ap, deadline);
-		if (rc) {
+		if (rc && rc != -ENODEV) {
 			ata_port_printk(ap, KERN_WARNING, "device not ready "
 					"(errno=%d), forcing hardreset\n", rc);
 			ehc->i.action |= ATA_EH_HARDRESET;
_

Patches currently in -mm which might be from htejun@gmail.com are

origin.patch
fix-gregkh-driver-sysfs-fix-error-handling-in-binattr-write.patch
git-libata-all.patch
pata_acpi-restore-driver.patch
optional-led-trigger-for-libata.patch
libata-add-support-for-ata_16-on-atapi.patch
fix-build-failure-for-drivers-ata-pata_sccc.patch
libata-implement-ata_wait_after_reset.patch
drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61.patch
hpt3x2n-correct-revision-boundary.patch
pata_sis-fix-and-clean-up-some-timing-setups.patch
pci-quirks-disable-msi-on-rs400-200-and-rs480.patch
git-scsi-misc.patch
libata-enodev-during-prereset-isnt-an-error.patch
