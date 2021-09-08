Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E865C433FE
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:56:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3926561153
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:56:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347049AbhIHC5n (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 22:57:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:54620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347442AbhIHC5l (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 22:57:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F7D261131;
        Wed,  8 Sep 2021 02:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631069794;
        bh=3lXrYTXmm+ZouijOQP8TQD1hebYHYJ6IT4wAQ1cf8Jo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=SQCA1bOEIy2shVyGpO8EqqLZt6nDfwiUY9Ozi4XT2jYMAaQxMOGYmxbWT/Jnyc5vV
         f+40jBqBri8GpnwkgJQOJzyCp5H5UBaiidduuuUC67QSjtzj8N3OrUMsirLjfyi8dd
         8Ak7ZEIx6wIRANr/gDoZmfsZKuRjTcQcLBldXgfc=
Date:   Tue, 07 Sep 2021 19:56:32 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alexander.shishkin@linux.intel.com,
        amit@kernel.org, benh@kernel.crashing.org,
        brendanhiggins@google.com, corbet@lwn.net, david@redhat.com,
        dwmw@amazon.com, elver@google.com, fan.du@intel.com,
        foersleo@amazon.de, greg@kroah.com, gthelen@google.com,
        joe@perches.com, Jonathan.Cameron@huawei.com, linux-mm@kvack.org,
        markubo@amazon.de, mgorman@suse.de, mheyne@amazon.de,
        minchan@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org,
        namhyung@kernel.org, peterz@infradead.org, riel@surriel.com,
        rientjes@google.com, rostedt@goodmis.org, shakeelb@google.com,
        shuah@kernel.org, sieberf@amazon.com, sjpark@amazon.de,
        torvalds@linux-foundation.org, vbabka@suse.cz,
        vdavydov.dev@gmail.com
Subject:  [patch 064/147] mm/damon/core: implement region-based
 sampling
Message-ID: <20210908025632.BLOJIz5mr%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: SeongJae Park <sjpark@amazon.de>
Subject: mm/damon/core: implement region-based sampling

To avoid the unbounded increase of the overhead, DAMON groups adjacent
pages that are assumed to have the same access frequencies into a
region.  As long as the assumption (pages in a region have the same
access frequencies) is kept, only one page in the region is required to
be checked.  Thus, for each ``sampling interval``,

 1. the 'prepare_access_checks' primitive picks one page in each region,
 2. waits for one ``sampling interval``,
 3. checks whether the page is accessed meanwhile, and
 4. increases the access count of the region if so.

Therefore, the monitoring overhead is controllable by adjusting the
number of regions.  DAMON allows both the underlying primitives and user
callbacks to adjust regions for the trade-off.  In other words, this
commit makes DAMON to use not only time-based sampling but also
space-based sampling.

This scheme, however, cannot preserve the quality of the output if the
assumption is not guaranteed.  Next commit will address this problem.

Link: https://lkml.kernel.org/r/20210716081449.22187-3-sj38.park@gmail.com
Signed-off-by: SeongJae Park <sjpark@amazon.de>
Reviewed-by: Leonard Foerster <foersleo@amazon.de>
Reviewed-by: Fernand Sieber <sieberf@amazon.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Amit Shah <amit@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: David Woodhouse <dwmw@amazon.com>
Cc: Fan Du <fan.du@intel.com>
Cc: Greg Kroah-Hartman <greg@kroah.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joe Perches <joe@perches.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Marco Elver <elver@google.com>
Cc: Markus Boehme <markubo@amazon.de>
Cc: Maximilian Heyne <mheyne@amazon.de>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |   77 ++++++++++++++++++++-
 mm/damon/core.c       |  143 ++++++++++++++++++++++++++++++++++++++--
 2 files changed, 213 insertions(+), 7 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-implement-region-based-sampling
+++ a/include/linux/damon.h
@@ -12,6 +12,48 @@
 #include <linux/time64.h>
 #include <linux/types.h>
 
+/**
+ * struct damon_addr_range - Represents an address region of [@start, @end).
+ * @start:	Start address of the region (inclusive).
+ * @end:	End address of the region (exclusive).
+ */
+struct damon_addr_range {
+	unsigned long start;
+	unsigned long end;
+};
+
+/**
+ * struct damon_region - Represents a monitoring target region.
+ * @ar:			The address range of the region.
+ * @sampling_addr:	Address of the sample for the next access check.
+ * @nr_accesses:	Access frequency of this region.
+ * @list:		List head for siblings.
+ */
+struct damon_region {
+	struct damon_addr_range ar;
+	unsigned long sampling_addr;
+	unsigned int nr_accesses;
+	struct list_head list;
+};
+
+/**
+ * struct damon_target - Represents a monitoring target.
+ * @id:			Unique identifier for this target.
+ * @regions_list:	Head of the monitoring target regions of this target.
+ * @list:		List head for siblings.
+ *
+ * Each monitoring context could have multiple targets.  For example, a context
+ * for virtual memory address spaces could have multiple target processes.  The
+ * @id of each target should be unique among the targets of the context.  For
+ * example, in the virtual address monitoring context, it could be a pidfd or
+ * an address of an mm_struct.
+ */
+struct damon_target {
+	unsigned long id;
+	struct list_head regions_list;
+	struct list_head list;
+};
+
 struct damon_ctx;
 
 /**
@@ -36,7 +78,7 @@ struct damon_ctx;
  *
  * @init should initialize primitive-internal data structures.  For example,
  * this could be used to construct proper monitoring target regions and link
- * those to @damon_ctx.target.
+ * those to @damon_ctx.adaptive_targets.
  * @update should update the primitive-internal data structures.  For example,
  * this could be used to update monitoring target regions for current status.
  * @prepare_access_checks should manipulate the monitoring regions to be
@@ -130,7 +172,7 @@ struct damon_callback {
  * @primitive:	Set of monitoring primitives for given use cases.
  * @callback:	Set of callbacks for monitoring events notifications.
  *
- * @target:	Pointer to the user-defined monitoring target.
+ * @region_targets:	Head of monitoring targets (&damon_target) list.
  */
 struct damon_ctx {
 	unsigned long sample_interval;
@@ -149,11 +191,40 @@ struct damon_ctx {
 	struct damon_primitive primitive;
 	struct damon_callback callback;
 
-	void *target;
+	struct list_head region_targets;
 };
 
+#define damon_next_region(r) \
+	(container_of(r->list.next, struct damon_region, list))
+
+#define damon_prev_region(r) \
+	(container_of(r->list.prev, struct damon_region, list))
+
+#define damon_for_each_region(r, t) \
+	list_for_each_entry(r, &t->regions_list, list)
+
+#define damon_for_each_region_safe(r, next, t) \
+	list_for_each_entry_safe(r, next, &t->regions_list, list)
+
+#define damon_for_each_target(t, ctx) \
+	list_for_each_entry(t, &(ctx)->region_targets, list)
+
+#define damon_for_each_target_safe(t, next, ctx)	\
+	list_for_each_entry_safe(t, next, &(ctx)->region_targets, list)
+
 #ifdef CONFIG_DAMON
 
+struct damon_region *damon_new_region(unsigned long start, unsigned long end);
+inline void damon_insert_region(struct damon_region *r,
+		struct damon_region *prev, struct damon_region *next);
+void damon_add_region(struct damon_region *r, struct damon_target *t);
+void damon_destroy_region(struct damon_region *r);
+
+struct damon_target *damon_new_target(unsigned long id);
+void damon_add_target(struct damon_ctx *ctx, struct damon_target *t);
+void damon_free_target(struct damon_target *t);
+void damon_destroy_target(struct damon_target *t);
+
 struct damon_ctx *damon_new_ctx(void);
 void damon_destroy_ctx(struct damon_ctx *ctx);
 int damon_set_attrs(struct damon_ctx *ctx, unsigned long sample_int,
--- a/mm/damon/core.c~mm-damon-core-implement-region-based-sampling
+++ a/mm/damon/core.c
@@ -15,6 +15,101 @@
 static DEFINE_MUTEX(damon_lock);
 static int nr_running_ctxs;
 
+/*
+ * Construct a damon_region struct
+ *
+ * Returns the pointer to the new struct if success, or NULL otherwise
+ */
+struct damon_region *damon_new_region(unsigned long start, unsigned long end)
+{
+	struct damon_region *region;
+
+	region = kmalloc(sizeof(*region), GFP_KERNEL);
+	if (!region)
+		return NULL;
+
+	region->ar.start = start;
+	region->ar.end = end;
+	region->nr_accesses = 0;
+	INIT_LIST_HEAD(&region->list);
+
+	return region;
+}
+
+/*
+ * Add a region between two other regions
+ */
+inline void damon_insert_region(struct damon_region *r,
+		struct damon_region *prev, struct damon_region *next)
+{
+	__list_add(&r->list, &prev->list, &next->list);
+}
+
+void damon_add_region(struct damon_region *r, struct damon_target *t)
+{
+	list_add_tail(&r->list, &t->regions_list);
+}
+
+static void damon_del_region(struct damon_region *r)
+{
+	list_del(&r->list);
+}
+
+static void damon_free_region(struct damon_region *r)
+{
+	kfree(r);
+}
+
+void damon_destroy_region(struct damon_region *r)
+{
+	damon_del_region(r);
+	damon_free_region(r);
+}
+
+/*
+ * Construct a damon_target struct
+ *
+ * Returns the pointer to the new struct if success, or NULL otherwise
+ */
+struct damon_target *damon_new_target(unsigned long id)
+{
+	struct damon_target *t;
+
+	t = kmalloc(sizeof(*t), GFP_KERNEL);
+	if (!t)
+		return NULL;
+
+	t->id = id;
+	INIT_LIST_HEAD(&t->regions_list);
+
+	return t;
+}
+
+void damon_add_target(struct damon_ctx *ctx, struct damon_target *t)
+{
+	list_add_tail(&t->list, &ctx->region_targets);
+}
+
+static void damon_del_target(struct damon_target *t)
+{
+	list_del(&t->list);
+}
+
+void damon_free_target(struct damon_target *t)
+{
+	struct damon_region *r, *next;
+
+	damon_for_each_region_safe(r, next, t)
+		damon_free_region(r);
+	kfree(t);
+}
+
+void damon_destroy_target(struct damon_target *t)
+{
+	damon_del_target(t);
+	damon_free_target(t);
+}
+
 struct damon_ctx *damon_new_ctx(void)
 {
 	struct damon_ctx *ctx;
@@ -32,15 +127,27 @@ struct damon_ctx *damon_new_ctx(void)
 
 	mutex_init(&ctx->kdamond_lock);
 
-	ctx->target = NULL;
+	INIT_LIST_HEAD(&ctx->region_targets);
 
 	return ctx;
 }
 
-void damon_destroy_ctx(struct damon_ctx *ctx)
+static void damon_destroy_targets(struct damon_ctx *ctx)
 {
-	if (ctx->primitive.cleanup)
+	struct damon_target *t, *next_t;
+
+	if (ctx->primitive.cleanup) {
 		ctx->primitive.cleanup(ctx);
+		return;
+	}
+
+	damon_for_each_target_safe(t, next_t, ctx)
+		damon_destroy_target(t);
+}
+
+void damon_destroy_ctx(struct damon_ctx *ctx)
+{
+	damon_destroy_targets(ctx);
 	kfree(ctx);
 }
 
@@ -218,6 +325,21 @@ static bool kdamond_aggregate_interval_p
 }
 
 /*
+ * Reset the aggregated monitoring results ('nr_accesses' of each region).
+ */
+static void kdamond_reset_aggregated(struct damon_ctx *c)
+{
+	struct damon_target *t;
+
+	damon_for_each_target(t, c) {
+		struct damon_region *r;
+
+		damon_for_each_region(r, t)
+			r->nr_accesses = 0;
+	}
+}
+
+/*
  * Check whether it is time to check and apply the target monitoring regions
  *
  * Returns true if it is.
@@ -238,6 +360,7 @@ static bool kdamond_need_update_primitiv
  */
 static bool kdamond_need_stop(struct damon_ctx *ctx)
 {
+	struct damon_target *t;
 	bool stop;
 
 	mutex_lock(&ctx->kdamond_lock);
@@ -249,7 +372,12 @@ static bool kdamond_need_stop(struct dam
 	if (!ctx->primitive.target_valid)
 		return false;
 
-	return !ctx->primitive.target_valid(ctx->target);
+	damon_for_each_target(t, ctx) {
+		if (ctx->primitive.target_valid(t))
+			return false;
+	}
+
+	return true;
 }
 
 static void set_kdamond_stop(struct damon_ctx *ctx)
@@ -265,6 +393,8 @@ static void set_kdamond_stop(struct damo
 static int kdamond_fn(void *data)
 {
 	struct damon_ctx *ctx = (struct damon_ctx *)data;
+	struct damon_target *t;
+	struct damon_region *r, *next;
 
 	mutex_lock(&ctx->kdamond_lock);
 	pr_info("kdamond (%d) starts\n", ctx->kdamond->pid);
@@ -291,6 +421,7 @@ static int kdamond_fn(void *data)
 			if (ctx->callback.after_aggregation &&
 					ctx->callback.after_aggregation(ctx))
 				set_kdamond_stop(ctx);
+			kdamond_reset_aggregated(ctx);
 			if (ctx->primitive.reset_aggregated)
 				ctx->primitive.reset_aggregated(ctx);
 		}
@@ -300,6 +431,10 @@ static int kdamond_fn(void *data)
 				ctx->primitive.update(ctx);
 		}
 	}
+	damon_for_each_target(t, ctx) {
+		damon_for_each_region_safe(r, next, t)
+			damon_destroy_region(r);
+	}
 
 	if (ctx->callback.before_terminate &&
 			ctx->callback.before_terminate(ctx))
_
