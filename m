Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48B5A370AF8
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027690; cv=none; b=aCw9Cu2O4z4VlVm5isIAyMk2y4CXXuX92Q850/+UH1kVxJ4xJ3zSzu2ciYq/B9t87KvjHkbyoVMDUV8NDqRIHEujasZZ8/xMs5EkIN7KizMkznLcACS6G1YtFmz0//oehvznq1sm8pnmmWOPuZuFbqhEkKT6hxMd8Qb96bCl4tY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027690; c=relaxed/simple;
	bh=upKTYAms3bDS7X5aj9CItmNXIsPADOlfFdBZZoWZRLQ=;
	h=Date:To:From:Subject:Message-Id; b=BsNUqhEJuUnRb+s5mxwpUF3V6c2Ph8iWGt8nFZZwQ/rASwwB02QQvkSCY/Npsn2rlY3w9di5haiqqqPkIgB2RwmviVRTyuSNo4OpnaBaUT0cfCT+c8JlOpJmZEf/+LcLi3kiYB0/MrquhYdyOf+WiPrXQUBpjlppEZHVQpq1l8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ytd2E5M9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ytd2E5M9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C6D21F00893;
	Fri, 29 May 2026 04:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027689;
	bh=sUEsEsp60Ks76WiL4IGSa1NcTJBUK4TzoMbIjNAiJ3Q=;
	h=Date:To:From:Subject;
	b=Ytd2E5M9Cb6+F2vaavye8tnac5UhySju0VUGIQwnkJ7ettRFyvh0A0TONGcEr6up5
	 TaYq+jac4lgZko/zejfamK9NdB4zgMe8sdTOJH2TGWB2aY4WU8nWjOPRcJBelhCIDx
	 9+ngiUl1LnJli9T6dmzJqX7HoY1J+VCDwQ5XjuOc=
Date: Thu, 28 May 2026 21:08:08 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,rostedt@goodmis.org,peterz@infradead.org,mhocko@suse.com,ljs@kernel.org,jackmanb@google.com,hannes@cmpxchg.org,david@kernel.org,d@ilvokhin.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-use-zone-lock-guard-in-reserve_highatomic_pageblock.patch removed from -mm tree
Message-Id: <20260529040809.1C6D21F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: use zone lock guard in reserve_highatomic_pageblock()
has been removed from the -mm tree.  Its filename was
     mm-use-zone-lock-guard-in-reserve_highatomic_pageblock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dmitry Ilvokhin <d@ilvokhin.com>
Subject: mm: use zone lock guard in reserve_highatomic_pageblock()
Date: Wed, 29 Apr 2026 12:02:06 +0000

Patch series "mm: use spinlock guards for zone lock", v3.

This series uses spinlock guard for zone lock across several mm functions
to replace explicit lock/unlock patterns with automatic scope-based
cleanup.

This simplifies the control flow by removing 'flags' variables, goto
labels, and redundant unlock calls.

Patches are ordered by decreasing value.  The first six patches simplify
the control flow by removing gotos, multiple unlock paths, or 'ret'
variables.  The last two are simpler lock/unlock pair conversions that
only remove 'flags' and can be dropped if considered unnecessary churn.

Binary size increase is +39 bytes, with Peter Zijlstra's fix for guards
[1] applied.  This is due to the compiler not being able to deduplicate
epilogue and eliminate redundant NULL check.  See discussion [2] for more
details.  I proposed a patch [3] that fixes this, but until it is merged
we need to assume +39 bytes will stay (though it is compiler dependent).


This patch (of 8):

Use the spinlock_irqsave zone lock guard in reserve_highatomic_pageblock()
to replace the explicit lock/unlock and goto out_unlock pattern with
automatic scope-based cleanup.

Link: https://lore.kernel.org/cover.1777462630.git.d@ilvokhin.com
Link: https://lore.kernel.org/3657e1144e2ffc1ca0eb57d57d89bfec4073d8c6.1777462630.git.d@ilvokhin.com
Link: https://lore.kernel.org/all/20260309164516.GE606826@noisy.programming.kicks-ass.net/ [1]
Link: https://lore.kernel.org/all/afC5C6fylF4AsITV@shell.ilvokhin.com/ [2]
Link: https://lore.kernel.org/all/20260427165037.205337-1-d@ilvokhin.com/ [3]
Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/mm/page_alloc.c~mm-use-zone-lock-guard-in-reserve_highatomic_pageblock
+++ a/mm/page_alloc.c
@@ -3442,7 +3442,7 @@ static void reserve_highatomic_pageblock
 					 struct zone *zone)
 {
 	int mt;
-	unsigned long max_managed, flags;
+	unsigned long max_managed;
 
 	/*
 	 * The number reserved as: minimum is 1 pageblock, maximum is
@@ -3456,29 +3456,26 @@ static void reserve_highatomic_pageblock
 	if (zone->nr_reserved_highatomic >= max_managed)
 		return;
 
-	spin_lock_irqsave(&zone->lock, flags);
+	guard(spinlock_irqsave)(&zone->lock);
 
 	/* Recheck the nr_reserved_highatomic limit under the lock */
 	if (zone->nr_reserved_highatomic >= max_managed)
-		goto out_unlock;
+		return;
 
 	/* Yoink! */
 	mt = get_pageblock_migratetype(page);
 	/* Only reserve normal pageblocks (i.e., they can merge with others) */
 	if (!migratetype_is_mergeable(mt))
-		goto out_unlock;
+		return;
 
 	if (order < pageblock_order) {
 		if (move_freepages_block(zone, page, mt, MIGRATE_HIGHATOMIC) == -1)
-			goto out_unlock;
+			return;
 		zone->nr_reserved_highatomic += pageblock_nr_pages;
 	} else {
 		change_pageblock_range(page, order, MIGRATE_HIGHATOMIC);
 		zone->nr_reserved_highatomic += 1 << order;
 	}
-
-out_unlock:
-	spin_unlock_irqrestore(&zone->lock, flags);
 }
 
 /*
_

Patches currently in -mm which might be from d@ilvokhin.com are

mm-page_alloc-fix-defrag_mode-for-non-reclaimable-allocations.patch

