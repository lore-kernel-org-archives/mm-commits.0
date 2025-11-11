Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6CFE2D0628
	for <mm-commits@vger.kernel.org>; Tue, 11 Nov 2025 18:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762887590; cv=none; b=WWsnHfXMFh0VPHeuuFgiTXe03Dsu/eShtcazNZuUZVd0v6xcGXOOzN7kd6tZ2NhIR/Vq5mhusnBOSREjkq4QC1Ctej9anjBu4z5PLjntURq3EbVdQbT58k8fqG1is4i73PnOsFsNnpdBoFxjxcXEOnZRX3jKrE66vme9Yo1dC/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762887590; c=relaxed/simple;
	bh=xt0mEnxgPx889RzknAbIjGWiIao3M4cbqsXo3HU4XDI=;
	h=Date:To:From:Subject:Message-Id; b=HWXd4cPb1kWqRdVDm+Gb/Z9nwcYxzRB+n1dcL7WejmdgIRe1vD8yDxHSX0LpJ5eqSS+Uys9izH9FynALqWQLALh22AGYunFz3reDrCjaQwK5gyuTpRv9odRGSlMHfRzdhr2nDj1/CA9iTnNdcR8xJ+V/Cy8UxBBMR1Leb12adgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QX4Q42um; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QX4Q42um"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 720EEC4CEF7;
	Tue, 11 Nov 2025 18:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762887590;
	bh=xt0mEnxgPx889RzknAbIjGWiIao3M4cbqsXo3HU4XDI=;
	h=Date:To:From:Subject:From;
	b=QX4Q42umAiOfMOXiaJdExIcsgBfk0LMdGljhOkLTu/Ng9+mAJ+cnefQcl5E2tgjID
	 QIUG0pOF4dqlPbeXF2sfwRp/253IeRz5K7fzhWoEC9Hnx+PO78Q5yhHnoNjy8uiKxO
	 hzyJiU3Yct91TWeGFKhDpmSa2Rov74yZFBG+uJtk=
Date: Tue, 11 Nov 2025 10:59:49 -0800
To: mm-commits@vger.kernel.org,davidgow@google.com,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-tests-core-kunit-add-damos_commit_dests-test.patch added to mm-new branch
Message-Id: <20251111185950.720EEC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/tests/core-kunit: add damos_commit_dests() test
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-tests-core-kunit-add-damos_commit_dests-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-tests-core-kunit-add-damos_commit_dests-test.patch

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
Subject: mm/damon/tests/core-kunit: add damos_commit_dests() test
Date: Tue, 11 Nov 2025 10:44:08 -0800

Add a new unit test for damos_commit_dests().

Link: https://lkml.kernel.org/r/20251111184415.141757-10-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/core-kunit.h |   97 ++++++++++++++++++++++++++++++++++
 1 file changed, 97 insertions(+)

--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-add-damos_commit_dests-test
+++ a/mm/damon/tests/core-kunit.h
@@ -692,6 +692,102 @@ static void damos_test_commit_quota(stru
 	KUNIT_EXPECT_EQ(test, dst.weight_age, src.weight_age);
 }
 
+static int damos_test_help_dests_setup(struct damos_migrate_dests *dests,
+		unsigned int *node_id_arr, unsigned int *weight_arr,
+		size_t nr_dests)
+{
+	size_t i;
+
+	dests->node_id_arr = kmalloc_array(nr_dests,
+			sizeof(*dests->node_id_arr), GFP_KERNEL);
+	if (!dests->node_id_arr)
+		return -ENOMEM;
+	dests->weight_arr = kmalloc_array(nr_dests,
+			sizeof(*dests->weight_arr), GFP_KERNEL);
+	if (!dests->weight_arr) {
+		kfree(dests->node_id_arr);
+		dests->node_id_arr = NULL;
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < nr_dests; i++) {
+		dests->node_id_arr[i] = node_id_arr[i];
+		dests->weight_arr[i] = weight_arr[i];
+	}
+	dests->nr_dests = nr_dests;
+	return 0;
+}
+
+static void damos_test_help_dests_free(struct damos_migrate_dests *dests)
+{
+	kfree(dests->node_id_arr);
+	kfree(dests->weight_arr);
+}
+
+static void damos_test_commit_dests_for(struct kunit *test,
+		unsigned int *dst_node_id_arr, unsigned int *dst_weight_arr,
+		size_t dst_nr_dests,
+		unsigned int *src_node_id_arr, unsigned int *src_weight_arr,
+		size_t src_nr_dests)
+{
+	struct damos_migrate_dests dst = {}, src = {};
+	int i, err;
+	bool skip = true;
+
+	err = damos_test_help_dests_setup(&dst, dst_node_id_arr,
+			dst_weight_arr, dst_nr_dests);
+	if (err)
+		kunit_skip(test, "dests setup fail");
+	err = damos_test_help_dests_setup(&src, src_node_id_arr,
+			src_weight_arr, src_nr_dests);
+	if (err) {
+		damos_test_help_dests_free(&dst);
+		kunit_skip(test, "src setup fail");
+	}
+	err = damos_commit_dests(&dst, &src);
+	if (err)
+		goto out;
+	skip = false;
+
+	KUNIT_EXPECT_EQ(test, dst.nr_dests, src_nr_dests);
+	for (i = 0; i < dst.nr_dests; i++) {
+		KUNIT_EXPECT_EQ(test, dst.node_id_arr[i], src_node_id_arr[i]);
+		KUNIT_EXPECT_EQ(test, dst.weight_arr[i], src_weight_arr[i]);
+	}
+
+out:
+	damos_test_help_dests_free(&dst);
+	damos_test_help_dests_free(&src);
+	if (skip)
+		kunit_skip(test, "skip");
+}
+
+static void damos_test_commit_dests(struct kunit *test)
+{
+	damos_test_commit_dests_for(test,
+			(unsigned int[]){1, 2, 3}, (unsigned int[]){2, 3, 4},
+			3,
+			(unsigned int[]){4, 5, 6}, (unsigned int[]){5, 6, 7},
+			3);
+	damos_test_commit_dests_for(test,
+			(unsigned int[]){1, 2}, (unsigned int[]){2, 3},
+			2,
+			(unsigned int[]){4, 5, 6}, (unsigned int[]){5, 6, 7},
+			3);
+	damos_test_commit_dests_for(test,
+			NULL, NULL, 0,
+			(unsigned int[]){4, 5, 6}, (unsigned int[]){5, 6, 7},
+			3);
+	damos_test_commit_dests_for(test,
+			(unsigned int[]){1, 2, 3}, (unsigned int[]){2, 3, 4},
+			3,
+			(unsigned int[]){4, 5}, (unsigned int[]){5, 6}, 2);
+	damos_test_commit_dests_for(test,
+			(unsigned int[]){1, 2, 3}, (unsigned int[]){2, 3, 4},
+			3,
+			NULL, NULL, 0);
+}
+
 static void damos_test_commit_filter_for(struct kunit *test,
 		struct damos_filter *dst, struct damos_filter *src)
 {
@@ -980,6 +1076,7 @@ static struct kunit_case damon_test_case
 	KUNIT_CASE(damos_test_commit_quota_goal),
 	KUNIT_CASE(damos_test_commit_quota_goals),
 	KUNIT_CASE(damos_test_commit_quota),
+	KUNIT_CASE(damos_test_commit_dests),
 	KUNIT_CASE(damos_test_commit_filter),
 	KUNIT_CASE(damos_test_filter_out),
 	KUNIT_CASE(damon_test_feed_loop_next_input),
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

