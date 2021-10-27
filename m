Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87768C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 27 Oct 2021 20:29:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5ED3F60C40
	for <mm-commits@archiver.kernel.org>; Wed, 27 Oct 2021 20:29:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240823AbhJ0UcG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Oct 2021 16:32:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:36952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240753AbhJ0UcF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 27 Oct 2021 16:32:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF34D60F39;
        Wed, 27 Oct 2021 20:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1635366579;
        bh=Tn3PQKIZEZXG0o/LQfGbqpIbPo29l57343fu6BbGYoE=;
        h=Date:From:To:Subject:From;
        b=eC60MsE4waZmscaVXGeHLzoRaXKKjiR4PWddQ62SuuFqc96noRzPLirGRp8LE3nt0
         FddUHAc4cSOxXczdaDk0DOxYB45Sx1zmDV6u+D+pkMbJZ9idi2tLhcpEkANCPU811u
         vPjq3t9CvJ4Np9coaMPu8jIktPQp4w6suoATs3Ec=
Date:   Wed, 27 Oct 2021 13:29:39 -0700
From:   akpm@linux-foundation.org
To:     changbin.du@gmail.com, mm-commits@vger.kernel.org, sj@kernel.org
Subject:  + mm-damon-simplify-stop-mechanism.patch added to -mm
 tree
Message-ID: <20211027202939.hIh606sGx%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: simplify stop mechanism
has been added to the -mm tree.  Its filename is
     mm-damon-simplify-stop-mechanism.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-simplify-stop-mechanism.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-simplify-stop-mechanism.patch

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
Subject: mm/damon: simplify stop mechanism

A kernel thread can exit gracefully with kthread_stop().  So we don't need
a new flag 'kdamond_stop'.  And to make sure the task struct is not freed
when accessing it, get reference to it before termination.

Link: https://lkml.kernel.org/r/20211027130517.4404-1-changbin.du@gmail.com
Signed-off-by: Changbin Du <changbin.du@gmail.com>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    1 
 mm/damon/core.c       |   51 +++++++++++-----------------------------
 2 files changed, 15 insertions(+), 37 deletions(-)

--- a/include/linux/damon.h~mm-damon-simplify-stop-mechanism
+++ a/include/linux/damon.h
@@ -381,7 +381,6 @@ struct damon_ctx {
 
 /* public: */
 	struct task_struct *kdamond;
-	bool kdamond_stop;
 	struct mutex kdamond_lock;
 
 	struct damon_primitive primitive;
--- a/mm/damon/core.c~mm-damon-simplify-stop-mechanism
+++ a/mm/damon/core.c
@@ -390,17 +390,6 @@ static unsigned long damon_region_sz_lim
 	return sz;
 }
 
-static bool damon_kdamond_running(struct damon_ctx *ctx)
-{
-	bool running;
-
-	mutex_lock(&ctx->kdamond_lock);
-	running = ctx->kdamond != NULL;
-	mutex_unlock(&ctx->kdamond_lock);
-
-	return running;
-}
-
 static int kdamond_fn(void *data);
 
 /*
@@ -418,7 +407,6 @@ static int __damon_start(struct damon_ct
 	mutex_lock(&ctx->kdamond_lock);
 	if (!ctx->kdamond) {
 		err = 0;
-		ctx->kdamond_stop = false;
 		ctx->kdamond = kthread_run(kdamond_fn, ctx, "kdamond.%d",
 				nr_running_ctxs);
 		if (IS_ERR(ctx->kdamond)) {
@@ -474,13 +462,15 @@ int damon_start(struct damon_ctx **ctxs,
  */
 static int __damon_stop(struct damon_ctx *ctx)
 {
+	struct task_struct *tsk;
+
 	mutex_lock(&ctx->kdamond_lock);
-	if (ctx->kdamond) {
-		ctx->kdamond_stop = true;
+	tsk = ctx->kdamond;
+	if (tsk) {
+		get_task_struct(tsk);
 		mutex_unlock(&ctx->kdamond_lock);
-		while (damon_kdamond_running(ctx))
-			usleep_range(ctx->sample_interval,
-					ctx->sample_interval * 2);
+		kthread_stop(tsk);
+		put_task_struct(tsk);
 		return 0;
 	}
 	mutex_unlock(&ctx->kdamond_lock);
@@ -925,12 +915,8 @@ static bool kdamond_need_update_primitiv
 static bool kdamond_need_stop(struct damon_ctx *ctx)
 {
 	struct damon_target *t;
-	bool stop;
 
-	mutex_lock(&ctx->kdamond_lock);
-	stop = ctx->kdamond_stop;
-	mutex_unlock(&ctx->kdamond_lock);
-	if (stop)
+	if (kthread_should_stop())
 		return true;
 
 	if (!ctx->primitive.target_valid)
@@ -1021,13 +1007,6 @@ static int kdamond_wait_activation(struc
 	return -EBUSY;
 }
 
-static void set_kdamond_stop(struct damon_ctx *ctx)
-{
-	mutex_lock(&ctx->kdamond_lock);
-	ctx->kdamond_stop = true;
-	mutex_unlock(&ctx->kdamond_lock);
-}
-
 /*
  * The monitoring daemon that runs as a kernel thread
  */
@@ -1038,17 +1017,18 @@ static int kdamond_fn(void *data)
 	struct damon_region *r, *next;
 	unsigned int max_nr_accesses = 0;
 	unsigned long sz_limit = 0;
+	bool done = false;
 
 	pr_debug("kdamond (%d) starts\n", current->pid);
 
 	if (ctx->primitive.init)
 		ctx->primitive.init(ctx);
 	if (ctx->callback.before_start && ctx->callback.before_start(ctx))
-		set_kdamond_stop(ctx);
+		done = true;
 
 	sz_limit = damon_region_sz_limit(ctx);
 
-	while (!kdamond_need_stop(ctx)) {
+	while (!kdamond_need_stop(ctx) && !done) {
 		if (kdamond_wait_activation(ctx))
 			continue;
 
@@ -1056,7 +1036,7 @@ static int kdamond_fn(void *data)
 			ctx->primitive.prepare_access_checks(ctx);
 		if (ctx->callback.after_sampling &&
 				ctx->callback.after_sampling(ctx))
-			set_kdamond_stop(ctx);
+			done = true;
 
 		usleep_range(ctx->sample_interval, ctx->sample_interval + 1);
 
@@ -1069,7 +1049,7 @@ static int kdamond_fn(void *data)
 					sz_limit);
 			if (ctx->callback.after_aggregation &&
 					ctx->callback.after_aggregation(ctx))
-				set_kdamond_stop(ctx);
+				done = true;
 			kdamond_apply_schemes(ctx);
 			kdamond_reset_aggregated(ctx);
 			kdamond_split_regions(ctx);
@@ -1088,9 +1068,8 @@ static int kdamond_fn(void *data)
 			damon_destroy_region(r, t);
 	}
 
-	if (ctx->callback.before_terminate &&
-			ctx->callback.before_terminate(ctx))
-		set_kdamond_stop(ctx);
+	if (ctx->callback.before_terminate)
+		ctx->callback.before_terminate(ctx);
 	if (ctx->primitive.cleanup)
 		ctx->primitive.cleanup(ctx);
 
_

Patches currently in -mm which might be from changbin.du@gmail.com are

mm-damon-remove-unnecessary-do_exit-from-kdamond.patch
mm-damon-neednt-hold-kdamond_lock-to-print-pid-of-kdamond.patch
mm-damon-simplify-stop-mechanism.patch

