Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832461;
	b=hmNJrP+jIkdZr2xV3or7jDtpNY5fJRur7yFlI9uDpKIcQ1dVHDfvm9ItCp9aYt2AtRmb
	 QdxbeaYqSK0MZtt/8M5uSHst7eaTNePLtu+/LpQNuy0tMxaWUg4sLlCzNTz0luYPhfEbF
	 tZzR6m0zgb+j/RdTgP9Ib7sR+SpRUmx5k5rndCcspcPFPvwlaHc7yMf2DJfL8yHLATGzz
	 kwj3S3vNQxCBVtGRkK9najjfhw0P8a15mpXt3W3wH6UV5lDRc9Guauosl3xYSn7AS0Oid
	 mHUoPxM+1CITSEKuOeoOc03Ktfm+kZNihD3Mx10cPHSFFkbzQU8u3dAHCcDaJImiwQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832461;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=NcurkatZ3jTN1gcIyHKqLzjbBc//XBkP9bl/OuhYr34=;
	b=oHbSdKZAMOf8u5WN5lIDvvD5YdRsZ4fJsPb7XJnNh8UvAeaxqqI0huR+FPLaBXMnQz9a
	 IQq88YpFv2Ycc+8DJeL/ADid/fe+zzR+tQ72drsuZ2/ScGZwLDd0DQ1ZQHlwAhipOD6Uz
	 9EL1x0jglSEAfYFJSXvTH1lta0xfMP1corXpZ98R4qSkX77VOVpkUiZpuUU22O508WckU
	 PeMsWLfOebDAjNKuehYz/kclVol1eJ7ROLbyfVj/oVAj97eL9DLD3GXKYgiXV8gQ/z+bW
	 cVjK4bPytaVw/AWSGZ4Ba4WJiRAFI1T8i4cxV9srXuSR4mMBoiuuiZJLUEHZegbdJfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=P26km9L+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00CF2606A31B
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 09:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=P26km9L+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 964711F01825;
	Sat, 24 Oct 2026 09:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832460;
	bh=NcurkatZ3jTN1gcIyHKqLzjbBc//XBkP9bl/OuhYr34=;
	h=Date:To:From:Subject;
	b=P26km9L+5nctKqh/NazlypBNpdjXRSl0qtPd8bnwN5Mnt0Akc70PjqcVbWRno628g
	 NwD4rOdKYWm0dmzPOYeXqz/bFsXxIc1vX+nckTl4oSar0TpmT4Dk47SBe8QA+06NqJ
	 41hfN/phi1vzuDUmwotddUfrjVxTi3QPawNr8auE=
Date: Sat, 24 Oct 2026 02:01:00 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,davidgow@davidgow.net,brendan.higgins@linux.dev,aethernet65535@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-tests-core-kunit-add-test-for-unconditionally-skipping-the-last-region.patch removed from -mm tree
Message-Id: <20261024090100.964711F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/damon/tests/core-kunit: add test for unconditionally skipping the last region
has been removed from the -mm tree.  Its filename was
     mm-damon-tests-core-kunit-add-test-for-unconditionally-skipping-the-last-region.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liew Rui Yan <aethernet65535@gmail.com>
Subject: mm/damon/tests/core-kunit: add test for unconditionally skipping the last region
Date: Mon,  5 Oct 2026 23:52:07 -0700

Commit b3723b596b54 ("mm/damon/core: fix unconditionally skip last
region") fixed a minor bug.

Add a KUnit test case to cover this behavior and prevent regressions in
the future.

Link: https://lore.kernel.org/20261006065209.41507-4-sj@kernel.org
Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@davidgow.net>
---

 mm/damon/tests/core-kunit.h |   42 ++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-add-test-for-unconditionally-skipping-the-last-region
+++ a/mm/damon/tests/core-kunit.h
@@ -2439,6 +2439,47 @@ static void damos_test_esz_goal_temporal
 	damon_destroy_ctx(ctx);
 }
 
+static void damon_test_last_region_quota_reset(struct kunit *test)
+{
+	struct damos s = {0};
+	struct damon_target *t;
+	struct damon_region *r1, *r2;
+	unsigned long min_region_sz = 1;
+	bool skipped;
+
+	t = damon_new_target();
+	if (!t)
+		kunit_skip(test, "target alloc fail");
+
+	r1 = damon_new_region(0, 100);
+	if (!r1) {
+		damon_free_target(t);
+		kunit_skip(test, "region 1 alloc fail");
+	}
+	damon_add_region(r1, t);
+
+	r2 = damon_new_region(100, 200);
+	if (!r2) {
+		damon_free_target(t);
+		kunit_skip(test, "region 2 alloc fail");
+	}
+	damon_add_region(r2, t);
+
+	s.quota.charge_target_from = t;
+	s.quota.charge_addr_from = r1->ar.end;
+
+	skipped = damos_skip_charged_region(t, r2, &s, min_region_sz);
+
+	/* 'r2' is not processed, it should not skip */
+	KUNIT_EXPECT_EQ(test, skipped, false);
+
+	/* 'r2' is last region, it should reset charge_{target,addr}_from */
+	KUNIT_EXPECT_PTR_EQ(test, s.quota.charge_target_from, NULL);
+	KUNIT_EXPECT_EQ(test, s.quota.charge_addr_from, 0);
+
+	damon_free_target(t);
+}
+
 static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_target),
 	KUNIT_CASE(damon_test_regions),
@@ -2482,6 +2523,7 @@ static struct kunit_case damon_test_case
 	KUNIT_CASE(damon_test_walk_control_obsolete),
 	KUNIT_CASE(damon_test_rand),
 	KUNIT_CASE(damos_test_esz_goal_temporal),
+	KUNIT_CASE(damon_test_last_region_quota_reset),
 	{},
 };
 
_

Patches currently in -mm which might be from aethernet65535@gmail.com are


