From: akpm@linux-foundation.org
Subject: - i2o-debug-messages-corrected.patch removed from -mm tree
Date: Mon, 05 Nov 2007 21:51:58 -0800
Message-ID: <200711060551.lA65pwkG007141@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41192 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753751AbXKFFxH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Nov 2007 00:53:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vvs@sw.ru, mm-commits@vger.kernel.org


The patch titled
     i2o: debug messages corrected
has been removed from the -mm tree.  Its filename was
     i2o-debug-messages-corrected.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i2o: debug messages corrected
From: Vasily Averin <vvs@sw.ru>

max_phys_segments and max_sectors were swapped

Signed-off-by:	Vasily Averin <vvs@sw.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/i2o/i2o_block.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/message/i2o/i2o_block.c~i2o-debug-messages-corrected drivers/message/i2o/i2o_block.c
--- a/drivers/message/i2o/i2o_block.c~i2o-debug-messages-corrected
+++ a/drivers/message/i2o/i2o_block.c
@@ -1077,8 +1077,8 @@ static int i2o_block_probe(struct device
 	blk_queue_max_sectors(queue, max_sectors);
 	blk_queue_max_hw_segments(queue, i2o_sg_tablesize(c, body_size));
 
-	osm_debug("max sectors = %d\n", queue->max_phys_segments);
-	osm_debug("phys segments = %d\n", queue->max_sectors);
+	osm_debug("max sectors = %d\n", queue->max_sectors);
+	osm_debug("phys segments = %d\n", queue->max_phys_segments);
 	osm_debug("max hw segments = %d\n", queue->max_hw_segments);
 
 	/*
_

Patches currently in -mm which might be from vvs@sw.ru are

origin.patch
