Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A889A156F45
	for <mm-commits@vger.kernel.org>; Sat, 28 Feb 2026 23:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772319861; cv=none; b=tYPMaMPaU5ZC0UEsXhhr9TYe9cgBR+D7iusFDxLjNP5cgGppsA9Nqn5HM/roeU/hn+HQO6BDVT9fJggk5nfP1bcAo2XOLLMRauVkdKET0b6WOdbJMHzkvretwPoNgN3V8FlddLEZOxPKdReuICz1vJK7DYI0QaEp7AkWWbARos4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772319861; c=relaxed/simple;
	bh=yfRVbbhINCVaGo5mYsLSfy9Q0lUFWTGelX0fe23HWJU=;
	h=Date:To:From:Subject:Message-Id; b=UbxOyJLqHhQYYT4xmj6GsD9RJTKRZJ5OmAOE7BeiMWP6odaCnm5j8ZexlwtEKXOxnO0qh0eOHr+o8AjI1znn0v08I0oeNnoJFWq3KslSX4QKYLZrfN9d0XX6QP4q7C7VLw+JP5qLIbQIBufJnS9KjE0oyoe+vCP8bw/1beznFWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BFfBoRm6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BFfBoRm6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49A3DC116D0;
	Sat, 28 Feb 2026 23:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772319861;
	bh=yfRVbbhINCVaGo5mYsLSfy9Q0lUFWTGelX0fe23HWJU=;
	h=Date:To:From:Subject:From;
	b=BFfBoRm6hIGOqiw+lIACBXCrWczjjHppTFZk8w2VViO2Z73EAkzklSYP9FGnDu9B/
	 Ah5oy5egLCXpHIFjbkuuFqlcQKtXbdH5Lo8gSD1bVRpV7qTYeL0e76mCo+5zZDnrOX
	 wGmDgV4uBt05i3x+t5uRKqR5wiI/Ghx/4XnaOZzo=
Date: Sat, 28 Feb 2026 15:04:20 -0800
To: mm-commits@vger.kernel.org,davidgow@google.com,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-vaddr-do-not-split-regions-for-min_nr_regions.patch added to mm-new branch
Message-Id: <20260228230421.49A3DC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/vaddr: do not split regions for min_nr_regions
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-vaddr-do-not-split-regions-for-min_nr_regions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-vaddr-do-not-split-regions-for-min_nr_regions.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

mm-damon-core-set-quota-score-histogram-with-core-filters.patch
mm-damon-core-do-non-safe-region-walk-on-kdamond_apply_schemes.patch
mm-damon-core-split-regions-for-min_nr_regions.patch
mm-damon-vaddr-do-not-split-regions-for-min_nr_regions.patch
mm-damon-test-core-kunit-add-damon_apply_min_nr_regions-test.patch

