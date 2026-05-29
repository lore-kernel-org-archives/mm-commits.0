Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E411370D56
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027692; cv=none; b=Ae+qGTBuoncqx+fVpT1VdXtoO3RR1M4UWF1fW8PWUS41aI67RVfsGdN+5Rkgstg+rjhN0ySZl4H6KmUu4bvs9jHB24bu73YgD22nlUVGsBArvFoiTwuu/nrk/xVr4FW1bquBgoJl3Vrc8Tdeij8XmWuU/xdMYDXhIfu0sGNMTEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027692; c=relaxed/simple;
	bh=Y9/ZGC2PU5eNoyxUewMkgvNtf8pPHUTWzuXakY1tkt4=;
	h=Date:To:From:Subject:Message-Id; b=HUllrkOuNCuEu3kQGo9rRELYh6DtX30PwSq47yZW9KN00iwCjA8ir/UkxqVv95dAFvyfjNFV3XdB7dVlrDYtw4PHUCTyh0hkfxwkGv52ITT9gQ8zLgO+TtsuC7aChfGz4BteZ8VPMA9/kkFoTpXjWKcTjM8SlkKN6j6LIX/yBXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hNIrqyNq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hNIrqyNq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 727BD1F00893;
	Fri, 29 May 2026 04:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027691;
	bh=SDHnF5DrmSBKE/qrlGJdw0XPe9NNRW7ZlQbompJfxZg=;
	h=Date:To:From:Subject;
	b=hNIrqyNqRAsV9k50I2KxCNVcbD+oKaIINLnf/5YfsCPrYvh6XjgVfb00H6oBitVH9
	 jIqhBu4MPVw5R8M8pZwlRa82KjmzFQGXAp8Xp1UHYBCJ6S28mdH0GIBcB3bTpggbIs
	 AMqzxODdXO8PlMtk+KDAwVln/pP5Z4zwVUUav6OA=
Date: Thu, 28 May 2026 21:08:11 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,rostedt@goodmis.org,peterz@infradead.org,mhocko@suse.com,ljs@kernel.org,jackmanb@google.com,hannes@cmpxchg.org,david@kernel.org,d@ilvokhin.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-use-zone-lock-guard-in-unreserve_highatomic_pageblock.patch removed from -mm tree
Message-Id: <20260529040811.727BD1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: use zone lock guard in unreserve_highatomic_pageblock()
has been removed from the -mm tree.  Its filename was
     mm-use-zone-lock-guard-in-unreserve_highatomic_pageblock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dmitry Ilvokhin <d@ilvokhin.com>
Subject: mm: use zone lock guard in unreserve_highatomic_pageblock()
Date: Wed, 29 Apr 2026 12:02:08 +0000

Use spinlock_irqsave zone lock guard in unreserve_highatomic_pageblock()
to replace the explicit lock/unlock pattern with automatic scope-based
cleanup.

Link: https://lore.kernel.org/69db814cd178915cb5615334a29304678f960963.1777462630.git.d@ilvokhin.com
Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/mm/page_alloc.c~mm-use-zone-lock-guard-in-unreserve_highatomic_pageblock
+++ a/mm/page_alloc.c
@@ -3491,7 +3491,6 @@ static bool unreserve_highatomic_pageblo
 						bool force)
 {
 	struct zonelist *zonelist = ac->zonelist;
-	unsigned long flags;
 	struct zoneref *z;
 	struct zone *zone;
 	struct page *page;
@@ -3508,7 +3507,7 @@ static bool unreserve_highatomic_pageblo
 					pageblock_nr_pages)
 			continue;
 
-		spin_lock_irqsave(&zone->lock, flags);
+		guard(spinlock_irqsave)(&zone->lock);
 		for (order = 0; order < NR_PAGE_ORDERS; order++) {
 			struct free_area *area = &(zone->free_area[order]);
 			unsigned long size;
@@ -3555,12 +3554,9 @@ static bool unreserve_highatomic_pageblo
 			 * so this should not fail on zone boundaries.
 			 */
 			WARN_ON_ONCE(ret == -1);
-			if (ret > 0) {
-				spin_unlock_irqrestore(&zone->lock, flags);
+			if (ret > 0)
 				return ret;
-			}
 		}
-		spin_unlock_irqrestore(&zone->lock, flags);
 	}
 
 	return false;
_

Patches currently in -mm which might be from d@ilvokhin.com are

mm-page_alloc-fix-defrag_mode-for-non-reclaimable-allocations.patch

