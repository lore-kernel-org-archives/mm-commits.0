Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5258C4167B
	for <mm-commits@archiver.kernel.org>; Thu, 10 Nov 2022 00:31:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232204AbiKJAbk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 9 Nov 2022 19:31:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232226AbiKJAbd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 9 Nov 2022 19:31:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D73C92A264
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 16:31:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A61DB82059
        for <mm-commits@vger.kernel.org>; Thu, 10 Nov 2022 00:31:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27C4DC433C1;
        Thu, 10 Nov 2022 00:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668040275;
        bh=jddrjurFz8KdZsjeY73ERjAQo7g/Jdz0ZVV7JDbigsw=;
        h=Date:To:From:Subject:From;
        b=r8ewSWRPgLED0s5PFh7nv49AcUy5NR8UCU/3w8Dw51GX5QFBe2d9WcdnIqSoLMvRE
         H0N2mGZN/KXAksqfIDIQPQMrZcThOw3mzqeyvSUJATao0Jt6e/tYAlj2ql7pRn4KH6
         Y47j1sXfK57W5CJ6C5BIQkVWidTHxGbIMSsBgvAI=
Date:   Wed, 09 Nov 2022 16:31:14 -0800
To:     mm-commits@vger.kernel.org, suleiman@google.com, nphamcs@gmail.com,
        ngupta@vflare.org, minchan@kernel.org, avromanov@sberdevices.ru,
        senozhatsky@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-add-incompressible-flag-to-read_block_state.patch added to mm-unstable branch
Message-Id: <20221110003115.27C4DC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram: add incompressible flag to read_block_state()
has been added to the -mm mm-unstable branch.  Its filename is
     zram-add-incompressible-flag-to-read_block_state.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-add-incompressible-flag-to-read_block_state.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

zram-preparation-for-multi-zcomp-support.patch
zram-add-recompression-algorithm-sysfs-knob.patch
zram-factor-out-wb-and-non-wb-zram-read-functions.patch
zram-introduce-recompress-sysfs-knob.patch
zram-add-recompress-flag-to-read_block_state.patch
zram-clarify-writeback_store-comment.patch
zram-use-is_err_value-to-check-for-zs_malloc-errors.patch
zram-remove-redundant-checks-from-zram_recompress.patch
zram-add-algo-parameter-support-to-zram_recompress.patch
documentation-add-zram-recompression-documentation.patch
zram-add-incompressible-writeback.patch
zram-add-incompressible-flag-to-read_block_state.patch

