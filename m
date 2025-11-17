Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FC6D25B687;
	Mon, 17 Nov 2025 01:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343309; cv=none; b=ZgsSSZLz8xWagX7hGOITomG5bQyVMqJs2GUu59/VZG41P8U5aRBeXZgYjXUVOz1d1y56Rm8oN8Q49LiNIQBWdgkMz5qcSr9flal/NlRoip/ElS9fFMuQbpgJyVj4vGV8cdlSbvZW9EK/rXaDqULnxP030t9mK6MKQ4WdfBCZb88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343309; c=relaxed/simple;
	bh=w32szzMnf0x64oCIpqCXsz8cLmkxbnJMTK39uk0SpII=;
	h=Date:To:From:Subject:Message-Id; b=TgdMXRPB5Gv+iBgj+FJTVZ6c8sf8WA/eq8qplsC1U+6GqbxwXd8pL1IVgTzyr9DL6Gui8WVvmgjNVKJwXkutpkDC+3V+jtLn6d7YxFVdVW6/gnm2uxwmAEaqTjEZIpnBH7WiqNON3ORr+uX7JUcy19YDGVMSE5T93fRZ3GOM+o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b4Ty53kD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b4Ty53kD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E185AC19422;
	Mon, 17 Nov 2025 01:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343309;
	bh=w32szzMnf0x64oCIpqCXsz8cLmkxbnJMTK39uk0SpII=;
	h=Date:To:From:Subject:From;
	b=b4Ty53kDazGEZcW0ZRPkFFJsCanXh0ZDSRjRAqyKlO4KFGjg1jgdlMLelKBIcDwnt
	 BJQfL3oMFyFKunBfNMz0WPzbg8o/B4JI53oK40rxcwXON8363GIGyEv3YP4t0AmdFD
	 pPTHAPerB0qUgwd+Q4U/Hx/t2qRBYNpPjzDaiGNs=
Date: Sun, 16 Nov 2025 17:35:08 -0800
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,stable@vger.kernel.org,davidgow@google.com,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-tests-core-kunit-handle-alloc-failures-on-damon_test_set_filters_default_reject.patch removed from -mm tree
Message-Id: <20251117013508.E185AC19422@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/tests/core-kunit: handle alloc failures on damon_test_set_filters_default_reject()
has been removed from the -mm tree.  Its filename was
     mm-damon-tests-core-kunit-handle-alloc-failures-on-damon_test_set_filters_default_reject.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/tests/core-kunit: handle alloc failures on damon_test_set_filters_default_reject()
Date: Sat, 1 Nov 2025 11:20:10 -0700

damon_test_set_filters_default_reject() is assuming all dynamic memory
allocation in it will succeed.  Those are indeed likely in the real use
cases since those allocations are too small to fail, but theoretically
those could fail.  In the case, inappropriate memory access can happen. 
Fix it by appropriately cleanup pre-allocated memory and skip the
execution of the remaining tests in the failure cases.

Link: https://lkml.kernel.org/r/20251101182021.74868-17-sj@kernel.org
Fixes: 094fb14913c7 ("mm/damon/tests/core-kunit: add a test for damos_set_filters_default_reject()")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: <stable@vger.kernel.org>	[6.16+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/core-kunit.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-handle-alloc-failures-on-damon_test_set_filters_default_reject
+++ a/mm/damon/tests/core-kunit.h
@@ -659,6 +659,8 @@ static void damon_test_set_filters_defau
 	KUNIT_EXPECT_EQ(test, scheme.ops_filters_default_reject, false);
 
 	target_filter = damos_new_filter(DAMOS_FILTER_TYPE_TARGET, true, true);
+	if (!target_filter)
+		kunit_skip(test, "filter alloc fail");
 	damos_add_filter(&scheme, target_filter);
 	damos_set_filters_default_reject(&scheme);
 	/*
@@ -684,6 +686,10 @@ static void damon_test_set_filters_defau
 	KUNIT_EXPECT_EQ(test, scheme.ops_filters_default_reject, false);
 
 	anon_filter = damos_new_filter(DAMOS_FILTER_TYPE_ANON, true, true);
+	if (!anon_filter) {
+		damos_free_filter(target_filter);
+		kunit_skip(test, "anon_filter alloc fail");
+	}
 	damos_add_filter(&scheme, anon_filter);
 
 	damos_set_filters_default_reject(&scheme);
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

