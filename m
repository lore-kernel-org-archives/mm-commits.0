From: akpm@linux-foundation.org
Subject: + cciss-fix-bad-scsi-status-reporting.patch added to -mm tree
Date: Tue, 08 Dec 2009 14:04:54 -0800
Message-ID: <200912082204.nB8M4src029240@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46792 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966518AbZLHWFT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Dec 2009 17:05:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: scameron@beardog.cce.hp.com, jens.axboe@oracle.com


The patch titled
     cciss: fix bad scsi status reporting.
has been added to the -mm tree.  Its filename is
     cciss-fix-bad-scsi-status-reporting.patch

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
Subject: cciss: fix bad scsi status reporting.
From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

The SCSI status needs to be shifted left 1 bit, and only needs to be set
once.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss_scsi.c |   21 +++------------------
 1 file changed, 3 insertions(+), 18 deletions(-)

diff -puN drivers/block/cciss_scsi.c~cciss-fix-bad-scsi-status-reporting drivers/block/cciss_scsi.c
--- a/drivers/block/cciss_scsi.c~cciss-fix-bad-scsi-status-reporting
+++ a/drivers/block/cciss_scsi.c
@@ -728,9 +728,7 @@ complete_scsi_command( CommandList_struc
 
 	cmd->result = (DID_OK << 16); 		/* host byte */
 	cmd->result |= (COMMAND_COMPLETE << 8);	/* msg byte */
-	/* cmd->result |= (GOOD < 1); */		/* status byte */
-
-	cmd->result |= (ei->ScsiStatus);
+	cmd->result |= (ei->ScsiStatus << 1);
 	/* printk("Scsistatus is 0x%02x\n", ei->ScsiStatus);  */
 
 	/* copy the sense data whether we need to or not. */
@@ -747,18 +745,8 @@ complete_scsi_command( CommandList_struc
 		{
 			case CMD_TARGET_STATUS:
 				/* Pass it up to the upper layers... */
-				if( ei->ScsiStatus)
-                		{
-#if 0
-                    			printk(KERN_WARNING "cciss: cmd %p "
-					"has SCSI Status = %x\n",
-                        			cp,  
-						ei->ScsiStatus); 
-#endif
-					cmd->result |= (ei->ScsiStatus << 1);
-                		}
-				else {  /* scsi status is zero??? How??? */
-					
+				if (ei->ScsiStatus == 0)
+					cmd->result = DID_NO_CONNECT << 16;
 	/* Ordinarily, this case should never happen, but there is a bug
 	   in some released firmware revisions that allows it to happen
 	   if, for example, a 4100 backplane loses power and the tape
@@ -766,9 +754,6 @@ complete_scsi_command( CommandList_struc
 	   kind because we can't show that it wasn't. We will make it
 	   look like selection timeout since that is the most common
 	   reason for this to occur, and it's severe enough. */
