Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3012C54EE9
	for <mm-commits@archiver.kernel.org>; Tue, 13 Sep 2022 21:53:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbiIMVxo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Sep 2022 17:53:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbiIMVxi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 13 Sep 2022 17:53:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03FF16DAED
        for <mm-commits@vger.kernel.org>; Tue, 13 Sep 2022 14:53:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2F28B810F2
        for <mm-commits@vger.kernel.org>; Tue, 13 Sep 2022 21:53:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57E86C433D6;
        Tue, 13 Sep 2022 21:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663106014;
        bh=xxwfl6vXK8MWzRA2nlYujH8NYqaYE3pKt8NN7jsm0t4=;
        h=Date:To:From:Subject:From;
        b=HKFcoiecd9e6bX5cNKE+InlfMb3xf2K5SwFWvn+Vi5MvW8/oNmO2qNokyTrPpjKnD
         pjIg5ViRRSs0MSLKF0bcvmmQ0Gah3N499WskaA80XPU9g3cdii7/mRgSpkoo0LyxsH
         0cO9PI7BEiMP9qi6bc3jVCa+TiLbWUFASmQvrF1M=
Date:   Tue, 13 Sep 2022 14:53:33 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-use-a-dedicated-struct-for-monitoring-attributes.patch added to mm-unstable branch
Message-Id: <20220913215334.57E86C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/core: use a dedicated struct for monitoring attributes
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-use-a-dedicated-struct-for-monitoring-attributes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-use-a-dedicated-struct-for-monitoring-attributes.patch

This patch will later appear in the mm-unstable branch at
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
@@ -376,17 +376,17 @@ struct damon_ctx *damon_new_ctx(void)
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
@@ -442,11 +442,11 @@ int damon_set_attrs(struct damon_ctx *ct
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
@@ -501,8 +501,8 @@ static unsigned long damon_region_sz_lim
 			sz += r->ar.end - r->ar.start;
 	}
 
-	if (ctx->min_nr_regions)
-		sz /= ctx->min_nr_regions;
+	if (ctx->attrs.min_nr_regions)
+		sz /= ctx->attrs.min_nr_regions;
 	if (sz < DAMON_MIN_REGION)
 		sz = DAMON_MIN_REGION;
 
@@ -651,7 +651,7 @@ static bool damon_check_reset_time_inter
 static bool kdamond_aggregate_interval_passed(struct damon_ctx *ctx)
 {
 	return damon_check_reset_time_interval(&ctx->last_aggregation,
-			ctx->aggr_interval);
+			ctx->attrs.aggr_interval);
 }
 
 /*
@@ -1010,12 +1010,12 @@ static void kdamond_split_regions(struct
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
@@ -1033,7 +1033,7 @@ static void kdamond_split_regions(struct
 static bool kdamond_need_update_operations(struct damon_ctx *ctx)
 {
 	return damon_check_reset_time_interval(&ctx->last_ops_update,
-			ctx->ops_update_interval);
+			ctx->attrs.ops_update_interval);
 }
 
 /*
@@ -1182,7 +1182,7 @@ static int kdamond_fn(void *data)
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

mm-demotion-update-node_is_toptier-to-work-with-memory-tiers-fix.patch
selftest-damon-add-a-test-for-duplicate-context-dirs-creation.patch
mm-damon-core-avoid-holes-in-newly-set-monitoring-target-ranges.patch
mm-damon-core-test-test-damon_set_regions.patch
docs-admin-guide-mm-damon-rename-the-title-of-the-document.patch
mm-damon-kconfig-notify-debugfs-deprecation-plan.patch
docs-admin-guide-mm-damon-start-mention-the-dependency-as-sysfs-instead-of-debugfs.patch
docs-admin-guide-mm-damon-usage-note-damon-debugfs-interface-deprecation-plan.patch
mm-damon-paddr-make-supported-damos-actions-of-paddr-clear.patch
mm-damon-paddr-deduplicate-damon_pa_mark_accesseddeactivate_pages.patch
mm-damon-core-copy-struct-to-struct-instead-of-field-to-field-in-damon_new_scheme.patch
mm-damon-core-factor-out-damos_quota-private-fileds-initialization.patch
mm-damon-core-use-a-dedicated-struct-for-monitoring-attributes.patch
mm-damon-core-reduce-parameters-for-damon_set_attrs.patch
mm-damon-reclaim-use-struct-damon_attrs-for-storing-parameters-for-it.patch
mm-damon-lru_sort-use-struct-damon_attrs-for-storing-parameters-for-it.patch
mm-damon-implement-a-monitoring-attributes-module-parameters-generator-macro.patch
mm-damon-lru_sort-use-monitoring-attributes-parameters-generaotr-macro.patch
mm-damon-reclaim-use-monitoring-attributes-parameters-generator-macro.patch
mm-damon-modules-common-implement-a-watermarks-module-parameters-generator-macro.patch
mm-damon-lru_sort-use-watermarks-parameters-generator-macro.patch
mm-damon-reclaim-use-watermarks-parameters-generator-macro.patch
mm-damon-modules-common-implement-a-stats-parameters-generator-macro.patch
mm-damon-reclaim-use-stat-parameters-generator.patch
mm-damon-lru_sort-use-stat-generator.patch
mm-damon-modules-common-implement-a-damos-quota-params-generator.patch
mm-damon-modules-common-implement-damos-time-quota-params-generator.patch
mm-damon-reclaim-use-the-quota-params-generator-macro.patch
mm-damon-lru_sort-use-quotas-param-generator.patch
mm-damon-lru_sort-deduplicate-hot-cold-schemes-generators.patch

