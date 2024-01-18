Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DC9B1E486
	for <mm-commits@vger.kernel.org>; Thu, 18 Jan 2024 22:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705616160; cv=none; b=QUuUGleec/zXmdMnicxB5qT1VW67z15MChKWxyUDyG3PwNJOgk2R4OH7lgEaJB2MYXs5gigge3lNL8MZ+LZrduGiCVYQnjAS1KhFJoR5GJbS/L7X2BgtpwZU3zcFbJsRDycmjV+unW7gFT14L2F87BCEw78PCIvbOf7CsP99+9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705616160; c=relaxed/simple;
	bh=iZx750PaYsnY6oZ91bGLfB2Xzakiec/Lh+9KFu14XtE=;
	h=Date:To:From:Subject:Message-Id; b=urGQOBFJFH6uNlJ+k8hNPbY+PZyNUrGGtxKS8BLAZMyq/4mIC58Q4xqATPcQrQkLYuX9JkV2/mr2nmVl8vfuKWFcPJLOxRbpdnKHc+Nw08ibxRChu6cmpUXuG/CAjIcS2Wm8SmUBBzNPkqbV6t/vhZuFbRJOlXNVPo2gL+vf6vM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VKBeuJF3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VKBeuJF3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07643C433F1;
	Thu, 18 Jan 2024 22:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705616160;
	bh=iZx750PaYsnY6oZ91bGLfB2Xzakiec/Lh+9KFu14XtE=;
	h=Date:To:From:Subject:From;
	b=VKBeuJF3R+POjUYsv9itx/3lsoJC2gI0R03P2+0ciqxEjRSPTbyWcflHj0rs67ulL
	 aowFowHH2DzVxFu6beSZYQHYRhxBbCpEZmrqb+pIrn8QU6KmosrUlVoKDX7lq7iUqf
	 dhA6T7gNvgABqsJe67J3hTkhWc/QcdcMt7RN8zZg=
Date: Thu, 18 Jan 2024 14:15:57 -0800
To: mm-commits@vger.kernel.org,tj@kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,jack@suse.cz,hannes@cmpxchg.org,axboe@kernel.dk,shakeelb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-writeback-ratelimit-stat-flush-from-mem_cgroup_wb_stats.patch added to mm-unstable branch
Message-Id: <20240118221600.07643C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: writeback: ratelimit stat flush from mem_cgroup_wb_stats
has been added to the -mm mm-unstable branch.  Its filename is
     mm-writeback-ratelimit-stat-flush-from-mem_cgroup_wb_stats.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-writeback-ratelimit-stat-flush-from-mem_cgroup_wb_stats.patch

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
From: Shakeel Butt <shakeelb@google.com>
Subject: mm: writeback: ratelimit stat flush from mem_cgroup_wb_stats
Date: Thu, 18 Jan 2024 18:42:35 +0000

One of our workloads (Postgres 14) has regressed when migrated from 5.10
to 6.1 upstream kernel.  The regression can be reproduced by sysbench's
oltp_write_only benchmark.  It seems like the always on rstat flush in
mem_cgroup_wb_stats() is causing the regression.  So, rate limit that
specific rstat flush.  One potential consequence would be the dirty
throttling might be decided on stale memcg stats.  However from our
benchmarks and production traffic we have not observed any change in the
dirty throttling behavior of the application.

Link: https://lkml.kernel.org/r/20240118184235.618164-1-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-writeback-ratelimit-stat-flush-from-mem_cgroup_wb_stats
+++ a/mm/memcontrol.c
@@ -4795,7 +4795,7 @@ void mem_cgroup_wb_stats(struct bdi_writ
 	struct mem_cgroup *memcg = mem_cgroup_from_css(wb->memcg_css);
 	struct mem_cgroup *parent;
 
-	mem_cgroup_flush_stats(memcg);
+	mem_cgroup_flush_stats_ratelimited(memcg);
 
 	*pdirty = memcg_page_state(memcg, NR_FILE_DIRTY);
 	*pwriteback = memcg_page_state(memcg, NR_WRITEBACK);
_

Patches currently in -mm which might be from shakeelb@google.com are

mm-writeback-ratelimit-stat-flush-from-mem_cgroup_wb_stats.patch

