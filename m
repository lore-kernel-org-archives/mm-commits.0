Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C9E281530
	for <mm-commits@vger.kernel.org>; Sun, 28 Dec 2025 23:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766962915; cv=none; b=T+jZUvXGcsB5vUjZuceCF7p5qAFPZnp3Ha24te2JLfdWKU502Idn+pucY7kQJ3zhGkwatkgSRxvLGxiKMj7z3pBfsTtVOSTdlSS5fDsc5m2aeFYcWY8JNGqgAopOXhC8DzmAbsKQzt8nFB4jrGbnZIArEFdjO3FelRmd0iIFn24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766962915; c=relaxed/simple;
	bh=ejnPVXClxOyKVaRZPdRpUI2/cGmaQIHaFF6h8v6fokQ=;
	h=Date:To:From:Subject:Message-Id; b=icmvhbl86wZRtju7bXMzPLi39dq7HyPbzcZ9BCf6w3a5IDdjI6RHA2a8Ix8y0ddLz1pmuSqdVl/zOIakSvshUz/cBLHYHOg34jxv0hC7AsuVAXZrq15+IMvpXY0oZJ/EnO+YwSq2COtXuna3r28ILYYABxGwrxOGxKMCnRGB33U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fwNekhhP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fwNekhhP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36145C4CEFB;
	Sun, 28 Dec 2025 23:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766962915;
	bh=ejnPVXClxOyKVaRZPdRpUI2/cGmaQIHaFF6h8v6fokQ=;
	h=Date:To:From:Subject:From;
	b=fwNekhhP7Q1YtD4HVt+X531oJhj2o+atExlEpXh6mc7jOh3HX3q0+3n+eZIRFMf7Y
	 t2Xsr3B63pez9A3/FpfyQzpaaTiiGXX756hx9y0THF+b7+GJwuctIBMMDVshRaOuyC
	 FLJ1l6wkh/UVUQ6BZlsRWWuvSZn9dXtMZ50L+vA4=
Date: Sun, 28 Dec 2025 15:01:54 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,shu17az@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-tests-core-kunit-verify-the-age-and-nr_accesses_bp-fields-in-damon_test_merge_two.patch added to mm-new branch
Message-Id: <20251228230155.36145C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/tests/core-kunit: verify the 'age' and 'nr_accesses_bp' fields in damon_test_merge_two()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-tests-core-kunit-verify-the-age-and-nr_accesses_bp-fields-in-damon_test_merge_two.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-tests-core-kunit-verify-the-age-and-nr_accesses_bp-fields-in-damon_test_merge_two.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Shu Anzai <shu17az@gmail.com>
Subject: mm/damon/tests/core-kunit: verify the 'age' and 'nr_accesses_bp' fields in damon_test_merge_two()
Date: Wed, 24 Dec 2025 04:21:57 +0000

Extend damon_test_merge_two() to verify the 'age' and 'nr_accesses_bp'
fields.

Link: https://lkml.kernel.org/r/20251224042200.2061847-3-shu17az@gmail.com
Signed-off-by: Shu Anzai <shu17az@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/core-kunit.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-verify-the-age-and-nr_accesses_bp-fields-in-damon_test_merge_two
+++ a/mm/damon/tests/core-kunit.h
@@ -192,6 +192,7 @@ static void damon_test_merge_two(struct
 	}
 	r->nr_accesses = 10;
 	r->nr_accesses_bp = 100000;
+	r->age = 9;
 	damon_add_region(r, t);
 	r2 = damon_new_region(100, 300);
 	if (!r2) {
@@ -200,12 +201,15 @@ static void damon_test_merge_two(struct
 	}
 	r2->nr_accesses = 20;
 	r2->nr_accesses_bp = 200000;
+	r2->age = 21;
 	damon_add_region(r2, t);
 
 	damon_merge_two_regions(t, r, r2);
 	KUNIT_EXPECT_EQ(test, r->ar.start, 0ul);
 	KUNIT_EXPECT_EQ(test, r->ar.end, 300ul);
 	KUNIT_EXPECT_EQ(test, r->nr_accesses, 16u);
+	KUNIT_EXPECT_EQ(test, r->nr_accesses_bp, 160000u);
+	KUNIT_EXPECT_EQ(test, r->age, 17u);
 
 	i = 0;
 	damon_for_each_region(r3, t) {
_

Patches currently in -mm which might be from shu17az@gmail.com are

mm-damon-tests-core-kunit-verify-the-age-field-in-damon_test_split_at.patch
mm-damon-tests-core-kunit-verify-the-age-and-nr_accesses_bp-fields-in-damon_test_merge_two.patch
mm-damon-tests-core-kunit-add-a-test-case-for-region-merge-size-limit-in-damon_test_merge_regions_of.patch
mm-damon-tests-core-kunit-add-test-cases-for-multiple-regions-in-damon_test_split_regions_of.patch
mm-damon-tests-core-kunit-remove-a-redundant-test-case-and-add-a-new-test-case-in-damos_test_commit_quota_goal.patch

