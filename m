From: akpm@linux-foundation.org
Subject: [merged] ksm-fix-mlockfreed-to-munlocked.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:53:30 -0800
Message-ID: <200912152153.nBFLrUfv015283@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49886 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761281AbZLOVyS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:54:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh.dickins@tiscali.co.uk, aarcange@redhat.com, chrisw@redhat.com, ieidus@redhat.com, mel@csn.ul.ie, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ksm: fix mlockfreed to munlocked
has been removed from the -mm tree.  Its filename was
     ksm-fix-mlockfreed-to-munlocked.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ksm: fix mlockfreed to munlocked
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

When KSM merges an mlocked page, it has been forgetting to munlock it:
that's been left to free_page_mlock(), which reports it in /proc/vmstat as
unevictable_pgs_mlockfreed instead of unevictable_pgs_munlocked (and
whinges "Page flag mlocked set for process" in mmotm, whereas mainline is
silently forgiving).  Call munlock_vma_page() to fix that.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Izik Eidus <ieidus@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Chris Wright <chrisw@redhat.com>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    3 ++-
 mm/ksm.c      |    4 ++++
 mm/mlock.c    |    4 ++--
 3 files changed, 8 insertions(+), 3 deletions(-)

diff -puN mm/internal.h~ksm-fix-mlockfreed-to-munlocked mm/internal.h
--- a/mm/internal.h~ksm-fix-mlockfreed-to-munlocked
+++ a/mm/internal.h
@@ -105,9 +105,10 @@ static inline int is_mlocked_vma(struct 
 }
 
 /*
- * must be called with vma's mmap_sem held for read, and page locked.
+ * must be called with vma's mmap_sem held for read or write, and page locked.
  */
 extern void mlock_vma_page(struct page *page);
+extern void munlock_vma_page(struct page *page);
 
 /*
  * Clear the page's PageMlocked().  This can be useful in a situation where
diff -puN mm/ksm.c~ksm-fix-mlockfreed-to-munlocked mm/ksm.c
--- a/mm/ksm.c~ksm-fix-mlockfreed-to-munlocked
+++ a/mm/ksm.c
@@ -34,6 +34,7 @@
 #include <linux/ksm.h>
 
 #include <asm/tlbflush.h>
+#include "internal.h"
 
 /*
  * A few notes about the KSM scanning process,
@@ -762,6 +763,9 @@ static int try_to_merge_one_page(struct 
 	    pages_identical(page, kpage))
 		err = replace_page(vma, page, kpage, orig_pte);
 
+	if ((vma->vm_flags & VM_LOCKED) && !err)
+		munlock_vma_page(page);
+
 	unlock_page(page);
 out:
 	return err;
diff -puN mm/mlock.c~ksm-fix-mlockfreed-to-munlocked mm/mlock.c
--- a/mm/mlock.c~ksm-fix-mlockfreed-to-munlocked
+++ a/mm/mlock.c
@@ -99,14 +99,14 @@ void mlock_vma_page(struct page *page)
  * not get another chance to clear PageMlocked.  If we successfully
  * isolate the page and try_to_munlock() detects other VM_LOCKED vmas
  * mapping the page, it will restore the PageMlocked state, unless the page
- * is mapped in a non-linear vma.  So, we go ahead and SetPageMlocked(),
+ * is mapped in a non-linear vma.  So, we go ahead and ClearPageMlocked(),
  * perhaps redundantly.
  * If we lose the isolation race, and the page is mapped by other VM_LOCKED
  * vmas, we'll detect this in vmscan--via try_to_munlock() or try_to_unmap()
  * either of which will restore the PageMlocked state by calling
  * mlock_vma_page() above, if it can grab the vma's mmap sem.
  */
-static void munlock_vma_page(struct page *page)
+void munlock_vma_page(struct page *page)
 {
 	BUG_ON(!PageLocked(page));
 
_

Patches currently in -mm which might be from hugh.dickins@tiscali.co.uk are

origin.patch
linux-next.patch
vfs-fsstack-handle-32-bit-smp-preempt-large-files-in-fsstack_copy_inode_size.patch
ksm-memory-hotremove-migration-only-fix.patch
elf-kill-use_elf_core_dump.patch
prio_tree-debugging-patch.patch

