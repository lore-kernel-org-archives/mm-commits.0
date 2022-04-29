Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0F92C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 29 Apr 2022 16:26:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379064AbiD2Q3g (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Apr 2022 12:29:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379076AbiD2Q30 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2022 12:29:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 258F1D95E7
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 09:26:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64D896231F
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 16:26:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6D44C385AE;
        Fri, 29 Apr 2022 16:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651249563;
        bh=QcA01Qjbxot//oNsz2kBmNp9Lg/8fGHEiZ02CBYB65c=;
        h=Date:To:From:Subject:From;
        b=EepzBDFId6FeEfb6/PZpTujKf4fxqOcfNVQtUGmtt0JuFe9V9SaJ5sSG5hQSPHX2z
         XwAMJvTlnsFrr5EKXziELX0tksuo2BGKefXqcM6I9WpGJSJAQjs3hdX+5Nd6qV7xBM
         9WD0u9CrPmGyfwCKn1vzzuNAol0umU8i6vnc8M54=
Date:   Fri, 29 Apr 2022 09:26:03 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-move-targets-setup-code-to-a-separated-function.patch added to mm-unstable branch
Message-Id: <20220429162603.B6D44C385AE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/sysfs: move targets setup code to a separated function
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-move-targets-setup-code-to-a-separated-function.patch

This patch should soon appear in the mm-unstable branch at
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
Subject: mm/damon/sysfs: move targets setup code to a separated function

This commit separates DAMON sysfs interface's monitoring context targets
setup code to a new function for better readability.

Link: https://lkml.kernel.org/r/20220429160606.127307-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |   49 +++++++++++++++++++++++++--------------------
 1 file changed, 28 insertions(+), 21 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-move-targets-setup-code-to-a-separated-function
+++ a/mm/damon/sysfs.c
@@ -2119,6 +2119,31 @@ static int damon_sysfs_set_regions(struc
 	return 0;
 }
 
+static int damon_sysfs_add_target(struct damon_sysfs_target *sys_target,
+		struct damon_ctx *ctx)
+{
+	struct damon_target *t = damon_new_target();
+	int err = -EINVAL;
+
+	if (!t)
+		return -ENOMEM;
+	if (ctx->ops.id == DAMON_OPS_VADDR ||
+			ctx->ops.id == DAMON_OPS_FVADDR) {
+		t->pid = find_get_pid(sys_target->pid);
+		if (!t->pid)
+			goto destroy_targets_out;
+	}
+	damon_add_target(ctx, t);
+	err = damon_sysfs_set_regions(t, sys_target->regions);
+	if (err)
+		goto destroy_targets_out;
+	return 0;
+
+destroy_targets_out:
+	damon_sysfs_destroy_targets(ctx);
+	return err;
+}
+
 static int damon_sysfs_set_targets(struct damon_ctx *ctx,
 		struct damon_sysfs_targets *sysfs_targets)
 {
@@ -2129,28 +2154,10 @@ static int damon_sysfs_set_targets(struc
 		return -EINVAL;
 
 	for (i = 0; i < sysfs_targets->nr; i++) {
-		struct damon_sysfs_target *sys_target =
-			sysfs_targets->targets_arr[i];
-		struct damon_target *t = damon_new_target();
-
-		if (!t) {
-			damon_sysfs_destroy_targets(ctx);
-			return -ENOMEM;
-		}
-		if (ctx->ops.id == DAMON_OPS_VADDR ||
-				ctx->ops.id == DAMON_OPS_FVADDR) {
-			t->pid = find_get_pid(sys_target->pid);
-			if (!t->pid) {
-				damon_sysfs_destroy_targets(ctx);
-				return -EINVAL;
-			}
-		}
-		damon_add_target(ctx, t);
-		err = damon_sysfs_set_regions(t, sys_target->regions);
-		if (err) {
-			damon_sysfs_destroy_targets(ctx);
+		err = damon_sysfs_add_target(
+				sysfs_targets->targets_arr[i], ctx);
+		if (err)
 			return err;
-		}
 	}
 	return 0;
 }
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-test-add-a-kunit-test-case-for-ops-registration.patch
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

