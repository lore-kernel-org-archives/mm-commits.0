Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792686557;
	b=JcbyL9XT3Yk/LpJQRRE5VXM09KpAGoxDOu9ZJte1HroJzA5ZwXr3pd2y+wxtmTbiWZN0
	 OcmSapBlB5Mk2eVA9sQPWM5nOmoxm7txTs7wuhCqTVBVx0mlzHj9Y4NzBGQp2y6lqRFNl
	 9YJ2GhmrC08HMLZVZ6nKFNWcdjPtYlr9OwoY9zJ41JmhdMXX1D4SUB7b3QhtAoxcnqGrL
	 +Nmq7/ssgZAYMnIEWhtm9CGLtktBjGg3Y0BIHIrTUB8lnM6u55vRNq6loybx117v/g+H1
	 rpKxvJ4yJ24isgm/5OKKyShhiA63OO3pRke0Eq+zyDDOa/xb3PYPcfZiCG/nMlwt44g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792686557;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=6Y88e0fm35ALMdB2gfORHdp/q5/TqSMv6cCitR5H620=;
	b=l3ddvLuaU090LibohpxvgW0q+/2nfkoVxlYIKwFNXXCw1RzRly8UB14MdK70i4ptLrxD
	 fwidcrkpWtBZ/6Z7suYhKEZ6Yf5ylxacX7UD40XxGnzvQYs0nW4KrJFRAfTlNm/bh6lhB
	 8TQSU7Sqj4pPqdQVrrH40SOMpfo4LJ4QY5h/KGIysd8scgj5lZb6w2RSU5h/h4btN1mkq
	 5d8uEc9VD/ky4RM3hXx8mEYjHpnTWlE4S6DRHYhtGHB96bvS0JmJgKzC6bngNo0IPX2R3
	 n6qwztOzU31eXrJGeyg2ppKhIOBH/SUBfoua9UlksCivhvO8rG/Sqi5jpK1zMsPmhqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=MpsG4hNT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5432F606A31D;
	Thu, 22 Oct 2026 16:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=MpsG4hNT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC4C11F01828;
	Thu, 22 Oct 2026 16:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792686557;
	bh=6Y88e0fm35ALMdB2gfORHdp/q5/TqSMv6cCitR5H620=;
	h=Date:To:From:Subject;
	b=MpsG4hNTn2JvYXsgFKEZlb+VOFBRjYRjM6vv9GR75HM9MG2djIV95R4MCNnXXxCwd
	 BdpEojVgY23DmKBvf+qFDTNf9PLdb7dzmEvr0ekzO6iD6aZm4kF+oO8g0V40d/o7Xc
	 1c1tiaYG6wpWQxYvL3QU79GvVdoogKd2YOXMuVeU=
Date: Thu, 22 Oct 2026 09:29:16 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,mhocko@suse.com,hannes@cmpxchg.org,flyinrm@gmail.com,brendan.jackman@linux.dev,gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-let-the-highest-memory-node-recover-from-hopeless-state.patch added to mm-unstable branch
Message-Id: <20261022162916.EC4C11F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/page_alloc: let the highest memory node recover from hopeless state
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-let-the-highest-memory-node-recover-from-hopeless-state.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-let-the-highest-memory-node-recover-from-hopeless-state.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-damon-use-damon_get_monitor_folio-for-hugetlb-entries.patch
mm-vmscan-reclaim-every-zone-in-per-node-proactive-reclaim.patch
mm-mempolicy-apply-bind-policies-against-the-scoped-allocation-zone.patch
mm-page_alloc-let-the-highest-memory-node-recover-from-hopeless-state.patch

