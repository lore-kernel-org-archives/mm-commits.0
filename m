Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF893C1F51
	for <mm-commits@vger.kernel.org>; Thu, 21 May 2026 23:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779407960; cv=none; b=GKiHFOozRUZt9wMcnashJtrY5SYSZk18g9c/haINoiBRAZreyrlnXW9wMbp6esQKfLskU6Gd873QwLOWi5iS+LbTnQ318H40/ZemhSzOZUaV16YLBHDGn2LpyE5M+OXL8Rjps/kMUHETJMTMNxFrxHvfgIf3sVI48CWQRQRBzIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779407960; c=relaxed/simple;
	bh=sUz1MNxeRX5+cMpYPr5Uenpko0V6dkHg7awHbm+wLIM=;
	h=Date:To:From:Subject:Message-Id; b=jqPikzoiWA2OomC/MNebVJCddaAM6u6Hollxpq+OvbqcGNVLnHwnqtzqWYhgUUgmlkJHprRJP1PrOxW/gzTpHoaJ1GP88LUbIncfD9GsiMVdHoJf7V8ZWCHogVv1eh9va4q2kZqzvmZRtjQoZMdPAeDSQ21U0aPoPAt2seS3A1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=y5Wwda2K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="y5Wwda2K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 796771F000E9;
	Thu, 21 May 2026 23:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779407957;
	bh=VZs+5vKdzqyDkIkvY/Y2I5UtkHNIwuBeYEKJJBukweA=;
	h=Date:To:From:Subject;
	b=y5Wwda2KU3LuNNT7wLiWiCNB+YZkQUOpWAm2sJjCCPPYzL7WZZQmon55nahBnO/Rq
	 FRVUaKrzEf5R1yL43C11CuN/Iyoo8uvJc8FIn6iBz8eCOGOxGx+/54z7QyRnstV1gv
	 3FXP00vtY9jCPa3sXIrmxZg8B3tgSWLKT6vvdFyM=
Date: Thu, 21 May 2026 16:59:17 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,d@ilvokhin.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-fix-defrag_mode-for-non-reclaimable-allocations.patch added to mm-new branch
Message-Id: <20260521235917.796771F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: fix defrag_mode for non-reclaimable allocations
has been added to the -mm mm-new branch.  Its filename is
     mm-page_alloc-fix-defrag_mode-for-non-reclaimable-allocations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-fix-defrag_mode-for-non-reclaimable-allocations.patch

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
From: Dmitry Ilvokhin <d@ilvokhin.com>
Subject: mm/page_alloc: fix defrag_mode for non-reclaimable allocations
Date: Wed, 20 May 2026 12:22:28 +0000

When defrag_mode is enabled, ALLOC_NOFRAGMENT is enforced to prevent
migratetype fallbacks and keep pageblocks clean.  The allocator relies on
reclaim and compaction to free pages of the correct type before allowing
fallback as a last resort.

However, non-reclaimable allocations such as GFP_ATOMIC cannot invoke
direct reclaim or compaction.  With defrag_mode=1, these allocations hit
the !can_direct_reclaim bailout in __alloc_pages_slowpath() with
ALLOC_NOFRAGMENT still set, and fail without ever attempting a fallback.

This causes a large number of SLUB allocation failures for
skbuff_head_cache under network-heavy workloads, despite free memory being
available in other migratetype freelists.

Clear ALLOC_NOFRAGMENT and retry for allocations that request kswapd
reclaim but cannot do direct reclaim themselves (GFP_ATOMIC).  Purely
speculative allocations like GFP_TRANSHUGE_LIGHT that don't set
__GFP_KSWAPD_RECLAIM are left to fail, since they have reasonable
fallbacks and should not cause fragmentation.

Link: https://lore.kernel.org/20260520122228.201550-1-d@ilvokhin.com
Fixes: e3aa7df331bc ("mm: page_alloc: defrag_mode")
Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-fix-defrag_mode-for-non-reclaimable-allocations
+++ a/mm/page_alloc.c
@@ -4853,8 +4853,19 @@ retry:
 	}
 
 	/* Caller is not willing to reclaim, we can't balance anything */
-	if (!can_direct_reclaim)
+	if (!can_direct_reclaim) {
+		/*
+		 * Reclaim/compaction cannot run, so defrag_mode's strategy
+		 * of enforcing ALLOC_NOFRAGMENT cannot be fulfilled. Allow
+		 * fallbacks rather than failing the allocation outright.
+		 */
+		if (defrag_mode && (alloc_flags & ALLOC_NOFRAGMENT) &&
+		    (gfp_mask & __GFP_KSWAPD_RECLAIM)) {
+			alloc_flags &= ~ALLOC_NOFRAGMENT;
+			goto retry;
+		}
 		goto nopage;
+	}
 
 	/* Avoid recursion of direct reclaim */
 	if (current->flags & PF_MEMALLOC)
_

Patches currently in -mm which might be from d@ilvokhin.com are

mm-use-zone-lock-guard-in-reserve_highatomic_pageblock.patch
mm-use-zone-lock-guard-in-unset_migratetype_isolate.patch
mm-use-zone-lock-guard-in-unreserve_highatomic_pageblock.patch
mm-use-zone-lock-guard-in-set_migratetype_isolate.patch
mm-use-zone-lock-guard-in-take_page_off_buddy.patch
mm-use-zone-lock-guard-in-put_page_back_buddy.patch
mm-use-zone-lock-guard-in-free_pcppages_bulk.patch
mm-use-zone-lock-guard-in-__offline_isolated_pages.patch
mm-page_alloc-fix-defrag_mode-for-non-reclaimable-allocations.patch

