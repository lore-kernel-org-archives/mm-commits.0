Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8881F318EC7
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 02:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465705; cv=none; b=n9gMSTMfaso9fXC9LezxX5Z4wISKFz0JVCJPOupIgWryAeThWvzbCmg1yIszb2G+nSmTm/l5hAqKzMYdkxrUyevl/ooQH4iKDvHU2m61Ww2vYAcx/L/EdNEQtna1kwCnUztgqGZCcrJRafZqIOOZj+G1F+5+k5DRUvSTYrHAQn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465705; c=relaxed/simple;
	bh=ll0bUBKXBrBpO55hp9nlf21+m/zfoAm2i8qzT9eglPI=;
	h=Date:To:From:Subject:Message-Id; b=dxPQqJ4EAmaQhfM4gWS4pXBlilgaFyE5w6qMFOE8CYzm4zcRcZH0eEKSykOl6HpRyRXYT/GJhOPDCLw0Vg5s78KyyfVDOGzvhtM2Ra2Vkb9mhE6jrPQZd+ZbbMDRy20NV44alDvMUvry/XG2V8aBJnySiRRrNGkimn79LgjCygY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RjLRS8Eo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RjLRS8Eo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 342001F00A3D;
	Fri, 31 Jul 2026 02:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785465704;
	bh=HbRgxZrecMTVC+gFCFBQqZouAJPP9GTjARZIa9Wbg38=;
	h=Date:To:From:Subject;
	b=RjLRS8EoMzxLX8md+t0M1psBjBiAFjYwC+OOfAsDVjYaNJ9qjfO7zeiwfrPtw38o5
	 FJqt+FOkvAMdvECc/l6uNbBYf5WKtDkebmaMxAbZlm1Ev6dWGw6UM+H0ifMGH/PBdA
	 aF4DWH6fAKuuDzsbMrcPxV0/SibHjMG49jfxcYV4=
Date: Thu, 30 Jul 2026 19:41:43 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,shu17az@gmail.com,jiayuan.chen@shopee.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-tests-core-kunit-test-split-above-max_nr_regions-2.patch removed from -mm tree
Message-Id: <20260731024144.342001F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/tests/core-kunit: test split above max_nr_regions/2
has been removed from the -mm tree.  Its filename was
     mm-damon-tests-core-kunit-test-split-above-max_nr_regions-2.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jiayuan Chen <jiayuan.chen@shopee.com>
Subject: mm/damon/tests/core-kunit: test split above max_nr_regions/2
Date: Mon, 29 Jun 2026 07:56:29 -0700

Add a test that exercises kdamond_split_regions() when the total region
count is already above max_nr_regions / 2, asserting that the function
still splits a fraction of the regions (makes progress) and does not
overshoot max_nr_regions.

The region size and min_region_sz are picked so the split arithmetic does
not depend on the page size.

All tests pass:
  damon: pass:31 fail:0 skip:0 total:31
  Totals: pass:31 fail:0 skip:0 total:31

Link: https://lore.kernel.org/20260626085851.70754-3-jiayuan.chen@linux.dev
Link: https://lore.kernel.org/20260629145630.134891-3-sj@kernel.org
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
Signed-off-by: SJ Park <sj@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Shu Anzai <shu17az@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/core-kunit.h |   64 ++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-test-split-above-max_nr_regions-2
+++ a/mm/damon/tests/core-kunit.h
@@ -335,6 +335,69 @@ static void damon_test_split_regions_of(
 	damon_destroy_ctx(c);
 }
 
+/*
+ * When the total region count is already above max_nr_regions / 2,
+ * kdamond_split_regions() must keep refining the resolution by splitting a
+ * fraction of the regions (making progress), without exceeding
+ * max_nr_regions.
+ */
+static void damon_test_split_above_half_progresses(struct kunit *test)
+{
+	struct damon_ctx *c;
+	struct damon_target *t;
+	struct damon_region *r;
+	unsigned long start;
+	unsigned int nr_before, nr_after, i;
+	const unsigned int nr_init = 760;
+	const unsigned long region_sz = 100;
+
+	c = damon_new_ctx();
+	if (!c)
+		kunit_skip(test, "ctx alloc fail");
+
+	/* Keep the split arithmetic independent of the page size */
+	c->min_region_sz = 1;
+	c->attrs.min_nr_regions = 10;
+	c->attrs.max_nr_regions = 1500;
+
+	t = damon_new_target();
+	if (!t) {
+		damon_destroy_ctx(c);
+		kunit_skip(test, "target alloc fail");
+	}
+
+	for (i = 0; i < nr_init; i++) {
+		start = i * region_sz;
+		r = damon_new_region(start, start + region_sz);
+		if (!r) {
+			damon_free_target(t);
+			damon_destroy_ctx(c);
+			kunit_skip(test, "region alloc fail");
+		}
+		r->nr_accesses = (i & 1) ? 0 : 100;
+		r->age = 5;
+		damon_add_region(r, t);
+	}
+
+	damon_add_target(c, t);
+
+	nr_before = damon_nr_regions(t);
+	/* Above max_nr_regions / 2, so the blanket-split path is skipped */
+	KUNIT_EXPECT_GT(test, (unsigned long)nr_before,
+			c->attrs.max_nr_regions / 2);
+
+	kdamond_split_regions(c);
+
+	nr_after = damon_nr_regions(t);
+	/* Still made progress ... */
+	KUNIT_EXPECT_GT(test, nr_after, nr_before);
+	/* ... but did not overshoot the configured maximum */
+	KUNIT_EXPECT_LE(test, (unsigned long)nr_after,
+			c->attrs.max_nr_regions);
+
+	damon_destroy_ctx(c);
+}
+
 static void damon_test_ops_registration(struct kunit *test)
 {
 	struct damon_ctx *c = damon_new_ctx();
@@ -1491,6 +1554,7 @@ static struct kunit_case damon_test_case
 	KUNIT_CASE(damon_test_merge_two),
 	KUNIT_CASE(damon_test_merge_regions_of),
 	KUNIT_CASE(damon_test_split_regions_of),
+	KUNIT_CASE(damon_test_split_above_half_progresses),
 	KUNIT_CASE(damon_test_ops_registration),
 	KUNIT_CASE(damon_test_set_regions),
 	KUNIT_CASE(damon_test_nr_accesses_to_accesses_bp),
_

Patches currently in -mm which might be from jiayuan.chen@shopee.com are

memcg-bail-out-memoryhigh-when-memcg-is-dying.patch
memcg-bail-out-memorymax-when-memcg-is-dying.patch
memcg-bail-out-proactive-reclaim-when-memcg-is-dying.patch
memcg-v1-bail-out-reclaim-when-memcg-is-dying.patch

