Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5207A3803DD
	for <mm-commits@vger.kernel.org>; Wed, 29 Apr 2026 15:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777477074; cv=none; b=oZQigPzM59+cyraQF7d/LLgdIzDyeYvDflbyLMWHHCbdcpSuS0cotidqPNVNT8nJpr5BOZuyKWjAvvsg+0MjfQLUbRi/WIQEC1siOe2rKB6OdDJartb6wLmAovu+1aaYAQ6sWCfRMWI+isXuqqTtFMbvRw5DK4a8NgtgtRYATXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777477074; c=relaxed/simple;
	bh=Qy7lQocNJ3bXD4MeGhYPwMR3yWxIY9Y00FjXLdcx3wM=;
	h=Date:To:From:Subject:Message-Id; b=rVwJW6t3wAuZ7zhYh2BuWksM8tuOAPSvOwupFfUNpAKOdXwSwnm564qht+2xZfR1DyYCxsyVcm4LiqXrblkvSHB15YJP33TYNAUFF1JUbz9ptPmQ3R/kZ5NBwVvo8JszTmFbtfBxRQXP6RaHELmd0zx3K90lJXNgdGcVTzQbnBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rlP8gDBF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rlP8gDBF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D454DC2BCC4;
	Wed, 29 Apr 2026 15:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777477073;
	bh=Qy7lQocNJ3bXD4MeGhYPwMR3yWxIY9Y00FjXLdcx3wM=;
	h=Date:To:From:Subject:From;
	b=rlP8gDBFuc/N0y9m4B6Yj8Ld/sZdzWCfyc5GYzjwth1Pj7MCLGGivK3pW1XEi0kZF
	 mQJeaBICwd7DwvcfkuSch3+iuWiqr5yLyq+qEKaDMLalMqTcwUyycWm6+nFdmZk+Qg
	 8HYmQpDJQpwXWl++BnvLOAG3+w47CVYOb20tPeuo=
Date: Wed, 29 Apr 2026 08:37:53 -0700
To: mm-commits@vger.kernel.org,d@ilvokhin.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-zone-lock-guard-in-take_page_off_buddy.patch added to mm-new branch
Message-Id: <20260429153753.D454DC2BCC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: use zone lock guard in take_page_off_buddy()
has been added to the -mm mm-new branch.  Its filename is
     mm-use-zone-lock-guard-in-take_page_off_buddy.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-zone-lock-guard-in-take_page_off_buddy.patch

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
Subject: mm: use zone lock guard in take_page_off_buddy()
Date: Wed, 29 Apr 2026 12:02:10 +0000

Use spinlock_irqsave zone lock guard in take_page_off_buddy() to replace
the explicit lock/unlock pattern with automatic scope-based cleanup.

This also allows to return directly from the loop, removing the 'ret'
variable.

Link: https://lore.kernel.org/a981721632a981f148c63e3f7df3d1116a0c3f6d.1777462630.git.d@ilvokhin.com
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

 mm/page_alloc.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/mm/page_alloc.c~mm-use-zone-lock-guard-in-take_page_off_buddy
+++ a/mm/page_alloc.c
@@ -7634,11 +7634,9 @@ bool take_page_off_buddy(struct page *pa
 {
 	struct zone *zone = page_zone(page);
 	unsigned long pfn = page_to_pfn(page);
-	unsigned long flags;
 	unsigned int order;
-	bool ret = false;
 
-	spin_lock_irqsave(&zone->lock, flags);
+	guard(spinlock_irqsave)(&zone->lock);
 	for (order = 0; order < NR_PAGE_ORDERS; order++) {
 		struct page *page_head = page - (pfn & ((1 << order) - 1));
 		int page_order = buddy_order(page_head);
@@ -7653,14 +7651,12 @@ bool take_page_off_buddy(struct page *pa
 			break_down_buddy_pages(zone, page_head, page, 0,
 						page_order, migratetype);
 			SetPageHWPoisonTakenOff(page);
-			ret = true;
-			break;
+			return true;
 		}
 		if (page_count(page_head) > 0)
 			break;
 	}
-	spin_unlock_irqrestore(&zone->lock, flags);
-	return ret;
+	return false;
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

