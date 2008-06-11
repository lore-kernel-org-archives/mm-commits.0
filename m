From: akpm@linux-foundation.org
Subject: - vmscan-mlocked-pages-count-attempts-to-free-mlocked-page.patch removed from -mm tree
Date: Wed, 11 Jun 2008 12:46:51 -0700
Message-ID: <200806111946.m5BJkpgU014626@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45288 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750700AbYFKTrW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Jun 2008 15:47:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lee.schermerhorn@hp.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     vmscan: mlocked pages: count attempts to free mlocked page
has been removed from the -mm tree.  Its filename was
     vmscan-mlocked-pages-count-attempts-to-free-mlocked-page.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: mlocked pages: count attempts to free mlocked page
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

Allow free of mlock()ed pages.  This shouldn't happen, but during
developement, it occasionally did.

This patch allows us to survive that condition, while keeping the
statistics and events correct for debug.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |    1 +
 mm/internal.h          |   17 +++++++++++++++++
 mm/page_alloc.c        |    1 +
 mm/vmstat.c            |    1 +
 4 files changed, 20 insertions(+)

diff -puN include/linux/vmstat.h~vmscan-mlocked-pages-count-attempts-to-free-mlocked-page include/linux/vmstat.h
--- a/include/linux/vmstat.h~vmscan-mlocked-pages-count-attempts-to-free-mlocked-page
+++ a/include/linux/vmstat.h
@@ -50,6 +50,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		NORECL_PGMUNLOCKED,
 		NORECL_PGCLEARED,
 		NORECL_PGSTRANDED,	/* unable to isolate on unlock */
+		NORECL_MLOCKFREED,
 #endif
 #endif
 		NR_VM_EVENT_ITEMS
diff -puN mm/internal.h~vmscan-mlocked-pages-count-attempts-to-free-mlocked-page mm/internal.h
--- a/mm/internal.h~vmscan-mlocked-pages-count-attempts-to-free-mlocked-page
+++ a/mm/internal.h
@@ -157,6 +157,22 @@ static inline void mlock_migrate_page(st
 	}
 }
 
+/*
+ * free_page_mlock() -- clean up attempts to free and mlocked() page.
+ * Page should not be on lru, so no need to fix that up.
+ * free_pages_check() will verify...
+ */
+static inline void free_page_mlock(struct page *page)
+{
+	if (unlikely(TestClearPageMlocked(page))) {
+		unsigned long flags;
+
+		local_irq_save(flags);
+		__dec_zone_page_state(page, NR_MLOCK);
+		__count_vm_event(NORECL_MLOCKFREED);
+		local_irq_restore(flags);
+	}
+}
 
 #else /* CONFIG_NORECLAIM_MLOCK */
 static inline int is_mlocked_vma(struct vm_area_struct *v, struct page *p)
@@ -166,6 +182,7 @@ static inline int is_mlocked_vma(struct 
 static inline void clear_page_mlock(struct page *page) { }
 static inline void mlock_vma_page(struct page *page) { }
 static inline void mlock_migrate_page(struct page *new, struct page *old) { }
+static inline void free_page_mlock(struct page *page) { }
 
 #endif /* CONFIG_NORECLAIM_MLOCK */
 
diff -puN mm/page_alloc.c~vmscan-mlocked-pages-count-attempts-to-free-mlocked-page mm/page_alloc.c
--- a/mm/page_alloc.c~vmscan-mlocked-pages-count-attempts-to-free-mlocked-page
+++ a/mm/page_alloc.c
@@ -467,6 +467,7 @@ static inline void __free_one_page(struc
 
 static inline int free_pages_check(struct page *page)
 {
+	free_page_mlock(page);
 	if (unlikely(page_mapcount(page) |
 		(page->mapping != NULL)  |
 		(page_get_page_cgroup(page) != NULL) |
diff -puN mm/vmstat.c~vmscan-mlocked-pages-count-attempts-to-free-mlocked-page mm/vmstat.c
--- a/mm/vmstat.c~vmscan-mlocked-pages-count-attempts-to-free-mlocked-page
+++ a/mm/vmstat.c
@@ -676,6 +676,7 @@ static const char * const vmstat_text[] 
 	"noreclaim_pgs_munlocked",
 	"noreclaim_pgs_cleared",
 	"noreclaim_pgs_stranded",
+	"noreclaim_pgs_mlockfreed",
 #endif
 #endif
 #endif
_

Patches currently in -mm which might be from lee.schermerhorn@hp.com are

page-allocator-inlnie-some-__alloc_pages-wrappers.patch
page-allocator-inlnie-some-__alloc_pages-wrappers-fix.patch
vmscan-mlocked-pages-count-attempts-to-free-mlocked-page.patch
vmscan-noreclaim-lru-and-mlocked-pages-documentation.patch

