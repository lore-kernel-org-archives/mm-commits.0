Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793672124;
	b=sLmGnEDYdQcoJY/55INCCre+1E+63xbX5BNRQ6v7/StaSXzcTIAOazhjRkqQO3iRue75
	 mWYX313w9oLAObg3M1UuZM6oeSsYMDSYjAWK1vvcHudXVkv02UOHxDludeIUEwopR6+Pg
	 8BpjiSCuAM01GitXSJPi4aYjfNSHPFir7J5CjCJefT57l6mt4jyoH8MCUS5rLD9AfIqBw
	 2OzFiRNdWD8v/Z3xJZYlQhnRl2IJ+4Srl0jJkSkbzHkZFyVz8PTrs97sZ3Micl/TTyPtt
	 9PVljkEHZ7nQ5jGVU4dTFwHlXie8AP1ylklvYR2gUVPnyTyb0rZebrvXvrXlTwSxHog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793672124;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=neVt8XK40l5Spl2SLbYgOLOq4vMo7oZBDGOXGzyxpzA=;
	b=LDn+D0EtEPVq7jY0+n6F+7ZHF5F+ma+X2VvFK2nw1viLR8KvQCOORJC6ZAK1cvWbHzbH
	 hIRL67IhuKy2U1usZesqyDePQVRA2z+lwZu+GsOfnPSrQCcgFHH7kv2pU/Wtj13dP5iLF
	 yK5qMz37dhb7qHiAJwlnCfAK01y0ITFsd4iPNRa8l407KC6ppwfHMr7TMfuQDlZ6Vfj5I
	 huiQlq6oW1BWyIPBDNk4xWgQUseud1+eJRUm26oP3k7dJQA/1w6N9iVkQySwl2j5QRZ+u
	 GCbpUFXXt1OGpBNivt1/nRLGL+gYrpp2ePDYrg+3LpGdbKAcB9bnvIFerPsL59t8Dkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=n1zphTnq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B66606D803;
	Tue,  3 Nov 2026 02:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=n1zphTnq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44BF71F00A1C;
	Tue,  3 Nov 2026 02:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793672124;
	bh=neVt8XK40l5Spl2SLbYgOLOq4vMo7oZBDGOXGzyxpzA=;
	h=Date:To:From:Subject;
	b=n1zphTnq/6bO96Fy9uHpCnKgW947XM1eYmhG5HyIwm7C3YnqONVHqJpfsvFWPvd68
	 COVmuZYuN9857y3TvGTCOW81Vcznw/clmqc4v364rDjC4iDmMiGxNXAzdoCcwfX0tm
	 2yRN8aQC8WzJtY4ywv49lIXrtcrRM1dC5IOF0SSE=
Date: Mon, 02 Nov 2026 18:15:23 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,
	surenb@google.com,stable@vger.kernel.org,mhocko@suse.com,hannes@cmpxchg.org,
	flyinrm@gmail.com,brendan.jackman@linux.dev,gourry@gourry.net,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-page_alloc-let-the-highest-memory-node-recover-from-hopeless-state.patch removed from -mm tree
Message-Id: <20261103021524.44BF71F00A1C@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/page_alloc: let the highest memory node recover from hopeless state
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-let-the-highest-memory-node-recover-from-hopeless-state.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Gregory Price (Meta)" <gourry@gourry.net>
Subject: mm/page_alloc: let the highest memory node recover from hopeless state
Date: Mon, 19 Oct 2026 14:48:50 -0400

free_frozen_page_commit() clears a hopeless node's kswapd failures once
its zone recovers above the high watermark, but only if another memory
node exists for allocations to fall back to.

The test `next_memory_node(nid) < MAX_NUMNODES` finds only memory nodes
with a higher id.  The highest-numbered memory node therefore never
recovers on this path, and its kswapd stays disabled until reclaim on that
node makes progress and balances it, or demotion is re-enabled.

In many cases, direct reclaim many never fully run against a lower node
(CXL/kmem), and that means its kswapd can end up full disabled in rare
situations.

To reproduce, fill the highest memory node with bound, non-THP anonymous
memory and no swap until kswapd gives up, then free it: /proc/zoneinfo
keeps showing node_unreclaimable 1 for that node.  A lower node recovers.

Count the memory nodes instead.  Adding first_memory_node != nid to the
existing test would also work, but a count says directly what the check
means: some other memory node exists.

Link: https://lore.kernel.org/20261019184850.3427905-1-gourry@gourry.net
Fixes: e7a5f249e6db ("mm: re-enable kswapd when memory pressure subsides or demotion is toggled")
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Chanwon Park <flyinrm@gmail.com>
Cc: <stable@vger.kernel.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-let-the-highest-memory-node-recover-from-hopeless-state
+++ a/mm/page_alloc.c
@@ -2929,7 +2929,7 @@ static bool free_frozen_page_commit(stru
 		 * kswapd work again by resetting kswapd_failures.
 		 */
 		if (kswapd_test_hopeless(pgdat) &&
-		    next_memory_node(pgdat->node_id) < MAX_NUMNODES)
+		    num_node_state(N_MEMORY) > 1)
 			kswapd_clear_hopeless(pgdat, KSWAPD_CLEAR_HOPELESS_PCP);
 	}
 	return ret;
_

Patches currently in -mm which might be from gourry@gourry.net are

mm-mempolicy-recompute-automatic-interleave-weights-on-memory-hotplug.patch
mm-memory-tiers-reset-demotion-targets-of-nodes-without-memory.patch
mm-mempolicy-convert-mempolicy-refcnt-to-refcount_t.patch
selftests-mm-add-madv_cold-and-madv_pageout-contract-tests.patch
selftests-mm-check-madv_cold-and-madv_pageout-range-handling.patch
selftests-mm-check-that-madv_cold-and-madv_pageout-reject-hugetlb.patch
selftests-mm-check-that-madv_cold-and-madv_pageout-preserve-shared-memory.patch
selftests-mm-check-madv_cold-and-madv_pageout-on-partly-advised-thps.patch
selftests-mm-check-madv_pageout-file-permissions.patch
selftests-mm-check-that-unauthorized-madv_pageout-skips-large-file-folios.patch

