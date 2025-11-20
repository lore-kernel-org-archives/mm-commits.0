Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E8962DE6EF
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 21:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763675114; cv=none; b=nW3hNc8AhfahgtoL1zNIu2ky7PnqZtAyhy+tVFgwoExcs0UTkDk5dzTxTx83Eso1bboQ1EhpIWhjjxAFd/FFTSEx/FxeF8ZTdwp1b4ifCoKiDW9BrlBwkTfNySaGpknBRq8FKZFZ7oeHPgy4d8+nuJpOC98z5bNwOowFuQSqCc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763675114; c=relaxed/simple;
	bh=X0iCglYvx1+cr6k+UjRXs+LtP5wUD3s2PfVcqT+CKDk=;
	h=Date:To:From:Subject:Message-Id; b=FIzBe+LHM3y5UHsqFlQJo1kvW4tNkTWgtufgqWOcskJ6Ovrm/xXvwyhPHV5fWoH/YuGjkrxcewWNneq5av+AsbW7CzOjTHjAOq5LHSvr/qNJPbu7szmXMbVRuTQWxG+xp9QsjF5AA8YmzvArRYXCyH6RdF4U8oRQtVQqzAb/riA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DpPWFIif; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DpPWFIif"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 318BEC4CEF1;
	Thu, 20 Nov 2025 21:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763675114;
	bh=X0iCglYvx1+cr6k+UjRXs+LtP5wUD3s2PfVcqT+CKDk=;
	h=Date:To:From:Subject:From;
	b=DpPWFIifsbM4CUnUk3jgdtM19ztZMsrEdONU59Mfng/y4e+zJ2NwpdR+Q6Y3fYkRo
	 /l8EFnriixmurpiajz8B+uaWLvnsp3pOxST1L9C0SpJRV2GX5PcHwIIgibkVRRkTTj
	 HHbqUO0byJyqz5NeIVV4HLiIXZn52Gk4Nm2Ezuj8=
Date: Thu, 20 Nov 2025 13:45:13 -0800
To: mm-commits@vger.kernel.org,davidgow@google.com,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-tests-core-kunit-add-damos_commit_dests-test.patch removed from -mm tree
Message-Id: <20251120214514.318BEC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/tests/core-kunit: add damos_commit_dests() test
has been removed from the -mm tree.  Its filename was
     mm-damon-tests-core-kunit-add-damos_commit_dests-test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/tests/core-kunit: add damos_commit_dests() test
Date: Tue, 11 Nov 2025 10:44:08 -0800

Add a new unit test for damos_commit_dests().

Link: https://lkml.kernel.org/r/20251111184415.141757-10-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/core-kunit.h |   97 ++++++++++++++++++++++++++++++++++
 1 file changed, 97 insertions(+)

--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-add-damos_commit_dests-test
+++ a/mm/damon/tests/core-kunit.h
@@ -692,6 +692,102 @@ static void damos_test_commit_quota(stru
 	KUNIT_EXPECT_EQ(test, dst.weight_age, src.weight_age);
 }
 
+static int damos_test_help_dests_setup(struct damos_migrate_dests *dests,
+		unsigned int *node_id_arr, unsigned int *weight_arr,
+		size_t nr_dests)
+{
+	size_t i;
+
+	dests->node_id_arr = kmalloc_array(nr_dests,
+			sizeof(*dests->node_id_arr), GFP_KERNEL);
+	if (!dests->node_id_arr)
+		return -ENOMEM;
+	dests->weight_arr = kmalloc_array(nr_dests,
+			sizeof(*dests->weight_arr), GFP_KERNEL);
+	if (!dests->weight_arr) {
+		kfree(dests->node_id_arr);
+		dests->node_id_arr = NULL;
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < nr_dests; i++) {
+		dests->node_id_arr[i] = node_id_arr[i];
+		dests->weight_arr[i] = weight_arr[i];
+	}
+	dests->nr_dests = nr_dests;
+	return 0;
+}
+
+static void damos_test_help_dests_free(struct damos_migrate_dests *dests)
+{
+	kfree(dests->node_id_arr);
+	kfree(dests->weight_arr);
+}
+
+static void damos_test_commit_dests_for(struct kunit *test,
+		unsigned int *dst_node_id_arr, unsigned int *dst_weight_arr,
+		size_t dst_nr_dests,
+		unsigned int *src_node_id_arr, unsigned int *src_weight_arr,
+		size_t src_nr_dests)
+{
+	struct damos_migrate_dests dst = {}, src = {};
+	int i, err;
+	bool skip = true;
+
+	err = damos_test_help_dests_setup(&dst, dst_node_id_arr,
+			dst_weight_arr, dst_nr_dests);
+	if (err)
+		kunit_skip(test, "dests setup fail");
+	err = damos_test_help_dests_setup(&src, src_node_id_arr,
+			src_weight_arr, src_nr_dests);
+	if (err) {
+		damos_test_help_dests_free(&dst);
+		kunit_skip(test, "src setup fail");
+	}
+	err = damos_commit_dests(&dst, &src);
+	if (err)
+		goto out;
+	skip = false;
+
+	KUNIT_EXPECT_EQ(test, dst.nr_dests, src_nr_dests);
+	for (i = 0; i < dst.nr_dests; i++) {
+		KUNIT_EXPECT_EQ(test, dst.node_id_arr[i], src_node_id_arr[i]);
+		KUNIT_EXPECT_EQ(test, dst.weight_arr[i], src_weight_arr[i]);
+	}
+
+out:
+	damos_test_help_dests_free(&dst);
+	damos_test_help_dests_free(&src);
+	if (skip)
+		kunit_skip(test, "skip");
+}
+
+static void damos_test_commit_dests(struct kunit *test)
+{
+	damos_test_commit_dests_for(test,
+			(unsigned int[]){1, 2, 3}, (unsigned int[]){2, 3, 4},
+			3,
+			(unsigned int[]){4, 5, 6}, (unsigned int[]){5, 6, 7},
+			3);
+	damos_test_commit_dests_for(test,
+			(unsigned int[]){1, 2}, (unsigned int[]){2, 3},
+			2,
+			(unsigned int[]){4, 5, 6}, (unsigned int[]){5, 6, 7},
+			3);
+	damos_test_commit_dests_for(test,
+			NULL, NULL, 0,
+			(unsigned int[]){4, 5, 6}, (unsigned int[]){5, 6, 7},
+			3);
+	damos_test_commit_dests_for(test,
+			(unsigned int[]){1, 2, 3}, (unsigned int[]){2, 3, 4},
+			3,
+			(unsigned int[]){4, 5}, (unsigned int[]){5, 6}, 2);
+	damos_test_commit_dests_for(test,
+			(unsigned int[]){1, 2, 3}, (unsigned int[]){2, 3, 4},
+			3,
+			NULL, NULL, 0);
+}
+
 static void damos_test_commit_filter_for(struct kunit *test,
 		struct damos_filter *dst, struct damos_filter *src)
 {
@@ -980,6 +1076,7 @@ static struct kunit_case damon_test_case
 	KUNIT_CASE(damos_test_commit_quota_goal),
 	KUNIT_CASE(damos_test_commit_quota_goals),
 	KUNIT_CASE(damos_test_commit_quota),
+	KUNIT_CASE(damos_test_commit_dests),
 	KUNIT_CASE(damos_test_commit_filter),
 	KUNIT_CASE(damos_test_filter_out),
 	KUNIT_CASE(damon_test_feed_loop_next_input),
_

Patches currently in -mm which might be from sj@kernel.org are


