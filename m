From: akpm@linux-foundation.org
Subject: + mm-further-cleanup-page_add_new_anon_rmap.patch added to -mm tree
Date: Mon, 24 Nov 2008 16:23:00 -0800
Message-ID: <200811250023.mAP0N0T5021794@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36034 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751724AbYKYAXv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Nov 2008 19:23:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, lee.schermerhorn@hp.com, nickpiggin@yahoo.com.au, riel@redhat.com


The patch titled
     mm: further cleanup page_add_new_anon_rmap
has been added to the -mm tree.  Its filename is
     mm-further-cleanup-page_add_new_anon_rmap.patch

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
Subject: mm: further cleanup page_add_new_anon_rmap
From: Hugh Dickins <hugh@veritas.com>

Moving lru_cache_add_active_or_unevictable() into page_add_new_anon_rmap()
was good but stupid: we can and should SetPageSwapBacked() there too; and
we know for sure that this anonymous, swap-backed page is not file cache.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    3 ---
 mm/rmap.c   |    6 +++---
 2 files changed, 3 insertions(+), 6 deletions(-)

diff -puN mm/memory.c~mm-further-cleanup-page_add_new_anon_rmap mm/memory.c
--- a/mm/memory.c~mm-further-cleanup-page_add_new_anon_rmap
+++ a/mm/memory.c
@@ -1919,7 +1919,6 @@ gotten:
 		 * thread doing COW.
 		 */
 		ptep_clear_flush_notify(vma, address, page_table);
-		SetPageSwapBacked(new_page);
 		page_add_new_anon_rmap(new_page, vma, address);
 		set_pte_at(mm, address, page_table, entry);
 		update_mmu_cache(vma, address, entry);
@@ -2415,7 +2414,6 @@ static int do_anonymous_page(struct mm_s
 	if (!pte_none(*page_table))
 		goto release;
 	inc_mm_counter(mm, anon_rss);
-	SetPageSwapBacked(page);
 	page_add_new_anon_rmap(page, vma, address);
 	set_pte_at(mm, address, page_table, entry);
 
@@ -2563,7 +2561,6 @@ static int __do_fault(struct mm_struct *
 			entry = maybe_mkwrite(pte_mkdirty(entry), vma);
 		if (anon) {
 			inc_mm_counter(mm, anon_rss);
-			SetPageSwapBacked(page);
 			page_add_new_anon_rmap(page, vma, address);
 		} else {
 			inc_mm_counter(mm, file_rss);
diff -puN mm/rmap.c~mm-further-cleanup-page_add_new_anon_rmap mm/rmap.c
--- a/mm/rmap.c~mm-further-cleanup-page_add_new_anon_rmap
+++ a/mm/rmap.c
@@ -47,7 +47,6 @@
 #include <linux/rmap.h>
 #include <linux/rcupdate.h>
 #include <linux/module.h>
-#include <linux/mm_inline.h>
 #include <linux/kallsyms.h>
 #include <linux/memcontrol.h>
 #include <linux/mmu_notifier.h>
@@ -673,10 +672,11 @@ void page_add_new_anon_rmap(struct page 
 	struct vm_area_struct *vma, unsigned long address)
 {
 	VM_BUG_ON(address < vma->vm_start || address >= vma->vm_end);
-	atomic_set(&page->_mapcount, 0); /* elevate count by 1 (starts at -1) */
+	SetPageSwapBacked(page);
+	atomic_set(&page->_mapcount, 0); /* increment count (starts at -1) */
 	__page_set_anon_rmap(page, vma, address);
 	if (page_evictable(page, vma))
-		lru_cache_add_lru(page, LRU_ACTIVE + page_is_file_cache(page));
+		lru_cache_add_lru(page, LRU_ACTIVE_ANON);
 	else
 		add_page_to_unevictable_list(page);
 }
_

Patches currently in -mm which might be from hugh@veritas.com are

linux-next.patch
mm-dont-mark_page_accessed-in-shmem_fault.patch
mm-apply_to_range-call-pte-function-with-lazy-updates.patch
mm-remove-cgroup_mm_owner_callbacks.patch
mm-remove-aop_writepage_activate.patch
mm-remove-gfp_highuser_pagecache.patch
mm-add-setclearpageswapcache-stubs.patch
mm-replace-some-bug_ons-by-vm_bug_ons.patch
mm-add_active_or_unevictable-into-rmap.patch
mm-make-page_lock_anon_vma-static.patch
mm-further-cleanup-page_add_new_anon_rmap.patch
memcg-handle-swap-caches.patch
memcg-handle-swap-caches-build-fix.patch
memcg-swap-cgroup-for-remembering-usage.patch
memcg-memswap-controller-core.patch
memcg-memswap-controller-core-make-resize-limit-hold-mutex.patch
prio_tree-debugging-patch.patch

