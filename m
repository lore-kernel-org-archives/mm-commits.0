Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6299F5381E
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247786; cv=none; b=FNdS6HDg0FPfJSmUNq9QF+3/uMjRwCkjvbnH/qfAoqeDOO+Yz+S1Kf8VUD6NJsz87TqOUD5b/vFXz+9gwYd7QrKmdjL0nokG4REd7HIQRMvAWdiUHM00/78dYwHT6H8UuF/2hePfKB6inosnxrO2bWnZYvtv8tIcEgAzbU7qVTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247786; c=relaxed/simple;
	bh=Ymua6GyLoCcKUeKzD8xvFR4zp2aqjbTI4/r5cIkVBkc=;
	h=Date:To:From:Subject:Message-Id; b=qsyFxJqBeWhw4E0eN5aT9QmF4sFDeUnKAogKMyUy6LQ/g11spexcN00U98ZjpEDLEPYwrjEtszjQ3P0EDDsT7Ot+0RhxzOgcXOguSYBHCnpKkYUeCoRRs8YYeAhEmbJ21xcubK0vBUTJ6PsIcAIhLbTVM82fdtJuVQVnbmckecU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eh6VFsV8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eh6VFsV8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C665CC4CEC2;
	Mon,  2 Sep 2024 03:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247785;
	bh=Ymua6GyLoCcKUeKzD8xvFR4zp2aqjbTI4/r5cIkVBkc=;
	h=Date:To:From:Subject:From;
	b=eh6VFsV87Axj01clrNBu4/Q8insVPFMAdFt8uHpMe25giF+L1geKFEMwZGq5yZo9w
	 ++vgTCd4VLMChRZYWqw0ejUJ5A+t7tXwK+5GVywkTIJz8vGdBB5KTtTM1LMqQpBzk8
	 RFxm0zHQ8icNYcAUBLIffAC80fTl+0YV1R5V4icM=
Date: Sun, 01 Sep 2024 20:29:45 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,thomas.lendacky@amd.com,rppt@kernel.org,mgorman@suse.de,hannes@cmpxchg.org,david@redhat.com,bp@alien8.de,kirill.shutemov@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-a-helper-to-accept-page.patch removed from -mm tree
Message-Id: <20240902032945.C665CC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: add a helper to accept page
has been removed from the -mm tree.  Its filename was
     mm-add-a-helper-to-accept-page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: add a helper to accept page
Date: Fri, 9 Aug 2024 14:48:52 +0300

Accept a given struct page and add it free list.

The help is useful for physical memory scanners that want to use free
unaccepted memory.

Link: https://lkml.kernel.org/r/20240809114854.3745464-7-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h   |    8 +++++++
 mm/page_alloc.c |   47 ++++++++++++++++++++++++++++++++++------------
 2 files changed, 43 insertions(+), 12 deletions(-)

--- a/mm/internal.h~mm-add-a-helper-to-accept-page
+++ a/mm/internal.h
@@ -1432,4 +1432,12 @@ unsigned long move_page_tables(struct vm
 	unsigned long new_addr, unsigned long len,
 	bool need_rmap_locks, bool for_stack);
 
+#ifdef CONFIG_UNACCEPTED_MEMORY
+void accept_page(struct page *page);
+#else /* CONFIG_UNACCEPTED_MEMORY */
+static inline void accept_page(struct page *page)
+{
+}
+#endif /* CONFIG_UNACCEPTED_MEMORY */
+
 #endif	/* __MM_INTERNAL_H */
--- a/mm/page_alloc.c~mm-add-a-helper-to-accept-page
+++ a/mm/page_alloc.c
@@ -6935,27 +6935,18 @@ static bool page_contains_unaccepted(str
 	return range_contains_unaccepted_memory(start, PAGE_SIZE << order);
 }
 
-static bool try_to_accept_memory_one(struct zone *zone)
+static void __accept_page(struct zone *zone, unsigned long *flags,
+			  struct page *page)
 {
-	unsigned long flags;
-	struct page *page;
 	bool last;
 
-	spin_lock_irqsave(&zone->lock, flags);
-	page = list_first_entry_or_null(&zone->unaccepted_pages,
-					struct page, lru);
-	if (!page) {
-		spin_unlock_irqrestore(&zone->lock, flags);
-		return false;
-	}
-
 	list_del(&page->lru);
 	last = list_empty(&zone->unaccepted_pages);
 
 	account_freepages(zone, -MAX_ORDER_NR_PAGES, MIGRATE_MOVABLE);
 	__mod_zone_page_state(zone, NR_UNACCEPTED, -MAX_ORDER_NR_PAGES);
 	__ClearPageUnaccepted(page);
-	spin_unlock_irqrestore(&zone->lock, flags);
+	spin_unlock_irqrestore(&zone->lock, *flags);
 
 	accept_memory(page_to_phys(page), PAGE_SIZE << MAX_PAGE_ORDER);
 
@@ -6963,6 +6954,38 @@ static bool try_to_accept_memory_one(str
 
 	if (last)
 		static_branch_dec(&zones_with_unaccepted_pages);
+}
+
+void accept_page(struct page *page)
+{
+	struct zone *zone = page_zone(page);
+	unsigned long flags;
+
+	spin_lock_irqsave(&zone->lock, flags);
+	if (!PageUnaccepted(page)) {
+		spin_unlock_irqrestore(&zone->lock, flags);
+		return;
+	}
+
+	/* Unlocks zone->lock */
+	__accept_page(zone, &flags, page);
+}
+
+static bool try_to_accept_memory_one(struct zone *zone)
+{
+	unsigned long flags;
+	struct page *page;
+
+	spin_lock_irqsave(&zone->lock, flags);
+	page = list_first_entry_or_null(&zone->unaccepted_pages,
+					struct page, lru);
+	if (!page) {
+		spin_unlock_irqrestore(&zone->lock, flags);
+		return false;
+	}
+
+	/* Unlocks zone->lock */
+	__accept_page(zone, &flags, page);
 
 	return true;
 }
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are


