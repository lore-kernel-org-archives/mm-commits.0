Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F1B9233722;
	Mon, 17 Nov 2025 01:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343293; cv=none; b=hYwiy5y2CiK8tc7unklroB6k2dKuLgxHaRHEgYfcGnu3dUtF/QcJSMw4oXkpPLGkiCqnIzn+EXWwFjeusUygs4N9T+AQKGAUdAnnRkKvUWaNrnjCRoKFsIBu2UxGglO7YGt45BFkCK0iF1yvx15TFqBfXZWzUxDkT+jfH/pDILg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343293; c=relaxed/simple;
	bh=15lg+3lmnia7PQ7a41g4HVqUZtABT+eoN5DdHVXfxvk=;
	h=Date:To:From:Subject:Message-Id; b=sckFGVhrOm66Hmf+ALj8jNdEcqvtkQPkwJebvvlaqTx3+uek9j6i7GxIn6zWzoVW20a+0/IAoXfedVBAEnUqfbsd2d6wydN15IxoYiMVMyb6lut+mPOsK+qm11KNTf3zfJn6OvzG7nUrf2VjZcRwetSUFWoKu1mev3L0sOz2vLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z2Xm0ELu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z2Xm0ELu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30469C2BC86;
	Mon, 17 Nov 2025 01:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343293;
	bh=15lg+3lmnia7PQ7a41g4HVqUZtABT+eoN5DdHVXfxvk=;
	h=Date:To:From:Subject:From;
	b=Z2Xm0ELuwbf34kenPjkuCZvIHh08MNJzCDo8AbD368WZlJKkXWsOUaba/30ejs1N7
	 VWlUgohQGXPtw26I4LDEd8DVVIrbTSQM2wP/QjOnIUzecUyqxTYl9OdAxE5gLhJBQC
	 J5YaUBZd2ZWO8aVNJ0w2OVzYG0ZRCQ7J6n34QW8E=
Date: Sun, 16 Nov 2025 17:34:52 -0800
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,stable@vger.kernel.org,davidgow@google.com,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-tests-core-kunit-handle-memory-failure-from-damon_test_target.patch removed from -mm tree
Message-Id: <20251117013453.30469C2BC86@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/tests/core-kunit: handle memory failure from damon_test_target()
has been removed from the -mm tree.  Its filename was
     mm-damon-tests-core-kunit-handle-memory-failure-from-damon_test_target.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/tests/core-kunit: handle memory failure from damon_test_target()
Date: Sat, 1 Nov 2025 11:19:57 -0700

damon_test_target() is assuming all dynamic memory allocation in it will
succeed.  Those are indeed likely in the real use cases since those
allocations are too small to fail, but theoretically those could fail.  In
the case, inappropriate memory access can happen.  Fix it by appropriately
cleanup pre-allocated memory and skip the execution of the remaining tests
in the failure cases.

Link: https://lkml.kernel.org/r/20251101182021.74868-4-sj@kernel.org
Fixes: 17ccae8bb5c9 ("mm/damon: add kunit tests")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: <stable@vger.kernel.org>	[5.15+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/core-kunit.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-handle-memory-failure-from-damon_test_target
+++ a/mm/damon/tests/core-kunit.h
@@ -58,7 +58,14 @@ static void damon_test_target(struct kun
 	struct damon_ctx *c = damon_new_ctx();
 	struct damon_target *t;
 
+	if (!c)
+		kunit_skip(test, "ctx alloc fail");
+
 	t = damon_new_target();
+	if (!t) {
+		damon_destroy_ctx(c);
+		kunit_skip(test, "target alloc fail");
+	}
 	KUNIT_EXPECT_EQ(test, 0u, nr_damon_targets(c));
 
 	damon_add_target(c, t);
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

