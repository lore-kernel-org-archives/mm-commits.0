Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15C8D3B2FCE
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068027; cv=none; b=TDR8KnH7iPIU+UjQWXjxvOCSJh22z3QPo1PL7q13QoL6fnMyAno5WZTpQWrftCy2sN+3JDqkQ2DvC+YSYYyrTQYgKKDGwh2kAU6c21RPUaQNnB3pMNjQd36euBP5hAU3X5wjcuaar9g8PmmNWfPZE8G9MmivWAqyXkSwCUXxd1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068027; c=relaxed/simple;
	bh=bl99AXCclC8rYolY5ILaItlm2WcK4iE3HWLPa/ZHjSQ=;
	h=Date:To:From:Subject:Message-Id; b=K3mcanxye4v+TGSu+n9XFiVmmOptr+NvoRo4Uv1R0ihcJnhLl/G8KQ4ZBbKRwnyJDiKpKEKPJD3QnO9hmXVsZMWFGpfhRaB9ZGKEQS8smWPmznRgT82Wpt3UtuUF2zwqIoOZde6ohC/ikJwzF+UgC1kWaZ0KXSVac+gV8vDCSqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tcgHZJkw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tcgHZJkw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 184291F00AC4;
	Fri,  7 Aug 2026 02:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068014;
	bh=LKedZ2CsPHXWDvfxMS1Vy1S8B6EeRi1RRSWCDKccGtc=;
	h=Date:To:From:Subject;
	b=tcgHZJkw4iLs4Y1kNJ+7l4eCdGniwL2WWxNwM8r/n3gCgdlx8LXH4KttuyKNjOV5p
	 G3+BOdlLmhJQFUJVHrLxiXdh4rW9Vr9bIS6UP6YcynWmnWhPA7jvMcBOZl1sMXRRcO
	 yeywqSbAizdXcj3Tiy9mLGVjbs5YAW+mmpUvOVUg=
Date: Thu, 06 Aug 2026 19:00:13 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,husong@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-tests-core-kunit-test-damon_nr_accesses_mvsum.patch removed from -mm tree
Message-Id: <20260807020014.184291F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/tests/core-kunit: test damon_nr_accesses_mvsum()
has been removed from the -mm tree.  Its filename was
     mm-damon-tests-core-kunit-test-damon_nr_accesses_mvsum.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


