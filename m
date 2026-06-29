Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8CF92D12EC
	for <mm-commits@vger.kernel.org>; Mon, 29 Jun 2026 19:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782759756; cv=none; b=I4KVxR0UDyVeNEcDpGEXSgMKlxCaHUfcZw6tC/UyFBfpy9edgQrsZ5ADadCJ5tIrI5tqqd82xOzgBGffMEoGaZSmLY0J1Rsin4xTfh0b/i4sUSevBXXV/iy/4nb3cB77mJZaATYXuvxIPARbDy6UawV4TofzyqVAvwxXLy1twh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782759756; c=relaxed/simple;
	bh=YbJUCUBkZ9pyyaq91noAFiz1KGsU0i+qwOsHVeRvynM=;
	h=Date:To:From:Subject:Message-Id; b=nxKYa2sP7qTLZzjknGRQx1bP580ZgwzaSa2cFt72OwJTqUIuwkuYcFi6ezxUklwDY4Hla2wILNsu6bqvwDIjqbN6RcIEqrbN/kTkl80kPtK1Jj9kjj/aPOEs1rdRWH8o9Xlxo+VJlbEY135i7E7XFTrNBlbvTLeawaRnNFHy3zM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0dcnF/7x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0dcnF/7x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79DCC1F000E9;
	Mon, 29 Jun 2026 19:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782759755;
	bh=Ngp+fXNayaLjGwB6E5MClUR84JxRfQdYOGztc0PZD5o=;
	h=Date:To:From:Subject;
	b=0dcnF/7xgqx+0yinSXSApvxVKd3Ru8z9LkKpSohLfERMYbmYvhgib7+j8ChI2HyMJ
	 SOFnKNvkwFJz7jorhVIX0pP36m/1yV12QnbvINPThKwagXN57rvHRR6g/7+vBAh5vv
	 S+MnBnquymjeWdjIDOK+UYYdRx2QIJ8chG0JCBKQ=
Date: Mon, 29 Jun 2026 12:02:35 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,shu17az@gmail.com,jiayuan.chen@shopee.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-tests-core-kunit-test-split-above-max_nr_regions-2.patch added to mm-new branch
Message-Id: <20260629190235.79DCC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/tests/core-kunit: test split above max_nr_regions/2
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-tests-core-kunit-test-split-above-max_nr_regions-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-tests-core-kunit-test-split-above-max_nr_regions-2.patch

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

mm-damon-core-split-a-fraction-of-regions-when-nr_regions-exceeds-max-2.patch
mm-damon-tests-core-kunit-test-split-above-max_nr_regions-2.patch

