From: akpm@linux-foundation.org
Subject: - memstick-use-__blk_end_request-to-complete-requests.patch removed from -mm tree
Date: Sat, 09 Feb 2008 10:19:12 -0800
Message-ID: <200802091820.m19IK59O025557@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38599 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752933AbYBISrV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 9 Feb 2008 13:47:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oakad@yahoo.com, mm-commits@vger.kernel.org


The patch titled
     memstick: use __blk_end_request to complete requests
has been removed from the -mm tree.  Its filename was
     memstick-use-__blk_end_request-to-complete-requests.patch

This patch was dropped because it was folded into memstick-initial-commit-for-sony-memorystick-support.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memstick: use __blk_end_request to complete requests
From: Alex Dubov <oakad@yahoo.com>

Signed-off-by: Alex Dubov <oakad@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/core/mspro_block.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff -puN drivers/memstick/core/mspro_block.c~memstick-use-__blk_end_request-to-complete-requests drivers/memstick/core/mspro_block.c
--- a/drivers/memstick/core/mspro_block.c~memstick-use-__blk_end_request-to-complete-requests
+++ a/drivers/memstick/core/mspro_block.c
@@ -668,20 +668,13 @@ static void mspro_block_process_request(
 
 		spin_lock_irqsave(&msb->q_lock, flags);
 		if (rc >= 0)
-			chunk = end_that_request_chunk(req, 1, rc);
+			chunk = __blk_end_request(req, 0, rc);
 		else
-			chunk = end_that_request_first(req, rc,
-						       req->current_nr_sectors);
+			chunk = __blk_end_request(req, rc, 0);
 
 		dev_dbg(&card->dev, "end chunk %d, %d\n", rc, chunk);
-		if (!chunk) {
-			add_disk_randomness(req->rq_disk);
-			blkdev_dequeue_request(req);
-			end_that_request_last(req, rc > 0 ? 1 : rc);
-		}
 		spin_unlock_irqrestore(&msb->q_lock, flags);
 	} while (chunk);
-
 }
 
 static int mspro_block_has_request(struct mspro_block_data *msb)
_

Patches currently in -mm which might be from oakad@yahoo.com are

origin.patch
memstick-initial-commit-for-sony-memorystick-support.patch
memstick-use-__blk_end_request-to-complete-requests.patch
memstick-fix-attribute-structure-casting-in-mspro_block_resume.patch
memstick-disable-busted-code.patch
