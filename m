From: akpm@linux-foundation.org
Subject: - mlock-count-attempts-to-free-mlocked-page-2.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:33:20 -0700
Message-ID: <200810202033.m9KKXKus010597@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60751 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753978AbYJTUiT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:38:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lee.schermerhorn@hp.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mlock: count attempts to free mlocked page
has been removed from the -mm tree.  Its filename was
     mlock-count-attempts-to-free-mlocked-page-2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mlock: count attempts to free mlocked page
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

diff -puN include/linux/vmstat.h~mlock-count-attempts-to-free-mlocked-page-2 include/linux/vmstat.h
--- a/include/linux/vmstat.h~mlock-count-attempts-to-free-mlocked-page-2
+++ a/include/linux/vmstat.h
@@ -49,6 +49,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		UNEVICTABLE_PGMUNLOCKED,
 		UNEVICTABLE_PGCLEARED,	/* on COW, page truncate */
 		UNEVICTABLE_PGSTRANDED,	/* unable to isolate on unlock */
+		UNEVICTABLE_MLOCKFREED,
 #endif
 		NR_VM_EVENT_ITEMS
 };
diff -puN mm/internal.h~mlock-count-attempts-to-free-mlocked-page-2 mm/internal.h
--- a/mm/internal.h~mlock-count-attempts-to-free-mlocked-page-2
+++ a/mm/internal.h
@@ -146,6 +146,22 @@ static inline void mlock_migrate_page(st
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
+		__count_vm_event(UNEVICTABLE_MLOCKFREED);
+		local_irq_restore(flags);
+	}
+}
 
 #else /* CONFIG_UNEVICTABLE_LRU */
 static inline int is_mlocked_vma(struct vm_area_struct *v, struct page *p)
@@ -155,6 +171,7 @@ static inline int is_mlocked_vma(struct 
 static inline void clear_page_mlock(struct page *page) { }
 static inline void mlock_vma_page(struct page *page) { }
 static inline void mlock_migrate_page(struct page *new, struct page *old) { }
+static inline void free_page_mlock(struct page *page) { }
 
 #endif /* CONFIG_UNEVICTABLE_LRU */
 
diff -puN mm/page_alloc.c~mlock-count-attempts-to-free-mlocked-page-2 mm/page_alloc.c
--- a/mm/page_alloc.c~mlock-count-attempts-to-free-mlocked-page-2
+++ a/mm/page_alloc.c
@@ -454,6 +454,7 @@ static inline void __free_one_page(struc
 
 static inline int free_pages_check(struct page *page)
 {
+	free_page_mlock(page);
 	if (unlikely(page_mapcount(page) |
 		(page->mapping != NULL)  |
 		(page_get_page_cgroup(page) != NULL) |
diff -puN mm/vmstat.c~mlock-count-attempts-to-free-mlocked-page-2 mm/vmstat.c
--- a/mm/vmstat.c~mlock-count-attempts-to-free-mlocked-page-2
+++ a/mm/vmstat.c
@@ -689,6 +689,7 @@ static const char * const vmstat_text[] 
 	"unevictable_pgs_munlocked",
 	"unevictable_pgs_cleared",
 	"unevictable_pgs_stranded",
+	"unevictable_pgs_mlockfreed",
 #endif
 #endif
 };
_

Patches currently in -mm which might be from lee.schermerhorn@hp.com are

origin.patch

