Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FC21156C6F
	for <mm-commits@vger.kernel.org>; Thu, 15 Aug 2024 23:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723765288; cv=none; b=qS7DF4byCoQCVO96IcTmToxGm6NIuu4SfiZtLhPgGimXYRXwho6fLEgXNaoE/2twVGc2c/BSS5i/EBbeRbHgvuW97tu946gRWTU31u5VJRTqzlFpJQJQh4XZ6zMT4SzhmSU83bihGKBHSsU4DeSD7+0OHJAmxPXfyByPydFQszk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723765288; c=relaxed/simple;
	bh=2k2SpVSQob8jZOK9k8DQ85md3PYxbxXwaKpXyB6pllA=;
	h=Date:To:From:Subject:Message-Id; b=BqVNigyLuJtfVN0UBBVdSgcFsuQZ48Q/acPy20lDrELhXHyUMILyg6rr5mDaYSK5sy5PWMxy4OynQt0JtZOmVO/FVSeUKeVIwIBLmYtkbpwfve/OgkNr/8qMebXvT1rPK+YKYHGS2762bTQjX/c2LRT35WZO69+DXWLIYcUmxw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=f3YfIH5n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="f3YfIH5n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FDF0C4AF10;
	Thu, 15 Aug 2024 23:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723765287;
	bh=2k2SpVSQob8jZOK9k8DQ85md3PYxbxXwaKpXyB6pllA=;
	h=Date:To:From:Subject:From;
	b=f3YfIH5nJhyFg7VOLZLv5lv3V6zeUiw0UkuLzMCYIVpV1IUb+0AIYYf29Mb2+a2fm
	 GZUZQuRqncV1L8rkhTKTjH2qu4PmZrS2KWL6y3a9DynIEIMlbJJ/i1CH15ruJqG6dc
	 +sxxG2EEzf4q86MnYsPiwmA8Pb33nSk7wylVdETI=
Date: Thu, 15 Aug 2024 16:41:26 -0700
To: mm-commits@vger.kernel.org,tjmercier@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-initiate-deprecation-of-v1-soft-limit.patch added to mm-unstable branch
Message-Id: <20240815234127.7FDF0C4AF10@smtp.kernel.org>
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
Date: Wed, 14 Aug 2024 15:00:19 -0700

Memcg v1 provides soft limit functionality for the best effort memory
sharing between multiple workloads on a system.  It is usually triggered
through kswapd and at the moment does not reclaim kernel memory.

Memcg v2 provides more straightforward best effort (memory.low) and hard
protection (memory.min) functionalities.  Let's initiate the deprecation
of soft limit from v1 and gather if v2 needs something more to move the
existing v1 users to v2 regarding soft limit.

Link: https://lkml.kernel.org/r/20240814220021.3208384-3-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: T.J. Mercier <tjmercier@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <muchun.song@linux.dev>
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
@@ -2542,6 +2542,9 @@ static ssize_t mem_cgroup_write(struct k
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
memcg-replace-memcg-id-idr-with-xarray-v2.patch
memcg-use-ratelimited-stats-flush-in-the-reclaim.patch
memcg-move-v1-only-percpu-stats-in-separate-struct.patch
memcg-move-mem_cgroup_event_ratelimit-to-v1-code.patch
memcg-move-mem_cgroup_charge_statistics-to-v1-code.patch
memcg-move-v1-events-and-statistics-code-to-v1-file.patch
memcg-make-v1-only-functions-static.patch
memcg-allocate-v1-event-percpu-only-on-v1-deployment.patch
memcg-make-pgpgin-and-pgpgout-v1-only.patch
memcg-initiate-deprecation-of-v1-tcp-accounting.patch
memcg-initiate-deprecation-of-v1-soft-limit.patch
memcg-initiate-deprecation-of-oom_control.patch
memcg-initiate-deprecation-of-pressure_level.patch

