Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29731370AFE
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027696; cv=none; b=b8TEIer3R2oFCkkjFyOsh3i1B3cMcOEmMDsNxIed5jdo9jblbYaAmQBide2duz9Qa9r1x5N27VJGZYR8EADzZNFAnGJLGk1Xik0SCPjyXzvGIoELDfB11w/TTVzBynCdMRWowuTawyxbgVThzlkdLiFsKXsd1bwMdndtuYXNtaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027696; c=relaxed/simple;
	bh=rJQ8FGVpiQzfqYYegCLI7ds/PQUV8+DXSeg8yav7RDk=;
	h=Date:To:From:Subject:Message-Id; b=U5nRo791Ug8yhfbss1UDlau059+/LDjKK+FSo8BvnHeJEZp1MEvrxP+ed5DP/RrOrma0br8ttezaNf1jbIR1WTLzRthe9ZYzvdK+9RSRVJj8+uLJdS09R1u0Xo++k1dwWDn2ln0+p72CTAnU/fnRCZThl5lbDjP+Vgs2i33OgKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aeAueQWx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aeAueQWx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0FB01F00898;
	Fri, 29 May 2026 04:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027695;
	bh=fKNMJLIpKjmKpA5GBp0L5/JtpaGhdEJYfJFWLhhcmuw=;
	h=Date:To:From:Subject;
	b=aeAueQWxWo58sRRugiOyAN1mqFNXIbwsEYPeVZaASv6xX/sutv71xALE62QToNwVH
	 uaBTC+rC1xM+ufKq3MrIKZMBhbyfLl+Y0Ysablmg7hrvDy1TSUVfNhqrUwF+lC4mNv
	 TpYem7MP/MFcWm9HXK30JRJaoayDYUp8w7CwrtKE=
Date: Thu, 28 May 2026 21:08:14 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,rostedt@goodmis.org,peterz@infradead.org,mhocko@suse.com,ljs@kernel.org,jackmanb@google.com,hannes@cmpxchg.org,david@kernel.org,d@ilvokhin.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-use-zone-lock-guard-in-put_page_back_buddy.patch removed from -mm tree
Message-Id: <20260529040814.F0FB01F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: use zone lock guard in put_page_back_buddy()
has been removed from the -mm tree.  Its filename was
     mm-use-zone-lock-guard-in-put_page_back_buddy.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dmitry Ilvokhin <d@ilvokhin.com>
Subject: mm: use zone lock guard in put_page_back_buddy()
Date: Wed, 29 Apr 2026 12:02:11 +0000

Use spinlock_irqsave zone lock guard in put_page_back_buddy() to replace
the explicit lock/unlock pattern with automatic scope-based cleanup.

Link: https://lore.kernel.org/b0fceedca37139da36aa626ac72eb9840b641021.1777462630.git.d@ilvokhin.com
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

 mm/page_alloc.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/mm/page_alloc.c~mm-use-zone-lock-guard-in-put_page_back_buddy
+++ a/mm/page_alloc.c
@@ -7675,23 +7675,19 @@ bool take_page_off_buddy(struct page *pa
 bool put_page_back_buddy(struct page *page)
 {
 	struct zone *zone = page_zone(page);
-	unsigned long flags;
-	bool ret = false;
 
-	spin_lock_irqsave(&zone->lock, flags);
+	guard(spinlock_irqsave)(&zone->lock);
 	if (put_page_testzero(page)) {
 		unsigned long pfn = page_to_pfn(page);
 		int migratetype = get_pfnblock_migratetype(page, pfn);
 
 		ClearPageHWPoisonTakenOff(page);
 		__free_one_page(page, pfn, zone, 0, migratetype, FPI_NONE);
-		if (TestClearPageHWPoison(page)) {
-			ret = true;
-		}
+		if (TestClearPageHWPoison(page))
+			return true;
 	}
-	spin_unlock_irqrestore(&zone->lock, flags);
 
-	return ret;
+	return false;
 }
 #endif
 
_

Patches currently in -mm which might be from d@ilvokhin.com are

mm-page_alloc-fix-defrag_mode-for-non-reclaimable-allocations.patch

