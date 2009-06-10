From: akpm@linux-foundation.org
Subject: [merged] cciss-use-schedule_timeout_uninterruptible-in-scsi-error-handling-code.patch removed from -mm tree
Date: Wed, 10 Jun 2009 10:56:12 -0700
Message-ID: <200906101756.n5AHuC03008260@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43367 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754285AbZFJR4X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Jun 2009 13:56:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: scameron@beardog.cca.cpqcorp.net, jens.axboe@oracle.com, mike.miller@hp.com, mm-commits@vger.kernel.org


The patch titled
     cciss: use schedule_timeout_uninterruptible in SCSI error handling code
has been removed from the -mm tree.  Its filename was
     cciss-use-schedule_timeout_uninterruptible-in-scsi-error-handling-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

