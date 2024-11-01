Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4900137B;
	Fri,  1 Nov 2024 01:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730423409; cv=none; b=Tc9IHh9IIvGVw8AS1snLno6pAs4h/OiXQySDctf21ElWi8RNLYsWJCXEHJK1JceS7p1uwynAOT413ZSflmDcnrrPHV+O2q/0qYHlJYJOGcv+asTPfdwNf4pkuv4X8yICk5mxWhfblg35HDBefkFq6jFB/NHnQkojlEcpigvImGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730423409; c=relaxed/simple;
	bh=UhY4tPhLXWlteRIFP8usPV8YC2zEXU2lTDHmZaCxs30=;
	h=Date:To:From:Subject:Message-Id; b=DVd33YswvuUjmgK9asQuozJaxP8TZlB9aKJyLlNAsnTH1nsDq0RsyUutPTJAt3VdQAaBTh+Eh9DwaOcotYimrPlxMjUKgAzDcqnNNj0tIt9gMZ+tYNQQG/eA+3c8fKuZJfFSXHDUP+LJEKyg8SHYkC92+wqcKH+bCLQIsrljkoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IggNIDyx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IggNIDyx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA2E7C4CEC3;
	Fri,  1 Nov 2024 01:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730423409;
	bh=UhY4tPhLXWlteRIFP8usPV8YC2zEXU2lTDHmZaCxs30=;
	h=Date:To:From:Subject:From;
	b=IggNIDyx6agAvWh/bHm4G+ntW1YaGErLY7BYgDDwpd0DKZe7aKJrBz8ZPzb61lo3t
	 OP4SU+Kmxwwtn5M0xlbpPCt+ngRC5kNe+CXNgRgNXOyz3O4+jQDpSir+arFqg2Mz11
	 metZ3/j/ZJZ6ZnyBeYtVqEyVA/ex5eVcBD1DQY28=
Date: Thu, 31 Oct 2024 18:10:08 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,linux@roeck-us.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-avoid-overflow-in-damon_feed_loop_next_input.patch added to mm-hotfixes-unstable branch
Message-Id: <20241101011008.EA2E7C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: avoid overflow in damon_feed_loop_next_input()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-core-avoid-overflow-in-damon_feed_loop_next_input.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-avoid-overflow-in-damon_feed_loop_next_input.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mm-damon-core-handle-zero-aggregationops_update-intervals.patch
mm-damon-core-handle-zero-schemes-apply-interval.patch
mm-damon-core-avoid-overflow-in-damon_feed_loop_next_input.patch
selftests-damon-huge_count_read_write-remove-unnecessary-debugging-message.patch
selftests-damon-_debugfs_common-hide-expected-error-message-from-test_write_result.patch
selftests-damon-debugfs_duplicate_context_creation-hide-errors-from-expected-file-write-failures.patch
mm-damon-kconfig-update-dbgfs_kunit-prompt-copy-for-sysfs_kunit.patch
mm-damon-tests-dbgfs-kunit-fix-the-header-double-inclusion-guarding-ifdef-comment.patch

