Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3768F20328
	for <mm-commits@vger.kernel.org>; Tue, 16 Jan 2024 21:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705441550; cv=none; b=lPJ4EjA72+7+7UEJlmVMisQYEiUzuOnb4fivS2MOyjU4uxgjAhjpmKgslUa7PujyladeLB6LSH5yzYBuef028qO1OFmD1aIy2V4RY+FYs1oJVL5jMh3149Wj1OV6of9+5zDnkZoRtq/XSNs9fvo3iY4LP2OvcmNVSSSA+8p3mEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705441550; c=relaxed/simple;
	bh=MDiO0cIEYSYZRXubBPpZZCBhHnAWP643iKaAKgZ4ISI=;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id; b=ES237mhuTHu8i/a2hoXtbYPAt3noVzqNhPayRI0P3X2m7u97uke1I5Bmb6OV8n70XfemhV2w3sWHC7aHTBy11LObNy5jyaC8EeCwS1Gph5HBCLaqty2gekQiTf2XyHBxyrnfKuWeUJWFzNp1xnVLDTKvAmu3QGOJf1XdRpNIkpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PVCcROZq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PVCcROZq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E4EAC433C7;
	Tue, 16 Jan 2024 21:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705441549;
	bh=MDiO0cIEYSYZRXubBPpZZCBhHnAWP643iKaAKgZ4ISI=;
	h=Date:To:From:Subject:From;
	b=PVCcROZqliLMj0x/edwrkv1PRYzWF3AoJsxGI35ID6ZA3nCKTj2a0QGwIH+J3RsPT
	 yGw725zKdyAhYVPAQ/T1q26UU2ozHvjclBMa8gxudO6ejpyogO5ANDF5jKZcpJyZan
	 2KAB9flF+cU2CMnNwl45rydxfT8WtIMLXlv/uBZI=
Date: Tue, 16 Jan 2024 13:45:47 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,tj@kernel.org,shakeelb@google.com,schatzberg.dan@gmail.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-dont-throttle-dying-tasks-on-memoryhigh.patch added to mm-hotfixes-unstable branch
Message-Id: <20240116214549.6E4EAC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcontrol: don't throttle dying tasks on memory.high
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memcontrol-dont-throttle-dying-tasks-on-memoryhigh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-dont-throttle-dying-tasks-on-memoryhigh.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: don't throttle dying tasks on memory.high
Date: Thu, 11 Jan 2024 08:29:02 -0500

While investigating hosts with high cgroup memory pressures, Tejun
found culprit zombie tasks that had were holding on to a lot of
memory, had SIGKILL pending, but were stuck in memory.high reclaim.

In the past, we used to always force-charge allocations from tasks
that were exiting in order to accelerate them dying and freeing up
their rss. This changed for memory.max in a4ebf1b6ca1e ("memcg:
prohibit unconditional exceeding the limit of dying tasks"); it noted
that this can cause (userspace inducable) containment failures, so it
added a mandatory reclaim and OOM kill cycle before forcing charges.
At the time, memory.high enforcement was handled in the userspace
return path, which isn't reached by dying tasks, and so memory.high
was still never enforced by dying tasks.

When c9afe31ec443 ("memcg: synchronously enforce memory.high for large
overcharges") added synchronous reclaim for memory.high, it added
unconditional memory.high enforcement for dying tasks as well. The
callstack shows that this path is where the zombie is stuck in.

We need to accelerate dying tasks getting past memory.high, but we
cannot do it quite the same way as we do for memory.max: memory.max is
enforced strictly, and tasks aren't allowed to move past it without
FIRST reclaiming and OOM killing if necessary. This ensures very small
levels of excess. With memory.high, though, enforcement happens lazily
after the charge, and OOM killing is never triggered. A lot of
concurrent threads could have pushed, or could actively be pushing,
the cgroup into excess. The dying task will enter reclaim on every
allocation attempt, with little hope of restoring balance.

To fix this, skip synchronous memory.high enforcement on dying tasks
altogether again. Update memory.high path documentation while at it.

Link: https://lkml.kernel.org/r/20240111132902.389862-1-hannes@cmpxchg.org
Fixes: c9afe31ec443 ("memcg: synchronously enforce memory.high for large overcharges")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Dan Schatzberg <schatzberg.dan@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-dont-throttle-dying-tasks-on-memoryhigh
+++ a/mm/memcontrol.c
@@ -2623,8 +2623,9 @@ static unsigned long calculate_high_dela
 }
 
 /*
- * Scheduled by try_charge() to be executed from the userland return path
- * and reclaims memory over the high limit.
+ * Reclaims memory over the high limit. Called directly from
+ * try_charge() when possible, but also scheduled to be called from
+ * the userland return path where reclaim is always able to block.
  */
 void mem_cgroup_handle_over_high(gfp_t gfp_mask)
 {
@@ -2693,6 +2694,9 @@ retry_reclaim:
 	}
 
 	/*
+	 * Reclaim didn't manage to push usage below the limit, slow
+	 * this allocating task down.
+	 *
 	 * If we exit early, we're guaranteed to die (since
 	 * schedule_timeout_killable sets TASK_KILLABLE). This means we don't
 	 * need to account for any ill-begotten jiffies to pay them off later.
@@ -2887,8 +2891,22 @@ done_restock:
 		}
 	} while ((memcg = parent_mem_cgroup(memcg)));
 
+	/*
+	 * Reclaim is scheduled for the userland return path already,
+	 * but also attempt synchronous reclaim to avoid excessive
+	 * overrun while the task is still inside the kernel. If this
+	 * is successful, the return path will see it when it rechecks
+	 * the overage, and simply bail out.
+	 *
+	 * Skip if the task is already dying, though. Unlike
+	 * memory.max, memory.high enforcement isn't as strict, and
+	 * there is no OOM killer involved, which means the excess
+	 * could already be much bigger (and still growing) than it
+	 * could for memory.max; the dying task could get stuck in
+	 * fruitless reclaim for a long time, which isn't desirable.
+	 */
 	if (current->memcg_nr_pages_over_high > MEMCG_CHARGE_BATCH &&
-	    !(current->flags & PF_MEMALLOC) &&
+	    !(current->flags & PF_MEMALLOC) && !task_is_dying() &&
 	    gfpflags_allow_blocking(gfp_mask)) {
 		mem_cgroup_handle_over_high(gfp_mask);
 	}
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-memcontrol-dont-throttle-dying-tasks-on-memoryhigh.patch

