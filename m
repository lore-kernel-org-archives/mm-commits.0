Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 745DD370D63
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027698; cv=none; b=okce3VcdfG6I33YHhFbvq3ffSjiDYB+D7lAvip8NvT/+i6S646u5CQs3BomY2HqQnRTE62DDMbwQnSSJhgx6kCjwIGbTmONN3i0dzhLxJA+nJlDfup8DbNw2XfBPU9NzdeQN9tH2U+OgNJ6Vt0SAihaIag6n8ysVk7xek+wRP6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027698; c=relaxed/simple;
	bh=L8CdAen+2mOUuk2f640G+BDQloO0BK1VHv9fv2BRFqk=;
	h=Date:To:From:Subject:Message-Id; b=Lfk7gpGs5Oeh8/Fma38QGWOlw/xUc26rAIhyWKqf9Qgo8SOZsIp9YUgQxuYke5F+kqFHKd3IBlizeoac7sa5QEYoWXcu86CcuiLAeGW4ferCeX39ml5HJAc8z8qh36/THzlNjXwASQcX2W7cxCY4wpfrEvC766GVKUg48mby2JI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AHTDX7yK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AHTDX7yK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47B9B1F00898;
	Fri, 29 May 2026 04:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027697;
	bh=dBJQSu7LUS72jxDEWsxHZPCJudzUv7SsKnMfdhFubl0=;
	h=Date:To:From:Subject;
	b=AHTDX7yK+YkVB9QgHnqI7ZI9vVOxdoG8dlELUsnpzWMF3XLUbqD4XXXSgwfb6SAGB
	 9e2B+02BTi1PsACTbGyi7CGElj+5QaFEX2TKtUbKYLIXfA9R0w5c7PimNb4+Q2Tup9
	 Z8HZ/zIdzkj74LbXBISEEnIwqme66wklvPEaD4Bg=
Date: Thu, 28 May 2026 21:08:16 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,rostedt@goodmis.org,peterz@infradead.org,mhocko@suse.com,ljs@kernel.org,jackmanb@google.com,hannes@cmpxchg.org,david@kernel.org,d@ilvokhin.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-use-zone-lock-guard-in-__offline_isolated_pages.patch removed from -mm tree
Message-Id: <20260529040817.47B9B1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: use zone lock guard in __offline_isolated_pages()
has been removed from the -mm tree.  Its filename was
     mm-use-zone-lock-guard-in-__offline_isolated_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dmitry Ilvokhin <d@ilvokhin.com>
Subject: mm: use zone lock guard in __offline_isolated_pages()
Date: Wed, 29 Apr 2026 12:02:13 +0000

Use spinlock_irqsave zone lock guard in __offline_isolated_pages() to
replace the explicit lock/unlock pattern with automatic scope-based
cleanup.

Link: https://lore.kernel.org/13149be4f8151e18eb5f1eb4f3241ab3cffb373e.1777462630.git.d@ilvokhin.com
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

 mm/page_alloc.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-use-zone-lock-guard-in-__offline_isolated_pages
+++ a/mm/page_alloc.c
@@ -7531,7 +7531,7 @@ void zone_pcp_reset(struct zone *zone)
 unsigned long __offline_isolated_pages(unsigned long start_pfn,
 		unsigned long end_pfn)
 {
-	unsigned long already_offline = 0, flags;
+	unsigned long already_offline = 0;
 	unsigned long pfn = start_pfn;
 	struct page *page;
 	struct zone *zone;
@@ -7539,7 +7539,7 @@ unsigned long __offline_isolated_pages(u
 
 	offline_mem_sections(pfn, end_pfn);
 	zone = page_zone(pfn_to_page(pfn));
-	spin_lock_irqsave(&zone->lock, flags);
+	guard(spinlock_irqsave)(&zone->lock);
 	while (pfn < end_pfn) {
 		page = pfn_to_page(pfn);
 		/*
@@ -7569,7 +7569,6 @@ unsigned long __offline_isolated_pages(u
 		del_page_from_free_list(page, zone, order, MIGRATE_ISOLATE);
 		pfn += (1 << order);
 	}
-	spin_unlock_irqrestore(&zone->lock, flags);
 
 	return end_pfn - start_pfn - already_offline;
 }
_

Patches currently in -mm which might be from d@ilvokhin.com are

mm-page_alloc-fix-defrag_mode-for-non-reclaimable-allocations.patch

