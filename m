From: akpm@linux-foundation.org
Subject: + cciss-set-scsi-max-cmd-len-to-16-as-default-is-wrong.patch added to -mm tree
Date: Mon, 14 Jun 2010 16:27:47 -0700
Message-ID: <201006142327.o5ENRlxb005227@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48458 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757108Ab0FNX21 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Jun 2010 19:28:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: scameron@beardog.cce.hp.com, axboe@kernel.dk, mikem@beardog.cce.hp.com


The patch titled
     cciss: set SCSI max cmd len to 16, as default is wrong
has been added to the -mm tree.  Its filename is
     cciss-set-scsi-max-cmd-len-to-16-as-default-is-wrong.patch

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
Subject: cciss: set SCSI max cmd len to 16, as default is wrong
From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Mike Miller <mikem@beardog.cce.hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss_scsi.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/block/cciss_scsi.c~cciss-set-scsi-max-cmd-len-to-16-as-default-is-wrong drivers/block/cciss_scsi.c
--- a/drivers/block/cciss_scsi.c~cciss-set-scsi-max-cmd-len-to-16-as-default-is-wrong
+++ a/drivers/block/cciss_scsi.c
@@ -861,6 +861,7 @@ cciss_scsi_detect(int ctlr)
 	sh->n_io_port = 0;	// I don't think we use these two...
 	sh->this_id = SELF_SCSI_ID;  
 	sh->sg_tablesize = hba[ctlr]->maxsgentries;
+	sh->max_cmd_len = MAX_COMMAND_SIZE;
 
 	((struct cciss_scsi_adapter_data_t *) 
 		hba[ctlr]->scsi_ctlr)->scsi_host = sh;
_

Patches currently in -mm which might be from scameron@beardog.cce.hp.com are

linux-next.patch
cciss-set-scsi-max-cmd-len-to-16-as-default-is-wrong.patch

