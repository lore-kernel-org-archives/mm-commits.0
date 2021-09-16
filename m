Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B936C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 16 Sep 2021 19:02:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DC8461207
	for <mm-commits@archiver.kernel.org>; Thu, 16 Sep 2021 19:02:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234898AbhIPTDa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Sep 2021 15:03:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:49070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344403AbhIPTDZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 16 Sep 2021 15:03:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9392661207;
        Thu, 16 Sep 2021 19:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631818924;
        bh=SLTJkFYIhd6hh3Zi4e8gGTQ+bJwAlTM7Vz7PKzUmRbs=;
        h=Date:From:To:Subject:From;
        b=UcpzbSIazKTuQxdamMHd9orSVXhd3Lt4RbP4Wj5i9NIwbksuniPnRhOVPgM+zJ9X/
         3LTkMoNST/ofVyXcy/V8MXKrR2gHJFx3ZfE8+Ap73Pa+h5gmCXEjjl3x/MGv58CTey
         NuwpjnkH837TkzzIQ3NKLtLGZXprsS/XLwVefSFs=
Date:   Thu, 16 Sep 2021 12:02:04 -0700
From:   akpm@linux-foundation.org
To:     dan.carpenter@oracle.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, senozhatsky@chromium.org
Subject:  + zram-off-by-one-in-read_block_state.patch added to -mm
 tree
Message-ID: <20210916190204.nUFsg15cS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram: off by one in read_block_state()
has been added to the -mm tree.  Its filename is
     zram-off-by-one-in-read_block_state.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/zram-off-by-one-in-read_block_state.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/zram-off-by-one-in-read_block_state.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: zram: off by one in read_block_state()

snprintf() returns the number of bytes it would have printed if there were
space.  But it does not count the NUL terminator.  So that means that if
"count == copied" then this has already overflowed by one character.

This bug likely isn't super harmful in real life.

Link: https://lkml.kernel.org/r/20210916130404.GA25094@kili
Fixes: c0265342bff4 ("zram: introduce zram memory tracking")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/block/zram/zram_drv.c~zram-off-by-one-in-read_block_state
+++ a/drivers/block/zram/zram_drv.c
@@ -910,7 +910,7 @@ static ssize_t read_block_state(struct f
 			zram_test_flag(zram, index, ZRAM_HUGE) ? 'h' : '.',
 			zram_test_flag(zram, index, ZRAM_IDLE) ? 'i' : '.');
 
-		if (count < copied) {
+		if (count <= copied) {
 			zram_slot_unlock(zram, index);
 			break;
 		}
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

zram-off-by-one-in-read_block_state.patch

