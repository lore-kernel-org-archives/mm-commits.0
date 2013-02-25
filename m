From: akpm@linux-foundation.org
Subject: [merged] mm-uninline-page_xchg_last_nid.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:53:14 -0800
Message-ID: <20130225205314.9845D31C1FC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:45408 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758022Ab3BYUxP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:53:15 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so347364ghb.3
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:53:15 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: uninline page_xchg_last_nid()
has been removed from the -mm tree.  Its filename was
     mm-uninline-page_xchg_last_nid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: uninline page_xchg_last_nid()

Andrew Morton pointed out that page_xchg_last_nid() and
reset_page_last_nid() were "getting nuttily large" and asked that it be
investigated.

reset_page_last_nid() is on the page free path and it would be unfortunate
to make that path more expensive than it needs to be.  Due to the internal
use of page_xchg_last_nid() it is already too expensive but fortunately,
it should also be impossible for the page->flags to be updated in parallel
when we call reset_page_last_nid().  Instead of unlining the function, it
uses a simplier implementation that assumes no parallel updates and should
now be sufficiently short for inlining.

page_xchg_last_nid() is called in paths that are already quite expensive
(splitting huge page, fault handling, migration) and it is reasonable to
uninline.  There was not really a good place to place the function but
mm/mmzone.c was the closest fit IMO.

This patch saved 128 bytes of text in the vmlinux file for the kernel
configuration I used for testing automatic NUMA balancing.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   21 +++++----------------
 mm/mmzone.c        |   20 +++++++++++++++++++-
 2 files changed, 24 insertions(+), 17 deletions(-)

diff -puN include/linux/mm.h~mm-uninline-page_xchg_last_nid include/linux/mm.h
--- a/include/linux/mm.h~mm-uninline-page_xchg_last_nid
+++ a/include/linux/mm.h
@@ -677,25 +677,14 @@ static inline int page_last_nid(struct p
 	return (page->flags >> LAST_NID_PGSHIFT) & LAST_NID_MASK;
 }
 
-static inline int page_xchg_last_nid(struct page *page, int nid)
-{
-	unsigned long old_flags, flags;
-	int last_nid;
-
-	do {
-		old_flags = flags = page->flags;
-		last_nid = page_last_nid(page);
-
-		flags &= ~(LAST_NID_MASK << LAST_NID_PGSHIFT);
-		flags |= (nid & LAST_NID_MASK) << LAST_NID_PGSHIFT;
-	} while (unlikely(cmpxchg(&page->flags, old_flags, flags) != old_flags));
-
-	return last_nid;
-}
+extern int page_xchg_last_nid(struct page *page, int nid);
 
 static inline void reset_page_last_nid(struct page *page)
 {
-	page_xchg_last_nid(page, (1 << LAST_NID_SHIFT) - 1);
+	int nid = (1 << LAST_NID_SHIFT) - 1;
+
+	page->flags &= ~(LAST_NID_MASK << LAST_NID_PGSHIFT);
+	page->flags |= (nid & LAST_NID_MASK) << LAST_NID_PGSHIFT;
 }
 #endif /* LAST_NID_NOT_IN_PAGE_FLAGS */
 #else
diff -puN mm/mmzone.c~mm-uninline-page_xchg_last_nid mm/mmzone.c
--- a/mm/mmzone.c~mm-uninline-page_xchg_last_nid
+++ a/mm/mmzone.c
@@ -1,7 +1,7 @@
 /*
  * linux/mm/mmzone.c
  *
- * management codes for pgdats and zones.
+ * management codes for pgdats, zones and page flags
  */
 
 
@@ -96,3 +96,21 @@ void lruvec_init(struct lruvec *lruvec)
 	for_each_lru(lru)
 		INIT_LIST_HEAD(&lruvec->lists[lru]);
 }
+
+#if defined(CONFIG_NUMA_BALANCING) && !defined(LAST_NID_NOT_IN_PAGE_FLAGS)
+int page_xchg_last_nid(struct page *page, int nid)
+{
+	unsigned long old_flags, flags;
+	int last_nid;
+
+	do {
+		old_flags = flags = page->flags;
+		last_nid = page_last_nid(page);
+
+		flags &= ~(LAST_NID_MASK << LAST_NID_PGSHIFT);
+		flags |= (nid & LAST_NID_MASK) << LAST_NID_PGSHIFT;
+	} while (unlikely(cmpxchg(&page->flags, old_flags, flags) != old_flags));
+
+	return last_nid;
+}
+#endif
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
linux-next.patch
revert-x86-mm-make-spurious_fault-check-explicitly-check-the-present-bit.patch
pageattr-prevent-pse-and-gloabl-leftovers-to-confuse-pmd-pte_present-and-pmd_huge.patch
mm-memmap_init_zone-performance-improvement.patch
mm-accelerate-munlock-treatment-of-thp-pages.patch

