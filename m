From: akpm@linux-foundation.org
Subject: + cciss-decode-unit-attention-in-scsi-error-handling-code.patch added to -mm tree
Date: Mon, 08 Jun 2009 15:41:51 -0700
Message-ID: <200906082241.n58Mfpt2007046@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35369 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755444AbZFHWmE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jun 2009 18:42:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: scameron@beardog.cca.cpqcorp.net, jens.axboe@oracle.com, mike.miller@hp.com


The patch titled
     cciss: decode unit attention in SCSI error handling code
has been added to the -mm tree.  Its filename is
     cciss-decode-unit-attention-in-scsi-error-handling-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
cciss-use-schedule_timeout_uninterruptible-in-scsi-error-handling-code.patch
cciss-factor-out-core-of-sendcmd_withirq-for-use-by-scsi-error-handling-code.patch
cciss-simplify-interface-of-sendcmd-and-sendcmd_withirq.patch
cciss-factor-out-fix-target-status-processing-code-from-sendcmd-functions.patch
cciss-separate-error-processing-and-command-retrying-code-in-sendcmd_withirq_core.patch
cciss-change-scsi-error-handling-routines-to-work-with-interrupts-enabled.patch
cciss-remove-no-longer-needed-sendcmd-reject-processing-code.patch
cciss-decode-unit-attention-in-scsi-error-handling-code.patch

