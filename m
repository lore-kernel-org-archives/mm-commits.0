Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A9A0C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 29 Apr 2022 16:25:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379050AbiD2Q3N (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Apr 2022 12:29:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379052AbiD2Q3M (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2022 12:29:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B825BD4C8C
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 09:25:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4663BB8369A
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 16:25:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8FCEC385AE;
        Fri, 29 Apr 2022 16:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651249551;
        bh=LN+d7lXaEBG4lqoHnTShB/kyxorDZRPOmeSWOMLEvb0=;
        h=Date:To:From:Subject:From;
        b=iMuEwS33Xqj0ARqfC/lYxuw2jXZxAs/6eSXwvXAd4jQGDGatS8LcxxxfFs7a34stw
         4SHtfLZUYoddIZG0yqestoW7+Jp6K1wQ0NOoICaeKqZZ4B4HGoZGQ9YBHnmZH5rwFT
         /kxvEdXE+A0okWwxxX1ESHAy8vOJkonfTop/NvN0=
Date:   Fri, 29 Apr 2022 09:25:50 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-add-a-new-callback-for-watermarks-checks.patch added to mm-unstable branch
Message-Id: <20220429162550.D8FCEC385AE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/core: add a new callback for watermarks checks
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-add-a-new-callback-for-watermarks-checks.patch

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
Subject: mm/damon/core: add a new callback for watermarks checks

Patch series "mm/damon: Support online tuning".

Effects of DAMON and DAMON-based Operation Schemes highly depends on the
configurations.  Wrong configurations could even result in unexpected
efficiency degradations.  For finding a best configuration, repeating
incremental configuration changes and results measurements, in other
words, online tuning, could be helpful.

Nevertheless, DAMON kernel API supports only restrictive online tuning. 
Worse yet, the sysfs-based DAMON user interface doesn't support online
tuning at all.  DAMON_RECLAIM also doesn't support online tuning.

This patchset makes the DAMON kernel API, DAMON sysfs interface, and
DAMON_RECLAIM supports online tuning.

Sequence of patches
-------------------

First two patches enhance DAMON online tuning for kernel API users. 
Specifically, patch 1 let kernel API users to be able to do DAMON online
tuning without a restriction, and patch 2 makes error handling easier.

Following seven patches (patches 3-9) refactor code for better readability
and easier reuse of code fragments that will be useful for online tuning
support.

Patch 10 introduces DAMON callback based user request handling structure
for DAMON sysfs interface, and patch 11 enables DAMON online tuning via
DAMON sysfs interface.  Documentation patch (patch 12) for usage of it
follows.

Patch 13 enables online tuning of DAMON_RECLAIM and finally patch 14
documents the DAMON_RECLAIM online tuning usage.


This patch (of 14):

For updating input parameters for running DAMON contexts, DAMON kernel API
users can use the contexts' callbacks, as it is the safe place for context
internal data accesses.  When the context has DAMON-based operation
schemes and all schemes are deactivated due to their watermarks, however,
DAMON does nothing but only watermarks checks.  As a result, no callbacks
will be called back, and therefore the kernel API users cannot update the
input parameters including monitoring attributes, DAMON-based operation
schemes, and watermarks.

To let users easily update such DAMON input parameters in such a case,
this commit adds a new callback, 'after_wmarks_check()'.  It will be
called after each watermarks check.  Users can do the online input
parameters update in the callback even under the schemes deactivated case.

Link: https://lkml.kernel.org/r/20220429160606.127307-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    7 +++++++
 mm/damon/core.c       |    8 +++++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

--- a/include/linux/damon.h~mm-damon-core-add-a-new-callback-for-watermarks-checks
+++ a/include/linux/damon.h
@@ -343,6 +343,7 @@ struct damon_operations {
  * struct damon_callback - Monitoring events notification callbacks.
  *
  * @before_start:	Called before starting the monitoring.
+ * @after_wmarks_check:	Called after each schemes' watermarks check.
  * @after_sampling:	Called after each sampling.
  * @after_aggregation:	Called after each aggregation.
  * @before_terminate:	Called before terminating the monitoring.
@@ -353,6 +354,11 @@ struct damon_operations {
  * respectively.  Therefore, those are good places for installing and cleaning
  * @private.
  *
+ * The monitoring thread calls @after_wmarks_check after each DAMON-based
+ * operation schemes' watermarks check.  If users need to make changes to the
+ * attributes of the monitoring context while it's deactivated due to the
+ * watermarks, this is the good place to do.
+ *
  * The monitoring thread calls @after_sampling and @after_aggregation for each
  * of the sampling intervals and aggregation intervals, respectively.
  * Therefore, users can safely access the monitoring results without additional
@@ -365,6 +371,7 @@ struct damon_callback {
 	void *private;
 
 	int (*before_start)(struct damon_ctx *context);
+	int (*after_wmarks_check)(struct damon_ctx *context);
 	int (*after_sampling)(struct damon_ctx *context);
 	int (*after_aggregation)(struct damon_ctx *context);
 	void (*before_terminate)(struct damon_ctx *context);
--- a/mm/damon/core.c~mm-damon-core-add-a-new-callback-for-watermarks-checks
+++ a/mm/damon/core.c
@@ -1051,6 +1051,10 @@ static int kdamond_wait_activation(struc
 			return 0;
 
 		kdamond_usleep(min_wait_time);
+
+		if (ctx->callback.after_wmarks_check &&
+				ctx->callback.after_wmarks_check(ctx))
+			break;
 	}
 	return -EBUSY;
 }
@@ -1077,8 +1081,10 @@ static int kdamond_fn(void *data)
 	sz_limit = damon_region_sz_limit(ctx);
 
 	while (!kdamond_need_stop(ctx) && !done) {
-		if (kdamond_wait_activation(ctx))
+		if (kdamond_wait_activation(ctx)) {
+			done = true;
 			continue;
+		}
 
 		if (ctx->ops.prepare_access_checks)
 			ctx->ops.prepare_access_checks(ctx);
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

