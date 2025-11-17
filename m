Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC1E823D7FD;
	Mon, 17 Nov 2025 01:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343313; cv=none; b=UnhefdmAk4bmLEqSSilYUlkFPUH0MwI81Nt95tYw9yoqsPV+UgUgees2irleBzLh08BdJJcs01ocOp6LlbPMgE/hwYuzThm3zriwHWIbbFGdVw7E6BpeAw8vedv49F69jr8XGjszzoFEK5gFzF2KvLON7UmDvB3HXFP9O90iwh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343313; c=relaxed/simple;
	bh=jv6T66thiPG7CNumGq5iILhsz5LxU62i3wjdr75feuI=;
	h=Date:To:From:Subject:Message-Id; b=UNYX3jBd2GivQCSm/GL4Hogr/XAa5DNz8xxrtwtHndHSr4UKJy6PBt1DgvgaBYj2kHRYeITbhA7eAaE9Y5WN9S2iPaLTUQ0SYxT2cCqrPhpHJU9jgHGXW1LXWEmzKdE4hrJ/skhd5PsKd6yV6ORJhrWnnMVqSXsaSSYyVh4WNFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CmHEA6Hn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CmHEA6Hn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 795AFC116D0;
	Mon, 17 Nov 2025 01:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343313;
	bh=jv6T66thiPG7CNumGq5iILhsz5LxU62i3wjdr75feuI=;
	h=Date:To:From:Subject:From;
	b=CmHEA6HnamffgxBfwT/G6Yh3+bn6dtugfmvt4N5uyF60uKbnw4mkL9gHCcY6+atgz
	 fm2n7LUsFHGcTSy2MQTSGEG86Keo1Oik/0WuOQNN41jgx5szt4QsjPnytW0iWrFasc
	 +GizFhlLjiXONWcCcvfHPwMAV1VVJflX5M9M08Dc=
Date: Sun, 16 Nov 2025 17:35:12 -0800
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,stable@vger.kernel.org,davidgow@google.com,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-tests-sysfs-kunit-handle-alloc-failures-on-damon_sysfs_test_add_targets.patch removed from -mm tree
Message-Id: <20251117013513.795AFC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/tests/sysfs-kunit: handle alloc failures on damon_sysfs_test_add_targets()
has been removed from the -mm tree.  Its filename was
     mm-damon-tests-sysfs-kunit-handle-alloc-failures-on-damon_sysfs_test_add_targets.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/tests/sysfs-kunit: handle alloc failures on damon_sysfs_test_add_targets()
Date: Sat, 1 Nov 2025 11:20:14 -0700

damon_sysfs_test_add_targets() is assuming all dynamic memory allocation
in it will succeed.  Those are indeed likely in the real use cases since
those allocations are too small to fail, but theoretically those could
fail.  In the case, inappropriate memory access can happen.  Fix it by
appropriately cleanup pre-allocated memory and skip the execution of the
remaining tests in the failure cases.

Link: https://lkml.kernel.org/r/20251101182021.74868-21-sj@kernel.org
Fixes: b8ee5575f763 ("mm/damon/sysfs-test: add a unit test for damon_sysfs_set_targets()")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: <stable@vger.kernel.org>	[6.7+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/sysfs-kunit.h |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

--- a/mm/damon/tests/sysfs-kunit.h~mm-damon-tests-sysfs-kunit-handle-alloc-failures-on-damon_sysfs_test_add_targets
+++ a/mm/damon/tests/sysfs-kunit.h
@@ -45,16 +45,41 @@ static void damon_sysfs_test_add_targets
 	struct damon_ctx *ctx;
 
 	sysfs_targets = damon_sysfs_targets_alloc();
+	if (!sysfs_targets)
+		kunit_skip(test, "sysfs_targets alloc fail");
 	sysfs_targets->nr = 1;
 	sysfs_targets->targets_arr = kmalloc_array(1,
 			sizeof(*sysfs_targets->targets_arr), GFP_KERNEL);
+	if (!sysfs_targets->targets_arr) {
+		kfree(sysfs_targets);
+		kunit_skip(test, "targets_arr alloc fail");
+	}
 
 	sysfs_target = damon_sysfs_target_alloc();
+	if (!sysfs_target) {
+		kfree(sysfs_targets->targets_arr);
+		kfree(sysfs_targets);
+		kunit_skip(test, "sysfs_target alloc fail");
+	}
 	sysfs_target->pid = __damon_sysfs_test_get_any_pid(12, 100);
 	sysfs_target->regions = damon_sysfs_regions_alloc();
+	if (!sysfs_target->regions) {
+		kfree(sysfs_targets->targets_arr);
+		kfree(sysfs_targets);
+		kfree(sysfs_target);
+		kunit_skip(test, "sysfs_regions alloc fail");
+	}
+
 	sysfs_targets->targets_arr[0] = sysfs_target;
 
 	ctx = damon_new_ctx();
+	if (!ctx) {
+		kfree(sysfs_targets->targets_arr);
+		kfree(sysfs_targets);
+		kfree(sysfs_target);
+		kfree(sysfs_target->regions);
+		kunit_skip(test, "ctx alloc fail");
+	}
 
 	damon_sysfs_add_targets(ctx, sysfs_targets);
 	KUNIT_EXPECT_EQ(test, 1u, nr_damon_targets(ctx));
_

Patches currently in -mm which might be from sj@kernel.org are

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
mm-damon-rename-damos-core-filter-helpers-to-have-word-core.patch
mm-damon-rename-damos-filters-to-damos-core_filters.patch
mm-damon-vaddr-cleanup-using-pmd_trans_huge_lock.patch
mm-damon-vaddr-use-vm_normal_folio_pmd-instead-of-damon_get_folio.patch
mm-damon-vaddr-consistently-use-only-pmd_entry-for-damos_migrate.patch
mm-damon-tests-core-kunit-remove-damon_min_region-redefinition.patch
selftests-damon-sysfspy-merge-damon-status-dumping-into-commitment-assertion.patch
docs-mm-damon-maintainer-profile-fix-a-typo-on-mm-untable-link.patch
docs-mm-damon-maintainer-profile-fix-grammartical-errors.patch

