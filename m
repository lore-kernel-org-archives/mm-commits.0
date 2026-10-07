Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E97424E1413
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 19:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791401765; cv=none; b=H34HIfvC+HunpO2VRBD1bWEb+xxhAMCZaC47MbbOQ4LdPMZyGXj47kUFZAklfS7s3CAgQT/3FZUi9oa0FTtNzAimm1HupmIdji1hPVO+qCcIzoW9dgX2kTYK0nTX81n+Ywx4WNiUO1Zterujp11J2t+sA4ZQAww8KBzBitx0pOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791401765; c=relaxed/simple;
	bh=Kslbmr20VE5V28J1VMjeOkUtU8eyPKdiZTdrmaxH2PQ=;
	h=Date:To:From:Subject:Message-Id; b=CWmsmSXswDWzHZAgiv5h5Y1bOmyyzz+rkNc6v3DhJrEq4vsB+i/ge1qoMQU5nVLBOxL+kkbMSXIVhYbPhdiV/PwL1cYinTY0nSyEZmJtJnhsxpkl4axX0OAyLk2bHRP2gnSai7SICBB1MEvZCkdoaPhvIQvdu1AJ8W/zdd3HrWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dpNjHOdK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dpNjHOdK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A6F01F000FF;
	Wed,  7 Oct 2026 19:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791401763;
	bh=fqp/7PB760B+rLtNHcNXwb0OqJWt9oIQF3zOWFLP18g=;
	h=Date:To:From:Subject;
	b=dpNjHOdKudf/Dk/TO73OB0eWcWkv5Ib1pt93LD2mYJNSnancDUhdcLuXsH1r4IGm8
	 EDfSh7Y/8SL1asCMZ9ry/sYClnYqR5NjPd13BLgrq4nQvOTfoPlCZLj4+8W4vOKyJa
	 yiLR4zku+5j3e5kbzJXNxdhbcS3G+aoRS44SOx98=
Date: Wed, 07 Oct 2026 12:36:02 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,davidgow@davidgow.net,brendan.higgins@linux.dev,aethernet65535@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-tests-core-kunit-add-test-for-unconditionally-skipping-the-last-region.patch added to mm-unstable branch
Message-Id: <20261007193603.6A6F01F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/tests/core-kunit: add test for unconditionally skipping the last region
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-tests-core-kunit-add-test-for-unconditionally-skipping-the-last-region.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-tests-core-kunit-add-test-for-unconditionally-skipping-the-last-region.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

docs-mm-damon-design-clarify-when-qt_exceeds-increases.patch
docs-mm-damon-design-fix-typos-in-temporal-auto-tuning-algorithm-section.patch
mm-damon-core-skip-quota-score-setup-when-the-quota-is-full.patch
mm-damon-tests-core-kunit-add-test-for-unconditionally-skipping-the-last-region.patch

