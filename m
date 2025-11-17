Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E3C423C8A0;
	Mon, 17 Nov 2025 01:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343308; cv=none; b=cF8goIAtC9FdifIFbnodBRrAge33v4l0EhH1I5bRChbVXX1kUWMRSPSwKyjJMS2MyC8QPVSpnlg6qJQA7uItkTswEQ6exH6PzCDeuwvKdeNpRoJaR/VI+RnXjSRswnWLcoozCTmPLifxppGRRpbOvTPpM47RSfTqgmTJ9/P/5No=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343308; c=relaxed/simple;
	bh=mbaZS8IB+QQmfaN9lkdRGmniJY0SONWus2ihuLnqVlM=;
	h=Date:To:From:Subject:Message-Id; b=g4En7yBJuooJCD8vm/UKv+/xUvSwdofpmZurc/Bu86Qs7RjWCt65BI9ImSZ3QIBV1JuZxTIbUb3p7YFLelojQHRYp1W2auPtbiOUvQftEDlCmZqTcDwlXFqaiNJIwH/fY7EXecBMdDuEPEkaj1oSsDCnxZNxJDPkzkHj2uw3Jgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LOYmNZQ2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LOYmNZQ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B436AC113D0;
	Mon, 17 Nov 2025 01:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343307;
	bh=mbaZS8IB+QQmfaN9lkdRGmniJY0SONWus2ihuLnqVlM=;
	h=Date:To:From:Subject:From;
	b=LOYmNZQ2oP60ZuQhtUir2yCj1AOZM7v7J8OYpOoQ/yd+0aRmxT2nmnkcioNLVV+BT
	 EnKsVLPSqkOLk1SU0V/f1fsIdKjbsZ960Xm8dcPi+unUkGO7AnNTtGYROyXBLHNikW
	 eoCahPU8Cld+81HJcXRFu6VxLiGdbSSlD69XO7mQ=
Date: Sun, 16 Nov 2025 17:35:07 -0800
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,stable@vger.kernel.org,davidgow@google.com,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-tests-core-kunit-handle-alloc-failures-on-damos_test_filter_out.patch removed from -mm tree
Message-Id: <20251117013507.B436AC113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/tests/core-kunit: handle alloc failures on damos_test_filter_out()
has been removed from the -mm tree.  Its filename was
     mm-damon-tests-core-kunit-handle-alloc-failures-on-damos_test_filter_out.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/tests/core-kunit: handle alloc failures on damos_test_filter_out()
Date: Sat, 1 Nov 2025 11:20:09 -0700

damon_test_filter_out() is assuming all dynamic memory allocation in it
will succeed.  Those are indeed likely in the real use cases since those
allocations are too small to fail, but theoretically those could fail.  In
the case, inappropriate memory access can happen.  Fix it by appropriately
cleanup pre-allocated memory and skip the execution of the remaining tests
in the failure cases.

Link: https://lkml.kernel.org/r/20251101182021.74868-16-sj@kernel.org
Fixes: 26713c890875 ("mm/damon/core-test: add a unit test for __damos_filter_out()")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: <stable@vger.kernel.org>	[6.6+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/core-kunit.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-handle-alloc-failures-on-damos_test_filter_out
+++ a/mm/damon/tests/core-kunit.h
@@ -542,11 +542,22 @@ static void damos_test_filter_out(struct
 	struct damos_filter *f;
 
 	f = damos_new_filter(DAMOS_FILTER_TYPE_ADDR, true, false);
+	if (!f)
+		kunit_skip(test, "filter alloc fail");
 	f->addr_range = (struct damon_addr_range){
 		.start = DAMON_MIN_REGION * 2, .end = DAMON_MIN_REGION * 6};
 
 	t = damon_new_target();
+	if (!t) {
+		damos_destroy_filter(f);
+		kunit_skip(test, "target alloc fail");
+	}
 	r = damon_new_region(DAMON_MIN_REGION * 3, DAMON_MIN_REGION * 5);
+	if (!r) {
+		damos_destroy_filter(f);
+		damon_free_target(t);
+		kunit_skip(test, "region alloc fail");
+	}
 	damon_add_region(r, t);
 
 	/* region in the range */
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

