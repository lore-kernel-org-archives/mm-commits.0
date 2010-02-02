From: akpm@linux-foundation.org
Subject: [withdrawn] hpsa-fix-scsi-status-reporting-yet-again.patch removed from -mm tree
Date: Tue, 02 Feb 2010 14:32:08 -0800
Message-ID: <201002022232.o12MW8mR018404@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43964 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757068Ab0BBWcX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Feb 2010 17:32:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: scameron@beardog.cce.hp.com, James.Bottomley@HansenPartnership.com, mm-commits@vger.kernel.org


The patch titled
     hpsa: fix scsi status reporting yet again.
has been removed from the -mm tree.  Its filename was
     hpsa-fix-scsi-status-reporting-yet-again.patch

This patch was dropped because it was withdrawn

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hpsa: fix scsi status reporting yet again.
From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Fix scsi status reporting yet again, reverting an earlier attempt.  The
status byte does not need to be shifted << 1.  Code in other drivers that
does "scp->result |= CHECK_CONDITION << 1;" works because CHECK_CONDITION
macro is pre-shifted right 1 bit.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/hpsa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/hpsa.c~hpsa-fix-scsi-status-reporting-yet-again drivers/scsi/hpsa.c
--- a/drivers/scsi/hpsa.c~hpsa-fix-scsi-status-reporting-yet-again
+++ a/drivers/scsi/hpsa.c
@@ -930,7 +930,7 @@ static void complete_scsi_command(struct
 
 	cmd->result = (DID_OK << 16); 		/* host byte */
 	cmd->result |= (COMMAND_COMPLETE << 8);	/* msg byte */
-	cmd->result |= (ei->ScsiStatus << 1);
+	cmd->result |= ei->ScsiStatus;
 
 	/* copy the sense data whether we need to or not. */
 	memcpy(cmd->sense_buffer, ei->SenseInfo,
_

Patches currently in -mm which might be from scameron@beardog.cce.hp.com are

hpsa-fix-scsi-status-reporting-yet-again.patch
drivers-scsi-hpsac-fix-section-mismatch.patch

