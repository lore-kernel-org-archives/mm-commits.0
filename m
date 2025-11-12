Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 307F435028E
	for <mm-commits@vger.kernel.org>; Wed, 12 Nov 2025 18:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762972405; cv=none; b=azpC8ggi2bQf6QH6ZE8yUMo9W2rWyRBA4vTfyFJUpWWa2tbJyIIdnMWhWyY8AtE7dge4/vhGHHB8F5W9ph8HRJpFNxiXaYTf7D2yz0C+rgZa30KF8GIsR+gVYP8FUF3nollzhrEysEK+hihGa6lDts4JrZ4o3OQiOpYnGDM3t1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762972405; c=relaxed/simple;
	bh=hQFKV/DxifeRu6tU3wKs4CGc0YtlX/AiG5OmKT+iPMc=;
	h=Date:To:From:Subject:Message-Id; b=QsileF0R5/kMAtM/fU++4GpJjW9QDd6f8WyireTr8sol6A1wTnyzxkS/VDX2hUL5AdLB3fBi1z6BjWTCwZ8VRywCC1RY1ldk9jkf0yXtTD6DcobS0vfOjiijaUMuu9kqanrWHbAl3gqTCUHEDA8/VFM2iwrB8r+CIZ1qldsUb+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2oz2mToY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2oz2mToY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97128C19421;
	Wed, 12 Nov 2025 18:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762972404;
	bh=hQFKV/DxifeRu6tU3wKs4CGc0YtlX/AiG5OmKT+iPMc=;
	h=Date:To:From:Subject:From;
	b=2oz2mToYLOziqtrBm0FIVNfkYpBQkc6ZJPonHJbMKDru5s2Raf4EXLlaep0xhruid
	 mpZ8NhQE83bdqXtq49akjfC6qlHmfCKs6WeYhfFdh180603440c/qrUV4gTHNdP8ab
	 peLgQYEcTul6aTLwiKanSwtJLTswgrfgrh8E3KjI=
Date: Wed, 12 Nov 2025 10:33:24 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,rppt@kernel.org,ojeda@kernel.org,nathan@kernel.org,morbo@google.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,justinstitt@google.com,hughd@google.com,david@kernel.org,davidgow@google.com,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-tests-core-kunit-remove-damon_min_region-redefinition.patch added to mm-new branch
Message-Id: <20251112183324.97128C19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/tests/core-kunit: remove DAMON_MIN_REGION redefinition
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-tests-core-kunit-remove-damon_min_region-redefinition.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-tests-core-kunit-remove-damon_min_region-redefinition.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/tests/core-kunit: remove DAMON_MIN_REGION redefinition
Date: Wed, 12 Nov 2025 07:41:09 -0800

A few DAMON core functions including damon_set_regions() were hard-coded
to use DAMON_MIN_REGION as their regions management granularity.  For
simple and human-readable unit tests' expectations, DAMON core layer kunit
test re-defines DAMON_MIN_REGION to '1'.

A previous patch series [1] has removed the hard-coded part but kept the
redefinition and updated related function calls to explicitly use
DAMON_MIN_REGION.  Remove the unnecessary redefinition and update relevant
function calls to pass literals (number '1') instead of the
DAMON_MIN_REGION.

Link: https://lkml.kernel.org/r/20251112154114.66053-7-sj@kernel.org
Link: https://lore.kernel.org/20250828171242.59810-1-sj@kernel.org [1]
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Bill Wendling <morbo@google.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c             |    5 ---
 mm/damon/tests/core-kunit.h |   55 ++++++++++++++++------------------
 2 files changed, 26 insertions(+), 34 deletions(-)

--- a/mm/damon/core.c~mm-damon-tests-core-kunit-remove-damon_min_region-redefinition
+++ a/mm/damon/core.c
@@ -20,11 +20,6 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/damon.h>
 
-#ifdef CONFIG_DAMON_KUNIT_TEST
-#undef DAMON_MIN_REGION
-#define DAMON_MIN_REGION 1
-#endif
-
 static DEFINE_MUTEX(damon_lock);
 static int nr_running_ctxs;
 static bool running_exclusive_ctxs;
--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-remove-damon_min_region-redefinition
+++ a/mm/damon/tests/core-kunit.h
@@ -279,7 +279,7 @@ static void damon_test_split_regions_of(
 		kunit_skip(test, "region alloc fail");
 	}
 	damon_add_region(r, t);
-	damon_split_regions_of(t, 2, DAMON_MIN_REGION);
+	damon_split_regions_of(t, 2, 1);
 	KUNIT_EXPECT_LE(test, damon_nr_regions(t), 2u);
 	damon_free_target(t);
 
@@ -292,7 +292,7 @@ static void damon_test_split_regions_of(
 		kunit_skip(test, "second region alloc fail");
 	}
 	damon_add_region(r, t);
-	damon_split_regions_of(t, 4, DAMON_MIN_REGION);
+	damon_split_regions_of(t, 4, 1);
 	KUNIT_EXPECT_LE(test, damon_nr_regions(t), 4u);
 	damon_free_target(t);
 }
@@ -373,7 +373,7 @@ static void damon_test_set_regions(struc
 
 	damon_add_region(r1, t);
 	damon_add_region(r2, t);
-	damon_set_regions(t, &range, 1, DAMON_MIN_REGION);
+	damon_set_regions(t, &range, 1, 1);
 
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 3);
 	damon_for_each_region(r, t) {
@@ -1037,15 +1037,14 @@ static void damos_test_filter_out(struct
 	f = damos_new_filter(DAMOS_FILTER_TYPE_ADDR, true, false);
 	if (!f)
 		kunit_skip(test, "filter alloc fail");
-	f->addr_range = (struct damon_addr_range){
-		.start = DAMON_MIN_REGION * 2, .end = DAMON_MIN_REGION * 6};
+	f->addr_range = (struct damon_addr_range){.start = 2, .end = 6};
 
 	t = damon_new_target();
 	if (!t) {
 		damos_destroy_filter(f);
 		kunit_skip(test, "target alloc fail");
 	}
-	r = damon_new_region(DAMON_MIN_REGION * 3, DAMON_MIN_REGION * 5);
+	r = damon_new_region(3, 5);
 	if (!r) {
 		damos_destroy_filter(f);
 		damon_free_target(t);
@@ -1054,50 +1053,48 @@ static void damos_test_filter_out(struct
 	damon_add_region(r, t);
 
 	/* region in the range */
-	KUNIT_EXPECT_TRUE(test,
-			damos_filter_match(NULL, t, r, f, DAMON_MIN_REGION));
+	KUNIT_EXPECT_TRUE(test, damos_filter_match(NULL, t, r, f, 1));
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 1);
 
 	/* region before the range */
-	r->ar.start = DAMON_MIN_REGION * 1;
-	r->ar.end = DAMON_MIN_REGION * 2;
+	r->ar.start = 1;
+	r->ar.end = 2;
 	KUNIT_EXPECT_FALSE(test,
-			damos_filter_match(NULL, t, r, f, DAMON_MIN_REGION));
+			damos_filter_match(NULL, t, r, f, 1));
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 1);
 
 	/* region after the range */
-	r->ar.start = DAMON_MIN_REGION * 6;
-	r->ar.end = DAMON_MIN_REGION * 8;
+	r->ar.start = 6;
+	r->ar.end = 8;
 	KUNIT_EXPECT_FALSE(test,
-			damos_filter_match(NULL, t, r, f, DAMON_MIN_REGION));
+			damos_filter_match(NULL, t, r, f, 1));
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 1);
 
 	/* region started before the range */
-	r->ar.start = DAMON_MIN_REGION * 1;
-	r->ar.end = DAMON_MIN_REGION * 4;
-	KUNIT_EXPECT_FALSE(test,
-			damos_filter_match(NULL, t, r, f, DAMON_MIN_REGION));
+	r->ar.start = 1;
+	r->ar.end = 4;
+	KUNIT_EXPECT_FALSE(test, damos_filter_match(NULL, t, r, f, 1));
 	/* filter should have split the region */
-	KUNIT_EXPECT_EQ(test, r->ar.start, DAMON_MIN_REGION * 1);
-	KUNIT_EXPECT_EQ(test, r->ar.end, DAMON_MIN_REGION * 2);
+	KUNIT_EXPECT_EQ(test, r->ar.start, 1);
+	KUNIT_EXPECT_EQ(test, r->ar.end, 2);
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 2);
 	r2 = damon_next_region(r);
-	KUNIT_EXPECT_EQ(test, r2->ar.start, DAMON_MIN_REGION * 2);
-	KUNIT_EXPECT_EQ(test, r2->ar.end, DAMON_MIN_REGION * 4);
+	KUNIT_EXPECT_EQ(test, r2->ar.start, 2);
+	KUNIT_EXPECT_EQ(test, r2->ar.end, 4);
 	damon_destroy_region(r2, t);
 
 	/* region started in the range */
-	r->ar.start = DAMON_MIN_REGION * 2;
-	r->ar.end = DAMON_MIN_REGION * 8;
+	r->ar.start = 2;
+	r->ar.end = 8;
 	KUNIT_EXPECT_TRUE(test,
-			damos_filter_match(NULL, t, r, f, DAMON_MIN_REGION));
+			damos_filter_match(NULL, t, r, f, 1));
 	/* filter should have split the region */
-	KUNIT_EXPECT_EQ(test, r->ar.start, DAMON_MIN_REGION * 2);
-	KUNIT_EXPECT_EQ(test, r->ar.end, DAMON_MIN_REGION * 6);
+	KUNIT_EXPECT_EQ(test, r->ar.start, 2);
+	KUNIT_EXPECT_EQ(test, r->ar.end, 6);
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 2);
 	r2 = damon_next_region(r);
-	KUNIT_EXPECT_EQ(test, r2->ar.start, DAMON_MIN_REGION * 6);
-	KUNIT_EXPECT_EQ(test, r2->ar.end, DAMON_MIN_REGION * 8);
+	KUNIT_EXPECT_EQ(test, r2->ar.start, 6);
+	KUNIT_EXPECT_EQ(test, r2->ar.end, 8);
 	damon_destroy_region(r2, t);
 
 	damon_free_target(t);
_

Patches currently in -mm which might be from sj@kernel.org are

mm-zswap-remove-unnecessary-dlen-writes-for-incompressible-pages.patch
mm-zswap-fix-typos-s-zwap-zswap.patch
mm-zswap-s-red-black-tree-xarray.patch
docs-admin-guide-mm-zswap-s-red-black-tree-xarray.patch
mm-damon-document-damos_quota_goal-nid-use-case.patch
mm-damon-add-damos-quota-goal-type-for-per-memcg-per-node-memory-usage.patch
mm-damon-core-implement-damos_quota_node_memcg_used_bp.patch
mm-damon-sysfs-schemes-implement-path-file-under-quota-goal-directory.patch
mm-damon-sysfs-schemes-support-damos_quota_node_memcg_used_bp.patch
mm-damon-core-add-damos-quota-gaol-metric-for-per-memcg-per-numa-free-memory.patch
mm-damon-sysfs-schemes-support-damos_quota_node_memcg_free_bp.patch
docs-mm-damon-design-document-damos_quota_node_memcg_usedfree_bp.patch
docs-admin-guide-mm-damon-usage-document-damos-quota-goal-path-file.patch
docs-abi-damon-document-damos-quota-goal-path-file.patch
mm-damon-core-fix-wrong-comment-of-damon_call-return-timing.patch
docs-mm-damon-design-fix-wrong-link-to-intervals-goal-section.patch
docs-admin-guide-mm-damon-stat-fix-a-typo-s-sampling-events-sampling-interval.patch
docs-admin-guide-mm-damon-usage-document-empty-target-regions-commit-behavior.patch
docs-admin-guide-mm-damon-reclaim-document-addr_unit-parameter.patch
docs-admin-guide-mm-damon-lru_sort-document-addr_unit-parameter.patch
docs-admin-guide-mm-damon-stat-document-aggr_interval_us-parameter.patch
docs-admin-guide-mm-damon-stat-document-negative-idle-time.patch
mm-damon-core-add-damon_target-obsolete-for-pin-point-removal.patch
mm-damon-sysfs-test-commit-input-against-realistic-destination.patch
mm-damon-sysfs-implement-obsolete_target-file.patch
docs-admin-guide-mm-damon-usage-document-obsolete_target-file.patch
docs-abi-damon-document-obsolete_target-sysfs-file.patch
selftests-damon-_damon_sysfs-support-obsolete_target-file.patch
drgn_dump_damon_status-dump-damon_target-obsolete.patch
sysfspy-extend-assert_ctx_committed-for-monitoring-targets.patch
selftests-damon-sysfs-add-obsolete_target-test.patch
mm-damon-tests-core-kunit-fix-memory-leak-in-damon_test_set_filters_default_reject.patch
mm-damon-tests-core-kunit-handle-allocation-failures-in-damon_test_regions.patch
mm-damon-tests-core-kunit-handle-memory-failure-from-damon_test_target.patch
mm-damon-tests-core-kunit-handle-memory-alloc-failure-from-damon_test_aggregate.patch
mm-damon-tests-core-kunit-handle-alloc-failures-on-damon_test_split_at.patch
mm-damon-tests-core-kunit-handle-alloc-failures-on-damon_test_merge_two.patch
mm-damon-tests-core-kunit-handle-alloc-failures-on-dasmon_test_merge_regions_of.patch
mm-damon-tests-core-kunit-handle-alloc-failures-on-damon_test_split_regions_of.patch
mm-damon-tests-core-kunit-handle-alloc-failures-in-damon_test_ops_registration.patch
mm-damon-tests-core-kunit-handle-alloc-failures-in-damon_test_set_regions.patch
mm-damon-tests-core-kunit-handle-alloc-failures-in-damon_test_update_monitoring_result.patch
mm-damon-tests-core-kunit-handle-alloc-failure-on-damon_test_set_attrs.patch
mm-damon-tests-core-kunit-handle-alloc-failres-in-damon_test_new_filter.patch
mm-damon-tests-core-kunit-handle-alloc-failure-on-damos_test_commit_filter.patch
mm-damon-tests-core-kunit-handle-alloc-failures-on-damos_test_filter_out.patch
mm-damon-tests-core-kunit-handle-alloc-failures-on-damon_test_set_filters_default_reject.patch
mm-damon-tests-vaddr-kunit-handle-alloc-failures-on-damon_do_test_apply_three_regions.patch
mm-damon-tests-vaddr-kunit-handle-alloc-failures-in-damon_test_split_evenly_fail.patch
mm-damon-tests-vaddr-kunit-handle-alloc-failures-on-damon_test_split_evenly_succ.patch
mm-damon-tests-sysfs-kunit-handle-alloc-failures-on-damon_sysfs_test_add_targets.patch
mm-damon-tests-core-kunit-remove-unnecessary-damon_ctx-variable-on-damon_test_split_at.patch
mm-damon-tests-core-kunit-remove-unused-ctx-in-damon_test_split_regions_of.patch
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

