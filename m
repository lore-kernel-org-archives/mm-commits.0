Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3949923D7C5;
	Mon, 17 Nov 2025 01:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343298; cv=none; b=tU0kh7dbFvu+Ay76faht2eHcIPpTVNBIIOaogXRoIguBmYuGuspxCu09fj8gqWv0DXflOE+jd8o5CKZPiwHk20tHsQZJup1qSAZvXNFgXDCG6UvIePWQRcWgs3N70ObdpBQ5bC2bUoN+q38VJF0R/Z1mo0SGIuy7/ztDTmJ3ScI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343298; c=relaxed/simple;
	bh=FZODp1SlGYwaTKOQXnCoZL+gIJrZNK3Dc8OLSP/VaTo=;
	h=Date:To:From:Subject:Message-Id; b=FD2Er0DZHFOUY7CS7nj00TXrC+qlOS6GsIhCibuKu+wHVqYz35ALKys4Xcq/5kZwckJ/TsTINte4hpmooASKQQ8ohaFJopxjPStbBxpxFnvkzSom4jW9pR9nDoGA8uaZQSDpjDId0vq+P3PNHcHfSA9Dcy+lANRScVqvGO5c73Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mcTW/feX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mcTW/feX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00C9FC19423;
	Mon, 17 Nov 2025 01:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343298;
	bh=FZODp1SlGYwaTKOQXnCoZL+gIJrZNK3Dc8OLSP/VaTo=;
	h=Date:To:From:Subject:From;
	b=mcTW/feXrjyRMim2s03DRcGRRdDi5Uo3ASzI3mfTrmqt3OS1n3PJD80GWKnoz4TgA
	 lJypHekc5UzRVvsCzy2d9Ysjwby1RNKRY5TaAtqnB5CGu21fR3xQMvsuUveK1tiOGf
	 Ai3EqkctdHeiqIEWXqZ6hlJSpBhw4O8kUDhCFHU8=
Date: Sun, 16 Nov 2025 17:34:57 -0800
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,stable@vger.kernel.org,davidgow@google.com,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-tests-core-kunit-handle-alloc-failures-on-dasmon_test_merge_regions_of.patch removed from -mm tree
Message-Id: <20251117013458.00C9FC19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/tests/core-kunit: handle alloc failures on dasmon_test_merge_regions_of()
has been removed from the -mm tree.  Its filename was
     mm-damon-tests-core-kunit-handle-alloc-failures-on-dasmon_test_merge_regions_of.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/tests/core-kunit: handle alloc failures on dasmon_test_merge_regions_of()
Date: Sat, 1 Nov 2025 11:20:01 -0700

damon_test_merge_regions_of() is assuming all dynamic memory allocation in
it will succeed.  Those are indeed likely in the real use cases since
those allocations are too small to fail, but theoretically those could
fail.  In the case, inappropriate memory access can happen.  Fix it by
appropriately cleanup pre-allocated memory and skip the execution of the
remaining tests in the failure cases.

Link: https://lkml.kernel.org/r/20251101182021.74868-8-sj@kernel.org
Fixes: 17ccae8bb5c9 ("mm/damon: add kunit tests")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: <stable@vger.kernel.org>	[5.15+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/core-kunit.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-handle-alloc-failures-on-dasmon_test_merge_regions_of
+++ a/mm/damon/tests/core-kunit.h
@@ -248,8 +248,14 @@ static void damon_test_merge_regions_of(
 	int i;
 
 	t = damon_new_target();
+	if (!t)
+		kunit_skip(test, "target alloc fail");
 	for (i = 0; i < ARRAY_SIZE(sa); i++) {
 		r = damon_new_region(sa[i], ea[i]);
+		if (!r) {
+			damon_free_target(t);
+			kunit_skip(test, "region alloc fail");
+		}
 		r->nr_accesses = nrs[i];
 		r->nr_accesses_bp = nrs[i] * 10000;
 		damon_add_region(r, t);
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

