Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2960C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:49:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236810AbiCVVul (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:50:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236896AbiCVVuk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:50:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44E844926C
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:49:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E8537B81DC3
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:49:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E3E2C340EC;
        Tue, 22 Mar 2022 21:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985747;
        bh=OE8JHBdEbctidvhLgNap8i04dQeZ+vM3fUWBBaF+yX8=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=YnLZ+J3QAVrGNatDBKV4mM7ZTldAcckRty2DPW44nNgdPZ2kWhXxCdyIDj1nAkunu
         7Vme1AVPoBaz9TB7bo063rBa6NwdLIpgYmsfN8fsKBLYj0J5dn5zMD/QAZK3Twtwjg
         JcLI4qq1J5IhGwXSczPNm3kPCV0987+ZaPrE8qRc=
Date:   Tue, 22 Mar 2022 14:49:07 -0700
To:     xhao@linux.alibaba.com, rientjes@google.com, sj@kernel.org,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 209/227] mm/damon/paddr,vaddr: remove damon_{p,v}a_{target_valid,set_operations}()
Message-Id: <20220322214907.9E3E2C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
