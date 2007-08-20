From: akpm@linux-foundation.org
Subject: - libata-adjust-libata-to-ignore-errors-after.patch removed from -mm tree
Date: Mon, 20 Aug 2007 12:12:24 -0700
Message-ID: <200708201912.l7KJCOg5018349@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45556 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760595AbXHTTVa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Aug 2007 15:21:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpower@sysreset.com, htejun@gmail.com, jeff@garzik.org, liml@rtr.ca, mm-commits@vger.kernel.org


The patch titled
     libata: adjust libata to ignore errors after spinup
has been removed from the -mm tree.  Its filename was
     libata-adjust-libata-to-ignore-errors-after.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: libata: adjust libata to ignore errors after spinup
From: Ryan Power <rpower@sysreset.com>

Adjust libata to ignore errors after spinup

This patch is to ignore errors from the spinup attempt if the drive is
in the "standby id" state.

Signed-off-by: Ryan Power <rpower@sysreset.com>
Acked-by: Mark Lord <liml@rtr.ca>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-core.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/ata/libata-core.c~libata-adjust-libata-to-ignore-errors-after drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~libata-adjust-libata-to-ignore-errors-after
+++ a/drivers/ata/libata-core.c
@@ -1723,7 +1723,7 @@ int ata_dev_read_id(struct ata_device *d
 		tf.protocol = ATA_PROT_NODATA;
 		tf.flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
 		err_mask = ata_exec_internal(dev, &tf, NULL, DMA_NONE, NULL, 0);
-		if (err_mask) {
+		if (err_mask && id[2] != 0x738c) {
 			rc = -EIO;
 			reason = "SPINUP failed";
 			goto err_out;
_

Patches currently in -mm which might be from rpower@sysreset.com are

origin.patch
