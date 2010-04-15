From: akpm@linux-foundation.org
Subject: + rmap-add-exclusively-owned-pages-to-the-newest-anon_vma.patch added to -mm tree
Date: Thu, 15 Apr 2010 12:55:31 -0700
Message-ID: <201004151955.o3FJtXp4027662@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44451 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756328Ab0DOT4x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Apr 2010 15:56:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: riel@redhat.com, Lee.Schermerhorn@hp.com, aarcange@redhat.com, bp@alien8.de, hannes@cmpxchg.org, hugh.dickins@tiscali.co.uk, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, npiggin@suse.de, torvalds@linux-foundation.org


The patch titled
     rmap: add exclusively owned pages to the newest anon_vma
has been added to the -mm tree.  Its filename is
     rmap-add-exclusively-owned-pages-to-the-newest-anon_vma.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rmap: add exclusively owned pages to the newest anon_vma
From: Rik van Riel <riel@redhat.com>

The recent anon_vma fixes cause many anonymous pages to end up in the
parent process anon_vma, even when the page is exclusively owned by the
current process.

Adding exclusively owned anonymous pages to the top anon_vma reduces rmap
scanning overhead, especially in workloads with forking servers.

This patch adds a parameter to __page_set_anon_rmap that can be used to
indicate whether or not the added page is exclusively owned by the current
process.

Pages added through page_add_new_anon_rmap are exclusively owned by the
current process, and can be added to the top anon_vma.

Pages added through page_add_anon_rmap can be either shared or exclusively
owned, so we do the conservative thing and add it to the oldest anon_vma.

A next step would be to add the exclusive parameter to page_add_anon_rmap,
to be used from functions where we do know for sure whether a page is
exclusively owned.

Signed-off-by: Rik van Riel <riel@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff -puN mm/rmap.c~rmap-add-exclusively-owned-pages-to-the-newest-anon_vma mm/rmap.c
--- a/mm/rmap.c~rmap-add-exclusively-owned-pages-to-the-newest-anon_vma
+++ a/mm/rmap.c
@@ -730,23 +730,31 @@ void page_move_anon_rmap(struct page *pa
  * @page:	the page to add the mapping to
  * @vma:	the vm area in which the mapping is added
  * @address:	the user virtual address mapped
+ * @exclusive:  the page is exclusively owned by the current process
  */
 static void __page_set_anon_rmap(struct page *page,
-	struct vm_area_struct *vma, unsigned long address)
+	struct vm_area_struct *vma, unsigned long address, int exclusive)
 {
 	struct anon_vma_chain *avc;
 	struct anon_vma *anon_vma;
 
 	BUG_ON(!vma->anon_vma);
 
-	/*
-	 * We must use the _oldest_ possible anon_vma for the page mapping!
-	 *
-	 * So take the last AVC chain entry in the vma, which is the deepest
-	 * ancestor, and use the anon_vma from that.
-	 */
-	avc = list_entry(vma->anon_vma_chain.prev, struct anon_vma_chain, same_vma);
-	anon_vma = avc->anon_vma;
+	if (exclusive)
+		anon_vma = vma->anon_vma;
+	else {
+		/*
+		 * The page may be shared between multiple processes.
+		 * We must use the _oldest_ possible anon_vma for the
+		 * page mapping!  That anon_vma is guaranteed to be
+		 * present in all processes that could share this page.
+		 *
+		 * So take the last AVC chain entry in the vma, which is the
+		 * deepest ancestor, and use the anon_vma from that.
+		 */
+		avc = list_entry(vma->anon_vma_chain.prev, struct anon_vma_chain, same_vma);
+		anon_vma = avc->anon_vma;
+	}
 
 	anon_vma = (void *) anon_vma + PAGE_MAPPING_ANON;
 	page->mapping = (struct address_space *) anon_vma;
@@ -802,7 +810,7 @@ void page_add_anon_rmap(struct page *pag
 	VM_BUG_ON(!PageLocked(page));
 	VM_BUG_ON(address < vma->vm_start || address >= vma->vm_end);
 	if (first)
-		__page_set_anon_rmap(page, vma, address);
+		__page_set_anon_rmap(page, vma, address, 0);
 	else
 		__page_check_anon_rmap(page, vma, address);
 }
@@ -824,7 +832,7 @@ void page_add_new_anon_rmap(struct page 
 	SetPageSwapBacked(page);
 	atomic_set(&page->_mapcount, 0); /* increment count (starts at -1) */
 	__inc_zone_page_state(page, NR_ANON_PAGES);
-	__page_set_anon_rmap(page, vma, address);
+	__page_set_anon_rmap(page, vma, address, 1);
 	if (page_evictable(page, vma))
 		lru_cache_add_lru(page, LRU_ACTIVE_ANON);
 	else
_

Patches currently in -mm which might be from riel@redhat.com are

rmap-add-exclusively-owned-pages-to-the-newest-anon_vma.patch
powerpc-add-rcu_read_lock-to-gup_fast-implementation.patch
page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists.patch
mm-remove-return-value-of-putback_lru_pages.patch
oom-filter-tasks-not-sharing-the-same-cpuset.patch
oom-sacrifice-child-with-highest-badness-score-for-parent.patch
oom-select-task-from-tasklist-for-mempolicy-ooms.patch
oom-remove-special-handling-for-pagefault-ooms.patch
oom-badness-heuristic-rewrite.patch
oom-deprecate-oom_adj-tunable.patch
oom-replace-sysctls-with-quick-mode.patch
oom-avoid-oom-killer-for-lowmem-allocations.patch
oom-remove-unnecessary-code-and-cleanup.patch
oom-default-to-killing-current-for-pagefault-ooms.patch
oom-avoid-race-for-oom-killed-tasks-detaching-mm-prior-to-exit.patch
oom-hold-tasklist_lock-when-dumping-tasks.patch
oom-give-current-access-to-memory-reserves-if-it-has-been-killed.patch
oom-avoid-sending-exiting-tasks-a-sigkill.patch
oom-clean-up-oom_kill_task.patch
oom-clean-up-oom_badness.patch
mm-migration-take-a-reference-to-the-anon_vma-before-migrating.patch
mm-migration-do-not-try-to-migrate-unmapped-anonymous-pages.patch
mm-share-the-anon_vma-ref-counts-between-ksm-and-page-migration.patch
mm-allow-config_migration-to-be-set-without-config_numa-or-memory-hot-remove.patch
mm-allow-config_migration-to-be-set-without-config_numa-or-memory-hot-remove-fix.patch
mm-export-unusable-free-space-index-via-proc-unusable_index.patch
mm-export-unusable-free-space-index-via-proc-unusable_index-fix.patch
mm-export-fragmentation-index-via-proc-extfrag_index.patch
mm-export-fragmentation-index-via-proc-extfrag_index-fix.patch
mm-move-definition-for-lru-isolation-modes-to-a-header.patch
mm-compaction-memory-compaction-core.patch
mm-compaction-memory-compaction-core-fix.patch
mm-compaction-add-proc-trigger-for-memory-compaction.patch
mm-compaction-add-proc-trigger-for-memory-compaction-fix.patch
mm-compaction-add-proc-trigger-for-memory-compaction-fix-fix.patch
mm-compaction-add-sys-trigger-for-per-node-memory-compaction.patch
mm-compaction-direct-compact-when-a-high-order-allocation-fails.patch
mm-compaction-direct-compact-when-a-high-order-allocation-fails-reject-fix.patch
mm-compaction-add-a-tunable-that-decides-when-memory-should-be-compacted-and-when-it-should-be-reclaimed.patch
mm-migration-allow-the-migration-of-pageswapcache-pages.patch
mm-migration-allow-the-migration-of-pageswapcache-pages-fix.patch
mm-compaction-do-not-display-compaction-related-stats-when-config_compaction.patch
mm-revalidate-anon_vma-in-page_lock_anon_vma.patch
vmscan-prevent-get_scan_ratio-rounding-errors.patch

