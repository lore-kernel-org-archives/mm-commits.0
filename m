From: akpm@linux-foundation.org
Subject: - libata-enodev-during-prereset-isnt-an-error.patch removed from -mm tree
Date: Tue, 29 May 2007 11:56:25 -0700
Message-ID: <200705291856.l4TIuOVI008647@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:44599 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760363AbXE2S4x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 14:56:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: htejun@gmail.com, lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     libata: -ENODEV during prereset isn't an error
has been removed from the -mm tree.  Its filename was
     libata-enodev-during-prereset-isnt-an-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

pci-quirks-fix-msi-disabling-on-rs400-200-and-rs480.patch
fix-gregkh-driver-sysfs-fix-error-handling-in-binattr-write.patch
git-libata-all.patch
pata_acpi-restore-driver.patch
libata-implement-ata_wait_after_reset.patch
git-scsi-misc.patch
