Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 242FF1A3154
	for <mm-commits@vger.kernel.org>; Sat, 28 Feb 2026 23:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772319864; cv=none; b=ppqNWZDJ4CqX3NkS4hvC8i8NZ9kb1gWBxX7ECxJvxHw5yiQyhstidepQLWLtyls3zwNlq2ogMbA52xROx4w8dg4EVFrypCwloGSBZ/vKnNBnD2BUBATk17mKsdF6cGGLrzAM08X85cXJXHovtOeQy4fDp44W6bB8lughCHNAzrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772319864; c=relaxed/simple;
	bh=AqMgZ4oQjxTLu6pYJ+aNz5wF2EBdAhVV64LTxxKZFIk=;
	h=Date:To:From:Subject:Message-Id; b=QkS4KUh6nqXX384siku50Ahz2UaSWkT2VCHiYvwz8jxt/nJHm15ah5zNfy4U8HV5TALFuG00G4vo/6dMvnAAudEoa8b6JGDO4RH8HAptr6zCApJgrvFJToBz62EZt6u7Ia4tfA3h/ytAxtgZuFLtkqajJNRID3cFs7y89V4B1O4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=j2esVLHb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j2esVLHb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8A44C116D0;
	Sat, 28 Feb 2026 23:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772319863;
	bh=AqMgZ4oQjxTLu6pYJ+aNz5wF2EBdAhVV64LTxxKZFIk=;
	h=Date:To:From:Subject:From;
	b=j2esVLHbC/nkj+1P3N1vU5LpN41WKQbmDREuAYBCJ2Rr6TKmi+OWUSgBehOcvCeKS
	 Equl18O9tASLKmgJ7O66rTS4N+7APX32OnOdzq51At/h8/05ma1pNuOqx1mC1spfsG
	 fktDPAnf8qTaz4iQ7NcBVPIDr26wTqXIGN9tFpNI=
Date: Sat, 28 Feb 2026 15:04:23 -0800
To: mm-commits@vger.kernel.org,davidgow@google.com,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-test-core-kunit-add-damon_apply_min_nr_regions-test.patch added to mm-new branch
Message-Id: <20260228230423.A8A44C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/test/core-kunit: add damon_apply_min_nr_regions() test
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-test-core-kunit-add-damon_apply_min_nr_regions-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-test-core-kunit-add-damon_apply_min_nr_regions-test.patch

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
Subject: mm/damon/test/core-kunit: add damon_apply_min_nr_regions() test
Date: Sat, 28 Feb 2026 14:28:27 -0800

Add a kunit test for the functionality of damon_apply_min_nr_regions().

Link: https://lkml.kernel.org/r/20260228222831.7232-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/core-kunit.h |   52 ++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

--- a/mm/damon/tests/core-kunit.h~mm-damon-test-core-kunit-add-damon_apply_min_nr_regions-test
+++ a/mm/damon/tests/core-kunit.h
@@ -1239,6 +1239,57 @@ static void damon_test_set_filters_defau
 	damos_free_filter(target_filter);
 }
 
+static void damon_test_apply_min_nr_regions_for(struct kunit *test,
+		unsigned long sz_regions, unsigned long min_region_sz,
+		unsigned long min_nr_regions,
+		unsigned long max_region_sz_expect,
+		unsigned long nr_regions_expect)
+{
+	struct damon_ctx *ctx;
+	struct damon_target *t;
+	struct damon_region *r;
+	unsigned long max_region_size;
+
+	ctx = damon_new_ctx();
+	if (!ctx)
+		kunit_skip(test, "ctx alloc fail\n");
+	t = damon_new_target();
+	if (!t) {
+		damon_destroy_ctx(ctx);
+		kunit_skip(test, "target alloc fail\n");
+	}
+	damon_add_target(ctx, t);
+	r = damon_new_region(0, sz_regions);
+	if (!r) {
+		damon_destroy_ctx(ctx);
+		kunit_skip(test, "region alloc fail\n");
+	}
+	damon_add_region(r, t);
+
+	ctx->min_region_sz = min_region_sz;
+	ctx->attrs.min_nr_regions = min_nr_regions;
+	max_region_size = damon_apply_min_nr_regions(ctx);
+
+	KUNIT_EXPECT_EQ(test, max_region_size, max_region_sz_expect);
+	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), nr_regions_expect);
+
+	damon_destroy_ctx(ctx);
+}
+
+static void damon_test_apply_min_nr_regions(struct kunit *test)
+{
+	/* common, expected setup */
+	damon_test_apply_min_nr_regions_for(test, 10, 1, 10, 1, 10);
+	/* no zero size limit */
+	damon_test_apply_min_nr_regions_for(test, 10, 1, 15, 1, 10);
+	/* max size should be aligned by min_region_sz */
+	damon_test_apply_min_nr_regions_for(test, 10, 2, 2, 6, 2);
+	/*
+	 * when min_nr_regions and min_region_sz conflicts, min_region_sz wins.
+	 */
+	damon_test_apply_min_nr_regions_for(test, 10, 2, 10, 2, 5);
+}
+
 static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_target),
 	KUNIT_CASE(damon_test_regions),
@@ -1265,6 +1316,7 @@ static struct kunit_case damon_test_case
 	KUNIT_CASE(damos_test_filter_out),
 	KUNIT_CASE(damon_test_feed_loop_next_input),
 	KUNIT_CASE(damon_test_set_filters_default_reject),
+	KUNIT_CASE(damon_test_apply_min_nr_regions),
 	{},
 };
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-set-quota-score-histogram-with-core-filters.patch
mm-damon-core-do-non-safe-region-walk-on-kdamond_apply_schemes.patch
mm-damon-core-split-regions-for-min_nr_regions.patch
mm-damon-vaddr-do-not-split-regions-for-min_nr_regions.patch
mm-damon-test-core-kunit-add-damon_apply_min_nr_regions-test.patch

