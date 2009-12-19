From: akpm@linux-foundation.org
Subject: + hpsa-fix-scsi-status-reporting-yet-again.patch added to -mm tree
Date: Fri, 18 Dec 2009 16:00:34 -0800
Message-ID: <200912190000.nBJ00YSq026293@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47158 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752610AbZLSAAp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Dec 2009 19:00:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: scameron@beardog.cce.hp.com, James.Bottomley@HansenPartnership.com


The patch titled
     hpsa: fix scsi status reporting yet again.
has been added to the -mm tree.  Its filename is
     hpsa-fix-scsi-status-reporting-yet-again.patch

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
cciss-fix-bad-scsi-status-reporting.patch

