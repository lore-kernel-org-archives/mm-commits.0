From: akpm@linux-foundation.org
Subject: [merged] mm-replace-remap_file_pages-syscall-with-emulation.patch removed from -mm tree
Date: Wed, 11 Feb 2015 12:21:45 -0800
Message-ID: <54dbb9d9.FDA28Dz6m70bsGz0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40915 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957AbbBKUVq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Feb 2015 15:21:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, arigo@tunes.org, davej@redhat.com, hughd@google.com, kirill@shutemov.name, mingo@kernel.org, peterz@infradead.org, sasha.levin@oracle.com, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: replace remap_file_pages() syscall with emulation
has been removed from the -mm tree.  Its filename was
     mm-replace-remap_file_pages-syscall-with-emulation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: replace remap_file_pages() syscall with emulation

remap_file_pages(2) was invented to be able efficiently map parts of huge
file into limited 32-bit virtual address space such as in database
workloads.

Nonlinear mappings are pain to support and it seems there's no legitimate
use-cases nowadays since 64-bit systems are widely available.

Let's drop it and get rid of all these special-cased code.

The patch replaces the syscall with emulation which creates new VMA on
each remap_file_pages(), unless they it can be merged with an adjacent
one.

I didn't find *any* real code that uses remap_file_pages(2) to test
emulation impact on.  I've checked Debian code search and source of all
packages in ALT Linux.  No real users: libc wrappers, mentions in strace,
gdb, valgrind and this kind of stuff.

There are few basic tests in LTP for the syscall. They work just fine
with emulation.

To test performance impact, I've written small test case which demonstrate
pretty much worst case scenario: map 4G shmfs file, write to begin of
every page pgoff of the page, remap pages in reverse order, read every
page.

The test creates 1 million of VMAs if emulation is in use, so I had to set
vm.max_map_count to 1100000 to avoid -ENOMEM.

Before:		23.3 ( +-  4.31% ) seconds
After:		43.9 ( +-  0.85% ) seconds
Slowdown:	1.88x

I believe we can live with that.

Test case:

	#define _GNU_SOURCE
	#include <assert.h>
	#include <stdlib.h>
	#include <stdio.h>
	#include <sys/mman.h>

	#define MB	(1024UL * 1024)
	#define SIZE	(4096 * MB)

	int main(int argc, char **argv)
	{
		unsigned long *p;
		long i, pass;

		for (pass = 0; pass < 10; pass++) {
			p = mmap(NULL, SIZE, PROT_READ|PROT_WRITE,
					MAP_SHARED | MAP_ANONYMOUS, -1, 0);
			if (p == MAP_FAILED) {
				perror("mmap");
				return -1;
			}

			for (i = 0; i < SIZE / 4096; i++)
				p[i * 4096 / sizeof(*p)] = i;

			for (i = 0; i < SIZE / 4096; i++) {
				if (remap_file_pages(p + i * 4096 / sizeof(*p), 4096,
						0, (SIZE - 4096 * (i + 1)) >> 12, 0)) {
					perror("remap_file_pages");
					return -1;
				}
			}

			for (i = SIZE / 4096 - 1; i >= 0; i--)
				assert(p[i * 4096 / sizeof(*p)] == SIZE / 4096 - i - 1);

			munmap(p, SIZE);
		}

		return 0;
	}

[akpm@linux-foundation.org: fix spello]
[sasha.levin@oracle.com: initialize populate before usage]
[sasha.levin@oracle.com: grab file ref to prevent race while mmaping]
Signed-off-by: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Dave Jones <davej@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Armin Rigo <arigo@tunes.org>
Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/remap_file_pages.txt |    7 
 include/linux/fs.h                    |    8 
 mm/Makefile                           |    2 
 mm/fremap.c                           |  283 ------------------------
 mm/mmap.c                             |   69 +++++
 mm/nommu.c                            |    8 
 6 files changed, 79 insertions(+), 298 deletions(-)

diff -puN Documentation/vm/remap_file_pages.txt~mm-replace-remap_file_pages-syscall-with-emulation Documentation/vm/remap_file_pages.txt
--- a/Documentation/vm/remap_file_pages.txt~mm-replace-remap_file_pages-syscall-with-emulation
+++ a/Documentation/vm/remap_file_pages.txt
@@ -18,10 +18,9 @@ on 32-bit systems to map files bigger th
 virtual address space. This use-case is not critical anymore since 64-bit
 systems are widely available.
 
-The plan is to deprecate the syscall and replace it with an emulation.
-The emulation will create new VMAs instead of nonlinear mappings. It's
-going to work slower for rare users of remap_file_pages() but ABI is
-preserved.
+The syscall is deprecated and replaced it with an emulation now. The
+emulation creates new VMAs instead of nonlinear mappings. It's going to
+work slower for rare users of remap_file_pages() but ABI is preserved.
 
 One side effect of emulation (apart from performance) is that user can hit
 vm.max_map_count limit more easily due to additional VMAs. See comment for
diff -puN include/linux/fs.h~mm-replace-remap_file_pages-syscall-with-emulation include/linux/fs.h
--- a/include/linux/fs.h~mm-replace-remap_file_pages-syscall-with-emulation
+++ a/include/linux/fs.h
@@ -2481,8 +2481,12 @@ extern int sb_min_blocksize(struct super
 
 extern int generic_file_mmap(struct file *, struct vm_area_struct *);
 extern int generic_file_readonly_mmap(struct file *, struct vm_area_struct *);
-extern int generic_file_remap_pages(struct vm_area_struct *, unsigned long addr,
-		unsigned long size, pgoff_t pgoff);
+static inline int generic_file_remap_pages(struct vm_area_struct *vma,
+		unsigned long addr, unsigned long size, pgoff_t pgoff)
+{
+	BUG();
+	return 0;
+}
 int generic_write_checks(struct file *file, loff_t *pos, size_t *count, int isblk);
 extern ssize_t generic_file_read_iter(struct kiocb *, struct iov_iter *);
 extern ssize_t __generic_file_write_iter(struct kiocb *, struct iov_iter *);
diff -puN mm/Makefile~mm-replace-remap_file_pages-syscall-with-emulation mm/Makefile
--- a/mm/Makefile~mm-replace-remap_file_pages-syscall-with-emulation
+++ a/mm/Makefile
@@ -3,7 +3,7 @@
 #
 
 mmu-y			:= nommu.o
-mmu-$(CONFIG_MMU)	:= fremap.o gup.o highmem.o memory.o mincore.o \
+mmu-$(CONFIG_MMU)	:= gup.o highmem.o memory.o mincore.o \
 			   mlock.o mmap.o mprotect.o mremap.o msync.o rmap.o \
 			   vmalloc.o pagewalk.o pgtable-generic.o
 
diff -puN mm/fremap.c~mm-replace-remap_file_pages-syscall-with-emulation /dev/null
--- a/mm/fremap.c
+++ /dev/null
@@ -1,283 +0,0 @@
-/*
- *   linux/mm/fremap.c
- * 
- * Explicit pagetable population and nonlinear (random) mappings support.
- *
- * started by Ingo Molnar, Copyright (C) 2002, 2003
- */
-#include <linux/export.h>
-#include <linux/backing-dev.h>
-#include <linux/mm.h>
-#include <linux/swap.h>
-#include <linux/file.h>
-#include <linux/mman.h>
-#include <linux/pagemap.h>
-#include <linux/swapops.h>
-#include <linux/rmap.h>
-#include <linux/syscalls.h>
-#include <linux/mmu_notifier.h>
-
-#include <asm/mmu_context.h>
-#include <asm/cacheflush.h>
-#include <asm/tlbflush.h>
-
-#include "internal.h"
-
-static int mm_counter(struct page *page)
-{
-	return PageAnon(page) ? MM_ANONPAGES : MM_FILEPAGES;
-}
-
-static void zap_pte(struct mm_struct *mm, struct vm_area_struct *vma,
-			unsigned long addr, pte_t *ptep)
-{
-	pte_t pte = *ptep;
-	struct page *page;
-	swp_entry_t entry;
-
-	if (pte_present(pte)) {
-		flush_cache_page(vma, addr, pte_pfn(pte));
-		pte = ptep_clear_flush_notify(vma, addr, ptep);
-		page = vm_normal_page(vma, addr, pte);
-		if (page) {
-			if (pte_dirty(pte))
-				set_page_dirty(page);
-			update_hiwater_rss(mm);
-			dec_mm_counter(mm, mm_counter(page));
-			page_remove_rmap(page);
-			page_cache_release(page);
-		}
-	} else {	/* zap_pte() is not called when pte_none() */
-		if (!pte_file(pte)) {
-			update_hiwater_rss(mm);
-			entry = pte_to_swp_entry(pte);
-			if (non_swap_entry(entry)) {
-				if (is_migration_entry(entry)) {
-					page = migration_entry_to_page(entry);
-					dec_mm_counter(mm, mm_counter(page));
-				}
-			} else {
-				free_swap_and_cache(entry);
-				dec_mm_counter(mm, MM_SWAPENTS);
-			}
-		}
-		pte_clear_not_present_full(mm, addr, ptep, 0);
-	}
-}
-
-/*
- * Install a file pte to a given virtual memory address, release any
- * previously existing mapping.
- */
-static int install_file_pte(struct mm_struct *mm, struct vm_area_struct *vma,
-		unsigned long addr, unsigned long pgoff, pgprot_t prot)
-{
-	int err = -ENOMEM;
-	pte_t *pte, ptfile;
-	spinlock_t *ptl;
-
-	pte = get_locked_pte(mm, addr, &ptl);
-	if (!pte)
-		goto out;
-
-	ptfile = pgoff_to_pte(pgoff);
-
-	if (!pte_none(*pte))
-		zap_pte(mm, vma, addr, pte);
-
-	set_pte_at(mm, addr, pte, pte_file_mksoft_dirty(ptfile));
-	/*
-	 * We don't need to run update_mmu_cache() here because the "file pte"
-	 * being installed by install_file_pte() is not a real pte - it's a
-	 * non-present entry (like a swap entry), noting what file offset should
-	 * be mapped there when there's a fault (in a non-linear vma where
-	 * that's not obvious).
-	 */
-	pte_unmap_unlock(pte, ptl);
-	err = 0;
-out:
-	return err;
-}
-
-int generic_file_remap_pages(struct vm_area_struct *vma, unsigned long addr,
-			     unsigned long size, pgoff_t pgoff)
-{
-	struct mm_struct *mm = vma->vm_mm;
-	int err;
-
-	do {
-		err = install_file_pte(mm, vma, addr, pgoff, vma->vm_page_prot);
-		if (err)
-			return err;
-
-		size -= PAGE_SIZE;
-		addr += PAGE_SIZE;
-		pgoff++;
-	} while (size);
-
-	return 0;
-}
-EXPORT_SYMBOL(generic_file_remap_pages);
-
-/**
- * sys_remap_file_pages - remap arbitrary pages of an existing VM_SHARED vma
- * @start: start of the remapped virtual memory range
- * @size: size of the remapped virtual memory range
- * @prot: new protection bits of the range (see NOTE)
- * @pgoff: to-be-mapped page of the backing store file
- * @flags: 0 or MAP_NONBLOCKED - the later will cause no IO.
- *
- * sys_remap_file_pages remaps arbitrary pages of an existing VM_SHARED vma
- * (shared backing store file).
- *
- * This syscall works purely via pagetables, so it's the most efficient
- * way to map the same (large) file into a given virtual window. Unlike
- * mmap()/mremap() it does not create any new vmas. The new mappings are
- * also safe across swapout.
- *
- * NOTE: the @prot parameter right now is ignored (but must be zero),
- * and the vma's default protection is used. Arbitrary protections
- * might be implemented in the future.
- */
-SYSCALL_DEFINE5(remap_file_pages, unsigned long, start, unsigned long, size,
-		unsigned long, prot, unsigned long, pgoff, unsigned long, flags)
-{
-	struct mm_struct *mm = current->mm;
-	struct address_space *mapping;
-	struct vm_area_struct *vma;
-	int err = -EINVAL;
-	int has_write_lock = 0;
-	vm_flags_t vm_flags = 0;
-
-	pr_warn_once("%s (%d) uses deprecated remap_file_pages() syscall. "
-			"See Documentation/vm/remap_file_pages.txt.\n",
-			current->comm, current->pid);
-
-	if (prot)
-		return err;
-	/*
-	 * Sanitize the syscall parameters:
-	 */
-	start = start & PAGE_MASK;
-	size = size & PAGE_MASK;
-
-	/* Does the address range wrap, or is the span zero-sized? */
-	if (start + size <= start)
-		return err;
-
-	/* Does pgoff wrap? */
-	if (pgoff + (size >> PAGE_SHIFT) < pgoff)
-		return err;
-
-	/* Can we represent this offset inside this architecture's pte's? */
-#if PTE_FILE_MAX_BITS < BITS_PER_LONG
-	if (pgoff + (size >> PAGE_SHIFT) >= (1UL << PTE_FILE_MAX_BITS))
-		return err;
-#endif
-
-	/* We need down_write() to change vma->vm_flags. */
-	down_read(&mm->mmap_sem);
- retry:
-	vma = find_vma(mm, start);
-
-	/*
-	 * Make sure the vma is shared, that it supports prefaulting,
-	 * and that the remapped range is valid and fully within
-	 * the single existing vma.
-	 */
-	if (!vma || !(vma->vm_flags & VM_SHARED))
-		goto out;
-
-	if (!vma->vm_ops || !vma->vm_ops->remap_pages)
-		goto out;
-
-	if (start < vma->vm_start || start + size > vma->vm_end)
-		goto out;
-
-	/* Must set VM_NONLINEAR before any pages are populated. */
-	if (!(vma->vm_flags & VM_NONLINEAR)) {
-		/*
-		 * vm_private_data is used as a swapout cursor
-		 * in a VM_NONLINEAR vma.
-		 */
-		if (vma->vm_private_data)
-			goto out;
-
-		/* Don't need a nonlinear mapping, exit success */
-		if (pgoff == linear_page_index(vma, start)) {
-			err = 0;
-			goto out;
-		}
-
-		if (!has_write_lock) {
-get_write_lock:
-			up_read(&mm->mmap_sem);
-			down_write(&mm->mmap_sem);
-			has_write_lock = 1;
-			goto retry;
-		}
-		mapping = vma->vm_file->f_mapping;
-		/*
-		 * page_mkclean doesn't work on nonlinear vmas, so if
-		 * dirty pages need to be accounted, emulate with linear
-		 * vmas.
-		 */
-		if (mapping_cap_account_dirty(mapping)) {
-			unsigned long addr;
-			struct file *file = get_file(vma->vm_file);
-			/* mmap_region may free vma; grab the info now */
-			vm_flags = vma->vm_flags;
-
-			addr = mmap_region(file, start, size, vm_flags, pgoff);
-			fput(file);
-			if (IS_ERR_VALUE(addr)) {
-				err = addr;
-			} else {
-				BUG_ON(addr != start);
-				err = 0;
-			}
-			goto out_freed;
-		}
-		i_mmap_lock_write(mapping);
-		flush_dcache_mmap_lock(mapping);
-		vma->vm_flags |= VM_NONLINEAR;
-		vma_interval_tree_remove(vma, &mapping->i_mmap);
-		vma_nonlinear_insert(vma, &mapping->i_mmap_nonlinear);
-		flush_dcache_mmap_unlock(mapping);
-		i_mmap_unlock_write(mapping);
-	}
-
-	if (vma->vm_flags & VM_LOCKED) {
-		/*
-		 * drop PG_Mlocked flag for over-mapped range
-		 */
-		if (!has_write_lock)
-			goto get_write_lock;
-		vm_flags = vma->vm_flags;
-		munlock_vma_pages_range(vma, start, start + size);
-		vma->vm_flags = vm_flags;
-	}
-
-	mmu_notifier_invalidate_range_start(mm, start, start + size);
-	err = vma->vm_ops->remap_pages(vma, start, size, pgoff);
-	mmu_notifier_invalidate_range_end(mm, start, start + size);
-
-	/*
-	 * We can't clear VM_NONLINEAR because we'd have to do
-	 * it after ->populate completes, and that would prevent
-	 * downgrading the lock.  (Locks can't be upgraded).
-	 */
-
-out:
-	if (vma)
-		vm_flags = vma->vm_flags;
-out_freed:
-	if (likely(!has_write_lock))
-		up_read(&mm->mmap_sem);
-	else
-		up_write(&mm->mmap_sem);
-	if (!err && ((vm_flags & VM_LOCKED) || !(flags & MAP_NONBLOCK)))
-		mm_populate(start, size);
-
-	return err;
-}
diff -puN mm/mmap.c~mm-replace-remap_file_pages-syscall-with-emulation mm/mmap.c
--- a/mm/mmap.c~mm-replace-remap_file_pages-syscall-with-emulation
+++ a/mm/mmap.c
@@ -2634,6 +2634,75 @@ SYSCALL_DEFINE2(munmap, unsigned long, a
 	return vm_munmap(addr, len);
 }
 
+
+/*
+ * Emulation of deprecated remap_file_pages() syscall.
+ */
+SYSCALL_DEFINE5(remap_file_pages, unsigned long, start, unsigned long, size,
+		unsigned long, prot, unsigned long, pgoff, unsigned long, flags)
+{
+
+	struct mm_struct *mm = current->mm;
+	struct vm_area_struct *vma;
+	unsigned long populate = 0;
+	unsigned long ret = -EINVAL;
+	struct file *file;
+
+	pr_warn_once("%s (%d) uses deprecated remap_file_pages() syscall. "
+			"See Documentation/vm/remap_file_pages.txt.\n",
+			current->comm, current->pid);
+
+	if (prot)
+		return ret;
+	start = start & PAGE_MASK;
+	size = size & PAGE_MASK;
+
+	if (start + size <= start)
+		return ret;
+
+	/* Does pgoff wrap? */
+	if (pgoff + (size >> PAGE_SHIFT) < pgoff)
+		return ret;
+
+	down_write(&mm->mmap_sem);
+	vma = find_vma(mm, start);
+
+	if (!vma || !(vma->vm_flags & VM_SHARED))
+		goto out;
+
+	if (start < vma->vm_start || start + size > vma->vm_end)
+		goto out;
+
+	if (pgoff == linear_page_index(vma, start)) {
+		ret = 0;
+		goto out;
+	}
+
+	prot |= vma->vm_flags & VM_READ ? PROT_READ : 0;
+	prot |= vma->vm_flags & VM_WRITE ? PROT_WRITE : 0;
+	prot |= vma->vm_flags & VM_EXEC ? PROT_EXEC : 0;
+
+	flags &= MAP_NONBLOCK;
+	flags |= MAP_SHARED | MAP_FIXED | MAP_POPULATE;
+	if (vma->vm_flags & VM_LOCKED) {
+		flags |= MAP_LOCKED;
+		/* drop PG_Mlocked flag for over-mapped range */
+		munlock_vma_pages_range(vma, start, start + size);
+	}
+
+	file = get_file(vma->vm_file);
+	ret = do_mmap_pgoff(vma->vm_file, start, size,
+			prot, flags, pgoff, &populate);
+	fput(file);
+out:
+	up_write(&mm->mmap_sem);
+	if (populate)
+		mm_populate(ret, populate);
+	if (!IS_ERR_VALUE(ret))
+		ret = 0;
+	return ret;
+}
+
 static inline void verify_mm_writelocked(struct mm_struct *mm)
 {
 #ifdef CONFIG_DEBUG_VM
diff -puN mm/nommu.c~mm-replace-remap_file_pages-syscall-with-emulation mm/nommu.c
--- a/mm/nommu.c~mm-replace-remap_file_pages-syscall-with-emulation
+++ a/mm/nommu.c
@@ -1984,14 +1984,6 @@ void filemap_map_pages(struct vm_area_st
 }
 EXPORT_SYMBOL(filemap_map_pages);
 
-int generic_file_remap_pages(struct vm_area_struct *vma, unsigned long addr,
-			     unsigned long size, pgoff_t pgoff)
-{
-	BUG();
-	return 0;
-}
-EXPORT_SYMBOL(generic_file_remap_pages);
-
 static int __access_remote_vm(struct task_struct *tsk, struct mm_struct *mm,
 		unsigned long addr, void *buf, int len, int write)
 {
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
mm-add-fields-for-compound-destructor-and-order-into-struct-page.patch
mm-add-vm_bug_on_page-for-page_mapcount.patch
sparc32-fix-broken-set_pte.patch
mm-numa-do-not-dereference-pmd-outside-of-the-lock-during-numa-hinting-fault.patch
mm-add-p-protnone-helpers-for-use-by-numa-balancing.patch
mm-convert-p_numa-users-to-p_protnone_numa.patch
ppc64-add-paranoid-warnings-for-unexpected-dsisr_protfault.patch
mm-convert-p_mknonnuma-and-remaining-page-table-manipulations.patch
mm-remove-remaining-references-to-numa-hinting-bits-and-helpers.patch
mm-numa-do-not-trap-faults-on-the-huge-zero-page.patch
x86-mm-restore-original-pte_special-check.patch
mm-numa-add-paranoid-check-around-pte_protnone_numa.patch
mm-numa-avoid-unnecessary-tlb-flushes-when-setting-numa-hinting-entries.patch
mm-set-page-pfmemalloc-in-prep_new_page.patch
mm-page_alloc-reduce-number-of-alloc_pages-functions-parameters.patch
mm-reduce-try_to_compact_pages-parameters.patch
mm-microoptimize-zonelist-operations.patch
mm-page_allocc-drop-dead-destroy_compound_page.patch
mm-more-checks-on-free_pages_prepare-for-tail-pages.patch
mm-more-checks-on-free_pages_prepare-for-tail-pages-fix-2.patch
microblaze-define-__pagetable_pmd_folded.patch
mm-make-first_user_address-unsigned-long-on-all-archs.patch
mm-asm-generic-define-pud_shift-in-asm-generic-4level-fixuph.patch
arm-define-__pagetable_pmd_folded-for-lpae.patch
mm-account-pmd-page-tables-to-the-process.patch
mm-account-pmd-page-tables-to-the-process-fix.patch
mm-account-pmd-page-tables-to-the-process-fix-2.patch
mm-account-pmd-page-tables-to-the-process-fix-3.patch
mm-fix-false-positive-warning-on-exit-due-mm_nr_pmdsmm.patch
mm-fix-false-positive-warning-on-exit-due-mm_nr_pmdsmm-fix-2.patch
mm-thp-allocate-transparent-hugepages-on-local-node.patch
mm-thp-allocate-transparent-hugepages-on-local-node-fix.patch
mm-mempolicy-merge-alloc_hugepage_vma-to-alloc_pages_vma.patch
mm-gup-add-get_user_pages_locked-and-get_user_pages_unlocked.patch
mm-gup-add-__get_user_pages_unlocked-to-customize-gup_flags.patch
mm-gup-use-get_user_pages_unlocked-within-get_user_pages_fast.patch
mm-gup-use-get_user_pages_unlocked.patch
mm-gup-kvm-use-get_user_pages_unlocked.patch
proc-pagemap-walk-page-tables-under-pte-lock.patch
mm-pagewalk-remove-pgd_entry-and-pud_entry.patch
pagewalk-improve-vma-handling.patch
pagewalk-add-walk_page_vma.patch
smaps-remove-mem_size_stats-vma-and-use-walk_page_vma.patch
clear_refs-remove-clear_refs_private-vma-and-introduce-clear_refs_test_walk.patch
pagemap-use-walk-vma-instead-of-calling-find_vma.patch
numa_maps-fix-typo-in-gather_hugetbl_stats.patch
numa_maps-remove-numa_maps-vma.patch
memcg-cleanup-preparation-for-page-table-walk.patch
arch-powerpc-mm-subpage-protc-use-walk-vma-and-walk_page_vma.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-proc-pid-clear_refs-avoid-split_huge_page.patch
mincore-apply-page-table-walker-on-do_mincore.patch
mm-when-stealing-freepages-also-take-pages-created-by-splitting-buddy-page.patch
mm-always-steal-split-buddies-in-fallback-allocations.patch
mm-more-aggressive-page-stealing-for-unmovable-allocations.patch
mm-incorporate-read-only-pages-into-transparent-huge-pages.patch
mm-do-not-use-mm-nr_pmds-on-mmu-configurations.patch
mm-fix-xip-fault-vs-truncate-race.patch
mm-fix-xip-fault-vs-truncate-race-fix.patch
mm-allow-page-fault-handlers-to-perform-the-cow.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix.patch
vfsext2-introduce-is_daxinode.patch
daxext2-replace-xip-read-and-write-with-dax-i-o.patch
daxext2-replace-ext2_clear_xip_target-with-dax_clear_blocks.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix.patch
daxext2-replace-xip_truncate_page-with-dax_truncate_page.patch
dax-replace-xip-documentation-with-dax-documentation.patch
vfs-remove-get_xip_mem.patch
ext2-remove-ext2_xip_verify_sb.patch
ext2-remove-ext2_use_xip.patch
ext2-remove-xipc-and-xiph.patch
vfsext2-remove-config_ext2_fs_xip-and-rename-config_fs_xip-to-config_fs_dax.patch
ext2-remove-ext2_aops_xip.patch
ext2-get-rid-of-most-mentions-of-xip-in-ext2.patch
dax-add-dax_zero_page_range.patch
dax-add-dax_zero_page_range-fix.patch
ext4-add-dax-functionality.patch
brd-rename-xip-to-dax.patch
powerpc-drop-_page_file-and-pte_file-related-helpers.patch

