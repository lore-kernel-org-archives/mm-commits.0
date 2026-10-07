Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AECC3033EB;
	Wed,  7 Oct 2026 00:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334273; cv=none; b=d954rfCBkdjsU+Hsw5SCZHHVKuyHk6439zMAzqUMIAUnO3dc7I79W14KnJ89o78D7syIaGkN09Rxf93bAKJZPhSXTy0SSCcKcXWZDfU6bUgAqALwL/9cmzokRtXoMqz8oLagMrxrRxQRQ7aTRIAqsglLZoXj0D9oPwj1Dhz867s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334273; c=relaxed/simple;
	bh=nRebXaQGjXgbMxl3PAnfIIP/xjygcSSt0oedEithBGs=;
	h=Date:To:From:Subject:Message-Id; b=pTuO1umiBRi6ng/imV/rT7cr0IMunt9j70Tcn5QcMmIoDWrxs/3OV5jkUEi4LHXV4oJQMf0LIA8eznH0FWwcVbNVb4FFVjYa4bhN+KBov8OIRXqcWA4+sliBktfkAC577bA19oW9abcL36g8CdzCKHSd/Wf65Dn+9+1cn2Ij9iY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iO2cXwz7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iO2cXwz7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F6111F0089C;
	Wed,  7 Oct 2026 00:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334272;
	bh=XFpOPKLXCCm6Ib5+aPbEyd3OlC4TjA7W6JKSt2QEngE=;
	h=Date:To:From:Subject;
	b=iO2cXwz77hIQjt2LAYTj4w6J2adZJF2ivzyFjEi/bPLcapGf87mn3wapHUHHkGA/P
	 O7vDVVrW7FGKRkxLN2SYTRCF2fIXtJBbWUVFNs7VTjStGa+1qICIoI6yCT36shM/2G
	 +bcpmf0hjJLTenREuNSQ94jTK9Q4VTtmbdFQi/xE=
Date: Tue, 06 Oct 2026 17:51:11 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,joe@dama.to,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcontrol-raise-memcg_max-for-charges-that-fail-without-reclaiming.patch removed from -mm tree
Message-Id: <20261007005112.4F6111F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcontrol: raise MEMCG_MAX for charges that fail without reclaiming
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-raise-memcg_max-for-charges-that-fail-without-reclaiming.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joe Damato <joe@dama.to>
Subject: mm: memcontrol: raise MEMCG_MAX for charges that fail without reclaiming
Date: Mon, 31 Aug 2026 10:48:35 -0700

Charges that exceed memory.max and return through the nomem label can
raise no event and simply return -ENOMEM.

A non-blocking charge can hit the limit, get rejected, but is not visible
in memory.events.

This was noticed in a production setting where bpf_mem_alloc() attempted
to refill its per-cpu freelists, which triggered a non-blocking charge
while at the limit.

Commit d6e103a757fa ("mm: memcontrol: do not miss MEMCG_MAX events for
enforced allocations") added raised_max_event to cover charges that are
force charged without ever reaching reclaim, but charges that are rejected
outright were left out.  Getting an allocation failure without the
corresponding MEMCG_MAX event is unexpected and makes debugging and
monitoring harder.

Raise the event on the way out for rejected charges as well, by routing
the -ENOMEM return through the same exit path that already covers forced
charges.  The existing behavior of raising a MEMCG_MAX event on every
charge/reclaim/retry iteration is left unchanged.

Tested with a module that performs accounted GFP_NOWAIT page allocations
from a task in a cgroup at its memory.max, and measures the resulting
memory.events:max delta.  Without this patch the rejected charges raise no
event at all; with it the delta matches the number of rejected charges
exactly.  A GFP_KERNEL|__GFP_NORETRY control, which reaches reclaim,
raises the same two events per failed charge before and after, confirming
the existing charge/reclaim/retry accounting is unchanged.

Link: https://lore.kernel.org/20260831174836.3102406-1-joe@dama.to
Fixes: d6e103a757fa ("mm: memcontrol: do not miss MEMCG_MAX events for enforced allocations")
Signed-off-by: Joe Damato <joe@dama.to>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: <stable@vger.kernel.org>
---

 mm/memcontrol.c |   28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-raise-memcg_max-for-charges-that-fail-without-reclaiming
+++ a/mm/memcontrol.c
@@ -2685,10 +2685,11 @@ static int try_charge_memcg(struct mem_c
 	bool raised_max_event = false;
 	unsigned long pflags;
 	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
+	int ret = 0;
 
 retry:
 	if (consume_stock(memcg, nr_pages))
-		return 0;
+		return ret;
 
 	if (!allow_spinning)
 		/* Avoid the refill and flush of the older stock */
@@ -2799,17 +2800,12 @@ nomem:
 	 * put the burden of reclaim on regular allocation requests
 	 * and let these go through as privileged allocations.
 	 */
-	if (!(gfp_mask & (__GFP_NOFAIL | __GFP_HIGH)))
-		return -ENOMEM;
+	if (!(gfp_mask & (__GFP_NOFAIL | __GFP_HIGH))) {
+		ret = -ENOMEM;
+		goto out;
+	}
 force:
 	/*
-	 * If the allocation has to be enforced, don't forget to raise
-	 * a MEMCG_MAX event.
-	 */
-	if (!raised_max_event)
-		__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
-
-	/*
 	 * The allocation either can't fail or will lead to more memory
 	 * being freed very soon.  Allow memory usage go over the limit
 	 * temporarily by force charging it.
@@ -2818,7 +2814,15 @@ force:
 	if (do_memsw_account())
 		page_counter_charge(&memcg->memsw, nr_pages);
 
-	return 0;
+out:
+	/*
+	 * Don't forget to raise a MEMCG_MAX event for forced or rejected
+	 * requests.
+	 */
+	if (!raised_max_event)
+		__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
+
+	return ret;
 
 done_restock:
 	if (batch > nr_pages)
@@ -2877,7 +2881,7 @@ done_restock:
 	    !(current->flags & PF_MEMALLOC) &&
 	    gfpflags_allow_blocking(gfp_mask))
 		__mem_cgroup_handle_over_high(gfp_mask);
-	return 0;
+	return ret;
 }
 
 static inline int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
_

Patches currently in -mm which might be from joe@dama.to are


