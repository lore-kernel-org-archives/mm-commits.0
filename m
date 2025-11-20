Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C2A23EAA5
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 21:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763675112; cv=none; b=WPHcnRSmNxAoLZr1FCwRbxMNWLP76PRDLv49Sc2UAk74TsGGq9QRpfoKjoA2pHTLZ/Ip9MKyJ64fs+dkmBpnWXTY9cEiJw6ALP7HNWmp1UZsum4qaNLx49bMxW4kSCLzn82VXtOBaoDTurjsL1+u8tfY1q/sgB4T0cWsA4YpkSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763675112; c=relaxed/simple;
	bh=LJOxELiOLjo/0GvXfhuUx+4W/WTuiqb9kShD4jdJJv4=;
	h=Date:To:From:Subject:Message-Id; b=BtkRfhDfLRlGmIAMqhIap0EAD+XaghN+47qvPpJ+7JY2nKP6WgbeIl/kniv6YVS8qKrY9t1pezsc9jeKx9T7ayt7wrt9D7m6LVtPAmalMJjMqkrtzSICB+us6GOd53Whou3fNGm1QwdbBCwFLqq2rShy4ZyXiDd0o5HCniTuteU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QLV5XtrU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QLV5XtrU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59CF4C4CEF1;
	Thu, 20 Nov 2025 21:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763675112;
	bh=LJOxELiOLjo/0GvXfhuUx+4W/WTuiqb9kShD4jdJJv4=;
	h=Date:To:From:Subject:From;
	b=QLV5XtrU5yecY+zRh9FHPI8+VoCnGlS0Ix94tnQCfLOmxQg08yzzLvcJrd+AiXbRu
	 jdyUNV+5Odqjqe5QTZ4Nj4aFEFIBmK4ghcfLQ9qmkxOFNpQlC4PTI5GeZb/MYr+/w6
	 izaVz8HiEweE6yhFdQnnI9szQmGDWa/j2mnVtL7k=
Date: Thu, 20 Nov 2025 13:45:11 -0800
To: mm-commits@vger.kernel.org,davidgow@google.com,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-tests-core-kunit-add-damos_commit_quota-test.patch removed from -mm tree
Message-Id: <20251120214512.59CF4C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/tests/core-kunit: add damos_commit_quota() test
has been removed from the -mm tree.  Its filename was
     mm-damon-tests-core-kunit-add-damos_commit_quota-test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/tests/core-kunit: add damos_commit_quota() test
Date: Tue, 11 Nov 2025 10:44:06 -0800

Add a new unit test for damos_commit_quota().

Link: https://lkml.kernel.org/r/20251111184415.141757-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/core-kunit.h |   33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-add-damos_commit_quota-test
+++ a/mm/damon/tests/core-kunit.h
@@ -660,6 +660,38 @@ static void damos_test_commit_quota_goal
 			(struct damos_quota_goal[]){}, 0);
 }
 
+static void damos_test_commit_quota(struct kunit *test)
+{
+	struct damos_quota dst = {
+		.reset_interval = 1,
+		.ms = 2,
+		.sz = 3,
+		.weight_sz = 4,
+		.weight_nr_accesses = 5,
+		.weight_age = 6,
+	};
+	struct damos_quota src = {
+		.reset_interval = 7,
+		.ms = 8,
+		.sz = 9,
+		.weight_sz = 10,
+		.weight_nr_accesses = 11,
+		.weight_age = 12,
+	};
+
+	INIT_LIST_HEAD(&dst.goals);
+	INIT_LIST_HEAD(&src.goals);
+
+	damos_commit_quota(&dst, &src);
+
+	KUNIT_EXPECT_EQ(test, dst.reset_interval, src.reset_interval);
+	KUNIT_EXPECT_EQ(test, dst.ms, src.ms);
+	KUNIT_EXPECT_EQ(test, dst.sz, src.sz);
+	KUNIT_EXPECT_EQ(test, dst.weight_sz, src.weight_sz);
+	KUNIT_EXPECT_EQ(test, dst.weight_nr_accesses, src.weight_nr_accesses);
+	KUNIT_EXPECT_EQ(test, dst.weight_age, src.weight_age);
+}
+
 static void damos_test_commit_filter_for(struct kunit *test,
 		struct damos_filter *dst, struct damos_filter *src)
 {
@@ -947,6 +979,7 @@ static struct kunit_case damon_test_case
 	KUNIT_CASE(damos_test_new_filter),
 	KUNIT_CASE(damos_test_commit_quota_goal),
 	KUNIT_CASE(damos_test_commit_quota_goals),
+	KUNIT_CASE(damos_test_commit_quota),
 	KUNIT_CASE(damos_test_commit_filter),
 	KUNIT_CASE(damos_test_filter_out),
 	KUNIT_CASE(damon_test_feed_loop_next_input),
_

Patches currently in -mm which might be from sj@kernel.org are


