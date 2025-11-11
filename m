Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF2A2C3770
	for <mm-commits@vger.kernel.org>; Tue, 11 Nov 2025 18:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762887574; cv=none; b=tlR/wsgrEFXcv7dTEqGoWWOfh8VrGA9Ly1wweq03LbMyd17zMPV+JAJUQtpOtdvWzA1fSO3qwSF3v8cM0yB2D1idhHQVt2MmtwdP58fCxzJxOe/c8WS2xRGC2W+tuEOtMWCjCZoqKRUCw1AEQ2Hp/K1qYGuNLSgSieVsnkh9wm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762887574; c=relaxed/simple;
	bh=kYYuHu2SeLIR+S8dvfMssNl8wm6CLDR3q2vfySUzktU=;
	h=Date:To:From:Subject:Message-Id; b=Zrcap0wi3j4bEIuxj7ZaKbPyc9X1j+GrllhPIhV7/Gc6UAa4TBMbGvi74SuJ85Ay/L5Nk5+lNg/nX4MjnHoVAO/G70Sda0DVSs51LjD6fFVzg7wKzdpWWdsbwsYy19tUthg3PCqbSppLff2D54kYT1adIcr7WJHvCglykjLeqd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TpcYonTf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TpcYonTf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34313C2BCB1;
	Tue, 11 Nov 2025 18:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762887573;
	bh=kYYuHu2SeLIR+S8dvfMssNl8wm6CLDR3q2vfySUzktU=;
	h=Date:To:From:Subject:From;
	b=TpcYonTfzDwP81sm7Ys6+E6bdviaaHRx/mIYXoW4a5JO+NrnaicttdMsFQkqb+fPB
	 iekVqlzq0YLSYrWk3k3q3h/wH3PJWGL9uXL3krvCEzIdVJpylVmDAM8P60puDsD/10
	 V5CgAMBYcHa+X9I45JvP81453nVteJgw++oYGVJs=
Date: Tue, 11 Nov 2025 10:59:32 -0800
To: mm-commits@vger.kernel.org,davidgow@google.com,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-tests-core-kunit-remove-dynamic-allocs-on-damos_test_commit_filter.patch added to mm-new branch
Message-Id: <20251111185933.34313C2BCB1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/tests/core-kunit: remove dynamic allocs on damos_test_commit_filter()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-tests-core-kunit-remove-dynamic-allocs-on-damos_test_commit_filter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-tests-core-kunit-remove-dynamic-allocs-on-damos_test_commit_filter.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
Subject: mm/damon/tests/core-kunit: remove dynamic allocs on damos_test_commit_filter()
Date: Tue, 11 Nov 2025 10:44:00 -0800

Patch series "mm/damon/tests: add more tests for online parameters commit".

A DAMON feature called parameters "commit" allows DAMON API callers and
ABI users to update nearly every DAMON parameter while DAMON is running. 
This is being used for flexible DAMON use cases such as taking a snapshot
of the monitoring results with minimum overhead, or adjusting access-aware
system operations (DAMOS) for user-space driven auto-tuning or
investigations.

Compared to the usefulness of the feature and size of the implementation,
the test coverage is pretty small.  Only the filter commit part has a
single test case, namely damos_test_commit_filter().  Actually, we found
and fixed a few bugs of the feature in the past.  The single existing test
was also added to avoid reintroduction of a found bug.

Add more unit tests for the feature.

First four patches (1-4) refactor and extend the existing test for DAMOS
filter commit for multiple test cases.

Next three patches (5-7) add tests for DAMOS quota commit.

Next two patches (8 and 9) refactor damos_commit_dests() for ease of code
reading and test writing, and implement a new unit test of the function
that is being refactored in a test-friendly way.

Final two patches (10 and 11) further add new unit tests for
damos_commit() and damon_commit_target_regions().


This patch (of 11):

damos_test_commit_filter() is dynamically allocating test-purpose DAMOS
filters.  Allocation failure checks are making the code longer,
complicated, and difficult to extend for more test cases.  Refactor the
code to remove the dynamic allocation.

Link: https://lkml.kernel.org/r/20251111184415.141757-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20251111184415.141757-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/core-kunit.h |   29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-remove-dynamic-allocs-on-damos_test_commit_filter
+++ a/mm/damon/tests/core-kunit.h
@@ -499,23 +499,20 @@ static void damos_test_new_filter(struct
 
 static void damos_test_commit_filter(struct kunit *test)
 {
-	struct damos_filter *src_filter, *dst_filter;
+	struct damos_filter src_filter = {
+		.type = DAMOS_FILTER_TYPE_ANON,
+		.matching = true,
+		.allow = true};
+	struct damos_filter dst_filter = {
+		.type = DAMOS_FILTER_TYPE_ACTIVE,
+		.matching = false,
+		.allow = false,
+	};
 
-	src_filter = damos_new_filter(DAMOS_FILTER_TYPE_ANON, true, true);
-	if (!src_filter)
-		kunit_skip(test, "src filter alloc fail");
-	dst_filter = damos_new_filter(DAMOS_FILTER_TYPE_ACTIVE, false, false);
-	if (!dst_filter) {
-		damos_destroy_filter(src_filter);
-		kunit_skip(test, "dst filter alloc fail");
-	}
-	damos_commit_filter(dst_filter, src_filter);
-	KUNIT_EXPECT_EQ(test, dst_filter->type, src_filter->type);
-	KUNIT_EXPECT_EQ(test, dst_filter->matching, src_filter->matching);
-	KUNIT_EXPECT_EQ(test, dst_filter->allow, src_filter->allow);
-
-	damos_destroy_filter(src_filter);
-	damos_destroy_filter(dst_filter);
+	damos_commit_filter(&dst_filter, &src_filter);
+	KUNIT_EXPECT_EQ(test, dst_filter.type, src_filter.type);
+	KUNIT_EXPECT_EQ(test, dst_filter.matching, src_filter.matching);
+	KUNIT_EXPECT_EQ(test, dst_filter.allow, src_filter.allow);
 }
 
 static void damos_test_filter_out(struct kunit *test)
_

Patches currently in -mm which might be from sj@kernel.org are

mm-zswap-remove-unnecessary-dlen-writes-for-incompressible-pages.patch
mm-zswap-fix-typos-s-zwap-zswap.patch
mm-zswap-s-red-black-tree-xarray.patch
docs-admin-guide-mm-zswap-s-red-black-tree-xarray.patch
mm-damon-document-damos_quota_goal-nid-use-case.patch
mm-damon-add-damos-quota-goal-type-for-per-memcg-per-node-memory-usage.patch
mm-damon-core-implement-damos_quota_node_memcg_used_bp.patch
mm-damon-sysfs-schemes-implement-path-file-under-quota-goal-directory.patch
mm-damon-sysfs-schemes-support-damos_quota_node_memcg_used_bp.patch
mm-damon-core-add-damos-quota-gaol-metric-for-per-memcg-per-numa-free-memory.patch
mm-damon-sysfs-schemes-support-damos_quota_node_memcg_free_bp.patch
docs-mm-damon-design-document-damos_quota_node_memcg_usedfree_bp.patch
docs-admin-guide-mm-damon-usage-document-damos-quota-goal-path-file.patch
docs-abi-damon-document-damos-quota-goal-path-file.patch
mm-damon-core-fix-wrong-comment-of-damon_call-return-timing.patch
docs-mm-damon-design-fix-wrong-link-to-intervals-goal-section.patch
docs-admin-guide-mm-damon-stat-fix-a-typo-s-sampling-events-sampling-interval.patch
docs-admin-guide-mm-damon-usage-document-empty-target-regions-commit-behavior.patch
docs-admin-guide-mm-damon-reclaim-document-addr_unit-parameter.patch
docs-admin-guide-mm-damon-lru_sort-document-addr_unit-parameter.patch
docs-admin-guide-mm-damon-stat-document-aggr_interval_us-parameter.patch
docs-admin-guide-mm-damon-stat-document-negative-idle-time.patch
mm-damon-core-add-damon_target-obsolete-for-pin-point-removal.patch
mm-damon-sysfs-test-commit-input-against-realistic-destination.patch
mm-damon-sysfs-implement-obsolete_target-file.patch
docs-admin-guide-mm-damon-usage-document-obsolete_target-file.patch
docs-abi-damon-document-obsolete_target-sysfs-file.patch
selftests-damon-_damon_sysfs-support-obsolete_target-file.patch
drgn_dump_damon_status-dump-damon_target-obsolete.patch
sysfspy-extend-assert_ctx_committed-for-monitoring-targets.patch
selftests-damon-sysfs-add-obsolete_target-test.patch
mm-damon-tests-core-kunit-fix-memory-leak-in-damon_test_set_filters_default_reject.patch
mm-damon-tests-core-kunit-handle-allocation-failures-in-damon_test_regions.patch
mm-damon-tests-core-kunit-handle-memory-failure-from-damon_test_target.patch
mm-damon-tests-core-kunit-handle-memory-alloc-failure-from-damon_test_aggregate.patch
mm-damon-tests-core-kunit-handle-alloc-failures-on-damon_test_split_at.patch
mm-damon-tests-core-kunit-handle-alloc-failures-on-damon_test_merge_two.patch
mm-damon-tests-core-kunit-handle-alloc-failures-on-dasmon_test_merge_regions_of.patch
mm-damon-tests-core-kunit-handle-alloc-failures-on-damon_test_split_regions_of.patch
mm-damon-tests-core-kunit-handle-alloc-failures-in-damon_test_ops_registration.patch
mm-damon-tests-core-kunit-handle-alloc-failures-in-damon_test_set_regions.patch
mm-damon-tests-core-kunit-handle-alloc-failures-in-damon_test_update_monitoring_result.patch
mm-damon-tests-core-kunit-handle-alloc-failure-on-damon_test_set_attrs.patch
mm-damon-tests-core-kunit-handle-alloc-failres-in-damon_test_new_filter.patch
mm-damon-tests-core-kunit-handle-alloc-failure-on-damos_test_commit_filter.patch
mm-damon-tests-core-kunit-handle-alloc-failures-on-damos_test_filter_out.patch
mm-damon-tests-core-kunit-handle-alloc-failures-on-damon_test_set_filters_default_reject.patch
mm-damon-tests-vaddr-kunit-handle-alloc-failures-on-damon_do_test_apply_three_regions.patch
mm-damon-tests-vaddr-kunit-handle-alloc-failures-in-damon_test_split_evenly_fail.patch
mm-damon-tests-vaddr-kunit-handle-alloc-failures-on-damon_test_split_evenly_succ.patch
mm-damon-tests-sysfs-kunit-handle-alloc-failures-on-damon_sysfs_test_add_targets.patch
mm-damon-tests-core-kunit-remove-unnecessary-damon_ctx-variable-on-damon_test_split_at.patch
mm-damon-tests-core-kunit-remove-unused-ctx-in-damon_test_split_regions_of.patch
mm-damon-tests-core-kunit-remove-dynamic-allocs-on-damos_test_commit_filter.patch
mm-damon-tests-core-kunit-split-out-damos_test_commit_filter-core-logic.patch
mm-damon-tests-core-kunit-extend-damos_test_commit_filter_for-for-union-fields.patch
mm-damon-tests-core-kunit-add-test-cases-to-damos_test_commit_filter.patch
mm-damon-tests-core-kunit-add-damos_commit_quota_goal-test.patch
mm-damon-tests-core-kunit-add-damos_commit_quota_goals-test.patch
mm-damon-tests-core-kunit-add-damos_commit_quota-test.patch
mm-damon-core-pass-migrate_dests-to-damos_commit_dests.patch
mm-damon-tests-core-kunit-add-damos_commit_dests-test.patch
mm-damon-tests-core-kunit-add-damos_commit-test.patch
mm-damon-tests-core-kunit-add-damon_commit_target_regions-test.patch

