Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A4CA3624AB
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768966121; cv=none; b=U8uMjZPQ2adm9JxtQbOaJ2da5jS4JNbUDc+NbwpD2UEe5Mw+F3dPnqMej7DxmyjNes9meROk9CYYfmrVRNwotgtkpxl3eLu7AVWWJD1E7HgPNe/APoI26MeIlAGAmxDRX2hXnluAehIMimSgYMbjtxywM8EL7cUrcM4BevobOY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768966121; c=relaxed/simple;
	bh=CgJ2fhddE48zz2qpgrjTu0Q1lQkTnVfZas0x9WcSPiA=;
	h=Date:To:From:Subject:Message-Id; b=WOFLwAKqyjohb1xsX9BQKsnUva7BZokJUmrfUBqK1HDkNjkdxJOqXRO4IDbJhrm55D4WXAsgOc2lJJ67fxb0kA+s55/vkQ0dcAWoSp7t5sRmmlwQKr62q+BOUN6BJAjXawUMpWJtQa0mlLeSvX1gYFwtt1v/oBZZhYgwFirh3T4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iZWGKVHo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iZWGKVHo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E01BAC16AAE;
	Wed, 21 Jan 2026 03:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768966121;
	bh=CgJ2fhddE48zz2qpgrjTu0Q1lQkTnVfZas0x9WcSPiA=;
	h=Date:To:From:Subject:From;
	b=iZWGKVHoGv8lYbq+9m0lpjEQaxXoJaqfiUQGzrj9CBQsqU19P8XY4BKz73+kLaL1n
	 17KlEy45Cw/x373yUKDM/n0qnd8MsdKfmYzS2FIyhF+dLKznu6mQvyy2sa2ib/Y3iG
	 yfZGrL2oazchIjhTDTGsrYnPzdrMBGGILjEBUaaY=
Date: Tue, 20 Jan 2026 19:28:40 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,shu17az@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-tests-core-kunit-add-a-test-case-for-region-merge-size-limit-in-damon_test_merge_regions_of.patch removed from -mm tree
Message-Id: <20260121032840.E01BAC16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/tests/core-kunit: add a test case for region merge size limit in damon_test_merge_regions_of()
has been removed from the -mm tree.  Its filename was
     mm-damon-tests-core-kunit-add-a-test-case-for-region-merge-size-limit-in-damon_test_merge_regions_of.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shu Anzai <shu17az@gmail.com>
Subject: mm/damon/tests/core-kunit: add a test case for region merge size limit in damon_test_merge_regions_of()
Date: Wed, 24 Dec 2025 04:21:58 +0000

Add a test case in damon_test_merge_regions_of() to verify that two
adjacent regions are not merged if the resulting region would exceed the
specified size limit.

Link: https://lkml.kernel.org/r/20251224042200.2061847-4-shu17az@gmail.com
Signed-off-by: Shu Anzai <shu17az@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/core-kunit.h |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-add-a-test-case-for-region-merge-size-limit-in-damon_test_merge_regions_of
+++ a/mm/damon/tests/core-kunit.h
@@ -238,12 +238,12 @@ static void damon_test_merge_regions_of(
 {
 	struct damon_target *t;
 	struct damon_region *r;
-	unsigned long sa[] = {0, 100, 114, 122, 130, 156, 170, 184};
-	unsigned long ea[] = {100, 112, 122, 130, 156, 170, 184, 230};
-	unsigned int nrs[] = {0, 0, 10, 10, 20, 30, 1, 2};
+	unsigned long sa[] = {0, 100, 114, 122, 130, 156, 170, 184, 230};
+	unsigned long ea[] = {100, 112, 122, 130, 156, 170, 184, 230, 10170};
+	unsigned int nrs[] = {0, 0, 10, 10, 20, 30, 1, 2, 5};
 
-	unsigned long saddrs[] = {0, 114, 130, 156, 170};
-	unsigned long eaddrs[] = {112, 130, 156, 170, 230};
+	unsigned long saddrs[] = {0, 114, 130, 156, 170, 230};
+	unsigned long eaddrs[] = {112, 130, 156, 170, 230, 10170};
 	int i;
 
 	t = damon_new_target();
@@ -261,9 +261,9 @@ static void damon_test_merge_regions_of(
 	}
 
 	damon_merge_regions_of(t, 9, 9999);
-	/* 0-112, 114-130, 130-156, 156-170 */
-	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 5u);
-	for (i = 0; i < 5; i++) {
+	/* 0-112, 114-130, 130-156, 156-170, 170-230, 230-10170 */
+	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 6u);
+	for (i = 0; i < 6; i++) {
 		r = __nth_region_of(t, i);
 		KUNIT_EXPECT_EQ(test, r->ar.start, saddrs[i]);
 		KUNIT_EXPECT_EQ(test, r->ar.end, eaddrs[i]);
_

Patches currently in -mm which might be from shu17az@gmail.com are


