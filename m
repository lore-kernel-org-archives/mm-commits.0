Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4179C5FEE6;
	Fri,  4 Jul 2025 01:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751591868; cv=none; b=FE4nOvvQluiRtppRbJUPBZVGeLEM0OP/3/MxJdn8SzYvXxpRPdwLO9OdNeozGQXn8jnSooLmh90YRaxSU/m8F5aZTduOkfdEeUHMlXA42mlatW3tjW1S5STu44J1EregO3K6/6Bu/GFLWE3Nc2S8bfrLKgIQ5/mJ8kiMWtRdlHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751591868; c=relaxed/simple;
	bh=beMgUsuH+k9vuVhvGsPw6TN2yXNfLZ+7W0/DrZzM8qA=;
	h=Date:To:From:Subject:Message-Id; b=rJP+gw1gWCGVqz/UOBjqC9q/o6aeDRs0hzAUSgzYZFqN2UbrC8Oam9k5ry2s9AoGieKYyGh3QJBgkLLd5YUAyxTaLsTKWct7EcbSZcqjX6Gtz9NxAVxyGo1flpMCI5d7kEIQn6E33y4OECjvdpV8FJsxzHWzH0eFjeVOYjZA4E0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qag2AAf3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qag2AAf3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0E8DC4CEE3;
	Fri,  4 Jul 2025 01:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751591867;
	bh=beMgUsuH+k9vuVhvGsPw6TN2yXNfLZ+7W0/DrZzM8qA=;
	h=Date:To:From:Subject:From;
	b=qag2AAf37SdRRtRI9xxh6iGSfYdYDRkMMJuofWJSvOTZ50/viVgC5PZxnB329bGAq
	 YgZGcFaQuGg6QATmypoyOi3amjBQeywHkIjkie8aXcsZ9IZf5gLKBYV8PKIFnk/+6u
	 jIOtYQ/QB7QfC7aQ7mBy5a9dL136z6J4C19N313o=
Date: Thu, 03 Jul 2025 18:17:47 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,honggyu.kim@sk.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-fix-divide-by-zero-in-damon_get_intervals_score.patch added to mm-hotfixes-unstable branch
Message-Id: <20250704011747.C0E8DC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon: fix divide by zero in damon_get_intervals_score()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-fix-divide-by-zero-in-damon_get_intervals_score.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-fix-divide-by-zero-in-damon_get_intervals_score.patch

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

samples-damon-fix-damon-sample-prcl-for-start-failure.patch
samples-damon-fix-damon-sample-wsse-for-start-failure.patch
samples-damon-fix-damon-sample-mtier-for-start-failure.patch
mm-damon-fix-divide-by-zero-in-damon_get_intervals_score.patch

