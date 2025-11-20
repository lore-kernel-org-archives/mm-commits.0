Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D074830170B
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 21:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763675107; cv=none; b=l93dQ5QQOXdvtj2lBoB4Xou1kcOriXhGzy2jaKMjcf2DB2aFYJQBIIjeRa1Avs/98kdaRt+IwYVbie8FSWzRaCmSiPjHdiVfxcUULOLgEFNNs+iFN6O7I/1CoGKPP/J/7lVOzC1aQmlrGAQredlUr2uMMkZ9H5Bf9an1rFSTL68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763675107; c=relaxed/simple;
	bh=227wWzu6V3nWh5fwVbkkEbm00BVA58PUPi7z7SNkdio=;
	h=Date:To:From:Subject:Message-Id; b=GbOWWdMCh1bVg1WHGPQm9e/sq2tKU6tP4rDiaoyWOMx8D2mL6mo9i1UOs1oh4rDeRWYxqxHO+nCYAginjbzAQWenxAaR4NafJ/jYQM7dtTbqUtUpRn0q8PMJQxsDKx5/xn96VhViUK4d2B9mJxQHNW8G4ilqbL9Kp+R1pMf9cN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=g8rW8CFD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="g8rW8CFD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 935F4C4CEF1;
	Thu, 20 Nov 2025 21:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763675107;
	bh=227wWzu6V3nWh5fwVbkkEbm00BVA58PUPi7z7SNkdio=;
	h=Date:To:From:Subject:From;
	b=g8rW8CFDSRCP44k37h7Uizb4PgBwweCjtxhtQNcpOvuk/Z6ROwUC7sle6dQp3mYQl
	 WD/OrXkq1hPAy3kJ68i073F+ohPMJ5Gd0bPcl6yU9gzT0xGXpK6eOc2102JIBtsK83
	 GPVHEt90d3iREWZWg5kaPC30TBan01WH2NQCedZk=
Date: Thu, 20 Nov 2025 13:45:05 -0800
To: mm-commits@vger.kernel.org,davidgow@google.com,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-tests-core-kunit-split-out-damos_test_commit_filter-core-logic.patch removed from -mm tree
Message-Id: <20251120214507.935F4C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/tests/core-kunit: split out damos_test_commit_filter() core logic
has been removed from the -mm tree.  Its filename was
     mm-damon-tests-core-kunit-split-out-damos_test_commit_filter-core-logic.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/tests/core-kunit: split out damos_test_commit_filter() core logic
Date: Tue, 11 Nov 2025 10:44:01 -0800

damos_test_commit_filter() is written for only a single test case.  Split
out the core logic of damos_test_commit_filter() as a general one so that
it can be reused for multiple test cases.

Link: https://lkml.kernel.org/r/20251111184415.141757-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/core-kunit.h |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-split-out-damos_test_commit_filter-core-logic
+++ a/mm/damon/tests/core-kunit.h
@@ -497,6 +497,15 @@ static void damos_test_new_filter(struct
 	damos_destroy_filter(filter);
 }
 
+static void damos_test_commit_filter_for(struct kunit *test,
+		struct damos_filter *dst, struct damos_filter *src)
+{
+	damos_commit_filter(dst, src);
+	KUNIT_EXPECT_EQ(test, dst->type, src->type);
+	KUNIT_EXPECT_EQ(test, dst->matching, src->matching);
+	KUNIT_EXPECT_EQ(test, dst->allow, src->allow);
+}
+
 static void damos_test_commit_filter(struct kunit *test)
 {
 	struct damos_filter src_filter = {
@@ -509,10 +518,7 @@ static void damos_test_commit_filter(str
 		.allow = false,
 	};
 
-	damos_commit_filter(&dst_filter, &src_filter);
-	KUNIT_EXPECT_EQ(test, dst_filter.type, src_filter.type);
-	KUNIT_EXPECT_EQ(test, dst_filter.matching, src_filter.matching);
-	KUNIT_EXPECT_EQ(test, dst_filter.allow, src_filter.allow);
+	damos_test_commit_filter_for(test, &dst_filter, &src_filter);
 }
 
 static void damos_test_filter_out(struct kunit *test)
_

Patches currently in -mm which might be from sj@kernel.org are


