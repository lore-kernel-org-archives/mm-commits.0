Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CC69C43334
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 01:09:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231774AbiGDBJk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:09:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231956AbiGDBJe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 21:09:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8436362F5
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 18:09:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E6FB612E7
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 01:09:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EDD3C341C6;
        Mon,  4 Jul 2022 01:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656896972;
        bh=W0vlBUrYAKzRAkIvM34mItwe0cctfd0d9xIfUdbCiBg=;
        h=Date:To:From:Subject:From;
        b=Y52q/Ax8pP/PMmhUZNoaJLnoBWKIOiY78OtRNbN6t1CvKMvqCfj5l8Z5vGCb2w8RI
         oOSh0oSTWIIj1SPHmzjyL8UJ6UfO4nesy+EEZyxDjO5eghqkfQn+OqzotWfCUe8QJM
         jJ7qSVzW6XRst2KibdzhN4yXw6LPyPFyPdxm/h5Q=
Date:   Sun, 03 Jul 2022 18:09:31 -0700
To:     mm-commits@vger.kernel.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-deduplicate-inputs-applying.patch removed from -mm tree
Message-Id: <20220704010932.6EDD3C341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/sysfs: deduplicate inputs applying
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-deduplicate-inputs-applying.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-damon-reclaim-make-enabled-checking-timer-simpler.patch
mm-damon-reclaim-add-damon_reclaim_-prefix-to-enabled_store.patch
mm-damon-dbgfs-add-and-use-mappings-between-schemes-action-inputs-and-damos_action-values.patch
mm-damon-paddr-use-a-separate-function-for-damos_pageout-handling.patch
mm-damon-schemes-add-lru_prio-damos-action.patch
docs-admin-guide-damon-sysfs-document-lru_prio-scheme-action.patch
mm-damon-schemes-add-lru_deprio-action.patch
docs-admin-guide-damon-sysfs-document-lru_deprio-scheme-action.patch
mm-damon-introduce-damon-based-lru-lists-sorting.patch
docs-admin-guide-damon-add-a-document-for-damon_lru_sort.patch

