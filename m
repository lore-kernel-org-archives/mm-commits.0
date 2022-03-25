Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 485E6C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:34:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357442AbiCYBgS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:36:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357439AbiCYBfb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:35:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAC52286FE
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:33:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58838B81DEA
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:33:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10740C340EC;
        Fri, 25 Mar 2022 01:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648172000;
        bh=rR/e+QnQV9jaqvMNmwrU1hSry4laeMhOBNAULJru0fM=;
        h=Date:To:From:Subject:From;
        b=kld39TUhC6QCdzPkYDdrKGmvRyiIilJIhwclETnNPeMtesKDyZpql+W0t1hxjNIJU
         DYhMObbsVuB14qjxZoJE+hsw9XYtc0KMc1G3qbKD88CZESesa9ZV6glu1f58p5uhb1
         9jOkIeL6Y2zjLLoIlPA3JkjIXP85jyHcc2NiDJGw=
Date:   Thu, 24 Mar 2022 18:33:19 -0700
To:     mm-commits@vger.kernel.org, xhao@linux.alibaba.com,
        rientjes@google.com, sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-damon-paddrvaddr-remove-damon_pva_target_validset_operations.patch removed from -mm tree
Message-Id: <20220325013320.10740C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/paddr,vaddr: remove damon_{p,v}a_{target_valid,set_operations}()
has been removed from the -mm tree.  Its filename was
     mm-damon-paddrvaddr-remove-damon_pva_target_validset_operations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/paddr,vaddr: remove damon_{p,v}a_{target_valid,set_operations}()

Because DAMON debugfs interface and DAMON-based proactive reclaim are now
using monitoring operations via registration mechanism,
damon_{p,v}a_{target_valid,set_operations}() functions have no user.  This
commit clean them up.

Link: https://lkml.kernel.org/r/20220215184603.1479-9-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Xin Hao <xhao@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |   10 ----------
 mm/damon/paddr.c      |   20 +-------------------
 mm/damon/vaddr.c      |   15 +--------------
 3 files changed, 2 insertions(+), 43 deletions(-)

--- a/include/linux/damon.h~mm-damon-paddrvaddr-remove-damon_pva_target_validset_operations
+++ a/include/linux/damon.h
@@ -513,14 +513,4 @@ int damon_stop(struct damon_ctx **ctxs,
 
 #endif	/* CONFIG_DAMON */
 
-#ifdef CONFIG_DAMON_VADDR
-bool damon_va_target_valid(void *t);
-void damon_va_set_operations(struct damon_ctx *ctx);
-#endif	/* CONFIG_DAMON_VADDR */
-
-#ifdef CONFIG_DAMON_PADDR
-bool damon_pa_target_valid(void *t);
-void damon_pa_set_operations(struct damon_ctx *ctx);
-#endif	/* CONFIG_DAMON_PADDR */
-
 #endif	/* _DAMON_H */
--- a/mm/damon/paddr.c~mm-damon-paddrvaddr-remove-damon_pva_target_validset_operations
+++ a/mm/damon/paddr.c
@@ -208,11 +208,6 @@ static unsigned int damon_pa_check_acces
 	return max_nr_accesses;
 }
 
-bool damon_pa_target_valid(void *t)
-{
-	return true;
-}
-
 static unsigned long damon_pa_apply_scheme(struct damon_ctx *ctx,
 		struct damon_target *t, struct damon_region *r,
 		struct damos *scheme)
@@ -261,19 +256,6 @@ static int damon_pa_scheme_score(struct
 	return DAMOS_MAX_SCORE;
 }
 
-void damon_pa_set_operations(struct damon_ctx *ctx)
-{
-	ctx->ops.init = NULL;
-	ctx->ops.update = NULL;
-	ctx->ops.prepare_access_checks = damon_pa_prepare_access_checks;
-	ctx->ops.check_accesses = damon_pa_check_accesses;
-	ctx->ops.reset_aggregated = NULL;
-	ctx->ops.target_valid = damon_pa_target_valid;
-	ctx->ops.cleanup = NULL;
-	ctx->ops.apply_scheme = damon_pa_apply_scheme;
-	ctx->ops.get_scheme_score = damon_pa_scheme_score;
-}
-
 static int __init damon_pa_initcall(void)
 {
 	struct damon_operations ops = {
@@ -283,7 +265,7 @@ static int __init damon_pa_initcall(void
 		.prepare_access_checks = damon_pa_prepare_access_checks,
 		.check_accesses = damon_pa_check_accesses,
 		.reset_aggregated = NULL,
-		.target_valid = damon_pa_target_valid,
+		.target_valid = NULL,
 		.cleanup = NULL,
 		.apply_scheme = damon_pa_apply_scheme,
 		.get_scheme_score = damon_pa_scheme_score,
--- a/mm/damon/vaddr.c~mm-damon-paddrvaddr-remove-damon_pva_target_validset_operations
+++ a/mm/damon/vaddr.c
@@ -653,7 +653,7 @@ static unsigned int damon_va_check_acces
  * Functions for the target validity check and cleanup
  */
 
-bool damon_va_target_valid(void *target)
+static bool damon_va_target_valid(void *target)
 {
 	struct damon_target *t = target;
 	struct task_struct *task;
@@ -739,19 +739,6 @@ static int damon_va_scheme_score(struct
 	return DAMOS_MAX_SCORE;
 }
 
-void damon_va_set_operations(struct damon_ctx *ctx)
-{
-	ctx->ops.init = damon_va_init;
-	ctx->ops.update = damon_va_update;
-	ctx->ops.prepare_access_checks = damon_va_prepare_access_checks;
-	ctx->ops.check_accesses = damon_va_check_accesses;
-	ctx->ops.reset_aggregated = NULL;
-	ctx->ops.target_valid = damon_va_target_valid;
-	ctx->ops.cleanup = NULL;
-	ctx->ops.apply_scheme = damon_va_apply_scheme;
-	ctx->ops.get_scheme_score = damon_va_scheme_score;
-}
-
 static int __init damon_va_initcall(void)
 {
 	struct damon_operations ops = {
_

Patches currently in -mm which might be from sj@kernel.org are


