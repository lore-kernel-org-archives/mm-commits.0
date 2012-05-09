From: akpm@linux-foundation.org
Subject: + cciss-fix-incorrect-scsi-status-reporting.patch added to -mm tree
Date: Wed, 09 May 2012 15:00:06 -0700
Message-ID: <20120509220007.5223CA03B2@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:54213 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759747Ab2EIWAJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2012 18:00:09 -0400
Received: by vbnl22 with SMTP id l22so117179vbn.1
        for <mm-commits@vger.kernel.org>; Wed, 09 May 2012 15:00:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: scameron@beardog.cce.hp.com, axboe@kernel.dk, roel.vanmeer@bokxing.nl, stable@vger.kernel.org


The patch titled
     Subject: cciss: fix incorrect scsi status reporting
has been added to the -mm tree.  Its filename is
     cciss-fix-incorrect-scsi-status-reporting.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Subject: cciss: fix incorrect scsi status reporting

Delete code which sets SCSI status incorrectly as it's already been set
correctly above this incorrect code.  Bug was introduced by b0e15f6db1110
("cciss: fix typo that causes scsi status to be lost.") in 2009.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Reported-by: Roel van Meer <roel.vanmeer@bokxing.nl>
Tested-by: Roel van Meer <roel.vanmeer@bokxing.nl>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss_scsi.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff -puN drivers/block/cciss_scsi.c~cciss-fix-incorrect-scsi-status-reporting drivers/block/cciss_scsi.c
--- a/drivers/block/cciss_scsi.c~cciss-fix-incorrect-scsi-status-reporting
+++ a/drivers/block/cciss_scsi.c
@@ -763,16 +763,7 @@ static void complete_scsi_command(Comman
 		{
 			case CMD_TARGET_STATUS:
 				/* Pass it up to the upper layers... */
-				if( ei->ScsiStatus)
-                		{
-#if 0
-                    			printk(KERN_WARNING "cciss: cmd %p "
-						"has SCSI Status = %x\n",
-						c, ei->ScsiStatus);
-#endif
-					cmd->result |= (ei->ScsiStatus << 1);
-                		}
-				else {  /* scsi status is zero??? How??? */
+				if (!ei->ScsiStatus) {
 					
 	/* Ordinarily, this case should never happen, but there is a bug
 	   in some released firmware revisions that allows it to happen
_
Subject: Subject: cciss: fix incorrect scsi status reporting

Patches currently in -mm which might be from scameron@beardog.cce.hp.com are

cciss-fix-incorrect-scsi-status-reporting.patch

