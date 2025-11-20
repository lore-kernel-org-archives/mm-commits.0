Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A0134FF7B
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 21:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763675110; cv=none; b=ImjsclkxJxCKAY4Gcvn+kTT4YPFU2XOXt0l3y31gVJcCO0LMWfaDnkH5z8Jq45WEcccy7Re08BHuLSZJMCBE9eiuPSBuvf4XwowzBuP7d/MBgK5gtfYv24qRt1Xamg8YOsk5LTGBEA4kHpNWeREOpVyyIaRPN8Naym1SEzSkkho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763675110; c=relaxed/simple;
	bh=dGIH4IgiF/pas9sqO1nGiYH/HK12X7bA/PPe8GTp+r0=;
	h=Date:To:From:Subject:Message-Id; b=LzKVdtGONyXNlsUtdM1hahBIhIdmuG8z34JZMeeJC0UHhwVvk2h4clvSWBcdT+Du7j8oVjjZSOpRphbZMekEVAC9rsJMRILJ8zK90sW0kgavWS3v256MFEoa+ys9UybnQFd+znRyDPShi88VGLryV3+FXIMWbLTowMKqczWGUyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rXMeA8D3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rXMeA8D3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87088C4CEF1;
	Thu, 20 Nov 2025 21:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763675110;
	bh=dGIH4IgiF/pas9sqO1nGiYH/HK12X7bA/PPe8GTp+r0=;
	h=Date:To:From:Subject:From;
	b=rXMeA8D3JaklsL0ZBTEoA4Nu+as8Z7vBEfYwrvDwOH0RbynskzuIrFFKM/0alZcfT
	 M2T2/8G71iw8lKuLmXo1OmW8SFTbXTFamj2C4E4ejvVe7LtB1qlKCXhF2wifpi/V3I
	 BRAZSOieb49Rb2r6KBvyGKIZn1LOTx2EbIb/SwTU=
Date: Thu, 20 Nov 2025 13:45:09 -0800
To: mm-commits@vger.kernel.org,davidgow@google.com,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-tests-core-kunit-add-damos_commit_quota_goal-test.patch removed from -mm tree
Message-Id: <20251120214510.87088C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/tests/core-kunit: add damos_commit_quota_goal() test
has been removed from the -mm tree.  Its filename was
     mm-damon-tests-core-kunit-add-damos_commit_quota_goal-test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/tests/core-kunit: add damos_commit_quota_goal() test
Date: Tue, 11 Nov 2025 10:44:04 -0800

Add a new unit test for damos_commit_quota_goal().

Link: https://lkml.kernel.org/r/20251111184415.141757-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/core-kunit.h |   84 ++++++++++++++++++++++++++++++++++
 1 file changed, 84 insertions(+)

--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-add-damos_commit_quota_goal-test
+++ a/mm/damon/tests/core-kunit.h
@@ -497,6 +497,89 @@ static void damos_test_new_filter(struct
 	damos_destroy_filter(filter);
 }
 
+static void damos_test_commit_quota_goal_for(struct kunit *test,
+		struct damos_quota_goal *dst,
+		struct damos_quota_goal *src)
+{
+	u64 dst_last_psi_total = 0;
+
+	if (dst->metric == DAMOS_QUOTA_SOME_MEM_PSI_US)
+		dst_last_psi_total = dst->last_psi_total;
+	damos_commit_quota_goal(dst, src);
+
+	KUNIT_EXPECT_EQ(test, dst->metric, src->metric);
+	KUNIT_EXPECT_EQ(test, dst->target_value, src->target_value);
+	if (src->metric == DAMOS_QUOTA_USER_INPUT)
+		KUNIT_EXPECT_EQ(test, dst->current_value, src->current_value);
+	if (dst_last_psi_total && src->metric == DAMOS_QUOTA_SOME_MEM_PSI_US)
+		KUNIT_EXPECT_EQ(test, dst->last_psi_total, dst_last_psi_total);
+	switch (dst->metric) {
+	case DAMOS_QUOTA_NODE_MEM_USED_BP:
+	case DAMOS_QUOTA_NODE_MEM_FREE_BP:
+		KUNIT_EXPECT_EQ(test, dst->nid, src->nid);
+		break;
+	case DAMOS_QUOTA_NODE_MEMCG_USED_BP:
+	case DAMOS_QUOTA_NODE_MEMCG_FREE_BP:
+		KUNIT_EXPECT_EQ(test, dst->nid, src->nid);
+		KUNIT_EXPECT_EQ(test, dst->memcg_id, src->memcg_id);
+		break;
+	default:
+		break;
+	}
+}
+
+static void damos_test_commit_quota_goal(struct kunit *test)
+{
+	struct damos_quota_goal dst = {
+		.metric = DAMOS_QUOTA_SOME_MEM_PSI_US,
+		.target_value = 1000,
+		.current_value = 123,
+		.last_psi_total = 456,
+	};
+
+	damos_test_commit_quota_goal_for(test, &dst,
+			&(struct damos_quota_goal){
+			.metric = DAMOS_QUOTA_USER_INPUT,
+			.target_value = 789,
+			.current_value = 12});
+	damos_test_commit_quota_goal_for(test, &dst,
+			&(struct damos_quota_goal){
+			.metric = DAMOS_QUOTA_NODE_MEM_FREE_BP,
+			.target_value = 345,
+			.current_value = 678,
+			.nid = 9,
+			});
+	damos_test_commit_quota_goal_for(test, &dst,
+			&(struct damos_quota_goal){
+			.metric = DAMOS_QUOTA_NODE_MEM_USED_BP,
+			.target_value = 12,
+			.current_value = 345,
+			.nid = 6,
+			});
+	damos_test_commit_quota_goal_for(test, &dst,
+			&(struct damos_quota_goal){
+			.metric = DAMOS_QUOTA_NODE_MEMCG_USED_BP,
+			.target_value = 456,
+			.current_value = 567,
+			.nid = 6,
+			.memcg_id = 7,
+			});
+	damos_test_commit_quota_goal_for(test, &dst,
+			&(struct damos_quota_goal){
+			.metric = DAMOS_QUOTA_NODE_MEMCG_FREE_BP,
+			.target_value = 890,
+			.current_value = 901,
+			.nid = 10,
+			.memcg_id = 1,
+			});
+	damos_test_commit_quota_goal_for(test, &dst,
+			&(struct damos_quota_goal) {
+			.metric = DAMOS_QUOTA_USER_INPUT,
+			.target_value = 789,
+			.current_value = 12,
+			});
+}
+
 static void damos_test_commit_filter_for(struct kunit *test,
 		struct damos_filter *dst, struct damos_filter *src)
 {
@@ -782,6 +865,7 @@ static struct kunit_case damon_test_case
 	KUNIT_CASE(damon_test_set_attrs),
 	KUNIT_CASE(damon_test_moving_sum),
 	KUNIT_CASE(damos_test_new_filter),
+	KUNIT_CASE(damos_test_commit_quota_goal),
 	KUNIT_CASE(damos_test_commit_filter),
 	KUNIT_CASE(damos_test_filter_out),
 	KUNIT_CASE(damon_test_feed_loop_next_input),
_

Patches currently in -mm which might be from sj@kernel.org are


