From: akpm@linux-foundation.org
Subject: [merged] page-allocator-move-free_page_mlock-to-page_allocc.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:34:32 -0700
Message-ID: <200906171834.n5HIYWZi000607@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43416 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760136AbZFQSe4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:34:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, Lee.Schermerhorn@hp.com, cl@linux-foundation.org, dave@linux.vnet.ibm.com, mel@csn.ul.ie, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     page allocator: move free_page_mlock() to page_alloc.c
has been removed from the -mm tree.  Its filename was
     page-allocator-move-free_page_mlock-to-page_allocc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page allocator: move free_page_mlock() to page_alloc.c
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Currently, free_page_mlock() is only called from page_alloc.c.  Thus, we
can move it to page_alloc.c.

Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h   |   13 -------------
 mm/page_alloc.c |   16 ++++++++++++++++
 2 files changed, 16 insertions(+), 13 deletions(-)

diff -puN mm/internal.h~page-allocator-move-free_page_mlock-to-page_allocc mm/internal.h
--- a/mm/internal.h~page-allocator-move-free_page_mlock-to-page_allocc
+++ a/mm/internal.h
@@ -150,18 +150,6 @@ static inline void mlock_migrate_page(st
 	}
 }
 
-/*
- * free_page_mlock() -- clean up attempts to free and mlocked() page.
- * Page should not be on lru, so no need to fix that up.
- * free_pages_check() will verify...
- */
-static inline void free_page_mlock(struct page *page)
-{
-	__ClearPageMlocked(page);
-	__dec_zone_page_state(page, NR_MLOCK);
-	__count_vm_event(UNEVICTABLE_MLOCKFREED);
-}
-
 #else /* CONFIG_HAVE_MLOCKED_PAGE_BIT */
 static inline int is_mlocked_vma(struct vm_area_struct *v, struct page *p)
 {
@@ -170,7 +158,6 @@ static inline int is_mlocked_vma(struct 
 static inline void clear_page_mlock(struct page *page) { }
 static inline void mlock_vma_page(struct page *page) { }
 static inline void mlock_migrate_page(struct page *new, struct page *old) { }
-static inline void free_page_mlock(struct page *page) { }
 
 #endif /* CONFIG_HAVE_MLOCKED_PAGE_BIT */
 
diff -puN mm/page_alloc.c~page-allocator-move-free_page_mlock-to-page_allocc mm/page_alloc.c
--- a/mm/page_alloc.c~page-allocator-move-free_page_mlock-to-page_allocc
+++ a/mm/page_alloc.c
@@ -493,6 +493,22 @@ static inline void __free_one_page(struc
 	zone->free_area[order].nr_free++;
 }
 
+#ifdef CONFIG_HAVE_MLOCKED_PAGE_BIT
+/*
+ * free_page_mlock() -- clean up attempts to free and mlocked() page.
+ * Page should not be on lru, so no need to fix that up.
+ * free_pages_check() will verify...
+ */
+static inline void free_page_mlock(struct page *page)
+{
+	__ClearPageMlocked(page);
+	__dec_zone_page_state(page, NR_MLOCK);
+	__count_vm_event(UNEVICTABLE_MLOCKFREED);
+}
+#else
+static void free_page_mlock(struct page *page) { }
+#endif
+
 static inline int free_pages_check(struct page *page)
 {
 	if (unlikely(page_mapcount(page) |
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
documentation-vm-makefile-dont-try-to-build-slqbinfo.patch
linux-next.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-export-statistics-for-softirq-to-proc-update.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
proc-update-document-for-proc-softirqs-and-proc-stat-update.patch
page_alloc-oops-when-setting-percpu_pagelist_fraction.patch
readahead-add-blk_run_backing_dev.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
getrusage-fill-ru_maxrss-value.patch
memcg-add-file-based-rss-accounting.patch
memcg-add-file-based-rss-accounting-fix-mem_cgroup_update_mapped_file_stat-oops.patch
memcg-fix-lru-rotation-in-isolate_pages.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

