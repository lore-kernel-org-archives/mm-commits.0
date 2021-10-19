Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ACE1C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 19 Oct 2021 21:32:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 072696134F
	for <mm-commits@archiver.kernel.org>; Tue, 19 Oct 2021 21:32:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbhJSVe1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Oct 2021 17:34:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:40574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229670AbhJSVeY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 19 Oct 2021 17:34:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 24CAC608FE;
        Tue, 19 Oct 2021 21:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634679130;
        bh=aUr0dq8EpIc7CdaCjVo1chzU2LPj0dnwa0XgsKYGn9A=;
        h=Date:From:To:Subject:From;
        b=ped+CNdi2DF2Wziuvpwn2AQPLE8wNym8DnY1+suPajCvCL+AA6i/E/Xs1N/j0b5c6
         kf8IMZ654dLqbb3dxOATh1Fqb+LYOJe1FYPlA/hPSg2rngXY2InH/yXArvV2+UpKXr
         NKtiAdxPmXzPddZJ3zdtAORo2MIgdqjxY2iUTBsw=
Date:   Tue, 19 Oct 2021 14:32:09 -0700
From:   akpm@linux-foundation.org
To:     amit@kernel.org, benh@kernel.crashing.org, corbet@lwn.net,
        david@redhat.com, dwmw@amazon.com, elver@google.com,
        foersleo@amazon.de, gthelen@google.com,
        Jonathan.Cameron@huawei.com, markubo@amazon.de,
        mm-commits@vger.kernel.org, rientjes@google.com,
        shakeelb@google.com, shuah@kernel.org, sj@kernel.org
Subject:  +
 mm-damon-schemes-activate-schemes-based-on-a-watermarks-mechanism.patch
 added to -mm tree
Message-ID: <20211019213209.rDZOBsA8Y%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/schemes: activate schemes based on a watermarks mechanism
has been added to the -mm tree.  Its filename is
     mm-damon-schemes-activate-schemes-based-on-a-watermarks-mechanism.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-schemes-activate-schemes-based-on-a-watermarks-mechanism.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-schemes-activate-schemes-based-on-a-watermarks-mechanism.patch

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
Subject: mm/damon/schemes: activate schemes based on a watermarks mechanism

DAMON-based operation schemes need to be manually turned on and off.  In
some use cases, however, the condition for turning a scheme on and off
would depend on the system's situation.  For example, schemes for
proactive pages reclamation would need to be turned on when some memory
pressure is detected, and turned off when the system has enough free
memory.

For easier control of schemes activation based on the system situation,
this commit introduces a watermarks-based mechanism.  The client can
describe the watermark metric (e.g., amount of free memory in the system),
watermark check interval, and three watermarks, namely high, mid, and low.
If the scheme is deactivated, it only gets the metric and compare that to
the three watermarks for every check interval.  If the metric is higher
than the high watermark, the scheme is deactivated.  If the metric is
between the mid watermark and the low watermark, the scheme is activated. 
If the metric is lower than the low watermark, the scheme is deactivated
again.  This is to allow users fall back to traditional page-granularity
mechanisms.

Link: https://lkml.kernel.org/r/20211019150731.16699-12-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Amit Shah <amit@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: David Woodhouse <dwmw@amazon.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Leonard Foerster <foersleo@amazon.de>
Cc: Marco Elver <elver@google.com>
Cc: Markus Boehme <markubo@amazon.de>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |   52 +++++++++++++++++++++
 mm/damon/core.c       |   97 +++++++++++++++++++++++++++++++++++++++-
 mm/damon/dbgfs.c      |    5 +-
 3 files changed, 151 insertions(+), 3 deletions(-)

--- a/include/linux/damon.h~mm-damon-schemes-activate-schemes-based-on-a-watermarks-mechanism
+++ a/include/linux/damon.h
@@ -147,6 +147,45 @@ struct damos_quota {
 };
 
 /**
+ * enum damos_wmark_metric - Represents the watermark metric.
+ *
+ * @DAMOS_WMARK_NONE:		Ignore the watermarks of the given scheme.
+ * @DAMOS_WMARK_FREE_MEM_RATE:	Free memory rate of the system in [0,1000].
+ */
+enum damos_wmark_metric {
+	DAMOS_WMARK_NONE,
+	DAMOS_WMARK_FREE_MEM_RATE,
+};
+
+/**
+ * struct damos_watermarks - Controls when a given scheme should be activated.
+ * @metric:	Metric for the watermarks.
+ * @interval:	Watermarks check time interval in microseconds.
+ * @high:	High watermark.
+ * @mid:	Middle watermark.
+ * @low:	Low watermark.
+ *
+ * If &metric is &DAMOS_WMARK_NONE, the scheme is always active.  Being active
+ * means DAMON does monitoring and applying the action of the scheme to
+ * appropriate memory regions.  Else, DAMON checks &metric of the system for at
+ * least every &interval microseconds and works as below.
+ *
+ * If &metric is higher than &high, the scheme is inactivated.  If &metric is
+ * between &mid and &low, the scheme is activated.  If &metric is lower than
+ * &low, the scheme is inactivated.
+ */
+struct damos_watermarks {
+	enum damos_wmark_metric metric;
+	unsigned long interval;
+	unsigned long high;
+	unsigned long mid;
+	unsigned long low;
+
+/* private: */
+	bool activated;
+};
+
+/**
  * struct damos - Represents a Data Access Monitoring-based Operation Scheme.
  * @min_sz_region:	Minimum size of target regions.
  * @max_sz_region:	Maximum size of target regions.
@@ -156,6 +195,7 @@ struct damos_quota {
  * @max_age_region:	Maximum age of target regions.
  * @action:		&damo_action to be applied to the target regions.
  * @quota:		Control the aggressiveness of this scheme.
+ * @wmarks:		Watermarks for automated (in)activation of this scheme.
  * @stat_count:		Total number of regions that this scheme is applied.
  * @stat_sz:		Total size of regions that this scheme is applied.
  * @list:		List head for siblings.
@@ -166,6 +206,14 @@ struct damos_quota {
  * those.  To avoid consuming too much CPU time or IO resources for the
  * &action, &quota is used.
  *
+ * To do the work only when needed, schemes can be activated for specific
+ * system situations using &wmarks.  If all schemes that registered to the
+ * monitoring context are inactive, DAMON stops monitoring either, and just
+ * repeatedly checks the watermarks.
+ *
+ * If all schemes that registered to a &struct damon_ctx are inactive, DAMON
+ * stops monitoring and just repeatedly checks the watermarks.
+ *
  * After applying the &action to each region, &stat_count and &stat_sz is
  * updated to reflect the number of regions and total size of regions that the
  * &action is applied.
@@ -179,6 +227,7 @@ struct damos {
 	unsigned int max_age_region;
 	enum damos_action action;
 	struct damos_quota quota;
+	struct damos_watermarks wmarks;
 	unsigned long stat_count;
 	unsigned long stat_sz;
 	struct list_head list;
@@ -384,7 +433,8 @@ struct damos *damon_new_scheme(
 		unsigned long min_sz_region, unsigned long max_sz_region,
 		unsigned int min_nr_accesses, unsigned int max_nr_accesses,
 		unsigned int min_age_region, unsigned int max_age_region,
-		enum damos_action action, struct damos_quota *quota);
+		enum damos_action action, struct damos_quota *quota,
+		struct damos_watermarks *wmarks);
 void damon_add_scheme(struct damon_ctx *ctx, struct damos *s);
 void damon_destroy_scheme(struct damos *s);
 
--- a/mm/damon/core.c~mm-damon-schemes-activate-schemes-based-on-a-watermarks-mechanism
+++ a/mm/damon/core.c
@@ -10,6 +10,7 @@
 #include <linux/damon.h>
 #include <linux/delay.h>
 #include <linux/kthread.h>
+#include <linux/mm.h>
 #include <linux/random.h>
 #include <linux/slab.h>
 #include <linux/string.h>
@@ -90,7 +91,8 @@ struct damos *damon_new_scheme(
 		unsigned long min_sz_region, unsigned long max_sz_region,
 		unsigned int min_nr_accesses, unsigned int max_nr_accesses,
 		unsigned int min_age_region, unsigned int max_age_region,
-		enum damos_action action, struct damos_quota *quota)
+		enum damos_action action, struct damos_quota *quota,
+		struct damos_watermarks *wmarks)
 {
 	struct damos *scheme;
 
@@ -122,6 +124,13 @@ struct damos *damon_new_scheme(
 	scheme->quota.charge_target_from = NULL;
 	scheme->quota.charge_addr_from = 0;
 
+	scheme->wmarks.metric = wmarks->metric;
+	scheme->wmarks.interval = wmarks->interval;
+	scheme->wmarks.high = wmarks->high;
+	scheme->wmarks.mid = wmarks->mid;
+	scheme->wmarks.low = wmarks->low;
+	scheme->wmarks.activated = true;
+
 	return scheme;
 }
 
@@ -582,6 +591,9 @@ static void damon_do_apply_schemes(struc
 		unsigned long sz = r->ar.end - r->ar.start;
 		struct timespec64 begin, end;
 
+		if (!s->wmarks.activated)
+			continue;
+
 		/* Check the quota */
 		if (quota->esz && quota->charged_sz >= quota->esz)
 			continue;
@@ -684,6 +696,9 @@ static void kdamond_apply_schemes(struct
 		unsigned long cumulated_sz;
 		unsigned int score, max_score = 0;
 
+		if (!s->wmarks.activated)
+			continue;
+
 		if (!quota->ms && !quota->sz)
 			continue;
 
@@ -924,6 +939,83 @@ static bool kdamond_need_stop(struct dam
 	return true;
 }
 
+static unsigned long damos_wmark_metric_value(enum damos_wmark_metric metric)
+{
+	struct sysinfo i;
+
+	switch (metric) {
+	case DAMOS_WMARK_FREE_MEM_RATE:
+		si_meminfo(&i);
+		return i.freeram * 1000 / i.totalram;
+	default:
+		break;
+	}
+	return -EINVAL;
+}
+
+/*
+ * Returns zero if the scheme is active.  Else, returns time to wait for next
+ * watermark check in micro-seconds.
+ */
+static unsigned long damos_wmark_wait_us(struct damos *scheme)
+{
+	unsigned long metric;
+
+	if (scheme->wmarks.metric == DAMOS_WMARK_NONE)
+		return 0;
+
+	metric = damos_wmark_metric_value(scheme->wmarks.metric);
+	/* higher than high watermark or lower than low watermark */
+	if (metric > scheme->wmarks.high || scheme->wmarks.low > metric) {
+		if (scheme->wmarks.activated)
+			pr_debug("inactivate a scheme (%d) for %s wmark\n",
+					scheme->action,
+					metric > scheme->wmarks.high ?
+					"high" : "low");
+		scheme->wmarks.activated = false;
+		return scheme->wmarks.interval;
+	}
+
+	/* inactive and higher than middle watermark */
+	if ((scheme->wmarks.high >= metric && metric >= scheme->wmarks.mid) &&
+			!scheme->wmarks.activated)
+		return scheme->wmarks.interval;
+
+	if (!scheme->wmarks.activated)
+		pr_debug("activate a scheme (%d)\n", scheme->action);
+	scheme->wmarks.activated = true;
+	return 0;
+}
+
+static void kdamond_usleep(unsigned long usecs)
+{
+	if (usecs > 100 * 1000)
+		schedule_timeout_interruptible(usecs_to_jiffies(usecs));
+	else
+		usleep_range(usecs, usecs + 1);
+}
+
+/* Returns negative error code if it's not activated but should return */
+static int kdamond_wait_activation(struct damon_ctx *ctx)
+{
+	struct damos *s;
+	unsigned long wait_time;
+	unsigned long min_wait_time = 0;
+
+	while (!kdamond_need_stop(ctx)) {
+		damon_for_each_scheme(s, ctx) {
+			wait_time = damos_wmark_wait_us(s);
+			if (!min_wait_time || wait_time < min_wait_time)
+				min_wait_time = wait_time;
+		}
+		if (!min_wait_time)
+			return 0;
+
+		kdamond_usleep(min_wait_time);
+	}
+	return -EBUSY;
+}
+
 static void set_kdamond_stop(struct damon_ctx *ctx)
 {
 	mutex_lock(&ctx->kdamond_lock);
@@ -952,6 +1044,9 @@ static int kdamond_fn(void *data)
 	sz_limit = damon_region_sz_limit(ctx);
 
 	while (!kdamond_need_stop(ctx)) {
+		if (kdamond_wait_activation(ctx))
+			continue;
+
 		if (ctx->primitive.prepare_access_checks)
 			ctx->primitive.prepare_access_checks(ctx);
 		if (ctx->callback.after_sampling &&
--- a/mm/damon/dbgfs.c~mm-damon-schemes-activate-schemes-based-on-a-watermarks-mechanism
+++ a/mm/damon/dbgfs.c
@@ -195,6 +195,9 @@ static struct damos **str_to_schemes(con
 	*nr_schemes = 0;
 	while (pos < len && *nr_schemes < max_nr_schemes) {
 		struct damos_quota quota = {};
+		struct damos_watermarks wmarks = {
+			.metric = DAMOS_WMARK_NONE,
+		};
 
 		ret = sscanf(&str[pos],
 				"%lu %lu %u %u %u %u %u %lu %lu %lu %u %u %u%n",
@@ -212,7 +215,7 @@ static struct damos **str_to_schemes(con
 
 		pos += parsed;
 		scheme = damon_new_scheme(min_sz, max_sz, min_nr_a, max_nr_a,
-				min_age, max_age, action, &quota);
+				min_age, max_age, action, &quota, &wmarks);
 		if (!scheme)
 			goto fail;
 
_

Patches currently in -mm which might be from sj@kernel.org are

maintainers-update-seongjaes-email-address.patch
mm-damon-core-print-kdamond-start-log-in-debug-mode-only.patch
mm-damon-core-account-age-of-target-regions.patch
mm-damon-core-implement-damon-based-operation-schemes-damos.patch
mm-damon-vaddr-support-damon-based-operation-schemes.patch
mm-damon-dbgfs-support-damon-based-operation-schemes.patch
mm-damon-schemes-implement-statistics-feature.patch
selftests-damon-add-schemes-debugfs-tests.patch
docs-admin-guide-mm-damon-document-damon-based-operation-schemes.patch
mm-damon-dbgfs-allow-users-to-set-initial-monitoring-target-regions.patch
mm-damon-dbgfs-test-add-a-unit-test-case-for-init_regions.patch
docs-admin-guide-mm-damon-document-init_regions-feature.patch
mm-damon-vaddr-separate-commonly-usable-functions.patch
mm-damon-vaddr-separate-commonly-usable-functions-fix.patch
mm-damon-implement-primitives-for-physical-address-space-monitoring.patch
mm-damon-dbgfs-support-physical-memory-monitoring.patch
docs-damon-document-physical-memory-monitoring-support.patch
mm-damon-paddr-support-the-pageout-scheme.patch
mm-damon-schemes-implement-size-quota-for-schemes-application-speed-control.patch
mm-damon-schemes-skip-already-charged-targets-and-regions.patch
mm-damon-schemes-implement-time-quota.patch
mm-damon-dbgfs-support-quotas-of-schemes.patch
mm-damon-selftests-support-schemes-quotas.patch
mm-damon-schemes-prioritize-regions-within-the-quotas.patch
mm-damon-vaddrpaddr-support-pageout-prioritization.patch
mm-damon-dbgfs-support-prioritization-weights.patch
tools-selftests-damon-update-for-regions-prioritization-of-schemes.patch
mm-damon-schemes-activate-schemes-based-on-a-watermarks-mechanism.patch
mm-damon-dbgfs-support-watermarks.patch
selftests-damon-support-watermarks.patch
mm-damon-introduce-damon-based-reclamation-damon_reclaim.patch
documentation-admin-guide-mm-damon-add-a-document-for-damon_reclaim.patch

