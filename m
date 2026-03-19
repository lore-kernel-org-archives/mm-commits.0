Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C9FF3803F7
	for <mm-commits@vger.kernel.org>; Thu, 19 Mar 2026 22:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773960905; cv=none; b=HxXxh2V7kS7Hwvsr9VDS0X5MHNC+Eg5/Pkm3uyC22RTa+NSiOIou8LYVHIyd6Aq9jGG7Dhdws4xs3DcrzH916iEo/YaLycJ8MPlZ0H4bd2f3RufEDsT5tTErP9ecORgpKGbHYFZUmgbBOP8WAGvRGwiKNgo8BI11jNsYCfD+2Cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773960905; c=relaxed/simple;
	bh=asNmPzGmwWkDqx+GdlWM0ebvE9eQldHVULTJQjrldGo=;
	h=Date:To:From:Subject:Message-Id; b=slpeNwb8IunGSFuQ3loQL5940QZn+wvReb9LW2aJxw3F/4OuMDbTf6OVDcxLZkxPVA1PH6kcWedMJ/0sRZZ5kk+3WZUFmkWrvZ1b+j9VjmxKRWs3hQdvc2Yiv0s/BfzcPD4YQ0aUWJvYVpFUUI1o3Zynak5h+oEteEGaudeQtHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mB33DP0S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mB33DP0S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A43BC19424;
	Thu, 19 Mar 2026 22:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773960905;
	bh=asNmPzGmwWkDqx+GdlWM0ebvE9eQldHVULTJQjrldGo=;
	h=Date:To:From:Subject:From;
	b=mB33DP0Sk06iC274AtFcllMP4rA2oajezX7EEBB/fgRPCV4wRVh1JXOpR3QXnmptI
	 dWag1K8S15QOmvsdhF2Mgwa2ElL6T7wXcER+9Yn1/di7y3ryvIMv53eJBhII1IZxpn
	 YRsdIp8VuQUd6CbFlqGr5oaJ8E905U0zgns9XYpY=
Date: Thu, 19 Mar 2026 15:55:04 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,yosry@kernel.org,weixugc@google.com,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,rientjes@google.com,nphamcs@gmail.com,muchun.song@linux.dev,mhocko@suse.com,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,joshua.hahnjy@gmail.com,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,axelrasmussen@google.com,bingjiao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-fix-reclaim_options-leak-in-try_charge_memcg.patch added to mm-new branch
Message-Id: <20260319225505.0A43BC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memcontrol: fix reclaim_options leak in try_charge_memcg()
has been added to the -mm mm-new branch.  Its filename is
     mm-memcontrol-fix-reclaim_options-leak-in-try_charge_memcg.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-fix-reclaim_options-leak-in-try_charge_memcg.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Bing Jiao <bingjiao@google.com>
Subject: mm/memcontrol: fix reclaim_options leak in try_charge_memcg()
Date: Wed, 18 Mar 2026 22:19:46 +0000

In try_charge_memcg(), the 'reclaim_options' variable is initialized once
at the start of the function.  However, the function contains a retry
loop.  If reclaim_options were modified during an iteration (e.g., by
encountering a memsw limit), the modified state would persist into
subsequent retries.

This leads to incorrect reclaim behavior.  Specifically,
MEMCG_RECLAIM_MAY_SWAP is cleared when the combined memcg->memsw limit is
reached.  After reclaimation attemps, a subsequent retry may successfully
charge memcg->memsw but fail on the memcg->memory charge.  In this case,
swapping should be permitted, but the carried-over state prevents it.

Fix by moving the initialization of 'reclaim_options' inside the retry
loop, ensuring a clean state for every reclaim attempt.

Link: https://lkml.kernel.org/r/20260318221957.2979346-1-bingjiao@google.com
Fixes: 6539cc053869 ("mm: memcontrol: fold mem_cgroup_do_charge()")
Signed-off-by: Bing Jiao <bingjiao@google.com>
Reviewed-by: Yosry Ahmed <yosry@kernel.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcontrol-fix-reclaim_options-leak-in-try_charge_memcg
+++ a/mm/memcontrol.c
@@ -2558,7 +2558,7 @@ static int try_charge_memcg(struct mem_c
 	struct page_counter *counter;
 	unsigned long nr_reclaimed;
 	bool passed_oom = false;
-	unsigned int reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
+	unsigned int reclaim_options;
 	bool drained = false;
 	bool raised_max_event = false;
 	unsigned long pflags;
@@ -2572,6 +2572,7 @@ retry:
 		/* Avoid the refill and flush of the older stock */
 		batch = nr_pages;
 
+	reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
 	if (!do_memsw_account() ||
 	    page_counter_try_charge(&memcg->memsw, batch, &counter)) {
 		if (page_counter_try_charge(&memcg->memory, batch, &counter))
_

Patches currently in -mm which might be from bingjiao@google.com are

mm-vmscan-fix-unintended-mtc-nmask-mutation-in-alloc_demote_folio.patch
mm-memcontrol-fix-reclaim_options-leak-in-try_charge_memcg.patch

