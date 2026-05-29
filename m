Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F391B370D47
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027695; cv=none; b=EhCUiZJ8PIBVuf6ixzw1BdGpQgGTGVsxowUWkwByEVtlgpAYY1vPLmW5yV/2Ol1kVh/PynPXq083Sigy3FPl1cZaxhGobuS2J7NfrTe3c7zN89fhEMNTp9fYRY/2HdGSNC/DTXACNNd1G3hJfO1Tr3kq2HHUC5M0PBoz0GcI0bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027695; c=relaxed/simple;
	bh=cSPM6j86iGpusKdFQ8+wNOdThdSJZzK/GkPcN4kXIy0=;
	h=Date:To:From:Subject:Message-Id; b=TfywAlhIWJRbJbutWm8XhJgdUTh0vmrgQAnnqYF5gnSTXeytebkGDCeGnwveqBGUxTzDlI0BRZCd/CUJ5Z+aVskEk2KRx2yjf1uCAsvZobGEajBH1eE/PsG6YcuLw7jOQnfYDzgBPCzS7ksRKtDCbSS4EHPkFBcjjqFOjdg2g8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=F5FU0rHQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F5FU0rHQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C62421F00893;
	Fri, 29 May 2026 04:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027693;
	bh=aJA1usKGnP7lmQrOiiO87Qjx42pc7A+tWp2ex+6qG8Y=;
	h=Date:To:From:Subject;
	b=F5FU0rHQPPLSGIGn0VSfe1OX1/esLrvCePy2KA3eL58Vvt56e/wncSpkcYvANLeEK
	 82Q/VncJ6kNumy7cvYkj9ZC+N4rWeYoALh/q3UZ/Y+OITSe4RbVOTCINXmFVFRxWLa
	 nLjP2p9UQHdSOQXBVFoZKDQI8iB7QhQbc5ILw2+g=
Date: Thu, 28 May 2026 21:08:13 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,rostedt@goodmis.org,peterz@infradead.org,mhocko@suse.com,ljs@kernel.org,jackmanb@google.com,hannes@cmpxchg.org,david@kernel.org,d@ilvokhin.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-use-zone-lock-guard-in-take_page_off_buddy.patch removed from -mm tree
Message-Id: <20260529040813.C62421F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: use zone lock guard in take_page_off_buddy()
has been removed from the -mm tree.  Its filename was
     mm-use-zone-lock-guard-in-take_page_off_buddy.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -7644,11 +7644,9 @@ bool take_page_off_buddy(struct page *pa
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
@@ -7663,14 +7661,12 @@ bool take_page_off_buddy(struct page *pa
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

mm-page_alloc-fix-defrag_mode-for-non-reclaimable-allocations.patch

