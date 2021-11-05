Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25E0DC4332F
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:45:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C63A6136A
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:45:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233504AbhKEUr5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:47:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:42924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233650AbhKEUrx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:47:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D66DE6128E;
        Fri,  5 Nov 2021 20:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636145113;
        bh=xtGAmTgTfPepl5sQOtEFzWvC2DftSFOFo6QMfSRQfhE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=aoIMkeT+7gshEJz18iT3lc1sgYvtPiVjKFLdWcMDhGr7ul/CZUrwx9EWFG54xNYzO
         DTrDh/rMzTWNy9pJKtJKQ1FDxc9MY/8vnLmj3xoG5PgN8tT2PtYeSd7Khj7El3Z86a
         748VPKcpJRpOTEmkwudGbiillKO14n+L/c6MEcA4=
Date:   Fri, 05 Nov 2021 13:45:12 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dan.carpenter@oracle.com,
        linux-mm@kvack.org, minchan@kernel.org, mm-commits@vger.kernel.org,
        senozhatsky@chromium.org, torvalds@linux-foundation.org
Subject:  [patch 201/262] zram: off by one in read_block_state()
Message-ID: <20211105204512.OEBIB2O7B%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
