Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B8218C332;
	Tue, 26 Aug 2025 01:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756172531; cv=none; b=IipZJ85MwR+LxDt43g29FLhFexouqM1ZxpCGIC4iM/HjyGgn35f1Fm/aeLOka4BcGRsu82ZAZBNJ/rhkOBCMjN9UCVGAofIHiOTCkTobfo7/NeTMVd2Xi3+vxyWLctad48CuT3rW4yvJ9/dbOY0TJ0D1YoBHP270LuVApIg+cJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756172531; c=relaxed/simple;
	bh=iXNU1QxMYVnTQejECTKsj6Y/YWYm5nmLM5j6vXYpeZA=;
	h=Date:To:From:Subject:Message-Id; b=fGamh049ezYdbE1cUAamo6AgRYfR8CuhPtxmuQWr/zEuBpeJS7o7wFrn2weG2XqH0TnV+vuI9PFHd82J4GEFkHUggCmxcMcJIY98zu6eYEJguINuv9nMugxgDLQTuUpq3G24QcLlyYyHS7dx5y+1NgusmmQX1NGXKbVyqHwkFPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bvlqKOXW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bvlqKOXW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A0B8C4CEED;
	Tue, 26 Aug 2025 01:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756172531;
	bh=iXNU1QxMYVnTQejECTKsj6Y/YWYm5nmLM5j6vXYpeZA=;
	h=Date:To:From:Subject:From;
	b=bvlqKOXWClUMned8xxuIeisuOU6YNs8K0S5xiHPdAOYTZL2fYt6RpWaBSrenucXYp
	 lXd8rwH9CdqW2LPjA58WdW5/2usrIc86oS0d8kRIzuvdi7aBi6r8DnGhW4HlrnwmBf
	 6sb76UJWQ+AR8j9Lj2gihDyRbh0v6Z7S4yOWvZ9c=
Date: Mon, 25 Aug 2025 18:42:10 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,ekffu200098@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-set-quota-charged_from-to-jiffies-at-first-charge-window.patch added to mm-hotfixes-unstable branch
Message-Id: <20250826014211.2A0B8C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: set quota->charged_from to jiffies at first charge window
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-core-set-quota-charged_from-to-jiffies-at-first-charge-window.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-set-quota-charged_from-to-jiffies-at-first-charge-window.patch

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
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: mm/damon/core: set quota->charged_from to jiffies at first charge window
Date: Fri, 22 Aug 2025 11:50:57 +0900

Kernel initializes the "jiffies" timer as 5 minutes below zero, as shown
in include/linux/jiffies.h

 /*
 * Have the 32 bit jiffies value wrap 5 minutes after boot
 * so jiffies wrap bugs show up earlier.
 */
 #define INITIAL_JIFFIES ((unsigned long)(unsigned int) (-300*HZ))

And jiffies comparison help functions cast unsigned value to signed to
cover wraparound

 #define time_after_eq(a,b) \
  (typecheck(unsigned long, a) && \
  typecheck(unsigned long, b) && \
  ((long)((a) - (b)) >= 0))

When quota->charged_from is initialized to 0, time_after_eq() can
incorrectly return FALSE even after reset_interval has elapsed.  This
occurs when (jiffies - reset_interval) produces a value with MSB=1, which
is interpreted as negative in signed arithmetic.

This issue primarily affects 32-bit systems because: On 64-bit systems:
MSB=1 values occur after ~292 million years from boot (assuming HZ=1000),
almost impossible.

On 32-bit systems: MSB=1 values occur during the first 5 minutes after
boot, and the second half of every jiffies wraparound cycle, starting from
day 25 (assuming HZ=1000)

When above unexpected FALSE return from time_after_eq() occurs, the
charging window will not reset.  The user impact depends on esz value at
that time.

If esz is 0, scheme ignores configured quotas and runs without any limits.

If esz is not 0, scheme stops working once the quota is exhausted.  It
remains until the charging window finally resets.

So, change quota->charged_from to jiffies at damos_adjust_quota() when it
is considered as the first charge window.  By this change, we can avoid
unexpected FALSE return from time_after_eq()

Link: https://lkml.kernel.org/r/20250822025057.1740854-1-ekffu200098@gmail.com
Fixes: 2b8a248d5873 ("mm/damon/schemes: implement size quota for schemes application speed control") # 5.16
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-set-quota-charged_from-to-jiffies-at-first-charge-window
+++ a/mm/damon/core.c
@@ -2111,6 +2111,10 @@ static void damos_adjust_quota(struct da
 	if (!quota->ms && !quota->sz && list_empty(&quota->goals))
 		return;
 
+	/* First charge window */
+	if (!quota->total_charged_sz && !quota->charged_from)
+		quota->charged_from = jiffies;
+
 	/* New charge window starts */
 	if (time_after_eq(jiffies, quota->charged_from +
 				msecs_to_jiffies(quota->reset_interval))) {
_

Patches currently in -mm which might be from ekffu200098@gmail.com are

mm-damon-core-set-quota-charged_from-to-jiffies-at-first-charge-window.patch
mm-damon-update-expired-description-of-damos_action.patch
docs-mm-damon-design-fix-typo-s-sz_trtied-sz_tried.patch
selftests-damon-test-no-op-commit-broke-damon-status.patch
selftests-damon-test-no-op-commit-broke-damon-status-fix.patch
mm-damon-tests-core-kunit-add-damos_commit_filter-test.patch

