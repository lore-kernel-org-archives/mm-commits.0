Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBC69C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:48:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF6F461361
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:48:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234434AbhKKCus (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:50:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:55382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234428AbhKKCus (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:50:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99C6F60F26;
        Thu, 11 Nov 2021 02:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598879;
        bh=d5gufC25MVrVZUavByOSmtmhIc95yzmiLavREesgRUM=;
        h=Date:From:To:Subject:From;
        b=lE0K/IY7M1ax+CkxSJfUvm29HUbyWpRHt8Nw+2lzbMVWeBVRZsBUJAS76zlaH0jUH
         aUHF7rUgFuNTky+TESCSwZNavev84ttig+S0fBIGaChum7aVxu51vhTmixLkrEZt7Q
         Twl5ImNGNsffTPnLmcBQ2BYU+NUFjthjfcj3G+Ck=
Date:   Wed, 10 Nov 2021 18:47:59 -0800
From:   akpm@linux-foundation.org
To:     dan.carpenter@oracle.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, senozhatsky@chromium.org
Subject:  [merged] zram-off-by-one-in-read_block_state.patch
 removed from -mm tree
Message-ID: <20211111024759.DqtlOsnAk%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram: off by one in read_block_state()
has been removed from the -mm tree.  Its filename was
     zram-off-by-one-in-read_block_state.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


