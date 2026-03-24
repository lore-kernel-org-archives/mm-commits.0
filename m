Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8DAE3612FB
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388664; cv=none; b=otTI8W17U3aBF2auF45o3qmWV9RP2hQas5PZgQf90aRGRTmpyrscmM4Dud4NVCbxi1xzjoaPggHacrXfVDZp5wNn3D5yuw870WJzQr5N+z6MULC4OehOdKJFn83BY0jYer5PbT9lsMOY6clqutAsalpfNnyypHF5TNdRoRb1qIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388664; c=relaxed/simple;
	bh=J69SARSN2kENejqvPijJ50K3asDBARc3psW8i7C6x5s=;
	h=Date:To:From:Subject:Message-Id; b=Ka/RV/7ZJj7Rcaf0HXNt6wVmS8RlSGG+FkyFjKwVQ5KOPqHRO36vN7iaYsrGQmlp1gwkSuY78CZeimK31nz4QcGtBNbJkqHx4iyeOWdmXRUhxwWQT434NDfFExc5dRFbsIXOiRmKJdbIqKj1wv3dZr+IjNxjLcNvs3we7iRtsH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aYQ/SvHa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aYQ/SvHa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E2A9C19424;
	Tue, 24 Mar 2026 21:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388664;
	bh=J69SARSN2kENejqvPijJ50K3asDBARc3psW8i7C6x5s=;
	h=Date:To:From:Subject:From;
	b=aYQ/SvHawSbnS0+xdtyE9u702TeidcrxlJ/QuzT3WKmqA3/PDEhUZkISviMWiQbR1
	 U9zWS6o5PRhohsxJC/uY/FSmn5s2x7uaAK4f/RFeDdqyH9pE9ffsFaX3agV8PsySYh
	 tnvLJSgn0qW8GDQEcfLZq5jvDI9KEeBQ2gOYq1mo=
Date: Tue, 24 Mar 2026 14:44:24 -0700
To: mm-commits@vger.kernel.org,davidgow@google.com,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-split-regions-for-min_nr_regions.patch removed from -mm tree
Message-Id: <20260324214424.7E2A9C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: split regions for min_nr_regions
has been removed from the -mm tree.  Its filename was
     mm-damon-core-split-regions-for-min_nr_regions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -1316,6 +1316,40 @@ static unsigned long damon_region_sz_lim
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
@@ -1672,9 +1706,6 @@ static void kdamond_tune_intervals(struc
 	damon_set_attrs(c, &new_attrs);
 }
 
-static void damon_split_region_at(struct damon_target *t,
-				  struct damon_region *r, unsigned long sz_r);
-
 static bool __damos_valid_target(struct damon_region *r, struct damos *s)
 {
 	unsigned long sz;
@@ -2763,7 +2794,7 @@ static int kdamond_fn(void *data)
 	if (!ctx->regions_score_histogram)
 		goto done;
 
-	sz_limit = damon_region_sz_limit(ctx);
+	sz_limit = damon_apply_min_nr_regions(ctx);
 
 	while (!kdamond_need_stop(ctx)) {
 		/*
@@ -2788,10 +2819,13 @@ static int kdamond_fn(void *data)
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
@@ -2850,7 +2884,6 @@ static int kdamond_fn(void *data)
 				sample_interval;
 			if (ctx->ops.update)
 				ctx->ops.update(ctx);
-			sz_limit = damon_region_sz_limit(ctx);
 		}
 	}
 done:
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-add-config_damon_debug_sanity.patch
mm-damon-core-add-damon_new_region-debug_sanity-check.patch
mm-damon-core-add-damon_del_region-debug_sanity-check.patch
mm-damon-core-add-damon_nr_regions-debug_sanity-check.patch
mm-damon-core-add-damon_merge_two_regions-debug_sanity-check.patch
mm-damon-core-add-damon_merge_regions_of-debug_sanity-check.patch
mm-damon-core-add-damon_split_region_at-debug_sanity-check.patch
mm-damon-core-add-damon_reset_aggregated-debug_sanity-check.patch
mm-damon-tests-kunitconifg-enable-damon_debug_sanity.patch
selftests-damon-config-enable-damon_debug_sanity.patch
mm-damon-tests-core-kunit-add-a-test-for-damon_commit_ctx.patch
docs-mm-damon-design-document-the-power-of-two-limitation-for-addr_unit.patch
mm-damon-core-remove-damos_set_next_apply_sis-duplicates.patch
mm-damon-core-use-time_before-for-next_apply_sis.patch
mm-damon-core-use-time_after_eq-in-kdamond_fn.patch
mm-damon-core-use-mult_frac.patch
mm-damon-tests-core-kunit-add-a-test-for-damon_is_last_region.patch
mm-damon-core-clarify-damon_set_attrs-usages.patch
mm-damon-document-non-zero-length-damon_region-assumption.patch
docs-admin-guide-mm-damn-lru_sort-fix-intervals-autotune-parameter-name.patch
docs-mm-damon-maintainer-profile-use-flexible-review-cadence.patch
docs-mm-damon-index-fix-typo-autoamted-automated.patch
mm-damon-core-introduce-damos_quota_goal_tuner.patch
mm-damon-core-allow-quota-goals-set-zero-effective-size-quota.patch
mm-damon-core-introduce-damos_quota_goal_tuner_temporal.patch
mm-damon-sysfs-schemes-implement-quotas-goal_tuner-file.patch
docs-mm-damon-design-document-the-goal-based-quota-tuner-selections.patch
docs-admin-guide-mm-damon-usage-document-goal_tuner-sysfs-file.patch
docs-abi-damon-update-for-goal_tuner.patch
mm-damon-tests-core-kunit-test-goal_tuner-commit.patch
selftests-damon-_damon_sysfs-support-goal_tuner-setup.patch
selftests-damon-drgn_dump_damon_status-support-quota-goal_tuner-dumping.patch
selftests-damon-sysfspy-test-goal_tuner-commit.patch
mm-damon-core-fix-wrong-end-address-assignment-on-walk_system_ram.patch
mm-damon-core-support-addr_unit-on-damon_find_biggest_system_ram.patch
mm-damon-core-support-addr_unit-on-damon_find_biggest_system_ram-fix.patch
mm-damon-core-receive-addr_unit-on-damon_set_region_biggest_system_ram_default.patch
mm-damon-core-receive-addr_unit-on-damon_set_region_biggest_system_ram_default-fix.patch
mm-damon-reclaim-respect-addr_unit-on-default-monitoring-region-setup.patch
mm-damon-lru_sort-respect-addr_unit-on-default-monitoring-region-setup.patch

