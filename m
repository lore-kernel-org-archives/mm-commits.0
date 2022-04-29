Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9DF8C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 29 Apr 2022 16:26:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379071AbiD2Q3o (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Apr 2022 12:29:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379105AbiD2Q3f (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2022 12:29:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46963DA6C5
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 09:26:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA5BE622A9
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 16:26:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C59AC385A4;
        Fri, 29 Apr 2022 16:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651249575;
        bh=gu+2UWeWIu8poUMPdVjGkya34FnH5ySg52ZCv5fWOv0=;
        h=Date:To:From:Subject:From;
        b=Yn3iCoCcQvmQJuP+U3WI7u89lbF63Zh2iWmKdiQWIG90S95x61uZ9i5OPYvv794yt
         Z7GB9t3kBzZicpO6nKAMqVt4MabTwoYatc7J4dQNi64qKqvzGCs0JVIFjlCrp5OlBE
         4y1zHuKwbR559TBfsNIDfYzC55OQ5Dsddl1EHvWs=
Date:   Fri, 29 Apr 2022 09:26:14 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-reclaim-support-online-inputs-update.patch added to mm-unstable branch
Message-Id: <20220429162615.1C59AC385A4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/reclaim: support online inputs update
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-reclaim-support-online-inputs-update.patch

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
Subject: mm/damon/reclaim: support online inputs update

DAMON_RECLAIM reads the user input parameters only when it starts.  To
allow more efficient online tuning, this commit implements a new input
parameter called 'commit_inputs'.  Writing true to the parameter makes
DAMON_RECLAIM reads the input parameters again.

Link: https://lkml.kernel.org/r/20220429160606.127307-14-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/reclaim.c |   95 ++++++++++++++++++++++++++++---------------
 1 file changed, 62 insertions(+), 33 deletions(-)

--- a/mm/damon/reclaim.c~mm-damon-reclaim-support-online-inputs-update
+++ a/mm/damon/reclaim.c
@@ -30,6 +30,18 @@
 static bool enabled __read_mostly;
 
 /*
+ * Make DAMON_RECLAIM reads the input parameters again, except ``enabled``.
+ *
+ * Input parameters that updated while DAMON_RECLAIM is running are not applied
+ * by default.  Once this parameter is set as ``Y``, DAMON_RECLAIM reads values
+ * of parametrs except ``enabled`` again.  Once the re-reading is done, this
+ * parameter is set as ``N``.  If invalid parameters are found while the
+ * re-reading, DAMON_RECLAIM will be disabled.
+ */
+static bool commit_inputs __read_mostly;
+module_param(commit_inputs, bool, 0600);
+
+/*
  * Time threshold for cold memory regions identification in microseconds.
  *
  * If a memory region is not accessed for this or longer time, DAMON_RECLAIM
@@ -289,57 +301,56 @@ static struct damos *damon_reclaim_new_s
 	return scheme;
 }
 
-static int damon_reclaim_turn(bool on)
+static int damon_reclaim_apply_parameters(void)
 {
-	struct damon_region *region;
 	struct damos *scheme;
-	int err;
-
-	if (!on) {
-		err = damon_stop(&ctx, 1);
-		if (!err)
-			kdamond_pid = -1;
-		return err;
-	}
+	struct damon_addr_range addr_range;
+	int err = 0;
 
 	err = damon_set_attrs(ctx, sample_interval, aggr_interval, 0,
 			min_nr_regions, max_nr_regions);
 	if (err)
 		return err;
 
+	/* Will be freed by next 'damon_set_schemes()' below */
+	scheme = damon_reclaim_new_scheme();
+	if (!scheme)
+		return -ENOMEM;
+	err = damon_set_schemes(ctx, &scheme, 1);
+	if (err)
+		return err;
+
 	if (monitor_region_start > monitor_region_end)
 		return -EINVAL;
 	if (!monitor_region_start && !monitor_region_end &&
 			!get_monitoring_region(&monitor_region_start,
 				&monitor_region_end))
 		return -EINVAL;
-	/* DAMON will free this on its own when finish monitoring */
-	region = damon_new_region(monitor_region_start, monitor_region_end);
-	if (!region)
-		return -ENOMEM;
-	damon_add_region(region, target);
+	addr_range.start = monitor_region_start;
+	addr_range.end = monitor_region_end;
+	return damon_set_regions(target, &addr_range, 1);
+}
 
-	/* Will be freed by 'damon_set_schemes()' below */
-	scheme = damon_reclaim_new_scheme();
-	if (!scheme) {
-		err = -ENOMEM;
-		goto free_region_out;
+static int damon_reclaim_turn(bool on)
+{
+	int err;
+
+	if (!on) {
+		err = damon_stop(&ctx, 1);
+		if (!err)
+			kdamond_pid = -1;
+		return err;
 	}
-	err = damon_set_schemes(ctx, &scheme, 1);
+
+	err = damon_reclaim_apply_parameters();
 	if (err)
-		goto free_scheme_out;
+		return err;
 
 	err = damon_start(&ctx, 1, true);
-	if (!err) {
-		kdamond_pid = ctx->kdamond->pid;
-		return 0;
-	}
-
-free_scheme_out:
-	damon_destroy_scheme(scheme);
-free_region_out:
-	damon_destroy_region(region, target);
-	return err;
+	if (err)
+		return err;
+	kdamond_pid = ctx->kdamond->pid;
+	return 0;
 }
 
 #define ENABLE_CHECK_INTERVAL_MS	1000
@@ -389,6 +400,7 @@ MODULE_PARM_DESC(enabled,
 static int damon_reclaim_after_aggregation(struct damon_ctx *c)
 {
 	struct damos *s;
+	int err = 0;
 
 	/* update the stats parameter */
 	damon_for_each_scheme(s, c) {
@@ -398,7 +410,23 @@ static int damon_reclaim_after_aggregati
 		bytes_reclaimed_regions = s->stat.sz_applied;
 		nr_quota_exceeds = s->stat.qt_exceeds;
 	}
-	return 0;
+
+	if (commit_inputs) {
+		err = damon_reclaim_apply_parameters();
+		commit_inputs = false;
+	}
+	return err;
+}
+
+static int damon_reclaim_after_wmarks_check(struct damon_ctx *c)
+{
+	int err = 0;
+
+	if (commit_inputs) {
+		err = damon_reclaim_apply_parameters();
+		commit_inputs = false;
+	}
+	return err;
 }
 
 static int __init damon_reclaim_init(void)
@@ -410,6 +438,7 @@ static int __init damon_reclaim_init(voi
 	if (damon_select_ops(ctx, DAMON_OPS_PADDR))
 		return -EINVAL;
 
+	ctx->callback.after_wmarks_check = damon_reclaim_after_wmarks_check;
 	ctx->callback.after_aggregation = damon_reclaim_after_aggregation;
 
 	target = damon_new_target();
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

