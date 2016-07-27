From: akpm@linux-foundation.org
Subject: [merged] mm-clean-up-non-standard-page-_mapcount-users.patch
 removed from -mm tree
Date: Wed, 27 Jul 2016 12:01:19 -0700
Message-ID: <579904ff.N9iMAaZnh7rVLawJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40395 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757190AbcG0TBU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jul 2016 15:01:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, eric.dumazet@gmail.com, hannes@cmpxchg.org, mhocko@kernel.org, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: clean up non-standard page->_mapcount users
has been removed from the -mm tree.  Its filename was
     mm-clean-up-non-standard-page-_mapcount-users.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: mm: clean up non-standard page->_mapcount users

 - Add a proper comment to page->_mapcount.
 - Introduce a macro for generating helper functions.
 - Place all special page->_mapcount values next to each other so that
   readers can see all possible values and so we don't get duplicates.

Link: http://lkml.kernel.org/r/502f49000e0b63e6c62e338fac6b420bf34fb526.1464079537.git.vdavydov@virtuozzo.com
Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h   |    5 ++
 include/linux/page-flags.h |   73 +++++++++++++++--------------------
 scripts/tags.sh            |    3 +
 3 files changed, 40 insertions(+), 41 deletions(-)

diff -puN include/linux/mm_types.h~mm-clean-up-non-standard-page-_mapcount-users include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-clean-up-non-standard-page-_mapcount-users
+++ a/include/linux/mm_types.h
@@ -85,6 +85,11 @@ struct page {
 				/*
 				 * Count of ptes mapped in mms, to show when
 				 * page is mapped & limit reverse map searches.
+				 *
+				 * Extra information about page type may be
+				 * stored here for pages that are never mapped,
+				 * in which case the value MUST BE <= -2.
+				 * See page-flags.h for more details.
 				 */
 				atomic_t _mapcount;
 
diff -puN include/linux/page-flags.h~mm-clean-up-non-standard-page-_mapcount-users include/linux/page-flags.h
--- a/include/linux/page-flags.h~mm-clean-up-non-standard-page-_mapcount-users
+++ a/include/linux/page-flags.h
@@ -604,54 +604,45 @@ TESTPAGEFLAG_FALSE(DoubleMap)
 #endif
 
 /*
- * PageBuddy() indicate that the page is free and in the buddy system
- * (see mm/page_alloc.c).
- *
- * PAGE_BUDDY_MAPCOUNT_VALUE must be <= -2 but better not too close to
- * -2 so that an underflow of the page_mapcount() won't be mistaken
- * for a genuine PAGE_BUDDY_MAPCOUNT_VALUE. -128 can be created very
- * efficiently by most CPU architectures.
+ * For pages that are never mapped to userspace, page->mapcount may be
+ * used for storing extra information about page type. Any value used
+ * for this purpose must be <= -2, but it's better start not too close
+ * to -2 so that an underflow of the page_mapcount() won't be mistaken
+ * for a special page.
  */
-#define PAGE_BUDDY_MAPCOUNT_VALUE (-128)
-
-static inline int PageBuddy(struct page *page)
-{
-	return atomic_read(&page->_mapcount) == PAGE_BUDDY_MAPCOUNT_VALUE;
+#define PAGE_MAPCOUNT_OPS(uname, lname)					\
+static __always_inline int Page##uname(struct page *page)		\
+{									\
+	return atomic_read(&page->_mapcount) ==				\
+				PAGE_##lname##_MAPCOUNT_VALUE;		\
+}									\
+static __always_inline void __SetPage##uname(struct page *page)		\
+{									\
+	VM_BUG_ON_PAGE(atomic_read(&page->_mapcount) != -1, page);	\
+	atomic_set(&page->_mapcount, PAGE_##lname##_MAPCOUNT_VALUE);	\
+}									\
+static __always_inline void __ClearPage##uname(struct page *page)	\
+{									\
+	VM_BUG_ON_PAGE(!Page##uname(page), page);			\
+	atomic_set(&page->_mapcount, -1);				\
 }
 
-static inline void __SetPageBuddy(struct page *page)
-{
-	VM_BUG_ON_PAGE(atomic_read(&page->_mapcount) != -1, page);
-	atomic_set(&page->_mapcount, PAGE_BUDDY_MAPCOUNT_VALUE);
-}
+/*
+ * PageBuddy() indicate that the page is free and in the buddy system
+ * (see mm/page_alloc.c).
+ */
+#define PAGE_BUDDY_MAPCOUNT_VALUE		(-128)
+PAGE_MAPCOUNT_OPS(Buddy, BUDDY)
 
-static inline void __ClearPageBuddy(struct page *page)
-{
-	VM_BUG_ON_PAGE(!PageBuddy(page), page);
-	atomic_set(&page->_mapcount, -1);
-}
+/*
+ * PageBalloon() is set on pages that are on the balloon page list
+ * (see mm/balloon_compaction.c).
+ */
+#define PAGE_BALLOON_MAPCOUNT_VALUE		(-256)
+PAGE_MAPCOUNT_OPS(Balloon, BALLOON)
 
 extern bool is_free_buddy_page(struct page *page);
 
-#define PAGE_BALLOON_MAPCOUNT_VALUE (-256)
-
-static inline int PageBalloon(struct page *page)
-{
-	return atomic_read(&page->_mapcount) == PAGE_BALLOON_MAPCOUNT_VALUE;
-}
-
-static inline void __SetPageBalloon(struct page *page)
-{
-	VM_BUG_ON_PAGE(atomic_read(&page->_mapcount) != -1, page);
-	atomic_set(&page->_mapcount, PAGE_BALLOON_MAPCOUNT_VALUE);
-}
-
-static inline void __ClearPageBalloon(struct page *page)
-{
-	VM_BUG_ON_PAGE(!PageBalloon(page), page);
-	atomic_set(&page->_mapcount, -1);
-}
