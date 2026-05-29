Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7404370AFE
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027694; cv=none; b=gzMKg/Ix5T8y+BWKG4cn0u/dt5LPASLjiD6eXyDTzbM+HQaysq0TdX0XI5ACnDVOO184TwwMVsTuazIVyykdab70jp4EryS3gY/k3/sLlm+SrXvNkfQy59IwcQ/7YWLfP0i4Pi7EPftJ8gop/vNeS9lfWQmKlchagwqDYthZpZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027694; c=relaxed/simple;
	bh=bgt8Uj+UUzTeotyCYnCAhk9I1DCvoM1VpshMdN0ddXQ=;
	h=Date:To:From:Subject:Message-Id; b=GnvBEARGwBaiPb9u+jSvpwcyzg0Z/Ap+ONhqPJy4pNTx6d/4hZo9jbQtN8fRu6+4WBsQf4tsqNz169RdGtRZFSfk7G8cBMl7qfKBSIIiPJOfQhYRDtTT3R9049A9yZjEk/NlgEq729TBmx8KlLl6ef7IgET2xP0+2EyYoCApnxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IYA00S+M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IYA00S+M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B0C51F00898;
	Fri, 29 May 2026 04:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027692;
	bh=LK/0kAjpoYwZeHfAOj0Qk9XDUnXiy35O4iM+Rm6l5v0=;
	h=Date:To:From:Subject;
	b=IYA00S+MARPYp22DyxvY2VKHDYF9ECbyc37giiMA6TmGysulLgpaklm4AxSeG66+K
	 pNPOfvfHUnL8vIvixmo/yIGv4LSWjE77voRsPaDykpPiOrtE0pLr1gtzq507XUubS+
	 Nu0YmCZ39xMgc2eWHI03yiWU3oI8TVjelYY3NfYI=
Date: Thu, 28 May 2026 21:08:12 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,rostedt@goodmis.org,peterz@infradead.org,mhocko@suse.com,ljs@kernel.org,jackmanb@google.com,hannes@cmpxchg.org,david@kernel.org,d@ilvokhin.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-use-zone-lock-guard-in-set_migratetype_isolate.patch removed from -mm tree
Message-Id: <20260529040812.9B0C51F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: use zone lock guard in set_migratetype_isolate()
has been removed from the -mm tree.  Its filename was
     mm-use-zone-lock-guard-in-set_migratetype_isolate.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dmitry Ilvokhin <d@ilvokhin.com>
Subject: mm: use zone lock guard in set_migratetype_isolate()
Date: Wed, 29 Apr 2026 12:02:09 +0000

Use spinlock_irqsave scoped lock guard in set_migratetype_isolate() to
replace the explicit lock/unlock pattern with automatic scope-based
cleanup.  The scoped variant is used to keep dump_page() outside the
locked section to avoid a lockdep splat.

Link: https://lore.kernel.org/6883351ad7f74d20875fff30e0e3214a089cea97.1777462630.git.d@ilvokhin.com
Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_isolation.c |   60 ++++++++++++++++++------------------------
 1 file changed, 26 insertions(+), 34 deletions(-)

--- a/mm/page_isolation.c~mm-use-zone-lock-guard-in-set_migratetype_isolate
+++ a/mm/page_isolation.c
@@ -167,48 +167,40 @@ static int set_migratetype_isolate(struc
 {
 	struct zone *zone = page_zone(page);
 	struct page *unmovable;
-	unsigned long flags;
 	unsigned long check_unmovable_start, check_unmovable_end;
 
 	if (PageUnaccepted(page))
 		accept_page(page);
 
-	spin_lock_irqsave(&zone->lock, flags);
-
-	/*
-	 * We assume the caller intended to SET migrate type to isolate.
-	 * If it is already set, then someone else must have raced and
-	 * set it before us.
-	 */
-	if (is_migrate_isolate_page(page)) {
-		spin_unlock_irqrestore(&zone->lock, flags);
-		return -EBUSY;
-	}
-
-	/*
-	 * FIXME: Now, memory hotplug doesn't call shrink_slab() by itself.
-	 * We just check MOVABLE pages.
-	 *
-	 * Pass the intersection of [start_pfn, end_pfn) and the page's pageblock
-	 * to avoid redundant checks.
-	 */
-	check_unmovable_start = max(page_to_pfn(page), start_pfn);
-	check_unmovable_end = min(pageblock_end_pfn(page_to_pfn(page)),
-				  end_pfn);
-
-	unmovable = has_unmovable_pages(check_unmovable_start, check_unmovable_end,
-			mode);
-	if (!unmovable) {
-		if (!pageblock_isolate_and_move_free_pages(zone, page)) {
-			spin_unlock_irqrestore(&zone->lock, flags);
+	scoped_guard(spinlock_irqsave, &zone->lock) {
+		/*
+		 * We assume the caller intended to SET migrate type to
+		 * isolate. If it is already set, then someone else must have
+		 * raced and set it before us.
+		 */
+		if (is_migrate_isolate_page(page))
 			return -EBUSY;
+
+		/*
+		 * FIXME: Now, memory hotplug doesn't call shrink_slab() by
+		 * itself. We just check MOVABLE pages.
+		 *
+		 * Pass the intersection of [start_pfn, end_pfn) and the page's
+		 * pageblock to avoid redundant checks.
+		 */
+		check_unmovable_start = max(page_to_pfn(page), start_pfn);
+		check_unmovable_end = min(pageblock_end_pfn(page_to_pfn(page)),
+					  end_pfn);
+
+		unmovable = has_unmovable_pages(check_unmovable_start,
+				check_unmovable_end, mode);
+		if (!unmovable) {
+			if (!pageblock_isolate_and_move_free_pages(zone, page))
+				return -EBUSY;
+			zone->nr_isolate_pageblock++;
+			return 0;
 		}
-		zone->nr_isolate_pageblock++;
-		spin_unlock_irqrestore(&zone->lock, flags);
-		return 0;
 	}
-
-	spin_unlock_irqrestore(&zone->lock, flags);
 	if (mode == PB_ISOLATE_MODE_MEM_OFFLINE) {
 		/*
 		 * printk() with zone->lock held will likely trigger a
_

Patches currently in -mm which might be from d@ilvokhin.com are

mm-page_alloc-fix-defrag_mode-for-non-reclaimable-allocations.patch

