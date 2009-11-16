From: akpm@linux-foundation.org
Subject: [folded] hpsa-fix-typo-that-causes-scsi-status-to-be-lost.patch removed from -mm tree
Date: Mon, 16 Nov 2009 13:28:48 -0800
Message-ID: <200911162128.nAGLSmqm001823@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43759 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754221AbZKPV2y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Nov 2009 16:28:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: scameron@beardog.cce.hp.com, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, mikem@beardog.cce.hp.com, mm-commits@vger.kernel.org


The patch titled
     hpsa: fix typo that causes scsi status to be lost
has been removed from the -mm tree.  Its filename was
     hpsa-fix-typo-that-causes-scsi-status-to-be-lost.patch

This patch was dropped because it was folded into scsi-add-hpsa-driver-for-hp-smart-array-controllers.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hpsa: fix typo that causes scsi status to be lost
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>

hpsa: fix typo that causes scsi status to be lost

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Mike Miller <mikem@beardog.cce.hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/hpsa.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/hpsa.c~hpsa-fix-typo-that-causes-scsi-status-to-be-lost drivers/scsi/hpsa.c
--- a/drivers/scsi/hpsa.c~hpsa-fix-typo-that-causes-scsi-status-to-be-lost
+++ a/drivers/scsi/hpsa.c
@@ -987,7 +987,7 @@ static void complete_scsi_command(struct
 
 
 			/* Must be some other type of check condition */
-			cmd->result |= (ei->ScsiStatus < 1);
+			cmd->result |= (ei->ScsiStatus << 1);
 			dev_warn(&h->pdev->dev, "cp %p has check condition: "
 					"unknown type: "
 					"Sense: 0x%x, ASC: 0x%x, ASCQ: 0x%x, "
@@ -1010,7 +1010,7 @@ static void complete_scsi_command(struct
 		 */
 		if (ei->ScsiStatus) {
 
-			cmd->result |= (ei->ScsiStatus < 1);
+			cmd->result |= (ei->ScsiStatus << 1);
 			dev_warn(&h->pdev->dev, "cp %p has status 0x%x "
 				"Sense: 0x%x, ASC: 0x%x, ASCQ: 0x%x, "
 				"Returning result: 0x%x\n",
_

Patches currently in -mm which might be from scameron@beardog.cce.hp.com are

linux-next.patch
scsi-add-hpsa-driver-for-hp-smart-array-controllers.patch
hpsa-fix-typo-that-causes-scsi-status-to-be-lost.patch
hpsa-make-device-attrs-static.patch

