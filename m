Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5D81C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 29 Apr 2022 16:26:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379057AbiD2Q3R (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Apr 2022 12:29:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379048AbiD2Q3Q (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2022 12:29:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0795D5C654
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 09:25:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B373DB83697
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 16:25:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6029CC385A4;
        Fri, 29 Apr 2022 16:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651249553;
        bh=gpF9KRg/lasvXqVZf/a0WH0ho64UtDK0SGqx/st7ajQ=;
        h=Date:To:From:Subject:From;
        b=ONNOAi8ORz+qFrqHU/5JlyDV/VPnRG7Aj1bHOX5xzJ8ouo/A7kn4kRs0D7jGusipD
         E+ewlEeuMaW/cxqZW1gn3OQtcUq1e552yUAdTh4MCfX12XO0igBk1m7h3kRUEd//yH
         qglyX/iWcKRHrQcStpIe0U3MYgdwAVleEnQYHjrI=
Date:   Fri, 29 Apr 2022 09:25:52 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-finish-kdamond-as-soon-as-any-callback-returns-an-error.patch added to mm-unstable branch
Message-Id: <20220429162553.6029CC385A4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/core: finish kdamond as soon as any callback returns an error
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-finish-kdamond-as-soon-as-any-callback-returns-an-error.patch

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
Subject: mm/damon/core: finish kdamond as soon as any callback returns an error

When 'after_sampling()' or 'after_aggregation()' DAMON callbacks return an
error, kdamond continues the remaining loop once.  It makes no much sense
to run the remaining part while something wrong already happened.  The
context might be corrupted or having invalid data.  This commit therefore
makes kdamond skips the remaining works and immediately finish in the
cases.

Link: https://lkml.kernel.org/r/20220429160606.127307-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-finish-kdamond-as-soon-as-any-callback-returns-an-error
+++ a/mm/damon/core.c
@@ -1089,8 +1089,10 @@ static int kdamond_fn(void *data)
 		if (ctx->ops.prepare_access_checks)
 			ctx->ops.prepare_access_checks(ctx);
 		if (ctx->callback.after_sampling &&
-				ctx->callback.after_sampling(ctx))
+				ctx->callback.after_sampling(ctx)) {
 			done = true;
+			continue;
+		}
 
 		kdamond_usleep(ctx->sample_interval);
 
@@ -1102,8 +1104,10 @@ static int kdamond_fn(void *data)
 					max_nr_accesses / 10,
 					sz_limit);
 			if (ctx->callback.after_aggregation &&
-					ctx->callback.after_aggregation(ctx))
+					ctx->callback.after_aggregation(ctx)) {
 				done = true;
+				continue;
+			}
 			kdamond_apply_schemes(ctx);
 			kdamond_reset_aggregated(ctx);
 			kdamond_split_regions(ctx);
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

