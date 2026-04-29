Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9DC3803C1
	for <mm-commits@vger.kernel.org>; Wed, 29 Apr 2026 15:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777477067; cv=none; b=sMtSEfxy5K5F6TI/ViUR049QE5ZLPIcTSeChKTLW4bMkW1zMHJJAzY6fv4k9q2P1wmmNUlh8XdzCZrKyABKgVXrzjxrzK+Z3qoK6FY6aDN1qmSP37MxxaXxU7Kc9vLR2yAYWC7HCLE6A4Bo2NWxaK4TdkthzVHPsenGWxH7CcLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777477067; c=relaxed/simple;
	bh=/zJbg5W+P+RhyhY5IWAnBhYExEr1xgRZc5Pri0hwoPU=;
	h=Date:To:From:Subject:Message-Id; b=bZf14l6xC4L3zN60ZuHZKpIBRSyxC6FxvCFLXjVg4zGqcGrmgKJFHYmcHznO/XWuGpEye9OepP0zs2BHqjEvrzq5de3etiPHi3zi+htLtSW5pOGAkbU4znEjFq0L3IniQtInU95Cyz12qmpt7nEm5AZTW7AeoCAz3/5GopxRpuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xKellvIH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xKellvIH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7387FC19425;
	Wed, 29 Apr 2026 15:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777477067;
	bh=/zJbg5W+P+RhyhY5IWAnBhYExEr1xgRZc5Pri0hwoPU=;
	h=Date:To:From:Subject:From;
	b=xKellvIH2PYSdarSsUQG70o+/nvkmmVvYLhpVRY1YY4RyjScrqs3E5eX+ycRP+zbm
	 n/2fWOHqbbKhOMMNf3bFdG+e/CzozYCeuuACHnwGfBuvEWThKL464NdvO5PXdcg5XK
	 1zyfVZyzka2OgxghwVuSyzOE4pAbYDYFQi9YRKnE=
Date: Wed, 29 Apr 2026 08:37:46 -0700
To: mm-commits@vger.kernel.org,d@ilvokhin.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-zone-lock-guard-in-unset_migratetype_isolate.patch added to mm-new branch
Message-Id: <20260429153747.7387FC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: use zone lock guard in unset_migratetype_isolate()
has been added to the -mm mm-new branch.  Its filename is
     mm-use-zone-lock-guard-in-unset_migratetype_isolate.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-zone-lock-guard-in-unset_migratetype_isolate.patch

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
Subject: mm: use zone lock guard in unset_migratetype_isolate()
Date: Wed, 29 Apr 2026 12:02:07 +0000

Use spinlock_irqsave zone lock guard in unset_migratetype_isolate() to
replace the explicit lock/unlock and goto pattern with automatic
scope-based cleanup.

Link: https://lore.kernel.org/815c0905ea77828ed32bf56ff0a6d3c6548eb3a2.1777462630.git.d@ilvokhin.com
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

 mm/page_isolation.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/mm/page_isolation.c~mm-use-zone-lock-guard-in-unset_migratetype_isolate
+++ a/mm/page_isolation.c
@@ -223,15 +223,14 @@ static int set_migratetype_isolate(struc
 static void unset_migratetype_isolate(struct page *page)
 {
 	struct zone *zone;
-	unsigned long flags;
 	bool isolated_page = false;
 	unsigned int order;
 	struct page *buddy;
 
 	zone = page_zone(page);
-	spin_lock_irqsave(&zone->lock, flags);
+	guard(spinlock_irqsave)(&zone->lock);
 	if (!is_migrate_isolate_page(page))
-		goto out;
+		return;
 
 	/*
 	 * Because freepage with more than pageblock_order on isolated
@@ -279,8 +278,6 @@ static void unset_migratetype_isolate(st
 		__putback_isolated_page(page, order, get_pageblock_migratetype(page));
 	}
 	zone->nr_isolate_pageblock--;
-out:
-	spin_unlock_irqrestore(&zone->lock, flags);
 }
 
 static inline struct page *
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

