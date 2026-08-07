Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA2A3B7752;
	Fri,  7 Aug 2026 02:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068123; cv=none; b=uu+yWxC3FpztKiRbkY3g4PFKKwaru5yQ7JmN2Fyv/1g6Tsw3fwD0ietDj9Ujz9kMYoGh4GFTsuzoT0SHv8bl867cBtnuhrn5/m482+6yakE6S7gwjDUdXr8nuQw/eAAegPlIdUD9x60+o6UEfpppzB8m4Z9Lv3mujGiBG+FAMEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068123; c=relaxed/simple;
	bh=F328gFrO3jh8Pi6zPuRyqHmioVgXV/AMIzLBOemQUa0=;
	h=Date:To:From:Subject:Message-Id; b=RBbckZEpfGgX98ta3GAVu3CrWCMV6nfvCr/pkgY+/R2QnQ0+hPRiZlWES5tsGcFBZDyLevCZGpJKzAKhwDtGnzy3ZErcaNNgdAbDjEAKrMyH5kwS5q/DEPnea+VoIAjCSOuGe6G/AkxbwJqKiQBWLd5zkozczlPEJVMN9wy+jok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VG938g4m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VG938g4m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C26321F000E9;
	Fri,  7 Aug 2026 02:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068121;
	bh=H1Tb4gEE9qopwIzA5PoUuc4Xrt2Dm6OY0Zhp1ZX7wpQ=;
	h=Date:To:From:Subject;
	b=VG938g4mHWY6Y62B4v4YJL4qSzBHDc2Pev5LfVPG/HaaYDxfsnSGUdUZ2W8BH0UJP
	 YIxmY0DF4WGl5gemaIOLQ8Wm4AIq0scDU6edup2YcYx8fYap1GlAATogbwcobCdWkc
	 01Roeco4zFPmALFS0AvdNMJwQJndOYCMgkwwYU5A=
Date: Thu, 06 Aug 2026 19:02:01 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-kunit-skip-wrong-quota-goal-walk-in-commit_quota_goals.patch removed from -mm tree
Message-Id: <20260807020201.C26321F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core-kunit: skip wrong quota goal walk in commit_quota_goals()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-kunit-skip-wrong-quota-goal-walk-in-commit_quota_goals.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core-kunit: skip wrong quota goal walk in commit_quota_goals()
Date: Fri, 17 Jul 2026 17:14:40 -0700

damos_test_commit_quota_goals_for() traverses damos quota goals after
damos_commit_quota_goals() call.  It assumes damos_commit_quota_goals()
made expected numbers of goals.  It might not.  Because the traversal is
made based on destination struct length, it could do out of bounds access
for source expectation value array.

The consequent user impact (out-of-bound access ) is quite bad.  The
realistic user impact would be limited though.  It would affect only test
run setups.

Fix it by testing if the number of goals was also changed as expected and
exit early for the failure.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260718001442.87129-7-sj@kernel.org
Link: https://lore.kernel.org/20260713144757.39740-1-sj@kernel.org [1]
Fixes: d9adfb8a28e7 ("mm/damon/tests/core-kunit: add damos_commit_quota_goals() test")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: <stable@vger.kernel.org> # 6.19.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/core-kunit.h |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/mm/damon/tests/core-kunit.h~mm-damon-core-kunit-skip-wrong-quota-goal-walk-in-commit_quota_goals
+++ a/mm/damon/tests/core-kunit.h
@@ -839,6 +839,7 @@ static void damos_test_commit_quota_goal
 	struct damos_quota_goal *goal, *next;
 	bool skip = true;
 	int i;
+	int nr_dst = 0, nr_src = 0;
 
 	INIT_LIST_HEAD(&dst.goals);
 	INIT_LIST_HEAD(&src.goals);
@@ -861,6 +862,14 @@ static void damos_test_commit_quota_goal
 
 	damos_commit_quota_goals(&dst, &src);
 
+	damos_for_each_quota_goal(goal, &dst)
+		nr_dst++;
+	damos_for_each_quota_goal(goal, &src)
+		nr_src++;
+	KUNIT_EXPECT_EQ(test, nr_dst, nr_src);
+	if (nr_dst != nr_src)
+		goto out;
+
 	i = 0;
 	damos_for_each_quota_goal(goal, (&dst)) {
 		KUNIT_EXPECT_EQ(test, goal->metric, src_goals[i].metric);
_

Patches currently in -mm which might be from sj@kernel.org are


