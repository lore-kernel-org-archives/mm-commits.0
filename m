Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB72370D56
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027698; cv=none; b=g1SBid4qON0FVv9MIzo2D8bSnLerMbTwjQOOhgBlQLg1gDZVnZ8zD1S+br+ikz1+DwKoA7LC8dMUny9iKb3R5wKbqRASk+FJVsgNjunnvTXeh1MykwD3SyCDOSSKB6Y8O3ja/i3UpuIFEcQ5/WfrG2q3rhfwL8rEKPfgzIFzdrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027698; c=relaxed/simple;
	bh=iWh0JnPvv2Vhqy2gNl0FAdi16/MZCxYirLRBR0CWkXU=;
	h=Date:To:From:Subject:Message-Id; b=JexShit9JO1DikjdS8NVI6Qsb6LpUwZoRCssRiU9WRIXIsfiTT0e80Qvozh9JSQd7ai0PkPCNY8ZW58OQZdWL9q2GauojeS5zF1OYBYyisvE/UvZ8BkKo6jt+CXU8bkVvq7a2sBRtOVqmlBi53zW619m2SaRETdeay7DpwSKBVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LQyIrnyJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LQyIrnyJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21B461F00893;
	Fri, 29 May 2026 04:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027696;
	bh=qbYh1iad3CVKQWjrmrwKDCxhULHr9wAy58psn9bI6Tc=;
	h=Date:To:From:Subject;
	b=LQyIrnyJVvzWRIJCUG2hSqo/WU1K2sG/jX+n6YOgkBAu2F5PM8hESIlmZt50ZRidM
	 nxtqrVfipD2odFnJ4bKCMM4Az8EPBAxxgmGAkuOMDw4DQrLJYpYYVOsrkTUYdublJF
	 KOAMnJr45o83b3clHVpHR9QHGiDRkPAseFWxt0J4=
Date: Thu, 28 May 2026 21:08:15 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,rostedt@goodmis.org,peterz@infradead.org,mhocko@suse.com,ljs@kernel.org,jackmanb@google.com,hannes@cmpxchg.org,david@kernel.org,d@ilvokhin.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-use-zone-lock-guard-in-free_pcppages_bulk.patch removed from -mm tree
Message-Id: <20260529040816.21B461F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: use zone lock guard in free_pcppages_bulk()
has been removed from the -mm tree.  Its filename was
     mm-use-zone-lock-guard-in-free_pcppages_bulk.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dmitry Ilvokhin <d@ilvokhin.com>
Subject: mm: use zone lock guard in free_pcppages_bulk()
Date: Wed, 29 Apr 2026 12:02:12 +0000

Use spinlock_irqsave zone lock guard in free_pcppages_bulk() to replace
the explicit lock/unlock pattern with automatic scope-based cleanup.

Link: https://lore.kernel.org/aafc2d660057a91eb40417f8ff4645b0a8c525e2.1777462630.git.d@ilvokhin.com
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

 mm/page_alloc.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/mm/page_alloc.c~mm-use-zone-lock-guard-in-free_pcppages_bulk
+++ a/mm/page_alloc.c
@@ -1469,7 +1469,6 @@ static void free_pcppages_bulk(struct zo
 					struct per_cpu_pages *pcp,
 					int pindex)
 {
-	unsigned long flags;
 	unsigned int order;
 	struct page *page;
 
@@ -1482,7 +1481,7 @@ static void free_pcppages_bulk(struct zo
 	/* Ensure requested pindex is drained first. */
 	pindex = pindex - 1;
 
-	spin_lock_irqsave(&zone->lock, flags);
+	guard(spinlock_irqsave)(&zone->lock);
 
 	while (count > 0) {
 		struct list_head *list;
@@ -1514,8 +1513,6 @@ static void free_pcppages_bulk(struct zo
 			trace_mm_page_pcpu_drain(page, order, mt);
 		} while (count > 0 && !list_empty(list));
 	}
-
-	spin_unlock_irqrestore(&zone->lock, flags);
 }
 
 /* Split a multi-block free page into its individual pageblocks. */
_

Patches currently in -mm which might be from d@ilvokhin.com are

mm-page_alloc-fix-defrag_mode-for-non-reclaimable-allocations.patch

