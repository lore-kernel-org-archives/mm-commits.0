Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D4B80029
	for <mm-commits@vger.kernel.org>; Tue, 12 Dec 2023 18:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KiorYfTN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EFCAC433C7;
	Tue, 12 Dec 2023 18:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702407573;
	bh=I9SR5fX8FEtYXP7boTlSyTe4lrnGb9udT2FJYt9aMp4=;
	h=Date:To:From:Subject:From;
	b=KiorYfTNIPPFvbESPqCRAvSA7as7dERbqhBTm9qzKJgQ8//a9LrZ0Efz9iI9SnoE/
	 Hl1vzbggAMNUyUflj4KQBlkMa+D00oOskkfjXyjFQESVfiGmSU8Wiy94NG0qCVFHyI
	 8HtKcTS2cQ3gNzMBmwfU6J1AnjxSw5vHvFlfywOs=
Date: Tue, 12 Dec 2023 10:59:32 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,davidgow@google.com,corbet@lwn.net,brendanhiggins@google.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-test-add-a-unit-test-for-the-feedback-loop-algorithm.patch removed from -mm tree
Message-Id: <20231212185933.1EFCAC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core-test: add a unit test for the feedback loop algorithm
has been removed from the -mm tree.  Its filename was
     mm-damon-core-test-add-a-unit-test-for-the-feedback-loop-algorithm.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core-test: add a unit test for the feedback loop algorithm
Date: Thu, 30 Nov 2023 02:36:48 +0000

Implement a simple kunit test for testing the behavior of the feedback
loop algorithm for the aim-oriented feedback-friven DAMOS aggressiveness
auto tuning.

Link: https://lkml.kernel.org/r/20231130023652.50284-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: David Gow <davidgow@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core-test.h |   32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

--- a/mm/damon/core-test.h~mm-damon-core-test-add-a-unit-test-for-the-feedback-loop-algorithm
+++ a/mm/damon/core-test.h
@@ -446,6 +446,37 @@ static void damos_test_filter_out(struct
 	damos_free_filter(f);
 }
 
+static void damon_test_feed_loop_next_input(struct kunit *test)
+{
+	unsigned long last_input = 900000, current_score = 200;
+
+	/*
+	 * If current score is lower than the goal, which is always 10,000
+	 * (read the comment on damon_feed_loop_next_input()'s comment), next
+	 * input should be higher than the last input.
+	 */
+	KUNIT_EXPECT_GT(test,
+			damon_feed_loop_next_input(last_input, current_score),
+			last_input);
+
+	/*
+	 * If current score is higher than the goal, next input should be lower
+	 * than the last input.
+	 */
+	current_score = 250000000;
+	KUNIT_EXPECT_LT(test,
+			damon_feed_loop_next_input(last_input, current_score),
+			last_input);
+
+	/*
+	 * The next input depends on the distance between the current score and
+	 * the goal
+	 */
+	KUNIT_EXPECT_GT(test,
+			damon_feed_loop_next_input(last_input, 200),
+			damon_feed_loop_next_input(last_input, 2000));
+}
+
 static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_target),
 	KUNIT_CASE(damon_test_regions),
@@ -461,6 +492,7 @@ static struct kunit_case damon_test_case
 	KUNIT_CASE(damon_test_moving_sum),
 	KUNIT_CASE(damos_test_new_filter),
 	KUNIT_CASE(damos_test_filter_out),
+	KUNIT_CASE(damon_test_feed_loop_next_input),
 	{},
 };
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-make-damon_start-waits-until-kdamond_fn-starts.patch

