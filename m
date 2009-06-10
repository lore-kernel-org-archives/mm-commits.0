From: akpm@linux-foundation.org
Subject: [merged] cciss-decode-unit-attention-in-scsi-error-handling-code.patch removed from -mm tree
Date: Wed, 10 Jun 2009 10:56:27 -0700
Message-ID: <200906101756.n5AHuRDr008511@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39634 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754888AbZFJR4i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Jun 2009 13:56:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: scameron@beardog.cca.cpqcorp.net, jens.axboe@oracle.com, mike.miller@hp.com, mm-commits@vger.kernel.org


The patch titled
     cciss: decode unit attention in SCSI error handling code
has been removed from the -mm tree.  Its filename was
     cciss-decode-unit-attention-in-scsi-error-handling-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cciss: decode unit attention in SCSI error handling code
From: Stephen M. Cameron <scameron@beardog.cca.cpqcorp.net>

Make SCSI reset error handler decode unit attention ASC and after a target
reset wait for a unit attention that indicates a reset occurred rather
than just for any old unit attention.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cca.cpqcorp.net>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Mike Miller <mike.miller@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss_scsi.c |   23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff -puN drivers/block/cciss_scsi.c~cciss-decode-unit-attention-in-scsi-error-handling-code drivers/block/cciss_scsi.c
--- a/drivers/block/cciss_scsi.c~cciss-decode-unit-attention-in-scsi-error-handling-code
+++ a/drivers/block/cciss_scsi.c
@@ -1604,16 +1604,25 @@ static int wait_for_device_to_become_rea
 
 		(void) process_sendcmd_error(h, c);
 
-		if (rc == 0 && c->err_info->CommandStatus == CMD_SUCCESS)
-			break;
+		if (rc != 0)
+			goto retry_tur;
 
-		if (rc == 0 &&
-			c->err_info->CommandStatus == CMD_TARGET_STATUS &&
-			c->err_info->ScsiStatus == SAM_STAT_CHECK_CONDITION &&
-			(c->err_info->SenseInfo[2] == NO_SENSE ||
-			c->err_info->SenseInfo[2] == UNIT_ATTENTION))
+		if (c->err_info->CommandStatus == CMD_SUCCESS)
 			break;
 
+		if (c->err_info->CommandStatus == CMD_TARGET_STATUS &&
+			c->err_info->ScsiStatus == SAM_STAT_CHECK_CONDITION) {
+			if (c->err_info->SenseInfo[2] == NO_SENSE)
+				break;
+			if (c->err_info->SenseInfo[2] == UNIT_ATTENTION) {
+				unsigned char asc;
+				asc = c->err_info->SenseInfo[12];
+				check_for_unit_attention(h, c);
+				if (asc == POWER_OR_RESET)
+					break;
+			}
+		}
+retry_tur:
 		printk(KERN_WARNING "cciss%d: Waiting %d secs "
 			"for device to become ready.\n",
 			h->ctlr, waittime / HZ);
_

Patches currently in -mm which might be from scameron@beardog.cca.cpqcorp.net are

linux-next.patch

