From: akpm@linux-foundation.org
Subject: [merged] mm-config_mmu-for-pg_mlocked.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:52:27 -0800
Message-ID: <200912152152.nBFLqRO7015195@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55380 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761176AbZLOVxV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:53:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh.dickins@tiscali.co.uk, Lee.Schermerhorn@hp.com, aarcange@redhat.com, andi@firstfloor.org, fengguang.wu@intel.com, ieidus@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohi


The patch titled
     mm: CONFIG_MMU for PG_mlocked
has been removed from the -mm tree.  Its filename was
     mm-config_mmu-for-pg_mlocked.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: CONFIG_MMU for PG_mlocked
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

Remove three degrees of obfuscation, left over from when we had
CONFIG_UNEVICTABLE_LRU.  MLOCK_PAGES is CONFIG_HAVE_MLOCKED_PAGE_BIT is
CONFIG_HAVE_MLOCK is CONFIG_MMU.  rmap.o (and memory-failure.o) are only
built when CONFIG_MMU, so don't need such conditions at all.

Somehow, I feel no compulsion to remove the CONFIG_HAVE_MLOCK* lines from
169 defconfigs: leave those to evolve in due course.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Izik Eidus <ieidus@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Nick Piggin <npiggin@suse.de>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    8 +++-----
 mm/Kconfig                 |    8 --------
 mm/internal.h              |   26 ++++++++++++--------------
 mm/memory-failure.c        |    2 --
 mm/page_alloc.c            |    4 ----
 mm/rmap.c                  |   15 ++++-----------
 6 files changed, 19 insertions(+), 44 deletions(-)

diff -puN include/linux/page-flags.h~mm-config_mmu-for-pg_mlocked include/linux/page-flags.h
--- a/include/linux/page-flags.h~mm-config_mmu-for-pg_mlocked
+++ a/include/linux/page-flags.h
@@ -99,7 +99,7 @@ enum pageflags {
 	PG_buddy,		/* Page is free, on buddy lists */
 	PG_swapbacked,		/* Page is backed by RAM/swap */
 	PG_unevictable,		/* Page is "unevictable"  */
-#ifdef CONFIG_HAVE_MLOCKED_PAGE_BIT
+#ifdef CONFIG_MMU
 	PG_mlocked,		/* Page is vma mlocked */
 #endif
 #ifdef CONFIG_ARCH_USES_PG_UNCACHED
@@ -259,12 +259,10 @@ PAGEFLAG_FALSE(SwapCache)
 PAGEFLAG(Unevictable, unevictable) __CLEARPAGEFLAG(Unevictable, unevictable)
 	TESTCLEARFLAG(Unevictable, unevictable)
 
-#ifdef CONFIG_HAVE_MLOCKED_PAGE_BIT
-#define MLOCK_PAGES 1
+#ifdef CONFIG_MMU
 PAGEFLAG(Mlocked, mlocked) __CLEARPAGEFLAG(Mlocked, mlocked)
 	TESTSCFLAG(Mlocked, mlocked) __TESTCLEARFLAG(Mlocked, mlocked)
 #else
-#define MLOCK_PAGES 0
 PAGEFLAG_FALSE(Mlocked) SETPAGEFLAG_NOOP(Mlocked)
 	TESTCLEARFLAG_FALSE(Mlocked) __TESTCLEARFLAG_FALSE(Mlocked)
 #endif
@@ -393,7 +391,7 @@ static inline void __ClearPageTail(struc
 
 #endif /* !PAGEFLAGS_EXTENDED */
 
-#ifdef CONFIG_HAVE_MLOCKED_PAGE_BIT
+#ifdef CONFIG_MMU
 #define __PG_MLOCKED		(1 << PG_mlocked)
 #else
 #define __PG_MLOCKED		0
diff -puN mm/Kconfig~mm-config_mmu-for-pg_mlocked mm/Kconfig
--- a/mm/Kconfig~mm-config_mmu-for-pg_mlocked
+++ a/mm/Kconfig
@@ -200,14 +200,6 @@ config VIRT_TO_BUS
 	def_bool y
 	depends on !ARCH_NO_VIRT_TO_BUS
 
-config HAVE_MLOCK
-	bool
-	default y if MMU=y
-
-config HAVE_MLOCKED_PAGE_BIT
-	bool
-	default y if HAVE_MLOCK=y
-
 config MMU_NOTIFIER
 	bool
 
diff -puN mm/internal.h~mm-config_mmu-for-pg_mlocked mm/internal.h
--- a/mm/internal.h~mm-config_mmu-for-pg_mlocked
+++ a/mm/internal.h
@@ -63,17 +63,6 @@ static inline unsigned long page_order(s
 	return page_private(page);
 }
 
-#ifdef CONFIG_HAVE_MLOCK
-extern long mlock_vma_pages_range(struct vm_area_struct *vma,
-			unsigned long start, unsigned long end);
-extern void munlock_vma_pages_range(struct vm_area_struct *vma,
-			unsigned long start, unsigned long end);
-static inline void munlock_vma_pages_all(struct vm_area_struct *vma)
-{
-	munlock_vma_pages_range(vma, vma->vm_start, vma->vm_end);
-}
-#endif
-
 /*
  * unevictable_migrate_page() called only from migrate_page_copy() to
  * migrate unevictable flag to new page.
@@ -86,7 +75,16 @@ static inline void unevictable_migrate_p
 		SetPageUnevictable(new);
 }
 
-#ifdef CONFIG_HAVE_MLOCKED_PAGE_BIT
+#ifdef CONFIG_MMU
+extern long mlock_vma_pages_range(struct vm_area_struct *vma,
+			unsigned long start, unsigned long end);
+extern void munlock_vma_pages_range(struct vm_area_struct *vma,
+			unsigned long start, unsigned long end);
+static inline void munlock_vma_pages_all(struct vm_area_struct *vma)
+{
+	munlock_vma_pages_range(vma, vma->vm_start, vma->vm_end);
+}
+
 /*
  * Called only in fault path via page_evictable() for a new page
  * to determine if it's being mapped into a LOCKED vma.
@@ -144,7 +142,7 @@ static inline void mlock_migrate_page(st
 	}
 }
 
-#else /* CONFIG_HAVE_MLOCKED_PAGE_BIT */
+#else /* !CONFIG_MMU */
 static inline int is_mlocked_vma(struct vm_area_struct *v, struct page *p)
 {
 	return 0;
@@ -153,7 +151,7 @@ static inline void clear_page_mlock(stru
 static inline void mlock_vma_page(struct page *page) { }
 static inline void mlock_migrate_page(struct page *new, struct page *old) { }
 
-#endif /* CONFIG_HAVE_MLOCKED_PAGE_BIT */
+#endif /* !CONFIG_MMU */
 
 /*
  * Return the mem_map entry representing the 'offset' subpage within
diff -puN mm/memory-failure.c~mm-config_mmu-for-pg_mlocked mm/memory-failure.c
--- a/mm/memory-failure.c~mm-config_mmu-for-pg_mlocked
+++ a/mm/memory-failure.c
@@ -582,10 +582,8 @@ static struct page_state {
 	{ unevict|dirty, unevict|dirty,	"unevictable LRU", me_pagecache_dirty},
 	{ unevict,	unevict,	"unevictable LRU", me_pagecache_clean},
 
-#ifdef CONFIG_HAVE_MLOCKED_PAGE_BIT
 	{ mlock|dirty,	mlock|dirty,	"mlocked LRU",	me_pagecache_dirty },
 	{ mlock,	mlock,		"mlocked LRU",	me_pagecache_clean },
-#endif
 
 	{ lru|dirty,	lru|dirty,	"LRU",		me_pagecache_dirty },
 	{ lru|dirty,	lru,		"clean LRU",	me_pagecache_clean },
diff -puN mm/page_alloc.c~mm-config_mmu-for-pg_mlocked mm/page_alloc.c
--- a/mm/page_alloc.c~mm-config_mmu-for-pg_mlocked
+++ a/mm/page_alloc.c
@@ -486,7 +486,6 @@ static inline void __free_one_page(struc
 	zone->free_area[order].nr_free++;
 }
 
-#ifdef CONFIG_HAVE_MLOCKED_PAGE_BIT
 /*
  * free_page_mlock() -- clean up attempts to free and mlocked() page.
  * Page should not be on lru, so no need to fix that up.
@@ -497,9 +496,6 @@ static inline void free_page_mlock(struc
 	__dec_zone_page_state(page, NR_MLOCK);
 	__count_vm_event(UNEVICTABLE_MLOCKFREED);
 }
-#else
-static void free_page_mlock(struct page *page) { }
-#endif
 
 static inline int free_pages_check(struct page *page)
 {
diff -puN mm/rmap.c~mm-config_mmu-for-pg_mlocked mm/rmap.c
--- a/mm/rmap.c~mm-config_mmu-for-pg_mlocked
+++ a/mm/rmap.c
@@ -788,7 +788,7 @@ static int try_to_unmap_one(struct page 
 			ret = SWAP_MLOCK;
 			goto out_unmap;
 		}
-		if (MLOCK_PAGES && TTU_ACTION(flags) == TTU_MUNLOCK)
+		if (TTU_ACTION(flags) == TTU_MUNLOCK)
 			goto out_unmap;
 	}
 	if (!(flags & TTU_IGNORE_ACCESS)) {
@@ -861,7 +861,7 @@ static int try_to_unmap_one(struct page 
 out_unmap:
 	pte_unmap_unlock(pte, ptl);
 
-	if (MLOCK_PAGES && ret == SWAP_MLOCK) {
+	if (ret == SWAP_MLOCK) {
 		ret = SWAP_AGAIN;
 		if (down_read_trylock(&vma->vm_mm->mmap_sem)) {
 			if (vma->vm_flags & VM_LOCKED) {
@@ -938,11 +938,10 @@ static int try_to_unmap_cluster(unsigned
 		return ret;
 
 	/*
-	 * MLOCK_PAGES => feature is configured.
-	 * if we can acquire the mmap_sem for read, and vma is VM_LOCKED,
+	 * If we can acquire the mmap_sem for read, and vma is VM_LOCKED,
 	 * keep the sem while scanning the cluster for mlocking pages.
 	 */
-	if (MLOCK_PAGES && down_read_trylock(&vma->vm_mm->mmap_sem)) {
+	if (down_read_trylock(&vma->vm_mm->mmap_sem)) {
 		locked_vma = (vma->vm_flags & VM_LOCKED);
 		if (!locked_vma)
 			up_read(&vma->vm_mm->mmap_sem); /* don't need it */
@@ -1075,9 +1074,6 @@ static int try_to_unmap_file(struct page
 
 	list_for_each_entry(vma, &mapping->i_mmap_nonlinear,
 						shared.vm_set.list) {
-		if (!MLOCK_PAGES && !(flags & TTU_IGNORE_MLOCK) &&
-			(vma->vm_flags & VM_LOCKED))
-			continue;
 		cursor = (unsigned long) vma->vm_private_data;
 		if (cursor > max_nl_cursor)
 			max_nl_cursor = cursor;
@@ -1110,9 +1106,6 @@ static int try_to_unmap_file(struct page
 	do {
 		list_for_each_entry(vma, &mapping->i_mmap_nonlinear,
 						shared.vm_set.list) {
-			if (!MLOCK_PAGES && !(flags & TTU_IGNORE_MLOCK) &&
-			    (vma->vm_flags & VM_LOCKED))
-				continue;
 			cursor = (unsigned long) vma->vm_private_data;
 			while ( cursor < max_nl_cursor &&
 				cursor < vma->vm_end - vma->vm_start) {
_

Patches currently in -mm which might be from hugh.dickins@tiscali.co.uk are

origin.patch
linux-next.patch
vfs-fsstack-handle-32-bit-smp-preempt-large-files-in-fsstack_copy_inode_size.patch
ksm-memory-hotremove-migration-only-fix.patch
elf-kill-use_elf_core_dump.patch
prio_tree-debugging-patch.patch

