Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8789712B94;
	Sat, 18 Apr 2026 07:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776498896; cv=none; b=lsrHzVXmja2RQny1FF7TK18KGrrXYbeRiNZtKmR893H4fLKuckOUShUKNrTRHU7O1PsgCo96jfWk8OTdWHAM3Aqs5zyaBNUmDhDUxdF1hYl//SvtuSCmGct74SsV3xYxoEPcBeHhRhhqM4HL85RMYCwMtuGVuV5ANRlafdUiX80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776498896; c=relaxed/simple;
	bh=GKg6mIwnBZH7X7Tr8gU26RjRsB2YXA/so1+Jqkd+hVg=;
	h=Date:To:From:Subject:Message-Id; b=FCTSoyScXESXcUGyKuFc8LSmJDysrY/xE+vlZgUlVoxPwQKwwCFQkZhNZTls2/o77zG0fMUcE5dddfy12S4BLQ2tyesFrljPG2Z4DPHSIcz2Mv32IITC1H2I473EGktlNqt0WM5CjF27R2JZsA1rUSsZhpgKD83UuOUm/tQYfS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Xgo5jSh1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Xgo5jSh1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 978F0C19424;
	Sat, 18 Apr 2026 07:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776498896;
	bh=GKg6mIwnBZH7X7Tr8gU26RjRsB2YXA/so1+Jqkd+hVg=;
	h=Date:To:From:Subject:From;
	b=Xgo5jSh1AdAFbG/JpRJxBvDdEWRxUyEBADmE3Qt1FTH4Q5lOyvSjixJhDzsDaJDzV
	 X0MUvln042fAt5dHOwSHOI33tPxVaXOcLp3o6uCrrgdigpiWWOfnkAAbTFQWrl4gqN
	 aRmB+Y/kFRZsmeNPtSF54eE5am5nQ5lOk+/a5F6I=
Date: Sat, 18 Apr 2026 00:54:51 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-use-time_in_range_open-for-damos-quota-window-start.patch removed from -mm tree
Message-Id: <20260418075455.978F0C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: use time_in_range_open() for damos quota window start
has been removed from the -mm tree.  Its filename was
     mm-damon-core-use-time_in_range_open-for-damos-quota-window-start.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: use time_in_range_open() for damos quota window start
Date: Sun, 29 Mar 2026 08:23:05 -0700

damos_adjust_quota() uses time_after_eq() to show if it is time to start a
new quota charge window, comparing the current jiffies and the scheduled
next charge window start time.  If it is, the next charge window start
time is updated and the new charge window starts.

The time check and next window start time update is skipped while the
scheme is deactivated by the watermarks.  Let's suppose the deactivation
is kept more than LONG_MAX jiffies (assuming CONFIG_HZ of 250, more than
99 days in 32 bit systems and more than one billion years in 64 bit
systems), resulting in having the jiffies larger than the next charge
window start time + LONG_MAX.  Then, the time_after_eq() call can return
false until another LONG_MAX jiffies are passed.

This means the scheme can continue working after being reactivated by the
watermarks.  But, soon, the quota will be exceeded and the scheme will
again effectively stop working until the next charge window starts. 
Because the current charge window is extended to up to LONG_MAX jiffies,
however, it will look like it stopped unexpectedly and indefinitely, from
the user's perspective.

Fix this by using !time_in_range_open() instead.

The issue was discovered [1] by sashiko.

Link: https://lore.kernel.org/20260329152306.45796-1-sj@kernel.org
Link: https://lore.kernel.org/20260324040722.57944-1-sj@kernel.org [1]
Fixes: ee801b7dd782 ("mm/damon/schemes: activate schemes based on a watermarks mechanism")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 5.16.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/damon/core.c~mm-damon-core-use-time_in_range_open-for-damos-quota-window-start
+++ a/mm/damon/core.c
@@ -2449,7 +2449,8 @@ static void damos_adjust_quota(struct da
 	}
 
 	/* New charge window starts */
-	if (time_after_eq(jiffies, quota->charged_from +
+	if (!time_in_range_open(jiffies, quota->charged_from,
+				quota->charged_from +
 				msecs_to_jiffies(quota->reset_interval))) {
 		if (damos_quota_is_set(quota) &&
 				quota->charged_sz >= quota->esz)
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-disallow-time-quota-setting-zero-esz.patch
mm-damon-core-disallow-non-power-of-two-min_region_sz-on-damon_start.patch

