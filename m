Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E4C023182D
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343315; cv=none; b=VlkNY8oUHbFNydgoUTbtXlvYtok9FADnZKIriZpTalkwOkh7iz52IQ/Apc8HRpRZoyDx+m2D1cqYTE67oRV1Se5DKiXTuHprDaKSEPhLiBqmkDc1zK2QkTzretEMrKyHA0sDx3D64TNiA+a1jWgQ6g9lX0hOBqfv/HeCSqjjgtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343315; c=relaxed/simple;
	bh=9px8qpCBB5RSa4FF66U1ENpR3ypI41eK+8Iy1+4nd7A=;
	h=Date:To:From:Subject:Message-Id; b=a8Z/5rYdEbtz4m4u4Bjs2+J9REU5jyaWVpv5k6hTvE8KH/seL2b2WMQ2o4tCXKZJgjdEor5dc3hCu86AHQcGLNXcqY1KudaMPyNQSAXt5bw47ue+wQNfoZX6WOY1UzKjNzkZeaaoc2iqGmuiIIbtTl+V0UkbUecFJGIA5pBse20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0puKTYI7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0puKTYI7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92682C116D0;
	Mon, 17 Nov 2025 01:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343314;
	bh=9px8qpCBB5RSa4FF66U1ENpR3ypI41eK+8Iy1+4nd7A=;
	h=Date:To:From:Subject:From;
	b=0puKTYI7/n2EqCXAra172r/w+PLEgOJlvluG0AiWoiOdROUihkRT/IPFfs2D0IPgC
	 QE1Sd3WPVlQIOmfqCyJzUqb2W3VubPdYhR8NI4k4rNsysVZVNxyMCPTgThPc0CuYDA
	 GqKcAw1xD7L827QFZDhmrNl4sccftZrIhGTQuitQ=
Date: Sun, 16 Nov 2025 17:35:14 -0800
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,davidgow@google.com,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-tests-core-kunit-remove-unnecessary-damon_ctx-variable-on-damon_test_split_at.patch removed from -mm tree
Message-Id: <20251117013514.92682C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/tests/core-kunit: remove unnecessary damon_ctx variable on damon_test_split_at()
has been removed from the -mm tree.  Its filename was
     mm-damon-tests-core-kunit-remove-unnecessary-damon_ctx-variable-on-damon_test_split_at.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/tests/core-kunit: remove unnecessary damon_ctx variable on damon_test_split_at()
Date: Sat, 1 Nov 2025 11:20:15 -0700

damon_test_split_at() dynamically allocates a 'struct damon_ctx' object,
but it is not really being used in the code other than handling the
allocation failure and deallocating it at the end of the function.  Remove
the unnecessary allocation and deallocation of the object.

Link: https://lkml.kernel.org/r/20251101182021.74868-22-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/core-kunit.h |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-remove-unnecessary-damon_ctx-variable-on-damon_test_split_at
+++ a/mm/damon/tests/core-kunit.h
@@ -144,20 +144,14 @@ static void damon_test_aggregate(struct
 
 static void damon_test_split_at(struct kunit *test)
 {
-	struct damon_ctx *c = damon_new_ctx();
 	struct damon_target *t;
 	struct damon_region *r, *r_new;
 
-	if (!c)
-		kunit_skip(test, "ctx alloc fail");
 	t = damon_new_target();
-	if (!t) {
-		damon_destroy_ctx(c);
+	if (!t)
 		kunit_skip(test, "target alloc fail");
-	}
 	r = damon_new_region(0, 100);
 	if (!r) {
-		damon_destroy_ctx(c);
 		damon_free_target(t);
 		kunit_skip(test, "region alloc fail");
 	}
@@ -178,7 +172,6 @@ static void damon_test_split_at(struct k
 	KUNIT_EXPECT_EQ(test, r->last_nr_accesses, r_new->last_nr_accesses);
 
 	damon_free_target(t);
-	damon_destroy_ctx(c);
 }
 
 static void damon_test_merge_two(struct kunit *test)
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

