Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B53735CBB3
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768966062; cv=none; b=uAN+Xk+DnkBBk3ejfgzx4LhuXRzwlc0jl8Uy0855PPhV75BFLA+LINrjdLihTUQ3xuemXhC80vKne6/rc6Rk1ExdIY4kt0qtsN4wzJaBC9c5q9byf/yDSVQCFn1gnFWkOPI1PyTwnZz4RKzsrIkvLkSvwOQtETWny/ZOcBLvUKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768966062; c=relaxed/simple;
	bh=zGHBuGmzdkROUwd4aU6DKbLvvagEGCKP8Gawy0YzhbE=;
	h=Date:To:From:Subject:Message-Id; b=m+6cTS4ea5NCcM+soQMotEKWxdMFdM2jHYe2FVjgcTGiExE4eaAxkSiRZ51coJ/tVZRPzxO1viC9O4O0UAZOqU8ooWFt5DRozbNKtdswTNVWPdLm4yy0A9d/blkOs/aJYMsl6ZIlKbAlVjC7ayyjxrY0vyVymotlzqoiU7Toj0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Wu5u7P5A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Wu5u7P5A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92E16C16AAE;
	Wed, 21 Jan 2026 03:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768966061;
	bh=zGHBuGmzdkROUwd4aU6DKbLvvagEGCKP8Gawy0YzhbE=;
	h=Date:To:From:Subject:From;
	b=Wu5u7P5Acf14jZEwq6jpIcNPcU4xqHaTFEepbjXX6SQN+BD94MA3uWhT1GxyLkAld
	 B+vvBzYFYig+g0LCl21j+/uFonQlsH0cBKqUixraa1hZIBraqGcvoL6hmI8a0jk7Ki
	 YZXoNLm0ly4VilIpA45Xq2G4VnJ1GCahh7uL77Ns=
Date: Tue, 20 Jan 2026 19:27:41 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,lienze@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-fix-wasteful-cpu-calls-by-skipping-non-existent-targets.patch removed from -mm tree
Message-Id: <20260121032741.92E16C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: fix wasteful CPU calls by skipping non-existent targets
has been removed from the -mm tree.  Its filename was
     mm-damon-core-fix-wasteful-cpu-calls-by-skipping-non-existent-targets.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Enze Li <lienze@kylinos.cn>
Subject: mm/damon/core: fix wasteful CPU calls by skipping non-existent targets
Date: Wed, 10 Dec 2025 13:25:08 +0800

Currently, DAMON does not proactively clean up invalid monitoring targets
during its runtime.  When some monitored processes exit, DAMON continues
to make the following unnecessary function calls,

  --damon_for_each_target--
  --damon_for_each_region--
      damon_do_apply_schemes
        damos_apply_scheme
          damon_va_apply_scheme
            damos_madvise
              damon_get_mm

it is only in the damon_get_mm() function that it may finally discover the
target no longer exists, which wastes CPU resources.  A simple idea is to
check for the existence of monitoring targets within the
kdamond_need_stop() function and promptly clean up non-existent targets.

However, SJ pointed out that this approach is problematic because the
online commit logic incorrectly uses list indices to update the monitoring
state.  This can lead to data loss if the target list is changed
concurrently.  Meanwhile, SJ suggests checking for target existence at the
damon_for_each_target level, and if a target does not exist, simply skip
it and proceed to the next one.

Link: https://lkml.kernel.org/r/20251210052508.264433-1-lienze@kylinos.cn
Signed-off-by: Enze Li <lienze@kylinos.cn>
Suggested-by: SeongJae Park <sj@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-fix-wasteful-cpu-calls-by-skipping-non-existent-targets
+++ a/mm/damon/core.c
@@ -2299,6 +2299,9 @@ static void kdamond_apply_schemes(struct
 
 	mutex_lock(&c->walk_control_lock);
 	damon_for_each_target(t, c) {
+		if (c->ops.target_valid && c->ops.target_valid(t) == false)
+			continue;
+
 		damon_for_each_region_safe(r, next_r, t)
 			damon_do_apply_schemes(c, t, r);
 	}
_

Patches currently in -mm which might be from lienze@kylinos.cn are


