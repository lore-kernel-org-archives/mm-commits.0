Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC2323182D
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343315; cv=none; b=n4/oiir5NywNAyrMxRQktaY8y6KNeh4Vdp7yhREellyOApI/LY7xgZCC8OQS2Dbj6QQ/9Rq9o1/VlhAjOhL1Tl/N622VdMHsRtVbnTcigPQWBRv/ot062pJ/STBnlwAhgAyqIX+JvRJMsa3CEqXvuTukbLkt9lM19Yn/bOLXYlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343315; c=relaxed/simple;
	bh=quEUO0NDJA/2fnxrilHZAwlWxubPElDXe36A5TCssPM=;
	h=Date:To:From:Subject:Message-Id; b=aCz6gMbwfa84R4nT1iygJ+ph4kC2m8FbsyI91gNDFXpOePc1nPfbug+2xiKnCETI+XydyW2BqfvVcVJeWkwtMIc66fKh0wGilt7Y1KGtlvmBRrHLmdIrEvIPv+XdEKViwvFJzc67/gw4cYFf4/KauIHXmT/cGwcMr8dWbC2kpbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=szDnifT6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="szDnifT6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEB8EC19422;
	Mon, 17 Nov 2025 01:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343315;
	bh=quEUO0NDJA/2fnxrilHZAwlWxubPElDXe36A5TCssPM=;
	h=Date:To:From:Subject:From;
	b=szDnifT67UBNJYe8UBxdyRsheOuOQ1xXSWAqg/xdeNba2mBb4Z0axsh/O0PJk4UFo
	 ToXcDR9nyy1GYN0g0My80ufuvJAnPhHni5IrFMvgLj51QE25cI7EYWn5v6YcCjo+cI
	 WEV+yqUinLdT4tUI2xhfAgZLMUAMehJI5OH3VYYw=
Date: Sun, 16 Nov 2025 17:35:15 -0800
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,davidgow@google.com,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-tests-core-kunit-remove-unused-ctx-in-damon_test_split_regions_of.patch removed from -mm tree
Message-Id: <20251117013515.AEB8EC19422@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/tests/core-kunit: remove unused ctx in damon_test_split_regions_of()
has been removed from the -mm tree.  Its filename was
     mm-damon-tests-core-kunit-remove-unused-ctx-in-damon_test_split_regions_of.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/tests/core-kunit: remove unused ctx in damon_test_split_regions_of()
Date: Sat, 1 Nov 2025 11:20:16 -0700

damon_test_split_regions_of() dynamically allocates a 'struct damon_ctx'
object, but it is not really being used in the code other than handling
the allocation failure and deallocating it at the end of the function. 
Remove the unnecessary allocation and deallocation of the object.

Link: https://lkml.kernel.org/r/20251101182021.74868-23-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/core-kunit.h |   14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-remove-unused-ctx-in-damon_test_split_regions_of
+++ a/mm/damon/tests/core-kunit.h
@@ -267,20 +267,14 @@ static void damon_test_merge_regions_of(
 
 static void damon_test_split_regions_of(struct kunit *test)
 {
-	struct damon_ctx *c = damon_new_ctx();
 	struct damon_target *t;
 	struct damon_region *r;
 
-	if (!c)
-		kunit_skip("ctx alloc fail");
 	t = damon_new_target();
-	if (!t) {
-		damon_destroy_ctx(c);
+	if (!t)
 		kunit_skip(test, "target alloc fail");
-	}
 	r = damon_new_region(0, 22);
 	if (!r) {
-		damon_destroy_ctx(c);
 		damon_free_target(t);
 		kunit_skip(test, "region alloc fail");
 	}
@@ -290,13 +284,10 @@ static void damon_test_split_regions_of(
 	damon_free_target(t);
 
 	t = damon_new_target();
-	if (!t) {
-		damon_destroy_ctx(c);
+	if (!t)
 		kunit_skip(test, "second target alloc fail");
-	}
 	r = damon_new_region(0, 220);
 	if (!r) {
-		damon_destroy_ctx(c);
 		damon_free_target(t);
 		kunit_skip(test, "second region alloc fail");
 	}
@@ -304,7 +295,6 @@ static void damon_test_split_regions_of(
 	damon_split_regions_of(t, 4, DAMON_MIN_REGION);
 	KUNIT_EXPECT_LE(test, damon_nr_regions(t), 4u);
 	damon_free_target(t);
-	damon_destroy_ctx(c);
 }
 
 static void damon_test_ops_registration(struct kunit *test)
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

