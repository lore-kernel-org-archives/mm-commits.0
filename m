Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C4CD3B9617;
	Fri,  7 Aug 2026 02:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068079; cv=none; b=DvnPsLlwXN32Oe1NLU8Syv2PctJgmtnbjt3zg122jXAVasxPuDohiAIWqbqFm1cRVC5zgfFWrNQ6CfA0A6f1CLNgfxAmXisguUEC5aIQrZGHFARxvUlVP8APQhTy+B5gsa0H3XlvAyN2kEhBjwqDAmg/xpwYxog+6T9ubXbf8wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068079; c=relaxed/simple;
	bh=QuQACvEk4rangUgQ3ZNco+HWi8asF+TpIGCXQMrTO7Y=;
	h=Date:To:From:Subject:Message-Id; b=UfYXd0FaNetfbpli7BdCpUbm3fpIh+/jaqR27sLXafA6/S+BKKZqZJMTRM8kerUA811Rpxo4bper42NrbIr2HYIyhgioEpPv0imavTMGFTxuCMm0JfuWy2UJawHA3FTJ/slzXTiJ9xzc4CF9yEwT8GPg9vc6Yc+5CznPlNadnt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oiNzdFQO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oiNzdFQO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6EA91F000E9;
	Fri,  7 Aug 2026 02:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068075;
	bh=4rWjkW+H2xPCdI6hOPuJ6f1nHRPf1xZcCtPyqrpoUo0=;
	h=Date:To:From:Subject;
	b=oiNzdFQOiuFNH6Xf75fP3PG2z8c2uKSBz9qntfH902OFj0sY9dJLL2zKLHsxODZLs
	 WFmjiw0AjNan/r7u0AS9njfPBkapO8jU4NOu7n5HT/CEYJrWdz3plGiKAiBboHzJcm
	 OIUF1Iexl9dwdm1Dg/rcWaBIb4UbuU4Y1aHdYniE=
Date: Thu, 06 Aug 2026 19:01:15 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-tests-core-kunit-catch-test-failure-in-test_merge_regions_of.patch removed from -mm tree
Message-Id: <20260807020115.A6EA91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/tests/core-kunit: catch test failure in test_merge_regions_of()
has been removed from the -mm tree.  Its filename was
     mm-damon-tests-core-kunit-catch-test-failure-in-test_merge_regions_of.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/tests/core-kunit: catch test failure in test_merge_regions_of()
Date: Tue, 14 Jul 2026 20:09:57 -0700

KUNIT_EXPECT_EQ() does not abort the execution of test code when the
expectation is not met.  But damon_test_merge_regions_of() code after its
initial KUNIT_EXPECT_EQ() call assumes the expectation is met.  It does a
per-region test with a hard-coded number of regions that is correct only
if the expectation was met.  As a result, __nth_region_of() could return
NULL, and the test code can dereference NULL pointers.  Fix the issue by
catching the expectation failure and skip the per-region tests.

The user impact on realistic setups should be negligible, as it is a unit
test.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260715031002.108504-3-sj@kernel.org
Link: https://lore.kernel.org/20260710144937.26981-1-sj@kernel.org [1]
Fixes: 17ccae8bb5c9 ("mm/damon: add kunit tests")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/core-kunit.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-catch-test-failure-in-test_merge_regions_of
+++ a/mm/damon/tests/core-kunit.h
@@ -260,11 +260,14 @@ static void damon_test_merge_regions_of(
 	damon_merge_regions_of(t, 9, 9999, ctx, true);
 	/* 0-112, 114-130, 130-156, 156-170, 170-230, 230-10170 */
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 6u);
+	if (damon_nr_regions(t) != 6)
+		goto out;
 	for (i = 0; i < 6; i++) {
 		r = __nth_region_of(t, i);
 		KUNIT_EXPECT_EQ(test, r->ar.start, saddrs[i]);
 		KUNIT_EXPECT_EQ(test, r->ar.end, eaddrs[i]);
 	}
+out:
 	damon_free_target(t);
 	damon_destroy_ctx(ctx);
 }
_

Patches currently in -mm which might be from sj@kernel.org are


