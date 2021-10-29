Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2665BC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 29 Oct 2021 23:22:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0633360ED3
	for <mm-commits@archiver.kernel.org>; Fri, 29 Oct 2021 23:22:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230504AbhJ2XZV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Oct 2021 19:25:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:56840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229546AbhJ2XZV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 29 Oct 2021 19:25:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC62D60F58;
        Fri, 29 Oct 2021 23:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1635549771;
        bh=brFK/ggf//IuUfhywkKmbV51wnGgCByelS3qfdipUAo=;
        h=Date:From:To:Subject:From;
        b=V+huE8tIUXmCdXurnVNRIAQqzAwLpRWTmzSEoinU4/jaj9TfYBvnwwkNDetN/jIu3
         Pv5w0pIWXhR2NqIPkiBCzfJlEeBGSNkVwRVBbO+1gorF/+yAjcbG+OqWN60mKkA9Q3
         ZTRKVYkyjaeRPYO+lKDFzbqAOb6dPCRYi4iorehc=
Date:   Fri, 29 Oct 2021 16:22:51 -0700
From:   akpm@linux-foundation.org
To:     changbin.du@gmail.com, mm-commits@vger.kernel.org, sj@kernel.org
Subject:  +
 mm-damon-remove-return-value-from-before_terminate-callback.patch added to
 -mm tree
Message-ID: <20211029232251.coqXC0kHB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: remove return value from before_terminate callback
has been added to the -mm tree.  Its filename is
     mm-damon-remove-return-value-from-before_terminate-callback.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-remove-return-value-from-before_terminate-callback.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-remove-return-value-from-before_terminate-callback.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-damon-remove-unnecessary-do_exit-from-kdamond.patch
mm-damon-neednt-hold-kdamond_lock-to-print-pid-of-kdamond.patch
mm-damon-simplify-stop-mechanism.patch
mm-damon-remove-return-value-from-before_terminate-callback.patch

