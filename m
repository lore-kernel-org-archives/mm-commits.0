Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8047E4973AF
	for <mm-commits@vger.kernel.org>; Mon, 28 Sep 2026 22:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790634881; cv=none; b=ZgX373qXw56a79RJLilJz7hNb/zWkRSRg95WMZJ6bzsU3HDvGr1SK3yeEcGkq3shCg/97HLVuiTMCz/nhI2F/3tHvMg7AcOW8kSioauzCFGXY/7Dkqb9zTVHKC7NbtkLYNI4hSNWgTYkZ2485uPbnjXa/DOuegf+NNCpj6leSRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790634881; c=relaxed/simple;
	bh=CrYZeT11eBUKOvHjcCJwX0FY+azKbMyLUIP8MRav8yY=;
	h=Date:To:From:Subject:Message-Id; b=HzLmF9N6edYnzFsSdt8a3nH18svoFRO1N1GlYYtCcX0R0eld+hbvBuexRX4oAmYUSEUw7wMZ2VrRx4tCXGE0dJhzQxbNwJ0gh0YOX/QoyXNo5wbVw+e83gfCZezGx7RV9j7UDSLZXVzNH6HONCksEfFR7vfcSIaL/gKBErLXFII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LnOVPZU1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LnOVPZU1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2455A1F00893;
	Mon, 28 Sep 2026 22:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790634880;
	bh=HJf7VhggG6oaMXD/217jw9SAhBUETdM7L4CZUn3ZN7g=;
	h=Date:To:From:Subject;
	b=LnOVPZU1Tc9M6w6/5hT3/cZJz/HogPUhurDOp/5CvgYWeoZegMCRHbB89beDY6Wt9
	 NzDjFnqvqtN1bNIbgjBqirbAAZWXjd+xBg6RB+EdjGol7RBHnaQTZlAgR8lcnUxQN6
	 W+TefTYZ3FYpJvML+o0EaYbxP4ixd6j7GddHfFFs=
Date: Mon, 28 Sep 2026 15:34:39 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,davidgow@davidgow.net,brendan.higgins@linux.dev,donggeunyoo.kernel@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-tests-core-kunit-test-the-temporal-tuners-size-quota-conversion.patch added to mm-new branch
Message-Id: <20260928223440.2455A1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/tests/core-kunit: test the temporal tuner's size quota conversion
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-tests-core-kunit-test-the-temporal-tuners-size-quota-conversion.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-tests-core-kunit-test-the-temporal-tuners-size-quota-conversion.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Subject: mm/damon/tests/core-kunit: test the temporal tuner's size quota conversion
Date: Mon, 28 Sep 2026 01:48:15 -0700

damos_goal_tune_esz_bp_temporal() encodes the size quota in basis points,
so the conversion is exact only up to ULONG_MAX / 10000.  Pin the three
sizes around that boundary: the largest one that fits, the first one that
does not, and ULONG_MAX.

Link: https://lore.kernel.org/20260928084816.5575-3-sj@kernel.org
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@davidgow.net>
---

 mm/damon/tests/core-kunit.h |   48 ++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-test-the-temporal-tuners-size-quota-conversion
+++ a/mm/damon/tests/core-kunit.h
@@ -2347,6 +2347,53 @@ static void damon_test_rand(struct kunit
 	}
 }
 
+static void damos_test_esz_goal_temporal(struct kunit *test)
+{
+	struct damos_access_pattern pattern = {};
+	struct damos_watermarks wmarks = {};
+	struct damos_quota quota = {
+		.goal_tuner = DAMOS_QUOTA_GOAL_TUNER_TEMPORAL,
+	};
+	struct damos_quota_goal *goal;
+	struct damon_ctx *ctx;
+	struct damos *s;
+
+	ctx = damon_new_ctx();
+	KUNIT_ASSERT_NOT_NULL(test, ctx);
+
+	s = damon_new_scheme(&pattern, DAMOS_STAT, 0, &quota, &wmarks,
+			NUMA_NO_NODE);
+	if (!s) {
+		damon_destroy_ctx(ctx);
+		kunit_skip(test, "scheme alloc fail");
+	}
+	damon_add_scheme(ctx, s);
+
+	goal = damos_new_quota_goal(DAMOS_QUOTA_USER_INPUT, 10000);
+	if (!goal) {
+		damon_destroy_ctx(ctx);
+		kunit_skip(test, "quota goal alloc fail");
+	}
+	goal->current_value = 0;
+	damos_add_quota_goal(&s->quota, goal);
+
+	/* The largest size quota the basis-point conversion can hold. */
+	s->quota.sz = ULONG_MAX / 10000;
+	damos_set_effective_quota(ctx, s);
+	KUNIT_EXPECT_EQ(test, s->quota.esz, ULONG_MAX / 10000);
+
+	/* Any larger one saturates instead of wrapping. */
+	s->quota.sz = ULONG_MAX / 10000 + 1;
+	damos_set_effective_quota(ctx, s);
+	KUNIT_EXPECT_EQ(test, s->quota.esz, ULONG_MAX / 10000);
+
+	s->quota.sz = ULONG_MAX;
+	damos_set_effective_quota(ctx, s);
+	KUNIT_EXPECT_EQ(test, s->quota.esz, ULONG_MAX / 10000);
+
+	damon_destroy_ctx(ctx);
+}
+
 static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_target),
 	KUNIT_CASE(damon_test_regions),
@@ -2388,6 +2435,7 @@ static struct kunit_case damon_test_case
 	KUNIT_CASE(damon_test_is_last_region),
 	KUNIT_CASE(damon_test_walk_control_obsolete),
 	KUNIT_CASE(damon_test_rand),
+	KUNIT_CASE(damos_test_esz_goal_temporal),
 	{},
 };
 
_

Patches currently in -mm which might be from donggeunyoo.kernel@gmail.com are

userfaultfd-clear-the-inherited-uffd-bit-in-move_swap_pte.patch
selftests-mm-add-tests-for-uffdio_move-of-a-uffd-protected-swap-entry.patch
mm-damon-core-charge-only-the-part-of-a-region-the-filter-left.patch
mm-damon-tests-core-kunit-test-the-size-charged-for-a-filter-trimmed-region.patch
mm-damon-core-prevent-size-quota-overflow-in-the-temporal-goal-tuner.patch
mm-damon-tests-core-kunit-test-the-temporal-tuners-size-quota-conversion.patch

