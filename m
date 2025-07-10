Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85AA2221273;
	Thu, 10 Jul 2025 04:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752120563; cv=none; b=ucM9t4FORwuyWlHVL3mrVhcWPUIK8ngL0YdQWN77FS0/mmO6B4QchxX6MbzC9yc7bW4bNNo+TTZTFLICO1vW2Tau68VW/r1NP/b3OMqdsLn1XEDa68G2BfDgnAYkyuVUaCygAElWOndtdRme0bm3O2W/cl8KY1lZIKbU2GLTwAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752120563; c=relaxed/simple;
	bh=0gElxXbDBd+veEbQG7Ut+XsFm/sXtixw8mTYM1YOWoI=;
	h=Date:To:From:Subject:Message-Id; b=WBbGMaA7jPPoFPI+neQLrkoh2qIbou79D1GYg4MKppJZBqwh7Hv4yFq/pa1DyUjiOFVi883XNuLtTefi7NaE0Ja4Dt7K2sKNm/qoWUImkH1WKLyaSeiJQ6DIJJ92G+yOSn7JB/M0Z8IdGQwVu8QqoGZtHbsorNYCG+V3E3B34bI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rVbphZlI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rVbphZlI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C069DC4CEE3;
	Thu, 10 Jul 2025 04:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752120562;
	bh=0gElxXbDBd+veEbQG7Ut+XsFm/sXtixw8mTYM1YOWoI=;
	h=Date:To:From:Subject:From;
	b=rVbphZlIayWBGfqHuuZFo0ushJDWlj9wzyA6XaDd8BnevpSEV57rQiTaXlVW6sKY4
	 i0HGPXnqMShrkkm7ntiT3M2Z3QzTxTCjEyUVxh0bu6kCGqV/Qfcf9xBFvl6MfJzHBU
	 Pc5C2hCitBvqBYVjUhxtQLrC1cKNJoAUvjA9l5NI=
Date: Wed, 09 Jul 2025 21:09:22 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,honggyu.kim@sk.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-fix-divide-by-zero-in-damon_get_intervals_score.patch removed from -mm tree
Message-Id: <20250710040922.C069DC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon: fix divide by zero in damon_get_intervals_score()
has been removed from the -mm tree.  Its filename was
     mm-damon-fix-divide-by-zero-in-damon_get_intervals_score.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Honggyu Kim <honggyu.kim@sk.com>
Subject: mm/damon: fix divide by zero in damon_get_intervals_score()
Date: Wed, 2 Jul 2025 09:02:04 +0900

The current implementation allows having zero size regions with no special
reasons, but damon_get_intervals_score() gets crashed by divide by zero
when the region size is zero.

  [   29.403950] Oops: divide error: 0000 [#1] SMP NOPTI

This patch fixes the bug, but does not disallow zero size regions to keep
the backward compatibility since disallowing zero size regions might be a
breaking change for some users.

In addition, the same crash can happen when intervals_goal.access_bp is
zero so this should be fixed in stable trees as well.

Link: https://lkml.kernel.org/r/20250702000205.1921-5-honggyu.kim@sk.com
Fixes: f04b0fedbe71 ("mm/damon/core: implement intervals auto-tuning")
Signed-off-by: Honggyu Kim <honggyu.kim@sk.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/damon/core.c~mm-damon-fix-divide-by-zero-in-damon_get_intervals_score
+++ a/mm/damon/core.c
@@ -1449,6 +1449,7 @@ static unsigned long damon_get_intervals
 		}
 	}
 	target_access_events = max_access_events * goal_bp / 10000;
+	target_access_events = target_access_events ? : 1;
 	return access_events * 10000 / target_access_events;
 }
 
_

Patches currently in -mm which might be from honggyu.kim@sk.com are

samples-damon-change-enable-parameters-to-enabled.patch

