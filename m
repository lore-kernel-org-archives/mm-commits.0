Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80BFBC433FE
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:19:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236141AbiEJEXC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:23:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236190AbiEJEUu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:20:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8308D3CFE9
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:15:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E26961766
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:15:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74D28C385C5;
        Tue, 10 May 2022 04:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156158;
        bh=qYKvJzD5QeKMLYy0PSz/uUp/+0PdAJfEvH6ix4YHeaM=;
        h=Date:To:From:Subject:From;
        b=gR0BHPafAw4EWIySnSfZ8Bz9TgiDo1DEzVConPtyLdXbqOISxdCddlAXywje8JeRt
         RFau+FXjyzWGlJnscwEwG8LLpkPPdtf3vfNXuA7RMU2teY55VEVmO8JqI3IlJe7CS0
         Fy5Q6caOVH73oOTpyweTkRIrc5vvSVIuHf3+TjQ8=
Date:   Mon, 09 May 2022 21:15:57 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-reclaim-support-online-inputs-update.patch removed from -mm tree
Message-Id: <20220510041558.74D28C385C5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/reclaim: support online inputs update
has been removed from the -mm tree.  Its filename was
     mm-damon-reclaim-support-online-inputs-update.patch

This patch was dropped because it was merged into mm-stable

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


