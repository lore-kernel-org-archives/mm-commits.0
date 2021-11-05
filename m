Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7B65C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:48:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 933D26126A
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:48:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233746AbhKEUvK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:51:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:46400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232646AbhKEUvI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:51:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D47060174;
        Fri,  5 Nov 2021 20:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636145308;
        bh=RAT4aEdVL5c3F3z9sf/D12jBWmrVR201Sw4cXQgfHzY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=BgRIC4e1uFTx+cf8wdU70Vd6Cz136CJLG22ykCmb8kyT0FI47DD2xOvU9y+V1BD2D
         WvP3jP326/C1t6rzuyLE+dXn2YYA1Q+WZgtm/B63IAsy0f074Og9Xq7q0NqQnVSYww
         33fxFlfFSbX+0Zp/wRQFD0MwF1Tl8uuehtS0WDlw=
Date:   Fri, 05 Nov 2021 13:48:27 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, changbin.du@gmail.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, sj@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 262/262] mm/damon: remove return value from
 before_terminate callback
Message-ID: <20211105204827.Ep_rdwILj%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Changbin Du <changbin.du@gmail.com>
Subject: mm/damon: remove return value from before_terminate callback

Since the return value of 'before_terminate' callback is never used,
we make it have no return value.

Link: https://lkml.kernel.org/r/20211029005023.8895-1-changbin.du@gmail.com
Signed-off-by: Changbin Du <changbin.du@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    2 +-
 mm/damon/dbgfs.c      |    5 ++---
 2 files changed, 3 insertions(+), 4 deletions(-)

--- a/include/linux/damon.h~mm-damon-remove-return-value-from-before_terminate-callback
+++ a/include/linux/damon.h
@@ -322,7 +322,7 @@ struct damon_callback {
 	int (*before_start)(struct damon_ctx *context);
 	int (*after_sampling)(struct damon_ctx *context);
 	int (*after_aggregation)(struct damon_ctx *context);
-	int (*before_terminate)(struct damon_ctx *context);
+	void (*before_terminate)(struct damon_ctx *context);
 };
 
 /**
--- a/mm/damon/dbgfs.c~mm-damon-remove-return-value-from-before_terminate-callback
+++ a/mm/damon/dbgfs.c
@@ -645,18 +645,17 @@ static void dbgfs_fill_ctx_dir(struct de
 		debugfs_create_file(file_names[i], 0600, dir, ctx, fops[i]);
 }
 
-static int dbgfs_before_terminate(struct damon_ctx *ctx)
+static void dbgfs_before_terminate(struct damon_ctx *ctx)
 {
 	struct damon_target *t, *next;
 
 	if (!targetid_is_pid(ctx))
-		return 0;
+		return;
 
 	damon_for_each_target_safe(t, next, ctx) {
 		put_pid((struct pid *)t->id);
 		damon_destroy_target(t);
 	}
-	return 0;
 }
 
 static struct damon_ctx *dbgfs_new_ctx(void)
_
