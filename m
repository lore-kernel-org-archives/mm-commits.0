Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9F321B7F4
	for <mm-commits@vger.kernel.org>; Mon, 18 Aug 2025 01:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755480990; cv=none; b=fZ/11xui8XulUQkPC/YhkOCVnTiESBeF9jYcoj5r+wyaLsLNmEfxF25oDh5jA7cE21khGzzFemP0Q0vUV6jBPeC5jhml+Clh/so+vx/TJwZEl+O1YtA5+cZLCzg+F4gS1+mUjObE5xTmjYHy+mXUrRBiKoGo81y16CS+8bLR+4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755480990; c=relaxed/simple;
	bh=cBw9gvzXEOUB58oiV3ydV6DQFVgfe58MSbz+f6Rnes0=;
	h=Date:To:From:Subject:Message-Id; b=h32kBnBqbWLrkOMhRx/c1I+vmG2V+6fTVZufU7hqtJtWBRUmID8bOERCm5LII9ZQ1vu6VxKmrYs3x7DGxa/lL8Jl8cbgoC7VZQdNCsKFeUCEA4MUIwa1MdjEvhO7dDuu+8L9+0Qtk8P9HU3spQd+foo9yHtjEX7f+DGwi8JlfwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SomxNnKy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SomxNnKy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12C97C4CEEB;
	Mon, 18 Aug 2025 01:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755480990;
	bh=cBw9gvzXEOUB58oiV3ydV6DQFVgfe58MSbz+f6Rnes0=;
	h=Date:To:From:Subject:From;
	b=SomxNnKycQUl0g68L2ooxqTLBDi3uw06znWm2Rk1qbamDWpbzIq21NgX9obVVRjmt
	 00ah7Yym2zBKTnpPGSaQ6lbv6OLGCVfg2jucmERJu5i3fmbpv5sOlqp67G/FQZUy4X
	 omAhNtju70qDR4cWtqXiUTmX+ID8z+MeA3QGoo9E=
Date: Sun, 17 Aug 2025 18:36:29 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,honggyu.kim@sk.com,ekffu200098@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-tests-core-kunit-add-damos_commit_filter-test.patch added to mm-new branch
Message-Id: <20250818013630.12C97C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/tests/core-kunit: add damos_commit_filter test
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-tests-core-kunit-add-damos_commit_filter-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-tests-core-kunit-add-damos_commit_filter-test.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: mm/damon/tests/core-kunit: add damos_commit_filter test
Date: Sun, 17 Aug 2025 11:13:48 +0900

Add unit test to verify that damos_commmit_filter() change dest value
well.

Link: https://lkml.kernel.org/r/20250817021348.570692-1-ekffu200098@gmail.com
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Honggyu Kim <honggyu.kim@sk.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/core-kunit.h |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-add-damos_commit_filter-test
+++ a/mm/damon/tests/core-kunit.h
@@ -419,6 +419,22 @@ static void damos_test_new_filter(struct
 	damos_destroy_filter(filter);
 }
 
+static void damos_test_commit_filter(struct kunit *test)
+{
+	struct damos_filter *src_filter = damos_new_filter(
+		DAMOS_FILTER_TYPE_ANON, true, true);
+	struct damos_filter *dst_filter = damos_new_filter(
+		DAMOS_FILTER_TYPE_ACTIVE, false, false);
+
+	damos_commit_filter(dst_filter, src_filter);
+	KUNIT_EXPECT_EQ(test, dst_filter->type, src_filter->type);
+	KUNIT_EXPECT_EQ(test, dst_filter->matching, src_filter->matching);
+	KUNIT_EXPECT_EQ(test, dst_filter->allow, src_filter->allow);
+
+	damos_destroy_filter(src_filter);
+	damos_destroy_filter(dst_filter);
+}
+
 static void damos_test_filter_out(struct kunit *test)
 {
 	struct damon_target *t;
@@ -594,6 +610,7 @@ static struct kunit_case damon_test_case
 	KUNIT_CASE(damon_test_set_attrs),
 	KUNIT_CASE(damon_test_moving_sum),
 	KUNIT_CASE(damos_test_new_filter),
+	KUNIT_CASE(damos_test_commit_filter),
 	KUNIT_CASE(damos_test_filter_out),
 	KUNIT_CASE(damon_test_feed_loop_next_input),
 	KUNIT_CASE(damon_test_set_filters_default_reject),
_

Patches currently in -mm which might be from ekffu200098@gmail.com are

mm-damon-core-fix-commit_ops_filters-by-using-correct-nth-function.patch
selftests-damon-fix-selftests-by-installing-drgn-related-script.patch
mm-damon-core-fix-damos_commit_filter-not-changing-allow.patch
mm-damon-update-expired-description-of-damos_action.patch
docs-mm-damon-design-fix-typo-s-sz_trtied-sz_tried.patch
selftests-damon-test-no-op-commit-broke-damon-status.patch
mm-damon-tests-core-kunit-add-damos_commit_filter-test.patch

