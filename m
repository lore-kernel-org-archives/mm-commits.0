Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AF5CC43217
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:49:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236828AbiCVVu2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236791AbiCVVuZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:50:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C0DD2DD64
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:48:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 90806615BD
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:48:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6952C340EE;
        Tue, 22 Mar 2022 21:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985727;
        bh=9AMztZDwYA/GPqgogGvDHmHxliV1tL6fZ+OLkXmJ4RY=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=TezCyqTgkCzfZqPByCFbQbDnTjMZ0kaI66h1dQgLaa6DCo1nbt94nS4EK96MD65Zd
         PqOmyk8xk2x9YURmyU4lvX7bhvde7Q+h43bjKysf/Z4lBV5ZvQJ++6onYPbfxYku9q
         bVHO+F6IIGZch9ePItaEjJcrQpH02iVLZvVtKV2w=
Date:   Tue, 22 Mar 2022 14:48:46 -0700
To:     xhao@linux.alibaba.com, rientjes@google.com, sj@kernel.org,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 202/227] mm/damon: rename damon_primitives to damon_operations
Message-Id: <20220322214846.D6952C340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: SeongJae Park <sj@kernel.org>
Subject: mm/damon: rename damon_primitives to damon_operations

Patch series "Allow DAMON user code independent of monitoring primitives".

In-kernel DAMON user code is required to configure the monitoring context
(struct damon_ctx) with proper monitoring primitives (struct
damon_primitive).  This makes the user code dependent to all supporting
monitoring primitives.  For example, DAMON debugfs interface depends on
both DAMON_VADDR and DAMON_PADDR, though some users have interest in only
one use case.  As more monitoring primitives are introduced, the problem
will be bigger.

To minimize such unnecessary dependency, this patchset makes monitoring
primitives can be registered by the implemnting code and later dynamically
searched and selected by the user code.

In addition to that, this patchset renames monitoring primitives to
monitoring operations, which is more easy to intuitively understand what
it means and how it would be structed.


This patch (of 8):

DAMON has a set of callback functions called monitoring primitives and let
it can be configured with various implementations for easy extension for
different address spaces and usages.  However, the word 'primitive' is not
so explicit.  Meanwhile, many other structs resembles similar purpose
calls themselves 'operations'.  To make the code easier to be understood,
this commit renames 'damon_primitives' to 'damon_operations' before it is
too late to rename.

Link: https://lkml.kernel.org/r/20220215184603.1479-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20220215184603.1479-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Xin Hao <xhao@linux.alibaba.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h   |   48 ++++++-------
 mm/damon/Kconfig        |   12 +--
 mm/damon/Makefile       |    4 -
 mm/damon/core.c         |   65 +++++++++---------
 mm/damon/dbgfs-test.h   |    2 
 mm/damon/dbgfs.c        |   10 +-
 mm/damon/{prmtv-common.c => ops-common.c} |  2 +-
 mm/damon/{prmtv-common.h => ops-common.h} |  0
 mm/damon/paddr.c        |   22 +++---
 mm/damon/reclaim.c      |    2 
 mm/damon/vaddr-test.h   |    2 
 mm/damon/vaddr.c        |   22 +++---
 14 files changed, 244 insertions(+), 243 deletions(-)

--- a/include/linux/damon.h~mm-damon-rename-damon_primitives-to-damon_operations
+++ a/include/linux/damon.h
@@ -67,8 +67,8 @@ struct damon_region {
  *
  * Each monitoring context could have multiple targets.  For example, a context
  * for virtual memory address spaces could have multiple target processes.  The
- * @pid should be set for appropriate address space monitoring primitives
- * including the virtual address spaces monitoring primitives.
+ * @pid should be set for appropriate &struct damon_operations including the
+ * virtual address spaces monitoring operations.
  */
 struct damon_target {
 	struct pid *pid;
@@ -120,9 +120,9 @@ enum damos_action {
  * uses smaller one as the effective quota.
  *
  * For selecting regions within the quota, DAMON prioritizes current scheme's
- * target memory regions using the &struct damon_primitive->get_scheme_score.
+ * target memory regions using the &struct damon_operations->get_scheme_score.
  * You could customize the prioritization logic by setting &weight_sz,
- * &weight_nr_accesses, and &weight_age, because monitoring primitives are
+ * &weight_nr_accesses, and &weight_age, because monitoring operations are
  * encouraged to respect those.
  */
 struct damos_quota {
@@ -256,10 +256,10 @@ struct damos {
 struct damon_ctx;
 
 /**
- * struct damon_primitive - Monitoring primitives for given use cases.
+ * struct damon_operations - Monitoring operations for given use cases.
  *
- * @init:			Initialize primitive-internal data structures.
- * @update:			Update primitive-internal data structures.
+ * @init:			Initialize operations-related data structures.
+ * @update:			Update operations-related data structures.
  * @prepare_access_checks:	Prepare next access check of target regions.
  * @check_accesses:		Check the accesses to target regions.
  * @reset_aggregated:		Reset aggregated accesses monitoring results.
@@ -269,18 +269,18 @@ struct damon_ctx;
  * @cleanup:			Clean up the context.
  *
  * DAMON can be extended for various address spaces and usages.  For this,
- * users should register the low level primitives for their target address
- * space and usecase via the &damon_ctx.primitive.  Then, the monitoring thread
+ * users should register the low level operations for their target address
+ * space and usecase via the &damon_ctx.ops.  Then, the monitoring thread
  * (&damon_ctx.kdamond) calls @init and @prepare_access_checks before starting
- * the monitoring, @update after each &damon_ctx.primitive_update_interval, and
+ * the monitoring, @update after each &damon_ctx.ops_update_interval, and
  * @check_accesses, @target_valid and @prepare_access_checks after each
  * &damon_ctx.sample_interval.  Finally, @reset_aggregated is called after each
  * &damon_ctx.aggr_interval.
  *
- * @init should initialize primitive-internal data structures.  For example,
+ * @init should initialize operations-related data structures.  For example,
  * this could be used to construct proper monitoring target regions and link
  * those to @damon_ctx.adaptive_targets.
- * @update should update the primitive-internal data structures.  For example,
+ * @update should update the operations-related data structures.  For example,
  * this could be used to update monitoring target regions for current status.
  * @prepare_access_checks should manipulate the monitoring regions to be
  * prepared for the next access check.
@@ -300,7 +300,7 @@ struct damon_ctx;
  * monitoring.
  * @cleanup is called from @kdamond just before its termination.
  */
-struct damon_primitive {
+struct damon_operations {
 	void (*init)(struct damon_ctx *context);
 	void (*update)(struct damon_ctx *context);
 	void (*prepare_access_checks)(struct damon_ctx *context);
@@ -354,15 +354,15 @@ struct damon_callback {
  *
  * @sample_interval:		The time between access samplings.
  * @aggr_interval:		The time between monitor results aggregations.
- * @primitive_update_interval:	The time between monitoring primitive updates.
+ * @ops_update_interval:	The time between monitoring operations updates.
  *
  * For each @sample_interval, DAMON checks whether each region is accessed or
  * not.  It aggregates and keeps the access information (number of accesses to
  * each region) for @aggr_interval time.  DAMON also checks whether the target
  * memory regions need update (e.g., by ``mmap()`` calls from the application,
  * in case of virtual memory monitoring) and applies the changes for each
- * @primitive_update_interval.  All time intervals are in micro-seconds.
- * Please refer to &struct damon_primitive and &struct damon_callback for more
+ * @ops_update_interval.  All time intervals are in micro-seconds.
+ * Please refer to &struct damon_operations and &struct damon_callback for more
  * detail.
  *
  * @kdamond:		Kernel thread who does the monitoring.
@@ -374,7 +374,7 @@ struct damon_callback {
  *
  * Once started, the monitoring thread runs until explicitly required to be
  * terminated or every monitoring target is invalid.  The validity of the
- * targets is checked via the &damon_primitive.target_valid of @primitive.  The
+ * targets is checked via the &damon_operations.target_valid of @ops.  The
  * termination can also be explicitly requested by writing non-zero to
  * @kdamond_stop.  The thread sets @kdamond to NULL when it terminates.
  * Therefore, users can know whether the monitoring is ongoing or terminated by
@@ -384,7 +384,7 @@ struct damon_callback {
  * Note that the monitoring thread protects only @kdamond and @kdamond_stop via
  * @kdamond_lock.  Accesses to other fields must be protected by themselves.
  *
- * @primitive:	Set of monitoring primitives for given use cases.
+ * @ops:	Set of monitoring operations for given use cases.
  * @callback:	Set of callbacks for monitoring events notifications.
  *
  * @min_nr_regions:	The minimum number of adaptive monitoring regions.
@@ -395,17 +395,17 @@ struct damon_callback {
 struct damon_ctx {
 	unsigned long sample_interval;
 	unsigned long aggr_interval;
-	unsigned long primitive_update_interval;
+	unsigned long ops_update_interval;
 
 /* private: internal use only */
 	struct timespec64 last_aggregation;
-	struct timespec64 last_primitive_update;
+	struct timespec64 last_ops_update;
 
 /* public: */
 	struct task_struct *kdamond;
 	struct mutex kdamond_lock;
 
-	struct damon_primitive primitive;
+	struct damon_operations ops;
 	struct damon_callback callback;
 
 	unsigned long min_nr_regions;
@@ -484,7 +484,7 @@ unsigned int damon_nr_regions(struct dam
 struct damon_ctx *damon_new_ctx(void);
 void damon_destroy_ctx(struct damon_ctx *ctx);
 int damon_set_attrs(struct damon_ctx *ctx, unsigned long sample_int,
-		unsigned long aggr_int, unsigned long primitive_upd_int,
+		unsigned long aggr_int, unsigned long ops_upd_int,
 		unsigned long min_nr_reg, unsigned long max_nr_reg);
 int damon_set_schemes(struct damon_ctx *ctx,
 			struct damos **schemes, ssize_t nr_schemes);
@@ -497,12 +497,12 @@ int damon_stop(struct damon_ctx **ctxs,
 
 #ifdef CONFIG_DAMON_VADDR
 bool damon_va_target_valid(void *t);
-void damon_va_set_primitives(struct damon_ctx *ctx);
+void damon_va_set_operations(struct damon_ctx *ctx);
 #endif	/* CONFIG_DAMON_VADDR */
 
 #ifdef CONFIG_DAMON_PADDR
 bool damon_pa_target_valid(void *t);
-void damon_pa_set_primitives(struct damon_ctx *ctx);
+void damon_pa_set_operations(struct damon_ctx *ctx);
 #endif	/* CONFIG_DAMON_PADDR */
 
 #endif	/* _DAMON_H */
--- a/mm/damon/core.c~mm-damon-rename-damon_primitives-to-damon_operations
+++ a/mm/damon/core.c
@@ -204,10 +204,10 @@ struct damon_ctx *damon_new_ctx(void)
 
 	ctx->sample_interval = 5 * 1000;
 	ctx->aggr_interval = 100 * 1000;
-	ctx->primitive_update_interval = 60 * 1000 * 1000;
+	ctx->ops_update_interval = 60 * 1000 * 1000;
 
 	ktime_get_coarse_ts64(&ctx->last_aggregation);
-	ctx->last_primitive_update = ctx->last_aggregation;
+	ctx->last_ops_update = ctx->last_aggregation;
 
 	mutex_init(&ctx->kdamond_lock);
 
@@ -224,8 +224,8 @@ static void damon_destroy_targets(struct
 {
 	struct damon_target *t, *next_t;
 
-	if (ctx->primitive.cleanup) {
-		ctx->primitive.cleanup(ctx);
+	if (ctx->ops.cleanup) {
+		ctx->ops.cleanup(ctx);
 		return;
 	}
 
@@ -250,7 +250,7 @@ void damon_destroy_ctx(struct damon_ctx
  * @ctx:		monitoring context
  * @sample_int:		time interval between samplings
  * @aggr_int:		time interval between aggregations
- * @primitive_upd_int:	time interval between monitoring primitive updates
+ * @ops_upd_int:	time interval between monitoring operations updates
  * @min_nr_reg:		minimal number of regions
  * @max_nr_reg:		maximum number of regions
  *
@@ -260,7 +260,7 @@ void damon_destroy_ctx(struct damon_ctx
  * Return: 0 on success, negative error code otherwise.
  */
 int damon_set_attrs(struct damon_ctx *ctx, unsigned long sample_int,
-		    unsigned long aggr_int, unsigned long primitive_upd_int,
+		    unsigned long aggr_int, unsigned long ops_upd_int,
 		    unsigned long min_nr_reg, unsigned long max_nr_reg)
 {
 	if (min_nr_reg < 3)
@@ -270,7 +270,7 @@ int damon_set_attrs(struct damon_ctx *ct
 
 	ctx->sample_interval = sample_int;
 	ctx->aggr_interval = aggr_int;
-	ctx->primitive_update_interval = primitive_upd_int;
+	ctx->ops_update_interval = ops_upd_int;
 	ctx->min_nr_regions = min_nr_reg;
 	ctx->max_nr_regions = max_nr_reg;
 
@@ -516,10 +516,10 @@ static bool damos_valid_target(struct da
 {
 	bool ret = __damos_valid_target(r, s);
 
-	if (!ret || !s->quota.esz || !c->primitive.get_scheme_score)
+	if (!ret || !s->quota.esz || !c->ops.get_scheme_score)
 		return ret;
 
-	return c->primitive.get_scheme_score(c, t, r, s) >= s->quota.min_score;
+	return c->ops.get_scheme_score(c, t, r, s) >= s->quota.min_score;
 }
 
 static void damon_do_apply_schemes(struct damon_ctx *c,
@@ -576,7 +576,7 @@ static void damon_do_apply_schemes(struc
 			continue;
 
 		/* Apply the scheme */
-		if (c->primitive.apply_scheme) {
+		if (c->ops.apply_scheme) {
 			if (quota->esz &&
 					quota->charged_sz + sz > quota->esz) {
 				sz = ALIGN_DOWN(quota->esz - quota->charged_sz,
@@ -586,7 +586,7 @@ static void damon_do_apply_schemes(struc
 				damon_split_region_at(c, t, r, sz);
 			}
 			ktime_get_coarse_ts64(&begin);
-			sz_applied = c->primitive.apply_scheme(c, t, r, s);
+			sz_applied = c->ops.apply_scheme(c, t, r, s);
 			ktime_get_coarse_ts64(&end);
 			quota->total_charged_ns += timespec64_to_ns(&end) -
 				timespec64_to_ns(&begin);
@@ -660,7 +660,7 @@ static void kdamond_apply_schemes(struct
 			damos_set_effective_quota(quota);
 		}
 
-		if (!c->primitive.get_scheme_score)
+		if (!c->ops.get_scheme_score)
 			continue;
 
 		/* Fill up the score histogram */
@@ -669,7 +669,7 @@ static void kdamond_apply_schemes(struct
 			damon_for_each_region(r, t) {
 				if (!__damos_valid_target(r, s))
 					continue;
-				score = c->primitive.get_scheme_score(
+				score = c->ops.get_scheme_score(
 						c, t, r, s);
 				quota->histogram[score] +=
 					r->ar.end - r->ar.start;
@@ -848,14 +848,15 @@ static void kdamond_split_regions(struct
 }
 
 /*
- * Check whether it is time to check and apply the target monitoring regions
+ * Check whether it is time to check and apply the operations-related data
+ * structures.
  *
  * Returns true if it is.
  */
-static bool kdamond_need_update_primitive(struct damon_ctx *ctx)
+static bool kdamond_need_update_operations(struct damon_ctx *ctx)
 {
-	return damon_check_reset_time_interval(&ctx->last_primitive_update,
-			ctx->primitive_update_interval);
+	return damon_check_reset_time_interval(&ctx->last_ops_update,
+			ctx->ops_update_interval);
 }
 
 /*
@@ -873,11 +874,11 @@ static bool kdamond_need_stop(struct dam
 	if (kthread_should_stop())
 		return true;
 
-	if (!ctx->primitive.target_valid)
+	if (!ctx->ops.target_valid)
 		return false;
 
 	damon_for_each_target(t, ctx) {
-		if (ctx->primitive.target_valid(t))
+		if (ctx->ops.target_valid(t))
 			return false;
 	}
 
@@ -976,8 +977,8 @@ static int kdamond_fn(void *data)
 
 	pr_debug("kdamond (%d) starts\n", current->pid);
 
-	if (ctx->primitive.init)
-		ctx->primitive.init(ctx);
+	if (ctx->ops.init)
+		ctx->ops.init(ctx);
 	if (ctx->callback.before_start && ctx->callback.before_start(ctx))
 		done = true;
 
@@ -987,16 +988,16 @@ static int kdamond_fn(void *data)
 		if (kdamond_wait_activation(ctx))
 			continue;
 
-		if (ctx->primitive.prepare_access_checks)
-			ctx->primitive.prepare_access_checks(ctx);
+		if (ctx->ops.prepare_access_checks)
+			ctx->ops.prepare_access_checks(ctx);
 		if (ctx->callback.after_sampling &&
 				ctx->callback.after_sampling(ctx))
 			done = true;
 
 		kdamond_usleep(ctx->sample_interval);
 
-		if (ctx->primitive.check_accesses)
-			max_nr_accesses = ctx->primitive.check_accesses(ctx);
+		if (ctx->ops.check_accesses)
+			max_nr_accesses = ctx->ops.check_accesses(ctx);
 
 		if (kdamond_aggregate_interval_passed(ctx)) {
 			kdamond_merge_regions(ctx,
@@ -1008,13 +1009,13 @@ static int kdamond_fn(void *data)
 			kdamond_apply_schemes(ctx);
 			kdamond_reset_aggregated(ctx);
 			kdamond_split_regions(ctx);
-			if (ctx->primitive.reset_aggregated)
-				ctx->primitive.reset_aggregated(ctx);
+			if (ctx->ops.reset_aggregated)
+				ctx->ops.reset_aggregated(ctx);
 		}
 
-		if (kdamond_need_update_primitive(ctx)) {
-			if (ctx->primitive.update)
-				ctx->primitive.update(ctx);
+		if (kdamond_need_update_operations(ctx)) {
+			if (ctx->ops.update)
+				ctx->ops.update(ctx);
 			sz_limit = damon_region_sz_limit(ctx);
 		}
 	}
@@ -1025,8 +1026,8 @@ static int kdamond_fn(void *data)
 
 	if (ctx->callback.before_terminate)
 		ctx->callback.before_terminate(ctx);
-	if (ctx->primitive.cleanup)
-		ctx->primitive.cleanup(ctx);
+	if (ctx->ops.cleanup)
+		ctx->ops.cleanup(ctx);
 
 	pr_debug("kdamond (%d) finishes\n", current->pid);
 	mutex_lock(&ctx->kdamond_lock);
--- a/mm/damon/dbgfs.c~mm-damon-rename-damon_primitives-to-damon_operations
+++ a/mm/damon/dbgfs.c
@@ -56,7 +56,7 @@ static ssize_t dbgfs_attrs_read(struct f
 	mutex_lock(&ctx->kdamond_lock);
 	ret = scnprintf(kbuf, ARRAY_SIZE(kbuf), "%lu %lu %lu %lu %lu\n",
 			ctx->sample_interval, ctx->aggr_interval,
-			ctx->primitive_update_interval, ctx->min_nr_regions,
+			ctx->ops_update_interval, ctx->min_nr_regions,
 			ctx->max_nr_regions);
 	mutex_unlock(&ctx->kdamond_lock);
 
@@ -277,7 +277,7 @@ out:
 
 static inline bool target_has_pid(const struct damon_ctx *ctx)
 {
-	return ctx->primitive.target_valid == damon_va_target_valid;
+	return ctx->ops.target_valid == damon_va_target_valid;
 }
 
 static ssize_t sprint_target_ids(struct damon_ctx *ctx, char *buf, ssize_t len)
@@ -477,9 +477,9 @@ static ssize_t dbgfs_target_ids_write(st
 
 	/* Configure the context for the address space type */
 	if (id_is_pid)
-		damon_va_set_primitives(ctx);
+		damon_va_set_operations(ctx);
 	else
-		damon_pa_set_primitives(ctx);
+		damon_pa_set_operations(ctx);
 
 	ret = dbgfs_set_targets(ctx, nr_targets, target_pids);
 	if (!ret)
@@ -735,7 +735,7 @@ static struct damon_ctx *dbgfs_new_ctx(v
 	if (!ctx)
 		return NULL;
 
-	damon_va_set_primitives(ctx);
+	damon_va_set_operations(ctx);
 	ctx->callback.before_terminate = dbgfs_before_terminate;
 	return ctx;
 }
--- a/mm/damon/dbgfs-test.h~mm-damon-rename-damon_primitives-to-damon_operations
+++ a/mm/damon/dbgfs-test.h
@@ -74,7 +74,7 @@ static void damon_dbgfs_test_set_targets
 	char buf[64];
 
 	/* Make DAMON consider target has no pid */
-	ctx->primitive = (struct damon_primitive){};
+	ctx->ops = (struct damon_operations){};
 
 	dbgfs_set_targets(ctx, 0, NULL);
 	sprint_target_ids(ctx, buf, 64);
--- a/mm/damon/Kconfig~mm-damon-rename-damon_primitives-to-damon_operations
+++ a/mm/damon/Kconfig
@@ -25,27 +25,27 @@ config DAMON_KUNIT_TEST
 	  If unsure, say N.
 
 config DAMON_VADDR
-	bool "Data access monitoring primitives for virtual address spaces"
+	bool "Data access monitoring operations for virtual address spaces"
 	depends on DAMON && MMU
 	select PAGE_IDLE_FLAG
 	help
-	  This builds the default data access monitoring primitives for DAMON
+	  This builds the default data access monitoring operations for DAMON
 	  that work for virtual address spaces.
 
 config DAMON_PADDR
-	bool "Data access monitoring primitives for the physical address space"
+	bool "Data access monitoring operations for the physical address space"
 	depends on DAMON && MMU
 	select PAGE_IDLE_FLAG
 	help
-	  This builds the default data access monitoring primitives for DAMON
+	  This builds the default data access monitoring operations for DAMON
 	  that works for the physical address space.
 
 config DAMON_VADDR_KUNIT_TEST
-	bool "Test for DAMON primitives" if !KUNIT_ALL_TESTS
+	bool "Test for DAMON operations" if !KUNIT_ALL_TESTS
 	depends on DAMON_VADDR && KUNIT=y
 	default KUNIT_ALL_TESTS
 	help
-	  This builds the DAMON virtual addresses primitives Kunit test suite.
+	  This builds the DAMON virtual addresses operations Kunit test suite.
 
 	  For more information on KUnit and unit tests in general, please refer
 	  to the KUnit documentation.
--- a/mm/damon/Makefile~mm-damon-rename-damon_primitives-to-damon_operations
+++ a/mm/damon/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 
 obj-$(CONFIG_DAMON)		:= core.o
-obj-$(CONFIG_DAMON_VADDR)	+= prmtv-common.o vaddr.o
-obj-$(CONFIG_DAMON_PADDR)	+= prmtv-common.o paddr.o
+obj-$(CONFIG_DAMON_VADDR)	+= ops-common.o vaddr.o
+obj-$(CONFIG_DAMON_PADDR)	+= ops-common.o paddr.o
 obj-$(CONFIG_DAMON_DBGFS)	+= dbgfs.o
 obj-$(CONFIG_DAMON_RECLAIM)	+= reclaim.o
--- /dev/null
+++ a/mm/damon/ops-common.c
@@ -0,0 +1,133 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Common Primitives for Data Access Monitoring
+ *
+ * Author: SeongJae Park <sj@kernel.org>
+ */
+
+#include <linux/mmu_notifier.h>
+#include <linux/page_idle.h>
+#include <linux/pagemap.h>
+#include <linux/rmap.h>
+
+#include "ops-common.h"
+
+/*
+ * Get an online page for a pfn if it's in the LRU list.  Otherwise, returns
+ * NULL.
+ *
+ * The body of this function is stolen from the 'page_idle_get_page()'.  We
+ * steal rather than reuse it because the code is quite simple.
+ */
+struct page *damon_get_page(unsigned long pfn)
+{
+	struct page *page = pfn_to_online_page(pfn);
+
+	if (!page || !PageLRU(page) || !get_page_unless_zero(page))
+		return NULL;
+
+	if (unlikely(!PageLRU(page))) {
+		put_page(page);
+		page = NULL;
+	}
+	return page;
+}
+
+void damon_ptep_mkold(pte_t *pte, struct mm_struct *mm, unsigned long addr)
+{
+	bool referenced = false;
+	struct page *page = damon_get_page(pte_pfn(*pte));
+
+	if (!page)
+		return;
+
+	if (pte_young(*pte)) {
+		referenced = true;
+		*pte = pte_mkold(*pte);
+	}
+
+#ifdef CONFIG_MMU_NOTIFIER
+	if (mmu_notifier_clear_young(mm, addr, addr + PAGE_SIZE))
+		referenced = true;
+#endif /* CONFIG_MMU_NOTIFIER */
+
+	if (referenced)
+		set_page_young(page);
+
+	set_page_idle(page);
+	put_page(page);
+}
+
+void damon_pmdp_mkold(pmd_t *pmd, struct mm_struct *mm, unsigned long addr)
+{
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	bool referenced = false;
+	struct page *page = damon_get_page(pmd_pfn(*pmd));
+
+	if (!page)
+		return;
+
+	if (pmd_young(*pmd)) {
+		referenced = true;
+		*pmd = pmd_mkold(*pmd);
+	}
+
+#ifdef CONFIG_MMU_NOTIFIER
+	if (mmu_notifier_clear_young(mm, addr,
+				addr + ((1UL) << HPAGE_PMD_SHIFT)))
+		referenced = true;
+#endif /* CONFIG_MMU_NOTIFIER */
+
+	if (referenced)
+		set_page_young(page);
+
+	set_page_idle(page);
+	put_page(page);
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
+}
+
+#define DAMON_MAX_SUBSCORE	(100)
+#define DAMON_MAX_AGE_IN_LOG	(32)
+
+int damon_pageout_score(struct damon_ctx *c, struct damon_region *r,
+			struct damos *s)
+{
+	unsigned int max_nr_accesses;
+	int freq_subscore;
+	unsigned int age_in_sec;
+	int age_in_log, age_subscore;
+	unsigned int freq_weight = s->quota.weight_nr_accesses;
+	unsigned int age_weight = s->quota.weight_age;
+	int hotness;
+
+	max_nr_accesses = c->aggr_interval / c->sample_interval;
+	freq_subscore = r->nr_accesses * DAMON_MAX_SUBSCORE / max_nr_accesses;
+
+	age_in_sec = (unsigned long)r->age * c->aggr_interval / 1000000;
+	for (age_in_log = 0; age_in_log < DAMON_MAX_AGE_IN_LOG && age_in_sec;
+			age_in_log++, age_in_sec >>= 1)
+		;
+
+	/* If frequency is 0, higher age means it's colder */
+	if (freq_subscore == 0)
+		age_in_log *= -1;
+
+	/*
+	 * Now age_in_log is in [-DAMON_MAX_AGE_IN_LOG, DAMON_MAX_AGE_IN_LOG].
+	 * Scale it to be in [0, 100] and set it as age subscore.
+	 */
+	age_in_log += DAMON_MAX_AGE_IN_LOG;
+	age_subscore = age_in_log * DAMON_MAX_SUBSCORE /
+		DAMON_MAX_AGE_IN_LOG / 2;
+
+	hotness = (freq_weight * freq_subscore + age_weight * age_subscore);
+	if (freq_weight + age_weight)
+		hotness /= freq_weight + age_weight;
+	/*
+	 * Transform it to fit in [0, DAMOS_MAX_SCORE]
+	 */
+	hotness = hotness * DAMOS_MAX_SCORE / DAMON_MAX_SUBSCORE;
+
+	/* Return coldness of the region */
+	return DAMOS_MAX_SCORE - hotness;
+}
--- /dev/null
+++ a/mm/damon/ops-common.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Common Primitives for Data Access Monitoring
+ *
+ * Author: SeongJae Park <sj@kernel.org>
+ */
+
+#include <linux/damon.h>
+
+struct page *damon_get_page(unsigned long pfn);
+
+void damon_ptep_mkold(pte_t *pte, struct mm_struct *mm, unsigned long addr);
+void damon_pmdp_mkold(pmd_t *pmd, struct mm_struct *mm, unsigned long addr);
+
+int damon_pageout_score(struct damon_ctx *c, struct damon_region *r,
+			struct damos *s);
--- a/mm/damon/paddr.c~mm-damon-rename-damon_primitives-to-damon_operations
+++ a/mm/damon/paddr.c
@@ -14,7 +14,7 @@
 #include <linux/swap.h>
 
 #include "../internal.h"
-#include "prmtv-common.h"
+#include "ops-common.h"
 
 static bool __damon_pa_mkold(struct page *page, struct vm_area_struct *vma,
 		unsigned long addr, void *arg)
@@ -261,15 +261,15 @@ static int damon_pa_scheme_score(struct
 	return DAMOS_MAX_SCORE;
 }
 
-void damon_pa_set_primitives(struct damon_ctx *ctx)
+void damon_pa_set_operations(struct damon_ctx *ctx)
 {
-	ctx->primitive.init = NULL;
-	ctx->primitive.update = NULL;
-	ctx->primitive.prepare_access_checks = damon_pa_prepare_access_checks;
-	ctx->primitive.check_accesses = damon_pa_check_accesses;
-	ctx->primitive.reset_aggregated = NULL;
-	ctx->primitive.target_valid = damon_pa_target_valid;
-	ctx->primitive.cleanup = NULL;
-	ctx->primitive.apply_scheme = damon_pa_apply_scheme;
-	ctx->primitive.get_scheme_score = damon_pa_scheme_score;
+	ctx->ops.init = NULL;
+	ctx->ops.update = NULL;
+	ctx->ops.prepare_access_checks = damon_pa_prepare_access_checks;
+	ctx->ops.check_accesses = damon_pa_check_accesses;
+	ctx->ops.reset_aggregated = NULL;
+	ctx->ops.target_valid = damon_pa_target_valid;
+	ctx->ops.cleanup = NULL;
+	ctx->ops.apply_scheme = damon_pa_apply_scheme;
+	ctx->ops.get_scheme_score = damon_pa_scheme_score;
 }
--- a/mm/damon/prmtv-common.c
+++ /dev/null
@@ -1,133 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * Common Primitives for Data Access Monitoring
- *
- * Author: SeongJae Park <sj@kernel.org>
- */
-
-#include <linux/mmu_notifier.h>
-#include <linux/page_idle.h>
-#include <linux/pagemap.h>
-#include <linux/rmap.h>
-
-#include "prmtv-common.h"
-
-/*
- * Get an online page for a pfn if it's in the LRU list.  Otherwise, returns
- * NULL.
- *
- * The body of this function is stolen from the 'page_idle_get_page()'.  We
- * steal rather than reuse it because the code is quite simple.
- */
-struct page *damon_get_page(unsigned long pfn)
-{
-	struct page *page = pfn_to_online_page(pfn);
-
-	if (!page || !PageLRU(page) || !get_page_unless_zero(page))
-		return NULL;
-
-	if (unlikely(!PageLRU(page))) {
-		put_page(page);
-		page = NULL;
-	}
-	return page;
-}
-
-void damon_ptep_mkold(pte_t *pte, struct mm_struct *mm, unsigned long addr)
-{
-	bool referenced = false;
-	struct page *page = damon_get_page(pte_pfn(*pte));
-
-	if (!page)
-		return;
-
-	if (pte_young(*pte)) {
-		referenced = true;
-		*pte = pte_mkold(*pte);
-	}
-
-#ifdef CONFIG_MMU_NOTIFIER
-	if (mmu_notifier_clear_young(mm, addr, addr + PAGE_SIZE))
-		referenced = true;
-#endif /* CONFIG_MMU_NOTIFIER */
-
-	if (referenced)
-		set_page_young(page);
-
-	set_page_idle(page);
-	put_page(page);
-}
-
-void damon_pmdp_mkold(pmd_t *pmd, struct mm_struct *mm, unsigned long addr)
-{
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	bool referenced = false;
-	struct page *page = damon_get_page(pmd_pfn(*pmd));
-
-	if (!page)
-		return;
-
-	if (pmd_young(*pmd)) {
-		referenced = true;
-		*pmd = pmd_mkold(*pmd);
-	}
-
-#ifdef CONFIG_MMU_NOTIFIER
-	if (mmu_notifier_clear_young(mm, addr,
-				addr + ((1UL) << HPAGE_PMD_SHIFT)))
-		referenced = true;
-#endif /* CONFIG_MMU_NOTIFIER */
-
-	if (referenced)
-		set_page_young(page);
-
-	set_page_idle(page);
-	put_page(page);
-#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
-}
-
-#define DAMON_MAX_SUBSCORE	(100)
-#define DAMON_MAX_AGE_IN_LOG	(32)
-
-int damon_pageout_score(struct damon_ctx *c, struct damon_region *r,
-			struct damos *s)
-{
-	unsigned int max_nr_accesses;
-	int freq_subscore;
-	unsigned int age_in_sec;
-	int age_in_log, age_subscore;
-	unsigned int freq_weight = s->quota.weight_nr_accesses;
-	unsigned int age_weight = s->quota.weight_age;
-	int hotness;
-
-	max_nr_accesses = c->aggr_interval / c->sample_interval;
-	freq_subscore = r->nr_accesses * DAMON_MAX_SUBSCORE / max_nr_accesses;
-
-	age_in_sec = (unsigned long)r->age * c->aggr_interval / 1000000;
-	for (age_in_log = 0; age_in_log < DAMON_MAX_AGE_IN_LOG && age_in_sec;
-			age_in_log++, age_in_sec >>= 1)
-		;
-
-	/* If frequency is 0, higher age means it's colder */
-	if (freq_subscore == 0)
-		age_in_log *= -1;
-
-	/*
-	 * Now age_in_log is in [-DAMON_MAX_AGE_IN_LOG, DAMON_MAX_AGE_IN_LOG].
-	 * Scale it to be in [0, 100] and set it as age subscore.
-	 */
-	age_in_log += DAMON_MAX_AGE_IN_LOG;
-	age_subscore = age_in_log * DAMON_MAX_SUBSCORE /
-		DAMON_MAX_AGE_IN_LOG / 2;
-
-	hotness = (freq_weight * freq_subscore + age_weight * age_subscore);
-	if (freq_weight + age_weight)
-		hotness /= freq_weight + age_weight;
-	/*
-	 * Transform it to fit in [0, DAMOS_MAX_SCORE]
-	 */
-	hotness = hotness * DAMOS_MAX_SCORE / DAMON_MAX_SUBSCORE;
-
-	/* Return coldness of the region */
-	return DAMOS_MAX_SCORE - hotness;
-}
--- a/mm/damon/prmtv-common.h
+++ /dev/null
@@ -1,16 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/*
- * Common Primitives for Data Access Monitoring
- *
- * Author: SeongJae Park <sj@kernel.org>
- */
-
-#include <linux/damon.h>
-
-struct page *damon_get_page(unsigned long pfn);
-
-void damon_ptep_mkold(pte_t *pte, struct mm_struct *mm, unsigned long addr);
-void damon_pmdp_mkold(pmd_t *pmd, struct mm_struct *mm, unsigned long addr);
-
-int damon_pageout_score(struct damon_ctx *c, struct damon_region *r,
-			struct damos *s);
--- a/mm/damon/reclaim.c~mm-damon-rename-damon_primitives-to-damon_operations
+++ a/mm/damon/reclaim.c
@@ -384,7 +384,7 @@ static int __init damon_reclaim_init(voi
 	if (!ctx)
 		return -ENOMEM;
 
-	damon_pa_set_primitives(ctx);
+	damon_pa_set_operations(ctx);
 	ctx->callback.after_aggregation = damon_reclaim_after_aggregation;
 
 	target = damon_new_target();
--- a/mm/damon/vaddr.c~mm-damon-rename-damon_primitives-to-damon_operations
+++ a/mm/damon/vaddr.c
@@ -15,7 +15,7 @@
 #include <linux/pagewalk.h>
 #include <linux/sched/mm.h>
 
-#include "prmtv-common.h"
+#include "ops-common.h"
 
 #ifdef CONFIG_DAMON_VADDR_KUNIT_TEST
 #undef DAMON_MIN_REGION
@@ -739,17 +739,17 @@ static int damon_va_scheme_score(struct
 	return DAMOS_MAX_SCORE;
 }
 
-void damon_va_set_primitives(struct damon_ctx *ctx)
+void damon_va_set_operations(struct damon_ctx *ctx)
 {
-	ctx->primitive.init = damon_va_init;
-	ctx->primitive.update = damon_va_update;
-	ctx->primitive.prepare_access_checks = damon_va_prepare_access_checks;
-	ctx->primitive.check_accesses = damon_va_check_accesses;
-	ctx->primitive.reset_aggregated = NULL;
-	ctx->primitive.target_valid = damon_va_target_valid;
-	ctx->primitive.cleanup = NULL;
-	ctx->primitive.apply_scheme = damon_va_apply_scheme;
-	ctx->primitive.get_scheme_score = damon_va_scheme_score;
+	ctx->ops.init = damon_va_init;
+	ctx->ops.update = damon_va_update;
+	ctx->ops.prepare_access_checks = damon_va_prepare_access_checks;
+	ctx->ops.check_accesses = damon_va_check_accesses;
+	ctx->ops.reset_aggregated = NULL;
+	ctx->ops.target_valid = damon_va_target_valid;
+	ctx->ops.cleanup = NULL;
+	ctx->ops.apply_scheme = damon_va_apply_scheme;
+	ctx->ops.get_scheme_score = damon_va_scheme_score;
 }
 
 #include "vaddr-test.h"
--- a/mm/damon/vaddr-test.h~mm-damon-rename-damon_primitives-to-damon_operations
+++ a/mm/damon/vaddr-test.h
@@ -314,7 +314,7 @@ static struct kunit_case damon_test_case
 };
 
 static struct kunit_suite damon_test_suite = {
-	.name = "damon-primitives",
+	.name = "damon-operations",
 	.test_cases = damon_test_cases,
 };
 kunit_test_suite(damon_test_suite);
_
