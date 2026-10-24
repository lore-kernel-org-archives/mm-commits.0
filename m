Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832297;
	b=iyCJE6gdVTX68+39n7HvIN7++/bu2B1dgVfzlePktPpS6XBZkNJfaaq/GVMl1XuPBt7c
	 zMdtaINNonED+yKU0lOVSV1hUAsIL1i7Z/7oXihgvPzigcfCevaWr68Qv8PhHBEyJvLGu
	 hRvaxJqm0fzuGzC08ZpwAOCn45KrQ7bG0lNwtT+K2COfcYYWC+Am8D1zOm+vrOrY03nkC
	 f/Bd1bPbYuC5c76pmkITvscacnqWY+QpPROVo0BIc0nAjcayX/rYQGKrGMQE2jUqTjvjH
	 kPaFSwVG55jYvtWyN4ehglif6Uhqk79sBVWv24708QY9g6cmv0ZDw5GKLceCyCUnoHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832297;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=bsBp1giX/Uu904if8L+JnZl7QTkYak8kLGbFYRA6izY=;
	b=nPGQCh0C1Tf2NovtaBdORQLXeIBWZtG4fcQsaI5Xq1+QXetEMYCyqzSUGJTX12uQosYX
	 kf0uJT6B8LeN1qJgvozlCiIN+Bd2l2kvcGHTfUszBiIt3+A5g6bafXCgwOPsmzsL2tRGs
	 vm6wZ2cu6s3+XVZMomp4UiMoahaV45eAg2V2QWlOG9KAuFDSe42xE7jBRgr1Sybv1khm8
	 5ZpEpbz9eNC8iJkmDIvrHpwzdqXExhvkGBqLL1rKcG6XJzRbUkQxZgtW4NHPVkJxBWW8o
	 bmUxSRO8A7egkx8zs4a7ksT5LH1NrgB5Q7JKdYwHrRY1IyU0k33sATG5/wkYj+Eq2CQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Vq3dIX09;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38482606A31D
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Vq3dIX09
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 033C41F01829;
	Sat, 24 Oct 2026 08:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832297;
	bh=bsBp1giX/Uu904if8L+JnZl7QTkYak8kLGbFYRA6izY=;
	h=Date:To:From:Subject;
	b=Vq3dIX09hNjn6SRPL1sQg03OhllmcU7YAQoDIPyzdxE0qt0D1r2sx9Th84E8jyXJZ
	 /iVjK3SXyv1hu9ajTSlYxbjKHQa9QJlqc1s4TmYtmOUu0RDULi9+dSxaZARFCNMYCC
	 dyj0L/Soz9XDn4kYiF4acvD0qXtPv8zia5e/8IQQ=
Date: Sat, 24 Oct 2026 01:58:16 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,lianux.mm@gmail.com,kunwu.chan@gmail.com,davidgow@davidgow.net,brendan.higgins@linux.dev,kmehltretter@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-tests-core-kunit-test-psi-goal-values-with-explicit-samples.patch removed from -mm tree
Message-Id: <20261024085817.033C41F01829@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/damon/tests/core-kunit: test PSI goal values with explicit samples
has been removed from the -mm tree.  Its filename was
     mm-damon-tests-core-kunit-test-psi-goal-values-with-explicit-samples.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Karl Mehltretter <kmehltretter@gmail.com>
Subject: mm/damon/tests/core-kunit: test PSI goal values with explicit samples
Date: Mon, 28 Sep 2026 01:39:57 -0700

Test the PSI current-value helper with explicit totals so the result does
not depend on the test system's memory pressure.  Cover an unmeasured
consist goal, unmeasured temporal goals with zero and nonzero effective
quotas, and measured rounds for both tuners.  Check last_psi_total after
each call.

Link: https://lore.kernel.org/20260928083959.4030-4-sj@kernel.org
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Assisted-by: LLM
Cc: Lian Wang <lianux.mm@gmail.com>
Cc: Kunwu Chan <kunwu.chan@gmail.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@davidgow.net>
---

 mm/damon/tests/core-kunit.h |   43 ++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-test-psi-goal-values-with-explicit-samples
+++ a/mm/damon/tests/core-kunit.h
@@ -952,6 +952,48 @@ static void damos_test_commit_quota_goal
 			});
 }
 
+static void damos_test_set_psi_current_val(struct kunit *test)
+{
+	struct damos s = {
+		.quota.goal_tuner = DAMOS_QUOTA_GOAL_TUNER_CONSIST,
+	};
+	struct damos_quota_goal goal = {
+		.metric = DAMOS_QUOTA_SOME_MEM_PSI_US,
+		.target_value = 100,
+		.last_psi_total = U64_MAX,
+	};
+
+	/* uninitialized last_psi_total keeps the consist tuner quota */
+	damos_set_psi_current_val(1000, &goal, &s);
+	KUNIT_EXPECT_EQ(test, goal.current_value, 100ul);
+	KUNIT_EXPECT_EQ(test, goal.last_psi_total, 1000ull);
+
+	/* initialized last_psi_total gives the delta */
+	damos_set_psi_current_val(1030, &goal, &s);
+	KUNIT_EXPECT_EQ(test, goal.current_value, 30ul);
+	KUNIT_EXPECT_EQ(test, goal.last_psi_total, 1030ull);
+
+	/* temporal tuner keeps a zero quota */
+	s.quota.goal_tuner = DAMOS_QUOTA_GOAL_TUNER_TEMPORAL;
+	s.quota.esz = 0;
+	goal.last_psi_total = U64_MAX;
+	damos_set_psi_current_val(2000, &goal, &s);
+	KUNIT_EXPECT_EQ(test, goal.current_value, 100ul);
+	KUNIT_EXPECT_EQ(test, goal.last_psi_total, 2000ull);
+
+	/* temporal tuner keeps a non-zero quota */
+	s.quota.esz = SZ_64K;
+	goal.last_psi_total = U64_MAX;
+	damos_set_psi_current_val(3000, &goal, &s);
+	KUNIT_EXPECT_EQ(test, goal.current_value, 0ul);
+	KUNIT_EXPECT_EQ(test, goal.last_psi_total, 3000ull);
+
+	/* temporal tuner uses the measured PSI delta */
+	damos_set_psi_current_val(3250, &goal, &s);
+	KUNIT_EXPECT_EQ(test, goal.current_value, 250ul);
+	KUNIT_EXPECT_EQ(test, goal.last_psi_total, 3250ull);
+}
+
 static void damos_test_commit_quota_goals_for(struct kunit *test,
 		struct damos_quota_goal *dst_goals, int nr_dst_goals,
 		struct damos_quota_goal *src_goals, int nr_src_goals)
@@ -2413,6 +2455,7 @@ static struct kunit_case damon_test_case
 	KUNIT_CASE(damos_test_new_filter),
 	KUNIT_CASE(damos_test_new_scheme_keeps_src_quota),
 	KUNIT_CASE(damos_test_commit_quota_goal),
+	KUNIT_CASE(damos_test_set_psi_current_val),
 	KUNIT_CASE(damos_test_commit_quota_goals),
 	KUNIT_CASE(damos_test_commit_quota),
 	KUNIT_CASE(damos_test_commit_dests),
_

Patches currently in -mm which might be from kmehltretter@gmail.com are

squashfs-fix-fragment-index-table-sizing-overflow-on-32-bit.patch
squashfs-make-the-fragment-index-table-bounds-check-overflow-safe.patch

