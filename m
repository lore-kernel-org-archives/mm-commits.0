From: akpm@linux-foundation.org
Subject: [merged] vmscan-detect-mapped-file-pages-used-only-once.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:04:44 -0800
Message-ID: <201003091904.o29J4iqJ031062@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54353 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753902Ab0CITFh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:05:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, minchan.kim@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     vmscan: detect mapped file pages used only once
has been removed from the -mm tree.  Its filename was
     vmscan-detect-mapped-file-pages-used-only-once.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: detect mapped file pages used only once
From: Johannes Weiner <hannes@cmpxchg.org>

The VM currently assumes that an inactive, mapped and referenced file page
is in use and promotes it to the active list.

However, every mapped file page starts out like this and thus a problem
arises when workloads create a stream of such pages that are used only for
a short time.  By flooding the active list with those pages, the VM
quickly gets into trouble finding eligible reclaim canditates.  The result
is long allocation latencies and eviction of the wrong pages.

This patch reuses the PG_referenced page flag (used for unmapped file
pages) to implement a usage detection that scales with the speed of LRU
list cycling (i.e.  memory pressure).

If the scanner encounters those pages, the flag is set and the page cycled
again on the inactive list.  Only if it returns with another page table
reference it is activated.  Otherwise it is reclaimed as 'not recently
used cache'.

This effectively changes the minimum lifetime of a used-once mapped file
page from a full memory cycle to an inactive list cycle, which allows it
to occur in linear streams without affecting the stable working set of the
system.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: OSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    2 -
 mm/rmap.c            |    3 --
 mm/vmscan.c          |   45 +++++++++++++++++++++++++++++++----------
 3 files changed, 36 insertions(+), 14 deletions(-)

diff -puN include/linux/rmap.h~vmscan-detect-mapped-file-pages-used-only-once include/linux/rmap.h
--- a/include/linux/rmap.h~vmscan-detect-mapped-file-pages-used-only-once
+++ a/include/linux/rmap.h
@@ -209,7 +209,7 @@ static inline int page_referenced(struct
 				  unsigned long *vm_flags)
 {
 	*vm_flags = 0;
-	return TestClearPageReferenced(page);
+	return 0;
 }
 
 #define try_to_unmap(page, refs) SWAP_FAIL
diff -puN mm/rmap.c~vmscan-detect-mapped-file-pages-used-only-once mm/rmap.c
--- a/mm/rmap.c~vmscan-detect-mapped-file-pages-used-only-once
+++ a/mm/rmap.c
@@ -601,9 +601,6 @@ int page_referenced(struct page *page,
 	int referenced = 0;
 	int we_locked = 0;
 
-	if (TestClearPageReferenced(page))
-		referenced++;
-
 	*vm_flags = 0;
 	if (page_mapped(page) && page_rmapping(page)) {
 		if (!is_locked && (!PageAnon(page) || PageKsm(page))) {
diff -puN mm/vmscan.c~vmscan-detect-mapped-file-pages-used-only-once mm/vmscan.c
--- a/mm/vmscan.c~vmscan-detect-mapped-file-pages-used-only-once
+++ a/mm/vmscan.c
@@ -561,18 +561,18 @@ redo:
 enum page_references {
 	PAGEREF_RECLAIM,
 	PAGEREF_RECLAIM_CLEAN,
+	PAGEREF_KEEP,
 	PAGEREF_ACTIVATE,
 };
 
 static enum page_references page_check_references(struct page *page,
 						  struct scan_control *sc)
 {
+	int referenced_ptes, referenced_page;
 	unsigned long vm_flags;
-	int referenced;
 
-	referenced = page_referenced(page, 1, sc->mem_cgroup, &vm_flags);
-	if (!referenced)
-		return PAGEREF_RECLAIM;
+	referenced_ptes = page_referenced(page, 1, sc->mem_cgroup, &vm_flags);
+	referenced_page = TestClearPageReferenced(page);
 
 	/* Lumpy reclaim - ignore references */
 	if (sc->order > PAGE_ALLOC_COSTLY_ORDER)
@@ -585,11 +585,36 @@ static enum page_references page_check_r
 	if (vm_flags & VM_LOCKED)
 		return PAGEREF_RECLAIM;
 
-	if (page_mapped(page))
-		return PAGEREF_ACTIVATE;
+	if (referenced_ptes) {
+		if (PageAnon(page))
+			return PAGEREF_ACTIVATE;
+		/*
+		 * All mapped pages start out with page table
+		 * references from the instantiating fault, so we need
+		 * to look twice if a mapped file page is used more
+		 * than once.
+		 *
+		 * Mark it and spare it for another trip around the
+		 * inactive list.  Another page table reference will
+		 * lead to its activation.
+		 *
+		 * Note: the mark is set for activated pages as well
+		 * so that recently deactivated but used pages are
+		 * quickly recovered.
+		 */
+		SetPageReferenced(page);
+
+		if (referenced_page)
+			return PAGEREF_ACTIVATE;
+
+		return PAGEREF_KEEP;
+	}
 
 	/* Reclaim if clean, defer dirty pages to writeback */
-	return PAGEREF_RECLAIM_CLEAN;
+	if (referenced_page)
+		return PAGEREF_RECLAIM_CLEAN;
+
+	return PAGEREF_RECLAIM;
 }
 
 /*
@@ -657,6 +682,8 @@ static unsigned long shrink_page_list(st
 		switch (references) {
 		case PAGEREF_ACTIVATE:
 			goto activate_locked;
+		case PAGEREF_KEEP:
+			goto keep_locked;
 		case PAGEREF_RECLAIM:
 		case PAGEREF_RECLAIM_CLEAN:
 			; /* try to reclaim the page below */
@@ -1359,9 +1386,7 @@ static void shrink_active_list(unsigned 
 			continue;
 		}
 
-		/* page_referenced clears PageReferenced */
-		if (page_mapped(page) &&
-		    page_referenced(page, 0, sc->mem_cgroup, &vm_flags)) {
+		if (page_referenced(page, 0, sc->mem_cgroup, &vm_flags)) {
 			nr_rotated++;
 			/*
 			 * Identify referenced, file-backed active pages and
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

bootmem-avoid-dma32-zone-by-default.patch

