Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1967711CA9;
	Thu,  4 Sep 2025 00:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756944698; cv=none; b=fun+tDy9lIgclp3KerNNyPIc+jGiy0m+6nIZonA0lgnFQHnsW3esALWksvJ85iTBNxfuRgYPT+bRdNBBXHJlRt2EAlnKEJdDCZwJDrItRbpa1WlqDUMSUsAXuvdF4H6RD5gUF539Thb8iM7iL4igOXDG0n+8qKvnoe7yTrge1rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756944698; c=relaxed/simple;
	bh=FVGOJoin5pBFGvElcgJ8E5ZCpv4hoxMmExRmjXrVZ+I=;
	h=Date:To:From:Subject:Message-Id; b=kiWkQVJsPU9nmcLTRkIH9lmMo5Lo3cB++dRRwuY77DAcD5lQAHnWuUiMdY4k7bcsRn14EeCFd+ZHTMcm+Iq425mgVqitwqdZ3OY7fiNUEfIfa02wfrq41YazkI2oEQvUGjt/BCkOeLNR68Aj3KzLnpRf7+ZBQGWg7MV2InQrdIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=c3edakpV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="c3edakpV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95F94C4CEE7;
	Thu,  4 Sep 2025 00:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756944696;
	bh=FVGOJoin5pBFGvElcgJ8E5ZCpv4hoxMmExRmjXrVZ+I=;
	h=Date:To:From:Subject:From;
	b=c3edakpVkdt91S82ddzBF/00Lpz7YbarvGPmzz2cP5yn0NAHPxwQfRY+afCLjPmZj
	 BgDh1WCDAyq5Y9EW6mXywbmOEMc7fktM2X0qJtQtvJUkkCdy8g+cfEREkFxzCSi/aY
	 FcRzHaiRAWMnx6rXG7XPg0cYZ9ms/y6F8n3yxhJ4=
Date: Wed, 03 Sep 2025 17:11:36 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,ekffu200098@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-core-set-quota-charged_from-to-jiffies-at-first-charge-window.patch removed from -mm tree
Message-Id: <20250904001136.95F94C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: set quota->charged_from to jiffies at first charge window
has been removed from the -mm tree.  Its filename was
     mm-damon-core-set-quota-charged_from-to-jiffies-at-first-charge-window.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-damon-update-expired-description-of-damos_action.patch
docs-mm-damon-design-fix-typo-s-sz_trtied-sz_tried.patch
selftests-damon-test-no-op-commit-broke-damon-status.patch
selftests-damon-test-no-op-commit-broke-damon-status-fix.patch
mm-damon-tests-core-kunit-add-damos_commit_filter-test.patch

