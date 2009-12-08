From: akpm@linux-foundation.org
Subject: [folded] hpsa-return-scsi_mlqueue_host_busy-on-command-allocation-failure.patch removed from -mm tree
Date: Tue, 08 Dec 2009 14:07:35 -0800
Message-ID: <200912082207.nB8M7Z2W003556@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51184 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966643AbZLHWIA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Dec 2009 17:08:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: scameron@beardog.cce.hp.com, James.Bottomley@HansenPartnership.com, achiang@hp.com, jens.axboe@oracle.com, mikem@beardog.cce.hp.com, mm-commits@vger.kernel.org


The patch titled
     hpsa: return SCSI_MLQUEUE_HOST_BUSY on command allocation failure.
has been removed from the -mm tree.  Its filename was
     hpsa-return-scsi_mlqueue_host_busy-on-command-allocation-failure.patch

This patch was dropped because it was folded into scsi-add-hpsa-driver-for-hp-smart-array-controllers.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hpsa: return SCSI_MLQUEUE_HOST_BUSY on command allocation failure.
From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Cc: Mike Miller <mikem@beardog.cce.hp.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Alex Chiang <achiang@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/hpsa.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/scsi/hpsa.c~hpsa-return-scsi_mlqueue_host_busy-on-command-allocation-failure drivers/scsi/hpsa.c
--- a/drivers/scsi/hpsa.c~hpsa-return-scsi_mlqueue_host_busy-on-command-allocation-failure
+++ a/drivers/scsi/hpsa.c
@@ -1842,9 +1842,7 @@ static int hpsa_scsi_queue_command(struc
 	spin_unlock_irqrestore(&h->lock, flags);
 	if (c == NULL) {			/* trouble... */
 		dev_err(&h->pdev->dev, "cmd_alloc returned NULL!\n");
-		cmd->result = DID_NO_CONNECT << 16;
-		done(cmd);
-		return 0;
+		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 
 	/* Fill in the command list header */
_

Patches currently in -mm which might be from scameron@beardog.cce.hp.com are

origin.patch
scsi-add-hpsa-driver-for-hp-smart-array-controllers.patch
hpsa-return-scsi_mlqueue_host_busy-on-command-allocation-failure.patch
hpsa-fix-incorrect-scsi-status-reporting.patch
hpsa-suppress-messages-due-to-unsupport-scsi-report_luns.patch
cciss-fix-bad-scsi-status-reporting.patch

