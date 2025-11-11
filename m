Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E608E2D1F69
	for <mm-commits@vger.kernel.org>; Tue, 11 Nov 2025 18:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762887595; cv=none; b=qMlLDT0MaC9k21dVSj++pXkwxzOsLmyoElIihKUxd5RwyTJJlq9PGKjShc/xVrbXZZkSs563Dqmm0DAvwYsdzwhImhviG+bz4Mhuxp+w3ei5gVsAYX1nXjQe3cTbXpzeE0csJ/iVpE7Or0cplj8eEbGk5VJ4hBua802IWuEuNfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762887595; c=relaxed/simple;
	bh=yBFSCZ035JNYVr+lBJ5EXvhD2S2QD/oYN1CveZMU2lQ=;
	h=Date:To:From:Subject:Message-Id; b=XYHDr+QLApQZxQ30exn3JxUYJWsSKH4qrll6fbKmMhXrMlTXWZysHuy17X90f3B0VfZsvj64juaoz1/AcWcP4QC1wa5uBIMgk6jM0n9DgfeUoN8c6uzHYEruCKE2UzioEUWAvM9aAHUA5EkbIokY3t92ijdss5NhMT0GQHgSMc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VfqGJvCv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VfqGJvCv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBEE6C19424;
	Tue, 11 Nov 2025 18:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762887594;
	bh=yBFSCZ035JNYVr+lBJ5EXvhD2S2QD/oYN1CveZMU2lQ=;
	h=Date:To:From:Subject:From;
	b=VfqGJvCv2vhhAmfMatOmPaS3nMNfbuyCTSRRVpxOZswKCVI1t/vGY0GBuD8rOdXRM
	 B6wM3/c6MxV9MEPp7YZi6PXROFkUUKbjzoBO/9jLuZaT2yj6356sz+te+UViQqaIiN
	 zwSEpJNYlPsU9f6+wj+faVcxJyoURXRQegptFem4=
Date: Tue, 11 Nov 2025 10:59:54 -0800
To: mm-commits@vger.kernel.org,davidgow@google.com,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-tests-core-kunit-add-damon_commit_target_regions-test.patch added to mm-new branch
Message-Id: <20251111185954.BBEE6C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/tests/core-kunit: add damon_commit_target_regions() test
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-tests-core-kunit-add-damon_commit_target_regions-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-tests-core-kunit-add-damon_commit_target_regions-test.patch

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
Subject: mm/damon/tests/core-kunit: add damon_commit_target_regions() test
Date: Tue, 11 Nov 2025 10:44:10 -0800

Add a new test for damon_commit_target_regions().

Link: https://lkml.kernel.org/r/20251111184415.141757-12-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/core-kunit.h |   65 ++++++++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-add-damon_commit_target_regions-test
+++ a/mm/damon/tests/core-kunit.h
@@ -964,6 +964,70 @@ static void damos_test_commit(struct kun
 			});
 }
 
+static struct damon_target *damon_test_help_setup_target(
+		unsigned long region_start_end[][2], int nr_regions)
+{
+	struct damon_target *t;
+	struct damon_region *r;
+	int i;
+
+	t = damon_new_target();
+	if (!t)
+		return NULL;
+	for (i = 0; i < nr_regions; i++) {
+		r = damon_new_region(region_start_end[i][0],
+				region_start_end[i][1]);
+		if (!r) {
+			damon_free_target(t);
+			return NULL;
+		}
+		damon_add_region(r, t);
+	}
+	return t;
+}
+
+static void damon_test_commit_target_regions_for(struct kunit *test,
+		unsigned long dst_start_end[][2], int nr_dst_regions,
+		unsigned long src_start_end[][2], int nr_src_regions,
+		unsigned long expect_start_end[][2], int nr_expect_regions)
+{
+	struct damon_target *dst_target, *src_target;
+	struct damon_region *r;
+	int i;
+
+	dst_target = damon_test_help_setup_target(dst_start_end, nr_dst_regions);
+	if (!dst_target)
+		kunit_skip(test, "dst target setup fail");
+	src_target = damon_test_help_setup_target(src_start_end, nr_src_regions);
+	if (!src_target) {
+		damon_free_target(dst_target);
+		kunit_skip(test, "src target setup fail");
+	}
+	damon_commit_target_regions(dst_target, src_target, 1);
+	i = 0;
+	damon_for_each_region(r, dst_target) {
+		KUNIT_EXPECT_EQ(test, r->ar.start, expect_start_end[i][0]);
+		KUNIT_EXPECT_EQ(test, r->ar.end, expect_start_end[i][1]);
+		i++;
+	}
+	KUNIT_EXPECT_EQ(test, damon_nr_regions(dst_target), nr_expect_regions);
+	KUNIT_EXPECT_EQ(test, i, nr_expect_regions);
+	damon_free_target(dst_target);
+	damon_free_target(src_target);
+}
+
+static void damon_test_commit_target_regions(struct kunit *test)
+{
+	damon_test_commit_target_regions_for(test,
+			(unsigned long[][2]) {{3, 8}, {8, 10}}, 2,
+			(unsigned long[][2]) {{4, 6}}, 1,
+			(unsigned long[][2]) {{4, 6}}, 1);
+	damon_test_commit_target_regions_for(test,
+			(unsigned long[][2]) {{3, 8}, {8, 10}}, 2,
+			(unsigned long[][2]) {}, 0,
+			(unsigned long[][2]) {{3, 8}, {8, 10}}, 2);
+}
+
 static void damos_test_filter_out(struct kunit *test)
 {
 	struct damon_target *t;
@@ -1170,6 +1234,7 @@ static struct kunit_case damon_test_case
 	KUNIT_CASE(damos_test_commit_dests),
 	KUNIT_CASE(damos_test_commit_filter),
 	KUNIT_CASE(damos_test_commit),
+	KUNIT_CASE(damon_test_commit_target_regions),
 	KUNIT_CASE(damos_test_filter_out),
 	KUNIT_CASE(damon_test_feed_loop_next_input),
 	KUNIT_CASE(damon_test_set_filters_default_reject),
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

