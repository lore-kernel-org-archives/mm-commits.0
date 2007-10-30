From: akpm@linux-foundation.org
Subject: + i2o-debug-messages-corrected.patch added to -mm tree
Date: Tue, 30 Oct 2007 13:04:37 -0700
Message-ID: <200710302004.l9UK4b6M025613@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57271 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752928AbXJ3UFS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Oct 2007 16:05:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vvs@sw.ru


The patch titled
     i2o: debug messages corrected
has been added to the -mm tree.  Its filename is
     i2o-debug-messages-corrected.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

i2o-debug-messages-corrected.patch
