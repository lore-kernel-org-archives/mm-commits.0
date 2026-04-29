Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1ACF344D80
	for <mm-commits@vger.kernel.org>; Wed, 29 Apr 2026 15:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777477065; cv=none; b=ie3QhdyQ+dEo3KHlHowKXYIXEVSuR0yvl+rHRao87kcOSn3eP52zWD0kMyPZhJo8R3HBYxmSmyU8cp/6hq1ZRhEaSPKU+aHpLPqMcENMxI5lRut7XLK3soB73/b0H3UuYNbhlEWjvkKDmGQquth7jQkDOcY5bp0R4OCN9TSudXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777477065; c=relaxed/simple;
	bh=QvjQaf5yULalvzjasXhrtxJpj9DhSwRfwsAINSqpC04=;
	h=Date:To:From:Subject:Message-Id; b=SN2W4AlRBxBsCfDwsCLu91BIVsQIi74RqZ0GULAYGGFjEjubXcYEA6v/Mdqep0qmQukTWHuSNUOvTsKjCzmyMLs9Hae6bXldsRMNwxz0oH1GELWNEwz1uslhXQgOzyWXq2et741JkfAgjPxQhwIEegGkgiS/Ljb/01Frp5Mu55Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Vu4uGnuQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Vu4uGnuQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DAB0C19425;
	Wed, 29 Apr 2026 15:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777477065;
	bh=QvjQaf5yULalvzjasXhrtxJpj9DhSwRfwsAINSqpC04=;
	h=Date:To:From:Subject:From;
	b=Vu4uGnuQTO1sii4UjjPmDvoN9ItLRRK+P4rqMrhhU8rS5LQW8TyhwleSPBAOenvqX
	 qkl2tPuQnPXb+wcN02Q/n/YLAh7p5zqUF7rjBB1hXagz4J1WTCDxuNtUEcauTQ6Dx5
	 WcbjfBXxWnMiSli2NjCJ22c5a+GWwn1sl5dumesY=
Date: Wed, 29 Apr 2026 08:37:44 -0700
To: mm-commits@vger.kernel.org,d@ilvokhin.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-zone-lock-guard-in-reserve_highatomic_pageblock.patch added to mm-new branch
Message-Id: <20260429153745.4DAB0C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: use zone lock guard in reserve_highatomic_pageblock()
has been added to the -mm mm-new branch.  Its filename is
     mm-use-zone-lock-guard-in-reserve_highatomic_pageblock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-zone-lock-guard-in-reserve_highatomic_pageblock.patch

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
@@ -3432,7 +3432,7 @@ static void reserve_highatomic_pageblock
 					 struct zone *zone)
 {
 	int mt;
-	unsigned long max_managed, flags;
+	unsigned long max_managed;
 
 	/*
 	 * The number reserved as: minimum is 1 pageblock, maximum is
@@ -3446,29 +3446,26 @@ static void reserve_highatomic_pageblock
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

mm-use-zone-lock-guard-in-reserve_highatomic_pageblock.patch
mm-use-zone-lock-guard-in-unset_migratetype_isolate.patch
mm-use-zone-lock-guard-in-unreserve_highatomic_pageblock.patch
mm-use-zone-lock-guard-in-set_migratetype_isolate.patch
mm-use-zone-lock-guard-in-take_page_off_buddy.patch
mm-use-zone-lock-guard-in-put_page_back_buddy.patch
mm-use-zone-lock-guard-in-free_pcppages_bulk.patch
mm-use-zone-lock-guard-in-__offline_isolated_pages.patch

