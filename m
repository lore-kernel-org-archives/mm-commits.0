Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8A2BC43219
	for <mm-commits@archiver.kernel.org>; Tue, 18 Oct 2022 23:21:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbiJRXVN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Oct 2022 19:21:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiJRXVB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Oct 2022 19:21:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0ED2D7E22
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 16:20:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E5776170E
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 23:20:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDE36C433D6;
        Tue, 18 Oct 2022 23:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666135256;
        bh=/KVRRxmd26dfXCSMj96y7h5UrBRY0f19b+WRmk/OK0A=;
        h=Date:To:From:Subject:From;
        b=XTsk2iUAfKH61TjtOEnlsrEAf37qhAiMoSNijWVvjAYrXhEP4uXkXTkUB46S7/MK2
         6hYCIO+eXBkXCi5XVIZ8Zn88EqaLKJmN5Uuz87CvcGapX7PzjPG+nvcNt8j7t9Dpkp
         FPurAik8YMgjsSHFbXNbjBk8PK4LkMs0Tve/1CSA=
Date:   Tue, 18 Oct 2022 16:20:56 -0700
To:     mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org,
        akpm@linux-foundation.org, senozhatsky@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-clarify-writeback_store-comment.patch added to mm-unstable branch
Message-Id: <20221018232056.CDE36C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram: clarify writeback_store() comment
has been added to the -mm mm-unstable branch.  Its filename is
     zram-clarify-writeback_store-comment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-clarify-writeback_store-comment.patch

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
Subject: zram: clarify writeback_store() comment
Date: Tue, 18 Oct 2022 13:55:32 +0900

Re-phrase writeback BIO error comment.

Link: https://lkml.kernel.org/r/20221018045533.2396670-9-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reported-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-clarify-writeback_store-comment
+++ a/drivers/block/zram/zram_drv.c
@@ -755,8 +755,12 @@ static ssize_t writeback_store(struct de
 			zram_clear_flag(zram, index, ZRAM_IDLE);
 			zram_slot_unlock(zram, index);
 			/*
-			 * Return last IO error unless every IO were
-			 * not suceeded.
+			 * BIO errors are not fatal, we continue and simply
+			 * attempt to writeback the remaining objects (pages).
+			 * At the same time we need to signal user-space that
+			 * some writes (at least one, but also could be all of
+			 * them) were not successful and we do so by returning
+			 * the most recent BIO error.
 			 */
 			ret = err;
 			continue;
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

