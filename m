From: akpm@linux-foundation.org
Subject: [merged] cciss-fix-incorrect-scsi-status-reporting.patch removed from -mm tree
Date: Fri, 24 Aug 2012 11:41:12 -0700
Message-ID: <20120824184112.BA21B100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:65465 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760009Ab2HXSlN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Aug 2012 14:41:13 -0400
Received: by mail-vc0-f202.google.com with SMTP id p1so311760vcq.1
        for <mm-commits@vger.kernel.org>; Fri, 24 Aug 2012 11:41:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: scameron@beardog.cce.hp.com, axboe@kernel.dk, roel.vanmeer@bokxing.nl, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: cciss: fix incorrect scsi status reporting
has been removed from the -mm tree.  Its filename was
     cciss-fix-incorrect-scsi-status-reporting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from scameron@beardog.cce.hp.com are

origin.patch
cciss-cleanup-bitops-usage.patch
cciss-use-check_signature.patch

