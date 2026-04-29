Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 761523803DD
	for <mm-commits@vger.kernel.org>; Wed, 29 Apr 2026 15:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777477078; cv=none; b=gNXgJuzLqRhfpoDlqoEz5H8VlFDftM4HbE6UXZmR9rmP0V9g5He5PfOOAwGAaN6QExZVQkgYs+/sk6YWPEp2hA4yawM8SrPLEbQi5eO1nYo9fwEz1NFNDrcbIUz2xLCUO+rIiqQPfOv4dRWd43pFCgKh8/6pGTHqkue5vJ8e+Kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777477078; c=relaxed/simple;
	bh=XYBb24cIbNymn0MM/PwcbElsgqtu7JzpbJn2AtEdVjw=;
	h=Date:To:From:Subject:Message-Id; b=LB91v3k9fkrOi9Mrxtaf4n7IB/a9PjBD/55MyQsIVhfFMObx9Z0wjgIQ4zTWMv8bOzV1YZJDIJlL1FkRpfVXB1U779sNaMBcneY1MOq4984l5KV8qnkj8zKqX3G5gDGpUccMyuZGdUpbtde8Em0wqzkvK+576S7Scht+uu+gpSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1xKaMdwi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1xKaMdwi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AF6BC19425;
	Wed, 29 Apr 2026 15:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777477078;
	bh=XYBb24cIbNymn0MM/PwcbElsgqtu7JzpbJn2AtEdVjw=;
	h=Date:To:From:Subject:From;
	b=1xKaMdwiondF7bHsZuVFWCGB8z2LzImQgNx+Zjx/myOb3y+dORd1Zb3fpR1YZxFMv
	 7MsZOglWjCjTDx+RsedUQVu6mi9FRrAPj27S+cOvOfU0VGjjvgz3qcWCoXfa3bYKUk
	 Oet4nTj6nVLzM+nIpqSj9LPF8z1P0OrufwWO5wMA=
Date: Wed, 29 Apr 2026 08:37:57 -0700
To: mm-commits@vger.kernel.org,d@ilvokhin.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-zone-lock-guard-in-free_pcppages_bulk.patch added to mm-new branch
Message-Id: <20260429153758.0AF6BC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: use zone lock guard in free_pcppages_bulk()
has been added to the -mm mm-new branch.  Its filename is
     mm-use-zone-lock-guard-in-free_pcppages_bulk.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-zone-lock-guard-in-free_pcppages_bulk.patch

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
@@ -1459,7 +1459,6 @@ static void free_pcppages_bulk(struct zo
 					struct per_cpu_pages *pcp,
 					int pindex)
 {
-	unsigned long flags;
 	unsigned int order;
 	struct page *page;
 
@@ -1472,7 +1471,7 @@ static void free_pcppages_bulk(struct zo
 	/* Ensure requested pindex is drained first. */
 	pindex = pindex - 1;
 
-	spin_lock_irqsave(&zone->lock, flags);
+	guard(spinlock_irqsave)(&zone->lock);
 
 	while (count > 0) {
 		struct list_head *list;
@@ -1504,8 +1503,6 @@ static void free_pcppages_bulk(struct zo
 			trace_mm_page_pcpu_drain(page, order, mt);
 		} while (count > 0 && !list_empty(list));
 	}
-
-	spin_unlock_irqrestore(&zone->lock, flags);
 }
 
 /* Split a multi-block free page into its individual pageblocks. */
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

