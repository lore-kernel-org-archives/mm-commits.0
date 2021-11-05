Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B93ECC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:48:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A442460FBF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:48:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233721AbhKEUvC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:51:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:46316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232646AbhKEUvC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:51:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65A3F60FBF;
        Fri,  5 Nov 2021 20:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636145302;
        bh=WOwthI6oXUs6Iyt1L3v7EFYMr6E5szWJy3emswO6zzY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=bapDyuhzp5dSanqGs3F82S0t/KW+ewub7TXTVwhDlDLC4ZHBIBmBOylk7uy8bYjUK
         NZUGko4Eva+0o+NqNRvNoQH6cDjbP6D2Gv8fIfRIKe4jjJ1EhjdFGROhO81v8QvlMW
         MQQjy2NkxD5XSpDdBqc9v7AL8cguibdQhMkmA12k=
Date:   Fri, 05 Nov 2021 13:48:22 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, changbin.du@gmail.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, sj@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 260/262] mm/damon: simplify stop mechanism
Message-ID: <20211105204822.UmpUEwvxA%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Changbin Du <changbin.du@gmail.com>
Subject: mm/damon: simplify stop mechanism

A kernel thread can exit gracefully with kthread_stop().  So we don't need
a new flag 'kdamond_stop'.  And to make sure the task struct is not freed
when accessing it, get reference to it before termination.

Link: https://lkml.kernel.org/r/20211027130517.4404-1-changbin.du@gmail.com
Signed-off-by: Changbin Du <changbin.du@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
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
