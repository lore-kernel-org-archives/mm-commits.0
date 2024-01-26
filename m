Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA376167C
	for <mm-commits@vger.kernel.org>; Fri, 26 Jan 2024 07:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706255707; cv=none; b=Dr1PdQVza0AcwEe9TDd3pKwDVsk/x0fs31g77pV6gfvAMUX0I4Yhtfxpp/GtU0eHBiKIkRfJ8U76Ps83HekegjivaXnQ7x7PW3zrLop0tpCdRf3utH9H/mPEIJJL+Sk9/1xhq4eR0JdZ+nJHiWGjJ37Mm92LyD5JObsM01SSMEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706255707; c=relaxed/simple;
	bh=KFETn0Yy+PKywOzjoIsyPsKVym0KrmIBBaZ/4Kd7LH0=;
	h=Date:To:From:Subject:Message-Id; b=ilBHFhilQIPdeHjy3P/WQrDPRFAA0F0Mh9//cHtQhiyKfDTe8o0ofW5sQae+Ge7l/1tfqsuzkKSPxCrqxrlTW0AL+oStuCJ5t8wOL2gnNK5NuX9H8AsM59JBmOCR2rDuhuXywBhKJa1HoeR1eVgZiyu683OTdEbDo6fZFJp64gE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TT+/qjzI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TT+/qjzI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68BD8C433C7;
	Fri, 26 Jan 2024 07:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706255706;
	bh=KFETn0Yy+PKywOzjoIsyPsKVym0KrmIBBaZ/4Kd7LH0=;
	h=Date:To:From:Subject:From;
	b=TT+/qjzIq2FSNuajco8/6TpWnvS97h0dGqZPDe8wSBGcr1hrm67qTruTbgvKA1gjC
	 LBFIoDtCnYL6P6rtBfLgZW3vD4B2kdgHJdXi2Nb1HdsMav+xuwoYXt8yIvrBwDJWT1
	 CFF88EElxBV/OK4BKLMR//lhCSUa3lrY6Zn3xp9k=
Date: Thu, 25 Jan 2024 23:55:03 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,tj@kernel.org,shakeelb@google.com,schatzberg.dan@gmail.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcontrol-dont-throttle-dying-tasks-on-memoryhigh.patch removed from -mm tree
Message-Id: <20240126075506.68BD8C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcontrol: don't throttle dying tasks on memory.high
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-dont-throttle-dying-tasks-on-memoryhigh.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[hannes@cmpxchg.org: also handle tasks are being killed during the reclaim]
  Link: https://lkml.kernel.org/r/20240111192807.GA424308@cmpxchg.org
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

 mm/memcontrol.c |   29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-dont-throttle-dying-tasks-on-memoryhigh
+++ a/mm/memcontrol.c
@@ -2623,8 +2623,9 @@ static unsigned long calculate_high_dela
 }
 
 /*
- * Scheduled by try_charge() to be executed from the userland return path
- * and reclaims memory over the high limit.
+ * Reclaims memory over the high limit. Called directly from
+ * try_charge() (context permitting), as well as from the userland
+ * return path where reclaim is always able to block.
  */
 void mem_cgroup_handle_over_high(gfp_t gfp_mask)
 {
@@ -2644,6 +2645,17 @@ void mem_cgroup_handle_over_high(gfp_t g
 
 retry_reclaim:
 	/*
+	 * Bail if the task is already exiting. Unlike memory.max,
+	 * memory.high enforcement isn't as strict, and there is no
+	 * OOM killer involved, which means the excess could already
+	 * be much bigger (and still growing) than it could for
+	 * memory.max; the dying task could get stuck in fruitless
+	 * reclaim for a long time, which isn't desirable.
+	 */
+	if (task_is_dying())
+		goto out;
+
+	/*
 	 * The allocating task should reclaim at least the batch size, but for
 	 * subsequent retries we only want to do what's necessary to prevent oom
 	 * or breaching resource isolation.
@@ -2693,6 +2705,9 @@ retry_reclaim:
 	}
 
 	/*
+	 * Reclaim didn't manage to push usage below the limit, slow
+	 * this allocating task down.
+	 *
 	 * If we exit early, we're guaranteed to die (since
 	 * schedule_timeout_killable sets TASK_KILLABLE). This means we don't
 	 * need to account for any ill-begotten jiffies to pay them off later.
@@ -2887,11 +2902,17 @@ done_restock:
 		}
 	} while ((memcg = parent_mem_cgroup(memcg)));
 
+	/*
+	 * Reclaim is set up above to be called from the userland
+	 * return path. But also attempt synchronous reclaim to avoid
+	 * excessive overrun while the task is still inside the
+	 * kernel. If this is successful, the return path will see it
+	 * when it rechecks the overage and simply bail out.
+	 */
 	if (current->memcg_nr_pages_over_high > MEMCG_CHARGE_BATCH &&
 	    !(current->flags & PF_MEMALLOC) &&
-	    gfpflags_allow_blocking(gfp_mask)) {
+	    gfpflags_allow_blocking(gfp_mask))
 		mem_cgroup_handle_over_high(gfp_mask);
-	}
 	return 0;
 }
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are


