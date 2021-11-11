Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34A50C43219
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:50:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BF3D619E2
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:50:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234516AbhKKCxd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:53:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:57354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234507AbhKKCx3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:53:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78BD360F26;
        Thu, 11 Nov 2021 02:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636599041;
        bh=PPM/HYoM5RkIPd+YeDU97Zc2DkbcUDoCM2Wk4n3+ZQI=;
        h=Date:From:To:Subject:From;
        b=utCh1qKpextdcOegkplqitx4O0YKhL/tazwJDOTBLH5WSKDuL/5uYJCo6NEFezKef
         DL836ci5UXqeFxYA/B/qda08Vx1+B6VF0w+rQKVT8LrVszkaed8gdrwtnX65NeoAz5
         Wp5A/3UNGANOcYiMTEcpvHhd/78JNV4GxoNIiPNU=
Date:   Wed, 10 Nov 2021 18:50:41 -0800
From:   akpm@linux-foundation.org
To:     changbin.du@gmail.com, mm-commits@vger.kernel.org, sj@kernel.org
Subject:  [merged]
 mm-damon-remove-return-value-from-before_terminate-callback.patch removed
 from -mm tree
Message-ID: <20211111025041.ymEYpa1cP%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: remove return value from before_terminate callback
has been removed from the -mm tree.  Its filename was
     mm-damon-remove-return-value-from-before_terminate-callback.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from changbin.du@gmail.com are


