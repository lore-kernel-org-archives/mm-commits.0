Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC38D30F550
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 21:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763675105; cv=none; b=OcApNQNhb7EBSd2YkIDSMTdA9aMnsneWqj28o8iQRtbXJW+OfbsYvra5/JwOK+9y5k6nTTm5hrV2Ll5qLKuf0wyooeGjhPP46+388cGpbj9n0RJOs/OdG3GVQKXHYzG7HErA8Jh5h9fLXC/DIjTqPU2lrMJtNvP4xQg84POTJSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763675105; c=relaxed/simple;
	bh=zAot0K54lr26ycyLIUQiz2Q2eLksATyu+1I8FjpoySw=;
	h=Date:To:From:Subject:Message-Id; b=CfFRKzVVHy+pjGtqvEh8JLAjE1JvQo1YpF4CzpAmHmDHP6UM80Y6lKT8uN1Y+OvqvDnf6IT3sgG3EPD3lRy08yFtyDfFUFFVz4DuLO27SbcF7sLq+FNDIDRrT8lasASaN9tkdANGg/d+3ktjxq6XThS3cthBGrwyE1cyoFTT9Go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=laecjhIg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="laecjhIg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B7B9C4CEF1;
	Thu, 20 Nov 2025 21:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763675105;
	bh=zAot0K54lr26ycyLIUQiz2Q2eLksATyu+1I8FjpoySw=;
	h=Date:To:From:Subject:From;
	b=laecjhIg8dmwYbTG2iXaD1eWPFeRz2NDAEz6V46yqmEZC8lES/pjTkxuCcCxbQHLr
	 952IzzfoF0RnfIKzQ5M/IF8dCxeMbPyYf3gaG+P6/fWkco+E3zIJodp1ehrcd8a3Ns
	 6B9ha2xoef/kfPgVoH0j/M5EQRCtzPxLUpg7YnRc=
Date: Thu, 20 Nov 2025 13:45:04 -0800
To: mm-commits@vger.kernel.org,davidgow@google.com,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-tests-core-kunit-remove-dynamic-allocs-on-damos_test_commit_filter.patch removed from -mm tree
Message-Id: <20251120214505.2B7B9C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/tests/core-kunit: remove dynamic allocs on damos_test_commit_filter()
has been removed from the -mm tree.  Its filename was
     mm-damon-tests-core-kunit-remove-dynamic-allocs-on-damos_test_commit_filter.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/tests/core-kunit: remove dynamic allocs on damos_test_commit_filter()
Date: Tue, 11 Nov 2025 10:44:00 -0800

Patch series "mm/damon/tests: add more tests for online parameters commit".

A DAMON feature called parameters "commit" allows DAMON API callers and
ABI users to update nearly every DAMON parameter while DAMON is running. 
This is being used for flexible DAMON use cases such as taking a snapshot
of the monitoring results with minimum overhead, or adjusting access-aware
system operations (DAMOS) for user-space driven auto-tuning or
investigations.

Compared to the usefulness of the feature and size of the implementation,
the test coverage is pretty small.  Only the filter commit part has a
single test case, namely damos_test_commit_filter().  Actually, we found
and fixed a few bugs of the feature in the past.  The single existing test
was also added to avoid reintroduction of a found bug.

Add more unit tests for the feature.

First four patches (1-4) refactor and extend the existing test for DAMOS
filter commit for multiple test cases.

Next three patches (5-7) add tests for DAMOS quota commit.

Next two patches (8 and 9) refactor damos_commit_dests() for ease of code
reading and test writing, and implement a new unit test of the function
that is being refactored in a test-friendly way.

Final two patches (10 and 11) further add new unit tests for
damos_commit() and damon_commit_target_regions().


This patch (of 11):

damos_test_commit_filter() is dynamically allocating test-purpose DAMOS
filters.  Allocation failure checks are making the code longer,
complicated, and difficult to extend for more test cases.  Refactor the
code to remove the dynamic allocation.

Link: https://lkml.kernel.org/r/20251111184415.141757-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20251111184415.141757-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/core-kunit.h |   29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-remove-dynamic-allocs-on-damos_test_commit_filter
+++ a/mm/damon/tests/core-kunit.h
@@ -499,23 +499,20 @@ static void damos_test_new_filter(struct
 
 static void damos_test_commit_filter(struct kunit *test)
 {
-	struct damos_filter *src_filter, *dst_filter;
+	struct damos_filter src_filter = {
+		.type = DAMOS_FILTER_TYPE_ANON,
+		.matching = true,
+		.allow = true};
+	struct damos_filter dst_filter = {
+		.type = DAMOS_FILTER_TYPE_ACTIVE,
+		.matching = false,
+		.allow = false,
+	};
 
-	src_filter = damos_new_filter(DAMOS_FILTER_TYPE_ANON, true, true);
-	if (!src_filter)
-		kunit_skip(test, "src filter alloc fail");
-	dst_filter = damos_new_filter(DAMOS_FILTER_TYPE_ACTIVE, false, false);
-	if (!dst_filter) {
-		damos_destroy_filter(src_filter);
-		kunit_skip(test, "dst filter alloc fail");
-	}
-	damos_commit_filter(dst_filter, src_filter);
-	KUNIT_EXPECT_EQ(test, dst_filter->type, src_filter->type);
-	KUNIT_EXPECT_EQ(test, dst_filter->matching, src_filter->matching);
-	KUNIT_EXPECT_EQ(test, dst_filter->allow, src_filter->allow);
-
-	damos_destroy_filter(src_filter);
-	damos_destroy_filter(dst_filter);
+	damos_commit_filter(&dst_filter, &src_filter);
+	KUNIT_EXPECT_EQ(test, dst_filter.type, src_filter.type);
+	KUNIT_EXPECT_EQ(test, dst_filter.matching, src_filter.matching);
+	KUNIT_EXPECT_EQ(test, dst_filter.allow, src_filter.allow);
 }
 
 static void damos_test_filter_out(struct kunit *test)
_

Patches currently in -mm which might be from sj@kernel.org are


