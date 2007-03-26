From: akpm@linux-foundation.org
Subject: + block-io-errors-on-i2o-disk.patch added to -mm tree
Date: Mon, 26 Mar 2007 00:37:14 -0800
Message-ID: <200703260837.l2Q8bEiX014845@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49643 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752691AbXCZIjR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Mar 2007 04:39:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vvs@sw.ru, Markus.Lidel@shadowconnect.com, jens.axboe@oracle.com, stable@kernel.org


The patch titled
     i2o: block IO errors on i2o disk
has been added to the -mm tree.  Its filename is
     block-io-errors-on-i2o-disk.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i2o: block IO errors on i2o disk
From: Vasily Averin <vvs@sw.ru>

I2O subsystem has been broken in mainstream several months ago (after
2.6.18).  The following patch from Jens Axboe splits struct request ->flags
into two parts: cmd_type and cmd_flags
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=4aff5e2333c9a1609662f2091f55c3f6fffdad36

In i2o layer this patch has replaced flag REQ_SPECIAL by the according
cmd_type.  However i2o has used REQ_SPECIAL not as command type but as
driver-specific flag for the debug purposes.  As result all i2o requests
have type "special" now, are not processed to the hardware and fail with
I/O error:

 i2o/hda:<3>Buffer I/O error on device i2o/hda, logical block 0
Buffer I/O error on device i2o/hda, logical block 0
Buffer I/O error on device i2o/hda, logical block 0
 unable to read partition table
block-osm: device added (TID: 207): i2o/hda

The following patch removes the extra debug checks without any drawbacks and
restores the normal driver's work.

Signed-off-by:	Vasily Averin <vvs@sw.ru>
Cc: Markus Lidel <Markus.Lidel@shadowconnect.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/i2o/i2o_block.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff -puN drivers/message/i2o/i2o_block.c~block-io-errors-on-i2o-disk drivers/message/i2o/i2o_block.c
--- a/drivers/message/i2o/i2o_block.c~block-io-errors-on-i2o-disk
+++ a/drivers/message/i2o/i2o_block.c
@@ -390,13 +390,6 @@ static int i2o_block_prep_req_fn(struct 
 		return BLKPREP_KILL;
 	}
 
-	/* request is already processed by us, so return */
-	if (blk_special_request(req)) {
-		osm_debug("REQ_SPECIAL already set!\n");
-		req->cmd_flags |= REQ_DONTPREP;
-		return BLKPREP_OK;
-	}
-
 	/* connect the i2o_block_request to the request */
 	if (!req->special) {
 		ireq = i2o_block_request_alloc();
@@ -408,11 +401,8 @@ static int i2o_block_prep_req_fn(struct 
 		ireq->i2o_blk_dev = i2o_blk_dev;
 		req->special = ireq;
 		ireq->req = req;
-	} else
-		ireq = req->special;
-
+	}
 	/* do not come back here */
-	req->cmd_type = REQ_TYPE_SPECIAL;
 	req->cmd_flags |= REQ_DONTPREP;
 
 	return BLKPREP_OK;
_

Patches currently in -mm which might be from vvs@sw.ru are

block-io-errors-on-i2o-disk.patch
