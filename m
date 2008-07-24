From: akpm@linux-foundation.org
Subject: - access_process_vm-device-memory-infrastructure.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:21:44 -0700
Message-ID: <200807242321.m6ONLiev010419@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50895 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752658AbYGXXW6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:22:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: riel@redhat.com, a.p.zijlstra@chello.nl, airlied@linux.ie, arnd@arndb.de, benh@kernel.crashing.org, hugh@veritas.com, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     access_process_vm device memory infrastructure
has been removed from the -mm tree.  Its filename was
     access_process_vm-device-memory-infrastructure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: access_process_vm device memory infrastructure
From: Rik van Riel <riel@redhat.com>

In order to be able to debug things like the X server and programs using
the PPC Cell SPUs, the debugger needs to be able to access device memory
through ptrace and /proc/pid/mem.


This patch:

Add the generic_access_phys access function and put the hooks in place
to allow access_process_vm to access device or PPC Cell SPU memory.

[riel@redhat.com: Add documentation for the vm_ops->access function]
Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Benjamin Herrensmidt <benh@kernel.crashing.org>
Cc: Dave Airlie <airlied@linux.ie>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/Locking |    7 +
 arch/Kconfig                      |    3 
 arch/x86/Kconfig                  |    1 
 arch/x86/mm/ioremap.c             |    8 +
 include/asm-x86/io_32.h           |    2 
 include/asm-x86/io_64.h           |    2 
 include/linux/mm.h                |    8 +
 mm/memory.c                       |  131 ++++++++++++++++++++++++----
 8 files changed, 144 insertions(+), 18 deletions(-)

diff -puN Documentation/filesystems/Locking~access_process_vm-device-memory-infrastructure Documentation/filesystems/Locking
--- a/Documentation/filesystems/Locking~access_process_vm-device-memory-infrastructure
+++ a/Documentation/filesystems/Locking
@@ -510,6 +510,7 @@ prototypes:
 	void (*close)(struct vm_area_struct*);
 	int (*fault)(struct vm_area_struct*, struct vm_fault *);
 	int (*page_mkwrite)(struct vm_area_struct *, struct page *);
+	int (*access)(struct vm_area_struct *, unsigned long, void*, int, int);
 
 locking rules:
 		BKL	mmap_sem	PageLocked(page)
@@ -517,6 +518,7 @@ open:		no	yes
 close:		no	yes
 fault:		no	yes
 page_mkwrite:	no	yes		no
+access:		no	yes
 
 	->page_mkwrite() is called when a previously read-only page is
 about to become writeable. The file system is responsible for
@@ -525,6 +527,11 @@ taking to lock out truncate, the page ra
 within i_size. The page mapping should also be checked that it is not
 NULL.
 
+	->access() is called when get_user_pages() fails in
+acces_process_vm(), typically used to debug a process through
+/proc/pid/mem or ptrace.  This function is needed only for
+VM_IO | VM_PFNMAP VMAs.
+
 ================================================================================
 			Dubious stuff
 
diff -puN arch/Kconfig~access_process_vm-device-memory-infrastructure arch/Kconfig
--- a/arch/Kconfig~access_process_vm-device-memory-infrastructure
+++ a/arch/Kconfig
@@ -31,6 +31,9 @@ config KRETPROBES
 	def_bool y
 	depends on KPROBES && HAVE_KRETPROBES
 
+config HAVE_IOREMAP_PROT
+	def_bool n
+
 config HAVE_KPROBES
 	def_bool n
 
diff -puN arch/x86/Kconfig~access_process_vm-device-memory-infrastructure arch/x86/Kconfig
--- a/arch/x86/Kconfig~access_process_vm-device-memory-infrastructure
+++ a/arch/x86/Kconfig
@@ -21,6 +21,7 @@ config X86
 	select HAVE_UNSTABLE_SCHED_CLOCK
 	select HAVE_IDE
 	select HAVE_OPROFILE
+	select HAVE_IOREMAP_PROT
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
 	select HAVE_DYNAMIC_FTRACE
diff -puN arch/x86/mm/ioremap.c~access_process_vm-device-memory-infrastructure arch/x86/mm/ioremap.c
--- a/arch/x86/mm/ioremap.c~access_process_vm-device-memory-infrastructure
+++ a/arch/x86/mm/ioremap.c
@@ -330,6 +330,14 @@ static void __iomem *ioremap_default(res
 	return (void __iomem *)ret;
 }
 
+void __iomem *ioremap_prot(resource_size_t phys_addr, unsigned long size,
+				unsigned long prot_val)
+{
+	return __ioremap_caller(phys_addr, size, (prot_val & _PAGE_CACHE_MASK),
+				__builtin_return_address(0));
+}
+EXPORT_SYMBOL(ioremap_prot);
+
 /**
  * iounmap - Free a IO remapping
  * @addr: virtual address from ioremap_*
diff -puN include/asm-x86/io_32.h~access_process_vm-device-memory-infrastructure include/asm-x86/io_32.h
--- a/include/asm-x86/io_32.h~access_process_vm-device-memory-infrastructure
+++ a/include/asm-x86/io_32.h
@@ -110,6 +110,8 @@ static inline void *phys_to_virt(unsigne
  */
 extern void __iomem *ioremap_nocache(resource_size_t offset, unsigned long size);
 extern void __iomem *ioremap_cache(resource_size_t offset, unsigned long size);
+extern void __iomem *ioremap_prot(resource_size_t offset, unsigned long size,
+				unsigned long prot_val);
 
 /*
  * The default ioremap() behavior is non-cached:
diff -puN include/asm-x86/io_64.h~access_process_vm-device-memory-infrastructure include/asm-x86/io_64.h
--- a/include/asm-x86/io_64.h~access_process_vm-device-memory-infrastructure
+++ a/include/asm-x86/io_64.h
@@ -175,6 +175,8 @@ extern void early_iounmap(void *addr, un
  */
 extern void __iomem *ioremap_nocache(resource_size_t offset, unsigned long size);
 extern void __iomem *ioremap_cache(resource_size_t offset, unsigned long size);
+extern void __iomem *ioremap_prot(resource_size_t offset, unsigned long size,
+				unsigned long prot_val);
 
 /*
  * The default ioremap() behavior is non-cached:
diff -puN include/linux/mm.h~access_process_vm-device-memory-infrastructure include/linux/mm.h
--- a/include/linux/mm.h~access_process_vm-device-memory-infrastructure
+++ a/include/linux/mm.h
@@ -170,6 +170,12 @@ struct vm_operations_struct {
 	/* notification that a previously read-only page is about to become
 	 * writable, if an error is returned it will cause a SIGBUS */
 	int (*page_mkwrite)(struct vm_area_struct *vma, struct page *page);
+
+	/* called by access_process_vm when get_user_pages() fails, typically
+	 * for use by special VMAs that can switch between memory and hardware
+	 */
+	int (*access)(struct vm_area_struct *vma, unsigned long addr,
+		      void *buf, int len, int write);
 #ifdef CONFIG_NUMA
 	/*
 	 * set_policy() op must add a reference to any non-NULL @new mempolicy
@@ -771,6 +777,8 @@ int copy_page_range(struct mm_struct *ds
 			struct vm_area_struct *vma);
 void unmap_mapping_range(struct address_space *mapping,
 		loff_t const holebegin, loff_t const holelen, int even_cows);
+int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
+			void *buf, int len, int write);
 
 static inline void unmap_shared_mapping_range(struct address_space *mapping,
 		loff_t const holebegin, loff_t const holelen)
diff -puN mm/memory.c~access_process_vm-device-memory-infrastructure mm/memory.c
--- a/mm/memory.c~access_process_vm-device-memory-infrastructure
+++ a/mm/memory.c
@@ -2751,6 +2751,86 @@ int in_gate_area_no_task(unsigned long a
 
 #endif	/* __HAVE_ARCH_GATE_AREA */
 
+#ifdef CONFIG_HAVE_IOREMAP_PROT
+static resource_size_t follow_phys(struct vm_area_struct *vma,
+			unsigned long address, unsigned int flags,
+			unsigned long *prot)
+{
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *ptep, pte;
+	spinlock_t *ptl;
+	resource_size_t phys_addr = 0;
+	struct mm_struct *mm = vma->vm_mm;
+
+	VM_BUG_ON(!(vma->vm_flags & (VM_IO | VM_PFNMAP)));
+
+	pgd = pgd_offset(mm, address);
+	if (pgd_none(*pgd) || unlikely(pgd_bad(*pgd)))
+		goto no_page_table;
+
+	pud = pud_offset(pgd, address);
+	if (pud_none(*pud) || unlikely(pud_bad(*pud)))
+		goto no_page_table;
+
+	pmd = pmd_offset(pud, address);
+	if (pmd_none(*pmd) || unlikely(pmd_bad(*pmd)))
+		goto no_page_table;
+
+	/* We cannot handle huge page PFN maps. Luckily they don't exist. */
+	if (pmd_huge(*pmd))
+		goto no_page_table;
+
+	ptep = pte_offset_map_lock(mm, pmd, address, &ptl);
+	if (!ptep)
+		goto out;
+
+	pte = *ptep;
+	if (!pte_present(pte))
+		goto unlock;
+	if ((flags & FOLL_WRITE) && !pte_write(pte))
+		goto unlock;
+	phys_addr = pte_pfn(pte);
+	phys_addr <<= PAGE_SHIFT; /* Shift here to avoid overflow on PAE */
+
+	*prot = pgprot_val(pte_pgprot(pte));
+
+unlock:
+	pte_unmap_unlock(ptep, ptl);
+out:
+	return phys_addr;
+no_page_table:
+	return 0;
+}
+
+int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
+			void *buf, int len, int write)
+{
+	resource_size_t phys_addr;
+	unsigned long prot = 0;
+	void *maddr;
+	int offset = addr & (PAGE_SIZE-1);
+
+	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
+		return -EINVAL;
+
+	phys_addr = follow_phys(vma, addr, write, &prot);
+
+	if (!phys_addr)
+		return -EINVAL;
+
+	maddr = ioremap_prot(phys_addr, PAGE_SIZE, prot);
+	if (write)
+		memcpy_toio(maddr + offset, buf, len);
+	else
+		memcpy_fromio(buf, maddr + offset, len);
+	iounmap(maddr);
+
+	return len;
+}
+#endif
+
 /*
  * Access another process' address space.
  * Source/target buffer must be kernel space,
@@ -2760,7 +2840,6 @@ int access_process_vm(struct task_struct
 {
 	struct mm_struct *mm;
 	struct vm_area_struct *vma;
-	struct page *page;
 	void *old_buf = buf;
 
 	mm = get_task_mm(tsk);
@@ -2772,28 +2851,44 @@ int access_process_vm(struct task_struct
 	while (len) {
 		int bytes, ret, offset;
 		void *maddr;
+		struct page *page = NULL;
 
 		ret = get_user_pages(tsk, mm, addr, 1,
 				write, 1, &page, &vma);
-		if (ret <= 0)
-			break;
-
-		bytes = len;
-		offset = addr & (PAGE_SIZE-1);
-		if (bytes > PAGE_SIZE-offset)
-			bytes = PAGE_SIZE-offset;
-
-		maddr = kmap(page);
-		if (write) {
-			copy_to_user_page(vma, page, addr,
-					  maddr + offset, buf, bytes);
-			set_page_dirty_lock(page);
+		if (ret <= 0) {
+			/*
+			 * Check if this is a VM_IO | VM_PFNMAP VMA, which
+			 * we can access using slightly different code.
+			 */
+#ifdef CONFIG_HAVE_IOREMAP_PROT
+			vma = find_vma(mm, addr);
+			if (!vma)
+				break;
+			if (vma->vm_ops && vma->vm_ops->access)
+				ret = vma->vm_ops->access(vma, addr, buf,
+							  len, write);
+			if (ret <= 0)
+#endif
+				break;
+			bytes = ret;
 		} else {
-			copy_from_user_page(vma, page, addr,
-					    buf, maddr + offset, bytes);
+			bytes = len;
+			offset = addr & (PAGE_SIZE-1);
+			if (bytes > PAGE_SIZE-offset)
+				bytes = PAGE_SIZE-offset;
+
+			maddr = kmap(page);
+			if (write) {
+				copy_to_user_page(vma, page, addr,
+						  maddr + offset, buf, bytes);
+				set_page_dirty_lock(page);
+			} else {
+				copy_from_user_page(vma, page, addr,
+						    buf, maddr + offset, bytes);
+			}
+			kunmap(page);
+			page_cache_release(page);
 		}
-		kunmap(page);
-		page_cache_release(page);
 		len -= bytes;
 		buf += bytes;
 		addr += bytes;
_

Patches currently in -mm which might be from riel@redhat.com are

origin.patch
ntp-let-update_persistent_clock-sleep.patch
mmu-notifiers-add-list_del_init_rcu.patch
mmu-notifiers-add-mm_take_all_locks-operation.patch
mmu-notifier-core.patch
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
mm-speculative-page-references-fix-migration_entry_wait-for-speculative-page-cache.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
vmscan-move-isolate_lru_page-to-vmscanc-fix.patch
vmscan-use-an-indexed-array-for-lru-variables.patch
swap-use-an-array-for-the-lru-pagevecs.patch
vmscan-free-swap-space-on-swap-in-activation.patch
define-page_file_cache-function.patch
define-page_file_cache-function-fix.patch
define-page_file_cache-function-fix-splitlru-shmem_getpage-setpageswapbacked-sooner.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
vmscan-split-lru-lists-into-anon-file-sets-collect-lru-meminfo-statistics-from-correct-offset.patch
vmscan-split-lru-lists-into-anon-file-sets-prevent-incorrect-oom-under-split_lru.patch
vmscan-split-lru-lists-into-anon-file-sets-split_lru-fix-pagevec_move_tail-doesnt-treat-unevictable-page.patch
vmscan-split-lru-lists-into-anon-file-sets-splitlru-memcg-swapbacked-pages-active.patch
vmscan-split-lru-lists-into-anon-file-sets-splitlru-bdi_cap_swap_backed.patch
vmscan-split-lru-lists-into-anon-file-sets-units-fix.patch
vmscan-second-chance-replacement-for-anonymous-pages.patch
vmscan-second-chance-replacement-for-anonymous-pages-fix.patch
vmscan-second-chance-replacement-for-anonymous-pages-memcg-lru-scan-fix.patch
vmscan-fix-pagecache-reclaim-referenced-bit-check.patch
vmscan-add-newly-swapped-in-pages-to-the-inactive-list.patch
more-aggressively-use-lumpy-reclaim.patch
pageflag-helpers-for-configed-out-flags.patch
unevictable-lru-infrastructure.patch
unevictable-lru-infrastructure-fix.patch
unevictable-lru-infrastructure-kconfig-fix.patch
unevictable-lru-infrastructure-remove-redundant-page-mapping-check.patch
unevictable-lru-infrastructure-kill-unnecessary-lock_page-in-vmscanc.patch
unevictable-lru-infrastructure-revert-migration-change-of-unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
unevictable-lru-page-statistics-fix-printk-in-show_free_areas.patch
unevictable-lru-page-statistics-units-fix.patch
ramfs-and-ram-disk-pages-are-unevictable.patch
ramfs-and-ram-disk-pages-are-unevictable-undo-the-brdc-part.patch
shm_locked-pages-are-unevictable.patch
shm_locked-pages-are-unevictable-revert-shm-change-of-shm_locked-pages-are-unevictable-patch.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mlock-mlocked-pages-are-unevictable-fix-fix.patch
mlock-mlocked-pages-are-unevictable-fix-3.patch
mlock-mlocked-pages-are-unevictable-fix-fix-munlock-page-table-walk-now-requires-mm.patch
mlock-mlocked-pages-are-unevictable-restore-patch-failure-hunk-of-mlock-mlocked-pages-are-unevictablepatch.patch
mlock-downgrade-mmap-sem-while-populating-mlocked-regions.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-cleanup.patch
fix-double-unlock_page-in-2626-rc5-mm3-kernel-bug-at-mm-filemapc-575.patch
introduce-__get_user_pages.patch
introduce-__get_user_pages-fix.patch
split-lru-munlock-rework.patch
revert-to-unevictable-lru-infrastructure-kconfig-fixpatch.patch
vmstat-mlocked-pages-statistics.patch
vmstat-mlocked-pages-statistics-fix-incorrect-mlocked-field-of-proc-meminfo.patch
swap-cull-unevictable-pages-in-fault-path.patch
swap-cull-unevictable-pages-in-fault-path-fix.patch
vmstat-unevictable-and-mlocked-pages-vm-events.patch
vmscan-unevictable-lru-scan-sysctl.patch
vmscan-unevictable-lru-scan-sysctl-nommu-fix.patch
vmscan-unevictable-lru-scan-sysctl-add-sys_device-parameter.patch
mlock-count-attempts-to-free-mlocked-page.patch
doc-unevictable-lru-and-mlocked-pages-documentation.patch
vmscam-kill-unused-lru-functions.patch
mm-more-likely-reclaim-madv_sequential-mappings.patch
make-mm-rmapc-anon_vma_cachep-static.patch

