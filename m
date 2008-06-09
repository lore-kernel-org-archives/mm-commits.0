From: akpm@linux-foundation.org
Subject: + vmscan-mlocked-pages-count-attempts-to-free-mlocked-page.patch added to -mm tree
Date: Sun, 08 Jun 2008 23:18:49 -0700
Message-ID: <200806090618.m596InbB006661@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41021 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754933AbYFIGTP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2008 02:19:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lee.schermerhorn@hp.com, riel@redhat.com


The patch titled
     vmscan: mlocked pages: count attempts to free mlocked page
has been added to the -mm tree.  Its filename is
     vmscan-mlocked-pages-count-attempts-to-free-mlocked-page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

---

Index: linux-2.6.26-rc2-mm1/mm/internal.h
===================================================================
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |    1 +
 mm/internal.h          |   17 +++++++++++++++++
 mm/page_alloc.c        |    1 +
 mm/vmstat.c            |    1 +
 4 files changed, 20 insertions(+)

diff -puN include/linux/vmstat.h~mlocked-pages-count-attempts-to-free-mlocked-page include/linux/vmstat.h
--- a/include/linux/vmstat.h~mlocked-pages-count-attempts-to-free-mlocked-page
+++ a/include/linux/vmstat.h
@@ -50,6 +50,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		NORECL_PGMUNLOCKED,
 		NORECL_PGCLEARED,
 		NORECL_PGSTRANDED,	/* unable to isolate on unlock */
+		NORECL_MLOCKFREED,
 #endif
 #endif
 		NR_VM_EVENT_ITEMS
diff -puN mm/internal.h~mlocked-pages-count-attempts-to-free-mlocked-page mm/internal.h
--- a/mm/internal.h~mlocked-pages-count-attempts-to-free-mlocked-page
+++ a/mm/internal.h
@@ -155,6 +155,22 @@ static inline void mlock_migrate_page(st
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
@@ -164,6 +180,7 @@ static inline int is_mlocked_vma(struct 
 static inline void clear_page_mlock(struct page *page) { }
 static inline void mlock_vma_page(struct page *page) { }
 static inline void mlock_migrate_page(struct page *new, struct page *old) { }
+static inline void free_page_mlock(struct page *page) { }
 
 #endif /* CONFIG_NORECLAIM_MLOCK */
 
diff -puN mm/page_alloc.c~mlocked-pages-count-attempts-to-free-mlocked-page mm/page_alloc.c
--- a/mm/page_alloc.c~mlocked-pages-count-attempts-to-free-mlocked-page
+++ a/mm/page_alloc.c
@@ -467,6 +467,7 @@ static inline void __free_one_page(struc
 
 static inline int free_pages_check(struct page *page)
 {
+	free_page_mlock(page);
 	if (unlikely(page_mapcount(page) |
 		(page->mapping != NULL)  |
 		(page_get_page_cgroup(page) != NULL) |
diff -puN mm/vmstat.c~mlocked-pages-count-attempts-to-free-mlocked-page mm/vmstat.c
--- a/mm/vmstat.c~mlocked-pages-count-attempts-to-free-mlocked-page
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
vmscan-use-an-indexed-array-for-lru-variables.patch
vmscan-define-page_file_cache-function.patch
vmscan-pageflag-helpers-for-configed-out-flags.patch
vmscan-noreclaim-lru-infrastructure.patch
vmscan-noreclaim-lru-page-statistics.patch
vmscan-ramfs-and-ram-disk-pages-are-non-reclaimable.patch
vmscan-shm_locked-pages-are-non-reclaimable.patch
vmscan-mlocked-pages-are-non-reclaimable.patch
vmscan-downgrade-mmap-sem-while-populating-mlocked-regions.patch
vmscan-handle-mlocked-pages-during-map-remap-unmap.patch
vmscan-mlocked-pages-statistics.patch
vmscan-cull-non-reclaimable-pages-in-fault-path.patch
vmscan-noreclaim-and-mlocked-pages-vm-events.patch
mm-only-vmscan-noreclaim-lru-scan-sysctl.patch
vmscan-mlocked-pages-count-attempts-to-free-mlocked-page.patch
vmscan-noreclaim-lru-and-mlocked-pages-documentation.patch

