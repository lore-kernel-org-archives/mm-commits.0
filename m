Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A256E1B86C1
	for <mm-commits@vger.kernel.org>; Wed, 14 Aug 2024 20:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723669083; cv=none; b=p9HqVbjWIFOWKyN9ERislmX5FCz9NDn2QFdJu4LxoWRVpMb5UiLfT9oeafbDDq9U/Q2kTq1NkUd+SzfjfHNhfWncA7JEz1eRF4/PmtxYpsh0e4NDh1mM1qeWgsRCgAQq45lslkMLfxp1Iugpf1t/lsIsCvWbB/mq9QQrm/W9ZcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723669083; c=relaxed/simple;
	bh=TPpNOxlVuIV1+WNbs7IKFkHIWb+f7KIHnqTzhy8WDCo=;
	h=Date:To:From:Subject:Message-Id; b=AiJiRr9jPuAtuD6imSRisVMzm+DQem41aUwInstHQL4EpcSrfOT8AJlNVFtB8LxzFWpyuHfq47tHTjvuZGflSLm3HBD93vCCuypntW+yxeJX0lJ1+RODh9A8K7/UArRgmhwGZqzP2Bmspx0vrTgmDyr83oM3SYuMi89/ZqM+l9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AQ77umLW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AQ77umLW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10700C116B1;
	Wed, 14 Aug 2024 20:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723669083;
	bh=TPpNOxlVuIV1+WNbs7IKFkHIWb+f7KIHnqTzhy8WDCo=;
	h=Date:To:From:Subject:From;
	b=AQ77umLWysMynFUozr5TckS+PHn4GcsSpSy53+q1Q+FYQSeW1hOeqvBeq81HI4TFh
	 iwOfXUXtApvFBIypHb/DI/txBguHDqzXeUcLFnX1z9yeNZtp+kLUPQbuUJWdnDBrp3
	 9e4njmMCUTBTvuppec/dDVFFUVjYTt8MewSgMjF4=
Date: Wed, 14 Aug 2024 13:58:02 -0700
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-initiate-deprecation-of-v1-soft-limit.patch added to mm-unstable branch
Message-Id: <20240814205803.10700C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: initiate deprecation of v1 soft limit
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-initiate-deprecation-of-v1-soft-limit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-initiate-deprecation-of-v1-soft-limit.patch

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
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: initiate deprecation of v1 soft limit
Date: Wed, 14 Aug 2024 13:28:23 -0700

Memcg v1 provides soft limit functionality for the best effort memory
sharing between multiple workloads on a system.  It is usually triggered
through kswapd and at the moment does not reclaim kernel memory.

Memcg v2 provide more straightforward best effort (memory.low) and hard
protection (memory.min) functionalities.  Let's initiate the deprecation
of soft limit from v1 and gather if v2 needs something more to move the
existing v1 users to v2 regarding soft limit.

Link: https://lkml.kernel.org/r/20240814202825.2694077-3-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v1/memory.rst |    8 ++++++--
 mm/memcontrol-v1.c                             |    3 +++
 2 files changed, 9 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/cgroup-v1/memory.rst~memcg-initiate-deprecation-of-v1-soft-limit
+++ a/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -78,6 +78,8 @@ Brief summary of control files.
  memory.memsw.max_usage_in_bytes     show max memory+Swap usage recorded
  memory.soft_limit_in_bytes	     set/show soft limit of memory usage
 				     This knob is not available on CONFIG_PREEMPT_RT systems.
+                                     This knob is deprecated and shouldn't be
+                                     used.
  memory.stat			     show various statistics
  memory.use_hierarchy		     set/show hierarchical account enabled
                                      This knob is deprecated and shouldn't be
@@ -701,8 +703,10 @@ For compatibility reasons writing 1 to m
 
 	# echo 1 > memory.use_hierarchy
 
-7. Soft limits
-==============
+7. Soft limits (DEPRECATED)
+===========================
+
+THIS IS DEPRECATED!
 
 Soft limits allow for greater sharing of memory. The idea behind soft limits
 is to allow control groups to use as much of the memory as needed, provided
--- a/mm/memcontrol-v1.c~memcg-initiate-deprecation-of-v1-soft-limit
+++ a/mm/memcontrol-v1.c
@@ -2455,6 +2455,9 @@ static ssize_t mem_cgroup_write(struct k
 		if (IS_ENABLED(CONFIG_PREEMPT_RT)) {
 			ret = -EOPNOTSUPP;
 		} else {
+			pr_warn_once("soft_limit_in_bytes is deprecated and will be removed. "
+				     "Please report your usecase to linux-mm@kvack.org if you "
+				     "depend on this functionality.\n");
 			WRITE_ONCE(memcg->soft_limit, nr_pages);
 			ret = 0;
 		}
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-increase-the-valid-index-range-for-memcg-stats.patch
memcg-replace-memcg-id-idr-with-xarray.patch
memcg-use-ratelimited-stats-flush-in-the-reclaim.patch
memcg-initiate-deprecation-of-v1-tcp-accounting.patch
memcg-initiate-deprecation-of-v1-soft-limit.patch
memcg-initiate-deprecation-of-oom_control.patch
memcg-initiate-deprecation-of-pressure_level.patch

