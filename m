From: akpm@linux-foundation.org
Subject: + hpsa-return-scsi_mlqueue_host_busy-on-command-allocation-failure.patch added to -mm tree
Date: Tue, 08 Dec 2009 14:04:14 -0800
Message-ID: <200912082204.nB8M4EKC027594@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49176 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966469AbZLHWEj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Dec 2009 17:04:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: scameron@beardog.cce.hp.com, James.Bottomley@HansenPartnership.com, achiang@hp.com, jens.axboe@oracle.com, mikem@beardog.cce.hp.com


The patch titled
     hpsa: return SCSI_MLQUEUE_HOST_BUSY on command allocation failure.
has been added to the -mm tree.  Its filename is
     hpsa-return-scsi_mlqueue_host_busy-on-command-allocation-failure.patch

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
hpsa-use-msleep-instead-of-schedule_timeout.patch
hpsa-use-msleep-instead-of-schedule_timeout-fix.patch
hpsa-rename-too-generic-variable-names.patch
hpsa-return-scsi_mlqueue_host_busy-on-command-allocation-failure.patch
hpsa-fix-incorrect-scsi-status-reporting.patch
hpsa-suppress-messages-due-to-unsupport-scsi-report_luns.patch

