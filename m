Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E11A82FD693
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 21:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763675112; cv=none; b=m1EXaMYPQxtPwHdbVKuKtcXiCMesGaxexQ/2Vl1fBLggf/i3TVkHmJotr4GqZEbkGIprIJ+Ekn39TXNWhrvu87yOSGMTPAwluloavorHFjx9DGgn8UfjnRDzQLFzevLCtTw+6r1qSaBdXY7lXQvwdUgaA4TF9KMNMWZD2ZVtkJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763675112; c=relaxed/simple;
	bh=O8qfhvTMMY1Q7cgdabMZrXUQZ/nS6hWQFDCieOms3V4=;
	h=Date:To:From:Subject:Message-Id; b=lqo94VFpkg00IHnNSdTwwD/svOBccxOiivCsOfeZxRkJLUa17IGt5+Em2d9W8WIMoeOwnDCRf2xnbEys6l19NxgeiOMcy5zMdVHxK95bcZ2krpZK2l9q8CAiiEvE0DDBz7fddeC/6RkboAyzqjUP6MUt/yHdXeDibzKYLciQfS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zw0iWm0Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zw0iWm0Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E00CC4CEF1;
	Thu, 20 Nov 2025 21:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763675111;
	bh=O8qfhvTMMY1Q7cgdabMZrXUQZ/nS6hWQFDCieOms3V4=;
	h=Date:To:From:Subject:From;
	b=zw0iWm0QCiJBNsFX51Xn5jMrko7CuyP7caYAFgV2y2KJPmwp4CSV1ZdIy0QgAIqRX
	 oc0wcJngsr2EP9Qkq7OH9x2jPXvnbmmPZn4KLH+ATFb+PTneE5BMtb42Syj1Ck7QyJ
	 6kuzlVBkGKmkG3q+boYvlC3sDSjfniKuziyn6r+U=
Date: Thu, 20 Nov 2025 13:45:10 -0800
To: mm-commits@vger.kernel.org,davidgow@google.com,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-tests-core-kunit-add-damos_commit_quota_goals-test.patch removed from -mm tree
Message-Id: <20251120214511.6E00CC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/tests/core-kunit: add damos_commit_quota_goals() test
has been removed from the -mm tree.  Its filename was
     mm-damon-tests-core-kunit-add-damos_commit_quota_goals-test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/tests/core-kunit: add damos_commit_quota_goals() test
Date: Tue, 11 Nov 2025 10:44:05 -0800

Add a new unit test for damos_commit_quota_goals().

Link: https://lkml.kernel.org/r/20251111184415.141757-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/core-kunit.h |   81 ++++++++++++++++++++++++++++++++++
 1 file changed, 81 insertions(+)

--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-add-damos_commit_quota_goals-test
+++ a/mm/damon/tests/core-kunit.h
@@ -580,6 +580,86 @@ static void damos_test_commit_quota_goal
 			});
 }
 
+static void damos_test_commit_quota_goals_for(struct kunit *test,
+		struct damos_quota_goal *dst_goals, int nr_dst_goals,
+		struct damos_quota_goal *src_goals, int nr_src_goals)
+{
+	struct damos_quota dst, src;
+	struct damos_quota_goal *goal, *next;
+	bool skip = true;
+	int i;
+
+	INIT_LIST_HEAD(&dst.goals);
+	INIT_LIST_HEAD(&src.goals);
+
+	for (i = 0; i < nr_dst_goals; i++) {
+		/*
+		 * When nr_src_goals is smaller than dst_goals,
+		 * damos_commit_quota_goals() will kfree() the dst goals.
+		 * Make it kfree()-able.
+		 */
+		goal = damos_new_quota_goal(dst_goals[i].metric,
+				dst_goals[i].target_value);
+		if (!goal)
+			goto out;
+		damos_add_quota_goal(&dst, goal);
+	}
+	skip = false;
+	for (i = 0; i < nr_src_goals; i++)
+		damos_add_quota_goal(&src, &src_goals[i]);
+
+	damos_commit_quota_goals(&dst, &src);
+
+	i = 0;
+	damos_for_each_quota_goal(goal, (&dst)) {
+		KUNIT_EXPECT_EQ(test, goal->metric, src_goals[i].metric);
+		KUNIT_EXPECT_EQ(test, goal->target_value,
+				src_goals[i++].target_value);
+	}
+	KUNIT_EXPECT_EQ(test, i, nr_src_goals);
+
+out:
+	damos_for_each_quota_goal_safe(goal, next, (&dst))
+		damos_destroy_quota_goal(goal);
+	if (skip)
+		kunit_skip(test, "goal alloc fail");
+}
+
+static void damos_test_commit_quota_goals(struct kunit *test)
+{
+	damos_test_commit_quota_goals_for(test,
+			(struct damos_quota_goal[]){}, 0,
+			(struct damos_quota_goal[]){
+				{
+				.metric = DAMOS_QUOTA_USER_INPUT,
+				.target_value = 123,
+				},
+			}, 1);
+	damos_test_commit_quota_goals_for(test,
+			(struct damos_quota_goal[]){
+				{
+				.metric = DAMOS_QUOTA_USER_INPUT,
+				.target_value = 234,
+				},
+
+			}, 1,
+			(struct damos_quota_goal[]){
+				{
+				.metric = DAMOS_QUOTA_USER_INPUT,
+				.target_value = 345,
+				},
+			}, 1);
+	damos_test_commit_quota_goals_for(test,
+			(struct damos_quota_goal[]){
+				{
+				.metric = DAMOS_QUOTA_USER_INPUT,
+				.target_value = 456,
+				},
+
+			}, 1,
+			(struct damos_quota_goal[]){}, 0);
+}
+
 static void damos_test_commit_filter_for(struct kunit *test,
 		struct damos_filter *dst, struct damos_filter *src)
 {
@@ -866,6 +946,7 @@ static struct kunit_case damon_test_case
 	KUNIT_CASE(damon_test_moving_sum),
 	KUNIT_CASE(damos_test_new_filter),
 	KUNIT_CASE(damos_test_commit_quota_goal),
+	KUNIT_CASE(damos_test_commit_quota_goals),
 	KUNIT_CASE(damos_test_commit_filter),
 	KUNIT_CASE(damos_test_filter_out),
 	KUNIT_CASE(damon_test_feed_loop_next_input),
_

Patches currently in -mm which might be from sj@kernel.org are


