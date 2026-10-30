Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793404120;
	b=zK+dHXYuMTaQFYHuEmIGg7dntfjiZeCYg779fgzV1Bjr6IpHFTPblhTT6cY5JQYeEFBn
	 T9Adxbf6q+X/FFl5GJs0mH3IFxj6zO55p0TYjS5fVrde97aUKwxEeuL26YZh0jq5D9OMQ
	 A+YKUtH35GB0zYZYpECAWgmufog8B2SqibUHTxYmM8D43I4DIjMuw9x5k6vFlQbIadWSC
	 MRSGDSmeXn0u9dZOhNov9hg0bTWg0qOPeQz1qnHP5wptKJ4MYDrlS+wxTOzoAE7zIWVHu
	 yZ0GlcLaVlxQU2cvvXnk9gf5eSHkGgPKu+jkehWChathIX7HsAP1nvn1w2VYyqRVoiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793404120;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=4uixsSc2lgLxYb7r7GaKlHkdqqk7hfocMLpvCZOM5f0=;
	b=HCdfiGEvgxD3Yls+T4zg4wh3H1XeTBfskG8dajIo4UNWtc6FS6B/KtMhayLqZSGxysVY
	 u82HJlN8xn4GQGHAHq+7Rza43tD9SDjhl8J2fRbWjEXOPHgXLFVmpes/Str60YTzatikw
	 3ajVt2nj7mMocmMVul8tzk/m2oh7uGTeeOX3lCdMpBKsyVbuFUdd6UipvLb+WylxK7r81
	 0oaoHIawL/TqcClX8cMqw6Wb0pxvQQpKtcCwPpa9d7tcINUBOlOF8gshgJzUf86YFthdg
	 JvYH0kOewfFYlwL1gBauAIgOIk2jlSK/vmaH11k4+Anf2K0UHC4b0vAD3YV8RMnLdJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=KWafOQWM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A3A3606A31A
	for <mm-commits@vger.kernel.org>; Fri, 30 Oct 2026 23:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=KWafOQWM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DE741F000C1;
	Fri, 30 Oct 2026 23:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793404120;
	bh=4uixsSc2lgLxYb7r7GaKlHkdqqk7hfocMLpvCZOM5f0=;
	h=Date:To:From:Subject;
	b=KWafOQWMTmNSB/Ygr6DO9Mg3ZE5N/Uo1nwBF2uDP15/jcynoLchc1TvW3mrlvdFxX
	 AbAmX3PHvVCXUIJgtC1WuZi0Rz+swl92jFO4EtStTDakhDgvJ340wE93FsuRwqj2KB
	 8ENf0bj8OazmfVa00fCPHOYNYmUa/bcOwNIO09Jw=
Date: Fri, 30 Oct 2026 16:48:39 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,roman.gushchin@linux.dev,
	muchun.song@linux.dev,mhocko@suse.com,mhocko@kernel.org,harry@kernel.org,
	hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-force-charges-from-reclaim-before-trying-the-limits.patch added to mm-new branch
Message-Id: <20261030234840.0DE741F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: memcg: force charges from reclaim before trying the limits
has been added to the -mm mm-new branch.  Its filename is
     memcg-force-charges-from-reclaim-before-trying-the-limits.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-force-charges-from-reclaim-before-trying-the-limits.patch

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
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: force charges from reclaim before trying the limits
Date: Fri, 30 Oct 2026 13:54:13 -0700

Reclaim can charge memory, for example when zswap stores a page.
try_charge_memcg() forces these PF_MEMALLOC charges, but only after
they fail at a limit. A charge that fits still has memory.high
enforced. That can make a task in direct reclaim do more reclaim and
sleep longer later, and kswapd records overage that it never handles.

It is also a problem for the next patches, which make kernel threads
queue high_work. The worker charges memory from its own reclaim, so it
can queue itself again. With those patches but not this one, the worker
queued itself in 118 of 284 runs in a VM test with incompressible zswap
data.

Check PF_MEMALLOC before trying the limits. Reclaim charges then skip
memory.high, as they can already go over memory.max. Drop the
PF_MEMALLOC check in memcg_enforce_high(), which no longer sees them.

Other effects:
- As before, the check reads current, so it also catches interrupts on
  a PF_MEMALLOC task such as kswapd. Softirqs set PF_MEMALLOC
  themselves for swap over network, so the check can't be limited to
  task context.
- These charges no longer charge a batch or refill the per-cpu stock.
- MEMCG_MAX still goes to the first cgroup that the charge puts over
  its limit. On cgroup v1, memory.failcnt no longer counts them.
- high_work can still run again and again when there is nothing left
  to reclaim. This only stops reclaim from queuing more reclaim.

Link: https://lore.kernel.org/20261030205418.341214-3-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: Harry Yoo <harry@kernel.org>
---

 mm/memcontrol.c |   29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

--- a/mm/memcontrol.c~memcg-force-charges-from-reclaim-before-trying-the-limits
+++ a/mm/memcontrol.c
@@ -2768,7 +2768,6 @@ static void memcg_enforce_high(struct me
 	 * when it rechecks the overage and simply bail out.
 	 */
 	if (current->memcg_nr_pages_over_high > MEMCG_CHARGE_BATCH &&
-	    !(current->flags & PF_MEMALLOC) &&
 	    gfpflags_allow_blocking(gfp_mask))
 		__mem_cgroup_handle_over_high(gfp_mask);
 }
@@ -2793,6 +2792,21 @@ retry:
 	if (consume_stock(memcg, nr_pages))
 		return ret;
 
+	/*
+	 * Reclaim may need memory to free memory. Let it go over the
+	 * limits for a while rather than fail or OOM kill. Doing this
+	 * before trying the limits also skips memory.high, so the
+	 * high_work worker can't queue itself from its own reclaim.
+	 */
+	if (unlikely(current->flags & PF_MEMALLOC)) {
+		/* Find the cgroup this charge puts over its limit, if any. */
+		for (mem_over_limit = memcg; mem_over_limit;
+		     mem_over_limit = parent_mem_cgroup(mem_over_limit))
+			if (mem_cgroup_margin(mem_over_limit) < nr_pages)
+				break;
+		goto force;
+	}
+
 	if (!allow_spinning)
 		/* Avoid the refill and flush of the older stock */
 		batch = nr_pages;
@@ -2815,15 +2829,6 @@ retry:
 		goto retry;
 	}
 
-	/*
-	 * Prevent unbounded recursion when reclaim operations need to
-	 * allocate memory. This might exceed the limits temporarily,
-	 * but we prefer facilitating memory reclaim and getting back
-	 * under the limit over triggering OOM kills in these cases.
-	 */
-	if (unlikely(current->flags & PF_MEMALLOC))
-		goto force;
-
 	if (unlikely(task_in_memcg_oom(current)))
 		goto nomem;
 
@@ -2919,9 +2924,9 @@ force:
 out:
 	/*
 	 * Don't forget to raise a MEMCG_MAX event for forced or rejected
-	 * requests.
+	 * requests. mem_over_limit is NULL if a PF_MEMALLOC charge fits.
 	 */
-	if (!raised_max_event)
+	if (!raised_max_event && mem_over_limit)
 		__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
 
 	return ret;
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-move-memoryhigh-enforcement-out-of-try_charge_memcg.patch
memcg-force-charges-from-reclaim-before-trying-the-limits.patch
memcg-use-high_work-for-kernel-threads.patch
memcg-use-high_work-for-remote-charges.patch
memcg-simplify-high-limit-handling-after-a-charge.patch

