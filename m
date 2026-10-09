Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB5D3F8EA2
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525373; cv=none; b=AkRyl9Xu5qRcG1vZTCBSv694fkAaz8nrFUK5vwBL7kgcnXAwPlq7ypOYOuVIWYOvWfHTa50oeoTncHmVyPvL0nhXAXwWCNFbwGNIx9EWFJaH1PUgIUDcdzM1AxIXxDzatadslHB4UBQ6Jz6xajKpOY4Hys6jd0m3hgA1EssOcxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525373; c=relaxed/simple;
	bh=ADaKipwOke9eELeqMEzHPHfJophJb+NkLdNsN0oWCxI=;
	h=Date:To:From:Subject:Message-Id; b=ofxIwDhOHGCtYOcNe070hjbH1028zR2e1cNUmNqw9hkuK5LZc0xWYFfQjIU/4mBngqxn6BtxcR9aAVJ2cUuoREDebYbrt6U9BiYricpssi+weBzL5T799T347NjSxYsJWuyjwjDeNA0beFNTTQv4qDBkpNgzxQqqymakFA1WI00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zJLPMKpM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zJLPMKpM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F4541F00893;
	Fri,  9 Oct 2026 05:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525371;
	bh=DeOP+8ZXchcunB4FcAcgdMcKGb0LtJ0DMxRCdSX7ieE=;
	h=Date:To:From:Subject;
	b=zJLPMKpMyCveI49oMt0tApunjwaZ4tciNq4yaS75Npl0sZlBYXN2vCuRLfqAIRsNY
	 kXobD0Pmw/63FTE/Mh3zCAaCKJisnH4lqvXWR1cY/jy5lNnHe986cBHOd271o8/+fP
	 Fr+mP8ytbkYo2+rjnXVL97VNu/AF2lcGY/FYzco8=
Date: Thu, 08 Oct 2026 22:56:10 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,rdunlap@infradead.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kunwu.chan@gmail.com,david@kernel.org,davidgow@davidgow.net,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-tests-core-kunit-extend-set_regions-test-for-error-case.patch removed from -mm tree
Message-Id: <20261009055611.0F4541F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/tests/core-kunit: extend set_regions() test for error case
has been removed from the -mm tree.  Its filename was
     mm-damon-tests-core-kunit-extend-set_regions-test-for-error-case.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/tests/core-kunit: extend set_regions() test for error case
Date: Tue, 1 Sep 2026 22:47:39 -0700

damon_test_set_regions_for() is designed to test only success-expected
damon_set_regions() calls.  Extend it to cover error-expected calls, too.

Link: https://lore.kernel.org/20260902054747.99370-7-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@davidgow.net>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Kunwu Chan <kunwu.chan@gmail.com>
---

 mm/damon/tests/core-kunit.h |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-extend-set_regions-test-for-error-case
+++ a/mm/damon/tests/core-kunit.h
@@ -469,11 +469,12 @@ static void damon_test_set_regions_for(s
 		struct damon_addr_range *old_ranges, int sz_old_ranges,
 		struct damon_addr_range *new_ranges, int sz_new_ranges,
 		unsigned long min_region_sz,
-		struct damon_addr_range *expect_ranges, int sz_expect_ranges)
+		struct damon_addr_range *expect_ranges, int sz_expect_ranges,
+		int expect_err)
 {
 	struct damon_target *t;
 	struct damon_region *r;
-	int i;
+	int i, err;
 
 	t = damon_new_target();
 	if (!t)
@@ -487,7 +488,8 @@ static void damon_test_set_regions_for(s
 		damon_add_region(r, t);
 	}
 
-	damon_set_regions(t, new_ranges, sz_new_ranges, min_region_sz);
+	err = damon_set_regions(t, new_ranges, sz_new_ranges, min_region_sz);
+	KUNIT_EXPECT_EQ(test, err, expect_err);
 
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), sz_expect_ranges);
 	if (damon_nr_regions(t) != sz_expect_ranges) {
@@ -516,7 +518,7 @@ static void damon_test_set_regions(struc
 			(struct damon_addr_range[]){
 			{.start = 5, .end = 15},
 			{.start = 15, .end = 25},
-			}, 2);
+			}, 2, 0);
 	/* Un-intersecting regions should be removed. */
 	damon_test_set_regions_for(test,
 			(struct damon_addr_range[]){
@@ -529,7 +531,7 @@ static void damon_test_set_regions(struc
 			1,
 			(struct damon_addr_range[]){
 			{.start = 18, .end = 23},
-			}, 1);
+			}, 1, 0);
 	/*
 	 * Holes should be filled up with new regions.
 	 *
@@ -550,7 +552,7 @@ static void damon_test_set_regions(struc
 			{.start = 8, .end = 16},
 			{.start = 16, .end = 24},
 			{.start = 24, .end = 28},
-			}, 3);
+			}, 3, 0);
 	/*
 	 * New regions should be able to be appended.
 	 *
@@ -572,7 +574,7 @@ static void damon_test_set_regions(struc
 			{.start = 0, .end = 4},
 			{.start = 4, .end = 15},
 			{.start = 25, .end = 40},
-			}, 3);
+			}, 3, 0);
 	/*
 	 * New regions should be able to be inserted.
 	 *
@@ -595,7 +597,7 @@ static void damon_test_set_regions(struc
 			{.start = 0, .end = 15},
 			{.start = 25, .end = 40},
 			{.start = 44, .end = 50},
-			}, 3);
+			}, 3, 0);
 }
 
 static void damon_test_update_monitoring_result(struct kunit *test)
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-schemes-read-sysfs_filter-addr_range-only-once.patch
mm-damon-sysfs-schemes-read-sysfs_filter-sz_range-only-once.patch
mm-damon-core-return-an-error-from-damos_commit_filter_arg.patch
mm-damon-core-disallow-max-min-damos-filter-range-arguments-commit.patch
mm-damon-sysfs-schemes-drop-centralized-filter-range-arg-validations.patch
mm-damon-sysfs-schemes-use-switch-case-in-add_scheme_filters.patch
mm-damon-core-kunit-extend-damos_commit_filter_for-for-wrong-input.patch
mm-damon-core-kunit-test-invalid-damos-filter-commits.patch
mm-damon-api-introduce-damon_filter_type_hugepage_size.patch
mm-damon-core-commit-hugepage_size-type-damon-filter.patch
mm-damon-ops-common-support-hugepage_size-damon-filter-matching.patch
mm-damon-sysfs-add-minmax-files-under-probe-filter-directory.patch
mm-damon-sysfs-support-hugepage_size-probe-filter.patch
docs-mm-damon-design-update-for-hugepage_size-probe-filter.patch
docs-admin-guide-mm-damon-usage-update-for-hugepage_size.patch
docs-abi-damon-update-for-hugepage_size-probe-filter.patch
mm-damon-api-remove-nr_damos_filter_types.patch
mm-damon-core-use-abs_diff-in-damon_feed_loop_next_input.patch
mm-damon-core-use-mult_frac-in-damon_feed_loop_next_input.patch
mm-damon-core-set-damon_ctx-walk_control_obsolete-in-damon_new_ctx.patch
mm-damon-core-document-damon_call-damon_start-race-hang-issue.patch
mm-damon-paddr-remove-pa-parameter-from-damon_pa_filter_pass.patch
mm-damon-tests-core-kunit-test-eligible_mem_bp-commitment.patch
mm-damon-tests-core-kunit-add-probe_hits_wsum-damos-filter-commit-test.patch
selftests-damon-sysfs_memcg_path_leak-fail-only-for-real-damon-leak.patch
docs-mm-damon-design-clarify-bp-is-basis-point.patch
mm-damon-core-introduce-damos_quota_goal-complement.patch
mm-damon-core-add-complement-argument-to-damos_new_quota_goal.patch
mm-damon-sysfs-schemes-support-quota-goal-complement-flag.patch
mm-damon-tests-core-kunit-test-quota_goal-complement-commit.patch
selftests-damon-sysfssh-test-quota-goal-complement-flag-file.patch
docs-mm-damon-design-document-damos-quota-goal-complement-flag.patch
docs-admin-guide-mm-damon-usage-update-for-quota-goal-complement-file.patch
docs-abi-damon-update-for-quota-goal-metric-complement-sysfs-file.patch

