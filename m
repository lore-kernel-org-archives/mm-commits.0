Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 908AD156F45
	for <mm-commits@vger.kernel.org>; Sat, 28 Feb 2026 23:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772319859; cv=none; b=HeBFXMx9/OeLimzcDzeNQIDS5+Rv1tqAM1ijpRU1sWaEQJ8ZMLG/zH6o/3rWDKKTVKwzjfG59xi0gIkg1Z126C7afCkGjiABkBUlUEVpSCpsKXLbGLM+bnDEPmtAkF2vZlblrqlTaET1YQqnMEO18wrqwtcSTRKKnI65ObASLps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772319859; c=relaxed/simple;
	bh=JmVRsN/lLzDa2JGKNw0l4HkGTRkPPVfaHuD9YDScjaI=;
	h=Date:To:From:Subject:Message-Id; b=caG8E+7uNIhPqjAS5hsY6NguVUDCKQ2OGQG6o7yD+WAzNXWFKloPDFXIXWlGCC5yFKQ6l1HwyAJvjhevQz5mIcIjUQyxI/sNOr7L4ICg0vIAXPMdyF9OQHTsKxowCfRZ0vlDe7aNCYrpYp+dD2EAXskCPU4lfGoJkuiai6QY3lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OSjIdMLZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OSjIdMLZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38D5BC116D0;
	Sat, 28 Feb 2026 23:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772319859;
	bh=JmVRsN/lLzDa2JGKNw0l4HkGTRkPPVfaHuD9YDScjaI=;
	h=Date:To:From:Subject:From;
	b=OSjIdMLZerSXNeL+RrAZztIhKV2RMLsAcwxw2dTe0zTeUjF8bAQoAqTpDty+JA9Ye
	 vjvDAHS4YP+OdyEYNVIpOq3izB31A2DFe79IWuRXPjwu95hdT1OntUNPJgDJu4VWkt
	 g5yfSEa5VvmQZnLeSC3KtJDbWVlXD1q7GGT7k5LQ=
Date: Sat, 28 Feb 2026 15:04:18 -0800
To: mm-commits@vger.kernel.org,davidgow@google.com,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-split-regions-for-min_nr_regions.patch added to mm-new branch
Message-Id: <20260228230419.38D5BC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: split regions for min_nr_regions
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-split-regions-for-min_nr_regions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-split-regions-for-min_nr_regions.patch

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
Subject: mm/damon/core: split regions for min_nr_regions
Date: Sat, 28 Feb 2026 14:28:25 -0800

Patch series "mm/damon: strictly respect min_nr_regions".

DAMON core respects min_nr_regions only at merge operation.  DAMON API
callers are therefore responsible to respect or ignore that.  Only vaddr
ops is respecting that, but only for initial start time.  DAMON sysfs
interface allows users to setup the initial regions that DAMON core also
respects.  But, again, it works for only the initial time.  Users setting
the regions for min_nr_regions can be difficult and inefficient, when the
min_nr_regions value is high.  There was actually a report [1] from a
user.  The use case was page granular access monitoring with a large
aggregation interval.

Make the following three changes for resolving the issue.  First (patch
1), make DAMON core split regions at the beginning and every aggregation
interval, to respect the min_nr_regions.  Second (patch 2), drop the
vaddr's split operations and related code that are no more needed.  Third
(patch 3), add a kunit test for the newly introduced function.


This patch (of 3):

DAMON core layer respects the min_nr_regions parameter by setting the
maximum size of each region as total monitoring region size divided by the
parameter value.  And the limit is applied by preventing merge of regions
that result in a region larger than the maximum size.  The limit is
updated per ops update interval, because vaddr updates the monitoring
regions on the ops update callback.

It does nothing for the beginning state.  That's because the users can set
the initial monitoring regions as they want.  That is, if the users really
care about the min_nr_regions, they are supposed to set the initial
monitoring regions to have more than min_nr_regions regions.  The virtual
address space operation set, vaddr, has an exceptional case.  Users can
ask the ops set to configure the initial regions on its own.  For the
case, vaddr sets up the initial regions to meet the min_nr_regions.  So,
vaddr has exceptional support, but basically users are required to set the
regions on their own if they want min_nr_regions to be respected.

When 'min_nr_regions' is high, such initial setup is difficult.  If DAMON
sysfs interface is used for that, the memory for saving the initial setup
is also a waste.

Even if the user forgives the setup, DAMON will eventually make more than
min_nr_regions regions by splitting operations.  But it will take time. 
If the aggregation interval is long, the delay could be problematic. 
There was actually a report [1] of the case.  The reporter wanted to do
page granular monitoring with a large aggregation interval.

Also, DAMON is doing nothing for online changes on monitoring regions and
min_nr_regions.  For example, the user can remove a monitoring region or
increase min_nr_regions while DAMON is running.

Split regions larger than the size at the beginning of the kdamond main
loop, to fix the initial setup issue.  Also do the split every aggregation
interval, for online changes.  This means the behavior is slightly
changed.  It is difficult to imagine a use case that actually depends on
the old behavior, though.  So this change is arguably fine.

Note that the size limit is aligned by damon_ctx->min_region_sz and cannot
be zero.  That is, if min_nr_region is larger than the total size of
monitoring regions divided by ->min_region_sz, that cannot be respected.

Link: https://lkml.kernel.org/r/20260228222831.7232-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20260228222831.7232-2-sj@kernel.org
Link: https://lore.kernel.org/CAC5umyjmJE9SBqjbetZZecpY54bHpn2AvCGNv3aF6J=1cfoPXQ@mail.gmail.com [1]
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   45 +++++++++++++++++++++++++++++++++++++++------
 1 file changed, 39 insertions(+), 6 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-split-regions-for-min_nr_regions
+++ a/mm/damon/core.c
@@ -1314,6 +1314,40 @@ static unsigned long damon_region_sz_lim
 	return sz;
 }
 
+static void damon_split_region_at(struct damon_target *t,
+				  struct damon_region *r, unsigned long sz_r);
+
+/*
+ * damon_apply_min_nr_regions() - Make effect of min_nr_regions parameter.
+ * @ctx:	monitoring context.
+ *
+ * This function implement min_nr_regions (minimum number of damon_region
+ * objects in the given monitoring context) behavior.  It first calculates
+ * maximum size of each region for enforcing the min_nr_regions as total size
+ * of the regions divided by the min_nr_regions.  After that, this function
+ * splits regions to ensure all regions are equal to or smaller than the size
+ * limit.  Finally, this function returns the maximum size limit.
+ *
+ * Returns: maximum size of each region for convincing min_nr_regions.
+ */
+static unsigned long damon_apply_min_nr_regions(struct damon_ctx *ctx)
+{
+	unsigned long max_region_sz = damon_region_sz_limit(ctx);
+	struct damon_target *t;
+	struct damon_region *r, *next;
+
+	max_region_sz = ALIGN(max_region_sz, ctx->min_region_sz);
+	damon_for_each_target(t, ctx) {
+		damon_for_each_region_safe(r, next, t) {
+			while (damon_sz_region(r) > max_region_sz) {
+				damon_split_region_at(t, r, max_region_sz);
+				r = damon_next_region(r);
+			}
+		}
+	}
+	return max_region_sz;
+}
+
 static int kdamond_fn(void *data);
 
 /*
@@ -1670,9 +1704,6 @@ static void kdamond_tune_intervals(struc
 	damon_set_attrs(c, &new_attrs);
 }
 
-static void damon_split_region_at(struct damon_target *t,
-				  struct damon_region *r, unsigned long sz_r);
-
 static bool __damos_valid_target(struct damon_region *r, struct damos *s)
 {
 	unsigned long sz;
@@ -2757,7 +2788,7 @@ static int kdamond_fn(void *data)
 	if (!ctx->regions_score_histogram)
 		goto done;
 
-	sz_limit = damon_region_sz_limit(ctx);
+	sz_limit = damon_apply_min_nr_regions(ctx);
 
 	while (!kdamond_need_stop(ctx)) {
 		/*
@@ -2782,10 +2813,13 @@ static int kdamond_fn(void *data)
 		if (ctx->ops.check_accesses)
 			max_nr_accesses = ctx->ops.check_accesses(ctx);
 
-		if (ctx->passed_sample_intervals >= next_aggregation_sis)
+		if (ctx->passed_sample_intervals >= next_aggregation_sis) {
 			kdamond_merge_regions(ctx,
 					max_nr_accesses / 10,
 					sz_limit);
+			/* online updates might be made */
+			sz_limit = damon_apply_min_nr_regions(ctx);
+		}
 
 		/*
 		 * do kdamond_call() and kdamond_apply_schemes() after
@@ -2842,7 +2876,6 @@ static int kdamond_fn(void *data)
 				sample_interval;
 			if (ctx->ops.update)
 				ctx->ops.update(ctx);
-			sz_limit = damon_region_sz_limit(ctx);
 		}
 	}
 done:
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-set-quota-score-histogram-with-core-filters.patch
mm-damon-core-do-non-safe-region-walk-on-kdamond_apply_schemes.patch
mm-damon-core-split-regions-for-min_nr_regions.patch
mm-damon-vaddr-do-not-split-regions-for-min_nr_regions.patch
mm-damon-test-core-kunit-add-damon_apply_min_nr_regions-test.patch

