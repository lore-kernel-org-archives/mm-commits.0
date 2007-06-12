From: akpm@linux-foundation.org
Subject: - libata-limit-post-srst-nsect-lbal-wait-to-100ms.patch removed from -mm tree
Date: Tue, 12 Jun 2007 11:58:09 -0700
Message-ID: <200706121858.l5CIw9gN018522@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35331 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750768AbXFLTCO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jun 2007 15:02:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: htejun@gmail.com, mm-commits@vger.kernel.org


The patch titled
     libata: limit post SRST nsect/lbal wait to ~100ms
has been removed from the -mm tree.  Its filename was
     libata-limit-post-srst-nsect-lbal-wait-to-100ms.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: libata: limit post SRST nsect/lbal wait to ~100ms
From: Tejun Heo <htejun@gmail.com>

After SRST, libata used to wait for nsect/lbal to be set to 1/1 for the
slave device.  However, some ATAPI devices don't set nsect/lbal after SRST
and the wait itself isn't too useful as we're gonna wait for !BSY right
after that anyway.

Before reset-seq update, nsect/lbal wait failure used to be ignored and
caused 30sec delay during detection.  After reset-seq, all timeouts are
considered error conditions making libata fail to detect such ATAPI
devices.

This patch limits nsect/lbal wait to around 100ms.  This should give
acceptable behavior to such ATAPI devices while not disturbing the heavily
used code path too much.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-core.c |   32 +++++++++++++++++++-------------
 1 files changed, 19 insertions(+), 13 deletions(-)

diff -puN drivers/ata/libata-core.c~libata-limit-post-srst-nsect-lbal-wait-to-100ms drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~libata-limit-post-srst-nsect-lbal-wait-to-100ms
+++ a/drivers/ata/libata-core.c
@@ -3091,22 +3091,28 @@ static int ata_bus_post_reset(struct ata
 		}
 	}
 
-	/* if device 1 was found in ata_devchk, wait for
-	 * register access, then wait for BSY to clear
+	/* if device 1 was found in ata_devchk, wait for register
+	 * access briefly, then wait for BSY to clear.
 	 */
-	while (dev1) {
-		u8 nsect, lbal;
+	if (dev1) {
+		int i;
 
 		ap->ops->dev_select(ap, 1);
-		nsect = ioread8(ioaddr->nsect_addr);
-		lbal = ioread8(ioaddr->lbal_addr);
-		if ((nsect == 1) && (lbal == 1))
-			break;
-		if (time_after(jiffies, deadline))
-			return -EBUSY;
-		msleep(50);	/* give drive a breather */
-	}
-	if (dev1) {
+
+		/* Wait for register access.  Some ATAPI devices fail
+		 * to set nsect/lbal after reset, so don't waste too
+		 * much time on it.  We're gonna wait for !BSY anyway.
+		 */
+		for (i = 0; i < 2; i++) {
+			u8 nsect, lbal;
+
+			nsect = ioread8(ioaddr->nsect_addr);
+			lbal = ioread8(ioaddr->lbal_addr);
+			if ((nsect == 1) && (lbal == 1))
+				break;
+			msleep(50);	/* give drive a breather */
+		}
+
 		rc = ata_wait_ready(ap, deadline);
 		if (rc) {
 			if (rc != -ENODEV)
_

Patches currently in -mm which might be from htejun@gmail.com are

origin.patch
git-libata-all.patch
pata_acpi-restore-driver.patch
libata-implement-ata_wait_after_reset.patch
drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61.patch
git-scsi-misc.patch
update-documentation-block-barriertxt.patch
block-drop-unnecessary-bvec-rewinding-from-flush_dry_bio_endio.patch
dma-mapping-prevent-dma-dependent-code-from-linking-on.patch
lib-add-idr_for_each.patch
lib-add-idr_for_each-fix.patch
lib-add-idr_remove_all.patch
