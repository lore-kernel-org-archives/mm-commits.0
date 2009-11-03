From: akpm@linux-foundation.org
Subject: + drivers-message-move-dereference-after-null-test.patch added to -mm tree
Date: Mon, 02 Nov 2009 22:23:59 -0800
Message-ID: <200911030624.nA36O0GU028834@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40216 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754204AbZKCGYH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Nov 2009 01:24:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, James.Bottomley@suse.de, kashyap.desai@lsi.com


The patch titled
     drivers/message: Move dereference after NULL test
has been added to the -mm tree.  Its filename is
     drivers-message-move-dereference-after-null-test.patch

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
Subject: drivers/message: Move dereference after NULL test
From: Julia Lawall <julia@diku.dk>

If the NULL test on dev->i2o_dev or i2o_dev is needed, then the dereference
should be after the NULL test.

A simplified version of the semantic match that detects this problem is as
follows (http://coccinelle.lip6.fr/):

// <smpl>
@match exists@
expression x, E;
identifier fld;
@@

* x->fld
  ... when != \(x = E\|&x\)
* x == NULL
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: James Bottomley <James.Bottomley@suse.de>
Cc: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/i2o/i2o_block.c |    3 ++-
 drivers/message/i2o/i2o_scsi.c  |    3 +--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/message/i2o/i2o_block.c~drivers-message-move-dereference-after-null-test drivers/message/i2o/i2o_block.c
--- a/drivers/message/i2o/i2o_block.c~drivers-message-move-dereference-after-null-test
+++ a/drivers/message/i2o/i2o_block.c
@@ -711,7 +711,7 @@ static int i2o_block_transfer(struct req
 {
 	struct i2o_block_device *dev = req->rq_disk->private_data;
 	struct i2o_controller *c;
-	u32 tid = dev->i2o_dev->lct_data.tid;
+	u32 tid;
 	struct i2o_message *msg;
 	u32 *mptr;
 	struct i2o_block_request *ireq = req->special;
@@ -727,6 +727,7 @@ static int i2o_block_transfer(struct req
 		goto exit;
 	}
 
+	tid = dev->i2o_dev->lct_data.tid;
 	c = dev->i2o_dev->iop;
 
 	msg = i2o_msg_get(c);
diff -puN drivers/message/i2o/i2o_scsi.c~drivers-message-move-dereference-after-null-test drivers/message/i2o/i2o_scsi.c
--- a/drivers/message/i2o/i2o_scsi.c~drivers-message-move-dereference-after-null-test
+++ a/drivers/message/i2o/i2o_scsi.c
@@ -528,7 +528,6 @@ static int i2o_scsi_queuecommand(struct 
 	 *      Do the incoming paperwork
 	 */
 	i2o_dev = SCpnt->device->hostdata;
-	c = i2o_dev->iop;
 
 	SCpnt->scsi_done = done;
 
@@ -538,7 +537,7 @@ static int i2o_scsi_queuecommand(struct 
 		done(SCpnt);
 		goto exit;
 	}
