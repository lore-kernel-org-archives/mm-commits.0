From: akpm@linux-foundation.org
Subject: [merged] mm-clear_page_mlock-in-page_remove_rmap.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:13:43 -0700
Message-ID: <20121009181343.DD9311E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:44252 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756819Ab2JISNp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:13:45 -0400
Received: by mail-gh0-f202.google.com with SMTP id z15so661483ghb.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:13:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, hannes@cmpxchg.org, mel@csn.ul.ie, riel@redhat.com, walken@google.com, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use clear_page_mlock() in page_remove_rmap()
has been removed from the -mm tree.  Its filename was
     mm-clear_page_mlock-in-page_remove_rmap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: use clear_page_mlock() in page_remove_rmap()

We had thought that pages could no longer get freed while still marked as
mlocked; but Johannes Weiner posted this program to demonstrate that
truncating an mlocked private file mapping containing COWed pages is still
mishandled:

#include <sys/types.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <stdio.h>

int main(void)
{
	char *map;
	int fd;

	system("grep mlockfreed /proc/vmstat");
	fd = open("chigurh", O_CREAT|O_EXCL|O_RDWR);
	unlink("chigurh");
	ftruncate(fd, 4096);
	map = mmap(NULL, 4096, PROT_WRITE, MAP_PRIVATE, fd, 0);
	map[0] = 11;
	mlock(map, sizeof(fd));
	ftruncate(fd, 0);
	close(fd);
	munlock(map, sizeof(fd));
	munmap(map, 4096);
	system("grep mlockfreed /proc/vmstat");
	return 0;
}

The anon COWed pages are not caught by truncation's clear_page_mlock() of
the pagecache pages; but unmap_mapping_range() unmaps them, so we ought to
look out for them there in page_remove_rmap().  Indeed, why should
truncation or invalidation be doing the clear_page_mlock() when removing
from pagecache?  mlock is a property of mapping in userspace, not a
property of pagecache: an mlocked unmapped page is nonsensical.

Reported-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Ying Han <yinghan@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    7 +------
 mm/memory.c   |   10 +++++-----
 mm/mlock.c    |   16 +++-------------
 mm/rmap.c     |    4 ++++
 mm/truncate.c |    4 ----
 5 files changed, 13 insertions(+), 28 deletions(-)

diff -puN mm/internal.h~mm-clear_page_mlock-in-page_remove_rmap mm/internal.h
--- a/mm/internal.h~mm-clear_page_mlock-in-page_remove_rmap
+++ a/mm/internal.h
@@ -201,12 +201,7 @@ extern void munlock_vma_page(struct page
  * If called for a page that is still mapped by mlocked vmas, all we do
  * is revert to lazy LRU behaviour -- semantics are not broken.
  */
-extern void __clear_page_mlock(struct page *page);
-static inline void clear_page_mlock(struct page *page)
-{
-	if (unlikely(TestClearPageMlocked(page)))
-		__clear_page_mlock(page);
-}
+extern void clear_page_mlock(struct page *page);
 
 /*
  * mlock_migrate_page - called only from migrate_page_copy() to
diff -puN mm/memory.c~mm-clear_page_mlock-in-page_remove_rmap mm/memory.c
--- a/mm/memory.c~mm-clear_page_mlock-in-page_remove_rmap
+++ a/mm/memory.c
@@ -1577,12 +1577,12 @@ split_fallthrough:
 		if (page->mapping && trylock_page(page)) {
 			lru_add_drain();  /* push cached pages to LRU */
 			/*
-			 * Because we lock page here and migration is
-			 * blocked by the pte's page reference, we need
-			 * only check for file-cache page truncation.
+			 * Because we lock page here, and migration is
+			 * blocked by the pte's page reference, and we
+			 * know the page is still mapped, we don't even
+			 * need to check for file-cache page truncation.
 			 */
-			if (page->mapping)
-				mlock_vma_page(page);
+			mlock_vma_page(page);
 			unlock_page(page);
 		}
 	}
diff -puN mm/mlock.c~mm-clear_page_mlock-in-page_remove_rmap mm/mlock.c
--- a/mm/mlock.c~mm-clear_page_mlock-in-page_remove_rmap
+++ a/mm/mlock.c
@@ -51,13 +51,10 @@ EXPORT_SYMBOL(can_do_mlock);
 /*
  *  LRU accounting for clear_page_mlock()
  */
-void __clear_page_mlock(struct page *page)
+void clear_page_mlock(struct page *page)
 {
-	VM_BUG_ON(!PageLocked(page));
-
-	if (!page->mapping) {	/* truncated ? */
+	if (!TestClearPageMlocked(page))
 		return;
-	}
 
 	dec_zone_page_state(page, NR_MLOCK);
 	count_vm_event(UNEVICTABLE_PGCLEARED);
@@ -290,14 +287,7 @@ void munlock_vma_pages_range(struct vm_a
 		page = follow_page(vma, addr, FOLL_GET | FOLL_DUMP);
 		if (page && !IS_ERR(page)) {
 			lock_page(page);
-			/*
-			 * Like in __mlock_vma_pages_range(),
-			 * because we lock page here and migration is
-			 * blocked by the elevated reference, we need
-			 * only check for file-cache page truncation.
-			 */
-			if (page->mapping)
-				munlock_vma_page(page);
+			munlock_vma_page(page);
 			unlock_page(page);
 			put_page(page);
 		}
diff -puN mm/rmap.c~mm-clear_page_mlock-in-page_remove_rmap mm/rmap.c
--- a/mm/rmap.c~mm-clear_page_mlock-in-page_remove_rmap
+++ a/mm/rmap.c
@@ -1155,7 +1155,10 @@ void page_remove_rmap(struct page *page)
 	} else {
 		__dec_zone_page_state(page, NR_FILE_MAPPED);
 		mem_cgroup_dec_page_stat(page, MEMCG_NR_FILE_MAPPED);
+		mem_cgroup_end_update_page_stat(page, &locked, &flags);
 	}
+	if (unlikely(PageMlocked(page)))
+		clear_page_mlock(page);
 	/*
 	 * It would be tidy to reset the PageAnon mapping here,
 	 * but that might overwrite a racing page_add_anon_rmap
@@ -1165,6 +1168,7 @@ void page_remove_rmap(struct page *page)
 	 * Leaving it set also helps swapoff to reinstate ptes
 	 * faster for those pages still in swapcache.
 	 */
+	return;
 out:
 	if (!anon)
 		mem_cgroup_end_update_page_stat(page, &locked, &flags);
diff -puN mm/truncate.c~mm-clear_page_mlock-in-page_remove_rmap mm/truncate.c
--- a/mm/truncate.c~mm-clear_page_mlock-in-page_remove_rmap
+++ a/mm/truncate.c
@@ -107,7 +107,6 @@ truncate_complete_page(struct address_sp
 
 	cancel_dirty_page(page, PAGE_CACHE_SIZE);
 
-	clear_page_mlock(page);
 	ClearPageMappedToDisk(page);
 	delete_from_page_cache(page);
 	return 0;
@@ -132,7 +131,6 @@ invalidate_complete_page(struct address_
 	if (page_has_private(page) && !try_to_release_page(page, 0))
 		return 0;
 
-	clear_page_mlock(page);
 	ret = remove_mapping(mapping, page);
 
 	return ret;
@@ -394,8 +392,6 @@ invalidate_complete_page2(struct address
 	if (page_has_private(page) && !try_to_release_page(page, GFP_KERNEL))
 		return 0;
 
-	clear_page_mlock(page);
