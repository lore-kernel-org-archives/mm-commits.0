Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17BF8C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 01:09:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233853AbiEJBNd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 May 2022 21:13:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233131AbiEJBNc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 May 2022 21:13:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A3102BA9B4
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 18:09:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1DBE6615AC
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 01:09:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70ADEC385C5;
        Tue, 10 May 2022 01:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652144975;
        bh=luQbY2s6s/l7SKHLp/ponjjdMBCpelsmGRUqLZMl88Q=;
        h=Date:To:From:Subject:From;
        b=B7mXt3fqvqVtGhQqtuXdGaGFEJpWhZuEAZVMwnb33yPRblJSTUlFhS0fwzkPsFVBW
         XPLYdz+r6P4lln2mp6CagkhHno2IPK+ma4c26OU41SDlGcN07Ss41BjQKLCWI7dZSb
         /2vDBz8Cj73K7fEYZCApkxK57Q+8tEK1FCDBW7PA=
Date:   Mon, 09 May 2022 18:09:34 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-damon-sysfs-support-fixed-virtual-address-ranges-monitoring-fix.patch removed from -mm tree
Message-Id: <20220510010935.70ADEC385C5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/sysfs: fix pid leak under fvaddr ops use case
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-support-fixed-virtual-address-ranges-monitoring-fix.patch

This patch was dropped because it was folded into mm-damon-sysfs-support-fixed-virtual-address-ranges-monitoring.patch

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs: fix pid leak under fvaddr ops use case

Commit c83136469313 ("mm/damon/sysfs: support fixed virtual address ranges
monitoring") in 'mm-unstable' does not put the monitoring target pid when
fvaddr ops is used.  This commit fixes it to put pid properly.

Link: https://lkml.kernel.org/r/20220503220531.45913-1-sj@kernel.org
Fixes: c83136469313 ("mm/damon/sysfs: support fixed virtual address ranges monitoring")
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-support-fixed-virtual-address-ranges-monitoring-fix
+++ a/mm/damon/sysfs.c
@@ -2086,7 +2086,8 @@ static void damon_sysfs_destroy_targets(
 	struct damon_target *t, *next;
 
 	damon_for_each_target_safe(t, next, ctx) {
-		if (ctx->ops.id == DAMON_OPS_VADDR)
+		if (ctx->ops.id == DAMON_OPS_VADDR ||
+				ctx->ops.id == DAMON_OPS_FVADDR)
 			put_pid(t->pid);
 		damon_destroy_target(t);
 	}
@@ -2204,7 +2205,7 @@ static void damon_sysfs_before_terminate
 {
 	struct damon_target *t, *next;
 
-	if (ctx->ops.id != DAMON_OPS_VADDR)
+	if (ctx->ops.id != DAMON_OPS_VADDR && ctx->ops.id != DAMON_OPS_FVADDR)
 		return;
 
 	mutex_lock(&ctx->kdamond_lock);
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-add-a-function-for-damon_operations-registration-checks.patch
mm-damon-sysfs-add-a-file-for-listing-available-monitoring-ops.patch
selftets-damon-sysfs-test-existence-and-permission-of-avail_operations.patch
docs-abiadmin-guide-damon-document-avail_operations-sysfs-file.patch
mm-damon-vaddr-register-a-damon_operations-for-fixed-virtual-address-ranges-monitoring.patch
mm-damon-sysfs-support-fixed-virtual-address-ranges-monitoring.patch
docs-abiadmin-guide-damon-update-for-fixed-virtual-address-ranges-monitoring.patch
mm-damon-core-add-a-new-callback-for-watermarks-checks.patch
mm-damon-core-finish-kdamond-as-soon-as-any-callback-returns-an-error.patch
mm-damon-vaddr-generalize-damon_va_apply_three_regions.patch
mm-damon-vaddr-move-damon_set_regions-to-core.patch
mm-damon-vaddr-remove-damon_va_apply_three_regions.patch
mm-damon-sysfs-prohibit-multiple-physical-address-space-monitoring-targets.patch
mm-damon-sysfs-move-targets-setup-code-to-a-separated-function.patch
mm-damon-sysfs-reuse-damon_set_regions-for-regions-setting.patch
mm-damon-sysfs-use-enum-for-state-input-handling.patch
mm-damon-sysfs-update-schemes-stat-in-the-kdamond-context.patch
mm-damon-sysfs-support-online-inputs-update.patch
docs-abiadmin-guide-damon-update-for-state-sysfs-file-input-keyword-commit.patch
mm-damon-reclaim-support-online-inputs-update.patch
docs-admin-guide-mm-damon-reclaim-document-commit_inputs-parameter.patch

