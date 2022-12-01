Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB763C4321E
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:04:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbiLAAEn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:04:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbiLAADX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:03:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 002698D666
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:01:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9FC55B81D83
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:01:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40DD9C433D7;
        Thu,  1 Dec 2022 00:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852889;
        bh=lYXBZRVgzR6+bIaqTPdaDuG60izpT6vPqxTlGi/EuCU=;
        h=Date:To:From:Subject:From;
        b=xtkTrdXRC8LFNC8NbSdeGAvL07ORomHEmQgRN+jzTfSYqxyCZdScVf5pfxVAn7UkQ
         4qTgM99PO43lggm4u42H+kxm8ItJq/nl85St5c3rz/47CX1Uf54wctrQBIaqKZjuEb
         k0C4dfEho+V8nCsRgF039L3UR4jc/bmcdcQ8/oOc=
Date:   Wed, 30 Nov 2022 16:01:28 -0800
To:     mm-commits@vger.kernel.org, suleiman@google.com, nphamcs@gmail.com,
        ngupta@vflare.org, minchan@kernel.org, avromanov@sberdevices.ru,
        senozhatsky@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-add-recompress-flag-to-read_block_state.patch removed from -mm tree
Message-Id: <20221201000129.40DD9C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zram: add recompress flag to read_block_state()
has been removed from the -mm tree.  Its filename was
     zram-add-recompress-flag-to-read_block_state.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: add recompress flag to read_block_state()
Date: Wed, 9 Nov 2022 20:50:39 +0900

Add a new flag to zram block state that shows if the page was recompressed
(using alternative compression algorithm).

Link: https://lkml.kernel.org/r/20221109115047.2921851-6-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Alexey Romanov <avromanov@sberdevices.ru>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Suleiman Souhlal <suleiman@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/blockdev/zram.rst |    9 ++++++---
 drivers/block/zram/zram_drv.c               |    5 +++--
 2 files changed, 9 insertions(+), 5 deletions(-)

--- a/Documentation/admin-guide/blockdev/zram.rst~zram-add-recompress-flag-to-read_block_state
+++ a/Documentation/admin-guide/blockdev/zram.rst
@@ -411,9 +411,10 @@ pages of the process with*pagemap.
 If you enable the feature, you could see block state via
 /sys/kernel/debug/zram/zram0/block_state". The output is as follows::
 
-	  300    75.033841 .wh.
-	  301    63.806904 s...
-	  302    63.806919 ..hi
+	  300    75.033841 .wh..
+	  301    63.806904 s....
+	  302    63.806919 ..hi.
+	  303    62.801919 ....r
 
 First column
 	zram's block index.
@@ -430,6 +431,8 @@ Third column
 		huge page
 	i:
 		idle page
+	r:
+		recompressed page (secondary compression algorithm)
 
 First line of above example says 300th block is accessed at 75.033841sec
 and the block's state is huge so it is written back to the backing
--- a/drivers/block/zram/zram_drv.c~zram-add-recompress-flag-to-read_block_state
+++ a/drivers/block/zram/zram_drv.c
@@ -936,13 +936,14 @@ static ssize_t read_block_state(struct f
 
 		ts = ktime_to_timespec64(zram->table[index].ac_time);
 		copied = snprintf(kbuf + written, count,
-			"%12zd %12lld.%06lu %c%c%c%c\n",
+			"%12zd %12lld.%06lu %c%c%c%c%c\n",
 			index, (s64)ts.tv_sec,
 			ts.tv_nsec / NSEC_PER_USEC,
 			zram_test_flag(zram, index, ZRAM_SAME) ? 's' : '.',
 			zram_test_flag(zram, index, ZRAM_WB) ? 'w' : '.',
 			zram_test_flag(zram, index, ZRAM_HUGE) ? 'h' : '.',
-			zram_test_flag(zram, index, ZRAM_IDLE) ? 'i' : '.');
+			zram_test_flag(zram, index, ZRAM_IDLE) ? 'i' : '.',
+			zram_get_priority(zram, index) ? 'r' : '.');
 
 		if (count <= copied) {
 			zram_slot_unlock(zram, index);
_

Patches currently in -mm which might be from senozhatsky@chromium.org are


