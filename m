Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC4C2AF0A
	for <mm-commits@vger.kernel.org>; Wed,  4 Jun 2025 21:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749072325; cv=none; b=nP6EIr8MmEdHWOnqDxdImzJTkYHimKURXkltWrXTFd5lxCQCDbHMUgoIq0OnmanRDqEDC3cAgeNxO4tuEG5Qhb4DRGBMdWC6Phf7+42BAZgK3XKJh9pjUNAdDKJf4wmsn4bW7zK7AHOR2vXdl6YOj9AH7Ndhba/wZHg6Uhj7bjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749072325; c=relaxed/simple;
	bh=mYcfRETzv7xiuZkECBUBxbTkRJbYLNgHSisa+V1OI+Q=;
	h=Date:To:From:Subject:Message-Id; b=COGr95zpPfxlbpRIqRxcnt4Hwk0/9v81XR99cKllCDO58axpBJCgRn/Ln5myPZD9EWU+HFZfv7VCuTvLPjGBTiPt1V1K3+fsqJdownySSwIe+b+dM9E869QUMjvfyPG5LwhuJ0N54LJjDbFlJGSciIFbamBY/FbZeUSukJ9iMJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AV9ibVyp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AV9ibVyp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EE91C4CEE4;
	Wed,  4 Jun 2025 21:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749072325;
	bh=mYcfRETzv7xiuZkECBUBxbTkRJbYLNgHSisa+V1OI+Q=;
	h=Date:To:From:Subject:From;
	b=AV9ibVyp7vcUzsZbSzqnQqEO+YgxoqsiQrbnjsoZUFQhSnCy+JJeZ929mSNkR6Ud/
	 zk2xex33+DaILy9Wmsi/JrU7f0Ug6ehAkvH3hDrjGoLbYHblWktL2xTNiQgsRL+TSl
	 7oR0vj+OTuy3HKTJUoL/CX1s2K/QpHssvIIETcK8=
Date: Wed, 04 Jun 2025 14:25:24 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-introduce-damon_stat-module-fix.patch added to mm-new branch
Message-Id: <20250604212525.1EE91C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/stat: use IS_ENABLED() for enabled initial value
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-introduce-damon_stat-module-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-introduce-damon_stat-module-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
Subject: mm/damon/stat: use IS_ENABLED() for enabled initial value
Date: Wed, 4 Jun 2025 13:48:30 -0700

The initial value of enabled parameter is set as
CONFIG_DAMON_STAT_ENABLED_DEFAULT, so get below build error when the
config is not enabled.  Fix it using IS_ENABLED().

    mm/damon/stat.c:27:37: error: `CONFIG_DAMON_STAT_ENABLED_DEFAULT' undeclared here (not in a function)
       27 | static bool enabled __read_mostly = CONFIG_DAMON_STAT_ENABLED_DEFAULT;
          |                                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Link: https://lkml.kernel.org/r/20250604205619.18929-1-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/stat.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/damon/stat.c~mm-damon-introduce-damon_stat-module-fix
+++ a/mm/damon/stat.c
@@ -24,7 +24,8 @@ static const struct kernel_param_ops ena
 	.get = param_get_bool,
 };
 
-static bool enabled __read_mostly = CONFIG_DAMON_STAT_ENABLED_DEFAULT;
+static bool enabled __read_mostly = IS_ENABLED(
+	CONFIG_DAMON_STAT_ENABLED_DEFAULT);
 module_param_cb(enabled, &enabled_param_ops, &enabled, 0600);
 MODULE_PARM_DESC(enabled, "Enable of disable DAMON_STAT");
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-madvise-handle-madvise_lock-failure-during-race-unwinding.patch
mm-damon-introduce-damon_stat-module.patch
mm-damon-introduce-damon_stat-module-fix.patch
mm-damon-stat-calculate-and-expose-estimated-memory-bandwidth.patch
mm-damon-stat-calculate-and-expose-idle-time-percentiles.patch
docs-admin-guide-mm-damon-add-damon_stat-usage-document.patch

