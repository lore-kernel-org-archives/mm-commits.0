Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B53A23C8A0;
	Mon, 17 Nov 2025 01:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343312; cv=none; b=Ny3p9AZ1t784nQEa+ZrtTRmsxxzuE0Q4ySdonGnCQDIHrVkvxYI4aKWol6JccBdbHwzYGBsEYedcPBbikGJA2p7KLJRSKjPbpZ4iI7yI6VoSZPJF3jE2T52LSqb0QZ7savB9E410VqmIWBo2kYHRMV574b7qSMWZzIYo4O+NGr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343312; c=relaxed/simple;
	bh=HL1W0xb3BcOoKWyc7S6vxEtCmoN+QpbCG+1Ajmswsbc=;
	h=Date:To:From:Subject:Message-Id; b=D0mY4kcJuGeYyLGWIXyMJo5alGTHgJaStJuCACPkgtE5i92eSb0kKfEEm/UCQwdWpTMaJw6fEkMPMW0PcAx6XgJdE0QNqyH8a/8wWz0vgrM9GOOYMRAqBgUCE8izfT6tZpersPGCN9rdBuY40PQnmykouY7NDRlNlWgSZs38S2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YCPUJlG/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YCPUJlG/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52E68C4CEF1;
	Mon, 17 Nov 2025 01:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343312;
	bh=HL1W0xb3BcOoKWyc7S6vxEtCmoN+QpbCG+1Ajmswsbc=;
	h=Date:To:From:Subject:From;
	b=YCPUJlG/5JeVPAErcp5hltOGJEJRBWC0qI+FjSVR107qkfB8lhdwVpIuAaRxhoEls
	 2hrBxnllogLxW6fay3AnNbG3Th+6WRurjqQEWrTMgB0bJrVzLTc9zxVK/vz+p4QcXH
	 S7GB9X7fEv780xQanxWl8QcxL0AgIk3AxLCnQpQ0=
Date: Sun, 16 Nov 2025 17:35:11 -0800
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,stable@vger.kernel.org,davidgow@google.com,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-tests-vaddr-kunit-handle-alloc-failures-on-damon_test_split_evenly_succ.patch removed from -mm tree
Message-Id: <20251117013512.52E68C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/tests/vaddr-kunit: handle alloc failures on damon_test_split_evenly_succ()
has been removed from the -mm tree.  Its filename was
     mm-damon-tests-vaddr-kunit-handle-alloc-failures-on-damon_test_split_evenly_succ.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/tests/vaddr-kunit: handle alloc failures on damon_test_split_evenly_succ()
Date: Sat, 1 Nov 2025 11:20:13 -0700

damon_test_split_evenly_succ() is assuming all dynamic memory allocation
in it will succeed.  Those are indeed likely in the real use cases since
those allocations are too small to fail, but theoretically those could
fail.  In the case, inappropriate memory access can happen.  Fix it by
appropriately cleanup pre-allocated memory and skip the execution of the
remaining tests in the failure cases.

Link: https://lkml.kernel.org/r/20251101182021.74868-20-sj@kernel.org
Fixes: 17ccae8bb5c9 ("mm/damon: add kunit tests")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: <stable@vger.kernel.org>	[5.15+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/vaddr-kunit.h |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/damon/tests/vaddr-kunit.h~mm-damon-tests-vaddr-kunit-handle-alloc-failures-on-damon_test_split_evenly_succ
+++ a/mm/damon/tests/vaddr-kunit.h
@@ -284,10 +284,17 @@ static void damon_test_split_evenly_succ
 	unsigned long start, unsigned long end, unsigned int nr_pieces)
 {
 	struct damon_target *t = damon_new_target();
-	struct damon_region *r = damon_new_region(start, end);
+	struct damon_region *r;
 	unsigned long expected_width = (end - start) / nr_pieces;
 	unsigned long i = 0;
 
+	if (!t)
+		kunit_skip(test, "target alloc fail");
+	r = damon_new_region(start, end);
+	if (!r) {
+		damon_free_target(t);
+		kunit_skip(test, "region alloc fail");
+	}
 	damon_add_region(r, t);
 	KUNIT_EXPECT_EQ(test,
 			damon_va_evenly_split_region(t, r, nr_pieces), 0);
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

