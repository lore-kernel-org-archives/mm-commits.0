Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D5334BA24
	for <mm-commits@vger.kernel.org>; Mon, 13 Jul 2026 20:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783975400; cv=none; b=ILVMnJHOu0sl396sXlloBoPLF6QlDYJw00HJdjlSNoS2YwE39WR3P0PRCu2QQAirIhWA3cq9Jr8vm0sEH/bw8+owJYehdab3hF0sERVrxSVQnsblNGLhwd78tRH4QPkQYHQZ/A+DDAk7KbCkTgeqjgL0qBP1VoVo+PZnoI8mVSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783975400; c=relaxed/simple;
	bh=XaEY23QG/vI69vp3k8O0aUY/f9Stz2/FMHB4a9DaQ9s=;
	h=Date:To:From:Subject:Message-Id; b=Jne4CjpHs++khQ3JKtKnMAdESKxG2hBXNPNi+p5h8WU+njr/rOQdgaT5DqSfpeTKKhazgfVWTOVke3yRV9wn+0AQS9o9Zxov61yC/VEULBL53jSBV3ahxBFTWmC3q4sMDcuTxr1jopWj1O/vN+MrI6TOEawj5pLwnjALvnzU5DI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ItZH8/sJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ItZH8/sJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A7E41F000E9;
	Mon, 13 Jul 2026 20:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783975399;
	bh=4OYgEh3D9j2188jdDKv7ZPUl+WuZZyXdp7fnSmws8YM=;
	h=Date:To:From:Subject;
	b=ItZH8/sJT7A5iuhDaK2iFldjhdcRabWolm6NKeT2vd1g00P+iTf+Hr8aAfuEbxHud
	 Ld1wgAASUsoCm0gKBXL81447eWialdGx9SrGM6Muwqey2r4VcUlJyHvwarcroUxLX4
	 NsGD8TclRjrcg9s29fXQhDz4ojjTcwZsTyO1IC7I=
Date: Mon, 13 Jul 2026 13:43:18 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,husong@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-tests-core-kunit-test-damon_nr_accesses_mvsum.patch added to mm-new branch
Message-Id: <20260713204319.4A7E41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/tests/core-kunit: test damon_nr_accesses_mvsum()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-tests-core-kunit-test-damon_nr_accesses_mvsum.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-tests-core-kunit-test-damon_nr_accesses_mvsum.patch

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
From: Song Hu <husong@kylinos.cn>
Subject: mm/damon/tests/core-kunit: test damon_nr_accesses_mvsum()
Date: Mon, 13 Jul 2026 17:46:48 +0800

damon_nr_accesses_mvsum() wraps damon_mvsum() with the monitoring
intervals of the context to compute the pseudo moving sum of a region's
access frequency, with a special case for when the whole aggregation
window remains.  damon_mvsum() itself is already covered by
damon_test_mvsum(), but the wrapper is not.

Add a table-driven KUnit test that exercises the full-window-remaining
boundary (with both reset and not-yet-reset nr_accesses), partially
elapsed windows, and the no-window-remaining case.

Link: https://lore.kernel.org/20260713094648.897239-1-husong@kylinos.cn
Signed-off-by: Song Hu <husong@kylinos.cn>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/core-kunit.h |   49 ++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-test-damon_nr_accesses_mvsum
+++ a/mm/damon/tests/core-kunit.h
@@ -677,6 +677,54 @@ static void damon_test_mvsum(struct kuni
 	}
 }
 
+/*
+ * Test damon_nr_accesses_mvsum(), which wraps damon_mvsum() with the
+ * monitoring intervals of the context.  With a sample interval of 1 and an
+ * aggregation interval of 10, an aggregation window is 10 sample intervals
+ * long.  Each row below specifies the passed sample intervals, the next
+ * aggregation time in sample intervals, the current and last nr_accesses of a
+ * region, and the expected return value.
+ */
+static void damon_test_nr_accesses_mvsum(struct kunit *test)
+{
+	unsigned long input_expects[] = {
+		/* passed, next_aggr, nr_accesses, last_nr_accesses, expect */
+		0, 10, 5, 3, 3,		/* full window left, unreset */
+		0, 10, 0, 7, 7,		/* full window left, reset */
+		5, 10, 3, 10, 8,	/* half window left */
+		8, 10, 3, 10, 5,	/* 20% window left */
+		10, 10, 42, 49, 42,	/* no window left */
+	};
+	struct damon_ctx *c = damon_new_ctx();
+	struct damon_region *r;
+	int i;
+
+	if (!c)
+		kunit_skip(test, "ctx alloc fail");
+
+	r = damon_new_region(0, 4096);
+	if (!r) {
+		damon_destroy_ctx(c);
+		kunit_skip(test, "region alloc fail");
+	}
+
+	c->attrs.sample_interval = 1;
+	c->attrs.aggr_interval = 10;
+
+	for (i = 0; i < ARRAY_SIZE(input_expects); i += 5) {
+		c->passed_sample_intervals = input_expects[i];
+		c->next_aggregation_sis = input_expects[i + 1];
+		r->nr_accesses = input_expects[i + 2];
+		r->last_nr_accesses = input_expects[i + 3];
+
+		KUNIT_EXPECT_EQ(test, (unsigned int)input_expects[i + 4],
+				damon_nr_accesses_mvsum(r, c));
+	}
+
+	damon_free_region(r);
+	damon_destroy_ctx(c);
+}
+
 static void damos_test_new_filter(struct kunit *test)
 {
 	struct damos_filter *filter;
@@ -1569,6 +1617,7 @@ static struct kunit_case damon_test_case
 	KUNIT_CASE(damon_test_update_monitoring_result),
 	KUNIT_CASE(damon_test_set_attrs),
 	KUNIT_CASE(damon_test_mvsum),
+	KUNIT_CASE(damon_test_nr_accesses_mvsum),
 	KUNIT_CASE(damos_test_new_filter),
 	KUNIT_CASE(damos_test_commit_quota_goal),
 	KUNIT_CASE(damos_test_commit_quota_goals),
_

Patches currently in -mm which might be from husong@kylinos.cn are

mm-damon-tests-core-kunit-test-damon_nr_accesses_mvsum.patch

