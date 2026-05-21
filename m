Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A173B4E9E
	for <mm-commits@vger.kernel.org>; Thu, 21 May 2026 23:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779407828; cv=none; b=pyAde0NcPXELFB0p40h1EoAMAOHQjoJySwE/KcB/iRoqWFs8SQbP0iLtEg1u3s7NGFNm9LrKDKmHAu4k1JAuyxS/BCRB3/TYRxfg4R6Z82OBJgbnTTvU2QARKg0o+86+dYDlKCqt9prli0DLHDG25POMWsRl8jSgqu6Bir2QixE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779407828; c=relaxed/simple;
	bh=aTw+chJvD/olnLs06yIxO3pNlIbmd/dbxIh1zqsXBPQ=;
	h=Date:To:From:Subject:Message-Id; b=FgRh6M8BtdY2FhgZe236+yIvOQVB3bWCwXnpc4EmGyvQ1ieEk/LBv5XvZIF7kMSPyLEExT2GXT7j1+yqtR9O6JMwYgxTO/lnGcKDExTEjjLx74LCftmnaJDUWpBCgYL0hpEiP5GNJ2FCD1ijcBoG8dMu4OVy9UdLB44GE4wo5xA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=L8fbgPI8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="L8fbgPI8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FF231F000E9;
	Thu, 21 May 2026 23:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779407820;
	bh=Xmq9C5GtyBtez17OTkhXGDCZ50d98WN7kLp13e5RmPY=;
	h=Date:To:From:Subject;
	b=L8fbgPI8mQMwafmBKenf5mmsSfjfDHMEQHN0zyOQOVoAQYo9Mi0r6QzYm0iorGl2f
	 rY6vvxXKsoHG1+zqk91ytwuqpbheIcKN9hnZVAgfRapvKHJfGIASGIh6WMBTlHUFvH
	 fSm1WFv9gg0Nf4xN1vMrBoz9KqKMSuRLEAwfaHrY=
Date: Thu, 21 May 2026 16:57:00 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,d@ilvokhin.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-page_alloc-fix-defrag_mode-for-non-reclaimable-allocations.patch removed from -mm tree
Message-Id: <20260521235700.7FF231F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: fix defrag_mode for non-reclaimable allocations
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-fix-defrag_mode-for-non-reclaimable-allocations.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Dmitry Ilvokhin <d@ilvokhin.com>
Subject: mm/page_alloc: fix defrag_mode for non-reclaimable allocations
Date: Mon, 18 May 2026 16:37:36 +0000

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

Clear ALLOC_NOFRAGMENT and retry before giving up on allocations that
cannot reclaim, following the same pattern used after reclaim/compaction
exhaustion later in the slowpath.

Link: https://lore.kernel.org/20260518163736.173910-1-d@ilvokhin.com
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

 mm/page_alloc.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-fix-defrag_mode-for-non-reclaimable-allocations
+++ a/mm/page_alloc.c
@@ -4853,8 +4853,18 @@ retry:
 	}
 
 	/* Caller is not willing to reclaim, we can't balance anything */
-	if (!can_direct_reclaim)
+	if (!can_direct_reclaim) {
+		/*
+		 * Reclaim/compaction cannot run, so defrag_mode's strategy
+		 * of enforcing ALLOC_NOFRAGMENT cannot be fulfilled. Allow
+		 * fallbacks rather than failing the allocation outright.
+		 */
+		if (defrag_mode && (alloc_flags & ALLOC_NOFRAGMENT)) {
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

