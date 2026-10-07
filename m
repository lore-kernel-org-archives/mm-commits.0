Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8609A30E85D
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334275; cv=none; b=rIHOyLYST1bumjib3W3OivIVZT4nMMn8Z2PVlcJ/w7USLPEBaykNLRYLU2cv7J214eoCF2E/Gu1iOGX373N866aPJVRwlZqgiCnNRFWgY5SYyJ7VaeIwIVtPVlnLt60qWrl4OSUPjKX6gmotTYK8yADqMz4AsrvsmYr8b736i14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334275; c=relaxed/simple;
	bh=5zPxRPfKkhgBfJcKwx7aUjnjAg4CewrIGmUnyBkV/Qs=;
	h=Date:To:From:Subject:Message-Id; b=IZ5UcgQ27+KXkhDFcVztJTW9j+QGa+zzlJjqEyyRLs6NsmUSc4fAslrgGtHG7jh2PrQAdYLcj066dA2lOnqKQHWQC0Kg8XJz2xcrwyhQxqHLOmMlZznr/vqRmZqeJvpwOR/MukAWTfWInUgTwQ7OFXVI1CrOM/lZPAh3a26jgO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NDwRC9yl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NDwRC9yl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D92F1F0089B;
	Wed,  7 Oct 2026 00:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334273;
	bh=y8PcQbovAoPwNRPJbeERpx1S/ED3kZQUc6Ftl+ikNas=;
	h=Date:To:From:Subject;
	b=NDwRC9ylvb8l1aKhGWJTcPO3kVjur16yveuLAQmT4Ld3TqZ92ho7uBefmrbvIHZv1
	 QH/dItXy9A3nc0bY8HdQ67+m8MWlWjYzW+iS/pZtL3B916V1mT8uQhBoZdy2adYZNw
	 J48CULJ1SoRz0jlGcXLJ46OtozLFu1d+wBUNK9gg=
Date: Tue, 06 Oct 2026 17:51:12 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,davidgow@davidgow.net,brendan.higgins@linux.dev,jasonangelov@ucla.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-kunit-test-probe_hits-handling-at-region-split-and-merge.patch removed from -mm tree
Message-Id: <20261007005113.5D92F1F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core-kunit: test probe_hits handling at region split and merge
has been removed from the -mm tree.  Its filename was
     mm-damon-core-kunit-test-probe_hits-handling-at-region-split-and-merge.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jason Angelov <jasonangelov@ucla.edu>
Subject: mm/damon/core-kunit: test probe_hits handling at region split and merge
Date: Mon, 31 Aug 2026 08:06:48 -0700

Patch series "mm/damon: add kunit tests for probe_hits handling and probe
params validation", v2.

DAMON recently introduced probes and probe weights.  Add kunit tests for
the propagation of probe_hits at region split and merge, and the rejection
of invalid probe parameters by damon_valid_probe_params().


This patch (of 2):

damon_split_region_at() copies probe_hits[] and last_probe_hits[] to the
new split region.

damon_merge_two_regions() sets probe_hits[] to the size-weighted
average of the merged regions.

Extend damon_test_split_at() and damon_test_merge_two() tests to cover
those fields.

Link: https://lore.kernel.org/20260831150650.84829-1-sj@kernel.org
Link: https://lore.kernel.org/20260831150650.84829-2-sj@kernel.org
Signed-off-by: Jason Angelov <jasonangelov@ucla.edu>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: David Gow <davidgow@davidgow.net>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
---

 mm/damon/tests/core-kunit.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/damon/tests/core-kunit.h~mm-damon-core-kunit-test-probe_hits-handling-at-region-split-and-merge
+++ a/mm/damon/tests/core-kunit.h
@@ -152,6 +152,8 @@ static void damon_test_split_at(struct k
 	}
 	r->nr_accesses = 42;
 	r->last_nr_accesses = 15;
+	r->probe_hits[0] = 7;
+	r->last_probe_hits[0] = 3;
 	r->age = 10;
 	damon_add_region(r, t);
 	damon_split_region_at(t, r, 25);
@@ -168,6 +170,8 @@ static void damon_test_split_at(struct k
 
 	KUNIT_EXPECT_EQ(test, r->nr_accesses, r_new->nr_accesses);
 	KUNIT_EXPECT_EQ(test, r->last_nr_accesses, r_new->last_nr_accesses);
+	KUNIT_EXPECT_EQ(test, r->probe_hits[0], r_new->probe_hits[0]);
+	KUNIT_EXPECT_EQ(test, r->last_probe_hits[0], r_new->last_probe_hits[0]);
 	KUNIT_EXPECT_EQ(test, r->age, r_new->age);
 
 out:
@@ -189,6 +193,7 @@ static void damon_test_merge_two(struct
 		kunit_skip(test, "region alloc fail");
 	}
 	r->nr_accesses = 10;
+	r->probe_hits[0] = 6;
 	r->age = 9;
 	damon_add_region(r, t);
 	r2 = damon_new_region(100, 300);
@@ -197,6 +202,7 @@ static void damon_test_merge_two(struct
 		kunit_skip(test, "second region alloc fail");
 	}
 	r2->nr_accesses = 20;
+	r2->probe_hits[0] = 14;
 	r2->age = 21;
 	damon_add_region(r2, t);
 
@@ -204,6 +210,7 @@ static void damon_test_merge_two(struct
 	KUNIT_EXPECT_EQ(test, r->ar.start, 0ul);
 	KUNIT_EXPECT_EQ(test, r->ar.end, 300ul);
 	KUNIT_EXPECT_EQ(test, r->nr_accesses, 16u);
+	KUNIT_EXPECT_EQ(test, r->probe_hits[0], 11);
 	KUNIT_EXPECT_EQ(test, r->age, 17u);
 
 	i = 0;
_

Patches currently in -mm which might be from jasonangelov@ucla.edu are


