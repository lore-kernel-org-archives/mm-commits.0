From: akpm@linux-foundation.org
Subject: + access_process_vm-device-memory-infrastructure.patch added to -mm tree
Date: Thu, 15 May 2008 17:24:10 -0700
Message-ID: <200805160024.m4G0OBQk018124@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59207 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753937AbYEPAZM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 May 2008 20:25:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: riel@redhat.com, airlied@linux.ie, arnd@arndb.de, benh@kernel.crashing.org, hugh@veritas.com, paulus@samba.org


The patch titled
     access_process_vm device memory infrastructure
has been added to the -mm tree.  Its filename is
     access_process_vm-device-memory-infrastructure.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Benjamin Herrensmidt <benh@kernel.crashing.org>
Cc: Dave Airlie <airlied@linux.ie>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig            |    3 
 arch/x86/Kconfig        |    1 
 arch/x86/mm/ioremap.c   |    8 ++
 include/asm-x86/io_32.h |    2 
 include/asm-x86/io_64.h |    2 
 include/linux/mm.h      |    8 ++
 mm/memory.c             |  131 ++++++++++++++++++++++++++++++++------
 7 files changed, 137 insertions(+), 18 deletions(-)

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
 	select HAVE_FTRACE
diff -puN arch/x86/mm/ioremap.c~access_process_vm-device-memory-infrastructure arch/x86/mm/ioremap.c
--- a/arch/x86/mm/ioremap.c~access_process_vm-device-memory-infrastructure
+++ a/arch/x86/mm/ioremap.c
@@ -307,6 +307,14 @@ void __iomem *ioremap_cache(resource_siz
 }
 EXPORT_SYMBOL(ioremap_cache);
 
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
@@ -169,6 +169,12 @@ struct vm_operations_struct {
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
@@ -769,6 +775,8 @@ int copy_page_range(struct mm_struct *ds
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
@@ -2688,6 +2688,86 @@ int in_gate_area_no_task(unsigned long a
 
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
@@ -2697,7 +2777,6 @@ int access_process_vm(struct task_struct
 {
 	struct mm_struct *mm;
 	struct vm_area_struct *vma;
-	struct page *page;
 	void *old_buf = buf;
 
 	mm = get_task_mm(tsk);
@@ -2709,28 +2788,44 @@ int access_process_vm(struct task_struct
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

access_process_vm-device-memory-infrastructure.patch
use-generic_access_phys-for-dev-mem-mappings.patch
use-generic_access_phys-for-pci-mmap-on-x86.patch
powerpc-ioremap_prot.patch
spufs-use-the-new-vm_ops-access.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
idr-change-the-idr-structure.patch
idr-rename-some-of-the-idr-apis-internal-routines.patch
idr-fix-a-printk-call.patch
idr-error-checking-factorization.patch
idr-make-idr_get_new-rcu-safe.patch
idr-make-idr_find-rcu-safe.patch
idr-make-idr_remove-rcu-safe.patch
ipc-call-idr_find-without-locking-in-ipc_lock.patch
ipc-get-rid-of-ipc_lock_down.patch
make-mm-rmapc-anon_vma_cachep-static.patch

