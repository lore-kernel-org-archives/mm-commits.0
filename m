Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 964082FE57F
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 21:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763675124; cv=none; b=TuINTFio0MivqTnSqSayG+eO2aCceZoSEY+0ZVf4qbta+GyrRbcJMdlM7Mlv4V7rW66DWiVLRvJm5ZUhrnCphcriKfUP7VoP8Ruz2PzfO7eQ3+r02treUzUVEnEqEizXy9SjkDCPp+hJ3EC6nQEETviX9uKSmsRZWjNbidvewb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763675124; c=relaxed/simple;
	bh=ztBPN1JSBkhWgdPN/X2A886SLrjnna9Pjoi8I5idR/s=;
	h=Date:To:From:Subject:Message-Id; b=QRt5/kLBbKmzXxk8Ztc5QaBzOAIHT2+4B5Y/OVJ1Jp9wVOpGHSF5EfEFWJbNgEvLcyCf5z3QmvXraLkDBZv3jFRRBcddJBlgZfx8gFn3a101ScOwm2rGw92jcu0kDuXdZUfdo+tgNe0EJfjJVSsf1dobQ7TdQ5FKkUlK161PJE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LbmT5ouO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LbmT5ouO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AD6AC4CEF1;
	Thu, 20 Nov 2025 21:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763675124;
	bh=ztBPN1JSBkhWgdPN/X2A886SLrjnna9Pjoi8I5idR/s=;
	h=Date:To:From:Subject:From;
	b=LbmT5ouO76bd2CoY6jySvS/ncyRq4OfLbKUheZdl4WDvA0QwW2ngfDE7rmELXaysj
	 lcLxodGr48gZIViWHF/h4+7eRJlcN1Xs4O8hxoktfWbecuILIjZtNq1mhoiXNeWMl0
	 xn0gHjbnWuQ5GfeP4KOCvRVAnBfS92aTROxn/KVE=
Date: Thu, 20 Nov 2025 13:45:23 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,rppt@kernel.org,ojeda@kernel.org,nathan@kernel.org,morbo@google.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,justinstitt@google.com,hughd@google.com,david@kernel.org,davidgow@google.com,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-tests-core-kunit-remove-damon_min_region-redefinition.patch removed from -mm tree
Message-Id: <20251120214524.6AD6AC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/tests/core-kunit: remove DAMON_MIN_REGION redefinition
has been removed from the -mm tree.  Its filename was
     mm-damon-tests-core-kunit-remove-damon_min_region-redefinition.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/tests/core-kunit: remove DAMON_MIN_REGION redefinition
Date: Wed, 12 Nov 2025 07:41:09 -0800

A few DAMON core functions including damon_set_regions() were hard-coded
to use DAMON_MIN_REGION as their regions management granularity.  For
simple and human-readable unit tests' expectations, DAMON core layer kunit
test re-defines DAMON_MIN_REGION to '1'.

A previous patch series [1] has removed the hard-coded part but kept the
redefinition and updated related function calls to explicitly use
DAMON_MIN_REGION.  Remove the unnecessary redefinition and update relevant
function calls to pass literals (number '1') instead of the
DAMON_MIN_REGION.

Link: https://lkml.kernel.org/r/20251112154114.66053-7-sj@kernel.org
Link: https://lore.kernel.org/20250828171242.59810-1-sj@kernel.org [1]
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Bill Wendling <morbo@google.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c             |    5 ---
 mm/damon/tests/core-kunit.h |   55 ++++++++++++++++------------------
 2 files changed, 26 insertions(+), 34 deletions(-)

--- a/mm/damon/core.c~mm-damon-tests-core-kunit-remove-damon_min_region-redefinition
+++ a/mm/damon/core.c
@@ -20,11 +20,6 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/damon.h>
 
-#ifdef CONFIG_DAMON_KUNIT_TEST
-#undef DAMON_MIN_REGION
-#define DAMON_MIN_REGION 1
-#endif
-
 static DEFINE_MUTEX(damon_lock);
 static int nr_running_ctxs;
 static bool running_exclusive_ctxs;
--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-remove-damon_min_region-redefinition
+++ a/mm/damon/tests/core-kunit.h
@@ -279,7 +279,7 @@ static void damon_test_split_regions_of(
 		kunit_skip(test, "region alloc fail");
 	}
 	damon_add_region(r, t);
-	damon_split_regions_of(t, 2, DAMON_MIN_REGION);
+	damon_split_regions_of(t, 2, 1);
 	KUNIT_EXPECT_LE(test, damon_nr_regions(t), 2u);
 	damon_free_target(t);
 
@@ -292,7 +292,7 @@ static void damon_test_split_regions_of(
 		kunit_skip(test, "second region alloc fail");
 	}
 	damon_add_region(r, t);
-	damon_split_regions_of(t, 4, DAMON_MIN_REGION);
+	damon_split_regions_of(t, 4, 1);
 	KUNIT_EXPECT_LE(test, damon_nr_regions(t), 4u);
 	damon_free_target(t);
 }
@@ -373,7 +373,7 @@ static void damon_test_set_regions(struc
 
 	damon_add_region(r1, t);
 	damon_add_region(r2, t);
-	damon_set_regions(t, &range, 1, DAMON_MIN_REGION);
+	damon_set_regions(t, &range, 1, 1);
 
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 3);
 	damon_for_each_region(r, t) {
@@ -1037,15 +1037,14 @@ static void damos_test_filter_out(struct
 	f = damos_new_filter(DAMOS_FILTER_TYPE_ADDR, true, false);
 	if (!f)
 		kunit_skip(test, "filter alloc fail");
-	f->addr_range = (struct damon_addr_range){
-		.start = DAMON_MIN_REGION * 2, .end = DAMON_MIN_REGION * 6};
+	f->addr_range = (struct damon_addr_range){.start = 2, .end = 6};
 
 	t = damon_new_target();
 	if (!t) {
 		damos_destroy_filter(f);
 		kunit_skip(test, "target alloc fail");
 	}
-	r = damon_new_region(DAMON_MIN_REGION * 3, DAMON_MIN_REGION * 5);
+	r = damon_new_region(3, 5);
 	if (!r) {
 		damos_destroy_filter(f);
 		damon_free_target(t);
@@ -1054,50 +1053,48 @@ static void damos_test_filter_out(struct
 	damon_add_region(r, t);
 
 	/* region in the range */
-	KUNIT_EXPECT_TRUE(test,
-			damos_filter_match(NULL, t, r, f, DAMON_MIN_REGION));
+	KUNIT_EXPECT_TRUE(test, damos_filter_match(NULL, t, r, f, 1));
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 1);
 
 	/* region before the range */
-	r->ar.start = DAMON_MIN_REGION * 1;
-	r->ar.end = DAMON_MIN_REGION * 2;
+	r->ar.start = 1;
+	r->ar.end = 2;
 	KUNIT_EXPECT_FALSE(test,
-			damos_filter_match(NULL, t, r, f, DAMON_MIN_REGION));
+			damos_filter_match(NULL, t, r, f, 1));
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 1);
 
 	/* region after the range */
-	r->ar.start = DAMON_MIN_REGION * 6;
-	r->ar.end = DAMON_MIN_REGION * 8;
+	r->ar.start = 6;
+	r->ar.end = 8;
 	KUNIT_EXPECT_FALSE(test,
-			damos_filter_match(NULL, t, r, f, DAMON_MIN_REGION));
+			damos_filter_match(NULL, t, r, f, 1));
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 1);
 
 	/* region started before the range */
-	r->ar.start = DAMON_MIN_REGION * 1;
-	r->ar.end = DAMON_MIN_REGION * 4;
-	KUNIT_EXPECT_FALSE(test,
-			damos_filter_match(NULL, t, r, f, DAMON_MIN_REGION));
+	r->ar.start = 1;
+	r->ar.end = 4;
+	KUNIT_EXPECT_FALSE(test, damos_filter_match(NULL, t, r, f, 1));
 	/* filter should have split the region */
-	KUNIT_EXPECT_EQ(test, r->ar.start, DAMON_MIN_REGION * 1);
-	KUNIT_EXPECT_EQ(test, r->ar.end, DAMON_MIN_REGION * 2);
+	KUNIT_EXPECT_EQ(test, r->ar.start, 1);
+	KUNIT_EXPECT_EQ(test, r->ar.end, 2);
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 2);
 	r2 = damon_next_region(r);
-	KUNIT_EXPECT_EQ(test, r2->ar.start, DAMON_MIN_REGION * 2);
-	KUNIT_EXPECT_EQ(test, r2->ar.end, DAMON_MIN_REGION * 4);
+	KUNIT_EXPECT_EQ(test, r2->ar.start, 2);
+	KUNIT_EXPECT_EQ(test, r2->ar.end, 4);
 	damon_destroy_region(r2, t);
 
 	/* region started in the range */
-	r->ar.start = DAMON_MIN_REGION * 2;
-	r->ar.end = DAMON_MIN_REGION * 8;
+	r->ar.start = 2;
+	r->ar.end = 8;
 	KUNIT_EXPECT_TRUE(test,
-			damos_filter_match(NULL, t, r, f, DAMON_MIN_REGION));
+			damos_filter_match(NULL, t, r, f, 1));
 	/* filter should have split the region */
-	KUNIT_EXPECT_EQ(test, r->ar.start, DAMON_MIN_REGION * 2);
-	KUNIT_EXPECT_EQ(test, r->ar.end, DAMON_MIN_REGION * 6);
+	KUNIT_EXPECT_EQ(test, r->ar.start, 2);
+	KUNIT_EXPECT_EQ(test, r->ar.end, 6);
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 2);
 	r2 = damon_next_region(r);
-	KUNIT_EXPECT_EQ(test, r2->ar.start, DAMON_MIN_REGION * 6);
-	KUNIT_EXPECT_EQ(test, r2->ar.end, DAMON_MIN_REGION * 8);
+	KUNIT_EXPECT_EQ(test, r2->ar.start, 6);
+	KUNIT_EXPECT_EQ(test, r2->ar.end, 8);
 	damon_destroy_region(r2, t);
 
 	damon_free_target(t);
_

Patches currently in -mm which might be from sj@kernel.org are


