Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A91C5CCA480
	for <mm-commits@archiver.kernel.org>; Mon, 13 Jun 2022 20:42:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235308AbiFMUlx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Jun 2022 16:41:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343523AbiFMUlG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Jun 2022 16:41:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C193065E5
        for <mm-commits@vger.kernel.org>; Mon, 13 Jun 2022 12:40:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57E7EB81262
        for <mm-commits@vger.kernel.org>; Mon, 13 Jun 2022 19:40:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A3B7C34114;
        Mon, 13 Jun 2022 19:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655149250;
        bh=OHmNAbhD/g22m2tFptyWEiDDyF73nqB1N6A5xa1NmJY=;
        h=Date:To:From:Subject:From;
        b=Hby65l8ziIH1YwqC8UBT7A2SBRwiJLpSHNZDgznLRZreMtx88VT2+p8MqNglmipF2
         e71bU7KWsRoMUUKSGGrReCII+VcO6oQ6ZgnFk4USAOfL3qH7sepIX8QmVseEpKAsjr
         Y5fHo7XR3F4jYyeA0O6fMMEE6u0oioQQmIS0PG5Q=
Date:   Mon, 13 Jun 2022 12:40:49 -0700
To:     mm-commits@vger.kernel.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-introduce-damon-based-lru-lists-sorting.patch added to mm-unstable branch
Message-Id: <20220613194050.0A3B7C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: introduce DAMON-based LRU-lists Sorting
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-introduce-damon-based-lru-lists-sorting.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-introduce-damon-based-lru-lists-sorting.patch

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
Subject: mm/damon: introduce DAMON-based LRU-lists Sorting
Date: Mon, 13 Jun 2022 19:23:00 +0000

Users can do data access-aware LRU-lists sorting using 'LRU_PRIO' and
'LRU_DEPRIO' DAMOS actions.  However, finding best parameters including
the hotness/coldness thresholds, CPU quota, and watermarks could be
challenging for some users.  To make the scheme easy to be used without
complex tuning for common situations, this commit implements a static
kernel module called 'DAMON_LRU_SORT' using the 'LRU_PRIO' and
'LRU_DEPRIO' DAMOS actions.

It proactively sorts LRU-lists using DAMON with conservatively chosen
default values of the parameters.  That is, the module under its default
parameters will make no harm for common situations but provide some level
of efficiency improvements for systems having clear hot/cold access
pattern under a level of memory pressure while consuming only a limited
small portion of CPU time.

Link: https://lkml.kernel.org/r/20220613192301.8817-9-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/Kconfig    |    8 
 mm/damon/Makefile   |    1 
 mm/damon/lru_sort.c |  546 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 555 insertions(+)

--- a/mm/damon/Kconfig~mm-damon-introduce-damon-based-lru-lists-sorting
+++ a/mm/damon/Kconfig
@@ -92,4 +92,12 @@ config DAMON_RECLAIM
 	  reclamation under light memory pressure, while the traditional page
 	  scanning-based reclamation is used for heavy pressure.
 
+config DAMON_LRU_SORT
+	bool "Build DAMON-based LRU-lists sorting (DAMON_LRU_SORT)"
+	depends on DAMON_PADDR
+	help
+	  This builds the DAMON-based LRU-lists sorting subsystem.  It tries to
+	  protect frequently accessed (hot) pages while rarely accessed (cold)
+	  pages reclaimed first under memory pressure.
+
 endmenu
--- /dev/null
+++ a/mm/damon/lru_sort.c
@@ -0,0 +1,546 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * DAMON-based LRU-lists Sorting
+ *
+ * Author: SeongJae Park <sj@kernel.org>
+ */
+
+#define pr_fmt(fmt) "damon-lru-sort: " fmt
+
+#include <linux/damon.h>
+#include <linux/ioport.h>
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/workqueue.h>
+
+#ifdef MODULE_PARAM_PREFIX
+#undef MODULE_PARAM_PREFIX
+#endif
+#define MODULE_PARAM_PREFIX "damon_lru_sort."
+
+/*
+ * Enable or disable DAMON_LRU_SORT.
+ *
+ * You can enable DAMON_LRU_SORT by setting the value of this parameter as
+ * ``Y``.  Setting it as ``N`` disables DAMON_LRU_SORT.  Note that
+ * DAMON_LRU_SORT could do no real monitoring and LRU-lists sorting due to the
+ * watermarks-based activation condition.  Refer to below descriptions for the
+ * watermarks parameter for this.
+ */
+static bool enabled __read_mostly;
+
+/*
+ * Make DAMON_LRU_SORT reads the input parameters again, except ``enabled``.
+ *
+ * Input parameters that updated while DAMON_LRU_SORT is running are not
+ * applied by default.  Once this parameter is set as ``Y``, DAMON_LRU_SORT
+ * reads values of parametrs except ``enabled`` again.  Once the re-reading is
+ * done, this parameter is set as ``N``.  If invalid parameters are found while
+ * the re-reading, DAMON_LRU_SORT will be disabled.
+ */
+static bool commit_inputs __read_mostly;
+module_param(commit_inputs, bool, 0600);
+
+/*
+ * Access frequency threshold for hot memory regions identification in permil.
+ *
+ * If a memory region is accessed in frequency of this or higher,
+ * DAMON_LRU_SORT identifies the region as hot, and mark it as accessed on the
+ * LRU list, so that it could not be reclaimed under memory pressure.  50% by
+ * default.
+ */
+static unsigned long hot_thres_access_freq = 500;
+module_param(hot_thres_access_freq, ulong, 0600);
+
+/*
+ * Time threshold for cold memory regions identification in microseconds.
+ *
+ * If a memory region is not accessed for this or longer time, DAMON_LRU_SORT
+ * identifies the region as cold, and mark it as unaccessed on the LRU list, so
+ * that it could be reclaimed first under memory pressure.  120 seconds by
+ * default.
+ */
+static unsigned long cold_min_age __read_mostly = 120000000;
+module_param(cold_min_age, ulong, 0600);
+
+/*
+ * Limit of time for trying the LRU lists sorting in milliseconds.
+ *
+ * DAMON_LRU_SORT tries to use only up to this time within a time window
+ * (quota_reset_interval_ms) for trying LRU lists sorting.  This can be used
+ * for limiting CPU consumption of DAMON_LRU_SORT.  If the value is zero, the
+ * limit is disabled.
+ *
+ * 10 ms by default.
+ */
+static unsigned long quota_ms __read_mostly = 10;
+module_param(quota_ms, ulong, 0600);
+
+/*
+ * The time quota charge reset interval in milliseconds.
+ *
+ * The charge reset interval for the quota of time (quota_ms).  That is,
+ * DAMON_LRU_SORT does not try LRU-lists sorting for more than quota_ms
+ * milliseconds or quota_sz bytes within quota_reset_interval_ms milliseconds.
+ *
+ * 1 second by default.
+ */
+static unsigned long quota_reset_interval_ms __read_mostly = 1000;
+module_param(quota_reset_interval_ms, ulong, 0600);
+
+/*
+ * The watermarks check time interval in microseconds.
+ *
+ * Minimal time to wait before checking the watermarks, when DAMON_LRU_SORT is
+ * enabled but inactive due to its watermarks rule.  5 seconds by default.
+ */
+static unsigned long wmarks_interval __read_mostly = 5000000;
+module_param(wmarks_interval, ulong, 0600);
+
+/*
+ * Free memory rate (per thousand) for the high watermark.
+ *
+ * If free memory of the system in bytes per thousand bytes is higher than
+ * this, DAMON_LRU_SORT becomes inactive, so it does nothing but periodically
+ * checks the watermarks.  200 (20%) by default.
+ */
+static unsigned long wmarks_high __read_mostly = 200;
+module_param(wmarks_high, ulong, 0600);
+
+/*
+ * Free memory rate (per thousand) for the middle watermark.
+ *
+ * If free memory of the system in bytes per thousand bytes is between this and
+ * the low watermark, DAMON_LRU_SORT becomes active, so starts the monitoring
+ * and the LRU-lists sorting.  150 (15%) by default.
+ */
+static unsigned long wmarks_mid __read_mostly = 150;
+module_param(wmarks_mid, ulong, 0600);
+
+/*
+ * Free memory rate (per thousand) for the low watermark.
+ *
+ * If free memory of the system in bytes per thousand bytes is lower than this,
+ * DAMON_LRU_SORT becomes inactive, so it does nothing but periodically checks
+ * the watermarks.  50 (5%) by default.
+ */
+static unsigned long wmarks_low __read_mostly = 50;
+module_param(wmarks_low, ulong, 0600);
+
+/*
+ * Sampling interval for the monitoring in microseconds.
+ *
+ * The sampling interval of DAMON for the hot/cold memory monitoring.  Please
+ * refer to the DAMON documentation for more detail.  5 ms by default.
+ */
+static unsigned long sample_interval __read_mostly = 5000;
+module_param(sample_interval, ulong, 0600);
+
+/*
+ * Aggregation interval for the monitoring in microseconds.
+ *
+ * The aggregation interval of DAMON for the hot/cold memory monitoring.
+ * Please refer to the DAMON documentation for more detail.  100 ms by default.
+ */
+static unsigned long aggr_interval __read_mostly = 100000;
+module_param(aggr_interval, ulong, 0600);
+
+/*
+ * Minimum number of monitoring regions.
+ *
+ * The minimal number of monitoring regions of DAMON for the hot/cold memory
+ * monitoring.  This can be used to set lower-bound of the monitoring quality.
+ * But, setting this too high could result in increased monitoring overhead.
+ * Please refer to the DAMON documentation for more detail.  10 by default.
+ */
+static unsigned long min_nr_regions __read_mostly = 10;
+module_param(min_nr_regions, ulong, 0600);
+
+/*
+ * Maximum number of monitoring regions.
+ *
+ * The maximum number of monitoring regions of DAMON for the hot/cold memory
+ * monitoring.  This can be used to set upper-bound of the monitoring overhead.
+ * However, setting this too low could result in bad monitoring quality.
+ * Please refer to the DAMON documentation for more detail.  1000 by default.
+ */
+static unsigned long max_nr_regions __read_mostly = 1000;
+module_param(max_nr_regions, ulong, 0600);
+
+/*
+ * Start of the target memory region in physical address.
+ *
+ * The start physical address of memory region that DAMON_LRU_SORT will do work
+ * against.  By default, biggest System RAM is used as the region.
+ */
+static unsigned long monitor_region_start __read_mostly;
+module_param(monitor_region_start, ulong, 0600);
+
+/*
+ * End of the target memory region in physical address.
+ *
+ * The end physical address of memory region that DAMON_LRU_SORT will do work
+ * against.  By default, biggest System RAM is used as the region.
+ */
+static unsigned long monitor_region_end __read_mostly;
+module_param(monitor_region_end, ulong, 0600);
+
+/*
+ * PID of the DAMON thread
+ *
+ * If DAMON_LRU_SORT is enabled, this becomes the PID of the worker thread.
+ * Else, -1.
+ */
+static int kdamond_pid __read_mostly = -1;
+module_param(kdamond_pid, int, 0400);
+
+/*
+ * Number of hot memory regions that tried to be LRU-sorted.
+ */
+static unsigned long nr_lru_sort_tried_hot_regions __read_mostly;
+module_param(nr_lru_sort_tried_hot_regions, ulong, 0400);
+
+/*
+ * Total bytes of hot memory regions that tried to be LRU-sorted.
+ */
+static unsigned long bytes_lru_sort_tried_hot_regions __read_mostly;
+module_param(bytes_lru_sort_tried_hot_regions, ulong, 0400);
+
+/*
+ * Number of hot memory regions that successfully be LRU-sorted.
+ */
+static unsigned long nr_lru_sorted_hot_regions __read_mostly;
+module_param(nr_lru_sorted_hot_regions, ulong, 0400);
+
+/*
+ * Total bytes of hot memory regions that successfully be LRU-sorted.
+ */
+static unsigned long bytes_lru_sorted_hot_regions __read_mostly;
+module_param(bytes_lru_sorted_hot_regions, ulong, 0400);
+
+/*
+ * Number of times that the time quota limit for hot regions have exceeded
+ */
+static unsigned long nr_hot_quota_exceeds __read_mostly;
+module_param(nr_hot_quota_exceeds, ulong, 0400);
+
+/*
+ * Number of cold memory regions that tried to be LRU-sorted.
+ */
+static unsigned long nr_lru_sort_tried_cold_regions __read_mostly;
+module_param(nr_lru_sort_tried_cold_regions, ulong, 0400);
+
+/*
+ * Total bytes of cold memory regions that tried to be LRU-sorted.
+ */
+static unsigned long bytes_lru_sort_tried_cold_regions __read_mostly;
+module_param(bytes_lru_sort_tried_cold_regions, ulong, 0400);
+
+/*
+ * Number of cold memory regions that successfully be LRU-sorted.
+ */
+static unsigned long nr_lru_sorted_cold_regions __read_mostly;
+module_param(nr_lru_sorted_cold_regions, ulong, 0400);
+
+/*
+ * Total bytes of cold memory regions that successfully be LRU-sorted.
+ */
+static unsigned long bytes_lru_sorted_cold_regions __read_mostly;
+module_param(bytes_lru_sorted_cold_regions, ulong, 0400);
+
+/*
+ * Number of times that the time quota limit for cold regions have exceeded
+ */
+static unsigned long nr_cold_quota_exceeds __read_mostly;
+module_param(nr_cold_quota_exceeds, ulong, 0400);
+
+static struct damon_ctx *ctx;
+static struct damon_target *target;
+
+struct damon_lru_sort_ram_walk_arg {
+	unsigned long start;
+	unsigned long end;
+};
+
+static int walk_system_ram(struct resource *res, void *arg)
+{
+	struct damon_lru_sort_ram_walk_arg *a = arg;
+
+	if (a->end - a->start < resource_size(res)) {
+		a->start = res->start;
+		a->end = res->end;
+	}
+	return 0;
+}
+
+/*
+ * Find biggest 'System RAM' resource and store its start and end address in
+ * @start and @end, respectively.  If no System RAM is found, returns false.
+ */
+static bool get_monitoring_region(unsigned long *start, unsigned long *end)
+{
+	struct damon_lru_sort_ram_walk_arg arg = {};
+
+	walk_system_ram_res(0, ULONG_MAX, &arg, walk_system_ram);
+	if (arg.end <= arg.start)
+		return false;
+
+	*start = arg.start;
+	*end = arg.end;
+	return true;
+}
+
+/* Create a DAMON-based operation scheme for hot memory regions */
+static struct damos *damon_lru_sort_new_hot_scheme(unsigned int hot_thres)
+{
+	struct damos_watermarks wmarks = {
+		.metric = DAMOS_WMARK_FREE_MEM_RATE,
+		.interval = wmarks_interval,
+		.high = wmarks_high,
+		.mid = wmarks_mid,
+		.low = wmarks_low,
+	};
+	struct damos_quota quota = {
+		/*
+		 * Do not try LRU-lists sorting of hot pages for more than half
+		 * of quota_ms milliseconds within quota_reset_interval_ms.
+		 */
+		.ms = quota_ms / 2,
+		.sz = 0,
+		.reset_interval = quota_reset_interval_ms,
+		/* Within the quota, mark hotter regions accessed first. */
+		.weight_sz = 0,
+		.weight_nr_accesses = 1,
+		.weight_age = 0,
+	};
+	struct damos *scheme = damon_new_scheme(
+			/* Find regions having PAGE_SIZE or larger size */
+			PAGE_SIZE, ULONG_MAX,
+			/* and accessed for more than the threshold */
+			hot_thres, UINT_MAX,
+			/* no matter its age */
+			0, UINT_MAX,
+			/* prioritize those on LRU lists, as soon as found */
+			DAMOS_LRU_PRIO,
+			/* under the quota. */
+			&quota,
+			/* (De)activate this according to the watermarks. */
+			&wmarks);
+
+	return scheme;
+}
+
+/* Create a DAMON-based operation scheme for cold memory regions */
+static struct damos *damon_lru_sort_new_cold_scheme(unsigned int cold_thres)
+{
+	struct damos_watermarks wmarks = {
+		.metric = DAMOS_WMARK_FREE_MEM_RATE,
+		.interval = wmarks_interval,
+		.high = wmarks_high,
+		.mid = wmarks_mid,
+		.low = wmarks_low,
+	};
+	struct damos_quota quota = {
+		/*
+		 * Do not try LRU-lists sorting of cold pages for more than
+		 * half of quota_ms milliseconds within
+		 * quota_reset_interval_ms.
+		 */
+		.ms = quota_ms / 2,
+		.sz = 0,
+		.reset_interval = quota_reset_interval_ms,
+		/* Within the quota, mark colder regions not accessed first. */
+		.weight_sz = 0,
+		.weight_nr_accesses = 0,
+		.weight_age = 1,
+	};
+	struct damos *scheme = damon_new_scheme(
+			/* Find regions having PAGE_SIZE or larger size */
+			PAGE_SIZE, ULONG_MAX,
+			/* and not accessed at all */
+			0, 0,
+			/* for cold_thres or more micro-seconds, and */
+			cold_thres, UINT_MAX,
+			/* mark those as not accessed, as soon as found */
+			DAMOS_LRU_DEPRIO,
+			/* under the quota. */
+			&quota,
+			/* (De)activate this according to the watermarks. */
+			&wmarks);
+
+	return scheme;
+}
+
+static int damon_lru_sort_apply_parameters(void)
+{
+	struct damos *scheme, *next_scheme;
+	struct damon_addr_range addr_range;
+	unsigned int hot_thres, cold_thres;
+	int err = 0;
+
+	err = damon_set_attrs(ctx, sample_interval, aggr_interval, 0,
+			min_nr_regions, max_nr_regions);
+	if (err)
+		return err;
+
+	/* free previously set schemes */
+	damon_for_each_scheme_safe(scheme, next_scheme, ctx)
+		damon_destroy_scheme(scheme);
+
+	/* aggr_interval / sample_interval is the maximum nr_accesses */
+	hot_thres = aggr_interval / sample_interval * hot_thres_access_freq /
+		1000;
+	scheme = damon_lru_sort_new_hot_scheme(hot_thres);
+	if (!scheme)
+		return -ENOMEM;
+	damon_add_scheme(ctx, scheme);
+
+	cold_thres = cold_min_age / aggr_interval;
+	scheme = damon_lru_sort_new_cold_scheme(cold_thres);
+	if (!scheme)
+		return -ENOMEM;
+	damon_add_scheme(ctx, scheme);
+
+	if (monitor_region_start > monitor_region_end)
+		return -EINVAL;
+	if (!monitor_region_start && !monitor_region_end &&
+			!get_monitoring_region(&monitor_region_start,
+				&monitor_region_end))
+		return -EINVAL;
+	addr_range.start = monitor_region_start;
+	addr_range.end = monitor_region_end;
+	return damon_set_regions(target, &addr_range, 1);
+}
+
+static int damon_lru_sort_turn(bool on)
+{
+	int err;
+
+	if (!on) {
+		err = damon_stop(&ctx, 1);
+		if (!err)
+			kdamond_pid = -1;
+		return err;
+	}
+
+	err = damon_lru_sort_apply_parameters();
+	if (err)
+		return err;
+
+	err = damon_start(&ctx, 1, true);
+	if (err)
+		return err;
+	kdamond_pid = ctx->kdamond->pid;
+	return 0;
+}
+
+static struct delayed_work damon_lru_sort_timer;
+static void damon_lru_sort_timer_fn(struct work_struct *work)
+{
+	static bool last_enabled;
+	bool now_enabled;
+
+	now_enabled = enabled;
+	if (last_enabled != now_enabled) {
+		if (!damon_lru_sort_turn(now_enabled))
+			last_enabled = now_enabled;
+		else
+			enabled = last_enabled;
+	}
+}
+static DECLARE_DELAYED_WORK(damon_lru_sort_timer, damon_lru_sort_timer_fn);
+
+static bool damon_lru_sort_initialized;
+
+static int damon_lru_sort_enabled_store(const char *val,
+		const struct kernel_param *kp)
+{
+	int rc = param_set_bool(val, kp);
+
+	if (rc < 0)
+		return rc;
+
+	if (!damon_lru_sort_initialized)
+		return rc;
+
+	schedule_delayed_work(&damon_lru_sort_timer, 0);
+
+	return 0;
+}
+
+static const struct kernel_param_ops enabled_param_ops = {
+	.set = damon_lru_sort_enabled_store,
+	.get = param_get_bool,
+};
+
+module_param_cb(enabled, &enabled_param_ops, &enabled, 0600);
+MODULE_PARM_DESC(enabled,
+	"Enable or disable DAMON_LRU_SORT (default: disabled)");
+
+static int damon_lru_sort_handle_commit_inputs(void)
+{
+	int err;
+
+	if (!commit_inputs)
+		return 0;
+
+	err = damon_lru_sort_apply_parameters();
+	commit_inputs = false;
+	return err;
+}
+
+static int damon_lru_sort_after_aggregation(struct damon_ctx *c)
+{
+	struct damos *s;
+
+	/* update the stats parameter */
+	damon_for_each_scheme(s, c) {
+		if (s->action == DAMOS_LRU_PRIO) {
+			nr_lru_sort_tried_hot_regions = s->stat.nr_tried;
+			bytes_lru_sort_tried_hot_regions = s->stat.sz_tried;
+			nr_lru_sorted_hot_regions = s->stat.nr_applied;
+			bytes_lru_sorted_hot_regions = s->stat.sz_applied;
+			nr_hot_quota_exceeds = s->stat.qt_exceeds;
+		} else if (s->action == DAMOS_LRU_DEPRIO) {
+			nr_lru_sort_tried_cold_regions = s->stat.nr_tried;
+			bytes_lru_sort_tried_cold_regions = s->stat.sz_tried;
+			nr_lru_sorted_cold_regions = s->stat.nr_applied;
+			bytes_lru_sorted_cold_regions = s->stat.sz_applied;
+			nr_cold_quota_exceeds = s->stat.qt_exceeds;
+		}
+	}
+
+	return damon_lru_sort_handle_commit_inputs();
+}
+
+static int damon_lru_sort_after_wmarks_check(struct damon_ctx *c)
+{
+	return damon_lru_sort_handle_commit_inputs();
+}
+
+static int __init damon_lru_sort_init(void)
+{
+	ctx = damon_new_ctx();
+	if (!ctx)
+		return -ENOMEM;
+
+	if (damon_select_ops(ctx, DAMON_OPS_PADDR))
+		return -EINVAL;
+
+	ctx->callback.after_wmarks_check = damon_lru_sort_after_wmarks_check;
+	ctx->callback.after_aggregation = damon_lru_sort_after_aggregation;
+
+	target = damon_new_target();
+	if (!target) {
+		damon_destroy_ctx(ctx);
+		return -ENOMEM;
+	}
+	damon_add_target(ctx, target);
+
+	schedule_delayed_work(&damon_lru_sort_timer, 0);
+
+	damon_lru_sort_initialized = true;
+	return 0;
+}
+
+module_init(damon_lru_sort_init);
--- a/mm/damon/Makefile~mm-damon-introduce-damon-based-lru-lists-sorting
+++ a/mm/damon/Makefile
@@ -6,3 +6,4 @@ obj-$(CONFIG_DAMON_PADDR)	+= ops-common.
 obj-$(CONFIG_DAMON_SYSFS)	+= sysfs.o
 obj-$(CONFIG_DAMON_DBGFS)	+= dbgfs.o
 obj-$(CONFIG_DAMON_RECLAIM)	+= reclaim.o
+obj-$(CONFIG_DAMON_LRU_SORT)	+= lru_sort.o
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-reclaim-schedule-damon_reclaim_timer-only-after-system_wq-is-initialized.patch
docs-admin-guide-damon-reclaim-remove-a-paragraph-that-been-obsolete-due-to-online-tuning-support.patch
mm-damon-dbgfssysfs-move-target_has_pid-from-dbgfs-to-damonh.patch
mm-damon-reclaim-deduplicate-commit_inputs-handling.patch
mm-damon-sysfs-deduplicate-inputs-applying.patch
mm-damon-reclaim-make-enabled-checking-timer-simpler.patch
mm-damon-reclaim-add-damon_reclaim_-prefix-to-enabled_store.patch
mm-damon-dbgfs-add-and-use-mappings-between-schemes-action-inputs-and-damos_action-values.patch
mm-damon-paddr-use-a-separate-function-for-damos_pageout-handling.patch
mm-damon-schemes-add-lru_prio-damos-action.patch
docs-admin-guide-damon-sysfs-document-lru_prio-scheme-action.patch
mm-damon-schemes-add-lru_deprio-action.patch
docs-admin-guide-damon-sysfs-document-lru_deprio-scheme-action.patch
mm-damon-introduce-damon-based-lru-lists-sorting.patch
docs-admin-guide-damon-add-a-document-for-damon_lru_sort.patch

