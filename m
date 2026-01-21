Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF9FA34677A
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768966119; cv=none; b=g1iDA/O7knup8YE6oQe9tC5gEX78vGDBs04b2HZ+XNJ2diQgCflg4LfBuYKnpWy/Ebgy/BVbCXZu2hvyGAt1cT5zKfBOPXARa3zGQa6rnfx+zdg5Qp0S6FQwzFT4W0ttJrSiO3SfomcZ5/FFbh0zbJSx2uPDwuGwgo+EHfLbvr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768966119; c=relaxed/simple;
	bh=/FkHIJjD84mR37u/W750h3h3JmLfEgzLVLJBdKrVUVM=;
	h=Date:To:From:Subject:Message-Id; b=k8weHtqm8I9O+2qXaePRc7FbNg9JOANczkKRTTGTa3oe+VZiikiPpe9xUGsPHeYuUckkNPaORLMr7BzuyBEgAaLW+BgD/XhCHkTFSnzLsegNu9dmb25vY9NqPFLkg4c9cEzemXZDIU9IATHRg6j13eFrE2G/XykxoYLYjGHt890=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=y08Wl7UT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="y08Wl7UT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA911C16AAE;
	Wed, 21 Jan 2026 03:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768966118;
	bh=/FkHIJjD84mR37u/W750h3h3JmLfEgzLVLJBdKrVUVM=;
	h=Date:To:From:Subject:From;
	b=y08Wl7UTCYdCcutDz4WSL9x3cLsXlT+SQtbIE23S1LIepC32Eg1ZeTPjJkkXGwZlZ
	 IxARNYZ8Z6cz/YNAwzn6t5n73PZWBwchKVps3025RZ9NFl+cAg0HIF9yvY62B4Y8iy
	 bxXlPRTZDmktuvxU4+A8Bh8swvsbaCB8pMPkGXQo=
Date: Tue, 20 Jan 2026 19:28:38 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,shu17az@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-tests-core-kunit-verify-the-age-field-in-damon_test_split_at.patch removed from -mm tree
Message-Id: <20260121032838.AA911C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/tests/core-kunit: verify the 'age' field in damon_test_split_at()
has been removed from the -mm tree.  Its filename was
     mm-damon-tests-core-kunit-verify-the-age-field-in-damon_test_split_at.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shu Anzai <shu17az@gmail.com>
Subject: mm/damon/tests/core-kunit: verify the 'age' field in damon_test_split_at()
Date: Wed, 24 Dec 2025 04:21:56 +0000

Patch series "mm/damon/tests/core-kunit: extend existing test scenarios",
v2.

Improve the KUnit test coverage for DAMON. 

The five patches in this series respectively extend damon_test_split_at(),
damon_test_merge_two(), damon_test_merge_regions_of(),
damon_test_split_regions_of(), and damos_test_commit_quota_goal().


This patch (of 5):

Extend damon_test_split_at() to verify the 'age' field.

Link: https://lkml.kernel.org/r/20251224042200.2061847-1-shu17az@gmail.com
Link: https://lkml.kernel.org/r/20251224042200.2061847-2-shu17az@gmail.com
Signed-off-by: Shu Anzai <shu17az@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/core-kunit.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-verify-the-age-field-in-damon_test_split_at
+++ a/mm/damon/tests/core-kunit.h
@@ -158,6 +158,7 @@ static void damon_test_split_at(struct k
 	r->nr_accesses_bp = 420000;
 	r->nr_accesses = 42;
 	r->last_nr_accesses = 15;
+	r->age = 10;
 	damon_add_region(r, t);
 	damon_split_region_at(t, r, 25);
 	KUNIT_EXPECT_EQ(test, r->ar.start, 0ul);
@@ -170,6 +171,7 @@ static void damon_test_split_at(struct k
 	KUNIT_EXPECT_EQ(test, r->nr_accesses_bp, r_new->nr_accesses_bp);
 	KUNIT_EXPECT_EQ(test, r->nr_accesses, r_new->nr_accesses);
 	KUNIT_EXPECT_EQ(test, r->last_nr_accesses, r_new->last_nr_accesses);
+	KUNIT_EXPECT_EQ(test, r->age, r_new->age);
 
 	damon_free_target(t);
 }
_

Patches currently in -mm which might be from shu17az@gmail.com are


