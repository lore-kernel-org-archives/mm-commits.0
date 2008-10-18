From: akpm@linux-foundation.org
Subject: - mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-update-locked_vm-on-munmap-of-mlocked-region.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:37:55 -0700
Message-ID: <200810182337.m9INbtNS032336@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39528 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752047AbYJRXiA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:38:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lee.schermerhorn@hp.com, kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     mlock: update locked_vm on munmap() of mlocked() region.
has been removed from the -mm tree.  Its filename was
     mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-update-locked_vm-on-munmap-of-mlocked-region.patch

This patch was dropped because it was folded into mmap-handle-mlocked-pages-during-map-remap-unmap.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mlock: update locked_vm on munmap() of mlocked() region.
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

munlock_vma_pages_range() clears VM_LOCKED for munlock_vma_page(), et al
to work.  This causes remove_vma_list(), called from do_munmap(), to skip
updating locked_vm.

We don't want to restore the VM_LOCKED in munlock_vma_pages_range()
because the pages are still on the lru.  If vmscan attempts to reclaim
any of these pages before we get a chance to unmap them,
try_to_un{lock|map}() may mlock them again.  This will result in freeing
an mlocked page.

	Add comment block to munlock_vma_pages_range() to explain
	this to future would be callers.

Move the accounting of locked_vm from remove_vma_list() to the munlock
loop in do_munmap().  This is where the pages are munlocked and VM_LOCKED
is cleared.  Note that remove_vma_list() is a helper function for
do_munmap(), called only from there.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |   17 ++++++++++++++++-
 mm/mmap.c  |    6 +++---
 2 files changed, 19 insertions(+), 4 deletions(-)

diff -puN mm/mlock.c~mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-update-locked_vm-on-munmap-of-mlocked-region mm/mlock.c
--- a/mm/mlock.c~mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-update-locked_vm-on-munmap-of-mlocked-region
+++ a/mm/mlock.c
@@ -304,7 +304,22 @@ no_mlock:
 
 
 /*
- * munlock all pages in the vma range.   For mremap(), munmap() and exit().
+ * munlock_vma_pages_range() - munlock all pages in the vma range.'
+ * @vma - vma containing range to be munlock()ed.
+ * @start - start address in @vma of the range
+ * @end - end of range in @vma.
+ *
+ *  For mremap(), munmap() and exit().
+ *
+ * Called with @vma VM_LOCKED.
+ *
+ * Returns with VM_LOCKED cleared.  Callers must be prepared to
+ * deal with this.
+ *
+ * We don't save and restore VM_LOCKED here because pages are
+ * still on lru.  In unmap path, pages might be scanned by reclaim
+ * and re-mlocked by try_to_{munlock|unmap} before we unmap and
+ * free them.  This will result in freeing mlocked pages.
  */
 void munlock_vma_pages_range(struct vm_area_struct *vma,
 			   unsigned long start, unsigned long end)
diff -puN mm/mmap.c~mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-update-locked_vm-on-munmap-of-mlocked-region mm/mmap.c
--- a/mm/mmap.c~mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-update-locked_vm-on-munmap-of-mlocked-region
+++ a/mm/mmap.c
@@ -1756,8 +1756,6 @@ static void remove_vma_list(struct mm_st
 		long nrpages = vma_pages(vma);
 
 		mm->total_vm -= nrpages;
-		if (vma->vm_flags & VM_LOCKED)
-			mm->locked_vm -= nrpages;
 		vm_stat_account(mm, vma->vm_flags, vma->vm_file, -nrpages);
 		vma = remove_vma(vma);
 	} while (vma);
@@ -1928,8 +1926,10 @@ int do_munmap(struct mm_struct *mm, unsi
 	if (mm->locked_vm) {
 		struct vm_area_struct *tmp = vma;
 		while (tmp && tmp->vm_start < end) {
-			if (tmp->vm_flags & VM_LOCKED)
+			if (tmp->vm_flags & VM_LOCKED) {
+				mm->locked_vm -= vma_pages(tmp);
 				munlock_vma_pages_all(tmp);
+			}
 			tmp = tmp->vm_next;
 		}
 	}
_

Patches currently in -mm which might be from lee.schermerhorn@hp.com are

vmscan-use-an-indexed-array-for-lru-variables.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
pageflag-helpers-for-configed-out-flags.patch
unevictable-lru-infrastructure.patch
unevictable-infrastructure-lru-add-event-counting-with-statistics.patch
unevictable-lru-page-statistics.patch
ramfs-and-ram-disk-pages-are-unevictable.patch
shm_locked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable.patch
doc-unevictable-lru-and-mlocked-pages-documentation.patch
mlock-downgrade-mmap-sem-while-populating-mlocked-regions.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-update-locked_vm-on-munmap-of-mlocked-region.patch
vmstat-mlocked-pages-statistics.patch
vmstat-mlocked-pages-statistics-mlocked-pages-add-event-counting-with-statistics.patch
swap-cull-unevictable-pages-in-fault-path.patch
vmscan-unevictable-lru-scan-sysctl.patch
mlock-count-attempts-to-free-mlocked-page-2.patch
mlock-revert-mainline-handling-of-mlock-error-return.patch
mlock-make-mlock-error-return-posixly-correct.patch
mlock-make-mlock-error-return-posixly-correct-fix.patch

