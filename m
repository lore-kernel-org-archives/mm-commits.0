Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38D30256C61;
	Mon, 17 Nov 2025 01:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343303; cv=none; b=HfVuW8wqMc1vtBXhGp3zhNQ+HieKBhMbGr0G2vLhaccfDsT9eonR0lMAkSFFc4KFIQ39hq96cDMOWoNUpetlfIWomS13QCN+PzHBxsNsoXv0YRmNshC+vAefOi3zz1jud7BwMj4Nm+6iwdjJKUYqylo6jN3AzMbQIuf1OPY/v0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343303; c=relaxed/simple;
	bh=S+4CKAi4gFZqzHBXlGpJWC5gFVTDCZkXwR56GICFrNs=;
	h=Date:To:From:Subject:Message-Id; b=jKDEHJg9l2u326dT8tIWTEFBMj7YdudjSm7xOxkC1RoirVw+QefvZwCdkhr/w1QX4E+rP53Wt+27uwQWrSly7ZH/eL8Npc0j5xJOpWbb+SGehtiBocPiz0xeqCiETKNTXFEd8OdV/u1BbS0Cuyy6A7c1le+snmN/4ttKj23XYJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x2PdJK8C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x2PdJK8C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF83AC19422;
	Mon, 17 Nov 2025 01:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343303;
	bh=S+4CKAi4gFZqzHBXlGpJWC5gFVTDCZkXwR56GICFrNs=;
	h=Date:To:From:Subject:From;
	b=x2PdJK8C58CTg27tm3dwE6hPQ2TUi9u5O195UYiHTtyPzpYBLlDTBpdnTlRJHlb+H
	 /LUt+v2HRzhE2K83O/kVjBDCV8fSh8HmwxiiyOfy2B9CN7S8eAsXrd1BDuEZW6Qw9S
	 Haxpr6I7RhC9dSDoCDtPSDwKYw8/UufhU378Jyfk=
Date: Sun, 16 Nov 2025 17:35:02 -0800
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,stable@vger.kernel.org,davidgow@google.com,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-tests-core-kunit-handle-alloc-failures-in-damon_test_update_monitoring_result.patch removed from -mm tree
Message-Id: <20251117013502.DF83AC19422@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/tests/core-kunit: handle alloc failures in damon_test_update_monitoring_result()
has been removed from the -mm tree.  Its filename was
     mm-damon-tests-core-kunit-handle-alloc-failures-in-damon_test_update_monitoring_result.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/tests/core-kunit: handle alloc failures in damon_test_update_monitoring_result()
Date: Sat, 1 Nov 2025 11:20:05 -0700

damon_test_update_monitoring_result() is assuming all dynamic memory
allocation in it will succeed.  Those are indeed likely in the real use
cases since those allocations are too small to fail, but theoretically
those could fail.  In the case, inappropriate memory access can happen. 
Fix it by appropriately cleanup pre-allocated memory and skip the
execution of the remaining tests in the failure cases.

Link: https://lkml.kernel.org/r/20251101182021.74868-12-sj@kernel.org
Fixes: f4c978b6594b ("mm/damon/core-test: add a test for damon_update_monitoring_results()")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: <stable@vger.kernel.org>	[6.3+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/core-kunit.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-handle-alloc-failures-in-damon_test_update_monitoring_result
+++ a/mm/damon/tests/core-kunit.h
@@ -429,6 +429,9 @@ static void damon_test_update_monitoring
 	struct damon_attrs new_attrs;
 	struct damon_region *r = damon_new_region(3, 7);
 
+	if (!r)
+		kunit_skip(test, "region alloc fail");
+
 	r->nr_accesses = 15;
 	r->nr_accesses_bp = 150000;
 	r->age = 20;
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

