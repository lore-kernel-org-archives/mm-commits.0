Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E353C365A0B
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388666; cv=none; b=m5AGWPaw5vXqU1UUYhwniiRD/aTHxSRLLaHRptECQnUIllzZVRf8sCbUu2vfS7rqxtj1fLqtgmTOXCHhrnyx5C5FBEy2AcU/omMNn5nBK9HP2+VSCWcivIzOnpMXkJZEfuF7GglZUSDq9ShJD/2WRN9IBgSijQQF7h7+LcYSlh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388666; c=relaxed/simple;
	bh=kDbo8tsqsOrato8T02UHUzxO0mH7rj8I3VmXHF8ddlI=;
	h=Date:To:From:Subject:Message-Id; b=X7P8bEuYJU7I/cB8cMp73tOpaGAmhasC/DTIbVeuGzT/Dk3aTohbowpPr3Kgj8LZ8A+vINeFoVT0nb5hCufFB88RZNEg3pS9xq/wTwEIUXDPQjLamLTXahY+DjMayUtLjqInXobYzW4NupBGxy032jCqZxqZnZ5iOf3AWJcHF3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=L671Ea0a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="L671Ea0a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B332DC19424;
	Tue, 24 Mar 2026 21:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388665;
	bh=kDbo8tsqsOrato8T02UHUzxO0mH7rj8I3VmXHF8ddlI=;
	h=Date:To:From:Subject:From;
	b=L671Ea0aKPbtCgE9Sc9sCw8jsskYP9CDjCq+olXhNHVMAH5NeaxirP6gTN/KHWw9Y
	 wwUcZP6YtZkgir+tRSx9XSHeVmlmb/j8oI4U67MTxUyOlmYKuS9D9sjpmmBSdAYFy0
	 GQpH8mrvO7bk4khoi/77Mhyp8zm646PoqOk2kQVc=
Date: Tue, 24 Mar 2026 14:44:25 -0700
To: mm-commits@vger.kernel.org,davidgow@google.com,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-vaddr-do-not-split-regions-for-min_nr_regions.patch removed from -mm tree
Message-Id: <20260324214425.B332DC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/vaddr: do not split regions for min_nr_regions
has been removed from the -mm tree.  Its filename was
     mm-damon-vaddr-do-not-split-regions-for-min_nr_regions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/vaddr: do not split regions for min_nr_regions
Date: Sat, 28 Feb 2026 14:28:26 -0800

The previous commit made DAMON core split regions at the beginning for
min_nr_regions.  The virtual address space operation set (vaddr) does
similar work on its own, for a case user delegates entire initial
monitoring regions setup to vaddr.  It is unnecessary now, as DAMON core
will do similar work for any case.  Remove the duplicated work in vaddr.

Also, remove a helper function that was being used only for the work, and
the test code of the helper function.

Link: https://lkml.kernel.org/r/20260228222831.7232-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/vaddr-kunit.h |   76 ---------------------------------
 mm/damon/vaddr.c             |   70 ------------------------------
 2 files changed, 2 insertions(+), 144 deletions(-)

--- a/mm/damon/tests/vaddr-kunit.h~mm-damon-vaddr-do-not-split-regions-for-min_nr_regions
+++ a/mm/damon/tests/vaddr-kunit.h
@@ -252,88 +252,12 @@ static void damon_test_apply_three_regio
 			new_three_regions, expected, ARRAY_SIZE(expected));
 }
 
-static void damon_test_split_evenly_fail(struct kunit *test,
-		unsigned long start, unsigned long end, unsigned int nr_pieces)
-{
-	struct damon_target *t = damon_new_target();
-	struct damon_region *r;
-
-	if (!t)
-		kunit_skip(test, "target alloc fail");
-
-	r = damon_new_region(start, end);
-	if (!r) {
-		damon_free_target(t);
-		kunit_skip(test, "region alloc fail");
-	}
-
-	damon_add_region(r, t);
-	KUNIT_EXPECT_EQ(test,
-			damon_va_evenly_split_region(t, r, nr_pieces), -EINVAL);
-	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 1u);
-
-	damon_for_each_region(r, t) {
-		KUNIT_EXPECT_EQ(test, r->ar.start, start);
-		KUNIT_EXPECT_EQ(test, r->ar.end, end);
-	}
-
-	damon_free_target(t);
-}
-
-static void damon_test_split_evenly_succ(struct kunit *test,
-	unsigned long start, unsigned long end, unsigned int nr_pieces)
-{
-	struct damon_target *t = damon_new_target();
-	struct damon_region *r;
-	unsigned long expected_width = (end - start) / nr_pieces;
-	unsigned long i = 0;
-
-	if (!t)
-		kunit_skip(test, "target alloc fail");
-	r = damon_new_region(start, end);
-	if (!r) {
-		damon_free_target(t);
-		kunit_skip(test, "region alloc fail");
-	}
-	damon_add_region(r, t);
-	KUNIT_EXPECT_EQ(test,
-			damon_va_evenly_split_region(t, r, nr_pieces), 0);
-	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), nr_pieces);
-
-	damon_for_each_region(r, t) {
-		if (i == nr_pieces - 1) {
-			KUNIT_EXPECT_EQ(test,
-				r->ar.start, start + i * expected_width);
-			KUNIT_EXPECT_EQ(test, r->ar.end, end);
-			break;
-		}
-		KUNIT_EXPECT_EQ(test,
-				r->ar.start, start + i++ * expected_width);
-		KUNIT_EXPECT_EQ(test, r->ar.end, start + i * expected_width);
-	}
-	damon_free_target(t);
-}
-
-static void damon_test_split_evenly(struct kunit *test)
-{
-	KUNIT_EXPECT_EQ(test, damon_va_evenly_split_region(NULL, NULL, 5),
-			-EINVAL);
-
-	damon_test_split_evenly_fail(test, 0, 100, 0);
-	damon_test_split_evenly_succ(test, 0, 100, 10);
-	damon_test_split_evenly_succ(test, 5, 59, 5);
-	damon_test_split_evenly_succ(test, 4, 6, 1);
-	damon_test_split_evenly_succ(test, 0, 3, 2);
-	damon_test_split_evenly_fail(test, 5, 6, 2);
-}
-
 static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_three_regions_in_vmas),
 	KUNIT_CASE(damon_test_apply_three_regions1),
 	KUNIT_CASE(damon_test_apply_three_regions2),
 	KUNIT_CASE(damon_test_apply_three_regions3),
 	KUNIT_CASE(damon_test_apply_three_regions4),
-	KUNIT_CASE(damon_test_split_evenly),
 	{},
 };
 
--- a/mm/damon/vaddr.c~mm-damon-vaddr-do-not-split-regions-for-min_nr_regions
+++ a/mm/damon/vaddr.c
@@ -53,52 +53,6 @@ static struct mm_struct *damon_get_mm(st
 	return mm;
 }
 
-/*
- * Functions for the initial monitoring target regions construction
- */
-
-/*
- * Size-evenly split a region into 'nr_pieces' small regions
- *
- * Returns 0 on success, or negative error code otherwise.
- */
-static int damon_va_evenly_split_region(struct damon_target *t,
-		struct damon_region *r, unsigned int nr_pieces)
-{
-	unsigned long sz_orig, sz_piece, orig_end;
-	struct damon_region *n = NULL, *next;
-	unsigned long start;
-	unsigned int i;
-
-	if (!r || !nr_pieces)
-		return -EINVAL;
-
-	if (nr_pieces == 1)
-		return 0;
-
-	orig_end = r->ar.end;
-	sz_orig = damon_sz_region(r);
-	sz_piece = ALIGN_DOWN(sz_orig / nr_pieces, DAMON_MIN_REGION_SZ);
-
-	if (!sz_piece)
-		return -EINVAL;
-
-	r->ar.end = r->ar.start + sz_piece;
-	next = damon_next_region(r);
-	for (start = r->ar.end, i = 1; i < nr_pieces; start += sz_piece, i++) {
-		n = damon_new_region(start, start + sz_piece);
-		if (!n)
-			return -ENOMEM;
-		damon_insert_region(n, r, next, t);
-		r = n;
-	}
-	/* complement last region for possible rounding error */
-	if (n)
-		n->ar.end = orig_end;
-
-	return 0;
-}
-
 static unsigned long sz_range(struct damon_addr_range *r)
 {
 	return r->end - r->start;
@@ -240,10 +194,8 @@ static void __damon_va_init_regions(stru
 				     struct damon_target *t)
 {
 	struct damon_target *ti;
-	struct damon_region *r;
 	struct damon_addr_range regions[3];
-	unsigned long sz = 0, nr_pieces;
-	int i, tidx = 0;
+	int tidx = 0;
 
 	if (damon_va_three_regions(t, regions)) {
 		damon_for_each_target(ti, ctx) {
@@ -255,25 +207,7 @@ static void __damon_va_init_regions(stru
 		return;
 	}
 
-	for (i = 0; i < 3; i++)
-		sz += regions[i].end - regions[i].start;
-	if (ctx->attrs.min_nr_regions)
-		sz /= ctx->attrs.min_nr_regions;
-	if (sz < DAMON_MIN_REGION_SZ)
-		sz = DAMON_MIN_REGION_SZ;
-
-	/* Set the initial three regions of the target */
-	for (i = 0; i < 3; i++) {
-		r = damon_new_region(regions[i].start, regions[i].end);
-		if (!r) {
-			pr_err("%d'th init region creation failed\n", i);
-			return;
-		}
-		damon_add_region(r, t);
-
-		nr_pieces = (regions[i].end - regions[i].start) / sz;
-		damon_va_evenly_split_region(t, r, nr_pieces);
-	}
+	damon_set_regions(t, regions, 3, DAMON_MIN_REGION_SZ);
 }
 
 /* Initialize '->regions_list' of every target (task) */
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-add-config_damon_debug_sanity.patch
mm-damon-core-add-damon_new_region-debug_sanity-check.patch
mm-damon-core-add-damon_del_region-debug_sanity-check.patch
mm-damon-core-add-damon_nr_regions-debug_sanity-check.patch
mm-damon-core-add-damon_merge_two_regions-debug_sanity-check.patch
mm-damon-core-add-damon_merge_regions_of-debug_sanity-check.patch
mm-damon-core-add-damon_split_region_at-debug_sanity-check.patch
mm-damon-core-add-damon_reset_aggregated-debug_sanity-check.patch
mm-damon-tests-kunitconifg-enable-damon_debug_sanity.patch
selftests-damon-config-enable-damon_debug_sanity.patch
mm-damon-tests-core-kunit-add-a-test-for-damon_commit_ctx.patch
docs-mm-damon-design-document-the-power-of-two-limitation-for-addr_unit.patch
mm-damon-core-remove-damos_set_next_apply_sis-duplicates.patch
mm-damon-core-use-time_before-for-next_apply_sis.patch
mm-damon-core-use-time_after_eq-in-kdamond_fn.patch
mm-damon-core-use-mult_frac.patch
mm-damon-tests-core-kunit-add-a-test-for-damon_is_last_region.patch
mm-damon-core-clarify-damon_set_attrs-usages.patch
mm-damon-document-non-zero-length-damon_region-assumption.patch
docs-admin-guide-mm-damn-lru_sort-fix-intervals-autotune-parameter-name.patch
docs-mm-damon-maintainer-profile-use-flexible-review-cadence.patch
docs-mm-damon-index-fix-typo-autoamted-automated.patch
mm-damon-core-introduce-damos_quota_goal_tuner.patch
mm-damon-core-allow-quota-goals-set-zero-effective-size-quota.patch
mm-damon-core-introduce-damos_quota_goal_tuner_temporal.patch
mm-damon-sysfs-schemes-implement-quotas-goal_tuner-file.patch
docs-mm-damon-design-document-the-goal-based-quota-tuner-selections.patch
docs-admin-guide-mm-damon-usage-document-goal_tuner-sysfs-file.patch
docs-abi-damon-update-for-goal_tuner.patch
mm-damon-tests-core-kunit-test-goal_tuner-commit.patch
selftests-damon-_damon_sysfs-support-goal_tuner-setup.patch
selftests-damon-drgn_dump_damon_status-support-quota-goal_tuner-dumping.patch
selftests-damon-sysfspy-test-goal_tuner-commit.patch
mm-damon-core-fix-wrong-end-address-assignment-on-walk_system_ram.patch
mm-damon-core-support-addr_unit-on-damon_find_biggest_system_ram.patch
mm-damon-core-support-addr_unit-on-damon_find_biggest_system_ram-fix.patch
mm-damon-core-receive-addr_unit-on-damon_set_region_biggest_system_ram_default.patch
mm-damon-core-receive-addr_unit-on-damon_set_region_biggest_system_ram_default-fix.patch
mm-damon-reclaim-respect-addr_unit-on-default-monitoring-region-setup.patch
mm-damon-lru_sort-respect-addr_unit-on-default-monitoring-region-setup.patch

