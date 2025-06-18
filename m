Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5103F1C2324
	for <mm-commits@vger.kernel.org>; Wed, 18 Jun 2025 23:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750287871; cv=none; b=R2u24eJcwAhtka3rQKrUEuHl9QPPrKyoExrW+soU0Z4Y5jsuYdhnG+2jErpN19JmtHUz3kLv9Hy7TlIrcOcDiWv5X+UxwI7GVnsju0BHR5dxh80ZuomOzzkB5jbTNpAtCnQ82R/nboBbWWi8nRjgtqw5ierk6YR+ATuJQoNYbek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750287871; c=relaxed/simple;
	bh=llJhkBzv4taltYYdacDIxzu0p3pOMwLhNGpqbEuDWMQ=;
	h=Date:To:From:Subject:Message-Id; b=db8h+2sSEVDs5I5o3I4EJiLMGu1vUDS4rwuVZL3iqwfh5ZYyTbzLhYVjoFhO6giA5ebvh5VDUiCpDKkhUEQ1SK3txAij2H3i4jYYIqw3zeLpol6VSSR8Ct9vDTDAqD59ItpdF1ieNc+c+tFoCpEzaMl73obyFGQ2xoE0/5EBS0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tnvdWkDQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tnvdWkDQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF8FCC4CEEE;
	Wed, 18 Jun 2025 23:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750287870;
	bh=llJhkBzv4taltYYdacDIxzu0p3pOMwLhNGpqbEuDWMQ=;
	h=Date:To:From:Subject:From;
	b=tnvdWkDQNhf33ctvJpGVUc6/XvA2TQwf6KU/bLcnZF9fFBRFpNXfaOUDSvopVNRqn
	 4K0Dx5tj66E61PX/A4d2w53d/rTG06/Ka+leXelb/Geb72u9bgxVZGLceOSC/DEOCT
	 nfW9c85k25hBGSFTKH6tLnXIGZZErh0VPfTStV/0=
Date: Wed, 18 Jun 2025 16:04:30 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,zcgao@amazon.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-fix-minor-typos-in-damon-header.patch added to mm-new branch
Message-Id: <20250618230430.CF8FCC4CEEE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon: fix minor typos in damon header
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-fix-minor-typos-in-damon-header.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-fix-minor-typos-in-damon-header.patch

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
From: Nathan Gao <zcgao@amazon.com>
Subject: mm/damon: fix minor typos in damon header
Date: Wed, 18 Jun 2025 09:33:31 -0700

Fix typos in include/linux/damon.h.

Link: https://lkml.kernel.org/r/20250618163331.54910-1-sj@kernel.org
Signed-off-by: Nathan Gao <zcgao@amazon.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/damon.h~mm-damon-fix-minor-typos-in-damon-header
+++ a/include/linux/damon.h
@@ -450,7 +450,7 @@ struct damos_access_pattern {
 /**
  * struct damos - Represents a Data Access Monitoring-based Operation Scheme.
  * @pattern:		Access pattern of target regions.
- * @action:		&damo_action to be applied to the target regions.
+ * @action:		&damos_action to be applied to the target regions.
  * @apply_interval_us:	The time between applying the @action.
  * @quota:		Control the aggressiveness of this scheme.
  * @wmarks:		Watermarks for automated (in)activation of this scheme.
@@ -656,7 +656,7 @@ struct damon_call_control {
  * struct damon_intervals_goal - Monitoring intervals auto-tuning goal.
  *
  * @access_bp:		Access events observation ratio to achieve in bp.
- * @aggrs:		Number of aggregations to acheive @access_bp within.
+ * @aggrs:		Number of aggregations to achieve @access_bp within.
  * @min_sample_us:	Minimum resulting sampling interval in microseconds.
  * @max_sample_us:	Maximum resulting sampling interval in microseconds.
  *
_

Patches currently in -mm which might be from zcgao@amazon.com are

mm-damon-fix-minor-typos-in-damon-header.patch

