Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 903A539A061
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439139; cv=none; b=mnvfYAFSSPI5PetIzp1KnQhA0VDmG5d2LOXQ0QRcK49a9M1XyoMlFF0t6ra8hnb+RdxckFxHOCnS30S2bLtYvWNdogU/1jwGiyLSWQD3WpEYyPnHnVx4aBOITW9cS3PB2qC0olcpGgnDRUGRoqIAsK/c5DHsDcKS0hYo+MbTDxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439139; c=relaxed/simple;
	bh=+nyx8UVzzV+heVKX9x5fbEK5G8WiQaxiNqmYQOfGAmY=;
	h=Date:To:From:Subject:Message-Id; b=jmmyIrR76eUf8NNFBMV0Gjn4m82YrffaIOkzCLeBdJQ8zGZjTQOQhLwPp0H9/EA1dUzBeBHlt2xFJt/0W0+CuUCPmRWCjQ+sTwjHdZpXt8Pl9JQf7Nauiy16K6FKdiLlir2xbfjGBpfC+gqR+Q6FLuct7VJIUbfTt6m4LpCp8kI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wxw9MWUb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wxw9MWUb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 655FC1F00898;
	Tue,  2 Jun 2026 22:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439138;
	bh=zthnCVHm7bb3XmeWuwDfgqDWdHnrCi21Lplpv990nxo=;
	h=Date:To:From:Subject;
	b=wxw9MWUbjbMmKkrMvOd3+3YsVOTWF03O5YorLTR6xkT3LdgzgPrYVeXhzJS9mW1Ag
	 fOUIH+ljBd3zjdkPP1pblVmHM3FderLv1XdVyVwR/LMaONyo/Rtov5FYzKryZtjFcz
	 qjduwT07czn3iVu9nGzCcUFHo763aPzOmeeqyt8c=
Date: Tue, 02 Jun 2026 15:25:38 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,d@ilvokhin.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-fix-defrag_mode-for-non-reclaimable-allocations.patch removed from -mm tree
Message-Id: <20260602222538.655FC1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: fix defrag_mode for non-reclaimable allocations
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-fix-defrag_mode-for-non-reclaimable-allocations.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

We observed it on a few of the Meta workloads that adopted
defrag_mode=1.

For the service under load there were 85509 SLUB allocation failures
messages in dmesg within 2 hours.  All of them are GFP_ATOMIC
allocations for skbuff_head_cache, despite free pages being available
in other migratetype freelists (~13 GB free).

Since it is networking path from the practical point of view, this
means dropped packets, failed RPC requests, tail latency spikes and
overall service degradation.

Clear ALLOC_NOFRAGMENT and retry for allocations that request kswapd
reclaim but cannot do direct reclaim themselves (GFP_ATOMIC).  Purely
speculative allocations like GFP_TRANSHUGE_LIGHT that don't set
__GFP_KSWAPD_RECLAIM are left to fail, since they have reasonable
fallbacks and should not cause fragmentation.

Link: https://lore.kernel.org/20260520122228.201550-1-d@ilvokhin.com
Fixes: e3aa7df331bc ("mm: page_alloc: defrag_mode")
Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
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


