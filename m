From: akpm@linux-foundation.org
Subject: + cciss-use-schedule_timeout_uninterruptible-in-scsi-error-handling-code.patch added to -mm tree
Date: Mon, 08 Jun 2009 15:41:37 -0700
Message-ID: <200906082241.n58Mfb6m006841@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43662 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752484AbZFHWlt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jun 2009 18:41:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: scameron@beardog.cca.cpqcorp.net, jens.axboe@oracle.com, mike.miller@hp.com


The patch titled
     cciss: use schedule_timeout_uninterruptible in SCSI error handling code
has been added to the -mm tree.  Its filename is
     cciss-use-schedule_timeout_uninterruptible-in-scsi-error-handling-code.patch

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
Subject: cciss: use schedule_timeout_uninterruptible in SCSI error handling code
From: Stephen M. Cameron <scameron@beardog.cca.cpqcorp.net>

Use schedule_timeout_uninterruptible instead of schedule_timeout in the
scsi error handling code when waiting between TUR polls since we are not
interested in nor want to be interrupted by signals.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cca.cpqcorp.net>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Mike Miller <mike.miller@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss_scsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/cciss_scsi.c~cciss-use-schedule_timeout_uninterruptible-in-scsi-error-handling-code drivers/block/cciss_scsi.c
--- a/drivers/block/cciss_scsi.c~cciss-use-schedule_timeout_uninterruptible-in-scsi-error-handling-code
+++ a/drivers/block/cciss_scsi.c
@@ -1608,7 +1608,7 @@ static int wait_for_device_to_become_rea
 		/* Wait for a bit.  do this first, because if we send
 		 * the TUR right away, the reset will just abort it.
 		 */
-		schedule_timeout_interruptible(waittime);
+		schedule_timeout_uninterruptible(waittime);
 		count++;
 
 		/* Increase wait time with each try, up to a point. */
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

