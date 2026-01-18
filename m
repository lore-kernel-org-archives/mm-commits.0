Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82EE318DF80
	for <mm-commits@vger.kernel.org>; Sun, 18 Jan 2026 00:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768696797; cv=none; b=YHRIsxGufwIcfiO3bt26lxM3RAqw2uZDVWO7z3Wg4PdYpsWqXz4FJ28f380MrBcHZuAFczO4eP2g6iJg9oSbtLMvMx6rTuv+Xt7mV3VVNtuGKqm9KNyjPQKj/DLELnt9zuO0Cm4pKI8wBXteTz6fULtrtZ24Eh+sB5rfKveX9YQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768696797; c=relaxed/simple;
	bh=pikqB/LBFZEDcf7auxtfWTV5x5Gd/eaqSSSrRb/xMjU=;
	h=Date:To:From:Subject:Message-Id; b=p8NgAaNFFs8bHXc13yezwl2FKOgY/0muSihWo1xMJis823Sbz+bNn5CLCdwVTYNRVQAMQY9U5Pr/yd7dv78OKzf+gnZKfEfeDCEBKqp/z4snviMsBFFygKnwmDehGcDCp4TwWbyc7M3sJ5iDbrSnFDaKMMpX7Dh9MkGViOuf3qM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZkyaxL2P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZkyaxL2P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD64C4CEF7;
	Sun, 18 Jan 2026 00:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768696797;
	bh=pikqB/LBFZEDcf7auxtfWTV5x5Gd/eaqSSSrRb/xMjU=;
	h=Date:To:From:Subject:From;
	b=ZkyaxL2PvJfpmVZ1I98A1IvgJpcdrcfI+8EPR6ExJqwZxgqKGeylNE8V9qvAK9X4F
	 gE8H3Db2WetVn68Taz0bjPNEa0qAQ91Ak9UNe3tkJMxoXtnwE9EkvwUE70RpSsigIz
	 xP89jjtK1gSTBpN2PY57ZkKwrKIewRbYXgg84YvY=
Date: Sat, 17 Jan 2026 16:39:56 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-rename-min_sz_region-of-damon_ctx-to-min_region_sz.patch added to mm-new branch
Message-Id: <20260118003957.2AD64C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon: rename min_sz_region of damon_ctx to min_region_sz
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-rename-min_sz_region-of-damon_ctx-to-min_region_sz.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-rename-min_sz_region-of-damon_ctx-to-min_region_sz.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon: rename min_sz_region of damon_ctx to min_region_sz
Date: Sat, 17 Jan 2026 09:52:55 -0800

'min_sz_region' field of 'struct damon_ctx' represents the minimum size of
each DAMON region for the context.  'struct damos_access_pattern' has a
field of the same name.  It confuses readers and makes 'grep' less optimal
for them.  Rename it to 'min_region_sz'.

Link: https://lkml.kernel.org/r/20260117175256.82826-9-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    8 ++--
 mm/damon/core.c       |   69 ++++++++++++++++++++--------------------
 mm/damon/lru_sort.c   |    4 +-
 mm/damon/reclaim.c    |    4 +-
 mm/damon/stat.c       |    2 -
 mm/damon/sysfs.c      |    9 ++---
 6 files changed, 49 insertions(+), 47 deletions(-)

--- a/include/linux/damon.h~mm-damon-rename-min_sz_region-of-damon_ctx-to-min_region_sz
+++ a/include/linux/damon.h
@@ -773,7 +773,7 @@ struct damon_attrs {
  *
  * @ops:	Set of monitoring operations for given use cases.
  * @addr_unit:	Scale factor for core to ops address conversion.
- * @min_sz_region:		Minimum region size.
+ * @min_region_sz:	Minimum region size.
  * @adaptive_targets:	Head of monitoring targets (&damon_target) list.
  * @schemes:		Head of schemes (&damos) list.
  */
@@ -818,7 +818,7 @@ struct damon_ctx {
 /* public: */
 	struct damon_operations ops;
 	unsigned long addr_unit;
-	unsigned long min_sz_region;
+	unsigned long min_region_sz;
 
 	struct list_head adaptive_targets;
 	struct list_head schemes;
@@ -907,7 +907,7 @@ static inline void damon_insert_region(s
 void damon_add_region(struct damon_region *r, struct damon_target *t);
 void damon_destroy_region(struct damon_region *r, struct damon_target *t);
 int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
-		unsigned int nr_ranges, unsigned long min_sz_region);
+		unsigned int nr_ranges, unsigned long min_region_sz);
 void damon_update_region_access_rate(struct damon_region *r, bool accessed,
 		struct damon_attrs *attrs);
 
@@ -975,7 +975,7 @@ int damos_walk(struct damon_ctx *ctx, st
 
 int damon_set_region_biggest_system_ram_default(struct damon_target *t,
 				unsigned long *start, unsigned long *end,
-				unsigned long min_sz_region);
+				unsigned long min_region_sz);
 
 #endif	/* CONFIG_DAMON */
 
--- a/mm/damon/core.c~mm-damon-rename-min_sz_region-of-damon_ctx-to-min_region_sz
+++ a/mm/damon/core.c
@@ -203,7 +203,7 @@ static int damon_fill_regions_holes(stru
  * @t:		the given target.
  * @ranges:	array of new monitoring target ranges.
  * @nr_ranges:	length of @ranges.
- * @min_sz_region:	minimum region size.
+ * @min_region_sz:	minimum region size.
  *
  * This function adds new regions to, or modify existing regions of a
  * monitoring target to fit in specific ranges.
@@ -211,7 +211,7 @@ static int damon_fill_regions_holes(stru
  * Return: 0 if success, or negative error code otherwise.
  */
 int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
-		unsigned int nr_ranges, unsigned long min_sz_region)
+		unsigned int nr_ranges, unsigned long min_region_sz)
 {
 	struct damon_region *r, *next;
 	unsigned int i;
@@ -248,16 +248,16 @@ int damon_set_regions(struct damon_targe
 			/* no region intersects with this range */
 			newr = damon_new_region(
 					ALIGN_DOWN(range->start,
-						min_sz_region),
-					ALIGN(range->end, min_sz_region));
+						min_region_sz),
+					ALIGN(range->end, min_region_sz));
 			if (!newr)
 				return -ENOMEM;
 			damon_insert_region(newr, damon_prev_region(r), r, t);
 		} else {
 			/* resize intersecting regions to fit in this range */
 			first->ar.start = ALIGN_DOWN(range->start,
-					min_sz_region);
-			last->ar.end = ALIGN(range->end, min_sz_region);
+					min_region_sz);
+			last->ar.end = ALIGN(range->end, min_region_sz);
 
 			/* fill possible holes in the range */
 			err = damon_fill_regions_holes(first, last, t);
@@ -553,7 +553,7 @@ struct damon_ctx *damon_new_ctx(void)
 	ctx->attrs.max_nr_regions = 1000;
 
 	ctx->addr_unit = 1;
-	ctx->min_sz_region = DAMON_MIN_REGION_SZ;
+	ctx->min_region_sz = DAMON_MIN_REGION_SZ;
 
 	INIT_LIST_HEAD(&ctx->adaptive_targets);
 	INIT_LIST_HEAD(&ctx->schemes);
@@ -1142,7 +1142,7 @@ static struct damon_target *damon_nth_ta
  * If @src has no region, @dst keeps current regions.
  */
 static int damon_commit_target_regions(struct damon_target *dst,
-		struct damon_target *src, unsigned long src_min_sz_region)
+		struct damon_target *src, unsigned long src_min_region_sz)
 {
 	struct damon_region *src_region;
 	struct damon_addr_range *ranges;
@@ -1159,7 +1159,7 @@ static int damon_commit_target_regions(s
 	i = 0;
 	damon_for_each_region(src_region, src)
 		ranges[i++] = src_region->ar;
-	err = damon_set_regions(dst, ranges, i, src_min_sz_region);
+	err = damon_set_regions(dst, ranges, i, src_min_region_sz);
 	kfree(ranges);
 	return err;
 }
@@ -1167,11 +1167,11 @@ static int damon_commit_target_regions(s
 static int damon_commit_target(
 		struct damon_target *dst, bool dst_has_pid,
 		struct damon_target *src, bool src_has_pid,
-		unsigned long src_min_sz_region)
+		unsigned long src_min_region_sz)
 {
 	int err;
 
-	err = damon_commit_target_regions(dst, src, src_min_sz_region);
+	err = damon_commit_target_regions(dst, src, src_min_region_sz);
 	if (err)
 		return err;
 	if (dst_has_pid)
@@ -1198,7 +1198,7 @@ static int damon_commit_targets(
 			err = damon_commit_target(
 					dst_target, damon_target_has_pid(dst),
 					src_target, damon_target_has_pid(src),
-					src->min_sz_region);
+					src->min_region_sz);
 			if (err)
 				return err;
 		} else {
@@ -1225,7 +1225,7 @@ static int damon_commit_targets(
 			return -ENOMEM;
 		err = damon_commit_target(new_target, false,
 				src_target, damon_target_has_pid(src),
-				src->min_sz_region);
+				src->min_region_sz);
 		if (err) {
 			damon_destroy_target(new_target, NULL);
 			return err;
@@ -1272,7 +1272,7 @@ int damon_commit_ctx(struct damon_ctx *d
 	}
 	dst->ops = src->ops;
 	dst->addr_unit = src->addr_unit;
-	dst->min_sz_region = src->min_sz_region;
+	dst->min_region_sz = src->min_region_sz;
 
 	return 0;
 }
@@ -1305,8 +1305,8 @@ static unsigned long damon_region_sz_lim
 
 	if (ctx->attrs.min_nr_regions)
 		sz /= ctx->attrs.min_nr_regions;
-	if (sz < ctx->min_sz_region)
-		sz = ctx->min_sz_region;
+	if (sz < ctx->min_region_sz)
+		sz = ctx->min_region_sz;
 
 	return sz;
 }
@@ -1696,7 +1696,7 @@ static bool damos_valid_target(struct da
  * @t:	The target of the region.
  * @rp:	The pointer to the region.
  * @s:	The scheme to be applied.
- * @min_sz_region:	minimum region size.
+ * @min_region_sz:	minimum region size.
  *
  * If a quota of a scheme has exceeded in a quota charge window, the scheme's
  * action would applied to only a part of the target access pattern fulfilling
@@ -1714,7 +1714,8 @@ static bool damos_valid_target(struct da
  * Return: true if the region should be entirely skipped, false otherwise.
  */
 static bool damos_skip_charged_region(struct damon_target *t,
-		struct damon_region **rp, struct damos *s, unsigned long min_sz_region)
+		struct damon_region **rp, struct damos *s,
+		unsigned long min_region_sz)
 {
 	struct damon_region *r = *rp;
 	struct damos_quota *quota = &s->quota;
@@ -1736,11 +1737,11 @@ static bool damos_skip_charged_region(st
 		if (quota->charge_addr_from && r->ar.start <
 				quota->charge_addr_from) {
 			sz_to_skip = ALIGN_DOWN(quota->charge_addr_from -
-					r->ar.start, min_sz_region);
+					r->ar.start, min_region_sz);
 			if (!sz_to_skip) {
-				if (damon_sz_region(r) <= min_sz_region)
+				if (damon_sz_region(r) <= min_region_sz)
 					return true;
-				sz_to_skip = min_sz_region;
+				sz_to_skip = min_region_sz;
 			}
 			damon_split_region_at(t, r, sz_to_skip);
 			r = damon_next_region(r);
@@ -1766,7 +1767,7 @@ static void damos_update_stat(struct dam
 
 static bool damos_filter_match(struct damon_ctx *ctx, struct damon_target *t,
 		struct damon_region *r, struct damos_filter *filter,
-		unsigned long min_sz_region)
+		unsigned long min_region_sz)
 {
 	bool matched = false;
 	struct damon_target *ti;
@@ -1783,8 +1784,8 @@ static bool damos_filter_match(struct da
 		matched = target_idx == filter->target_idx;
 		break;
 	case DAMOS_FILTER_TYPE_ADDR:
-		start = ALIGN_DOWN(filter->addr_range.start, min_sz_region);
-		end = ALIGN_DOWN(filter->addr_range.end, min_sz_region);
+		start = ALIGN_DOWN(filter->addr_range.start, min_region_sz);
+		end = ALIGN_DOWN(filter->addr_range.end, min_region_sz);
 
 		/* inside the range */
 		if (start <= r->ar.start && r->ar.end <= end) {
@@ -1820,7 +1821,7 @@ static bool damos_core_filter_out(struct
 
 	s->core_filters_allowed = false;
 	damos_for_each_core_filter(filter, s) {
-		if (damos_filter_match(ctx, t, r, filter, ctx->min_sz_region)) {
+		if (damos_filter_match(ctx, t, r, filter, ctx->min_region_sz)) {
 			if (filter->allow)
 				s->core_filters_allowed = true;
 			return !filter->allow;
@@ -1955,7 +1956,7 @@ static void damos_apply_scheme(struct da
 	if (c->ops.apply_scheme) {
 		if (quota->esz && quota->charged_sz + sz > quota->esz) {
 			sz = ALIGN_DOWN(quota->esz - quota->charged_sz,
-					c->min_sz_region);
+					c->min_region_sz);
 			if (!sz)
 				goto update_stat;
 			damon_split_region_at(t, r, sz);
@@ -2003,7 +2004,7 @@ static void damon_do_apply_schemes(struc
 		if (quota->esz && quota->charged_sz >= quota->esz)
 			continue;
 
-		if (damos_skip_charged_region(t, &r, s, c->min_sz_region))
+		if (damos_skip_charged_region(t, &r, s, c->min_region_sz))
 			continue;
 
 		if (s->max_nr_snapshots &&
@@ -2496,7 +2497,7 @@ static void damon_split_region_at(struct
 
 /* Split every region in the given target into 'nr_subs' regions */
 static void damon_split_regions_of(struct damon_target *t, int nr_subs,
-				  unsigned long min_sz_region)
+				  unsigned long min_region_sz)
 {
 	struct damon_region *r, *next;
 	unsigned long sz_region, sz_sub = 0;
@@ -2506,13 +2507,13 @@ static void damon_split_regions_of(struc
 		sz_region = damon_sz_region(r);
 
 		for (i = 0; i < nr_subs - 1 &&
-				sz_region > 2 * min_sz_region; i++) {
+				sz_region > 2 * min_region_sz; i++) {
 			/*
 			 * Randomly select size of left sub-region to be at
 			 * least 10 percent and at most 90% of original region
 			 */
 			sz_sub = ALIGN_DOWN(damon_rand(1, 10) *
-					sz_region / 10, min_sz_region);
+					sz_region / 10, min_region_sz);
 			/* Do not allow blank region */
 			if (sz_sub == 0 || sz_sub >= sz_region)
 				continue;
@@ -2552,7 +2553,7 @@ static void kdamond_split_regions(struct
 		nr_subregions = 3;
 
 	damon_for_each_target(t, ctx)
-		damon_split_regions_of(t, nr_subregions, ctx->min_sz_region);
+		damon_split_regions_of(t, nr_subregions, ctx->min_region_sz);
 
 	last_nr_regions = nr_regions;
 }
@@ -2902,7 +2903,7 @@ static bool damon_find_biggest_system_ra
  * @t:		The monitoring target to set the region.
  * @start:	The pointer to the start address of the region.
  * @end:	The pointer to the end address of the region.
- * @min_sz_region:	Minimum region size.
+ * @min_region_sz:	Minimum region size.
  *
  * This function sets the region of @t as requested by @start and @end.  If the
  * values of @start and @end are zero, however, this function finds the biggest
@@ -2914,7 +2915,7 @@ static bool damon_find_biggest_system_ra
  */
 int damon_set_region_biggest_system_ram_default(struct damon_target *t,
 			unsigned long *start, unsigned long *end,
-			unsigned long min_sz_region)
+			unsigned long min_region_sz)
 {
 	struct damon_addr_range addr_range;
 
@@ -2927,7 +2928,7 @@ int damon_set_region_biggest_system_ram_
 
 	addr_range.start = *start;
 	addr_range.end = *end;
-	return damon_set_regions(t, &addr_range, 1, min_sz_region);
+	return damon_set_regions(t, &addr_range, 1, min_region_sz);
 }
 
 /*
--- a/mm/damon/lru_sort.c~mm-damon-rename-min_sz_region-of-damon_ctx-to-min_region_sz
+++ a/mm/damon/lru_sort.c
@@ -298,7 +298,7 @@ static int damon_lru_sort_apply_paramete
 	if (!monitor_region_start && !monitor_region_end)
 		addr_unit = 1;
 	param_ctx->addr_unit = addr_unit;
-	param_ctx->min_sz_region = max(DAMON_MIN_REGION_SZ / addr_unit, 1);
+	param_ctx->min_region_sz = max(DAMON_MIN_REGION_SZ / addr_unit, 1);
 
 	if (!damon_lru_sort_mon_attrs.sample_interval) {
 		err = -EINVAL;
@@ -345,7 +345,7 @@ static int damon_lru_sort_apply_paramete
 	err = damon_set_region_biggest_system_ram_default(param_target,
 					&monitor_region_start,
 					&monitor_region_end,
-					param_ctx->min_sz_region);
+					param_ctx->min_region_sz);
 	if (err)
 		goto out;
 	err = damon_commit_ctx(ctx, param_ctx);
--- a/mm/damon/reclaim.c~mm-damon-rename-min_sz_region-of-damon_ctx-to-min_region_sz
+++ a/mm/damon/reclaim.c
@@ -208,7 +208,7 @@ static int damon_reclaim_apply_parameter
 	if (!monitor_region_start && !monitor_region_end)
 		addr_unit = 1;
 	param_ctx->addr_unit = addr_unit;
-	param_ctx->min_sz_region = max(DAMON_MIN_REGION_SZ / addr_unit, 1);
+	param_ctx->min_region_sz = max(DAMON_MIN_REGION_SZ / addr_unit, 1);
 
 	if (!damon_reclaim_mon_attrs.aggr_interval) {
 		err = -EINVAL;
@@ -251,7 +251,7 @@ static int damon_reclaim_apply_parameter
 	err = damon_set_region_biggest_system_ram_default(param_target,
 					&monitor_region_start,
 					&monitor_region_end,
-					param_ctx->min_sz_region);
+					param_ctx->min_region_sz);
 	if (err)
 		goto out;
 	err = damon_commit_ctx(ctx, param_ctx);
--- a/mm/damon/stat.c~mm-damon-rename-min_sz_region-of-damon_ctx-to-min_region_sz
+++ a/mm/damon/stat.c
@@ -181,7 +181,7 @@ static struct damon_ctx *damon_stat_buil
 		goto free_out;
 	damon_add_target(ctx, target);
 	if (damon_set_region_biggest_system_ram_default(target, &start, &end,
-							ctx->min_sz_region))
+							ctx->min_region_sz))
 		goto free_out;
 	return ctx;
 free_out:
--- a/mm/damon/sysfs.c~mm-damon-rename-min_sz_region-of-damon_ctx-to-min_region_sz
+++ a/mm/damon/sysfs.c
@@ -1365,7 +1365,7 @@ static int damon_sysfs_set_attrs(struct
 
 static int damon_sysfs_set_regions(struct damon_target *t,
 		struct damon_sysfs_regions *sysfs_regions,
-		unsigned long min_sz_region)
+		unsigned long min_region_sz)
 {
 	struct damon_addr_range *ranges = kmalloc_array(sysfs_regions->nr,
 			sizeof(*ranges), GFP_KERNEL | __GFP_NOWARN);
@@ -1387,7 +1387,7 @@ static int damon_sysfs_set_regions(struc
 		if (ranges[i - 1].end > ranges[i].start)
 			goto out;
 	}
-	err = damon_set_regions(t, ranges, sysfs_regions->nr, min_sz_region);
+	err = damon_set_regions(t, ranges, sysfs_regions->nr, min_region_sz);
 out:
 	kfree(ranges);
 	return err;
@@ -1409,7 +1409,8 @@ static int damon_sysfs_add_target(struct
 			return -EINVAL;
 	}
 	t->obsolete = sys_target->obsolete;
-	return damon_sysfs_set_regions(t, sys_target->regions, ctx->min_sz_region);
+	return damon_sysfs_set_regions(t, sys_target->regions,
+			ctx->min_region_sz);
 }
 
 static int damon_sysfs_add_targets(struct damon_ctx *ctx,
@@ -1469,7 +1470,7 @@ static int damon_sysfs_apply_inputs(stru
 	ctx->addr_unit = sys_ctx->addr_unit;
 	/* addr_unit is respected by only DAMON_OPS_PADDR */
 	if (sys_ctx->ops_id == DAMON_OPS_PADDR)
-		ctx->min_sz_region = max(
+		ctx->min_region_sz = max(
 				DAMON_MIN_REGION_SZ / sys_ctx->addr_unit, 1);
 	err = damon_sysfs_set_attrs(ctx, sys_ctx->attrs);
 	if (err)
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-introduce-nr_snapshots-damos-stat.patch
mm-damon-core-introduce-nr_snapshots-damos-stat-fix.patch
mm-damon-sysfs-schemes-introduce-nr_snapshots-damos-stat-file.patch
docs-mm-damon-design-update-for-nr_snapshots-damos-stat.patch
docs-admin-guide-mm-damon-usage-update-for-nr_snapshots-damos-stat.patch
docs-abi-damon-update-for-nr_snapshots-damos-stat.patch
mm-damon-update-damos-kerneldoc-for-stat-field.patch
mm-damon-core-implement-max_nr_snapshots.patch
mm-damon-sysfs-schemes-implement-max_nr_snapshots-file.patch
docs-mm-damon-design-update-for-max_nr_snapshots.patch
docs-admin-guide-mm-damon-usage-update-for-max_nr_snapshots.patch
docs-abi-damon-update-for-max_nr_snapshots.patch
mm-damon-core-add-trace-point-for-damos-stat-per-apply-interval.patch
mm-damon-tests-core-kunit-add-test-cases-for-multiple-regions-in-damon_test_split_regions_of-fix.patch
mm-damon-core-introduce-active-memory-ratio-damos-quota-goal-metric.patch
mm-damon-sysfs-schemes-support-damos_quota_active_mem_bp.patch
docs-mm-damon-design-document-damos_quota_active_mem_bp.patch
mm-damon-paddr-activate-damos_lru_prio-targets-instead-of-marking-accessed.patch
mm-damon-lru_sort-consider-age-for-quota-prioritization.patch
mm-damon-lru_sort-support-young-page-filters.patch
docs-admin-guide-mm-damon-lru_sort-document-filter_young_pages.patch
mm-damon-lru_sort-support-active-inactive-memory-ratio-based-auto-tuning.patch
mm-damon-lru_sort-support-active-inactive-memory-ratio-based-auto-tuning-fix.patch
docs-admin-guide-mm-damon-lru_sort-document-active_mem_bp-parameter.patch
mm-damon-lru_sort-add-monitoring-intervals-auto-tuning-parameter.patch
docs-admin-guide-mm-damon-lru_sort-document-intervals-autotuning.patch
mm-damon-core-implement-damon_kdamond_pid.patch
mm-damon-sysfs-use-damon_kdamond_pid.patch
mm-damon-lru_sort-use-damon_kdamond_pid.patch
mm-damon-reclaim-use-damon_kdamond_pid.patch
mm-damon-hide-kdamond-and-kdamond_lock-of-damon_ctx.patch
mm-vma-temporary-build-fix.patch
selftests-damon-sysfs_memcg_path_leaksh-use-kmemleak.patch
selftests-damon-wss_estimation-test-for-up-to-160-mib-working-set-size.patch
selftests-damon-access_memory-add-repeat-mode.patch
selftests-damon-wss_estimation-ensure-number-of-collected-wss.patch
selftests-damon-wss_estimation-deduplicate-failed-samples-output.patch
mm-damon-remove-damon_operations-cleanup.patch
mm-damon-core-cleanup-targets-and-regions-at-once-on-kdamond-termination.patch
mm-damon-core-cancel-damos_walk-before-damon_ctx-kdamond-reset.patch
mm-damon-core-process-damon_call_control-requests-on-a-local-list.patch
mm-damon-document-damon_call_control-dealloc_on_cancel-repeat-behavior.patch
mm-damon-core-rename-damos_filter_out-to-damos_core_filter_out.patch
mm-damon-rename-damon_min_region-to-damon_min_region_sz.patch
mm-damon-rename-min_sz_region-of-damon_ctx-to-min_region_sz.patch

