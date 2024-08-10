Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F493142E6F
	for <mm-commits@vger.kernel.org>; Sat, 10 Aug 2024 06:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723270769; cv=none; b=Ls6ZJbG10RtGsRgRfXPevGbS5VRDEeYq0WBb8dhIgM9MkLgI7g8Qw1Pj2ipy148BT/FKx5ddNRz2+TRZ/qxXI8z8wWGoxGnqFzbAp6uq0yc55v8yK13NryCT5cYQOo7DmleyDs4da9diMMAjIt9Mw5wHSzMzpBp4LEUA8HHiyf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723270769; c=relaxed/simple;
	bh=Aby4M6TJSwpSo6ELFMiul+pxpiVSUkfXfvVAv7V5X5I=;
	h=Date:To:From:Subject:Message-Id; b=VBAfeW/xS2r+g5qFXpyZc6m23TXjPd/4o2wxDxUj65Lx4ad7MQRCz1bNwospbTew1PtPic+aA7bHtT45ThRs84qhlLNMsF2njBh/J7Ln37WIIwyioWOdIor6ZzRgeReTb940coC+ERHxrBQH+V3m7d4HwTzunyQAtoio2VohgzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1+YwfUK9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1+YwfUK9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 913B0C32781;
	Sat, 10 Aug 2024 06:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723270768;
	bh=Aby4M6TJSwpSo6ELFMiul+pxpiVSUkfXfvVAv7V5X5I=;
	h=Date:To:From:Subject:From;
	b=1+YwfUK9e4u/XeTbB3/FVooMa0w5P3aQNvXXMNBuZeEhKGxLVC219Q1nDmah2qBKm
	 2CderrFiTDwFypOVliR3T00A76K8Fxe+mZhrJr1t0/GsTqiP2Ios9lft/tUoc2pPVW
	 l0fPAPdEYNask9axcCK3iy7jV0vqP9HLjNSzQb9c=
Date: Fri, 09 Aug 2024 23:19:27 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,thomas.lendacky@amd.com,rppt@kernel.org,mgorman@suse.de,hannes@cmpxchg.org,david@redhat.com,bp@alien8.de,kirill.shutemov@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-a-helper-to-accept-page.patch added to mm-unstable branch
Message-Id: <20240810061928.913B0C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add a helper to accept page
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-a-helper-to-accept-page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-a-helper-to-accept-page.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
@@ -6944,27 +6944,18 @@ static bool page_contains_unaccepted(str
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
 
@@ -6972,6 +6963,38 @@ static bool try_to_accept_memory_one(str
 
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

mm-fix-endless-reclaim-on-machines-with-unaccepted-memory.patch
mm-reduce-deferred-struct-page-init-ifdeffery.patch
mm-accept-memory-in-__alloc_pages_bulk.patch
mm-introduce-pageunaccepted-page-type.patch
mm-rework-accept-memory-helpers.patch
mm-add-a-helper-to-accept-page.patch
mm-page_isolation-handle-unaccepted-memory-isolation.patch
mm-accept-to-promo-watermark.patch

