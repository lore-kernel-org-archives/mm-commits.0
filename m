Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AADEB3FC7
	for <mm-commits@vger.kernel.org>; Sun, 20 Apr 2025 20:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745181535; cv=none; b=LLh4YEIB7ircBG0q8AxIvVcSJNdi/CkUdvEZbRj4P7izNo1uSQm3DsDavtZYQOfQTtoNSvIqtdEHRej2XmX6jd7HUaH214KBu9fFoAOgjOmhCX4SR0FvYJOoxgPhH01PP/xPXRpLQtnFeszY/fMC2QfUzDrdTRqfJnSXaU/wMtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745181535; c=relaxed/simple;
	bh=OlCZjB3FZXcXzcQOu6SwTfbVZ3N2zAlfLST5/KiOT4E=;
	h=Date:To:From:Subject:Message-Id; b=n4raia/yfswFZApPImce+8qodTzqudCSmM9krkQWJ9xl503RcJwvloD4VeoLkxhNiuOo2FLBvSDIqNKJm1VIvLLkjU19eg4XPdbLb21vcTUBjbrwilIxgCQTQkbDYmwY/29FsZ+TbiVxzSvoXx8ibAjQuYtm95le1PQ8xpFly+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FzaMpibz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FzaMpibz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4FB0C4CEE2;
	Sun, 20 Apr 2025 20:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745181535;
	bh=OlCZjB3FZXcXzcQOu6SwTfbVZ3N2zAlfLST5/KiOT4E=;
	h=Date:To:From:Subject:From;
	b=FzaMpibz+ropWsp/4CUkoCSBSXqUgOtjtE5hWYoCDSlasVd0QAmFK/P150dTg5qul
	 Tpz30/hzVwgopS2J9/GE7wMGXnKshKTkAF/oLrt+6M8QXp3pgwb+mTDStgG+2CZHg9
	 r3i4vdQy8CxsWAN9dA5/bdSWaLPKQbEi/vXKWEMw=
Date: Sun, 20 Apr 2025 13:38:54 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,gthelen@google.com,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-introduce-non-blocking-limit-setting-option.patch added to mm-new branch
Message-Id: <20250420203854.E4FB0C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: introduce non-blocking limit setting option
has been added to the -mm mm-new branch.  Its filename is
     memcg-introduce-non-blocking-limit-setting-option.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-introduce-non-blocking-limit-setting-option.patch

This patch will later appear in the mm-new branch at
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

Link: https://lkml.kernel.org/r/20250419183545.1982187-1-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
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
@@ -4252,6 +4252,9 @@ static ssize_t memory_high_write(struct
 
 	page_counter_set_high(&memcg->memory, high);
 
+	if (of->file->f_flags & O_NONBLOCK)
+		goto out;
+
 	for (;;) {
 		unsigned long nr_pages = page_counter_read(&memcg->memory);
 		unsigned long reclaimed;
@@ -4274,7 +4277,7 @@ static ssize_t memory_high_write(struct
 		if (!reclaimed && !nr_retries--)
 			break;
 	}
-
+out:
 	memcg_wb_domain_size_changed(memcg);
 	return nbytes;
 }
@@ -4301,6 +4304,9 @@ static ssize_t memory_max_write(struct k
 
 	xchg(&memcg->memory.max, max);
 
+	if (of->file->f_flags & O_NONBLOCK)
+		goto out;
+
 	for (;;) {
 		unsigned long nr_pages = page_counter_read(&memcg->memory);
 
@@ -4328,7 +4334,7 @@ static ssize_t memory_max_write(struct k
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

memcg-vmalloc-simplify-memcg_vmalloc-updates.patch
memcg-vmalloc-simplify-memcg_vmalloc-updates-fix.patch
memcg-remove-root-memcg-check-from-refill_stock.patch
memcg-decouple-drain_obj_stock-from-local-stock.patch
memcg-introduce-memcg_uncharge.patch
memcg-manually-inline-__refill_stock.patch
memcg-no-refilling-stock-from-obj_cgroup_release.patch
memcg-do-obj_cgroup_put-inside-drain_obj_stock.patch
memcg-use-__mod_memcg_state-in-drain_obj_stock.patch
memcg-manually-inline-replace_stock_objcg.patch
memcg-optimize-memcg_rstat_updated.patch
memcg-multi-memcg-percpu-charge-cache.patch
memcg-introduce-non-blocking-limit-setting-option.patch

