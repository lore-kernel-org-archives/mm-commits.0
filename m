Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1090D23771E;
	Mon, 17 Nov 2025 01:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343291; cv=none; b=ccbhROvXwb7WWZJ9+i+WqrNZGdcH2aUQF9c/9xkpjE5BP/6EWuIo1z3FBVxn4v0B1RpYgFzio8WoMWYiqjivS51PW9s4WhMUee3jkogltV78XkAmIn9fvtf/pkT0Y0poy+cLt704bWmdIv/AJkTMyxnak/UD4FLKjw8MXIAxUAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343291; c=relaxed/simple;
	bh=UDWzA6wRTteBDoRpr3lD2mdIMNjjlKeYxXYWGgGrBA4=;
	h=Date:To:From:Subject:Message-Id; b=mRIw7ddXgIO6kEJ4Z+1znd0RMNbmYPhZKcRaE3KpJXwHg6z9VZzTfR0CNh9VwonBY1akNRaoHS/AAgprsJ6sYvPsRraTAkK6qnbY9oHX/cY8KtHX+FIXtmuRlOeevu170n9jo4HqNWv4YQnGadac4vz7eDBDDc9kYHtjpq/YezE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M8HOsodR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M8HOsodR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCA21C4CEF1;
	Mon, 17 Nov 2025 01:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343290;
	bh=UDWzA6wRTteBDoRpr3lD2mdIMNjjlKeYxXYWGgGrBA4=;
	h=Date:To:From:Subject:From;
	b=M8HOsodRfwRi85ydiEGPMpNRwgLdWLu8xEiPm2Zl04dGH7TR9scWUYyPnl9dNwgBV
	 aiYiayPIceRnKvnkS83jbErbZsCGKKvrmcH/pnT/M+pSLFHbKGq5A5Z1Y1fzIZTR+d
	 61Duzo4+pkwnDKUClChCyOL7FfWbz6+dZRHzs4yY=
Date: Sun, 16 Nov 2025 17:34:50 -0800
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,stable@vger.kernel.org,davidgow@google.com,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-tests-core-kunit-fix-memory-leak-in-damon_test_set_filters_default_reject.patch removed from -mm tree
Message-Id: <20251117013450.DCA21C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/tests/core-kunit: fix memory leak in damon_test_set_filters_default_reject()
has been removed from the -mm tree.  Its filename was
     mm-damon-tests-core-kunit-fix-memory-leak-in-damon_test_set_filters_default_reject.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/tests/core-kunit: fix memory leak in damon_test_set_filters_default_reject()
Date: Sat, 1 Nov 2025 11:19:55 -0700

Patch series "mm/damon/tests: fix memory bugs in kunit tests".

DAMON kunit tests were initially written assuming those will be run on
environments that are well controlled and therefore tolerant to transient
test failures and bugs in the test code itself.  The user-mode linux based
manual run of the tests is one example of such an environment.  And the
test code was written for adding more test coverage as fast as possible,
over making those safe and reliable.

As a result, the tests resulted in having a number of bugs including real
memory leaks, theoretical unhandled memory allocation failures, and unused
memory allocations.  The allocation failures that are not handled well are
unlikely in the real world, since those allocations are too small to fail.
But in theory, it can happen and cause inappropriate memory access.

It is arguable if bugs in test code can really harm users.  But, anyway
bugs are bugs that need to be fixed.  Fix the bugs one by one.  Also Cc
stable@ for the fixes of memory leak and unhandled memory allocation
failures.  The unused memory allocations are only a matter of memory
efficiency, so not Cc-ing stable@.

The first patch fixes memory leaks in the test code for the DAMON core
layer.

Following fifteen, three, and one patches respectively fix unhandled
memory allocation failures in the test code for DAMON core layer, virtual
address space DAMON operation set, and DAMON sysfs interface, one by one
per test function.

Final two patches remove memory allocations that are correctly deallocated
at the end, but not really being used by any code.


This patch (of 22):

Kunit test function for damos_set_filters_default_reject() allocates two
'struct damos_filter' objects and not deallocates those, so that the
memory for the two objects are leaked for every time the test runs.  Fix
this by deallocating those objects at the end of the test code.

Link: https://lkml.kernel.org/r/20251101182021.74868-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20251101182021.74868-2-sj@kernel.org
Fixes: 094fb14913c7 ("mm/damon/tests/core-kunit: add a test for damos_set_filters_default_reject()")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: <stable@vger.kernel.org>	[6.16+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/core-kunit.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-fix-memory-leak-in-damon_test_set_filters_default_reject
+++ a/mm/damon/tests/core-kunit.h
@@ -598,6 +598,9 @@ static void damon_test_set_filters_defau
 	 */
 	KUNIT_EXPECT_EQ(test, scheme.core_filters_default_reject, false);
 	KUNIT_EXPECT_EQ(test, scheme.ops_filters_default_reject, true);
+
+	damos_free_filter(anon_filter);
+	damos_free_filter(target_filter);
 }
 
 static struct kunit_case damon_test_cases[] = {
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

