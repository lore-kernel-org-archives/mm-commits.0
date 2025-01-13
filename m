Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEBC116EC19
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 23:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736812307; cv=none; b=RNqexVlXQRW9P3wUoMtCQMjHFzU3eWz0yhM192OTearVKh4OwEae8a6MGf1HqcEDdn7AVlt9ab0pdTi/7TG7yv4wUcpulDUE55aoLh2jme7AmqAPmd50QlA+UWe2ze9UZRuuB4ChwQ1RMgfIvgE0p2U2qf78+ylP15Pbg7qZQoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736812307; c=relaxed/simple;
	bh=tzOdIV/wxZWWT/qr3+oZZ5QgzR+ax/KMGm2xyA1JjbA=;
	h=Date:To:From:Subject:Message-Id; b=bFGb4pM0/Jl/isc7ExkH2Z+Vj6tgdB+3Ng2Ap6taqB/YP9r5zMGHvN3yRwGxBThGqTa5RWufGyz4kSprM7GcznthHETE0ZV+8z1Cl9nN27b1lhE022nmtGXKFSMb3aqMLvzrCW2oCnN6z6+lE8BbJ0oyWA8UJqHxY4ddrGttoWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=spwdOegU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="spwdOegU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56A9CC4CED6;
	Mon, 13 Jan 2025 23:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736812306;
	bh=tzOdIV/wxZWWT/qr3+oZZ5QgzR+ax/KMGm2xyA1JjbA=;
	h=Date:To:From:Subject:From;
	b=spwdOegU/msSJo/XSIPp+YpVAAXVHg/dfFOhLVlbOI4bQ/7RNKPBgRBVCYS2ayRMn
	 lHMoQJVbHLB7pzn9uOG7a1IyUmKJgo1Lrcp7KYOrFbBjJG6g53N5XQlLev9bPsAytS
	 WXmWTvhg37eEtkEsAH0rtF47K6e4LZM4v19IL/Sg=
Date: Mon, 13 Jan 2025 15:51:45 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,joshua.hahnjy@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-paddr-improve-readability-of-damon_pa_stat.patch added to mm-unstable branch
Message-Id: <20250113235146.56A9CC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/paddr: improve readability of damon_pa_stat
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-paddr-improve-readability-of-damon_pa_stat.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-paddr-improve-readability-of-damon_pa_stat.patch

This patch will later appear in the mm-unstable branch at
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
From: Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: mm/damon/paddr: improve readability of damon_pa_stat
Date: Mon, 13 Jan 2025 13:01:56 -0800

damon_pa_stat contains an unnecessary goto statement, and the if/else can
be re-written to be more readable.

This patch is written on top of SJ's patch series [1], which in turn is
written on top of another one of his series [2].

[1] https://lore.kernel.org/all/20241219040327.61902-1-sj@kernel.org/
[2] https://lore.kernel.org/all/20241213215306.54778-1-sj@kernel.org/

Link: https://lkml.kernel.org/r/20250113210201.446051-1-joshua.hahnjy@gmail.com
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/paddr.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/mm/damon/paddr.c~mm-damon-paddr-improve-readability-of-damon_pa_stat
+++ a/mm/damon/paddr.c
@@ -510,11 +510,8 @@ static unsigned long damon_pa_stat(struc
 		if (!folio)
 			continue;
 
-		if (damos_pa_filter_out(s, folio))
-			goto put_folio;
-		else
+		if (!damos_pa_filter_out(s, folio))
 			*sz_filter_passed += folio_size(folio);
-put_folio:
 		folio_put(folio);
 	}
 	return 0;
_

Patches currently in -mm which might be from joshua.hahnjy@gmail.com are

memcg-hugetlb-introduce-memcg_accounts_hugetlb.patch
memcg-hugetlb-introduce-mem_cgroup_charge_hugetlb.patch
memcg-hugetlb-remove-memcg-hugetlb-try-commit-cancel-protocol.patch
mm-damon-paddr-improve-readability-of-damon_pa_stat.patch

