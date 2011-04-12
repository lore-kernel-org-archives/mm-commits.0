From: akpm@linux-foundation.org
Subject: + mm-convert-vma-vm_flags-to-64-bit.patch added to -mm tree
Date: Tue, 12 Apr 2011 14:36:07 -0700
Message-ID: <201104122136.p3CLa7LE004000@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40658 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932568Ab1DLVgt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Apr 2011 17:36:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, benh@kernel.crashing.org, dave@linux.vnet.ibm.com, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     mm: convert vma->vm_flags to 64 bit
has been added to the -mm tree.  Its filename is
     mm-convert-vma-vm_flags-to-64-bit.patch

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
Subject: mm: convert vma->vm_flags to 64 bit
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

For years, powerpc people repeatedly request us to convert vm_flags to
64bit.  Because now it has no room to store an addional powerpc specific
flags.

Here is previous discussion logs.

	http://lkml.org/lkml/2009/10/1/202
	http://lkml.org/lkml/2010/4/27/23

But, unforunately they didn't get merged.  This is 3rd trial.  I've merged
previous two posted patches and adapted it for latest tree.

No functional change.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/cacheflush.h            |    7 -
 arch/powerpc/include/asm/mman.h              |    6 -
 arch/sh/mm/tlbflush_64.c                     |    2 
 arch/x86/mm/hugetlbpage.c                    |    4 
 drivers/char/agp/frontend.c                  |    2 
 drivers/char/mem.c                           |    2 
 drivers/infiniband/hw/ipath/ipath_file_ops.c |    4 
 drivers/infiniband/hw/qib/qib_file_ops.c     |    4 
 drivers/media/video/omap3isp/ispqueue.h      |    2 
 fs/binfmt_elf_fdpic.c                        |   10 -
 fs/exec.c                                    |    2 
 fs/hugetlbfs/inode.c                         |    3 
 include/linux/huge_mm.h                      |    4 
 include/linux/hugetlb.h                      |    9 +
 include/linux/hugetlb_inline.h               |    2 
 include/linux/ksm.h                          |    8 -
 include/linux/mm.h                           |   95 ++++++++---------
 include/linux/mm_types.h                     |    7 -
 include/linux/mman.h                         |   11 +
 include/linux/rmap.h                         |    7 -
 ipc/shm.c                                    |    2 
 mm/huge_memory.c                             |    2 
 mm/hugetlb.c                                 |    2 
 mm/ksm.c                                     |    4 
 mm/madvise.c                                 |    2 
 mm/memory.c                                  |   10 -
 mm/mlock.c                                   |    8 -
 mm/mmap.c                                    |   45 ++++----
 mm/mprotect.c                                |    9 -
 mm/mremap.c                                  |    2 
 mm/nommu.c                                   |   15 +-
 mm/rmap.c                                    |    8 -
 mm/shmem.c                                   |   22 +--
 mm/vmscan.c                                  |    4 
 34 files changed, 171 insertions(+), 155 deletions(-)

diff -puN arch/arm/include/asm/cacheflush.h~mm-convert-vma-vm_flags-to-64-bit arch/arm/include/asm/cacheflush.h
--- a/arch/arm/include/asm/cacheflush.h~mm-convert-vma-vm_flags-to-64-bit
+++ a/arch/arm/include/asm/cacheflush.h
@@ -60,7 +60,7 @@
  *		specified address space before a change of page tables.
  *		- start - user start address (inclusive, page aligned)
  *		- end   - user end address   (exclusive, page aligned)
- *		- flags - vma->vm_flags field
+ *		- flags - low unsigned long of vma->vm_flags field
  *
  *	coherent_kern_range(start, end)
  *
@@ -217,7 +217,7 @@ vivt_flush_cache_range(struct vm_area_st
 {
 	if (cpumask_test_cpu(smp_processor_id(), mm_cpumask(vma->vm_mm)))
 		__cpuc_flush_user_range(start & PAGE_MASK, PAGE_ALIGN(end),
-					vma->vm_flags);
+					(unsigned long)vma->vm_flags);
 }
 
 static inline void
@@ -225,7 +225,8 @@ vivt_flush_cache_page(struct vm_area_str
 {
 	if (cpumask_test_cpu(smp_processor_id(), mm_cpumask(vma->vm_mm))) {
 		unsigned long addr = user_addr & PAGE_MASK;
-		__cpuc_flush_user_range(addr, addr + PAGE_SIZE, vma->vm_flags);
+		__cpuc_flush_user_range(addr, addr + PAGE_SIZE,
+					(unsigned long)vma->vm_flags);
 	}
 }
 
diff -puN arch/powerpc/include/asm/mman.h~mm-convert-vma-vm_flags-to-64-bit arch/powerpc/include/asm/mman.h
--- a/arch/powerpc/include/asm/mman.h~mm-convert-vma-vm_flags-to-64-bit
+++ a/arch/powerpc/include/asm/mman.h
@@ -38,13 +38,13 @@
  * This file is included by linux/mman.h, so we can't use cacl_vm_prot_bits()
  * here.  How important is the optimization?
  */
-static inline unsigned long arch_calc_vm_prot_bits(unsigned long prot)
+static inline unsigned long long arch_calc_vm_prot_bits(unsigned long prot)
 {
-	return (prot & PROT_SAO) ? VM_SAO : 0;
+	return (prot & PROT_SAO) ? VM_SAO : 0ULL;
 }
 #define arch_calc_vm_prot_bits(prot) arch_calc_vm_prot_bits(prot)
 
-static inline pgprot_t arch_vm_get_page_prot(unsigned long vm_flags)
+static inline pgprot_t arch_vm_get_page_prot(unsigned long long vm_flags)
 {
 	return (vm_flags & VM_SAO) ? __pgprot(_PAGE_SAO) : __pgprot(0);
 }
diff -puN arch/sh/mm/tlbflush_64.c~mm-convert-vma-vm_flags-to-64-bit arch/sh/mm/tlbflush_64.c
--- a/arch/sh/mm/tlbflush_64.c~mm-convert-vma-vm_flags-to-64-bit
+++ a/arch/sh/mm/tlbflush_64.c
@@ -48,7 +48,7 @@ static inline void print_vma(struct vm_a
 	printk("vma end   0x%08lx\n", vma->vm_end);
 
 	print_prots(vma->vm_page_prot);
-	printk("vm_flags 0x%08lx\n", vma->vm_flags);
+	printk("vm_flags 0x%08llx\n", vma->vm_flags);
 }
 
 static inline void print_task(struct task_struct *tsk)
diff -puN arch/x86/mm/hugetlbpage.c~mm-convert-vma-vm_flags-to-64-bit arch/x86/mm/hugetlbpage.c
--- a/arch/x86/mm/hugetlbpage.c~mm-convert-vma-vm_flags-to-64-bit
+++ a/arch/x86/mm/hugetlbpage.c
@@ -26,8 +26,8 @@ static unsigned long page_table_shareabl
 	unsigned long s_end = sbase + PUD_SIZE;
 
 	/* Allow segments to share if only one is marked locked */
-	unsigned long vm_flags = vma->vm_flags & ~VM_LOCKED;
-	unsigned long svm_flags = svma->vm_flags & ~VM_LOCKED;
+	unsigned long long vm_flags = vma->vm_flags & ~VM_LOCKED;
+	unsigned long long svm_flags = svma->vm_flags & ~VM_LOCKED;
 
 	/*
 	 * match the virtual addresses, permission and the alignment of the
diff -puN drivers/char/agp/frontend.c~mm-convert-vma-vm_flags-to-64-bit drivers/char/agp/frontend.c
--- a/drivers/char/agp/frontend.c~mm-convert-vma-vm_flags-to-64-bit
+++ a/drivers/char/agp/frontend.c
@@ -155,7 +155,7 @@ static void agp_add_seg_to_client(struct
 
 static pgprot_t agp_convert_mmap_flags(int prot)
 {
-	unsigned long prot_bits;
+	unsigned long long prot_bits;
 
 	prot_bits = calc_vm_prot_bits(prot) | VM_SHARED;
 	return vm_get_page_prot(prot_bits);
diff -puN drivers/char/mem.c~mm-convert-vma-vm_flags-to-64-bit drivers/char/mem.c
--- a/drivers/char/mem.c~mm-convert-vma-vm_flags-to-64-bit
+++ a/drivers/char/mem.c
@@ -279,7 +279,7 @@ static unsigned long get_unmapped_area_m
 /* can't do an in-place private mapping if there's no MMU */
 static inline int private_mapping_ok(struct vm_area_struct *vma)
 {
-	return vma->vm_flags & VM_MAYSHARE;
+	return !!(vma->vm_flags & VM_MAYSHARE);
 }
 #else
 #define get_unmapped_area_mem	NULL
diff -puN drivers/infiniband/hw/ipath/ipath_file_ops.c~mm-convert-vma-vm_flags-to-64-bit drivers/infiniband/hw/ipath/ipath_file_ops.c
--- a/drivers/infiniband/hw/ipath/ipath_file_ops.c~mm-convert-vma-vm_flags-to-64-bit
+++ a/drivers/infiniband/hw/ipath/ipath_file_ops.c
@@ -1113,7 +1113,7 @@ static int mmap_rcvegrbufs(struct vm_are
 
 	if (vma->vm_flags & VM_WRITE) {
 		dev_info(&dd->pcidev->dev, "Can't map eager buffers as "
-			 "writable (flags=%lx)\n", vma->vm_flags);
+			 "writable (flags=%llx)\n", vma->vm_flags);
 		ret = -EPERM;
 		goto bail;
 	}
@@ -1202,7 +1202,7 @@ static int mmap_kvaddr(struct vm_area_st
                 if (vma->vm_flags & VM_WRITE) {
                         dev_info(&dd->pcidev->dev,
                                  "Can't map eager buffers as "
-                                 "writable (flags=%lx)\n", vma->vm_flags);
+                                 "writable (flags=%llx)\n", vma->vm_flags);
                         ret = -EPERM;
                         goto bail;
                 }
diff -puN drivers/infiniband/hw/qib/qib_file_ops.c~mm-convert-vma-vm_flags-to-64-bit drivers/infiniband/hw/qib/qib_file_ops.c
--- a/drivers/infiniband/hw/qib/qib_file_ops.c~mm-convert-vma-vm_flags-to-64-bit
+++ a/drivers/infiniband/hw/qib/qib_file_ops.c
@@ -856,7 +856,7 @@ static int mmap_rcvegrbufs(struct vm_are
 
 	if (vma->vm_flags & VM_WRITE) {
 		qib_devinfo(dd->pcidev, "Can't map eager buffers as "
-			 "writable (flags=%lx)\n", vma->vm_flags);
+			 "writable (flags=%llx)\n", vma->vm_flags);
 		ret = -EPERM;
 		goto bail;
 	}
@@ -945,7 +945,7 @@ static int mmap_kvaddr(struct vm_area_st
 		if (vma->vm_flags & VM_WRITE) {
 			qib_devinfo(dd->pcidev,
 				 "Can't map eager buffers as "
-				 "writable (flags=%lx)\n", vma->vm_flags);
+				 "writable (flags=%llx)\n", vma->vm_flags);
 			ret = -EPERM;
 			goto bail;
 		}
diff -puN drivers/media/video/omap3isp/ispqueue.h~mm-convert-vma-vm_flags-to-64-bit drivers/media/video/omap3isp/ispqueue.h
--- a/drivers/media/video/omap3isp/ispqueue.h~mm-convert-vma-vm_flags-to-64-bit
+++ a/drivers/media/video/omap3isp/ispqueue.h
@@ -90,7 +90,7 @@ struct isp_video_buffer {
 	void *vaddr;
 
 	/* For userspace buffers. */
-	unsigned long vm_flags;
+	unsigned long long vm_flags;
 	unsigned long offset;
 	unsigned int npages;
 	struct page **pages;
diff -puN fs/binfmt_elf_fdpic.c~mm-convert-vma-vm_flags-to-64-bit fs/binfmt_elf_fdpic.c
--- a/fs/binfmt_elf_fdpic.c~mm-convert-vma-vm_flags-to-64-bit
+++ a/fs/binfmt_elf_fdpic.c
@@ -1226,7 +1226,7 @@ static int maydump(struct vm_area_struct
 	 * them either. "dump_write()" can't handle it anyway.
 	 */
 	if (!(vma->vm_flags & VM_READ)) {
-		kdcore("%08lx: %08lx: no (!read)", vma->vm_start, vma->vm_flags);
+		kdcore("%08lx: %08llx: no (!read)", vma->vm_start, vma->vm_flags);
 		return 0;
 	}
 
@@ -1234,13 +1234,13 @@ static int maydump(struct vm_area_struct
 	if (vma->vm_flags & VM_SHARED) {
 		if (vma->vm_file->f_path.dentry->d_inode->i_nlink == 0) {
 			dump_ok = test_bit(MMF_DUMP_ANON_SHARED, &mm_flags);
-			kdcore("%08lx: %08lx: %s (share)", vma->vm_start,
+			kdcore("%08lx: %08llx: %s (share)", vma->vm_start,
 			       vma->vm_flags, dump_ok ? "yes" : "no");
 			return dump_ok;
 		}
 
 		dump_ok = test_bit(MMF_DUMP_MAPPED_SHARED, &mm_flags);
-		kdcore("%08lx: %08lx: %s (share)", vma->vm_start,
+		kdcore("%08lx: %08llx: %s (share)", vma->vm_start,
 		       vma->vm_flags, dump_ok ? "yes" : "no");
 		return dump_ok;
 	}
@@ -1249,14 +1249,14 @@ static int maydump(struct vm_area_struct
 	/* By default, if it hasn't been written to, don't write it out */
 	if (!vma->anon_vma) {
 		dump_ok = test_bit(MMF_DUMP_MAPPED_PRIVATE, &mm_flags);
-		kdcore("%08lx: %08lx: %s (!anon)", vma->vm_start,
+		kdcore("%08lx: %08llx: %s (!anon)", vma->vm_start,
 		       vma->vm_flags, dump_ok ? "yes" : "no");
 		return dump_ok;
 	}
 #endif
 
 	dump_ok = test_bit(MMF_DUMP_ANON_PRIVATE, &mm_flags);
-	kdcore("%08lx: %08lx: %s", vma->vm_start, vma->vm_flags,
+	kdcore("%08lx: %08llx: %s", vma->vm_start, vma->vm_flags,
 	       dump_ok ? "yes" : "no");
 	return dump_ok;
 }
diff -puN fs/exec.c~mm-convert-vma-vm_flags-to-64-bit fs/exec.c
--- a/fs/exec.c~mm-convert-vma-vm_flags-to-64-bit
+++ a/fs/exec.c
@@ -619,7 +619,7 @@ int setup_arg_pages(struct linux_binprm 
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma = bprm->vma;
 	struct vm_area_struct *prev = NULL;
-	unsigned long vm_flags;
+	unsigned long long vm_flags;
 	unsigned long stack_base;
 	unsigned long stack_size;
 	unsigned long stack_expand;
diff -puN fs/hugetlbfs/inode.c~mm-convert-vma-vm_flags-to-64-bit fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~mm-convert-vma-vm_flags-to-64-bit
+++ a/fs/hugetlbfs/inode.c
@@ -921,7 +921,8 @@ static int can_do_hugetlb_shm(void)
 	return capable(CAP_IPC_LOCK) || in_group_p(sysctl_hugetlb_shm_group);
 }
 
-struct file *hugetlb_file_setup(const char *name, size_t size, int acctflag,
+struct file *hugetlb_file_setup(const char *name, size_t size,
+				unsigned long long acctflag,
 				struct user_struct **user, int creat_flags)
 {
 	int error = -ENOMEM;
diff -puN include/linux/huge_mm.h~mm-convert-vma-vm_flags-to-64-bit include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~mm-convert-vma-vm_flags-to-64-bit
+++ a/include/linux/huge_mm.h
@@ -107,7 +107,7 @@ extern void __split_huge_page_pmd(struct
 #error "hugepages can't be allocated by the buddy allocator"
 #endif
 extern int hugepage_madvise(struct vm_area_struct *vma,
-			    unsigned long *vm_flags, int advice);
+			    unsigned long long *vm_flags, int advice);
 extern void __vma_adjust_trans_huge(struct vm_area_struct *vma,
 				    unsigned long start,
 				    unsigned long end,
@@ -164,7 +164,7 @@ static inline int split_huge_page(struct
 	do { } while (0)
 #define compound_trans_head(page) compound_head(page)
 static inline int hugepage_madvise(struct vm_area_struct *vma,
-				   unsigned long *vm_flags, int advice)
+				   unsigned long long *vm_flags, int advice)
 {
 	BUG();
 	return 0;
diff -puN include/linux/hugetlb.h~mm-convert-vma-vm_flags-to-64-bit include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-convert-vma-vm_flags-to-64-bit
+++ a/include/linux/hugetlb.h
@@ -41,7 +41,7 @@ int hugetlb_fault(struct mm_struct *mm, 
 			unsigned long address, unsigned int flags);
 int hugetlb_reserve_pages(struct inode *inode, long from, long to,
 						struct vm_area_struct *vma,
-						int acctflags);
+						unsigned long long acctflags);
 void hugetlb_unreserve_pages(struct inode *inode, long offset, long freed);
 int dequeue_hwpoisoned_huge_page(struct page *page);
 void copy_huge_page(struct page *dst, struct page *src);
@@ -168,7 +168,8 @@ static inline struct hugetlbfs_sb_info *
 
 extern const struct file_operations hugetlbfs_file_operations;
 extern const struct vm_operations_struct hugetlb_vm_ops;
-struct file *hugetlb_file_setup(const char *name, size_t size, int acct,
+struct file *hugetlb_file_setup(const char *name, size_t size,
+				unsigned long long acctflag,
 				struct user_struct **user, int creat_flags);
 int hugetlb_get_quota(struct address_space *mapping, long delta);
 void hugetlb_put_quota(struct address_space *mapping, long delta);
@@ -192,7 +193,9 @@ static inline void set_file_hugepages(st
 #define is_file_hugepages(file)			0
 #define set_file_hugepages(file)		BUG()
 static inline struct file *hugetlb_file_setup(const char *name, size_t size,
-		int acctflag, struct user_struct **user, int creat_flags)
+					      unsigned long long acctflag,
+					      struct user_struct **user,
+					      int creat_flags)
 {
 	return ERR_PTR(-ENOSYS);
 }
diff -puN include/linux/hugetlb_inline.h~mm-convert-vma-vm_flags-to-64-bit include/linux/hugetlb_inline.h
--- a/include/linux/hugetlb_inline.h~mm-convert-vma-vm_flags-to-64-bit
+++ a/include/linux/hugetlb_inline.h
@@ -7,7 +7,7 @@
 
 static inline int is_vm_hugetlb_page(struct vm_area_struct *vma)
 {
-	return vma->vm_flags & VM_HUGETLB;
+	return !!(vma->vm_flags & VM_HUGETLB);
 }
 
 #else
diff -puN include/linux/ksm.h~mm-convert-vma-vm_flags-to-64-bit include/linux/ksm.h
--- a/include/linux/ksm.h~mm-convert-vma-vm_flags-to-64-bit
+++ a/include/linux/ksm.h
@@ -21,7 +21,7 @@ struct page *ksm_does_need_to_copy(struc
 
 #ifdef CONFIG_KSM
 int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
-		unsigned long end, int advice, unsigned long *vm_flags);
+		unsigned long end, int advice, unsigned long long *vm_flags);
 int __ksm_enter(struct mm_struct *mm);
 void __ksm_exit(struct mm_struct *mm);
 
@@ -84,7 +84,7 @@ static inline int ksm_might_need_to_copy
 }
 
 int page_referenced_ksm(struct page *page,
-			struct mem_cgroup *memcg, unsigned long *vm_flags);
+			struct mem_cgroup *memcg, unsigned long long *vm_flags);
 int try_to_unmap_ksm(struct page *page, enum ttu_flags flags);
 int rmap_walk_ksm(struct page *page, int (*rmap_one)(struct page *,
 		  struct vm_area_struct *, unsigned long, void *), void *arg);
@@ -108,7 +108,7 @@ static inline int PageKsm(struct page *p
 
 #ifdef CONFIG_MMU
 static inline int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
-		unsigned long end, int advice, unsigned long *vm_flags)
+		unsigned long end, int advice, unsigned long long *vm_flags)
 {
 	return 0;
 }
@@ -120,7 +120,7 @@ static inline int ksm_might_need_to_copy
 }
 
 static inline int page_referenced_ksm(struct page *page,
-			struct mem_cgroup *memcg, unsigned long *vm_flags)
+			struct mem_cgroup *memcg, unsigned long long *vm_flags)
 {
 	return 0;
 }
diff -puN include/linux/mm.h~mm-convert-vma-vm_flags-to-64-bit include/linux/mm.h
--- a/include/linux/mm.h~mm-convert-vma-vm_flags-to-64-bit
+++ a/include/linux/mm.h
@@ -67,55 +67,55 @@ extern unsigned int kobjsize(const void 
 /*
  * vm_flags in vm_area_struct, see mm_types.h.
  */
-#define VM_READ		0x00000001	/* currently active flags */
-#define VM_WRITE	0x00000002
-#define VM_EXEC		0x00000004
-#define VM_SHARED	0x00000008
+#define VM_READ		0x00000001ULL	/* currently active flags */
+#define VM_WRITE	0x00000002ULL
+#define VM_EXEC		0x00000004ULL
+#define VM_SHARED	0x00000008ULL
 
 /* mprotect() hardcodes VM_MAYREAD >> 4 == VM_READ, and so for r/w/x bits. */
-#define VM_MAYREAD	0x00000010	/* limits for mprotect() etc */
-#define VM_MAYWRITE	0x00000020
-#define VM_MAYEXEC	0x00000040
-#define VM_MAYSHARE	0x00000080
+#define VM_MAYREAD	0x00000010ULL	/* limits for mprotect() etc */
+#define VM_MAYWRITE	0x00000020ULL
+#define VM_MAYEXEC	0x00000040ULL
+#define VM_MAYSHARE	0x00000080ULL
 
-#define VM_GROWSDOWN	0x00000100	/* general info on the segment */
+#define VM_GROWSDOWN	0x00000100ULL	/* general info on the segment */
 #if defined(CONFIG_STACK_GROWSUP) || defined(CONFIG_IA64)
-#define VM_GROWSUP	0x00000200
+#define VM_GROWSUP	0x00000200ULL
 #else
-#define VM_GROWSUP	0x00000000
-#define VM_NOHUGEPAGE	0x00000200	/* MADV_NOHUGEPAGE marked this vma */
+#define VM_GROWSUP	0x00000000ULL
+#define VM_NOHUGEPAGE	0x00000200ULL	/* MADV_NOHUGEPAGE marked this vma */
 #endif
-#define VM_PFNMAP	0x00000400	/* Page-ranges managed without "struct page", just pure PFN */
-#define VM_DENYWRITE	0x00000800	/* ETXTBSY on write attempts.. */
+#define VM_PFNMAP	0x00000400ULL	/* Page-ranges managed without "struct page", just pure PFN */
+#define VM_DENYWRITE	0x00000800ULL	/* ETXTBSY on write attempts.. */
 
-#define VM_EXECUTABLE	0x00001000
-#define VM_LOCKED	0x00002000
-#define VM_IO           0x00004000	/* Memory mapped I/O or similar */
+#define VM_EXECUTABLE	0x00001000ULL
+#define VM_LOCKED	0x00002000ULL
+#define VM_IO           0x00004000ULL	/* Memory mapped I/O or similar */
 
 					/* Used by sys_madvise() */
-#define VM_SEQ_READ	0x00008000	/* App will access data sequentially */
-#define VM_RAND_READ	0x00010000	/* App will not benefit from clustered reads */
+#define VM_SEQ_READ	0x00008000ULL	/* App will access data sequentially */
+#define VM_RAND_READ	0x00010000ULL	/* App will not benefit from clustered reads */
 
-#define VM_DONTCOPY	0x00020000      /* Do not copy this vma on fork */
-#define VM_DONTEXPAND	0x00040000	/* Cannot expand with mremap() */
-#define VM_RESERVED	0x00080000	/* Count as reserved_vm like IO */
-#define VM_ACCOUNT	0x00100000	/* Is a VM accounted object */
-#define VM_NORESERVE	0x00200000	/* should the VM suppress accounting */
-#define VM_HUGETLB	0x00400000	/* Huge TLB Page VM */
-#define VM_NONLINEAR	0x00800000	/* Is non-linear (remap_file_pages) */
+#define VM_DONTCOPY	0x00020000ULL	/* Do not copy this vma on fork */
+#define VM_DONTEXPAND	0x00040000ULL	/* Cannot expand with mremap() */
+#define VM_RESERVED	0x00080000ULL	/* Count as reserved_vm like IO */
+#define VM_ACCOUNT	0x00100000ULL	/* Is a VM accounted object */
+#define VM_NORESERVE	0x00200000ULL	/* should the VM suppress accounting */
+#define VM_HUGETLB	0x00400000ULL	/* Huge TLB Page VM */
+#define VM_NONLINEAR	0x00800000ULL	/* Is non-linear (remap_file_pages) */
 #ifndef CONFIG_TRANSPARENT_HUGEPAGE
-#define VM_MAPPED_COPY	0x01000000	/* T if mapped copy of data (nommu mmap) */
+#define VM_MAPPED_COPY	0x01000000ULL	/* T if mapped copy of data (nommu mmap) */
 #else
-#define VM_HUGEPAGE	0x01000000	/* MADV_HUGEPAGE marked this vma */
+#define VM_HUGEPAGE	0x01000000ULL	/* MADV_HUGEPAGE marked this vma */
 #endif
-#define VM_INSERTPAGE	0x02000000	/* The vma has had "vm_insert_page()" done on it */
-#define VM_ALWAYSDUMP	0x04000000	/* Always include in core dumps */
+#define VM_INSERTPAGE	0x02000000ULL	/* The vma has had "vm_insert_page()" done on it */
+#define VM_ALWAYSDUMP	0x04000000ULL	/* Always include in core dumps */
 
-#define VM_CAN_NONLINEAR 0x08000000	/* Has ->fault & does nonlinear pages */
-#define VM_MIXEDMAP	0x10000000	/* Can contain "struct page" and pure PFN pages */
-#define VM_SAO		0x20000000	/* Strong Access Ordering (powerpc) */
-#define VM_PFN_AT_MMAP	0x40000000	/* PFNMAP vma that is fully mapped at mmap time */
-#define VM_MERGEABLE	0x80000000	/* KSM may merge identical pages */
+#define VM_CAN_NONLINEAR 0x08000000ULL	/* Has ->fault & does nonlinear pages */
+#define VM_MIXEDMAP	0x10000000ULL	/* Can contain "struct page" and pure PFN pages */
+#define VM_SAO		0x20000000ULL	/* Strong Access Ordering (powerpc) */
+#define VM_PFN_AT_MMAP	0x40000000ULL	/* PFNMAP vma that is fully mapped at mmap time */
+#define VM_MERGEABLE	0x80000000ULL	/* KSM may merge identical pages */
 
 /* Bits set in the VMA until the stack is in its final location */
 #define VM_STACK_INCOMPLETE_SETUP	(VM_RAND_READ | VM_SEQ_READ)
@@ -164,12 +164,12 @@ extern pgprot_t protection_map[16];
  */
 static inline int is_linear_pfn_mapping(struct vm_area_struct *vma)
 {
-	return (vma->vm_flags & VM_PFN_AT_MMAP);
+	return !!(vma->vm_flags & VM_PFN_AT_MMAP);
 }
 
 static inline int is_pfn_mapping(struct vm_area_struct *vma)
 {
-	return (vma->vm_flags & VM_PFNMAP);
+	return !!(vma->vm_flags & VM_PFNMAP);
 }
 
 /*
@@ -871,7 +871,7 @@ extern void show_free_areas(unsigned int
 extern bool skip_free_areas_node(unsigned int flags, int nid);
 
 int shmem_lock(struct file *file, int lock, struct user_struct *user);
-struct file *shmem_file_setup(const char *name, loff_t size, unsigned long flags);
+struct file *shmem_file_setup(const char *name, loff_t size, unsigned long long vm_flags);
 int shmem_zero_setup(struct vm_area_struct *);
 
 #ifndef CONFIG_MMU
@@ -1024,7 +1024,7 @@ extern unsigned long do_mremap(unsigned 
 			       unsigned long flags, unsigned long new_addr);
 extern int mprotect_fixup(struct vm_area_struct *vma,
 			  struct vm_area_struct **pprev, unsigned long start,
-			  unsigned long end, unsigned long newflags);
+			  unsigned long end, unsigned long long newflags);
 
 /*
  * doesn't attempt to fault and will return short.
@@ -1398,7 +1398,7 @@ extern int vma_adjust(struct vm_area_str
 	unsigned long end, pgoff_t pgoff, struct vm_area_struct *insert);
 extern struct vm_area_struct *vma_merge(struct mm_struct *,
 	struct vm_area_struct *prev, unsigned long addr, unsigned long end,
-	unsigned long vm_flags, struct anon_vma *, struct file *, pgoff_t,
+	unsigned long long vm_flags, struct anon_vma *, struct file *, pgoff_t,
 	struct mempolicy *);
 extern struct anon_vma *find_mergeable_anon_vma(struct vm_area_struct *);
 extern int split_vma(struct mm_struct *,
@@ -1429,7 +1429,8 @@ static inline void removed_exe_file_vma(
 extern int may_expand_vm(struct mm_struct *mm, unsigned long npages);
 extern int install_special_mapping(struct mm_struct *mm,
 				   unsigned long addr, unsigned long len,
-				   unsigned long flags, struct page **pages);
+				   unsigned long long vm_flags,
+				   struct page **pages);
 
 extern unsigned long get_unmapped_area(struct file *, unsigned long, unsigned long, unsigned long, unsigned long);
 
@@ -1438,7 +1439,7 @@ extern unsigned long do_mmap_pgoff(struc
 	unsigned long flag, unsigned long pgoff);
 extern unsigned long mmap_region(struct file *file, unsigned long addr,
 	unsigned long len, unsigned long flags,
-	unsigned int vm_flags, unsigned long pgoff);
+	unsigned long long vm_flags, unsigned long pgoff);
 
 static inline unsigned long do_mmap(struct file *file, unsigned long addr,
 	unsigned long len, unsigned long prot,
@@ -1527,9 +1528,9 @@ static inline unsigned long vma_pages(st
 }
 
 #ifdef CONFIG_MMU
-pgprot_t vm_get_page_prot(unsigned long vm_flags);
+pgprot_t vm_get_page_prot(unsigned long long vm_flags);
 #else
-static inline pgprot_t vm_get_page_prot(unsigned long vm_flags)
+static inline pgprot_t vm_get_page_prot(unsigned long long vm_flags)
 {
 	return __pgprot(0);
 }
@@ -1563,10 +1564,12 @@ extern int apply_to_page_range(struct mm
 			       unsigned long size, pte_fn_t fn, void *data);
 
 #ifdef CONFIG_PROC_FS
-void vm_stat_account(struct mm_struct *, unsigned long, struct file *, long);
+void vm_stat_account(struct mm_struct *mm, unsigned long long vm_flags,
+		     struct file *file, long pages);
 #else
 static inline void vm_stat_account(struct mm_struct *mm,
-			unsigned long flags, struct file *file, long pages)
+				   unsigned long long flags,
+				   struct file *file, long pages)
 {
 }
 #endif /* CONFIG_PROC_FS */
diff -puN include/linux/mm_types.h~mm-convert-vma-vm_flags-to-64-bit include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-convert-vma-vm_flags-to-64-bit
+++ a/include/linux/mm_types.h
@@ -109,7 +109,7 @@ struct page {
  */
 struct vm_region {
 	struct rb_node	vm_rb;		/* link in global region tree */
-	unsigned long	vm_flags;	/* VMA vm_flags */
+	unsigned long long vm_flags;	/* VMA vm_flags */
 	unsigned long	vm_start;	/* start address of region */
 	unsigned long	vm_end;		/* region initialised to here */
 	unsigned long	vm_top;		/* region allocated to here */
@@ -137,7 +137,7 @@ struct vm_area_struct {
 	struct vm_area_struct *vm_next, *vm_prev;
 
 	pgprot_t vm_page_prot;		/* Access permissions of this VMA. */
-	unsigned long vm_flags;		/* Flags, see mm.h. */
+	unsigned long long vm_flags;		/* Flags, see mm.h. */
 
 	struct rb_node vm_rb;
 
@@ -251,7 +251,8 @@ struct mm_struct {
 	unsigned long hiwater_vm;	/* High-water virtual memory usage */
 
 	unsigned long total_vm, locked_vm, shared_vm, exec_vm;
-	unsigned long stack_vm, reserved_vm, def_flags, nr_ptes;
+	unsigned long stack_vm, reserved_vm, nr_ptes;
+	unsigned long long def_flags;
 	unsigned long start_code, end_code, start_data, end_data;
 	unsigned long start_brk, brk, start_stack;
 	unsigned long arg_start, arg_end, env_start, env_end;
diff -puN include/linux/mman.h~mm-convert-vma-vm_flags-to-64-bit include/linux/mman.h
--- a/include/linux/mman.h~mm-convert-vma-vm_flags-to-64-bit
+++ a/include/linux/mman.h
@@ -35,11 +35,14 @@ static inline void vm_unacct_memory(long
  */
 
 #ifndef arch_calc_vm_prot_bits
-#define arch_calc_vm_prot_bits(prot) 0
+#define arch_calc_vm_prot_bits(prot) 0ULL
 #endif
 
 #ifndef arch_vm_get_page_prot
-#define arch_vm_get_page_prot(vm_flags) __pgprot(0)
+static inline pgprot_t arch_vm_get_page_prot(unsigned long long vm_flags)
+{
+	return __pgprot(0);
+}
 #endif
 
 #ifndef arch_validate_prot
@@ -69,7 +72,7 @@ static inline int arch_validate_prot(uns
 /*
  * Combine the mmap "prot" argument into "vm_flags" used internally.
  */
-static inline unsigned long
+static inline unsigned long long
 calc_vm_prot_bits(unsigned long prot)
 {
 	return _calc_vm_trans(prot, PROT_READ,  VM_READ ) |
@@ -81,7 +84,7 @@ calc_vm_prot_bits(unsigned long prot)
 /*
  * Combine the mmap "flags" argument into "vm_flags" used internally.
  */
-static inline unsigned long
+static inline unsigned long long
 calc_vm_flag_bits(unsigned long flags)
 {
 	return _calc_vm_trans(flags, MAP_GROWSDOWN,  VM_GROWSDOWN ) |
diff -puN include/linux/rmap.h~mm-convert-vma-vm_flags-to-64-bit include/linux/rmap.h
--- a/include/linux/rmap.h~mm-convert-vma-vm_flags-to-64-bit
+++ a/include/linux/rmap.h
@@ -157,9 +157,10 @@ static inline void page_dup_rmap(struct 
  * Called from mm/vmscan.c to handle paging out
  */
 int page_referenced(struct page *, int is_locked,
-			struct mem_cgroup *cnt, unsigned long *vm_flags);
+			struct mem_cgroup *cnt, unsigned long long *vm_flags);
 int page_referenced_one(struct page *, struct vm_area_struct *,
-	unsigned long address, unsigned int *mapcount, unsigned long *vm_flags);
+			unsigned long address, unsigned int *mapcount,
+			unsigned long long *vm_flags);
 
 enum ttu_flags {
 	TTU_UNMAP = 0,			/* unmap mode */
@@ -249,7 +250,7 @@ int rmap_walk(struct page *page, int (*r
 
 static inline int page_referenced(struct page *page, int is_locked,
 				  struct mem_cgroup *cnt,
-				  unsigned long *vm_flags)
+				  unsigned long long *vm_flags)
 {
 	*vm_flags = 0;
 	return 0;
diff -puN ipc/shm.c~mm-convert-vma-vm_flags-to-64-bit ipc/shm.c
--- a/ipc/shm.c~mm-convert-vma-vm_flags-to-64-bit
+++ a/ipc/shm.c
@@ -347,7 +347,7 @@ static int newseg(struct ipc_namespace *
 	struct file * file;
 	char name[13];
 	int id;
-	int acctflag = 0;
+	unsigned long long acctflag = 0;
 
 	if (size < SHMMIN || size > ns->shm_ctlmax)
 		return -EINVAL;
diff -puN mm/huge_memory.c~mm-convert-vma-vm_flags-to-64-bit mm/huge_memory.c
--- a/mm/huge_memory.c~mm-convert-vma-vm_flags-to-64-bit
+++ a/mm/huge_memory.c
@@ -1405,7 +1405,7 @@ out:
 }
 
 int hugepage_madvise(struct vm_area_struct *vma,
-		     unsigned long *vm_flags, int advice)
+		     unsigned long long *vm_flags, int advice)
 {
 	switch (advice) {
 	case MADV_HUGEPAGE:
diff -puN mm/hugetlb.c~mm-convert-vma-vm_flags-to-64-bit mm/hugetlb.c
--- a/mm/hugetlb.c~mm-convert-vma-vm_flags-to-64-bit
+++ a/mm/hugetlb.c
@@ -2833,7 +2833,7 @@ void hugetlb_change_protection(struct vm
 int hugetlb_reserve_pages(struct inode *inode,
 					long from, long to,
 					struct vm_area_struct *vma,
-					int acctflag)
+					unsigned long long acctflag)
 {
 	long ret, chg;
 	struct hstate *h = hstate_inode(inode);
diff -puN mm/ksm.c~mm-convert-vma-vm_flags-to-64-bit mm/ksm.c
--- a/mm/ksm.c~mm-convert-vma-vm_flags-to-64-bit
+++ a/mm/ksm.c
@@ -1446,7 +1446,7 @@ static int ksm_scan_thread(void *nothing
 }
 
 int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
-		unsigned long end, int advice, unsigned long *vm_flags)
+		unsigned long end, int advice, unsigned long long *vm_flags)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	int err;
@@ -1581,7 +1581,7 @@ struct page *ksm_does_need_to_copy(struc
 }
 
 int page_referenced_ksm(struct page *page, struct mem_cgroup *memcg,
-			unsigned long *vm_flags)
+			unsigned long long *vm_flags)
 {
 	struct stable_node *stable_node;
 	struct rmap_item *rmap_item;
diff -puN mm/madvise.c~mm-convert-vma-vm_flags-to-64-bit mm/madvise.c
--- a/mm/madvise.c~mm-convert-vma-vm_flags-to-64-bit
+++ a/mm/madvise.c
@@ -43,7 +43,7 @@ static long madvise_behavior(struct vm_a
 	struct mm_struct * mm = vma->vm_mm;
 	int error = 0;
 	pgoff_t pgoff;
-	unsigned long new_flags = vma->vm_flags;
+	unsigned long long new_flags = vma->vm_flags;
 
 	switch (behavior) {
 	case MADV_NORMAL:
diff -puN mm/memory.c~mm-convert-vma-vm_flags-to-64-bit mm/memory.c
--- a/mm/memory.c~mm-convert-vma-vm_flags-to-64-bit
+++ a/mm/memory.c
@@ -518,7 +518,7 @@ static void print_bad_pte(struct vm_area
 	if (page)
 		dump_page(page);
 	printk(KERN_ALERT
-		"addr:%p vm_flags:%08lx anon_vma:%p mapping:%p index:%lx\n",
+		"addr:%p vm_flags:%08llx anon_vma:%p mapping:%p index:%lx\n",
 		(void *)addr, vma->vm_flags, vma->anon_vma, mapping, index);
 	/*
 	 * Choose text because data symbols depend on CONFIG_KALLSYMS_ALL=y
@@ -533,9 +533,9 @@ static void print_bad_pte(struct vm_area
 	add_taint(TAINT_BAD_PAGE);
 }
 
-static inline int is_cow_mapping(unsigned int flags)
+static inline int is_cow_mapping(unsigned long long vm_flags)
 {
-	return (flags & (VM_SHARED | VM_MAYWRITE)) == VM_MAYWRITE;
+	return (vm_flags & (VM_SHARED | VM_MAYWRITE)) == VM_MAYWRITE;
 }
 
 #ifndef is_zero_pfn
@@ -658,7 +658,7 @@ copy_one_pte(struct mm_struct *dst_mm, s
 		pte_t *dst_pte, pte_t *src_pte, struct vm_area_struct *vma,
 		unsigned long addr, int *rss)
 {
-	unsigned long vm_flags = vma->vm_flags;
+	unsigned long long vm_flags = vma->vm_flags;
 	pte_t pte = *src_pte;
 	struct page *page;
 
@@ -1465,7 +1465,7 @@ int __get_user_pages(struct task_struct 
 		     int *nonblocking)
 {
 	int i;
-	unsigned long vm_flags;
+	unsigned long long vm_flags;
 
 	if (nr_pages <= 0)
 		return 0;
diff -puN mm/mlock.c~mm-convert-vma-vm_flags-to-64-bit mm/mlock.c
--- a/mm/mlock.c~mm-convert-vma-vm_flags-to-64-bit
+++ a/mm/mlock.c
@@ -323,13 +323,13 @@ void munlock_vma_pages_range(struct vm_a
  * For vmas that pass the filters, merge/split as appropriate.
  */
 static int mlock_fixup(struct vm_area_struct *vma, struct vm_area_struct **prev,
-	unsigned long start, unsigned long end, unsigned int newflags)
+	unsigned long start, unsigned long end, unsigned long long newflags)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	pgoff_t pgoff;
 	int nr_pages;
 	int ret = 0;
-	int lock = newflags & VM_LOCKED;
+	int lock = !!(newflags & VM_LOCKED);
 
 	if (newflags == vma->vm_flags || (vma->vm_flags & VM_SPECIAL) ||
 	    is_vm_hugetlb_page(vma) || vma == get_gate_vma(current->mm))
@@ -401,7 +401,7 @@ static int do_mlock(unsigned long start,
 		prev = vma;
 
 	for (nstart = start ; ; ) {
-		unsigned int newflags;
+		unsigned long long newflags;
 
 		/* Here we know that  vma->vm_start <= nstart < vma->vm_end. */
 
@@ -540,7 +540,7 @@ static int do_mlockall(int flags)
 		goto out;
 
 	for (vma = current->mm->mmap; vma ; vma = prev->vm_next) {
-		unsigned int newflags;
+		unsigned long long newflags;
 
 		newflags = vma->vm_flags | VM_LOCKED;
 		if (!(flags & MCL_CURRENT))
diff -puN mm/mmap.c~mm-convert-vma-vm_flags-to-64-bit mm/mmap.c
--- a/mm/mmap.c~mm-convert-vma-vm_flags-to-64-bit
+++ a/mm/mmap.c
@@ -76,7 +76,7 @@ pgprot_t protection_map[16] = {
 	__S000, __S001, __S010, __S011, __S100, __S101, __S110, __S111
 };
 
-pgprot_t vm_get_page_prot(unsigned long vm_flags)
+pgprot_t vm_get_page_prot(unsigned long long vm_flags)
 {
 	return __pgprot(pgprot_val(protection_map[vm_flags &
 				(VM_READ|VM_WRITE|VM_EXEC|VM_SHARED)]) |
@@ -667,7 +667,7 @@ again:			remove_next = 1 + (end > next->
  * per-vma resources, so we don't attempt to merge those.
  */
 static inline int is_mergeable_vma(struct vm_area_struct *vma,
-			struct file *file, unsigned long vm_flags)
+			struct file *file, unsigned long long vm_flags)
 {
 	/* VM_CAN_NONLINEAR may get set later by f_op->mmap() */
 	if ((vma->vm_flags ^ vm_flags) & ~VM_CAN_NONLINEAR)
@@ -705,7 +705,7 @@ static inline int is_mergeable_anon_vma(
  * wrap, nor mmaps which cover the final page at index -1UL.
  */
 static int
-can_vma_merge_before(struct vm_area_struct *vma, unsigned long vm_flags,
+can_vma_merge_before(struct vm_area_struct *vma, unsigned long long vm_flags,
 	struct anon_vma *anon_vma, struct file *file, pgoff_t vm_pgoff)
 {
 	if (is_mergeable_vma(vma, file, vm_flags) &&
@@ -724,7 +724,7 @@ can_vma_merge_before(struct vm_area_stru
  * anon_vmas, nor if same anon_vma is assigned but offsets incompatible.
  */
 static int
-can_vma_merge_after(struct vm_area_struct *vma, unsigned long vm_flags,
+can_vma_merge_after(struct vm_area_struct *vma, unsigned long long vm_flags,
 	struct anon_vma *anon_vma, struct file *file, pgoff_t vm_pgoff)
 {
 	if (is_mergeable_vma(vma, file, vm_flags) &&
@@ -768,7 +768,7 @@ can_vma_merge_after(struct vm_area_struc
  */
 struct vm_area_struct *vma_merge(struct mm_struct *mm,
 			struct vm_area_struct *prev, unsigned long addr,
-			unsigned long end, unsigned long vm_flags,
+			unsigned long end, unsigned long long vm_flags,
 		     	struct anon_vma *anon_vma, struct file *file,
 			pgoff_t pgoff, struct mempolicy *policy)
 {
@@ -944,19 +944,19 @@ none:
 }
 
 #ifdef CONFIG_PROC_FS
-void vm_stat_account(struct mm_struct *mm, unsigned long flags,
-						struct file *file, long pages)
+void vm_stat_account(struct mm_struct *mm, unsigned long long vm_flags,
+		     struct file *file, long pages)
 {
-	const unsigned long stack_flags
+	const unsigned long long stack_flags
 		= VM_STACK_FLAGS & (VM_GROWSUP|VM_GROWSDOWN);
 
 	if (file) {
 		mm->shared_vm += pages;
-		if ((flags & (VM_EXEC|VM_WRITE)) == VM_EXEC)
+		if ((vm_flags & (VM_EXEC|VM_WRITE)) == VM_EXEC)
 			mm->exec_vm += pages;
-	} else if (flags & stack_flags)
+	} else if (vm_flags & stack_flags)
 		mm->stack_vm += pages;
-	if (flags & (VM_RESERVED|VM_IO))
+	if (vm_flags & (VM_RESERVED|VM_IO))
 		mm->reserved_vm += pages;
 }
 #endif /* CONFIG_PROC_FS */
@@ -971,7 +971,7 @@ unsigned long do_mmap_pgoff(struct file 
 {
 	struct mm_struct * mm = current->mm;
 	struct inode *inode;
-	unsigned int vm_flags;
+	unsigned long long vm_flags;
 	int error;
 	unsigned long reqprot = prot;
 
@@ -1176,7 +1176,7 @@ SYSCALL_DEFINE1(old_mmap, struct mmap_ar
  */
 int vma_wants_writenotify(struct vm_area_struct *vma)
 {
-	unsigned int vm_flags = vma->vm_flags;
+	unsigned long long vm_flags = vma->vm_flags;
 
 	/* If it was private or non-writable, the write bit is already clear */
 	if ((vm_flags & (VM_WRITE|VM_SHARED)) != ((VM_WRITE|VM_SHARED)))
@@ -1204,7 +1204,8 @@ int vma_wants_writenotify(struct vm_area
  * We account for memory if it's a private writeable mapping,
  * not hugepages and VM_NORESERVE wasn't set.
  */
-static inline int accountable_mapping(struct file *file, unsigned int vm_flags)
+static inline int accountable_mapping(struct file *file,
+				      unsigned long long vm_flags)
 {
 	/*
 	 * hugetlb has its own accounting separate from the core VM
@@ -1218,7 +1219,7 @@ static inline int accountable_mapping(st
 
 unsigned long mmap_region(struct file *file, unsigned long addr,
 			  unsigned long len, unsigned long flags,
-			  unsigned int vm_flags, unsigned long pgoff)
+			  unsigned long long vm_flags, unsigned long pgoff)
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma, *prev;
@@ -2157,7 +2158,7 @@ unsigned long do_brk(unsigned long addr,
 {
 	struct mm_struct * mm = current->mm;
 	struct vm_area_struct * vma, * prev;
-	unsigned long flags;
+	unsigned long long vm_flags;
 	struct rb_node ** rb_link, * rb_parent;
 	pgoff_t pgoff = addr >> PAGE_SHIFT;
 	int error;
@@ -2170,7 +2171,7 @@ unsigned long do_brk(unsigned long addr,
 	if (error)
 		return error;
 
-	flags = VM_DATA_DEFAULT_FLAGS | VM_ACCOUNT | mm->def_flags;
+	vm_flags = VM_DATA_DEFAULT_FLAGS | VM_ACCOUNT | mm->def_flags;
 
 	error = get_unmapped_area(NULL, addr, len, 0, MAP_FIXED);
 	if (error & ~PAGE_MASK)
@@ -2217,7 +2218,7 @@ unsigned long do_brk(unsigned long addr,
 		return -ENOMEM;
 
 	/* Can we just expand an old private anonymous mapping? */
-	vma = vma_merge(mm, prev, addr, addr + len, flags,
+	vma = vma_merge(mm, prev, addr, addr + len, vm_flags,
 					NULL, NULL, pgoff, NULL);
 	if (vma)
 		goto out;
@@ -2236,13 +2237,13 @@ unsigned long do_brk(unsigned long addr,
 	vma->vm_start = addr;
 	vma->vm_end = addr + len;
 	vma->vm_pgoff = pgoff;
-	vma->vm_flags = flags;
-	vma->vm_page_prot = vm_get_page_prot(flags);
+	vma->vm_flags = vm_flags;
+	vma->vm_page_prot = vm_get_page_prot(vm_flags);
 	vma_link(mm, vma, prev, rb_link, rb_parent);
 out:
 	perf_event_mmap(vma);
 	mm->total_vm += len >> PAGE_SHIFT;
-	if (flags & VM_LOCKED) {
+	if (vm_flags & VM_LOCKED) {
 		if (!mlock_vma_pages_range(vma, addr, addr + len))
 			mm->locked_vm += (len >> PAGE_SHIFT);
 	}
@@ -2464,7 +2465,7 @@ static const struct vm_operations_struct
  */
 int install_special_mapping(struct mm_struct *mm,
 			    unsigned long addr, unsigned long len,
-			    unsigned long vm_flags, struct page **pages)
+			    unsigned long long vm_flags, struct page **pages)
 {
 	int ret;
 	struct vm_area_struct *vma;
diff -puN mm/mprotect.c~mm-convert-vma-vm_flags-to-64-bit mm/mprotect.c
--- a/mm/mprotect.c~mm-convert-vma-vm_flags-to-64-bit
+++ a/mm/mprotect.c
@@ -143,10 +143,10 @@ static void change_protection(struct vm_
 
 int
 mprotect_fixup(struct vm_area_struct *vma, struct vm_area_struct **pprev,
-	unsigned long start, unsigned long end, unsigned long newflags)
+	unsigned long start, unsigned long end, unsigned long long newflags)
 {
 	struct mm_struct *mm = vma->vm_mm;
-	unsigned long oldflags = vma->vm_flags;
+	unsigned long long oldflags = vma->vm_flags;
 	long nrpages = (end - start) >> PAGE_SHIFT;
 	unsigned long charged = 0;
 	pgoff_t pgoff;
@@ -232,7 +232,8 @@ fail:
 SYSCALL_DEFINE3(mprotect, unsigned long, start, size_t, len,
 		unsigned long, prot)
 {
-	unsigned long vm_flags, nstart, end, tmp, reqprot;
+	unsigned long long vm_flags;
+	unsigned long nstart, end, tmp, reqprot;
 	struct vm_area_struct *vma, *prev;
 	int error = -EINVAL;
 	const int grows = prot & (PROT_GROWSDOWN|PROT_GROWSUP);
@@ -288,7 +289,7 @@ SYSCALL_DEFINE3(mprotect, unsigned long,
 		prev = vma;
 
 	for (nstart = start ; ; ) {
-		unsigned long newflags;
+		unsigned long long newflags;
 
 		/* Here we know that  vma->vm_start <= nstart < vma->vm_end. */
 
diff -puN mm/mremap.c~mm-convert-vma-vm_flags-to-64-bit mm/mremap.c
--- a/mm/mremap.c~mm-convert-vma-vm_flags-to-64-bit
+++ a/mm/mremap.c
@@ -169,7 +169,7 @@ static unsigned long move_vma(struct vm_
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct vm_area_struct *new_vma;
-	unsigned long vm_flags = vma->vm_flags;
+	unsigned long long vm_flags = vma->vm_flags;
 	unsigned long new_pgoff;
 	unsigned long moved_len;
 	unsigned long excess = 0;
diff -puN mm/nommu.c~mm-convert-vma-vm_flags-to-64-bit mm/nommu.c
--- a/mm/nommu.c~mm-convert-vma-vm_flags-to-64-bit
+++ a/mm/nommu.c
@@ -131,7 +131,7 @@ int __get_user_pages(struct task_struct 
 		     int *retry)
 {
 	struct vm_area_struct *vma;
-	unsigned long vm_flags;
+	unsigned long long vm_flags;
 	int i;
 
 	/* calculate required read or write permissions.
@@ -1059,12 +1059,12 @@ static int validate_mmap_request(struct 
  * we've determined that we can make the mapping, now translate what we
  * now know into VMA flags
  */
-static unsigned long determine_vm_flags(struct file *file,
-					unsigned long prot,
-					unsigned long flags,
-					unsigned long capabilities)
+static unsigned long long determine_vm_flags(struct file *file,
+					     unsigned long prot,
+					     unsigned long flags,
+					     unsigned long capabilities)
 {
-	unsigned long vm_flags;
+	unsigned long long vm_flags;
 
 	vm_flags = calc_vm_prot_bits(prot) | calc_vm_flag_bits(flags);
 	/* vm_flags |= mm->def_flags; */
@@ -1243,7 +1243,8 @@ unsigned long do_mmap_pgoff(struct file 
 	struct vm_area_struct *vma;
 	struct vm_region *region;
 	struct rb_node *rb;
-	unsigned long capabilities, vm_flags, result;
+	unsigned long capabilities, result;
+	unsigned long long vm_flags;
 	int ret;
 
 	kenter(",%lx,%lx,%lx,%lx,%lx", addr, len, prot, flags, pgoff);
diff -puN mm/rmap.c~mm-convert-vma-vm_flags-to-64-bit mm/rmap.c
--- a/mm/rmap.c~mm-convert-vma-vm_flags-to-64-bit
+++ a/mm/rmap.c
@@ -497,7 +497,7 @@ int page_mapped_in_vma(struct page *page
  */
 int page_referenced_one(struct page *page, struct vm_area_struct *vma,
 			unsigned long address, unsigned int *mapcount,
-			unsigned long *vm_flags)
+			unsigned long long *vm_flags)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	int referenced = 0;
@@ -577,7 +577,7 @@ out:
 
 static int page_referenced_anon(struct page *page,
 				struct mem_cgroup *mem_cont,
-				unsigned long *vm_flags)
+				unsigned long long *vm_flags)
 {
 	unsigned int mapcount;
 	struct anon_vma *anon_vma;
@@ -626,7 +626,7 @@ static int page_referenced_anon(struct p
  */
 static int page_referenced_file(struct page *page,
 				struct mem_cgroup *mem_cont,
-				unsigned long *vm_flags)
+				unsigned long long *vm_flags)
 {
 	unsigned int mapcount;
 	struct address_space *mapping = page->mapping;
@@ -692,7 +692,7 @@ static int page_referenced_file(struct p
 int page_referenced(struct page *page,
 		    int is_locked,
 		    struct mem_cgroup *mem_cont,
-		    unsigned long *vm_flags)
+		    unsigned long long *vm_flags)
 {
 	int referenced = 0;
 	int we_locked = 0;
diff -puN mm/shmem.c~mm-convert-vma-vm_flags-to-64-bit mm/shmem.c
--- a/mm/shmem.c~mm-convert-vma-vm_flags-to-64-bit
+++ a/mm/shmem.c
@@ -183,15 +183,15 @@ static inline struct shmem_sb_info *SHME
  * (unless MAP_NORESERVE and sysctl_overcommit_memory <= 1),
  * consistent with the pre-accounting of private mappings ...
  */
-static inline int shmem_acct_size(unsigned long flags, loff_t size)
+static inline int shmem_acct_size(unsigned long long vm_flags, loff_t size)
 {
-	return (flags & VM_NORESERVE) ?
+	return (vm_flags & VM_NORESERVE) ?
 		0 : security_vm_enough_memory_kern(VM_ACCT(size));
 }
 
-static inline void shmem_unacct_size(unsigned long flags, loff_t size)
+static inline void shmem_unacct_size(unsigned long long vm_flags, loff_t size)
 {
-	if (!(flags & VM_NORESERVE))
+	if (!(vm_flags & VM_NORESERVE))
 		vm_unacct_memory(VM_ACCT(size));
 }
 
@@ -1575,7 +1575,7 @@ static int shmem_mmap(struct file *file,
 }
 
 static struct inode *shmem_get_inode(struct super_block *sb, const struct inode *dir,
-				     int mode, dev_t dev, unsigned long flags)
+				     int mode, dev_t dev, unsigned long long vm_flags)
 {
 	struct inode *inode;
 	struct shmem_inode_info *info;
@@ -1595,7 +1595,7 @@ static struct inode *shmem_get_inode(str
 		info = SHMEM_I(inode);
 		memset(info, 0, (char *)inode - (char *)info);
 		spin_lock_init(&info->lock);
-		info->flags = flags & VM_NORESERVE;
+		info->flags = vm_flags & VM_NORESERVE;
 		INIT_LIST_HEAD(&info->swaplist);
 		cache_no_acl(inode);
 
@@ -2704,7 +2704,7 @@ out:
 
 #define shmem_vm_ops				generic_file_vm_ops
 #define shmem_file_operations			ramfs_file_operations
-#define shmem_get_inode(sb, dir, mode, dev, flags)	ramfs_get_inode(sb, dir, mode, dev)
+#define shmem_get_inode(sb, dir, mode, dev, vm_flags)	ramfs_get_inode(sb, dir, mode, dev)
 #define shmem_acct_size(flags, size)		0
 #define shmem_unacct_size(flags, size)		do {} while (0)
 #define SHMEM_MAX_BYTES				MAX_LFS_FILESIZE
@@ -2719,7 +2719,7 @@ out:
  * @size: size to be set for the file
  * @flags: VM_NORESERVE suppresses pre-accounting of the entire object size
  */
-struct file *shmem_file_setup(const char *name, loff_t size, unsigned long flags)
+struct file *shmem_file_setup(const char *name, loff_t size, unsigned long long vm_flags)
 {
 	int error;
 	struct file *file;
@@ -2734,7 +2734,7 @@ struct file *shmem_file_setup(const char
 	if (size < 0 || size > SHMEM_MAX_BYTES)
 		return ERR_PTR(-EINVAL);
 
-	if (shmem_acct_size(flags, size))
+	if (shmem_acct_size(vm_flags, size))
 		return ERR_PTR(-ENOMEM);
 
 	error = -ENOMEM;
@@ -2748,7 +2748,7 @@ struct file *shmem_file_setup(const char
 	path.mnt = mntget(shm_mnt);
 
 	error = -ENOSPC;
-	inode = shmem_get_inode(root->d_sb, NULL, S_IFREG | S_IRWXUGO, 0, flags);
+	inode = shmem_get_inode(root->d_sb, NULL, S_IFREG | S_IRWXUGO, 0, vm_flags);
 	if (!inode)
 		goto put_dentry;
 
@@ -2772,7 +2772,7 @@ struct file *shmem_file_setup(const char
 put_dentry:
 	path_put(&path);
 put_memory:
-	shmem_unacct_size(flags, size);
+	shmem_unacct_size(vm_flags, size);
 	return ERR_PTR(error);
 }
 EXPORT_SYMBOL_GPL(shmem_file_setup);
diff -puN mm/vmscan.c~mm-convert-vma-vm_flags-to-64-bit mm/vmscan.c
--- a/mm/vmscan.c~mm-convert-vma-vm_flags-to-64-bit
+++ a/mm/vmscan.c
@@ -633,7 +633,7 @@ static enum page_references page_check_r
 						  struct scan_control *sc)
 {
 	int referenced_ptes, referenced_page;
-	unsigned long vm_flags;
+	unsigned long long vm_flags;
 
 	referenced_ptes = page_referenced(page, 1, sc->mem_cgroup, &vm_flags);
 	referenced_page = TestClearPageReferenced(page);
@@ -1505,7 +1505,7 @@ static void shrink_active_list(unsigned 
 {
 	unsigned long nr_taken;
 	unsigned long pgscanned;
-	unsigned long vm_flags;
+	unsigned long long vm_flags;
 	LIST_HEAD(l_hold);	/* The pages which were snipped off */
 	LIST_HEAD(l_active);
 	LIST_HEAD(l_inactive);
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

memcg-fix-mem_cgroup_rotate_reclaimable_page.patch
mm-check-that-we-have-the-right-vma-in-__access_remote_vm.patch
vmscan-all_unreclaimable-use-zone-all_unreclaimable-as-a-name.patch
oom-kill-remove-boost_dying_task_prio.patch
mm-per-node-vmstat-show-proper-vmstats.patch
mm-per-node-vmstat-show-proper-vmstats-fix.patch
mm-increase-reclaim_distance-to-30.patch
mm-introduce-wait_on_page_locked_killable.patch
x86mm-make-pagefault-killable.patch
mm-mem-hotplug-fix-section-mismatch-setup_per_zone_inactive_ratio-should-be-__meminit.patch
mm-mem-hotplug-recalculate-lowmem_reserve-when-memory-hotplug-occur.patch
mm-mem-hotplug-update-pcp-stat_threshold-when-memory-hotplug-occur.patch
mm-convert-vma-vm_flags-to-64-bit.patch
mm-batch-activate_page-to-reduce-lock-contention.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
memcg-count-the-soft_limit-reclaim-in-global-background-reclaim.patch
memcg-add-stats-to-monitor-soft_limit-reclaim.patch
add-the-pagefault-count-into-memcg-stats.patch
add-the-pagefault-count-into-memcg-stats-fix.patch
kexec-remove-kmsg_dump_kexec.patch
kexec-remove-kmsg_dump_kexec-fix.patch

