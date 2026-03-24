Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06320365A0B
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388667; cv=none; b=ukPTaMzy2X79tXpe5MURSlkXdqCwnak1wQ/NXR6yaEzKYlmiIGAmZ0a6ZLdmxS0ZND2ybX+w8dGRd1cDXw9dtiwrOAlxPWZH9LD4z3TlDDAZsbj2LxRDe52NaqaA4YLlR2ZxW77NjydohlT1asyeuR3hcIr7pg5vS4G5K225NyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388667; c=relaxed/simple;
	bh=UGygwT5Po2zxTxSuEhnws4keQpL8ttXU/MHLPWYkgS8=;
	h=Date:To:From:Subject:Message-Id; b=H0T/oDgJjPvcvmD30MiZodio6cWkuhGtS8KgP+q7y88N8sEuRNkk0XwYJQgqORTryJtuUhEUkHD8JhS+dyW1jqAthfbs2MN68vHzKVW1DyibZiI4z1y+MW3eaz0Vc9DMqkpDy9Kn8E3MNdPLENV2165hPIgeM/wsZJvFVl8mHn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ANv5dXAg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ANv5dXAg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2F9EC19424;
	Tue, 24 Mar 2026 21:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388666;
	bh=UGygwT5Po2zxTxSuEhnws4keQpL8ttXU/MHLPWYkgS8=;
	h=Date:To:From:Subject:From;
	b=ANv5dXAgUrjIb84PWdGyghbi2k7qmu9ZG6UtjRTIC6jgIJVQ8hV2mgQB2ukc1KkpR
	 t8KSss/7+XjP/Py8F8YpwJMFEnoBJbg+/BE1qQAeE25bx57O5vNezrBnQ9GE8NqUpa
	 AjHzVlISfW5jG6+CAW4Cui0VF3E7GJexR+4zE1Y8=
Date: Tue, 24 Mar 2026 14:44:26 -0700
To: mm-commits@vger.kernel.org,davidgow@google.com,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-test-core-kunit-add-damon_apply_min_nr_regions-test.patch removed from -mm tree
Message-Id: <20260324214426.D2F9EC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/test/core-kunit: add damon_apply_min_nr_regions() test
has been removed from the -mm tree.  Its filename was
     mm-damon-test-core-kunit-add-damon_apply_min_nr_regions-test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/test/core-kunit: add damon_apply_min_nr_regions() test
Date: Sat, 28 Feb 2026 14:28:27 -0800

Add a kunit test for the functionality of damon_apply_min_nr_regions().

Link: https://lkml.kernel.org/r/20260228222831.7232-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/core-kunit.h |   52 ++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

--- a/mm/damon/tests/core-kunit.h~mm-damon-test-core-kunit-add-damon_apply_min_nr_regions-test
+++ a/mm/damon/tests/core-kunit.h
@@ -1239,6 +1239,57 @@ static void damon_test_set_filters_defau
 	damos_free_filter(target_filter);
 }
 
+static void damon_test_apply_min_nr_regions_for(struct kunit *test,
+		unsigned long sz_regions, unsigned long min_region_sz,
+		unsigned long min_nr_regions,
+		unsigned long max_region_sz_expect,
+		unsigned long nr_regions_expect)
+{
+	struct damon_ctx *ctx;
+	struct damon_target *t;
+	struct damon_region *r;
+	unsigned long max_region_size;
+
+	ctx = damon_new_ctx();
+	if (!ctx)
+		kunit_skip(test, "ctx alloc fail\n");
+	t = damon_new_target();
+	if (!t) {
+		damon_destroy_ctx(ctx);
+		kunit_skip(test, "target alloc fail\n");
+	}
+	damon_add_target(ctx, t);
+	r = damon_new_region(0, sz_regions);
+	if (!r) {
+		damon_destroy_ctx(ctx);
+		kunit_skip(test, "region alloc fail\n");
+	}
+	damon_add_region(r, t);
+
+	ctx->min_region_sz = min_region_sz;
+	ctx->attrs.min_nr_regions = min_nr_regions;
+	max_region_size = damon_apply_min_nr_regions(ctx);
+
+	KUNIT_EXPECT_EQ(test, max_region_size, max_region_sz_expect);
+	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), nr_regions_expect);
+
+	damon_destroy_ctx(ctx);
+}
+
+static void damon_test_apply_min_nr_regions(struct kunit *test)
+{
+	/* common, expected setup */
+	damon_test_apply_min_nr_regions_for(test, 10, 1, 10, 1, 10);
+	/* no zero size limit */
+	damon_test_apply_min_nr_regions_for(test, 10, 1, 15, 1, 10);
+	/* max size should be aligned by min_region_sz */
+	damon_test_apply_min_nr_regions_for(test, 10, 2, 2, 6, 2);
+	/*
+	 * when min_nr_regions and min_region_sz conflicts, min_region_sz wins.
+	 */
+	damon_test_apply_min_nr_regions_for(test, 10, 2, 10, 2, 5);
+}
+
 static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_target),
 	KUNIT_CASE(damon_test_regions),
@@ -1265,6 +1316,7 @@ static struct kunit_case damon_test_case
 	KUNIT_CASE(damos_test_filter_out),
 	KUNIT_CASE(damon_test_feed_loop_next_input),
 	KUNIT_CASE(damon_test_set_filters_default_reject),
+	KUNIT_CASE(damon_test_apply_min_nr_regions),
 	{},
 };
 
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

