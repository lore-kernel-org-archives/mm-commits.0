Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2298D2512DE
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 21:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763675116; cv=none; b=Vru1RKQrGz/+aVRl0FZxgJ/4u9CoQV5xAU8Wwn0j7zq8pbWnqIE01NEZRhbyEG9ZHF1dP++WtV2+EVYyaa18oM6tky9Z76EWj968qvq32kly5Dcr65nsJ1puVQApVKCdBQfHAZnJnoYJDoTskhewSxs3DVAZTWdH7dgNHRIcUSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763675116; c=relaxed/simple;
	bh=UZ1KTJjJnkVZp231G1xbLrbCOYIbzovJZLalsWaYCkw=;
	h=Date:To:From:Subject:Message-Id; b=qBwkrdCz52yRPQak40gClpTcY5Z9UbYTnDw4u4favRj4KXn/B/kB/HpwQyyBAT2xkbWtj+Bk5RD0/Y/AHIbnnAitRSHIf3ij9Alsfi5Hjn3xkKsKKZDRiLxV3zUNKNNRzMXcc/fLSM+TkTx2m3LaWGyDawT6scdSHNGdid2MGAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=opvo7PzL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="opvo7PzL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBC8FC4CEF1;
	Thu, 20 Nov 2025 21:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763675116;
	bh=UZ1KTJjJnkVZp231G1xbLrbCOYIbzovJZLalsWaYCkw=;
	h=Date:To:From:Subject:From;
	b=opvo7PzLZeXYJzBMUqPVZswVLRuq1vc+O0qAY9TQVRu5J7Jj7gA1Kbn2J/GoIPUQU
	 129TVwt2yA2hrWCfb5ExyciM+2SVMG/3fOZe1fYhk3oAPrHjTznP/sLyQTOXm0th/r
	 Q9zVtiThHz9fiioHzlcxdaPZg9QeVM4S9s0ijmYQ=
Date: Thu, 20 Nov 2025 13:45:15 -0800
To: mm-commits@vger.kernel.org,davidgow@google.com,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-tests-core-kunit-add-damon_commit_target_regions-test.patch removed from -mm tree
Message-Id: <20251120214515.EBC8FC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/tests/core-kunit: add damon_commit_target_regions() test
has been removed from the -mm tree.  Its filename was
     mm-damon-tests-core-kunit-add-damon_commit_target_regions-test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/tests/core-kunit: add damon_commit_target_regions() test
Date: Tue, 11 Nov 2025 10:44:10 -0800

Add a new test for damon_commit_target_regions().

Link: https://lkml.kernel.org/r/20251111184415.141757-12-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/core-kunit.h |   65 ++++++++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-add-damon_commit_target_regions-test
+++ a/mm/damon/tests/core-kunit.h
@@ -964,6 +964,70 @@ static void damos_test_commit(struct kun
 			});
 }
 
+static struct damon_target *damon_test_help_setup_target(
+		unsigned long region_start_end[][2], int nr_regions)
+{
+	struct damon_target *t;
+	struct damon_region *r;
+	int i;
+
+	t = damon_new_target();
+	if (!t)
+		return NULL;
+	for (i = 0; i < nr_regions; i++) {
+		r = damon_new_region(region_start_end[i][0],
+				region_start_end[i][1]);
+		if (!r) {
+			damon_free_target(t);
+			return NULL;
+		}
+		damon_add_region(r, t);
+	}
+	return t;
+}
+
+static void damon_test_commit_target_regions_for(struct kunit *test,
+		unsigned long dst_start_end[][2], int nr_dst_regions,
+		unsigned long src_start_end[][2], int nr_src_regions,
+		unsigned long expect_start_end[][2], int nr_expect_regions)
+{
+	struct damon_target *dst_target, *src_target;
+	struct damon_region *r;
+	int i;
+
+	dst_target = damon_test_help_setup_target(dst_start_end, nr_dst_regions);
+	if (!dst_target)
+		kunit_skip(test, "dst target setup fail");
+	src_target = damon_test_help_setup_target(src_start_end, nr_src_regions);
+	if (!src_target) {
+		damon_free_target(dst_target);
+		kunit_skip(test, "src target setup fail");
+	}
+	damon_commit_target_regions(dst_target, src_target, 1);
+	i = 0;
+	damon_for_each_region(r, dst_target) {
+		KUNIT_EXPECT_EQ(test, r->ar.start, expect_start_end[i][0]);
+		KUNIT_EXPECT_EQ(test, r->ar.end, expect_start_end[i][1]);
+		i++;
+	}
+	KUNIT_EXPECT_EQ(test, damon_nr_regions(dst_target), nr_expect_regions);
+	KUNIT_EXPECT_EQ(test, i, nr_expect_regions);
+	damon_free_target(dst_target);
+	damon_free_target(src_target);
+}
+
+static void damon_test_commit_target_regions(struct kunit *test)
+{
+	damon_test_commit_target_regions_for(test,
+			(unsigned long[][2]) {{3, 8}, {8, 10}}, 2,
+			(unsigned long[][2]) {{4, 6}}, 1,
+			(unsigned long[][2]) {{4, 6}}, 1);
+	damon_test_commit_target_regions_for(test,
+			(unsigned long[][2]) {{3, 8}, {8, 10}}, 2,
+			(unsigned long[][2]) {}, 0,
+			(unsigned long[][2]) {{3, 8}, {8, 10}}, 2);
+}
+
 static void damos_test_filter_out(struct kunit *test)
 {
 	struct damon_target *t;
@@ -1170,6 +1234,7 @@ static struct kunit_case damon_test_case
 	KUNIT_CASE(damos_test_commit_dests),
 	KUNIT_CASE(damos_test_commit_filter),
 	KUNIT_CASE(damos_test_commit),
+	KUNIT_CASE(damon_test_commit_target_regions),
 	KUNIT_CASE(damos_test_filter_out),
 	KUNIT_CASE(damon_test_feed_loop_next_input),
 	KUNIT_CASE(damon_test_set_filters_default_reject),
_

Patches currently in -mm which might be from sj@kernel.org are


