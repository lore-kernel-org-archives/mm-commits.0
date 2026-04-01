Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B48D31F99B;
	Wed,  1 Apr 2026 03:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775014382; cv=none; b=Op9a7kR6t/CdGt8+jtygK5iVkwknxBRoaMLtM3StthL3MdHt3WBZdBvJFK9/sK8tz/Lj3MidXY+AN/Azhwa5+Y8dbsTyp2lqY2Hdb2lbqyA8GYXBi2kNVxlRFNd9CkGtK6ujaMGmR0S6zQ75gm5vcQ5Sv0BtRB9AzauON9K3ykk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775014382; c=relaxed/simple;
	bh=+A+K/m57VIQooOldDDdUbG8PeD/W/DGcAH2o9p2SN48=;
	h=Date:To:From:Subject:Message-Id; b=F/8kIRvZi4E42o+NKZs/XXfIScqPPEyjsU5+5Qyth2jAyg4s2bN0GzjX/+OYr1gaCKvJkYEWWZxvIxBtM/So0ZkDMg9CS2bGBBwh8fXRvH5eN68whd7/M/QZqguDdthwqBU79pWgm9bFl4t1B5S6CbKguuEFzjSxD1XjswN9J9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=agEHNVaV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="agEHNVaV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13CC4C4CEF7;
	Wed,  1 Apr 2026 03:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775014382;
	bh=+A+K/m57VIQooOldDDdUbG8PeD/W/DGcAH2o9p2SN48=;
	h=Date:To:From:Subject:From;
	b=agEHNVaVzTkdUeyHjc+0sTVSH5GpBcOiAtmth+Kae2BS5+hr1Ya+nh2GvzZ9SUbMa
	 obRwG0vD/K6Ar4HG5XregwqBV3uTQ8x0i0Z3sJXXMPhCOy87JcQyj4Jb0QQj6tJPoQ
	 UfKTl7wHBqXI5KQCrZRi5AqfjX2r5Mz9Pyt4nVa4=
Date: Tue, 31 Mar 2026 20:33:01 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-use-time_in_range_open-for-damos-quota-window-start.patch added to mm-hotfixes-unstable branch
Message-Id: <20260401033302.13CC4C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: use time_in_range_open() for damos quota window start
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-core-use-time_in_range_open-for-damos-quota-window-start.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-use-time_in_range_open-for-damos-quota-window-start.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

Link: https://lkml.kernel.org/r/20260329152306.45796-1-sj@kernel.org
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
@@ -2291,7 +2291,8 @@ static void damos_adjust_quota(struct da
 	}
 
 	/* New charge window starts */
-	if (time_after_eq(jiffies, quota->charged_from +
+	if (!time_in_range_open(jiffies, quota->charged_from,
+				quota->charged_from +
 				msecs_to_jiffies(quota->reset_interval))) {
 		if (quota->esz && quota->charged_sz >= quota->esz)
 			s->stat.qt_exceeds++;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-dealloc-repeat_call_control-if-damon_call-fails.patch
mm-damon-core-fix-damon_call-vs-kdamond_fn-exit-race.patch
mm-damon-core-fix-damos_walk-vs-kdamond_fn-exit-race.patch
mm-damon-core-validate-damos_quota_goal-nid-for-node_mem_usedfree_bp.patch
mm-damon-core-validate-damos_quota_goal-nid-for-node_memcg_usedfree_bp.patch
mm-damon-core-use-time_in_range_open-for-damos-quota-window-start.patch

