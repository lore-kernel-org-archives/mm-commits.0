Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AEF4C43334
	for <mm-commits@archiver.kernel.org>; Mon,  6 Jun 2022 19:18:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbiFFTSB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Jun 2022 15:18:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230227AbiFFTR5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jun 2022 15:17:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E49C8880EB
        for <mm-commits@vger.kernel.org>; Mon,  6 Jun 2022 12:17:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45C9961459
        for <mm-commits@vger.kernel.org>; Mon,  6 Jun 2022 19:17:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4592C3411D;
        Mon,  6 Jun 2022 19:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654543075;
        bh=O46x1deyw1Fy8DIfrf0yrURffwiN9/JmiGQYfrVHF04=;
        h=Date:To:From:Subject:From;
        b=NBH3hLw3ytAw2dROXSrA82VIgS4YShpD25si+2DFkWQZVGEKmnfAsVlu+T3fsvlUF
         jiKkg2y3NpT0Vt4tv+vfiTKV97h8b5vksryhHkJN7Z5X6AwQFxwjqP/42f+baGmwUu
         7oT5K/6tRfKybON+T4wN/3NptK6vhFlE/0cRE83k=
Date:   Mon, 06 Jun 2022 12:17:54 -0700
To:     mm-commits@vger.kernel.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-deduplicate-inputs-applying.patch added to mm-unstable branch
Message-Id: <20220606191755.A4592C3411D@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/sysfs: deduplicate inputs applying
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-deduplicate-inputs-applying.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-deduplicate-inputs-applying.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs: deduplicate inputs applying
Date: Mon, 6 Jun 2022 18:23:08 +0000

DAMON sysfs interface's DAMON context building and its online parameter
update have duplicated code.  This commit removes the duplicate.

Link: https://lkml.kernel.org/r/20220606182310.48781-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |   59 ++++++++++++++++++---------------------------
 1 file changed, 24 insertions(+), 35 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-deduplicate-inputs-applying
+++ a/mm/damon/sysfs.c
@@ -2357,6 +2357,23 @@ static inline bool damon_sysfs_kdamond_r
 		damon_sysfs_ctx_running(kdamond->damon_ctx);
 }
 
+static int damon_sysfs_apply_inputs(struct damon_ctx *ctx,
+		struct damon_sysfs_context *sys_ctx)
+{
+	int err;
+
+	err = damon_select_ops(ctx, sys_ctx->ops_id);
+	if (err)
+		return err;
+	err = damon_sysfs_set_attrs(ctx, sys_ctx->attrs);
+	if (err)
+		return err;
+	err = damon_sysfs_set_targets(ctx, sys_ctx->targets);
+	if (err)
+		return err;
+	return damon_sysfs_set_schemes(ctx, sys_ctx->schemes);
+}
+
 /*
  * damon_sysfs_commit_input() - Commit user inputs to a running kdamond.
  * @kdamond:	The kobject wrapper for the associated kdamond.
@@ -2365,31 +2382,14 @@ static inline bool damon_sysfs_kdamond_r
  */
 static int damon_sysfs_commit_input(struct damon_sysfs_kdamond *kdamond)
 {
-	struct damon_ctx *ctx = kdamond->damon_ctx;
-	struct damon_sysfs_context *sys_ctx;
-	int err = 0;
-
 	if (!damon_sysfs_kdamond_running(kdamond))
 		return -EINVAL;
 	/* TODO: Support multiple contexts per kdamond */
 	if (kdamond->contexts->nr != 1)
 		return -EINVAL;
 
-	sys_ctx = kdamond->contexts->contexts_arr[0];
-
-	err = damon_select_ops(ctx, sys_ctx->ops_id);
-	if (err)
-		return err;
-	err = damon_sysfs_set_attrs(ctx, sys_ctx->attrs);
-	if (err)
-		return err;
-	err = damon_sysfs_set_targets(ctx, sys_ctx->targets);
-	if (err)
-		return err;
-	err = damon_sysfs_set_schemes(ctx, sys_ctx->schemes);
-	if (err)
-		return err;
-	return err;
+	return damon_sysfs_apply_inputs(kdamond->damon_ctx,
+			kdamond->contexts->contexts_arr[0]);
 }
 
 /*
@@ -2436,27 +2436,16 @@ static struct damon_ctx *damon_sysfs_bui
 	if (!ctx)
 		return ERR_PTR(-ENOMEM);
 
-	err = damon_select_ops(ctx, sys_ctx->ops_id);
-	if (err)
-		goto out;
-	err = damon_sysfs_set_attrs(ctx, sys_ctx->attrs);
-	if (err)
-		goto out;
-	err = damon_sysfs_set_targets(ctx, sys_ctx->targets);
-	if (err)
-		goto out;
-	err = damon_sysfs_set_schemes(ctx, sys_ctx->schemes);
-	if (err)
-		goto out;
+	err = damon_sysfs_apply_inputs(ctx, sys_ctx);
+	if (err) {
+		damon_destroy_ctx(ctx);
+		return ERR_PTR(err);
+	}
 
 	ctx->callback.after_wmarks_check = damon_sysfs_cmd_request_callback;
 	ctx->callback.after_aggregation = damon_sysfs_cmd_request_callback;
 	ctx->callback.before_terminate = damon_sysfs_before_terminate;
 	return ctx;
-
-out:
-	damon_destroy_ctx(ctx);
-	return ERR_PTR(err);
 }
 
 static int damon_sysfs_turn_damon_on(struct damon_sysfs_kdamond *kdamond)
_

Patches currently in -mm which might be from sj@kernel.org are

docs-admin-guide-damon-reclaim-remove-a-paragraph-that-been-obsolete-due-to-online-tuning-support.patch
mm-damon-dbgfssysfs-move-target_has_pid-from-dbgfs-to-damonh.patch
mm-damon-reclaim-deduplicate-commit_inputs-handling.patch
mm-damon-sysfs-deduplicate-inputs-applying.patch
mm-damon-reclaim-make-enabled-checking-timer-simpler.patch
mm-damon-reclaim-add-damon_reclaim_-prefix-to-enabled_store.patch

