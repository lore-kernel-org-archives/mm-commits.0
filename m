Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BD732512DE
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 21:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763675115; cv=none; b=SzGiuzmGtYerz4Ve8Ms6yT0J0/LmGkqw6IN566ChWur9wIW1Ll2kEAdX6kY3LAevkd4Dhl9Zt8HMEundfFtumO0V6nEvoY80bxUghB2BUNXgX8dHbdD2w1WnVqt/UDbNNbiAISqkJyvO3NWeS0GIMEloSPTStpcfWzSYnWlqfQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763675115; c=relaxed/simple;
	bh=vfvue43SllVk7X/OYwsIkM++84c3GRWvD7ei+gUd6is=;
	h=Date:To:From:Subject:Message-Id; b=OWEO3FQwdtRt8Q/eCt9LncJndLu91zO9yJrMJ6ZA6a1y1arahEnvmzZv2qyO5IQkni8S0XPxUeG4sWAYraujexKOrGQUaymXCt0xsFL31d0wL9Dl2JHM0B7RGwNkqlPAiXm5RvEXJ0pXyRhsjEoyeMyx0pZhTxi5q09EjfHRWRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Co3NwTmo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Co3NwTmo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17323C113D0;
	Thu, 20 Nov 2025 21:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763675115;
	bh=vfvue43SllVk7X/OYwsIkM++84c3GRWvD7ei+gUd6is=;
	h=Date:To:From:Subject:From;
	b=Co3NwTmo7aA6Liwy+cV/QSi3Ofy5tbKl8LeAJvpzUngAke4iWXic2wdzXgePOFE25
	 wTecN/qOLcqnFaUZrtRGbS6HCl9MJcJ3CATKsvQ9sncR+bqBDLvwCjGmmhVqsCsEem
	 hKbYr+ZVNQX2KHdd0r4h6o/RtgHo10qL9wfpnSzM=
Date: Thu, 20 Nov 2025 13:45:14 -0800
To: mm-commits@vger.kernel.org,davidgow@google.com,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-tests-core-kunit-add-damos_commit-test.patch removed from -mm tree
Message-Id: <20251120214515.17323C113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/tests/core-kunit: add damos_commit() test
has been removed from the -mm tree.  Its filename was
     mm-damon-tests-core-kunit-add-damos_commit-test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/tests/core-kunit: add damos_commit() test
Date: Tue, 11 Nov 2025 10:44:09 -0800

Add a new unit test for damos_commit().

Link: https://lkml.kernel.org/r/20251111184415.141757-11-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/core-kunit.h |   92 ++++++++++++++++++++++++++++++++++
 1 file changed, 92 insertions(+)

--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-add-damos_commit-test
+++ a/mm/damon/tests/core-kunit.h
@@ -873,6 +873,97 @@ static void damos_test_commit_filter(str
 			});
 }
 
+static void damos_test_help_initailize_scheme(struct damos *scheme)
+{
+	INIT_LIST_HEAD(&scheme->quota.goals);
+	INIT_LIST_HEAD(&scheme->filters);
+	INIT_LIST_HEAD(&scheme->ops_filters);
+}
+
+static void damos_test_commit_for(struct kunit *test, struct damos *dst,
+		struct damos *src)
+{
+	int err;
+
+	damos_test_help_initailize_scheme(dst);
+	damos_test_help_initailize_scheme(src);
+
+	err = damos_commit(dst, src);
+	if (err)
+		kunit_skip(test, "damos_commit fail");
+
+	KUNIT_EXPECT_EQ(test, dst->pattern.min_sz_region,
+			src->pattern.min_sz_region);
+	KUNIT_EXPECT_EQ(test, dst->pattern.max_sz_region,
+			src->pattern.max_sz_region);
+	KUNIT_EXPECT_EQ(test, dst->pattern.min_nr_accesses,
+			src->pattern.min_nr_accesses);
+	KUNIT_EXPECT_EQ(test, dst->pattern.max_nr_accesses,
+			src->pattern.max_nr_accesses);
+	KUNIT_EXPECT_EQ(test, dst->pattern.min_age_region,
+			src->pattern.min_age_region);
+	KUNIT_EXPECT_EQ(test, dst->pattern.max_age_region,
+			src->pattern.max_age_region);
+
+	KUNIT_EXPECT_EQ(test, dst->action, src->action);
+	KUNIT_EXPECT_EQ(test, dst->apply_interval_us, src->apply_interval_us);
+
+	KUNIT_EXPECT_EQ(test, dst->wmarks.metric, src->wmarks.metric);
+	KUNIT_EXPECT_EQ(test, dst->wmarks.interval, src->wmarks.interval);
+	KUNIT_EXPECT_EQ(test, dst->wmarks.high, src->wmarks.high);
+	KUNIT_EXPECT_EQ(test, dst->wmarks.mid, src->wmarks.mid);
+	KUNIT_EXPECT_EQ(test, dst->wmarks.low, src->wmarks.low);
+
+	switch (src->action) {
+	case DAMOS_MIGRATE_COLD:
+	case DAMOS_MIGRATE_HOT:
+		KUNIT_EXPECT_EQ(test, dst->target_nid, src->target_nid);
+		break;
+	default:
+		break;
+	}
+}
+
+static void damos_test_commit(struct kunit *test)
+{
+	damos_test_commit_for(test,
+			&(struct damos){
+				.pattern = (struct damos_access_pattern){
+					1, 2, 3, 4, 5, 6},
+				.action = DAMOS_PAGEOUT,
+				.apply_interval_us = 1000000,
+				.wmarks = (struct damos_watermarks){
+					DAMOS_WMARK_FREE_MEM_RATE,
+					900, 100, 50},
+			},
+			&(struct damos){
+				.pattern = (struct damos_access_pattern){
+					2, 3, 4, 5, 6, 7},
+				.action = DAMOS_PAGEOUT,
+				.apply_interval_us = 2000000,
+				.wmarks = (struct damos_watermarks){
+					DAMOS_WMARK_FREE_MEM_RATE,
+					800, 50, 30},
+			});
+	damos_test_commit_for(test,
+			&(struct damos){
+				.pattern = (struct damos_access_pattern){
+					1, 2, 3, 4, 5, 6},
+				.action = DAMOS_PAGEOUT,
+				.apply_interval_us = 1000000,
+				.wmarks = (struct damos_watermarks){
+					DAMOS_WMARK_FREE_MEM_RATE,
+					900, 100, 50},
+			},
+			&(struct damos){
+				.pattern = (struct damos_access_pattern){
+					2, 3, 4, 5, 6, 7},
+				.action = DAMOS_MIGRATE_HOT,
+				.apply_interval_us = 2000000,
+				.target_nid = 5,
+			});
+}
+
 static void damos_test_filter_out(struct kunit *test)
 {
 	struct damon_target *t;
@@ -1078,6 +1169,7 @@ static struct kunit_case damon_test_case
 	KUNIT_CASE(damos_test_commit_quota),
 	KUNIT_CASE(damos_test_commit_dests),
 	KUNIT_CASE(damos_test_commit_filter),
+	KUNIT_CASE(damos_test_commit),
 	KUNIT_CASE(damos_test_filter_out),
 	KUNIT_CASE(damon_test_feed_loop_next_input),
 	KUNIT_CASE(damon_test_set_filters_default_reject),
_

Patches currently in -mm which might be from sj@kernel.org are


