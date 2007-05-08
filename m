From: akpm@linux-foundation.org
Subject: - uml-speed-page-fault-path.patch removed from -mm tree
Date: Mon, 07 May 2007 17:07:33 -0700
Message-ID: <200705080007.l4807Xgc009296@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52209 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967478AbXEHALs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:11:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: speed page fault path
has been removed from the -mm tree.  Its filename was
     uml-speed-page-fault-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: speed page fault path
From: Jeff Dike <jdike@addtoit.com>

Give the page fault code a specialized path.  There is only one page to look
at, so there's no point in going into the general page table walking code. 
There's only going to be one host operation, so there are no opportunities for
merging.  So, we go straight to the pte we want, figure out what needs doing,
and do it.

While I was in here, I fixed the wart where the address passed to unmap was a
void *, but an unsigned long to map and protect.

This gives me just under 10% on a kernel build.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/os.h                  |    2 
 arch/um/include/skas/mode_kern_skas.h |    2 
 arch/um/kernel/skas/tlb.c             |   66 +++++++++++++++++++++++-
 arch/um/kernel/tlb.c                  |    4 +
 arch/um/os-Linux/skas/mem.c           |    4 -
 5 files changed, 72 insertions(+), 6 deletions(-)

diff -puN arch/um/include/os.h~uml-speed-page-fault-path arch/um/include/os.h
--- a/arch/um/include/os.h~uml-speed-page-fault-path
+++ a/arch/um/include/os.h
@@ -302,7 +302,7 @@ extern long syscall_stub_data(struct mm_
 extern int map(struct mm_id * mm_idp, unsigned long virt,
 	       unsigned long len, int r, int w, int x, int phys_fd,
 	       unsigned long long offset, int done, void **data);
-extern int unmap(struct mm_id * mm_idp, void *addr, unsigned long len,
+extern int unmap(struct mm_id * mm_idp, unsigned long addr, unsigned long len,
 		 int done, void **data);
 extern int protect(struct mm_id * mm_idp, unsigned long addr,
 		   unsigned long len, int r, int w, int x, int done,
diff -puN arch/um/include/skas/mode_kern_skas.h~uml-speed-page-fault-path arch/um/include/skas/mode_kern_skas.h
--- a/arch/um/include/skas/mode_kern_skas.h~uml-speed-page-fault-path
+++ a/arch/um/include/skas/mode_kern_skas.h
@@ -33,6 +33,8 @@ extern unsigned long set_task_sizes_skas
 extern int start_uml_skas(void);
 extern int external_pid_skas(struct task_struct *task);
 extern int thread_pid_skas(struct task_struct *task);
+extern void flush_tlb_page_skas(struct vm_area_struct *vma,
+				unsigned long address);
 
 #define kmem_end_skas (host_task_size - 1024 * 1024)
 
diff -puN arch/um/kernel/skas/tlb.c~uml-speed-page-fault-path arch/um/kernel/skas/tlb.c
--- a/arch/um/kernel/skas/tlb.c~uml-speed-page-fault-path
+++ a/arch/um/kernel/skas/tlb.c
@@ -32,8 +32,7 @@ static int do_ops(union mm_context *mmu,
 				  op->u.mmap.offset, finished, flush);
 			break;
 		case MUNMAP:
-			ret = unmap(&mmu->skas.id,
-				    (void *) op->u.munmap.addr,
+			ret = unmap(&mmu->skas.id, op->u.munmap.addr,
 				    op->u.munmap.len, finished, flush);
 			break;
 		case MPROTECT:
@@ -94,3 +93,66 @@ void force_flush_all_skas(void)
 	unsigned long end = proc_mm ? task_size : CONFIG_STUB_START;
         fix_range(current->mm, 0, end, 1);
 }
+
+void flush_tlb_page_skas(struct vm_area_struct *vma, unsigned long address)
+{
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *pte;
+	struct mm_struct *mm = vma->vm_mm;
+	void *flush = NULL;
+	int r, w, x, err = 0;
+	struct mm_id *mm_id;
+
+	pgd = pgd_offset(vma->vm_mm, address);
+	if(!pgd_present(*pgd))
+		goto kill;
+
+	pud = pud_offset(pgd, address);
+	if(!pud_present(*pud))
+		goto kill;
+
+	pmd = pmd_offset(pud, address);
+	if(!pmd_present(*pmd))
+		goto kill;
+
+	pte = pte_offset_kernel(pmd, address);
+
+	r = pte_read(*pte);
+	w = pte_write(*pte);
+	x = pte_exec(*pte);
+	if (!pte_young(*pte)) {
+		r = 0;
+		w = 0;
+	} else if (!pte_dirty(*pte)) {
+		w = 0;
+	}
+
+	mm_id = &mm->context.skas.id;
+	if(pte_newpage(*pte)){
+		if(pte_present(*pte)){
+			unsigned long long offset;
+			int fd;
+
+			fd = phys_mapping(pte_val(*pte) & PAGE_MASK, &offset);
+			err = map(mm_id, address, PAGE_SIZE, r, w, x, fd,
+				  offset, 1, &flush);
+		}
+		else err = unmap(mm_id, address, PAGE_SIZE, 1, &flush);
+	}
+	else if(pte_newprot(*pte))
+		err = protect(mm_id, address, PAGE_SIZE, r, w, x, 1, &flush);
+
+	if(err)
+		goto kill;
+
+	*pte = pte_mkuptodate(*pte);
+
+	return;
+
+kill:
+	printk("Failed to flush page for address 0x%lx\n", address);
+	force_sig(SIGKILL, current);
+}
+
diff -puN arch/um/kernel/tlb.c~uml-speed-page-fault-path arch/um/kernel/tlb.c
--- a/arch/um/kernel/tlb.c~uml-speed-page-fault-path
+++ a/arch/um/kernel/tlb.c
@@ -381,7 +381,9 @@ pte_t *addr_pte(struct task_struct *task
 void flush_tlb_page(struct vm_area_struct *vma, unsigned long address)
 {
 	address &= PAGE_MASK;
-	flush_tlb_range(vma, address, address + PAGE_SIZE);
+
+	CHOOSE_MODE(flush_tlb_range(vma, address, address + PAGE_SIZE),
+		    flush_tlb_page_skas(vma, address));
 }
 
 void flush_tlb_all(void)
diff -puN arch/um/os-Linux/skas/mem.c~uml-speed-page-fault-path arch/um/os-Linux/skas/mem.c
--- a/arch/um/os-Linux/skas/mem.c~uml-speed-page-fault-path
+++ a/arch/um/os-Linux/skas/mem.c
@@ -219,8 +219,8 @@ int map(struct mm_id * mm_idp, unsigned 
 	return ret;
 }
 
-int unmap(struct mm_id * mm_idp, void *addr, unsigned long len, int done,
-	  void **data)
+int unmap(struct mm_id * mm_idp, unsigned long addr, unsigned long len,
+	  int done, void **data)
 {
 	int ret;
 
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-hostfs-style-fixes.patch
uml-an-idle-system-should-have-zero-load-average.patch
remove-tas.patch
x86-create-asm-cmpxchgh.patch
uml-network-and-pcap-cleanup.patch
uml-pcap-devices-should-get-macs-from-command-line.patch
