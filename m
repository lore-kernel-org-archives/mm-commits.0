From: akpm@linux-foundation.org
Subject: + uml-clean-up-task_size-usage.patch added to -mm tree
Date: Tue, 27 Nov 2007 13:17:58 -0800
Message-ID: <200711272117.lARLHx0A030832@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41012 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752305AbXK0VSJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 16:18:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: clean up TASK_SIZE usage
has been added to the -mm tree.  Its filename is
     uml-clean-up-task_size-usage.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: clean up TASK_SIZE usage
From: Jeff Dike <jdike@addtoit.com>

Clean up the calculation and use of the usable address space size on the host.

task_size is gone, replaced with TASK_SIZE, which is calculated from
CONFIG_TOP_ADDR.  get_kmem_end and set_task_sizes_skas are also gone.

host_task_size, which refers to the entire address space usable by the UML
kernel and which may be larger than the address space usable by a UML process,
since that has to end on a pgdir boundary, is replaced by CONFIG_TOP_ADDR.

STACK_TOP is now TASK_SIZE minus the two stub pages.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/as-layout.h        |   15 +++++++++++++--
 arch/um/include/common-offsets.h   |    3 +++
 arch/um/include/mem_user.h         |    4 ----
 arch/um/kernel/exec.c              |    2 +-
 arch/um/kernel/ksyms.c             |    3 ---
 arch/um/kernel/physmem.c           |   10 ----------
 arch/um/kernel/tlb.c               |    2 +-
 arch/um/kernel/um_arch.c           |   22 ++--------------------
 include/asm-um/a.out.h             |    4 +---
 include/asm-um/fixmap.h            |    3 +--
 include/asm-um/processor-generic.h |    4 +---
 11 files changed, 23 insertions(+), 49 deletions(-)

diff -puN arch/um/include/as-layout.h~uml-clean-up-task_size-usage arch/um/include/as-layout.h
--- a/arch/um/include/as-layout.h~uml-clean-up-task_size-usage
+++ a/arch/um/include/as-layout.h
@@ -29,9 +29,20 @@
 #define _AC(X, Y)	__AC(X, Y)
 #endif
 
+/*
+ * The "- 1"'s are to avoid gcc complaining about integer overflows
+ * and unrepresentable decimal constants.  With 3-level page tables,
+ * TASK_SIZE is 0x80000000, which gets turned into its signed decimal
+ * equivalent in asm-offsets.s.  gcc then complains about that being
+ * unsigned only in C90.  To avoid that, UM_TASK_SIZE is defined as
+ * TASK_SIZE - 1.  To compensate, we need to add the 1 back here.
+ * However, adding it back to UM_TASK_SIZE produces more gcc
+ * complaints.  So, I adjust the thing being subtracted from
+ * UM_TASK_SIZE instead.  Bah.
+ */
 #define STUB_CODE _AC((unsigned long), \
-		      UML_CONFIG_TOP_ADDR - 2 * UM_KERN_PAGE_SIZE)
-#define STUB_DATA _AC((unsigned long), UML_CONFIG_TOP_ADDR - UM_KERN_PAGE_SIZE)
+		      UM_TASK_SIZE - (2 * UM_KERN_PAGE_SIZE - 1))
+#define STUB_DATA _AC((unsigned long), UM_TASK_SIZE - (UM_KERN_PAGE_SIZE - 1))
 #define STUB_START _AC(, STUB_CODE)
 
 #ifndef __ASSEMBLY__
diff -puN arch/um/include/common-offsets.h~uml-clean-up-task_size-usage arch/um/include/common-offsets.h
--- a/arch/um/include/common-offsets.h~uml-clean-up-task_size-usage
+++ a/arch/um/include/common-offsets.h
@@ -39,3 +39,6 @@ DEFINE(UM_HZ, HZ);
 DEFINE(UM_USEC_PER_SEC, USEC_PER_SEC);
 DEFINE(UM_NSEC_PER_SEC, NSEC_PER_SEC);
 DEFINE(UM_NSEC_PER_USEC, NSEC_PER_USEC);
+
+/* See as-layout.h for an explanation of the "- 1".  Bah. */
+DEFINE(UM_TASK_SIZE, TASK_SIZE - 1);
diff -puN arch/um/include/mem_user.h~uml-clean-up-task_size-usage arch/um/include/mem_user.h
--- a/arch/um/include/mem_user.h~uml-clean-up-task_size-usage
+++ a/arch/um/include/mem_user.h
@@ -46,9 +46,6 @@ extern int iomem_size;
 
 #define ROUND_4M(n) ((((unsigned long) (n)) + (1 << 22)) & ~((1 << 22) - 1))
 
-extern unsigned long host_task_size;
-extern unsigned long task_size;
-
 extern int init_mem_user(void);
 extern void setup_memory(void *entry);
 extern unsigned long find_iomem(char *driver, unsigned long *len_out);
@@ -62,6 +59,5 @@ extern unsigned long phys_offset(unsigne
 extern void unmap_physmem(void);
 extern void map_memory(unsigned long virt, unsigned long phys,
 		       unsigned long len, int r, int w, int x);
-extern unsigned long get_kmem_end(void);
 
 #endif
diff -puN arch/um/kernel/exec.c~uml-clean-up-task_size-usage arch/um/kernel/exec.c
--- a/arch/um/kernel/exec.c~uml-clean-up-task_size-usage
+++ a/arch/um/kernel/exec.c
@@ -19,7 +19,7 @@
 void flush_thread(void)
 {
 	void *data = NULL;
-	unsigned long end = proc_mm ? task_size : STUB_START;
+	unsigned long end = proc_mm ? TASK_SIZE : STUB_START;
 	int ret;
 
 	arch_flush_thread(&current->thread.arch);
diff -puN arch/um/kernel/ksyms.c~uml-clean-up-task_size-usage arch/um/kernel/ksyms.c
--- a/arch/um/kernel/ksyms.c~uml-clean-up-task_size-usage
+++ a/arch/um/kernel/ksyms.c
@@ -18,11 +18,8 @@ EXPORT_SYMBOL(set_signals);
 EXPORT_SYMBOL(get_signals);
 EXPORT_SYMBOL(kernel_thread);
 EXPORT_SYMBOL(sys_waitpid);
-EXPORT_SYMBOL(task_size);
 EXPORT_SYMBOL(flush_tlb_range);
-EXPORT_SYMBOL(host_task_size);
 EXPORT_SYMBOL(arch_validate);
-EXPORT_SYMBOL(get_kmem_end);
 
 EXPORT_SYMBOL(high_physmem);
 EXPORT_SYMBOL(empty_zero_page);
diff -puN arch/um/kernel/physmem.c~uml-clean-up-task_size-usage arch/um/kernel/physmem.c
--- a/arch/um/kernel/physmem.c~uml-clean-up-task_size-usage
+++ a/arch/um/kernel/physmem.c
@@ -55,16 +55,6 @@ int __init init_maps(unsigned long physm
 	return 0;
 }
 
-/* Changed during early boot */
-static unsigned long kmem_top = 0;
-
-unsigned long get_kmem_end(void)
-{
-	if (kmem_top == 0)
-		kmem_top = host_task_size - 1024 * 1024;
-	return kmem_top;
-}
-
 void map_memory(unsigned long virt, unsigned long phys, unsigned long len,
 		int r, int w, int x)
 {
diff -puN arch/um/kernel/tlb.c~uml-clean-up-task_size-usage arch/um/kernel/tlb.c
--- a/arch/um/kernel/tlb.c~uml-clean-up-task_size-usage
+++ a/arch/um/kernel/tlb.c
@@ -511,7 +511,7 @@ void flush_tlb_mm(struct mm_struct *mm)
 	if (atomic_read(&mm->mm_users) == 0)
 		return;
 
-	end = proc_mm ? task_size : STUB_START;
+	end = proc_mm ? TASK_SIZE : STUB_START;
 	fix_range(mm, 0, end, 0);
 }
 
diff -puN arch/um/kernel/um_arch.c~uml-clean-up-task_size-usage arch/um/kernel/um_arch.c
--- a/arch/um/kernel/um_arch.c~uml-clean-up-task_size-usage
+++ a/arch/um/kernel/um_arch.c
@@ -101,8 +101,6 @@ const struct seq_operations cpuinfo_op =
 };
 
 /* Set in linux_main */
-unsigned long host_task_size;
-unsigned long task_size;
 unsigned long uml_physmem;
 unsigned long uml_reserved; /* Also modified in mem_init */
 unsigned long start_vm;
@@ -234,20 +232,6 @@ EXPORT_SYMBOL(end_iomem);
 
 extern char __binary_start;
 
-static unsigned long set_task_sizes_skas(unsigned long *task_size_out)
-{
-	/* Round up to the nearest 4M */
-	unsigned long host_task_size = ROUND_4M((unsigned long)
-						&host_task_size);
-
-	if (!skas_needs_stub)
-		*task_size_out = host_task_size;
-	else
-		*task_size_out = STUB_START & PGDIR_MASK;
-
-	return host_task_size;
-}
-
 int __init linux_main(int argc, char **argv)
 {
 	unsigned long avail, diff;
@@ -278,8 +262,6 @@ int __init linux_main(int argc, char **a
 
 	printf("UML running in %s mode\n", mode);
 
-	host_task_size = set_task_sizes_skas(&task_size);
-
 	brk_start = (unsigned long) sbrk(0);
 
 	/*
@@ -304,7 +286,7 @@ int __init linux_main(int argc, char **a
 
 	highmem = 0;
 	iomem_size = (iomem_size + PAGE_SIZE - 1) & PAGE_MASK;
-	max_physmem = get_kmem_end() - uml_physmem - iomem_size - MIN_VMALLOC;
+	max_physmem = CONFIG_TOP_ADDR - uml_physmem - iomem_size - MIN_VMALLOC;
 
 	/*
 	 * Zones have to begin on a 1 << MAX_ORDER page boundary,
@@ -336,7 +318,7 @@ int __init linux_main(int argc, char **a
 	}
 
 	virtmem_size = physmem_size;
-	avail = get_kmem_end() - start_vm;
+	avail = CONFIG_TOP_ADDR - start_vm;
 	if (physmem_size > avail)
 		virtmem_size = avail;
 	end_vm = start_vm + virtmem_size;
diff -puN include/asm-um/a.out.h~uml-clean-up-task_size-usage include/asm-um/a.out.h
--- a/include/asm-um/a.out.h~uml-clean-up-task_size-usage
+++ a/include/asm-um/a.out.h
@@ -13,11 +13,9 @@
 
 extern unsigned long stacksizelim;
 
-extern unsigned long host_task_size;
-
 #define STACK_ROOM (stacksizelim)
 
-#define STACK_TOP task_size
+#define STACK_TOP (TASK_SIZE - 2 * PAGE_SIZE)
 
 #define STACK_TOP_MAX STACK_TOP
 
diff -puN include/asm-um/fixmap.h~uml-clean-up-task_size-usage include/asm-um/fixmap.h
--- a/include/asm-um/fixmap.h~uml-clean-up-task_size-usage
+++ a/include/asm-um/fixmap.h
@@ -56,9 +56,8 @@ extern void __set_fixmap (enum fixed_add
  * the start of the fixmap, and leave one page empty
  * at the top of mem..
  */
-extern unsigned long get_kmem_end(void);
 
-#define FIXADDR_TOP	(get_kmem_end() - 0x2000)
+#define FIXADDR_TOP	(CONFIG_TOP_ADDR - 2 * PAGE_SIZE)
 #define FIXADDR_SIZE	(__end_of_fixed_addresses << PAGE_SHIFT)
 #define FIXADDR_START	(FIXADDR_TOP - FIXADDR_SIZE)
 
diff -puN include/asm-um/processor-generic.h~uml-clean-up-task_size-usage include/asm-um/processor-generic.h
--- a/include/asm-um/processor-generic.h~uml-clean-up-task_size-usage
+++ a/include/asm-um/processor-generic.h
@@ -94,9 +94,7 @@ static inline void mm_copy_segments(stru
 /*
  * User space process size: 3GB (default).
  */
-extern unsigned long task_size;
-
-#define TASK_SIZE	(task_size)
+#define TASK_SIZE (CONFIG_TOP_ADDR & PGDIR_MASK)
 
 /* This decides where the kernel will search for a free chunk of vm
  * space during mmap's.
_

Patches currently in -mm which might be from jdike@addtoit.com are

git-kvm.patch
uml-arch-um-include-inith-needs-a-definition-of-__used.patch
uml-implement-get_wchan.patch
uml-implement-get_wchan-fix.patch
uml-get-rid-of-asmlinkage.patch
uml-get-rid-of-asmlinkage-checkpatch-fixes.patch
uml-document-new-ubd-flag.patch
uml-further-bugsc-tidying.patch
uml-further-bugsc-tidying-checkpatch-fixes.patch
uml-smp-needs-to-depend-on-broken-for-now.patch
uml-console-driver-cleanups.patch
uml-clonec-tidying.patch
uml-borrow-consth-techniques.patch
uml-delete-some-unused-headers.patch
uml-allow-lflags-on-command-line.patch
uml-tidy-kern_utilh.patch
uml-tidy-pgtableh.patch
uml-tidy-pgtableh-fix.patch
uml-reconst-a-parameter.patch
arch-um-remove-duplicate-includes.patch
uml-host-tls-diagnostics.patch
uml-move-um_virt_to_phys.patch
uml-header-untangling.patch
uml-style-cleanup.patch
uml-currenth-cleanup.patch
uml-fix-page-table-data-sizes.patch
uml-add-virt_to_pte.patch
uml-simplify-sigsegv-handling.patch
uml-use-ptrace-directly-in-libc-code.patch
uml-kill-processes-instead-of-panicing-kernel.patch
uml-clean-up-task_size-usage.patch
uml-cover-stubs-with-a-vma.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
