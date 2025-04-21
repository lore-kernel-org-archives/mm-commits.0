Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 914ED1EEA5D
	for <mm-commits@vger.kernel.org>; Mon, 21 Apr 2025 18:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745261669; cv=none; b=TdyXX7pDos1yjhh0JPQF6TAbA8136pkqlVWwuCMmZcpHJjOwBAg3VtH3TVRDU0noY/PEFZQ+4poM5Zzi2FJyvqb2xGAdyyywFjJl/Nz2gxNKHsFcLYsj+TSmSZLtHgnw6TMgY0SPxmylrbx7j5EfKzwUGDLDP5Kz8VckP5vEYzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745261669; c=relaxed/simple;
	bh=3smJEFd42sXucj/uOb0CyVU7ku7bDaK4mG1+CdREoUM=;
	h=Date:To:From:Subject:Message-Id; b=C4bwLaw1dwM4c9DsnKCrZQolP9UkMRS/pPLvQlwUXks8wtbE3CDF34uUzt1h3UVw5iOUuovAjvp6Q9Zb9wuGaEC1YgRnP0QVQVc/SqMKHaVO5Bco7mXhiHPuKYUXGLh1ALL0ZLo1dspQ4ZO7hpE7RWZZc4ToWR9oIM8wG8r1asU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fcbi05o9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fcbi05o9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA541C4CEE4;
	Mon, 21 Apr 2025 18:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745261668;
	bh=3smJEFd42sXucj/uOb0CyVU7ku7bDaK4mG1+CdREoUM=;
	h=Date:To:From:Subject:From;
	b=fcbi05o9dl7D+OyXmJfnRADmZ1IOEQDLgdYkyTorjQvMuVWr7pIetZw5MONENqdKH
	 hAAns1gqJ+miduapYymPe16JtC72TPVMSNd5M4O1bjB5jCSN4RdKojrJVLK1ZwLr9z
	 wM/Dz2ZticelUWWInG2UgjIWHY5LqxiLPP7LGqoc=
Date: Mon, 21 Apr 2025 11:54:28 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yosry.ahmed@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,hezhongkun.hzk@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-add-more-comments-about-cache_trim_mode.patch added to mm-new branch
Message-Id: <20250421185428.DA541C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: vmscan: add more comments about cache_trim_mode
has been added to the -mm mm-new branch.  Its filename is
     mm-vmscan-add-more-comments-about-cache_trim_mode.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-add-more-comments-about-cache_trim_mode.patch

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
From: Zhongkun He <hezhongkun.hzk@bytedance.com>
Subject: mm: vmscan: add more comments about cache_trim_mode
Date: Mon, 21 Apr 2025 17:13:29 +0800

Add more comments for cache_trim_mode, and the annotations provided by
Johannes Weiner in [1].

Link: https://lore.kernel.org/all/20250314141833.GA1316033@cmpxchg.org/
Link: https://lkml.kernel.org/r/4baad87ba637f1e6f666e9b99b3fdcb7ab39171b.1745225696.git.hezhongkun.hzk@bytedance.com
Signed-off-by: Zhongkun He <hezhongkun.hzk@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-add-more-comments-about-cache_trim_mode
+++ a/mm/vmscan.c
@@ -2591,7 +2591,8 @@ static void get_scan_count(struct lruvec
 
 	/*
 	 * If there is enough inactive page cache, we do not reclaim
-	 * anything from the anonymous working right now.
+	 * anything from the anonymous working right now to make sure
+         * a streaming file access pattern doesn't cause swapping.
 	 */
 	if (sc->cache_trim_mode) {
 		scan_balance = SCAN_FILE;
_

Patches currently in -mm which might be from hezhongkun.hzk@bytedance.com are

mm-add-swappiness=max-arg-to-memoryreclaim-for-only-anon-reclaim.patch
mm-vmscan-add-more-comments-about-cache_trim_mode.patch
mm-add-max-swappiness-arg-to-lru_gen-for-anonymous-memory-only.patch
mm-using-swappiness_anon_only-in-mglru.patch

