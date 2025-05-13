Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E53441EDA04
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119231; cv=none; b=ovGfY4b8zvb659m+FOVPuWwYve/r736NISi5HD0Ab+bpAd4uuWhXHLEAlhNo8oReSOdYxAswuAIfshJ3lofni6PnAnSClXQHOO4I2AHr2srd6aOcxj6zJK+ZUM+weozWdECth7FkJOEyoOPkmgGdV1mwD61gbXOQrmZXv5uW6cY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119231; c=relaxed/simple;
	bh=k17M63pvoDxUehVyXdEBQwpFfunu6W184xYReQYA+FQ=;
	h=Date:To:From:Subject:Message-Id; b=SvkJBRhE9zJXnIirAgE03PQgceWkjZ6joR/kXGBUrt3IkM8WyI4YIphloH6X33TQKOvz9m9Wt6rQXDpHA1+9wu9Wk7W3U1rC9qP16JqDgJGW4vQGlyWMqlofqbvFBju/YqXrtgTl3qAHXNcgJNLK9ohcAOsyw5pYgrvOtgNtsr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ecjULE3y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ecjULE3y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52B26C4CEE4;
	Tue, 13 May 2025 06:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119230;
	bh=k17M63pvoDxUehVyXdEBQwpFfunu6W184xYReQYA+FQ=;
	h=Date:To:From:Subject:From;
	b=ecjULE3yYsTF8hQaE9p5PI946WSjzCHmEnBy1e3Gtjrtyg+E460sqZ6zEKtD+CkQ5
	 y9CeR23TwxucsrxsedpP+irPin61XlOL/uSj0N9gxUpyVzv5zMHuTy+hyVmis2H28a
	 /iumHpRrRt4uHsQneQy3faCCboBwxpMPcU656Lgw=
Date: Mon, 12 May 2025 23:53:49 -0700
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,tj@kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mhocko@suse.com,hannes@cmpxchg.org,gthelen@google.com,brauner@kernel.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-introduce-non-blocking-limit-setting-option.patch removed from -mm tree
Message-Id: <20250513065350.52B26C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: introduce non-blocking limit setting option
has been removed from the -mm tree.  Its filename was
     memcg-introduce-non-blocking-limit-setting-option.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: introduce non-blocking limit setting option
Date: Sat, 19 Apr 2025 11:35:45 -0700

Setting the max and high limits can trigger synchronous reclaim and/or
oom-kill if the usage is higher than the given limit.  This behavior is
fine for newly created cgroups but it can cause issues for the node
controller while setting limits for existing cgroups.

In our production multi-tenant and overcommitted environment, we are
seeing priority inversion when the node controller dynamically adjusts the
limits of running jobs of different priorities.  Based on the system
situation, the node controller may reduce the limits of lower priority
jobs and increase the limits of higher priority jobs.  However we are
seeing node controller getting stuck for long period of time while
reclaiming from lower priority jobs while setting their limits and also
spends a lot of its own CPU.

One of the workaround we are trying is to fork a new process which sets
the limit of the lower priority job along with setting an alarm to get
itself killed if it get stuck in the reclaim for lower priority job. 
However we are finding it very unreliable and costly.  Either we need a
good enough time buffer for the alarm to be delivered after setting limit
and potentialy spend a lot of CPU in the reclaim or be unreliable in
setting the limit for much shorter but cheaper (less reclaim) alarms.

Let's introduce new limit setting option which does not trigger reclaim
and/or oom-kill and let the processes in the target cgroup to trigger
reclaim and/or throttling and/or oom-kill in their next charge request. 
This will make the node controller on multi-tenant overcommitted
environment much more reliable.

Explanation from Johannes on side-effects of O_NONBLOCK limit change:
  It's usually the allocating tasks inside the group bearing the cost of
  limit enforcement and reclaim. This allows a (privileged) updater from
  outside the group to keep that cost in there - instead of having to
  help, from a context that doesn't necessarily make sense.

  I suppose the tradeoff with that - and the reason why this was doing
  sync reclaim in the first place - is that, if the group is idle and
  not trying to allocate more, it can take indefinitely for the new
  limit to actually be met.

  It should be okay in most scenarios in practice. As the capacity is
  reallocated from group A to B, B will exert pressure on A once it
  tries to claim it and thereby shrink it down. If A is idle, that
  shouldn't be hard. If A is running, it's likely to fault/allocate
  soon-ish and then join the effort.

  It does leave a (malicious) corner case where A is just busy-hitting
  its memory to interfere with the clawback. This is comparable to
  reclaiming memory.low overage from the outside, though, which is an
  acceptable risk. Users of O_NONBLOCK just need to be aware.

Link: https://lkml.kernel.org/r/20250419183545.1982187-1-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v2.rst |   14 ++++++++++++++
 mm/memcontrol.c                         |   10 ++++++++--
 2 files changed, 22 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/cgroup-v2.rst~memcg-introduce-non-blocking-limit-setting-option
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -1299,6 +1299,13 @@ PAGE_SIZE multiple when read back.
 	monitors the limited cgroup to alleviate heavy reclaim
 	pressure.
 
+        If memory.high is opened with O_NONBLOCK then the synchronous
+        reclaim is bypassed. This is useful for admin processes that
+        need to dynamically adjust the job's memory limits without
+        expending their own CPU resources on memory reclamation. The
+        job will trigger the reclaim and/or get throttled on its
+        next charge request.
+
   memory.max
 	A read-write single value file which exists on non-root
 	cgroups.  The default is "max".
@@ -1316,6 +1323,13 @@ PAGE_SIZE multiple when read back.
 	Caller could retry them differently, return into userspace
 	as -ENOMEM or silently ignore in cases like disk readahead.
 
+        If memory.max is opened with O_NONBLOCK, then the synchronous
+        reclaim and oom-kill are bypassed. This is useful for admin
+        processes that need to dynamically adjust the job's memory limits
+        without expending their own CPU resources on memory reclamation.
+        The job will trigger the reclaim and/or oom-kill on its next
+        charge request.
+
   memory.reclaim
 	A write-only nested-keyed file which exists for all cgroups.
 
--- a/mm/memcontrol.c~memcg-introduce-non-blocking-limit-setting-option
+++ a/mm/memcontrol.c
@@ -4269,6 +4269,9 @@ static ssize_t memory_high_write(struct
 
 	page_counter_set_high(&memcg->memory, high);
 
+	if (of->file->f_flags & O_NONBLOCK)
+		goto out;
+
 	for (;;) {
 		unsigned long nr_pages = page_counter_read(&memcg->memory);
 		unsigned long reclaimed;
@@ -4291,7 +4294,7 @@ static ssize_t memory_high_write(struct
 		if (!reclaimed && !nr_retries--)
 			break;
 	}
-
+out:
 	memcg_wb_domain_size_changed(memcg);
 	return nbytes;
 }
@@ -4318,6 +4321,9 @@ static ssize_t memory_max_write(struct k
 
 	xchg(&memcg->memory.max, max);
 
+	if (of->file->f_flags & O_NONBLOCK)
+		goto out;
+
 	for (;;) {
 		unsigned long nr_pages = page_counter_read(&memcg->memory);
 
@@ -4345,7 +4351,7 @@ static ssize_t memory_max_write(struct k
 			break;
 		cond_resched();
 	}
-
+out:
 	memcg_wb_domain_size_changed(memcg);
 	return nbytes;
 }
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are


