Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65BF53CF200
	for <mm-commits@vger.kernel.org>; Mon, 31 Aug 2026 23:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788218023; cv=none; b=YfVu6jiBkP3zSk7IKR9VP010KBt4qdfCQNfiL3BqE7d7uknGSqere84Ndw0JgNLDcUZ3r7XXpnHn+afWwAYM9Kzo7p1dmXH+JSwgjqb06FoBWHUYq9zlqXQYV7w3M95WNgViY8W77MTy/KQc2bkOt1XvQyPPoHcCpp5nGX9dIBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788218023; c=relaxed/simple;
	bh=Cz0KGtXmytpi//nAW/ReO0KvReuk0jgPQq72zVAzRpA=;
	h=Date:To:From:Subject:Message-Id; b=UN7RPIYrAVfUjQUqmrkFeUrhAByTtETZ2nMJRskO58/D2KcZ6Q0SG+Dr9/hdXSTM+7XWrMZdMFmEn/a7keZKkb11EDeD/lnuyCXDg3pNG+DPX7imkzrgqxGN383A1f7A4xvwnCyYBEpSweNOqSDT+2ld37eyXYfRsuU5v3iOCJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pJxlPdVB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pJxlPdVB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD5FE1F000E9;
	Mon, 31 Aug 2026 23:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788218020;
	bh=pAjlhT8glPX3sRpJON0llFZUnGcYOeYFUxgq/TWlfSc=;
	h=Date:To:From:Subject;
	b=pJxlPdVBjOefbGZco7iKoZ6YZnRHEEMNRbFdI04+zGTjEWWHtvcOePPoEb+qz6ZiF
	 SyAEY5XLsQXVkkr3yW+gCJ1tihj5z+y9usVStxhiuBzK63JgfIA1rU/NL7JxZwf0L2
	 li79KPfL+HufpEgXlNxSfMnVVzyAjIXKsfdK5NH4=
Date: Mon, 31 Aug 2026 16:13:40 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,davidgow@davidgow.net,brendan.higgins@linux.dev,jasonangelov@ucla.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-kunit-test-damon_valid_probe_params.patch added to mm-new branch
Message-Id: <20260831231340.BD5FE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core-kunit: test damon_valid_probe_params()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-kunit-test-damon_valid_probe_params.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-kunit-test-damon_valid_probe_params.patch

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
From: Jason Angelov <jasonangelov@ucla.edu>
Subject: mm/damon/core-kunit: test damon_valid_probe_params()
Date: Mon, 31 Aug 2026 08:06:49 -0700

damon_valid_probe_params() makes damon_commit_ctx() reject probe
configurations that could overflow a probe_hits counter, a single (weight
* probe_hits) product, or the sum of those products.

Add a kunit test covering each rejection at its boundary:

- samples per aggregation interval: U8_MAX is allowed, one more could
  overflow a probe_hits counter
- single weight: the largest whose product fits in unsigned int is
  allowed, one larger is rejected
- multiple probes: each product fits, but their sum overflows
- no weight set: the validation is skipped

Link: https://lore.kernel.org/20260831150650.84829-3-sj@kernel.org
Signed-off-by: Jason Angelov <jasonangelov@ucla.edu>
Signed-off-by: SJ Park <sj@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@davidgow.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/core-kunit.h |   57 ++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

--- a/mm/damon/tests/core-kunit.h~mm-damon-core-kunit-test-damon_valid_probe_params
+++ a/mm/damon/tests/core-kunit.h
@@ -1338,6 +1338,62 @@ static void damon_test_commit_ctx(struct
 	damon_destroy_ctx(dst);
 }
 
+static void damon_test_valid_probe_params(struct kunit *test)
+{
+	struct damon_ctx *ctx;
+	struct damon_probe *probe, *probe2;
+
+	ctx = damon_new_ctx();
+	if (!ctx)
+		kunit_skip(test, "ctx alloc fail");
+	probe = damon_new_probe();
+	if (!probe) {
+		damon_destroy_ctx(ctx);
+		kunit_skip(test, "probe alloc fail");
+	}
+	damon_add_probe(ctx, probe);
+
+	/* Parameters are validated only if any probe weight is set. */
+	ctx->attrs.sample_interval = 1;
+	ctx->attrs.aggr_interval = 1000000;
+	KUNIT_EXPECT_TRUE(test, damon_valid_probe_params(ctx));
+
+	/* Up to U8_MAX samples per aggregation interval are allowed. */
+	probe->weight = 100;
+	ctx->attrs.aggr_interval = 255;
+	KUNIT_EXPECT_TRUE(test, damon_valid_probe_params(ctx));
+
+	/* More samples could overflow the probe_hits counters. */
+	ctx->attrs.aggr_interval = 256;
+	KUNIT_EXPECT_FALSE(test, damon_valid_probe_params(ctx));
+
+	/* The largest weight whose weighted hit count fits in unsigned int. */
+	ctx->attrs.aggr_interval = 255;
+	probe->weight = UINT_MAX / 255;
+	KUNIT_EXPECT_TRUE(test, damon_valid_probe_params(ctx));
+
+	/* Any larger weight could overflow its weighted hit count. */
+	probe->weight = UINT_MAX / 255 + 1;
+	KUNIT_EXPECT_FALSE(test, damon_valid_probe_params(ctx));
+
+	/* With one sample per aggregation, even the largest weight fits. */
+	ctx->attrs.aggr_interval = 1;
+	probe->weight = UINT_MAX;
+	KUNIT_EXPECT_TRUE(test, damon_valid_probe_params(ctx));
+
+	/* The sum of all probes' weighted hit counts could also overflow. */
+	probe2 = damon_new_probe();
+	if (!probe2) {
+		damon_destroy_ctx(ctx);
+		kunit_skip(test, "probe2 alloc fail");
+	}
+	probe2->weight = 1;
+	damon_add_probe(ctx, probe2);
+	KUNIT_EXPECT_FALSE(test, damon_valid_probe_params(ctx));
+
+	damon_destroy_ctx(ctx);
+}
+
 static void damos_test_filter_out(struct kunit *test)
 {
 	struct damon_target *t;
@@ -1664,6 +1720,7 @@ static struct kunit_case damon_test_case
 	KUNIT_CASE(damos_test_commit_migrate_hot),
 	KUNIT_CASE(damon_test_commit_target_regions),
 	KUNIT_CASE(damon_test_commit_ctx),
+	KUNIT_CASE(damon_test_valid_probe_params),
 	KUNIT_CASE(damos_test_filter_out),
 	KUNIT_CASE(damon_test_feed_loop_next_input),
 	KUNIT_CASE(damon_test_set_filters_default_reject),
_

Patches currently in -mm which might be from jasonangelov@ucla.edu are

mm-damon-core-kunit-test-probe_hits-handling-at-region-split-and-merge.patch
mm-damon-core-kunit-test-damon_valid_probe_params.patch

