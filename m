Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FE18C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 18 Oct 2022 23:21:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbiJRXVM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Oct 2022 19:21:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbiJRXVA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Oct 2022 19:21:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF6EBD77DC
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 16:20:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BB6F6170E
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 23:20:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DB35C433D6;
        Tue, 18 Oct 2022 23:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666135254;
        bh=u207NHRJhOLN+6Jv61x1M9KFg/BRJY9xgyqVrZVO6q4=;
        h=Date:To:From:Subject:From;
        b=YQJ8MMb5KZifMsW9u+dxYTtFEEOypPZ9bttzYA+yyiVjTTJxNHsol4ztBf+4KAiyU
         Fmf3q9/AHl8bjGejtPSnWmJKnKPJLd8ebmCjNKoEwb+3olChyNJshWNYiiUYevhw69
         sXyRJuYdoT5dwSG+QYCjneIiW6tGErPfqvc6SS18=
Date:   Tue, 18 Oct 2022 16:20:53 -0700
To:     mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org,
        senozhatsky@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-add-recompress-flag-to-read_block_state.patch added to mm-unstable branch
Message-Id: <20221018232054.9DB35C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram: add recompress flag to read_block_state()
has been added to the -mm mm-unstable branch.  Its filename is
     zram-add-recompress-flag-to-read_block_state.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-add-recompress-flag-to-read_block_state.patch

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
Subject: zram: add recompress flag to read_block_state()
Date: Tue, 18 Oct 2022 13:55:31 +0900

Add a new flag to zram block state that shows if the page was recompressed
(using alternative compression algorithm).

Link: https://lkml.kernel.org/r/20221018045533.2396670-8-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/blockdev/zram.rst |    9 ++++++---
 drivers/block/zram/zram_drv.c               |    5 +++--
 2 files changed, 9 insertions(+), 5 deletions(-)

--- a/Documentation/admin-guide/blockdev/zram.rst~zram-add-recompress-flag-to-read_block_state
+++ a/Documentation/admin-guide/blockdev/zram.rst
@@ -466,9 +466,10 @@ pages of the process with*pagemap.
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
@@ -485,6 +486,8 @@ Third column
 		huge page
 	i:
 		idle page
+	r:
+		recompressed page (secondary compression algorithm)
 
 First line of above example says 300th block is accessed at 75.033841sec
 and the block's state is huge so it is written back to the backing
--- a/drivers/block/zram/zram_drv.c~zram-add-recompress-flag-to-read_block_state
+++ a/drivers/block/zram/zram_drv.c
@@ -922,13 +922,14 @@ static ssize_t read_block_state(struct f
 
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
+			zram_test_flag(zram, index, ZRAM_RECOMP) ? 'r' : '.');
 
 		if (count <= copied) {
 			zram_slot_unlock(zram, index);
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-preparation-for-multi-zcomp-support.patch
zram-add-recompression-algorithm-sysfs-knob.patch
zram-factor-out-wb-and-non-wb-zram-read-functions.patch
zram-introduce-recompress-sysfs-knob.patch
documentation-add-recompression-documentation.patch
zram-add-recompression-algorithm-choice-to-kconfig.patch
zram-add-recompress-flag-to-read_block_state.patch
zram-clarify-writeback_store-comment.patch
zram-use-is_err_value-to-check-for-zs_malloc-errors.patch

