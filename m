Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795454453;
	b=vegpzBvqXJ+woIaIBFvgf5OlC5g53/RTWmScz1RYADmG+zel4v0EetlySUXANZJvrFXZ
	 30krotdsaCPFN+wgLmso8mXYTXxTnEl0fWGUHEZ9K0paoFEdjdgFZFTgJ7DAxPjA7YbXg
	 GmUdInYINTuQ61jpkX6sSq/mwfQK9XsP9xJiOkKPw3MGSiu2nHV08YcLxmVNcUyUyv+oJ
	 iKXO/Sed9ndF1LbbB7Y+x4JJDi4/x+gUFQxpwsW3PBcSRwtDzGUESu0b/cG+cla0bSgqp
	 hFHgyXRLNBxKstnhcj6xjAxV8aBS//cPNp2HuGBuVidjHNWupfqOk8uIN09tB+RgtQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795454453;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=5NWlbfRmFK/LNQAkhnlSGY6+CpXofyf498DNnv0Rv9g=;
	b=LZdL/6vdaNOKsDTZusKHRN9d7Ct+DMiQ2XmMWfTc3EYtzSDdYoOprQLVO/YX5itDb7sW
	 ccb7xAi9RY3MfBmER4m5Tl5qvaBU1/3gwAAMTVl6lItbt/uCtEb374WAU0GJhkqpDHPL9
	 RXdpti6WVlaNVFClM9CFzwU/b0H4sG79DyTkl903ZeJMpcIs2HtSbJPIk0AfSLCFS6f28
	 +vEN6vAeeaJURzVEq21ug86ZXOvA0qcUxbXnHHDqK0bH9qGrQ+COW7K+IFvC6ySsCRTz3
	 bQj0rV6FZGtduL8HzbGgcjqpnKytX85SBrB/Wv2lCQOVRO5JpKRelkyIG0PSOzZr4cg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=cfwS5hXO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12311606A31E
	for <mm-commits@vger.kernel.org>; Mon, 23 Nov 2026 17:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=cfwS5hXO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3CFB1F000D0;
	Mon, 23 Nov 2026 17:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795454452;
	bh=5NWlbfRmFK/LNQAkhnlSGY6+CpXofyf498DNnv0Rv9g=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=cfwS5hXOYhbun6ZptR3zDgeELnV4xBwppyKsvys2Y98Wu9UV3K2QNwsHcMqExO3pA
	 GOx4Po9OwZ3IkP3vw9t4payMmW8PJHhOvLQE2UCgQdIwJQuHm9O37uiTmQkZZEaRMn
	 xzO8LQdqzGDAjlRBOGwoVO5pmb84imE68qk3i504=
Date: Mon, 23 Nov 2026 09:20:52 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,jm5905938@gmail.com,
	davidgow@davidgow.net,brendan.higgins@linux.dev,jasonangelov@ucla.edu,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261123150929.81797-4-sj@kernel.org>
References: <20261123150929.81797-4-sj@kernel.org>
Subject: + mm-damon-tests-core-kunit-test-damos_filter_type_age_ms-interval-changes.patch added to mm-new branch
Message-Id: <20261123172052.A3CFB1F000D0@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/damon/tests/core-kunit: test DAMOS_FILTER_TYPE_AGE_MS interval changes
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-tests-core-kunit-test-damos_filter_type_age_ms-interval-changes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-tests-core-kunit-test-damos_filter_type_age_ms-interval-changes.patch

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
Subject: mm/damon/tests/core-kunit: test DAMOS_FILTER_TYPE_AGE_MS interval changes
Date: Mon, 23 Nov 2026 07:09:27 -0800

DAMOS_FILTER_TYPE_AGE_MS defines an inclusive range for age in
milliseconds to filter for target regions. Aggregation interval can be
changed by users or intervals auto-tuning features.

Add a kunit test for each:

- convert region age to milliseconds, correct behavior at boundaries
  for defined filter range
- DAMOS_FILTER_TYPE_AGE_MS filter keeps correct behavior even when
  aggregation interval changes

Link: https://patch.msgid.link/20261123150929.81797-4-sj@kernel.org
Signed-off-by: Jason Angelov <jasonangelov@ucla.edu>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Aveline Noir <jm5905938@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@davidgow.net>

 mm/damon/tests/core-kunit.h |   66 ++++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)

--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-test-damos_filter_type_age_ms-interval-changes
+++ a/mm/damon/tests/core-kunit.h
@@ -1838,6 +1838,71 @@ static void damos_test_age_ms_filter_is_
 			damos_filter_for_ops(DAMOS_FILTER_TYPE_AGE_MS));
 }
 
+static void damos_test_age_ms_filter_interval_changes(struct kunit *test)
+{
+	struct damos_filter filter = {
+		.type = DAMOS_FILTER_TYPE_AGE_MS,
+		.matching = true,
+		.range_min = 200,
+		.range_max = 400,
+	};
+	struct damon_ctx *ctx;
+	struct damon_target *t;
+	struct damon_region *r;
+	int err;
+
+	ctx = damon_new_ctx();
+	if (!ctx)
+		kunit_skip(test, "ctx alloc fail");
+	t = damon_new_target();
+	if (!t) {
+		damon_destroy_ctx(ctx);
+		kunit_skip(test, "target alloc fail");
+	}
+	damon_add_target(ctx, t);
+	r = damon_new_region(0, DAMON_MIN_REGION_SZ);
+	if (!r) {
+		damon_destroy_ctx(ctx);
+		kunit_skip(test, "region alloc fail");
+	}
+	damon_add_region(r, t);
+	ctx->attrs.aggr_interval = 100000;
+
+	/* An age of 100 ms is below the 200 ms lower bound. */
+	r->age = 1;
+	KUNIT_EXPECT_FALSE(test, damos_filter_match(ctx, t, r, &filter,
+			ctx->min_region_sz, &err));
+
+	/* An age of 200 ms matches the inclusive lower bound. */
+	r->age = 2;
+	KUNIT_EXPECT_TRUE(test, damos_filter_match(ctx, t, r, &filter,
+			ctx->min_region_sz, &err));
+
+	/* At a 200 ms interval, age 1 matches the lower bound. */
+	ctx->attrs.aggr_interval = 200000;
+	r->age = 1;
+	KUNIT_EXPECT_TRUE(test, damos_filter_match(ctx, t, r, &filter,
+			ctx->min_region_sz, &err));
+
+	/* An age of 400 ms matches the inclusive upper bound. */
+	r->age = 2;
+	KUNIT_EXPECT_TRUE(test, damos_filter_match(ctx, t, r, &filter,
+			ctx->min_region_sz, &err));
+
+	/* At a 50 ms interval, age 8 matches the upper bound. */
+	ctx->attrs.aggr_interval = 50000;
+	r->age = 8;
+	KUNIT_EXPECT_TRUE(test, damos_filter_match(ctx, t, r, &filter,
+			ctx->min_region_sz, &err));
+
+	/* An age of 450 ms exceeds the 400 ms upper bound. */
+	r->age = 9;
+	KUNIT_EXPECT_FALSE(test, damos_filter_match(ctx, t, r, &filter,
+			ctx->min_region_sz, &err));
+
+	damon_destroy_ctx(ctx);
+}
+
 static void damos_test_filter_out(struct kunit *test)
 {
 	struct damon_target *t;
@@ -2600,6 +2665,7 @@ static struct kunit_case damon_test_case
 	KUNIT_CASE(damon_test_commit_ctx_keeps_quota),
 	KUNIT_CASE(damon_test_valid_probe_params),
 	KUNIT_CASE(damos_test_age_ms_filter_is_core),
+	KUNIT_CASE(damos_test_age_ms_filter_interval_changes),
 	KUNIT_CASE(damos_test_filter_out),
 	KUNIT_CASE(damos_test_apply_scheme_filtered_sz),
 	KUNIT_CASE(damos_test_apply_scheme_filter_sz_unchanged),
_

Patches currently in -mm which might be from jasonangelov@ucla.edu are

mm-damon-tests-core-kunit-test-damos_filter_type_age_ms-in-damos_test_commit_filter.patch
mm-damon-tests-core-kunit-test-damos_filter_type_age_ms-in-damos_filter_for_ops.patch
mm-damon-tests-core-kunit-test-damos_filter_type_age_ms-interval-changes.patch

