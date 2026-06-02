Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4DAD3C063E
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439150; cv=none; b=mHqY+ADH7nSohQgnzn1rD57rcf9bF6zloELZj0QpErOkmCJhU7jtTH/guPw+e+J8JQIHr3LC70HmkR81FB03D6TthIF8gc2ZLE5B4wZU+HmVeVZdhjygiKKlNqpk6Hb2mzc04OuO/nDuOAPXDBrcPI2cCQu3eJ5F41neGgl6tQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439150; c=relaxed/simple;
	bh=TgTuCWPw2U+32HMUrX/RdQVdTqGmuk67u2NL4zQXYhE=;
	h=Date:To:From:Subject:Message-Id; b=mIHtAIe9yWrj7g8i6E6NBo6Mysf0hUpiwz85xv1yY+I5oqc/AnWMD4xu6y7mJdBwclU7q0df3wU+IvP+ivVn6C1O7XcurdAPD2RWyM2uGoRSrw9k5OkxTHNg363uiubQJSVtCDohwl+JmpRzlxH9etmC4cMb5fFCF9MxKl8Kuvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1w6KyXC6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1w6KyXC6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79FE31F00893;
	Tue,  2 Jun 2026 22:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439149;
	bh=jB48anSUHhVuxYEaPqtgJsUcW2C4BtF/TiAby+RXoEs=;
	h=Date:To:From:Subject;
	b=1w6KyXC6aZrtoWqq6i7yEbzj4acUCZecodG6ZUAj1SyX5PXq6hnY1fyyqwzjaHYK4
	 ZjvOMnxHzJZ60CPkj/LQVwlCer7YzqWbFnejWxq7GyeQN7MePsYzDLI7Deg+GMBVpP
	 XXmuEZNnNF+8o91MJT1FMdPYffeIFZ/aRoSHIWhM=
Date: Tue, 02 Jun 2026 15:25:49 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-tests-vaddr-kunit-replace-damon_add_region-with-damon_set_regions.patch removed from -mm tree
Message-Id: <20260602222549.79FE31F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/tests/vaddr-kunit: replace damon_add_region() with damon_set_regions()
has been removed from the -mm tree.  Its filename was
     mm-damon-tests-vaddr-kunit-replace-damon_add_region-with-damon_set_regions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/tests/vaddr-kunit: replace damon_add_region() with damon_set_regions()
Date: Fri, 22 May 2026 08:40:15 -0700

DAMON virtual address operation set (vaddr) unit tests is using
damon_add_region() for setup of DAMON monitoring target region boundaries
setup.  But, damon_set_regions() is designed for exactly the purpose.  All
other DAMON API callers use the function for the purpose.  Replace
damon_add_region() usage in the unit tests with damon_set_regions(), for
unifying the use case and reducing the maintenance cost.

Link: https://lore.kernel.org/20260522154026.80546-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/vaddr-kunit.h |   27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

--- a/mm/damon/tests/vaddr-kunit.h~mm-damon-tests-vaddr-kunit-replace-damon_add_region-with-damon_set_regions
+++ a/mm/damon/tests/vaddr-kunit.h
@@ -132,22 +132,35 @@ static void damon_do_test_apply_three_re
 				unsigned long *expected, int nr_expected)
 {
 	struct damon_target *t;
+	struct damon_addr_range *ranges;
 	struct damon_region *r;
 	int i;
 
 	t = damon_new_target();
 	if (!t)
 		kunit_skip(test, "target alloc fail");
+
+	ranges = kmalloc_array(nr_regions / 2, sizeof(*ranges), GFP_KERNEL);
+	if (!ranges) {
+		damon_destroy_target(t, NULL);
+		kunit_skip(test, "ranges alloc fail");
+	}
 	for (i = 0; i < nr_regions / 2; i++) {
-		r = damon_new_region(regions[i * 2], regions[i * 2 + 1]);
-		if (!r) {
-			damon_destroy_target(t, NULL);
-			kunit_skip(test, "region alloc fail");
-		}
-		damon_add_region(r, t);
+		ranges[i].start = regions[i * 2];
+		ranges[i].end = regions[i * 2 + 1];
 	}
+	if (damon_set_regions(t, ranges, nr_regions / 2,
+				DAMON_MIN_REGION_SZ)) {
+		kfree(ranges);
+		damon_destroy_target(t, NULL);
+		kunit_skip(test, "damon_set_regions() fail");
+	}
+	kfree(ranges);
 
-	damon_set_regions(t, three_regions, 3, DAMON_MIN_REGION_SZ);
+	if (damon_set_regions(t, three_regions, 3, DAMON_MIN_REGION_SZ)) {
+		damon_destroy_target(t, NULL);
+		kunit_skip(test, "second damon_set_regions() fail");
+	}
 
 	for (i = 0; i < nr_expected / 2; i++) {
 		r = __nth_region_of(t, i);
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-reclaim-handle-ctx-allocation-failure.patch
mm-damonn-lru_sort-handle-ctx-allocation-failure.patch
maintainers-add-testing-abi-documents-for-mm.patch

