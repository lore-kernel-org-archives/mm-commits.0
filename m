From: akpm@linux-foundation.org
Subject: [folded] hpsa-fix-incorrect-scsi-status-reporting.patch removed from -mm tree
Date: Tue, 08 Dec 2009 14:07:40 -0800
Message-ID: <200912082207.nB8M7eZh003794@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54953 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966644AbZLHWIF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Dec 2009 17:08:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: scameron@beardog.cce.hp.com, James.Bottomley@HansenPartnership.com, achiang@hp.com, jens.axboe@oracle.com, mikem@beardog.cce.hp.com, mm-commits@vger.kernel.org


The patch titled
     hpsa: fix incorrect SCSI status reporting
has been removed from the -mm tree.  Its filename was
     hpsa-fix-incorrect-scsi-status-reporting.patch

This patch was dropped because it was folded into scsi-add-hpsa-driver-for-hp-smart-array-controllers.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hpsa: fix incorrect SCSI status reporting
From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Cc: Mike Miller <mikem@beardog.cce.hp.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Alex Chiang <achiang@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/hpsa.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN drivers/scsi/hpsa.c~hpsa-fix-incorrect-scsi-status-reporting drivers/scsi/hpsa.c
--- a/drivers/scsi/hpsa.c~hpsa-fix-incorrect-scsi-status-reporting
+++ a/drivers/scsi/hpsa.c
@@ -930,7 +930,7 @@ static void complete_scsi_command(struct
 
 	cmd->result = (DID_OK << 16); 		/* host byte */
 	cmd->result |= (COMMAND_COMPLETE << 8);	/* msg byte */
-	cmd->result |= (ei->ScsiStatus);
+	cmd->result |= (ei->ScsiStatus << 1);
 
 	/* copy the sense data whether we need to or not. */
 	memcpy(cmd->sense_buffer, ei->SenseInfo,
@@ -991,7 +991,6 @@ static void complete_scsi_command(struct
 
 
 			/* Must be some other type of check condition */
-			cmd->result |= (ei->ScsiStatus << 1);
 			dev_warn(&h->pdev->dev, "cp %p has check condition: "
 					"unknown type: "
 					"Sense: 0x%x, ASC: 0x%x, ASCQ: 0x%x, "
@@ -1013,8 +1012,6 @@ static void complete_scsi_command(struct
 		 * Pass it up to the upper layers...
 		 */
 		if (ei->ScsiStatus) {
