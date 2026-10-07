Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 985AE31355B
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334275; cv=none; b=pzgABzcb7Z2SkHJy6ILzV8azrMQeO7u3oMAV16oCR4DtfA9pTkMgkBN3Ag1QIUu1vI6g0S/dmuzg7l3KIDxXXu1NurnipVzAAToL0jHDhZra/lFRy7KIUp+2OSykrfMv0dWOhlLmjrHEAR3RLhAlGH4vupDeWepZijuTA9tEnos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334275; c=relaxed/simple;
	bh=YuSG92sEYhIY4V7Myon3Z3+thp0DmgafO0CUSUmRvi0=;
	h=Date:To:From:Subject:Message-Id; b=RX6hrxaEE2WAQT54SUf6StqGB8hQ8KaNyireLAo78JW8jwhvia6qW4RQ7wTofCy9CO8Bo1dYLJDdNAYUF7sGDG3i5tt5ezCxyS/1tV9HJ3QIJn1GwYvsv8hUTpdfrbdJ8uPUp0nFTXGJUVNw/7ci5ip9xKX7l1V8OlVMEkQFkk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dFXnZgQa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dFXnZgQa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ECE81F0089C;
	Wed,  7 Oct 2026 00:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334274;
	bh=yYfm9xwUusXGY/3cSyNj3XccqAJdZisRNt1lYaYtvLk=;
	h=Date:To:From:Subject;
	b=dFXnZgQa51ZzHMrBEFyJENuTawBB/V8gcA/hp1Vq4klmw/ceydSjUm46tLXDQxnHv
	 w3r5eWTXpIQ/NaQ/vp03mfwuzAkwb0m8a4Bxcdnz/2hlzzSHmRTzco9V3ibMp5zRaC
	 z31aZlRd6pHHCli/ISvJ1Io/b3OTSTDzPSsNXJsU=
Date: Tue, 06 Oct 2026 17:51:14 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,davidgow@davidgow.net,brendan.higgins@linux.dev,jasonangelov@ucla.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-kunit-test-damon_valid_probe_params.patch removed from -mm tree
Message-Id: <20261007005114.6ECE81F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core-kunit: test damon_valid_probe_params()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-kunit-test-damon_valid_probe_params.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@davidgow.net>
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


