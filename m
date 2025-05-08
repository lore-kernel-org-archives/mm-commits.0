Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25A291FC8
	for <mm-commits@vger.kernel.org>; Thu,  8 May 2025 01:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746667757; cv=none; b=tBpKnWkkdER8gzDKFgQK3zY7TFHq83TA+9yVgv4dinxZGuPnrfIEc/xwmwNqS6YHTgm7inSrn59t9ygbHzVO6ULnIqV+UKkEGrs2o+ok9/h5mQHC869zyptfwOHphRqgU2QhF9SZ0mF25dwii8imk7n1BG/s3VHhzZ7o4MsyT4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746667757; c=relaxed/simple;
	bh=q0llc3oiif6W0JwtoyRshYRa22F7gvKPqMx97vxGGfM=;
	h=Date:To:From:Subject:Message-Id; b=VgxNycBXeGzxjq97OIorqGwKS7z3zYOmrpF/B2xGgacmqmlB1WfKXZHO22htEjnz32lCh2PF+TITLkpZBnKu6ArxuopWpvuYLfSkM2JR+MdNsAYEGrUqX4JvgzXHI4KgsQ++2HWoe2sxw8i3ZTLdZneMTbPGNNqNLY7J77qGGdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q/LZGRax; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q/LZGRax"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84FBBC4CEE2;
	Thu,  8 May 2025 01:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746667756;
	bh=q0llc3oiif6W0JwtoyRshYRa22F7gvKPqMx97vxGGfM=;
	h=Date:To:From:Subject:From;
	b=Q/LZGRax/AWL0wrlnXIIt8E/qAa4PUCsH0KtnYY+9g8akwx7sycvfZ3qGjRyLmM81
	 FunQhlEa9Wsl/9osfhIIoZTBvGnrr1oNaV7nuNiOFkWnlqJJwh8U7Su91j9oYWR4QY
	 6GoUx8Y4niZ5juaChmRCSXmvsAEYY0I7zfgl1A7c=
Date: Wed, 07 May 2025 18:29:15 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yosry.ahmed@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,hezhongkun.hzk@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-max-swappiness-arg-to-lru_gen-for-anonymous-memory-only-update.patch added to mm-unstable branch
Message-Id: <20250508012916.84FBBC4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add max swappiness arg to lru_gen for anonymous memory only
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-max-swappiness-arg-to-lru_gen-for-anonymous-memory-only-update.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-max-swappiness-arg-to-lru_gen-for-anonymous-memory-only-update.patch

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
From: Zhongkun He <hezhongkun.hzk@bytedance.com>
Subject: mm: add max swappiness arg to lru_gen for anonymous memory only
Date: Wed, 7 May 2025 15:10:57 +0800

 1) use strcmp instead of strncmp from Dan Carpenter
https://lore.kernel.org/all/aBHYT27M1tRxNLRj@stanley.mountain/
 2) If swappiness is not set, use the default value.

Link: https://lkml.kernel.org/r/20250507071057.3184240-1-hezhongkun.hzk@bytedance.com
Signed-off-by: Zhongkun He <hezhongkun.hzk@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/mm/vmscan.c~mm-add-max-swappiness-arg-to-lru_gen-for-anonymous-memory-only-update
+++ a/mm/vmscan.c
@@ -5592,7 +5592,7 @@ static ssize_t lru_gen_seq_write(struct
 		unsigned int memcg_id;
 		unsigned int nid;
 		unsigned long seq;
-		unsigned int swappiness = -1;
+		unsigned int swappiness;
 		unsigned long opt = -1;
 
 		cur = skip_spaces(cur);
@@ -5606,8 +5606,10 @@ static ssize_t lru_gen_seq_write(struct
 			break;
 		}
 
-		/* set by userspace for anonymous memory only */
-		if (!strncmp("max", swap_string, sizeof("max"))) {
+		if (n == 4)
+			swappiness = -1;
+		else if (!strcmp("max", swap_string)) {
+			/* set by userspace for anonymous memory only */
 			swappiness = SWAPPINESS_ANON_ONLY;
 		} else {
 			err = kstrtouint(swap_string, 0, &swappiness);
_

Patches currently in -mm which might be from hezhongkun.hzk@bytedance.com are

mm-add-swappiness=max-arg-to-memoryreclaim-for-only-anon-reclaim.patch
mm-vmscan-add-more-comments-about-cache_trim_mode.patch
mm-add-max-swappiness-arg-to-lru_gen-for-anonymous-memory-only.patch
mm-add-max-swappiness-arg-to-lru_gen-for-anonymous-memory-only-update.patch
mm-using-swappiness_anon_only-in-mglru.patch

