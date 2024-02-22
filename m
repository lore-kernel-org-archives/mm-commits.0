Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ECA917550
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560088; cv=none; b=T4+FsHrcxYxzNhhpWtBCtqtR9rJHxU7ujzW9WRgvi4D6fy0o68O9zFnj9giD8U8mxIsuYYPwtIAqJhDMwmIrb/pzeX99xkEAiNOgs8dsYCCskFyqiLTp7XUPft+cFXQWmismuEFYVqxgcrkkoS7X7AWkMuw66/qbQVrNmJd6GMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560088; c=relaxed/simple;
	bh=17CzwoPFfkoGBzGCc31xxFmjJe8oCr4BxJtpGHmrH5c=;
	h=Date:To:From:Subject:Message-Id; b=LsiSiG3qwAYMz8gAM/N0ix2LCh+cXeOjfI18KZK+qthexiTSrCX5KWncoaMOCe6xADvxRjW5gFby4fHUyn9dc7IK+bkxUejWb+ih79mm7SV7P3kOkDC9haWnQpIdQ6rcnKlQdOKsjJhoVQZ2D/ahMlnccsiSJAAp1iScwYhFnew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sd7thiJ5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sd7thiJ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DB4BC433C7;
	Thu, 22 Feb 2024 00:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560088;
	bh=17CzwoPFfkoGBzGCc31xxFmjJe8oCr4BxJtpGHmrH5c=;
	h=Date:To:From:Subject:From;
	b=sd7thiJ507EHhmE7GkHws1Etk0fDC9YWLNmOsB2RKBO8fVb7EG0WVsUDDELmOM3K9
	 1BhsfS1nK21+ibT1xCBuJDI1WND7rfoCHYZdFqQq97OvPzf6J5lhm47I08b3DmrUWu
	 aYY8vJUaW62UjJmGU3cfYejy11CmjYleEMFBAhyI=
Date: Wed, 21 Feb 2024 16:01:27 -0800
To: mm-commits@vger.kernel.org,tj@kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,jack@suse.cz,hannes@cmpxchg.org,axboe@kernel.dk,shakeelb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-writeback-ratelimit-stat-flush-from-mem_cgroup_wb_stats.patch removed from -mm tree
Message-Id: <20240222000128.5DB4BC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: writeback: ratelimit stat flush from mem_cgroup_wb_stats
has been removed from the -mm tree.  Its filename was
     mm-writeback-ratelimit-stat-flush-from-mem_cgroup_wb_stats.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Fixes: 2d146aa3aa84 ("mm: memcontrol: switch to rstat")
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-writeback-ratelimit-stat-flush-from-mem_cgroup_wb_stats
+++ a/mm/memcontrol.c
@@ -4800,7 +4800,7 @@ void mem_cgroup_wb_stats(struct bdi_writ
 	struct mem_cgroup *memcg = mem_cgroup_from_css(wb->memcg_css);
 	struct mem_cgroup *parent;
 
-	mem_cgroup_flush_stats(memcg);
+	mem_cgroup_flush_stats_ratelimited(memcg);
 
 	*pdirty = memcg_page_state(memcg, NR_FILE_DIRTY);
 	*pwriteback = memcg_page_state(memcg, NR_WRITEBACK);
_

Patches currently in -mm which might be from shakeelb@google.com are


