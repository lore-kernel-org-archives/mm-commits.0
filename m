Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06480C4321E
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:05:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbiLAAFe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:05:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbiLAADe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:03:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D4728EE4C
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:01:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D4E896176C
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:01:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26B54C433D7;
        Thu,  1 Dec 2022 00:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852899;
        bh=LK1Ms0G1h8ncPxD1ys7LweNZVHxpTpO9+n9hvMDiWgk=;
        h=Date:To:From:Subject:From;
        b=Bh/fKDerz3dBM1kOaviWf0dAb5YiVDRehvAjKquA1JZGhc9j/l+j2mj+OqDUMtztF
         aFXMhvqHASkUYtquCuI7cm/rUdkv7VJhdFHyxNuBR7rf/nxhbNFsedOt5RmgiPmuUz
         5dbQtS0sBelb1z7SOSP8PThjyKJlSlGPZaEiy1o8=
Date:   Wed, 30 Nov 2022 16:01:38 -0800
To:     mm-commits@vger.kernel.org, suleiman@google.com, nphamcs@gmail.com,
        ngupta@vflare.org, minchan@kernel.org, avromanov@sberdevices.ru,
        senozhatsky@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-add-incompressible-flag-to-read_block_state.patch removed from -mm tree
Message-Id: <20221201000139.26B54C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zram: add incompressible flag to read_block_state()
has been removed from the -mm tree.  Its filename was
     zram-add-incompressible-flag-to-read_block_state.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: add incompressible flag to read_block_state()
Date: Wed, 9 Nov 2022 20:50:47 +0900

Add a new flag to zram block state that shows if the page is
incompressible: that none of the algorithm (including secondary ones)
could compress it.

Link: https://lkml.kernel.org/r/20221109115047.2921851-14-senozhatsky@chromium.org
Suggested-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Alexey Romanov <avromanov@sberdevices.ru>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Suleiman Souhlal <suleiman@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/blockdev/zram.rst |   11 +++++++----
 drivers/block/zram/zram_drv.c               |    6 ++++--
 2 files changed, 11 insertions(+), 6 deletions(-)

--- a/Documentation/admin-guide/blockdev/zram.rst~zram-add-incompressible-flag-to-read_block_state
+++ a/Documentation/admin-guide/blockdev/zram.rst
@@ -497,10 +497,11 @@ pages of the process with*pagemap.
 If you enable the feature, you could see block state via
 /sys/kernel/debug/zram/zram0/block_state". The output is as follows::
 
-	  300    75.033841 .wh..
-	  301    63.806904 s....
-	  302    63.806919 ..hi.
-	  303    62.801919 ....r
+	  300    75.033841 .wh...
+	  301    63.806904 s.....
+	  302    63.806919 ..hi..
+	  303    62.801919 ....r.
+	  304   146.781902 ..hi.n
 
 First column
 	zram's block index.
@@ -519,6 +520,8 @@ Third column
 		idle page
 	r:
 		recompressed page (secondary compression algorithm)
+	n:
+		none (including secondary) of algorithms could compress it
 
 First line of above example says 300th block is accessed at 75.033841sec
 and the block's state is huge so it is written back to the backing
--- a/drivers/block/zram/zram_drv.c~zram-add-incompressible-flag-to-read_block_state
+++ a/drivers/block/zram/zram_drv.c
@@ -946,14 +946,16 @@ static ssize_t read_block_state(struct f
 
 		ts = ktime_to_timespec64(zram->table[index].ac_time);
 		copied = snprintf(kbuf + written, count,
-			"%12zd %12lld.%06lu %c%c%c%c%c\n",
+			"%12zd %12lld.%06lu %c%c%c%c%c%c\n",
 			index, (s64)ts.tv_sec,
 			ts.tv_nsec / NSEC_PER_USEC,
 			zram_test_flag(zram, index, ZRAM_SAME) ? 's' : '.',
 			zram_test_flag(zram, index, ZRAM_WB) ? 'w' : '.',
 			zram_test_flag(zram, index, ZRAM_HUGE) ? 'h' : '.',
 			zram_test_flag(zram, index, ZRAM_IDLE) ? 'i' : '.',
-			zram_get_priority(zram, index) ? 'r' : '.');
+			zram_get_priority(zram, index) ? 'r' : '.',
+			zram_test_flag(zram, index,
+				       ZRAM_INCOMPRESSIBLE) ? 'n' : '.');
 
 		if (count <= copied) {
 			zram_slot_unlock(zram, index);
_

Patches currently in -mm which might be from senozhatsky@chromium.org are


