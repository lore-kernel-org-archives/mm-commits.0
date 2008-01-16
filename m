From: akpm@linux-foundation.org
Subject: - libata-relocate-sdev-manage_start_stop-configuration.patch removed from -mm tree
Date: Tue, 15 Jan 2008 17:40:18 -0800
Message-ID: <200801160140.m0G1eInM014100@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47958 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756036AbYAPBtT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Jan 2008 20:49:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: htejun@gmail.com, bunk@kernel.org, mm-commits@vger.kernel.org


The patch titled
     libata: relocate sdev->manage_start_stop configuration
has been removed from the -mm tree.  Its filename was
     libata-relocate-sdev-manage_start_stop-configuration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: libata: relocate sdev->manage_start_stop configuration
From: Tejun Heo <htejun@gmail.com>

After 9b8e8de7, manage_start_stop configuration depends on valid ATA
device.  Move it into ata_scsi_dev_config().  This was detected by the
coverity checker.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-scsi.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/ata/libata-scsi.c~libata-relocate-sdev-manage_start_stop-configuration drivers/ata/libata-scsi.c
--- a/drivers/ata/libata-scsi.c~libata-relocate-sdev-manage_start_stop-configuration
+++ a/drivers/ata/libata-scsi.c
@@ -841,6 +841,9 @@ static void ata_scsi_dev_config(struct s
 		blk_queue_max_hw_segments(q, q->max_hw_segments - 1);
 	}
 
+	if (dev->class == ATA_DEV_ATA)
+		sdev->manage_start_stop = 1;
+
 	if (dev->flags & ATA_DFLAG_AN)
 		set_bit(SDEV_EVT_MEDIA_CHANGE, sdev->supported_events);
 
@@ -872,9 +875,6 @@ int ata_scsi_slave_config(struct scsi_de
 
 	ata_scsi_sdev_config(sdev);
 
-	if (dev->class == ATA_DEV_ATA)
-		sdev->manage_start_stop = 1;
-
 	if (dev)
 		ata_scsi_dev_config(sdev, dev);
 
_

Patches currently in -mm which might be from htejun@gmail.com are

origin.patch
git-kbuild.patch
git-libata-all.patch
pata_legacy-resychronize-with-upstream-changes-and-resubmit.patch
git-scsi-misc.patch
