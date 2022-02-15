Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72F12C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 15 Feb 2022 20:57:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239772AbiBOU6H (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Feb 2022 15:58:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244236AbiBOU6F (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Feb 2022 15:58:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF78514031
        for <mm-commits@vger.kernel.org>; Tue, 15 Feb 2022 12:57:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B3B1618D1
        for <mm-commits@vger.kernel.org>; Tue, 15 Feb 2022 20:57:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDB8FC340EC;
        Tue, 15 Feb 2022 20:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644958673;
        bh=UfFa//4OxJ43Qv4OaO+1v55whyZyi6idNga3/kAUq0I=;
        h=Date:To:From:Subject:From;
        b=FrdY5YAY2zsB5JeTS8NnPiiBvougYHH2zd36PZO8N74PmI9gqmoDHV/BqDFhY2iPO
         OXzjMoV93AJEXBY3qJsvS/OrQT6eXSS+v0MExj1WAv4ZtUztsS5FgAY+lninnj/djO
         kf1w/1uNAvSke5UomDuZmyC5JOYbbxTx+a7tvxX0=
Date:   Tue, 15 Feb 2022 12:57:53 -0800
To:     mm-commits@vger.kernel.org, xhao@linux.alibaba.com,
        rientjes@google.com, sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-paddrvaddr-remove-damon_pva_target_validset_operations.patch added to -mm tree
Message-Id: <20220215205753.CDB8FC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/paddr,vaddr: remove damon_{p,v}a_{target_valid,set_operations}()
has been added to the -mm tree.  Its filename is
     mm-damon-paddrvaddr-remove-damon_pva_target_validset_operations.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-paddrvaddr-remove-damon_pva_target_validset_operations.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-paddrvaddr-remove-damon_pva_target_validset_operations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-munlock-mlock_page-munlock_page-batch-by-pagevec-fix-2.patch
mm-damon-dbgfs-init_regions-use-target-index-instead-of-target-id.patch
docs-admin-guide-mm-damon-usage-update-for-changed-initail_regions-file-input.patch
mm-damon-core-move-damon_set_targets-into-dbgfs.patch
mm-damon-remove-the-target-id-concept.patch
mm-damon-rename-damon_primitives-to-damon_operations.patch
mm-damon-let-monitoring-operations-can-be-registered-and-selected.patch
mm-damon-paddrvaddr-register-themselves-to-damon-in-subsys_initcall.patch
mm-damon-reclaim-use-damon_select_ops-instead-of-damon_vpa_set_operations.patch
mm-damon-dbgfs-use-damon_select_ops-instead-of-damon_vpa_set_operations.patch
mm-damon-dbgfs-use-operations-id-for-knowing-if-the-target-has-pid.patch
mm-damon-dbgfs-test-fix-is_target_id-change.patch
mm-damon-paddrvaddr-remove-damon_pva_target_validset_operations.patch

