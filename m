From: akpm@linux-foundation.org
Subject: - vmscan-handle-mlocked-pages-during-map-remap-unmap.patch removed from -mm tree
Date: Wed, 11 Jun 2008 12:46:38 -0700
Message-ID: <200806111946.m5BJkccT014604@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59299 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753520AbYFKTq7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Jun 2008 15:46:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: riel@redhat.com, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     vmscan: handle mlocked pages during map, remap, unmap
has been removed from the -mm tree.  Its filename was
     vmscan-handle-mlocked-pages-during-map-remap-unmap.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: handle mlocked pages during map, remap, unmap
From: Rik van Riel <riel@redhat.com>

Originally from Nick Piggin <npiggin@suse.de>

Remove mlocked pages from the LRU using "NoReclaim infrastructure" during
mmap(), munmap(), mremap() and truncate().  Try to move back to normal LRU
lists on munmap() when last mlocked mapping removed.  Removed
PageMlocked() status when page truncated from file.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/fremap.c   |   26 ++++++++++++++--
 mm/internal.h |   13 +++++++-
 mm/mlock.c    |   10 +++---
 mm/mmap.c     |   75 +++++++++++++++++++++++++++++++++++++-----------
 mm/mremap.c   |    8 +++--
 mm/truncate.c |    4 ++
 6 files changed, 106 insertions(+), 30 deletions(-)

diff -puN mm/fremap.c~vmscan-handle-mlocked-pages-during-map-remap-unmap mm/fremap.c
--- a/mm/fremap.c~vmscan-handle-mlocked-pages-during-map-remap-unmap
+++ a/mm/fremap.c
@@ -20,6 +20,8 @@
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
 
+#include "internal.h"
+
 static void zap_pte(struct mm_struct *mm, struct vm_area_struct *vma,
 			unsigned long addr, pte_t *ptep)
 {
@@ -214,13 +216,29 @@ asmlinkage long sys_remap_file_pages(uns
 		spin_unlock(&mapping->i_mmap_lock);
 	}
 
+	if (vma->vm_flags & VM_LOCKED) {
+		/*
+		 * drop PG_Mlocked flag for over-mapped range
+		 */
+		unsigned int saved_flags = vma->vm_flags;
+		munlock_vma_pages_range(vma, start, start + size);
+		vma->vm_flags = saved_flags;
+	}
+
 	err = populate_range(mm, vma, start, size, pgoff);
 	if (!err && !(flags & MAP_NONBLOCK)) {
-		if (unlikely(has_write_lock)) {
-			downgrade_write(&mm->mmap_sem);
-			has_write_lock = 0;
+		if (vma->vm_flags & VM_LOCKED) {
+			/*
+			 * might be mapping previously unmapped range of file
+			 */
+			mlock_vma_pages_range(vma, start, start + size);
+		} else {
+			if (unlikely(has_write_lock)) {
+				downgrade_write(&mm->mmap_sem);
+				has_write_lock = 0;
+			}
+			make_pages_present(start, start+size);
 		}
-		make_pages_present(start, start+size);
 	}
 
 	/*
diff -puN mm/internal.h~vmscan-handle-mlocked-pages-during-map-remap-unmap mm/internal.h
--- a/mm/internal.h~vmscan-handle-mlocked-pages-during-map-remap-unmap
+++ a/mm/internal.h
@@ -68,9 +68,18 @@ extern int mlock_vma_pages_range(struct 
 			unsigned long start, unsigned long end);
 
 /*
- * munlock all pages in vma.   For munmap() and exit().
+ * munlock all pages in vma range.   For mremap().
  */
-extern void munlock_vma_pages_all(struct vm_area_struct *vma);
+extern void munlock_vma_pages_range(struct vm_area_struct *vma,
+			       unsigned long start, unsigned long end);
+
+/*
+ * munlock all pages in vma.   For munmap and exit().
+ */
+static inline void munlock_vma_pages_all(struct vm_area_struct *vma)
+{
+	munlock_vma_pages_range(vma, vma->vm_start, vma->vm_end);
+}
 
 #ifdef CONFIG_NORECLAIM_LRU
 /*
diff -puN mm/mlock.c~vmscan-handle-mlocked-pages-during-map-remap-unmap mm/mlock.c
--- a/mm/mlock.c~vmscan-handle-mlocked-pages-during-map-remap-unmap
+++ a/mm/mlock.c
@@ -270,7 +270,8 @@ static void __munlock_vma_pages_range(st
 	struct munlock_page_walk mpw;
 
 	VM_BUG_ON(start & ~PAGE_MASK || end & ~PAGE_MASK);
-	VM_BUG_ON(!rwsem_is_locked(&vma->vm_mm->mmap_sem));
+	VM_BUG_ON((!rwsem_is_locked(&vma->vm_mm->mmap_sem)) &&
+		  (atomic_read(&mm->mm_users) != 0));
 	VM_BUG_ON(start < vma->vm_start);
 	VM_BUG_ON(end > vma->vm_end);
 
@@ -354,12 +355,13 @@ no_mlock:
 
 
 /*
- * munlock all pages in vma.   For munmap() and exit().
+ * munlock all pages in the vma range.   For mremap(), munmap() and exit().
  */
-void munlock_vma_pages_all(struct vm_area_struct *vma)
+void munlock_vma_pages_range(struct vm_area_struct *vma,
+			   unsigned long start, unsigned long end)
 {
 	vma->vm_flags &= ~VM_LOCKED;
-	__munlock_vma_pages_range(vma, vma->vm_start, vma->vm_end);
+	__munlock_vma_pages_range(vma, start, end);
 }
 
 /*
diff -puN mm/mmap.c~vmscan-handle-mlocked-pages-during-map-remap-unmap mm/mmap.c
--- a/mm/mmap.c~vmscan-handle-mlocked-pages-during-map-remap-unmap
+++ a/mm/mmap.c
@@ -35,6 +35,8 @@
 
 #include "internal.h"
 
+#include "internal.h"
+
 #ifndef arch_mmap_check
 #define arch_mmap_check(addr, len, flags)	(0)
 #endif
@@ -970,6 +972,7 @@ unsigned long do_mmap_pgoff(struct file 
 			return -EPERM;
 		vm_flags |= VM_LOCKED;
 	}
+
 	/* mlock MCL_FUTURE? */
 	if (vm_flags & VM_LOCKED) {
 		unsigned long locked, lock_limit;
@@ -1133,10 +1136,12 @@ munmap_back:
 	 * The VM_SHARED test is necessary because shmem_zero_setup
 	 * will create the file object for a shared anonymous map below.
 	 */
-	if (!file && !(vm_flags & VM_SHARED) &&
-	    vma_merge(mm, prev, addr, addr + len, vm_flags,
-					NULL, NULL, pgoff, NULL))
-		goto out;
+	if (!file && !(vm_flags & VM_SHARED)) {
+		vma = vma_merge(mm, prev, addr, addr + len, vm_flags,
+					NULL, NULL, pgoff, NULL);
+		if (vma)
+			goto out;
+	}
 
 	/*
 	 * Determine the object being mapped and call the appropriate
@@ -1218,10 +1223,14 @@ out:
 	mm->total_vm += len >> PAGE_SHIFT;
 	vm_stat_account(mm, vm_flags, file, len >> PAGE_SHIFT);
 	if (vm_flags & VM_LOCKED) {
-		mm->locked_vm += len >> PAGE_SHIFT;
-		make_pages_present(addr, addr + len);
-	}
-	if ((flags & MAP_POPULATE) && !(flags & MAP_NONBLOCK))
+		/*
+		 * makes pages present; downgrades, drops, reacquires mmap_sem
+		 */
+		int nr_pages = mlock_vma_pages_range(vma, addr, addr + len);
+		if (nr_pages < 0)
+			return nr_pages;	/* vma gone! */
+		mm->locked_vm += (len >> PAGE_SHIFT) - nr_pages;
+	} else if ((flags & MAP_POPULATE) && !(flags & MAP_NONBLOCK))
 		make_pages_present(addr, addr + len);
 	return addr;
 
@@ -1694,8 +1703,11 @@ find_extend_vma(struct mm_struct *mm, un
 		return vma;
 	if (!prev || expand_stack(prev, addr))
 		return NULL;
-	if (prev->vm_flags & VM_LOCKED)
-		make_pages_present(addr, prev->vm_end);
+	if (prev->vm_flags & VM_LOCKED) {
+		int nr_pages = mlock_vma_pages_range(prev, addr, prev->vm_end);
+		if (nr_pages < 0)
+			return NULL;	/* vma gone! */
+	}
 	return prev;
 }
 #else
@@ -1721,8 +1733,11 @@ find_extend_vma(struct mm_struct * mm, u
 	start = vma->vm_start;
 	if (expand_stack(vma, addr))
 		return NULL;
-	if (vma->vm_flags & VM_LOCKED)
-		make_pages_present(addr, start);
+	if (vma->vm_flags & VM_LOCKED) {
+		int nr_pages = mlock_vma_pages_range(vma, addr, start);
+		if (nr_pages < 0)
+			return NULL;	/* vma gone! */
+	}
 	return vma;
 }
 #endif
@@ -1909,6 +1924,18 @@ int do_munmap(struct mm_struct *mm, unsi
 	vma = prev? prev->vm_next: mm->mmap;
 
 	/*
+	 * unlock any mlock()ed ranges before detaching vmas
+	 */
+	if (mm->locked_vm) {
+		struct vm_area_struct *tmp = vma;
+		while (tmp && tmp->vm_start < end) {
+			if (tmp->vm_flags & VM_LOCKED)
+				munlock_vma_pages_all(tmp);
+			tmp = tmp->vm_next;
+		}
+	}
+
+	/*
 	 * Remove the vma's, and unmap the actual pages
 	 */
 	detach_vmas_to_be_unmapped(mm, vma, prev, end);
@@ -2020,8 +2047,9 @@ unsigned long do_brk(unsigned long addr,
 		return -ENOMEM;
 
 	/* Can we just expand an old private anonymous mapping? */
-	if (vma_merge(mm, prev, addr, addr + len, flags,
-					NULL, NULL, pgoff, NULL))
+	vma = vma_merge(mm, prev, addr, addr + len, flags,
+					NULL, NULL, pgoff, NULL);
+	if (vma)
 		goto out;
 
 	/*
@@ -2043,8 +2071,9 @@ unsigned long do_brk(unsigned long addr,
 out:
 	mm->total_vm += len >> PAGE_SHIFT;
 	if (flags & VM_LOCKED) {
-		mm->locked_vm += len >> PAGE_SHIFT;
-		make_pages_present(addr, addr + len);
+		int nr_pages = mlock_vma_pages_range(vma, addr, addr + len);
+		if (nr_pages >= 0)
+			mm->locked_vm += (len >> PAGE_SHIFT) - nr_pages;
 	}
 	return addr;
 }
@@ -2055,13 +2084,25 @@ EXPORT_SYMBOL(do_brk);
 void exit_mmap(struct mm_struct *mm)
 {
 	struct mmu_gather *tlb;
-	struct vm_area_struct *vma = mm->mmap;
+	struct vm_area_struct *vma;
 	unsigned long nr_accounted = 0;
 	unsigned long end;
 
 	/* mm's last user has gone, and its about to be pulled down */
 	arch_exit_mmap(mm);
 
+	if (mm->locked_vm) {
+		vma = mm->mmap;
+		while (vma) {
+			if (vma->vm_flags & VM_LOCKED)
+				munlock_vma_pages_all(vma);
+			vma = vma->vm_next;
+		}
+	}
+
+	vma = mm->mmap;
+
+
 	lru_add_drain();
 	flush_cache_mm(mm);
 	tlb = tlb_gather_mmu(mm, 1);
diff -puN mm/mremap.c~vmscan-handle-mlocked-pages-during-map-remap-unmap mm/mremap.c
--- a/mm/mremap.c~vmscan-handle-mlocked-pages-during-map-remap-unmap
+++ a/mm/mremap.c
@@ -23,6 +23,8 @@
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
 
+#include "internal.h"
+
 static pmd_t *get_old_pmd(struct mm_struct *mm, unsigned long addr)
 {
 	pgd_t *pgd;
@@ -232,8 +234,8 @@ static unsigned long move_vma(struct vm_
 	if (vm_flags & VM_LOCKED) {
 		mm->locked_vm += new_len >> PAGE_SHIFT;
 		if (new_len > old_len)
-			make_pages_present(new_addr + old_len,
-					   new_addr + new_len);
+			mlock_vma_pages_range(new_vma, new_addr + old_len,
+						       new_addr + new_len);
 	}
 
 	return new_addr;
@@ -373,7 +375,7 @@ unsigned long do_mremap(unsigned long ad
 			vm_stat_account(mm, vma->vm_flags, vma->vm_file, pages);
 			if (vma->vm_flags & VM_LOCKED) {
 				mm->locked_vm += pages;
-				make_pages_present(addr + old_len,
+				mlock_vma_pages_range(vma, addr + old_len,
 						   addr + new_len);
 			}
 			ret = addr;
diff -puN mm/truncate.c~vmscan-handle-mlocked-pages-during-map-remap-unmap mm/truncate.c
--- a/mm/truncate.c~vmscan-handle-mlocked-pages-during-map-remap-unmap
+++ a/mm/truncate.c
@@ -18,6 +18,7 @@
 #include <linux/task_io_accounting_ops.h>
 #include <linux/buffer_head.h>	/* grr. try_to_release_page,
 				   do_invalidatepage */
+#include "internal.h"
 
 
 /**
@@ -104,6 +105,7 @@ truncate_complete_page(struct address_sp
 	cancel_dirty_page(page, PAGE_CACHE_SIZE);
 
 	remove_from_page_cache(page);
+	clear_page_mlock(page);
 	ClearPageUptodate(page);
 	ClearPageMappedToDisk(page);
 	page_cache_release(page);	/* pagecache ref */
@@ -128,6 +130,7 @@ invalidate_complete_page(struct address_
 	if (PagePrivate(page) && !try_to_release_page(page, 0))
 		return 0;
 
+	clear_page_mlock(page);
 	ret = remove_mapping(mapping, page);
 
 	return ret;
@@ -353,6 +356,7 @@ invalidate_complete_page2(struct address
 	if (PageDirty(page))
 		goto failed;
 
+	clear_page_mlock(page);
 	BUG_ON(PagePrivate(page));
 	__remove_from_page_cache(page);
 	spin_unlock_irq(&mapping->tree_lock);
_

Patches currently in -mm which might be from riel@redhat.com are

ntp-let-update_persistent_clock-sleep.patch
access_process_vm-device-memory-infrastructure.patch
access_process_vm-device-memory-infrastructure-fix.patch
use-generic_access_phys-for-dev-mem-mappings.patch
use-generic_access_phys-for-dev-mem-mappings-fix.patch
use-generic_access_phys-for-pci-mmap-on-x86.patch
powerpc-ioremap_prot.patch
spufs-use-the-new-vm_ops-access.patch
spufs-use-the-new-vm_ops-access-fix.patch
page-flags-record-page-flag-overlays-explicitly.patch
page-flags-record-page-flag-overlays-explicitly-xen.patch
slub-record-page-flag-overlays-explicitly.patch
slob-record-page-flag-overlays-explicitly.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
idr-change-the-idr-structure.patch
idr-rename-some-of-the-idr-apis-internal-routines.patch
idr-fix-a-printk-call.patch
idr-error-checking-factorization.patch
idr-make-idr_get_new-rcu-safe.patch
idr-make-idr_get_new-rcu-safe-fix.patch
idr-make-idr_find-rcu-safe.patch
idr-make-idr_remove-rcu-safe.patch
ipc-call-idr_find-without-locking-in-ipc_lock.patch
ipc-get-rid-of-ipc_lock_down.patch
vmscan-handle-mlocked-pages-during-map-remap-unmap.patch
vmscan-mlocked-pages-statistics.patch
vmscan-cull-non-reclaimable-pages-in-fault-path.patch
vmscan-noreclaim-and-mlocked-pages-vm-events.patch
mm-only-vmscan-noreclaim-lru-scan-sysctl.patch
mm-only-vmscan-noreclaim-lru-scan-sysctl-fix.patch
vmscan-mlocked-pages-count-attempts-to-free-mlocked-page.patch
vmscan-noreclaim-lru-and-mlocked-pages-documentation.patch
make-mm-rmapc-anon_vma_cachep-static.patch

