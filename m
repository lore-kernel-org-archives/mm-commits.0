Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832294;
	b=1aw0Qt860tlZ7L5mxRGK/KKw91uJVXNEcM+HWTxC9K7dQLinNe+SBYw8gDB/qbRxU4ZW
	 TSyhN0/Y/WLUWT7McWHp/ny0w2hN61stIWk3WWvYMr54G2iW00yYh9XoAv2xqItczOKAA
	 F8SCbYUnEhHfphY2AZmEje0aaZV6By/9GlZO9DIEfblRLzOCxGbrTInVDBZd4aADRZRU4
	 e6IJMbPo04BnVdtOcrho4HonRbWY9Aoh9fEx/1VqXMoN5qH/n0bn/inBdiRuOPBuia4XD
	 nXp8CQ20wBTANY4HsC/z3ctCLben04qyX0aMRj8dlLw8/KeQHTCG0D91cG6TNSwP3Fg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832294;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=bBLUSh0GvmYx+FQIR9OxKP9yaQ+AuN71p5E3AMLpo/M=;
	b=QlSykRh/1oTcb5NTpQmwi8Fb8ZD6WCeu5BqQwKRND+EuFgwVZlANipZk3t34fsZaM5td
	 1gOf5qDV1QxmxBH3xuRTH/9VUZ4zbeCaQSYet32dVH7BN5OQXvEK1AMEyv+u+5Y8/BXey
	 MfPjJ38j384khQtnLXOUAuFmcWzZISOp0EZ5NGEjfpzbA2lvLkLs/PdIpLXz45pDuegQe
	 HgfImsJ6cVEZVEOyuvwk64vP3kbcGWhZgP89p7FQoY9mA3tGxUZp+sqO6CE2gBLdrbKmB
	 ZXcs4bMxNf7yhf41tu8whQ86Hdfp12y5/sYAjrqXrmIE8ULVlyj7DdxfCJbZkYGLOEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=nKVLo7t0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA06606A326
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=nKVLo7t0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA50F1F01828;
	Sat, 24 Oct 2026 08:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832294;
	bh=bBLUSh0GvmYx+FQIR9OxKP9yaQ+AuN71p5E3AMLpo/M=;
	h=Date:To:From:Subject;
	b=nKVLo7t0A4VgXGhQETlfG+EPhHxruJXN2XAlFNT9ZZLgNieLuJIqkatWqZ7dOXVvj
	 TcxEhN4Fc234Ebga//2uem5I8zoQCkgXTttMy+9QTKtYRj3ASQQrR+1ROfSpEdGK9j
	 t48ldQ5Aa8QSxp5j+p1/75iYM3fPSQKJk2MgnOaU=
Date: Sat, 24 Oct 2026 01:58:13 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,davidgow@davidgow.net,brendan.higgins@linux.dev,donggeunyoo.kernel@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-tests-core-kunit-test-the-temporal-tuners-size-quota-conversion.patch removed from -mm tree
Message-Id: <20261024085813.DA50F1F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/damon/tests/core-kunit: test the temporal tuner's size quota conversion
has been removed from the -mm tree.  Its filename was
     mm-damon-tests-core-kunit-test-the-temporal-tuners-size-quota-conversion.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

