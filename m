Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 754D3217916;
	Thu,  7 Nov 2024 22:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731017730; cv=none; b=tvxl/Me2hNSpIXEq5+lKpxTYX4D2bNzAWKkTZBKIWuhU1arom4Sex87Ts5NHLObcsAPJAv1Vp3I4H85xX58AbQ5F6dBLdc6CkXJALS2W9B2wX0bWT4gvzARMUCT9FNIAQSvexATwhbQJG1ZuGQxdO7E24ihMA8mgqFGKoGGK974=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731017730; c=relaxed/simple;
	bh=uO0iuNbkrnND2QDK2dCe7e8Jx/us+EzUepdSAZp+2Ng=;
	h=Date:To:From:Subject:Message-Id; b=HXV+6kQJPda1Tm1yXn6tKi6nGDyd/qmadB4t99HgHLfwn7Yzm5miy7xrKpJciC6+9/kRSpfI+VKUeK2JugFvH/N8AT/307l8zqfaemh4xlD+OJPn+Io7aa3jSspg745Qp9o10YO42qGkelFftDmduPXdTYly078Yck1lOhURyYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yLAodZYy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yLAodZYy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3919C4CECC;
	Thu,  7 Nov 2024 22:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731017730;
	bh=uO0iuNbkrnND2QDK2dCe7e8Jx/us+EzUepdSAZp+2Ng=;
	h=Date:To:From:Subject:From;
	b=yLAodZYyPiwZ9Roe0Z7hYhdviRhj1jVGEkqr8o84FFHLuDLNngW5b3kxqyfSaOdgo
	 u2CIlCCz1tiYu2UFN09KryS3HR7oMddw7mUsarkaiGToRcE68ZeqQGB8n6nkZGqEk2
	 OMssYutC7yS+QqaqMzy89kOUApPUUQ8ONgoFMxyw=
Date: Thu, 07 Nov 2024 14:15:29 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,linux@roeck-us.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-core-avoid-overflow-in-damon_feed_loop_next_input.patch removed from -mm tree
Message-Id: <20241107221529.F3919C4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: avoid overflow in damon_feed_loop_next_input()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-avoid-overflow-in-damon_feed_loop_next_input.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: avoid overflow in damon_feed_loop_next_input()
Date: Thu, 31 Oct 2024 09:12:03 -0700

damon_feed_loop_next_input() is inefficient and fragile to overflows. 
Specifically, 'score_goal_diff_bp' calculation can overflow when 'score'
is high.  The calculation is actually unnecessary at all because 'goal' is
a constant of value 10,000.  Calculation of 'compensation' is again
fragile to overflow.  Final calculation of return value for under-achiving
case is again fragile to overflow when the current score is
under-achieving the target.

Add two corner cases handling at the beginning of the function to make the
body easier to read, and rewrite the body of the function to avoid
overflows and the unnecessary bp value calcuation.

Link: https://lkml.kernel.org/r/20241031161203.47751-1-sj@kernel.org
Fixes: 9294a037c015 ("mm/damon/core: implement goal-oriented feedback-driven quota auto-tuning")
Signed-off-by: SeongJae Park <sj@kernel.org>
Reported-by: Guenter Roeck <linux@roeck-us.net>
Closes: https://lore.kernel.org/944f3d5b-9177-48e7-8ec9-7f1331a3fea3@roeck-us.net
Tested-by: Guenter Roeck <linux@roeck-us.net>
Cc: <stable@vger.kernel.org>	[6.8.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-avoid-overflow-in-damon_feed_loop_next_input
+++ a/mm/damon/core.c
@@ -1456,17 +1456,31 @@ static unsigned long damon_feed_loop_nex
 		unsigned long score)
 {
 	const unsigned long goal = 10000;
-	unsigned long score_goal_diff = max(goal, score) - min(goal, score);
-	unsigned long score_goal_diff_bp = score_goal_diff * 10000 / goal;
-	unsigned long compensation = last_input * score_goal_diff_bp / 10000;
 	/* Set minimum input as 10000 to avoid compensation be zero */
 	const unsigned long min_input = 10000;
+	unsigned long score_goal_diff, compensation;
+	bool over_achieving = score > goal;
 
-	if (goal > score)
+	if (score == goal)
+		return last_input;
+	if (score >= goal * 2)
+		return min_input;
+
+	if (over_achieving)
+		score_goal_diff = score - goal;
+	else
+		score_goal_diff = goal - score;
+
+	if (last_input < ULONG_MAX / score_goal_diff)
+		compensation = last_input * score_goal_diff / goal;
+	else
+		compensation = last_input / goal * score_goal_diff;
+
+	if (over_achieving)
+		return max(last_input - compensation, min_input);
+	if (last_input < ULONG_MAX - compensation)
 		return last_input + compensation;
-	if (last_input > compensation + min_input)
-		return last_input - compensation;
-	return min_input;
+	return ULONG_MAX;
 }
 
 #ifdef CONFIG_PSI
_

Patches currently in -mm which might be from sj@kernel.org are

selftests-damon-huge_count_read_write-remove-unnecessary-debugging-message.patch
selftests-damon-_debugfs_common-hide-expected-error-message-from-test_write_result.patch
selftests-damon-debugfs_duplicate_context_creation-hide-errors-from-expected-file-write-failures.patch
mm-damon-kconfig-update-dbgfs_kunit-prompt-copy-for-sysfs_kunit.patch
mm-damon-tests-dbgfs-kunit-fix-the-header-double-inclusion-guarding-ifdef-comment.patch
docs-mm-damon-recommend-academic-papers-to-read-and-or-cite.patch
maintainers-memory-management-add-document-files-for-mm.patch

