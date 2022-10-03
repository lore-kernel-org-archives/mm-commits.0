Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D692FC4332F
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:12:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbiJCVMx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:12:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230047AbiJCVLh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:11:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F20AE51A32
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:07:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC358B811BF
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:07:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61C32C433B5;
        Mon,  3 Oct 2022 21:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831237;
        bh=1xYu01n6QaF/bOykmJnCu20BLQHvzC8Sp/rTmdNlMTg=;
        h=Date:To:From:Subject:From;
        b=I30pHp4FnxazrXOeQtwIJ9Eeeuea16bRNY3u3QnoX0bcZs4f0rFm5a/NzsMS3ar9C
         dndEgdbhSM993glPuYR288gHZ8Io0KkYhwsMKo2Yani5LY/MVnZgAuNZJ7TfTde7FK
         N7AFueAYmITTQWaoeFZkE7scr6xN+2mg3Dv70M/s=
Date:   Mon, 03 Oct 2022 14:07:16 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-use-a-dedicated-struct-for-monitoring-attributes.patch removed from -mm tree
Message-Id: <20221003210717.61C32C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/core: use a dedicated struct for monitoring attributes
has been removed from the -mm tree.  Its filename was
     mm-damon-core-use-a-dedicated-struct-for-monitoring-attributes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: use a dedicated struct for monitoring attributes
Date: Tue, 13 Sep 2022 17:44:32 +0000

DAMON monitoring attributes are directly defined as fields of 'struct
damon_ctx'.  This makes 'struct damon_ctx' a little long and complicated. 
This commit defines and uses a struct, 'struct damon_attrs', which is
dedicated for only the monitoring attributes to make the purpose of the
five values clearer and simplify 'struct damon_ctx'.

Link: https://lkml.kernel.org/r/20220913174449.50645-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |   30 ++++++++++++++++++++----------
 mm/damon/core.c       |   34 +++++++++++++++++-----------------
 mm/damon/dbgfs.c      |    6 +++---
 mm/damon/ops-common.c |    4 ++--
 mm/damon/vaddr.c      |    4 ++--
 5 files changed, 44 insertions(+), 34 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-use-a-dedicated-struct-for-monitoring-attributes
+++ a/include/linux/damon.h
@@ -389,13 +389,15 @@ struct damon_callback {
 };
 
 /**
- * struct damon_ctx - Represents a context for each monitoring.  This is the
- * main interface that allows users to set the attributes and get the results
- * of the monitoring.
+ * struct damon_attrs - Monitoring attributes for accuracy/overhead control.
  *
  * @sample_interval:		The time between access samplings.
  * @aggr_interval:		The time between monitor results aggregations.
  * @ops_update_interval:	The time between monitoring operations updates.
+ * @min_nr_regions:		The minimum number of adaptive monitoring
+ *				regions.
+ * @max_nr_regions:		The maximum number of adaptive monitoring
+ *				regions.
  *
  * For each @sample_interval, DAMON checks whether each region is accessed or
  * not.  It aggregates and keeps the access information (number of accesses to
@@ -405,7 +407,21 @@ struct damon_callback {
  * @ops_update_interval.  All time intervals are in micro-seconds.
  * Please refer to &struct damon_operations and &struct damon_callback for more
  * detail.
+ */
+struct damon_attrs {
+	unsigned long sample_interval;
+	unsigned long aggr_interval;
+	unsigned long ops_update_interval;
+	unsigned long min_nr_regions;
+	unsigned long max_nr_regions;
+};
+
+/**
+ * struct damon_ctx - Represents a context for each monitoring.  This is the
+ * main interface that allows users to set the attributes and get the results
+ * of the monitoring.
  *
+ * @attrs:		Monitoring attributes for accuracy/overhead control.
  * @kdamond:		Kernel thread who does the monitoring.
  * @kdamond_lock:	Mutex for the synchronizations with @kdamond.
  *
@@ -427,15 +443,11 @@ struct damon_callback {
  * @ops:	Set of monitoring operations for given use cases.
  * @callback:	Set of callbacks for monitoring events notifications.
  *
- * @min_nr_regions:	The minimum number of adaptive monitoring regions.
- * @max_nr_regions:	The maximum number of adaptive monitoring regions.
  * @adaptive_targets:	Head of monitoring targets (&damon_target) list.
  * @schemes:		Head of schemes (&damos) list.
  */
 struct damon_ctx {
-	unsigned long sample_interval;
-	unsigned long aggr_interval;
-	unsigned long ops_update_interval;
+	struct damon_attrs attrs;
 
 /* private: internal use only */
 	struct timespec64 last_aggregation;
@@ -448,8 +460,6 @@ struct damon_ctx {
 	struct damon_operations ops;
 	struct damon_callback callback;
 
-	unsigned long min_nr_regions;
-	unsigned long max_nr_regions;
 	struct list_head adaptive_targets;
 	struct list_head schemes;
 };
--- a/mm/damon/core.c~mm-damon-core-use-a-dedicated-struct-for-monitoring-attributes
+++ a/mm/damon/core.c
@@ -382,17 +382,17 @@ struct damon_ctx *damon_new_ctx(void)
 	if (!ctx)
 		return NULL;
 
-	ctx->sample_interval = 5 * 1000;
-	ctx->aggr_interval = 100 * 1000;
-	ctx->ops_update_interval = 60 * 1000 * 1000;
+	ctx->attrs.sample_interval = 5 * 1000;
+	ctx->attrs.aggr_interval = 100 * 1000;
+	ctx->attrs.ops_update_interval = 60 * 1000 * 1000;
 
 	ktime_get_coarse_ts64(&ctx->last_aggregation);
 	ctx->last_ops_update = ctx->last_aggregation;
 
 	mutex_init(&ctx->kdamond_lock);
 
-	ctx->min_nr_regions = 10;
-	ctx->max_nr_regions = 1000;
+	ctx->attrs.min_nr_regions = 10;
+	ctx->attrs.max_nr_regions = 1000;
 
 	INIT_LIST_HEAD(&ctx->adaptive_targets);
 	INIT_LIST_HEAD(&ctx->schemes);
@@ -448,11 +448,11 @@ int damon_set_attrs(struct damon_ctx *ct
 	if (min_nr_reg > max_nr_reg)
 		return -EINVAL;
 
-	ctx->sample_interval = sample_int;
-	ctx->aggr_interval = aggr_int;
-	ctx->ops_update_interval = ops_upd_int;
-	ctx->min_nr_regions = min_nr_reg;
-	ctx->max_nr_regions = max_nr_reg;
+	ctx->attrs.sample_interval = sample_int;
+	ctx->attrs.aggr_interval = aggr_int;
+	ctx->attrs.ops_update_interval = ops_upd_int;
+	ctx->attrs.min_nr_regions = min_nr_reg;
+	ctx->attrs.max_nr_regions = max_nr_reg;
 
 	return 0;
 }
@@ -507,8 +507,8 @@ static unsigned long damon_region_sz_lim
 			sz += r->ar.end - r->ar.start;
 	}
 
-	if (ctx->min_nr_regions)
-		sz /= ctx->min_nr_regions;
+	if (ctx->attrs.min_nr_regions)
+		sz /= ctx->attrs.min_nr_regions;
 	if (sz < DAMON_MIN_REGION)
 		sz = DAMON_MIN_REGION;
 
@@ -657,7 +657,7 @@ static bool damon_check_reset_time_inter
 static bool kdamond_aggregate_interval_passed(struct damon_ctx *ctx)
 {
 	return damon_check_reset_time_interval(&ctx->last_aggregation,
-			ctx->aggr_interval);
+			ctx->attrs.aggr_interval);
 }
 
 /*
@@ -1016,12 +1016,12 @@ static void kdamond_split_regions(struct
 	damon_for_each_target(t, ctx)
 		nr_regions += damon_nr_regions(t);
 
-	if (nr_regions > ctx->max_nr_regions / 2)
+	if (nr_regions > ctx->attrs.max_nr_regions / 2)
 		return;
 
 	/* Maybe the middle of the region has different access frequency */
 	if (last_nr_regions == nr_regions &&
-			nr_regions < ctx->max_nr_regions / 3)
+			nr_regions < ctx->attrs.max_nr_regions / 3)
 		nr_subregions = 3;
 
 	damon_for_each_target(t, ctx)
@@ -1039,7 +1039,7 @@ static void kdamond_split_regions(struct
 static bool kdamond_need_update_operations(struct damon_ctx *ctx)
 {
 	return damon_check_reset_time_interval(&ctx->last_ops_update,
-			ctx->ops_update_interval);
+			ctx->attrs.ops_update_interval);
 }
 
 /*
@@ -1188,7 +1188,7 @@ static int kdamond_fn(void *data)
 			continue;
 		}
 
-		kdamond_usleep(ctx->sample_interval);
+		kdamond_usleep(ctx->attrs.sample_interval);
 
 		if (ctx->ops.check_accesses)
 			max_nr_accesses = ctx->ops.check_accesses(ctx);
--- a/mm/damon/dbgfs.c~mm-damon-core-use-a-dedicated-struct-for-monitoring-attributes
+++ a/mm/damon/dbgfs.c
@@ -55,9 +55,9 @@ static ssize_t dbgfs_attrs_read(struct f
 
 	mutex_lock(&ctx->kdamond_lock);
 	ret = scnprintf(kbuf, ARRAY_SIZE(kbuf), "%lu %lu %lu %lu %lu\n",
-			ctx->sample_interval, ctx->aggr_interval,
-			ctx->ops_update_interval, ctx->min_nr_regions,
-			ctx->max_nr_regions);
+			ctx->attrs.sample_interval, ctx->attrs.aggr_interval,
+			ctx->attrs.ops_update_interval,
+			ctx->attrs.min_nr_regions, ctx->attrs.max_nr_regions);
 	mutex_unlock(&ctx->kdamond_lock);
 
 	return simple_read_from_buffer(buf, count, ppos, kbuf, ret);
--- a/mm/damon/ops-common.c~mm-damon-core-use-a-dedicated-struct-for-monitoring-attributes
+++ a/mm/damon/ops-common.c
@@ -99,10 +99,10 @@ int damon_hot_score(struct damon_ctx *c,
 	unsigned int age_weight = s->quota.weight_age;
 	int hotness;
 
-	max_nr_accesses = c->aggr_interval / c->sample_interval;
+	max_nr_accesses = c->attrs.aggr_interval / c->attrs.sample_interval;
 	freq_subscore = r->nr_accesses * DAMON_MAX_SUBSCORE / max_nr_accesses;
 
-	age_in_sec = (unsigned long)r->age * c->aggr_interval / 1000000;
+	age_in_sec = (unsigned long)r->age * c->attrs.aggr_interval / 1000000;
 	for (age_in_log = 0; age_in_log < DAMON_MAX_AGE_IN_LOG && age_in_sec;
 			age_in_log++, age_in_sec >>= 1)
 		;
--- a/mm/damon/vaddr.c~mm-damon-core-use-a-dedicated-struct-for-monitoring-attributes
+++ a/mm/damon/vaddr.c
@@ -251,8 +251,8 @@ static void __damon_va_init_regions(stru
 
 	for (i = 0; i < 3; i++)
 		sz += regions[i].end - regions[i].start;
-	if (ctx->min_nr_regions)
-		sz /= ctx->min_nr_regions;
+	if (ctx->attrs.min_nr_regions)
+		sz /= ctx->attrs.min_nr_regions;
 	if (sz < DAMON_MIN_REGION)
 		sz = DAMON_MIN_REGION;
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-initialize-damon_target-list-in-damon_new_target.patch

