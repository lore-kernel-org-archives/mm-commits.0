Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D249F23FC5A;
	Mon, 17 Nov 2025 01:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343294; cv=none; b=VV3LffptMeGSg2CJtibUlB5ZLrXU9nUJFlgiHl0pIy5ZIslRGqerQG0dFPBOGgDC06lwbwWiJpPRFXMgBRTOh+WUi7JBO8T85hvhq1z7bB4LaOkWtwUPDZAe+TsZ3JOLUFm02ZmL0dnTdPBB5a/vnGzNYtObsNWu/dQtEdFRKDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343294; c=relaxed/simple;
	bh=tKF3aMZBHmEeYn4qHlfqnU3CSAiMdUMbExeb9zR2TZM=;
	h=Date:To:From:Subject:Message-Id; b=g5VfHC6NcS3NlOkHSQyl96w99sFZ+ox1wmeQNdO8MMbUBkNGPkTLBXAZiZ+/DgccqD1XZdGL4XUWBC9fXDuIuvZz9ymLNxx3R5HMB9Bkvhu/imcTSanjSMvs9xwhoCZ/X0qJlzGHbLj9LfS+ICBob1muYYub2y+FATocik1ZEbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=redFvkEr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="redFvkEr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64AEDC19425;
	Mon, 17 Nov 2025 01:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343294;
	bh=tKF3aMZBHmEeYn4qHlfqnU3CSAiMdUMbExeb9zR2TZM=;
	h=Date:To:From:Subject:From;
	b=redFvkErmLJq1wED63/blVRBUm2WeVR3v3BC+NnFIxOgeVSK+EYpFQbtMcawcjgU0
	 8wtWfOSQDm3awd+bimQgDEpiiHzqsoWFB3Wg38o7Myz0vESaoe2Ho3W1fuBLnPXrQ0
	 r4gNs2ceHnBDpBcW2CFcHBZcMmPyEzwpZCGu3/KM=
Date: Sun, 16 Nov 2025 17:34:53 -0800
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,stable@vger.kernel.org,davidgow@google.com,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-tests-core-kunit-handle-memory-alloc-failure-from-damon_test_aggregate.patch removed from -mm tree
Message-Id: <20251117013454.64AEDC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/tests/core-kunit: handle memory alloc failure from damon_test_aggregate()
has been removed from the -mm tree.  Its filename was
     mm-damon-tests-core-kunit-handle-memory-alloc-failure-from-damon_test_aggregate.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/tests/core-kunit: handle memory alloc failure from damon_test_aggregate()
Date: Sat, 1 Nov 2025 11:19:58 -0700

damon_test_aggregate() is assuming all dynamic memory allocation in it
will succeed.  Those are indeed likely in the real use cases since those
allocations are too small to fail, but theoretically those could fail.  In
the case, inappropriate memory access can happen.  Fix it by appropriately
cleanup pre-allocated memory and skip the execution of the remaining tests
in the failure cases.

Link: https://lkml.kernel.org/r/20251101182021.74868-5-sj@kernel.org
Fixes: 17ccae8bb5c9 ("mm/damon: add kunit tests")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: <stable@vger.kernel.org>	[5.15+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/core-kunit.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-handle-memory-alloc-failure-from-damon_test_aggregate
+++ a/mm/damon/tests/core-kunit.h
@@ -97,8 +97,15 @@ static void damon_test_aggregate(struct
 	struct damon_region *r;
 	int it, ir;
 
+	if (!ctx)
+		kunit_skip(test, "ctx alloc fail");
+
 	for (it = 0; it < 3; it++) {
 		t = damon_new_target();
+		if (!t) {
+			damon_destroy_ctx(ctx);
+			kunit_skip(test, "target alloc fail");
+		}
 		damon_add_target(ctx, t);
 	}
 
@@ -106,6 +113,10 @@ static void damon_test_aggregate(struct
 	damon_for_each_target(t, ctx) {
 		for (ir = 0; ir < 3; ir++) {
 			r = damon_new_region(saddr[it][ir], eaddr[it][ir]);
+			if (!r) {
+				damon_destroy_ctx(ctx);
+				kunit_skip(test, "region alloc fail");
+			}
 			r->nr_accesses = accesses[it][ir];
 			r->nr_accesses_bp = accesses[it][ir] * 10000;
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

