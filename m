Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C15F225DA
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 22:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="C0SQMmfA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8D1CC433C7;
	Wed, 20 Dec 2023 22:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703112566;
	bh=SF8BKTx+X3gQA4jprfHhc9sQxaausv6hC2nyHo5HfiY=;
	h=Date:To:From:Subject:From;
	b=C0SQMmfAtmCuNvKf1ffOldRmFslSJjAzGlI1NeYPd+s9uJQqdbrgIKyV7pBuw40+5
	 Mj99pM4th+NywxY4Tjfrv2MftLI16xzzpaXQKwJV+X6jMWVPyV5dy5/SGRCAz2Wz7m
	 7XZWrJPAeFX6k0ULGxmakzpHzz0FdosJ8tZ/AsVU=
Date: Wed, 20 Dec 2023 14:49:25 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-test-test-max_nr_accesses-overflow-caused-divide-by-zero.patch removed from -mm tree
Message-Id: <20231220224925.E8D1CC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core-test: test max_nr_accesses overflow caused divide-by-zero
has been removed from the -mm tree.  Its filename was
     mm-damon-core-test-test-max_nr_accesses-overflow-caused-divide-by-zero.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core-test: test max_nr_accesses overflow caused divide-by-zero
Date: Wed, 13 Dec 2023 19:03:34 +0000

Commit 35f5d94187a6 ("mm/damon: implement a function for max nr_accesses
safe calculation") has fixed an overflow bug that could cause
divide-by-zero.  Add a kunit test for the bug to ensure similar bugs are
not introduced again.

Link: https://lkml.kernel.org/r/20231213190338.54146-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core-test.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/mm/damon/core-test.h~mm-damon-core-test-test-max_nr_accesses-overflow-caused-divide-by-zero
+++ a/mm/damon/core-test.h
@@ -302,6 +302,16 @@ static void damon_test_set_regions(struc
 	damon_destroy_target(t);
 }
 
+static void damon_test_nr_accesses_to_accesses_bp(struct kunit *test)
+{
+	struct damon_attrs attrs = {
+		.sample_interval = 10,
+		.aggr_interval = ((unsigned long)UINT_MAX + 1) * 10
+	};
+
+	KUNIT_EXPECT_EQ(test, damon_nr_accesses_to_accesses_bp(123, &attrs), 0);
+}
+
 static void damon_test_update_monitoring_result(struct kunit *test)
 {
 	struct damon_attrs old_attrs = {
@@ -487,6 +497,7 @@ static struct kunit_case damon_test_case
 	KUNIT_CASE(damon_test_split_regions_of),
 	KUNIT_CASE(damon_test_ops_registration),
 	KUNIT_CASE(damon_test_set_regions),
+	KUNIT_CASE(damon_test_nr_accesses_to_accesses_bp),
 	KUNIT_CASE(damon_test_update_monitoring_result),
 	KUNIT_CASE(damon_test_set_attrs),
 	KUNIT_CASE(damon_test_moving_sum),
_

Patches currently in -mm which might be from sj@kernel.org are


