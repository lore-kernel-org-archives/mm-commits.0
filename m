Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 561703D3AC
	for <mm-commits@vger.kernel.org>; Thu,  9 May 2024 18:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715280981; cv=none; b=BLNtwhclcVC5Mt4GT4RIshxnKHjxsXtqFJF8AENaBjwzFiGSwaCGX7Lm8qegsAQQ2y91Y0AYcG2KzK4YMnjyicGfQ1NgtyxqF0LuAuPGTojL+g5wQcb37Mn/p9ieFDZSMaW+4/7xaIu/KcwIGAFLf7+oNLr0ROEbrgeJ/x7WmHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715280981; c=relaxed/simple;
	bh=qwrtyH8g981FGvw8w/PeeuMTeug6/vt5ANXELLI25ws=;
	h=Date:To:From:Subject:Message-Id; b=XwOAbO0ecpqryuQOLGpFfOPLzJwmYhCZNtI7k94Iw950ktBuS6QmAuDSwZu4OTqpbZEsAAWzPGREx+4pI59rbbptIzdQv7u6m/R0NdmqWpkSOBIE8cIlU9Ij5zswAeh7KrYD9Fv9nRmrpxJJrgJY2FFNfRVzyt2oFq6VFXte+Ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qGC/UxCc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qGC/UxCc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADFEFC116B1;
	Thu,  9 May 2024 18:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715280980;
	bh=qwrtyH8g981FGvw8w/PeeuMTeug6/vt5ANXELLI25ws=;
	h=Date:To:From:Subject:From;
	b=qGC/UxCccoGFHnYlYS1cHppnvkm9H15sClS7vtEUxXeOOqppndhM5g8Hp1h2OHcV5
	 +NHMJjQLoBrYmExDccnTPMZeD2dG2VH5wWNt0vbm0Zq4cdEiMQoqxNjrFPOD2W+0LR
	 N+V/Vl9F2ISxoAybOuAW/bkPjVYrUhFx30kfZtkM=
Date: Thu, 09 May 2024 11:56:20 -0700
To: mm-commits@vger.kernel.org,vschneid@redhat.com,vincent.guittot@linaro.org,songmuchun@bytedance.com,shakeelb@google.com,rostedt@goodmis.org,roman.gushchin@linux.dev,peterz@infradead.org,mingo@redhat.com,mhocko@suse.com,mgorman@suse.de,juri.lelli@redhat.com,hannes@cmpxchg.org,dietmar.eggemann@arm.com,bsegall@google.com,bristot@redhat.com,xiujianfeng@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-oom-cleanup-unused-memcg_oom_gfp_mask-and-memcg_oom_order.patch added to mm-unstable branch
Message-Id: <20240509185620.ADFEFC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg, oom: cleanup unused memcg_oom_gfp_mask and memcg_oom_order
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-oom-cleanup-unused-memcg_oom_gfp_mask-and-memcg_oom_order.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-oom-cleanup-unused-memcg_oom_gfp_mask-and-memcg_oom_order.patch

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
From: Xiu Jianfeng <xiujianfeng@huawei.com>
Subject: memcg, oom: cleanup unused memcg_oom_gfp_mask and memcg_oom_order
Date: Thu, 9 May 2024 03:26:28 +0000

Since commit 857f21397f71 ("memcg, oom: remove unnecessary check in
mem_cgroup_oom_synchronize()"), memcg_oom_gfp_mask and memcg_oom_order are
no longer used any more.

Link: https://lkml.kernel.org/r/20240509032628.1217652-1-xiujianfeng@huawei.com
Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Benjamin Segall <bsegall@google.com>
Cc: Daniel Bristot de Oliveira <bristot@redhat.com>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    2 --
 mm/memcontrol.c       |    2 --
 2 files changed, 4 deletions(-)

--- a/include/linux/sched.h~memcg-oom-cleanup-unused-memcg_oom_gfp_mask-and-memcg_oom_order
+++ a/include/linux/sched.h
@@ -1448,8 +1448,6 @@ struct task_struct {
 
 #ifdef CONFIG_MEMCG
 	struct mem_cgroup		*memcg_in_oom;
-	gfp_t				memcg_oom_gfp_mask;
-	int				memcg_oom_order;
 
 	/* Number of pages to reclaim on returning to userland: */
 	unsigned int			memcg_nr_pages_over_high;
--- a/mm/memcontrol.c~memcg-oom-cleanup-unused-memcg_oom_gfp_mask-and-memcg_oom_order
+++ a/mm/memcontrol.c
@@ -2188,8 +2188,6 @@ static bool mem_cgroup_oom(struct mem_cg
 		if (current->in_user_fault) {
 			css_get(&memcg->css);
 			current->memcg_in_oom = memcg;
-			current->memcg_oom_gfp_mask = mask;
-			current->memcg_oom_order = order;
 		}
 		return false;
 	}
_

Patches currently in -mm which might be from xiujianfeng@huawei.com are

mm-memcg-make-alloc_mem_cgroup_per_node_info-return-bool.patch
memcg-oom-cleanup-unused-memcg_oom_gfp_mask-and-memcg_oom_order.patch

