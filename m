From: akpm@linux-foundation.org
Subject: - hugetlb-modular-state-for-hugetlb-page-size.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:22:57 -0700
Message-ID: <200807242322.m6ONMv96010609@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37454 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753997AbYGXXXS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:23:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, agl@us.ibm.com, ak@suse.de, nacc@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     hugetlb: modular state for hugetlb page size
has been removed from the -mm tree.  Its filename was
     hugetlb-modular-state-for-hugetlb-page-size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb: modular state for hugetlb page size
From: Nick Piggin <npiggin@suse.de>

The goal of this patchset is to support multiple hugetlb page sizes.  This
is achieved by introducing a new struct hstate structure, which
encapsulates the important hugetlb state and constants (eg.  huge page
size, number of huge pages currently allocated, etc).

The hstate structure is then passed around the code which requires these
fields, they will do the right thing regardless of the exact hstate they
are operating on.

This patch adds the hstate structure, with a single global instance of it
(default_hstate), and does the basic work of converting hugetlb to use the
hstate.

Future patches will add more hstate structures to allow for different
hugetlbfs mounts to have different page sizes.

[akpm@linux-foundation.org: coding-style fixes]
Acked-by: Adam Litke <agl@us.ibm.com>
Acked-by: Nishanth Aravamudan <nacc@us.ibm.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/mm/hugetlbpage.c    |    7 
 arch/powerpc/mm/hugetlbpage.c |    3 
 arch/s390/mm/hugetlbpage.c    |    3 
 arch/sh/mm/hugetlbpage.c      |    3 
 arch/sparc64/mm/hugetlbpage.c |    5 
 arch/x86/mm/hugetlbpage.c     |    5 
 fs/hugetlbfs/inode.c          |   52 ++--
 include/asm-ia64/hugetlb.h    |    3 
 include/asm-powerpc/hugetlb.h |    3 
 include/asm-s390/hugetlb.h    |    3 
 include/asm-sh/hugetlb.h      |    3 
 include/asm-sparc/hugetlb.h   |    3 
 include/asm-x86/hugetlb.h     |    8 
 include/linux/hugetlb.h       |   88 +++++++
 ipc/shm.c                     |    3 
 mm/hugetlb.c                  |  368 +++++++++++++++++---------------
 mm/memory.c                   |    2 
 mm/mempolicy.c                |    9 
 mm/mmap.c                     |    3 
 19 files changed, 356 insertions(+), 218 deletions(-)

diff -puN arch/ia64/mm/hugetlbpage.c~hugetlb-modular-state-for-hugetlb-page-size arch/ia64/mm/hugetlbpage.c
--- a/arch/ia64/mm/hugetlbpage.c~hugetlb-modular-state-for-hugetlb-page-size
+++ a/arch/ia64/mm/hugetlbpage.c
@@ -24,7 +24,7 @@
 unsigned int hpage_shift=HPAGE_SHIFT_DEFAULT;
 
 pte_t *
-huge_pte_alloc (struct mm_struct *mm, unsigned long addr)
+huge_pte_alloc(struct mm_struct *mm, unsigned long addr, unsigned long sz)
 {
 	unsigned long taddr = htlbpage_to_page(addr);
 	pgd_t *pgd;
@@ -75,7 +75,8 @@ int huge_pmd_unshare(struct mm_struct *m
  * Don't actually need to do any preparation, but need to make sure
  * the address is in the right region.
  */
-int prepare_hugepage_range(unsigned long addr, unsigned long len)
+int prepare_hugepage_range(struct file *file,
+			unsigned long addr, unsigned long len)
 {
 	if (len & ~HPAGE_MASK)
 		return -EINVAL;
@@ -149,7 +150,7 @@ unsigned long hugetlb_get_unmapped_area(
 
 	/* Handle MAP_FIXED */
 	if (flags & MAP_FIXED) {
-		if (prepare_hugepage_range(addr, len))
+		if (prepare_hugepage_range(file, addr, len))
 			return -EINVAL;
 		return addr;
 	}
diff -puN arch/powerpc/mm/hugetlbpage.c~hugetlb-modular-state-for-hugetlb-page-size arch/powerpc/mm/hugetlbpage.c
--- a/arch/powerpc/mm/hugetlbpage.c~hugetlb-modular-state-for-hugetlb-page-size
+++ a/arch/powerpc/mm/hugetlbpage.c
@@ -128,7 +128,8 @@ pte_t *huge_pte_offset(struct mm_struct 
 	return NULL;
 }
 
-pte_t *huge_pte_alloc(struct mm_struct *mm, unsigned long addr)
+pte_t *huge_pte_alloc(struct mm_struct *mm,
+			unsigned long addr, unsigned long sz)
 {
 	pgd_t *pg;
 	pud_t *pu;
diff -puN arch/s390/mm/hugetlbpage.c~hugetlb-modular-state-for-hugetlb-page-size arch/s390/mm/hugetlbpage.c
--- a/arch/s390/mm/hugetlbpage.c~hugetlb-modular-state-for-hugetlb-page-size
+++ a/arch/s390/mm/hugetlbpage.c
@@ -72,7 +72,8 @@ void arch_release_hugepage(struct page *
 	page[1].index = 0;
 }
 
-pte_t *huge_pte_alloc(struct mm_struct *mm, unsigned long addr)
+pte_t *huge_pte_alloc(struct mm_struct *mm,
+			unsigned long addr, unsigned long sz)
 {
 	pgd_t *pgdp;
 	pud_t *pudp;
diff -puN arch/sh/mm/hugetlbpage.c~hugetlb-modular-state-for-hugetlb-page-size arch/sh/mm/hugetlbpage.c
--- a/arch/sh/mm/hugetlbpage.c~hugetlb-modular-state-for-hugetlb-page-size
+++ a/arch/sh/mm/hugetlbpage.c
@@ -22,7 +22,8 @@
 #include <asm/tlbflush.h>
 #include <asm/cacheflush.h>
 
-pte_t *huge_pte_alloc(struct mm_struct *mm, unsigned long addr)
+pte_t *huge_pte_alloc(struct mm_struct *mm,
+			unsigned long addr, unsigned long sz)
 {
 	pgd_t *pgd;
 	pud_t *pud;
diff -puN arch/sparc64/mm/hugetlbpage.c~hugetlb-modular-state-for-hugetlb-page-size arch/sparc64/mm/hugetlbpage.c
--- a/arch/sparc64/mm/hugetlbpage.c~hugetlb-modular-state-for-hugetlb-page-size
+++ a/arch/sparc64/mm/hugetlbpage.c
@@ -175,7 +175,7 @@ hugetlb_get_unmapped_area(struct file *f
 		return -ENOMEM;
 
 	if (flags & MAP_FIXED) {
-		if (prepare_hugepage_range(addr, len))
+		if (prepare_hugepage_range(file, addr, len))
 			return -EINVAL;
 		return addr;
 	}
@@ -195,7 +195,8 @@ hugetlb_get_unmapped_area(struct file *f
 				pgoff, flags);
 }
 
-pte_t *huge_pte_alloc(struct mm_struct *mm, unsigned long addr)
+pte_t *huge_pte_alloc(struct mm_struct *mm,
+			unsigned long addr, unsigned long sz)
 {
 	pgd_t *pgd;
 	pud_t *pud;
diff -puN arch/x86/mm/hugetlbpage.c~hugetlb-modular-state-for-hugetlb-page-size arch/x86/mm/hugetlbpage.c
--- a/arch/x86/mm/hugetlbpage.c~hugetlb-modular-state-for-hugetlb-page-size
+++ a/arch/x86/mm/hugetlbpage.c
@@ -124,7 +124,8 @@ int huge_pmd_unshare(struct mm_struct *m
 	return 1;
 }
 
-pte_t *huge_pte_alloc(struct mm_struct *mm, unsigned long addr)
+pte_t *huge_pte_alloc(struct mm_struct *mm,
+			unsigned long addr, unsigned long sz)
 {
 	pgd_t *pgd;
 	pud_t *pud;
@@ -368,7 +369,7 @@ hugetlb_get_unmapped_area(struct file *f
 		return -ENOMEM;
 
 	if (flags & MAP_FIXED) {
-		if (prepare_hugepage_range(addr, len))
+		if (prepare_hugepage_range(file, addr, len))
 			return -EINVAL;
 		return addr;
 	}
diff -puN fs/hugetlbfs/inode.c~hugetlb-modular-state-for-hugetlb-page-size fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~hugetlb-modular-state-for-hugetlb-page-size
+++ a/fs/hugetlbfs/inode.c
@@ -80,6 +80,7 @@ static int hugetlbfs_file_mmap(struct fi
 	struct inode *inode = file->f_path.dentry->d_inode;
 	loff_t len, vma_len;
 	int ret;
+	struct hstate *h = hstate_file(file);
 
 	/*
 	 * vma address alignment (but not the pgoff alignment) has
@@ -92,7 +93,7 @@ static int hugetlbfs_file_mmap(struct fi
 	vma->vm_flags |= VM_HUGETLB | VM_RESERVED;
 	vma->vm_ops = &hugetlb_vm_ops;
 
-	if (vma->vm_pgoff & ~(HPAGE_MASK >> PAGE_SHIFT))
+	if (vma->vm_pgoff & ~(huge_page_mask(h) >> PAGE_SHIFT))
 		return -EINVAL;
 
 	vma_len = (loff_t)(vma->vm_end - vma->vm_start);
@@ -104,8 +105,8 @@ static int hugetlbfs_file_mmap(struct fi
 	len = vma_len + ((loff_t)vma->vm_pgoff << PAGE_SHIFT);
 
 	if (hugetlb_reserve_pages(inode,
-				vma->vm_pgoff >> (HPAGE_SHIFT-PAGE_SHIFT),
-				len >> HPAGE_SHIFT, vma))
+				vma->vm_pgoff >> huge_page_order(h),
+				len >> huge_page_shift(h), vma))
 		goto out;
 
 	ret = 0;
@@ -130,20 +131,21 @@ hugetlb_get_unmapped_area(struct file *f
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
 	unsigned long start_addr;
+	struct hstate *h = hstate_file(file);
 
-	if (len & ~HPAGE_MASK)
+	if (len & ~huge_page_mask(h))
 		return -EINVAL;
 	if (len > TASK_SIZE)
 		return -ENOMEM;
 
 	if (flags & MAP_FIXED) {
-		if (prepare_hugepage_range(addr, len))
+		if (prepare_hugepage_range(file, addr, len))
 			return -EINVAL;
 		return addr;
 	}
 
 	if (addr) {
-		addr = ALIGN(addr, HPAGE_SIZE);
+		addr = ALIGN(addr, huge_page_size(h));
 		vma = find_vma(mm, addr);
 		if (TASK_SIZE - len >= addr &&
 		    (!vma || addr + len <= vma->vm_start))
@@ -156,7 +158,7 @@ hugetlb_get_unmapped_area(struct file *f
 		start_addr = TASK_UNMAPPED_BASE;
 
 full_search:
-	addr = ALIGN(start_addr, HPAGE_SIZE);
+	addr = ALIGN(start_addr, huge_page_size(h));
 
 	for (vma = find_vma(mm, addr); ; vma = vma->vm_next) {
 		/* At this point:  (!vma || addr < vma->vm_end). */
@@ -174,7 +176,7 @@ full_search:
 
 		if (!vma || addr + len <= vma->vm_start)
 			return addr;
-		addr = ALIGN(vma->vm_end, HPAGE_SIZE);
+		addr = ALIGN(vma->vm_end, huge_page_size(h));
 	}
 }
 #endif
@@ -225,10 +227,11 @@ hugetlbfs_read_actor(struct page *page, 
 static ssize_t hugetlbfs_read(struct file *filp, char __user *buf,
 			      size_t len, loff_t *ppos)
 {
+	struct hstate *h = hstate_file(filp);
 	struct address_space *mapping = filp->f_mapping;
 	struct inode *inode = mapping->host;
-	unsigned long index = *ppos >> HPAGE_SHIFT;
-	unsigned long offset = *ppos & ~HPAGE_MASK;
+	unsigned long index = *ppos >> huge_page_shift(h);
+	unsigned long offset = *ppos & ~huge_page_mask(h);
 	unsigned long end_index;
 	loff_t isize;
 	ssize_t retval = 0;
@@ -243,17 +246,17 @@ static ssize_t hugetlbfs_read(struct fil
 	if (!isize)
 		goto out;
 
-	end_index = (isize - 1) >> HPAGE_SHIFT;
+	end_index = (isize - 1) >> huge_page_shift(h);
 	for (;;) {
 		struct page *page;
-		int nr, ret;
+		unsigned long nr, ret;
 
 		/* nr is the maximum number of bytes to copy from this page */
-		nr = HPAGE_SIZE;
+		nr = huge_page_size(h);
 		if (index >= end_index) {
 			if (index > end_index)
 				goto out;
-			nr = ((isize - 1) & ~HPAGE_MASK) + 1;
+			nr = ((isize - 1) & ~huge_page_mask(h)) + 1;
 			if (nr <= offset) {
 				goto out;
 			}
@@ -287,8 +290,8 @@ static ssize_t hugetlbfs_read(struct fil
 		offset += ret;
 		retval += ret;
 		len -= ret;
-		index += offset >> HPAGE_SHIFT;
-		offset &= ~HPAGE_MASK;
+		index += offset >> huge_page_shift(h);
+		offset &= ~huge_page_mask(h);
 
 		if (page)
 			page_cache_release(page);
@@ -298,7 +301,7 @@ static ssize_t hugetlbfs_read(struct fil
 			break;
 	}
 out:
-	*ppos = ((loff_t)index << HPAGE_SHIFT) + offset;
+	*ppos = ((loff_t)index << huge_page_shift(h)) + offset;
 	mutex_unlock(&inode->i_mutex);
 	return retval;
 }
@@ -339,8 +342,9 @@ static void truncate_huge_page(struct pa
 
 static void truncate_hugepages(struct inode *inode, loff_t lstart)
 {
+	struct hstate *h = hstate_inode(inode);
 	struct address_space *mapping = &inode->i_data;
-	const pgoff_t start = lstart >> HPAGE_SHIFT;
+	const pgoff_t start = lstart >> huge_page_shift(h);
 	struct pagevec pvec;
 	pgoff_t next;
 	int i, freed = 0;
@@ -449,8 +453,9 @@ static int hugetlb_vmtruncate(struct ino
 {
 	pgoff_t pgoff;
 	struct address_space *mapping = inode->i_mapping;
+	struct hstate *h = hstate_inode(inode);
 
-	BUG_ON(offset & ~HPAGE_MASK);
+	BUG_ON(offset & ~huge_page_mask(h));
 	pgoff = offset >> PAGE_SHIFT;
 
 	i_size_write(inode, offset);
@@ -465,6 +470,7 @@ static int hugetlb_vmtruncate(struct ino
 static int hugetlbfs_setattr(struct dentry *dentry, struct iattr *attr)
 {
 	struct inode *inode = dentry->d_inode;
+	struct hstate *h = hstate_inode(inode);
 	int error;
 	unsigned int ia_valid = attr->ia_valid;
 
@@ -476,7 +482,7 @@ static int hugetlbfs_setattr(struct dent
 
 	if (ia_valid & ATTR_SIZE) {
 		error = -EINVAL;
-		if (!(attr->ia_size & ~HPAGE_MASK))
+		if (!(attr->ia_size & ~huge_page_mask(h)))
 			error = hugetlb_vmtruncate(inode, attr->ia_size);
 		if (error)
 			goto out;
@@ -610,9 +616,10 @@ static int hugetlbfs_set_page_dirty(stru
 static int hugetlbfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
 	struct hugetlbfs_sb_info *sbinfo = HUGETLBFS_SB(dentry->d_sb);
+	struct hstate *h = hstate_inode(dentry->d_inode);
 
 	buf->f_type = HUGETLBFS_MAGIC;
-	buf->f_bsize = HPAGE_SIZE;
+	buf->f_bsize = huge_page_size(h);
 	if (sbinfo) {
 		spin_lock(&sbinfo->stat_lock);
 		/* If no limits set, just report 0 for max/free/used
@@ -942,7 +949,8 @@ struct file *hugetlb_file_setup(const ch
 		goto out_dentry;
 
 	error = -ENOMEM;
-	if (hugetlb_reserve_pages(inode, 0, size >> HPAGE_SHIFT, NULL))
+	if (hugetlb_reserve_pages(inode, 0,
+			size >> huge_page_shift(hstate_inode(inode)), NULL))
 		goto out_inode;
 
 	d_instantiate(dentry, inode);
diff -puN include/asm-ia64/hugetlb.h~hugetlb-modular-state-for-hugetlb-page-size include/asm-ia64/hugetlb.h
--- a/include/asm-ia64/hugetlb.h~hugetlb-modular-state-for-hugetlb-page-size
+++ a/include/asm-ia64/hugetlb.h
@@ -8,7 +8,8 @@ void hugetlb_free_pgd_range(struct mmu_g
 			    unsigned long end, unsigned long floor,
 			    unsigned long ceiling);
 
-int prepare_hugepage_range(unsigned long addr, unsigned long len);
+int prepare_hugepage_range(struct file *file,
+			unsigned long addr, unsigned long len);
 
 static inline int is_hugepage_only_range(struct mm_struct *mm,
 					 unsigned long addr,
diff -puN include/asm-powerpc/hugetlb.h~hugetlb-modular-state-for-hugetlb-page-size include/asm-powerpc/hugetlb.h
--- a/include/asm-powerpc/hugetlb.h~hugetlb-modular-state-for-hugetlb-page-size
+++ a/include/asm-powerpc/hugetlb.h
@@ -21,7 +21,8 @@ pte_t huge_ptep_get_and_clear(struct mm_
  * If the arch doesn't supply something else, assume that hugepage
  * size aligned regions are ok without further preparation.
  */
-static inline int prepare_hugepage_range(unsigned long addr, unsigned long len)
+static inline int prepare_hugepage_range(struct file *file,
+			unsigned long addr, unsigned long len)
 {
 	if (len & ~HPAGE_MASK)
 		return -EINVAL;
diff -puN include/asm-s390/hugetlb.h~hugetlb-modular-state-for-hugetlb-page-size include/asm-s390/hugetlb.h
--- a/include/asm-s390/hugetlb.h~hugetlb-modular-state-for-hugetlb-page-size
+++ a/include/asm-s390/hugetlb.h
@@ -22,7 +22,8 @@ void set_huge_pte_at(struct mm_struct *m
  * If the arch doesn't supply something else, assume that hugepage
  * size aligned regions are ok without further preparation.
  */
-static inline int prepare_hugepage_range(unsigned long addr, unsigned long len)
+static inline int prepare_hugepage_range(struct file *file,
+			unsigned long addr, unsigned long len)
 {
 	if (len & ~HPAGE_MASK)
 		return -EINVAL;
diff -puN include/asm-sh/hugetlb.h~hugetlb-modular-state-for-hugetlb-page-size include/asm-sh/hugetlb.h
--- a/include/asm-sh/hugetlb.h~hugetlb-modular-state-for-hugetlb-page-size
+++ a/include/asm-sh/hugetlb.h
@@ -14,7 +14,8 @@ static inline int is_hugepage_only_range
  * If the arch doesn't supply something else, assume that hugepage
  * size aligned regions are ok without further preparation.
  */
-static inline int prepare_hugepage_range(unsigned long addr, unsigned long len)
+static inline int prepare_hugepage_range(struct file *file,
+			unsigned long addr, unsigned long len)
 {
 	if (len & ~HPAGE_MASK)
 		return -EINVAL;
diff -puN include/asm-sparc/hugetlb.h~hugetlb-modular-state-for-hugetlb-page-size include/asm-sparc/hugetlb.h
--- a/include/asm-sparc/hugetlb.h~hugetlb-modular-state-for-hugetlb-page-size
+++ a/include/asm-sparc/hugetlb.h
@@ -22,7 +22,8 @@ static inline int is_hugepage_only_range
  * If the arch doesn't supply something else, assume that hugepage
  * size aligned regions are ok without further preparation.
  */
-static inline int prepare_hugepage_range(unsigned long addr, unsigned long len)
+static inline int prepare_hugepage_range(struct file *file,
+			unsigned long addr, unsigned long len)
 {
 	if (len & ~HPAGE_MASK)
 		return -EINVAL;
diff -puN include/asm-x86/hugetlb.h~hugetlb-modular-state-for-hugetlb-page-size include/asm-x86/hugetlb.h
--- a/include/asm-x86/hugetlb.h~hugetlb-modular-state-for-hugetlb-page-size
+++ a/include/asm-x86/hugetlb.h
@@ -14,11 +14,13 @@ static inline int is_hugepage_only_range
  * If the arch doesn't supply something else, assume that hugepage
  * size aligned regions are ok without further preparation.
  */
-static inline int prepare_hugepage_range(unsigned long addr, unsigned long len)
+static inline int prepare_hugepage_range(struct file *file,
+			unsigned long addr, unsigned long len)
 {
-	if (len & ~HPAGE_MASK)
+	struct hstate *h = hstate_file(file);
+	if (len & ~huge_page_mask(h))
 		return -EINVAL;
-	if (addr & ~HPAGE_MASK)
+	if (addr & ~huge_page_mask(h))
 		return -EINVAL;
 	return 0;
 }
diff -puN include/linux/hugetlb.h~hugetlb-modular-state-for-hugetlb-page-size include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~hugetlb-modular-state-for-hugetlb-page-size
+++ a/include/linux/hugetlb.h
@@ -8,7 +8,6 @@
 #include <linux/mempolicy.h>
 #include <linux/shm.h>
 #include <asm/tlbflush.h>
-#include <asm/hugetlb.h>
 
 struct ctl_table;
 
@@ -45,7 +44,8 @@ extern int sysctl_hugetlb_shm_group;
 
 /* arch callbacks */
 
-pte_t *huge_pte_alloc(struct mm_struct *mm, unsigned long addr);
+pte_t *huge_pte_alloc(struct mm_struct *mm,
+			unsigned long addr, unsigned long sz);
 pte_t *huge_pte_offset(struct mm_struct *mm, unsigned long addr);
 int huge_pmd_unshare(struct mm_struct *mm, unsigned long *addr, pte_t *ptep);
 struct page *follow_huge_addr(struct mm_struct *mm, unsigned long address,
@@ -80,7 +80,7 @@ static inline unsigned long hugetlb_tota
 #define hugetlb_report_meminfo(buf)		0
 #define hugetlb_report_node_meminfo(n, buf)	0
 #define follow_huge_pmd(mm, addr, pmd, write)	NULL
-#define prepare_hugepage_range(addr,len)	(-EINVAL)
+#define prepare_hugepage_range(file, addr, len)	(-EINVAL)
 #define pmd_huge(x)	0
 #define is_hugepage_only_range(mm, addr, len)	0
 #define hugetlb_free_pgd_range(tlb, addr, end, floor, ceiling) ({BUG(); 0; })
@@ -134,8 +134,6 @@ struct file *hugetlb_file_setup(const ch
 int hugetlb_get_quota(struct address_space *mapping, long delta);
 void hugetlb_put_quota(struct address_space *mapping, long delta);
 
-#define BLOCKS_PER_HUGEPAGE	(HPAGE_SIZE / 512)
-
 static inline int is_file_hugepages(struct file *file)
 {
 	if (file->f_op == &hugetlbfs_file_operations)
@@ -164,4 +162,84 @@ unsigned long hugetlb_get_unmapped_area(
 					unsigned long flags);
 #endif /* HAVE_ARCH_HUGETLB_UNMAPPED_AREA */
 
+#ifdef CONFIG_HUGETLB_PAGE
+
+/* Defines one hugetlb page size */
+struct hstate {
+	int hugetlb_next_nid;
+	unsigned int order;
+	unsigned long mask;
+	unsigned long max_huge_pages;
+	unsigned long nr_huge_pages;
+	unsigned long free_huge_pages;
+	unsigned long resv_huge_pages;
+	unsigned long surplus_huge_pages;
+	unsigned long nr_overcommit_huge_pages;
+	struct list_head hugepage_freelists[MAX_NUMNODES];
+	unsigned int nr_huge_pages_node[MAX_NUMNODES];
+	unsigned int free_huge_pages_node[MAX_NUMNODES];
+	unsigned int surplus_huge_pages_node[MAX_NUMNODES];
+};
+
+extern struct hstate default_hstate;
+
+static inline struct hstate *hstate_vma(struct vm_area_struct *vma)
+{
+	return &default_hstate;
+}
+
+static inline struct hstate *hstate_file(struct file *f)
+{
+	return &default_hstate;
+}
+
+static inline struct hstate *hstate_inode(struct inode *i)
+{
+	return &default_hstate;
+}
+
+static inline unsigned long huge_page_size(struct hstate *h)
+{
+	return (unsigned long)PAGE_SIZE << h->order;
+}
+
+static inline unsigned long huge_page_mask(struct hstate *h)
+{
+	return h->mask;
+}
+
+static inline unsigned int huge_page_order(struct hstate *h)
+{
+	return h->order;
+}
+
+static inline unsigned huge_page_shift(struct hstate *h)
+{
+	return h->order + PAGE_SHIFT;
+}
+
+static inline unsigned int pages_per_huge_page(struct hstate *h)
+{
+	return 1 << h->order;
+}
+
+static inline unsigned int blocks_per_huge_page(struct hstate *h)
+{
+	return huge_page_size(h) / 512;
+}
+
+#include <asm/hugetlb.h>
+
+#else
+struct hstate {};
+#define hstate_file(f) NULL
+#define hstate_vma(v) NULL
+#define hstate_inode(i) NULL
+#define huge_page_size(h) PAGE_SIZE
+#define huge_page_mask(h) PAGE_MASK
+#define huge_page_order(h) 0
+#define huge_page_shift(h) PAGE_SHIFT
+#define pages_per_huge_page(h) 1
+#endif
+
 #endif /* _LINUX_HUGETLB_H */
diff -puN ipc/shm.c~hugetlb-modular-state-for-hugetlb-page-size ipc/shm.c
--- a/ipc/shm.c~hugetlb-modular-state-for-hugetlb-page-size
+++ a/ipc/shm.c
@@ -577,7 +577,8 @@ static void shm_get_stat(struct ipc_name
 
 		if (is_file_hugepages(shp->shm_file)) {
 			struct address_space *mapping = inode->i_mapping;
-			*rss += (HPAGE_SIZE/PAGE_SIZE)*mapping->nrpages;
+			struct hstate *h = hstate_file(shp->shm_file);
+			*rss += pages_per_huge_page(h) * mapping->nrpages;
 		} else {
 			struct shmem_inode_info *info = SHMEM_I(inode);
 			spin_lock(&info->lock);
diff -puN mm/hugetlb.c~hugetlb-modular-state-for-hugetlb-page-size mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-modular-state-for-hugetlb-page-size
+++ a/mm/hugetlb.c
@@ -22,18 +22,12 @@
 #include "internal.h"
 
 const unsigned long hugetlb_zero = 0, hugetlb_infinity = ~0UL;
-static unsigned long nr_huge_pages, free_huge_pages, resv_huge_pages;
-static unsigned long surplus_huge_pages;
-static unsigned long nr_overcommit_huge_pages;
 unsigned long max_huge_pages;
 unsigned long sysctl_overcommit_huge_pages;
-static struct list_head hugepage_freelists[MAX_NUMNODES];
-static unsigned int nr_huge_pages_node[MAX_NUMNODES];
-static unsigned int free_huge_pages_node[MAX_NUMNODES];
-static unsigned int surplus_huge_pages_node[MAX_NUMNODES];
 static gfp_t htlb_alloc_mask = GFP_HIGHUSER;
 unsigned long hugepages_treat_as_movable;
-static int hugetlb_next_nid;
+
+struct hstate default_hstate;
 
 /*
  * Protects updates to hugepage_freelists, nr_huge_pages, and free_huge_pages
@@ -203,11 +197,11 @@ static long region_count(struct list_hea
  * Convert the address within this vma to the page offset within
  * the mapping, in pagecache page units; huge pages here.
  */
-static pgoff_t vma_hugecache_offset(struct vm_area_struct *vma,
-					unsigned long address)
+static pgoff_t vma_hugecache_offset(struct hstate *h,
+			struct vm_area_struct *vma, unsigned long address)
 {
-	return ((address - vma->vm_start) >> HPAGE_SHIFT) +
-			(vma->vm_pgoff >> (HPAGE_SHIFT - PAGE_SHIFT));
+	return ((address - vma->vm_start) >> huge_page_shift(h)) +
+			(vma->vm_pgoff >> huge_page_order(h));
 }
 
 /*
@@ -309,20 +303,21 @@ static int is_vma_resv_set(struct vm_are
 }
 
 /* Decrement the reserved pages in the hugepage pool by one */
-static void decrement_hugepage_resv_vma(struct vm_area_struct *vma)
+static void decrement_hugepage_resv_vma(struct hstate *h,
+			struct vm_area_struct *vma)
 {
 	if (vma->vm_flags & VM_NORESERVE)
 		return;
 
 	if (vma->vm_flags & VM_SHARED) {
 		/* Shared mappings always use reserves */
-		resv_huge_pages--;
+		h->resv_huge_pages--;
 	} else if (is_vma_resv_set(vma, HPAGE_RESV_OWNER)) {
 		/*
 		 * Only the process that called mmap() has reserves for
 		 * private mappings.
 		 */
-		resv_huge_pages--;
+		h->resv_huge_pages--;
 	}
 }
 
@@ -344,12 +339,13 @@ static int vma_has_private_reserves(stru
 	return 1;
 }
 
-static void clear_huge_page(struct page *page, unsigned long addr)
+static void clear_huge_page(struct page *page,
+			unsigned long addr, unsigned long sz)
 {
 	int i;
 
 	might_sleep();
-	for (i = 0; i < (HPAGE_SIZE/PAGE_SIZE); i++) {
+	for (i = 0; i < sz/PAGE_SIZE; i++) {
 		cond_resched();
 		clear_user_highpage(page + i, addr + i * PAGE_SIZE);
 	}
@@ -359,41 +355,43 @@ static void copy_huge_page(struct page *
 			   unsigned long addr, struct vm_area_struct *vma)
 {
 	int i;
+	struct hstate *h = hstate_vma(vma);
 
 	might_sleep();
-	for (i = 0; i < HPAGE_SIZE/PAGE_SIZE; i++) {
+	for (i = 0; i < pages_per_huge_page(h); i++) {
 		cond_resched();
 		copy_user_highpage(dst + i, src + i, addr + i*PAGE_SIZE, vma);
 	}
 }
 
-static void enqueue_huge_page(struct page *page)
+static void enqueue_huge_page(struct hstate *h, struct page *page)
 {
 	int nid = page_to_nid(page);
-	list_add(&page->lru, &hugepage_freelists[nid]);
-	free_huge_pages++;
-	free_huge_pages_node[nid]++;
+	list_add(&page->lru, &h->hugepage_freelists[nid]);
+	h->free_huge_pages++;
+	h->free_huge_pages_node[nid]++;
 }
 
-static struct page *dequeue_huge_page(void)
+static struct page *dequeue_huge_page(struct hstate *h)
 {
 	int nid;
 	struct page *page = NULL;
 
 	for (nid = 0; nid < MAX_NUMNODES; ++nid) {
-		if (!list_empty(&hugepage_freelists[nid])) {
-			page = list_entry(hugepage_freelists[nid].next,
+		if (!list_empty(&h->hugepage_freelists[nid])) {
+			page = list_entry(h->hugepage_freelists[nid].next,
 					  struct page, lru);
 			list_del(&page->lru);
-			free_huge_pages--;
-			free_huge_pages_node[nid]--;
+			h->free_huge_pages--;
+			h->free_huge_pages_node[nid]--;
 			break;
 		}
 	}
 	return page;
 }
 
-static struct page *dequeue_huge_page_vma(struct vm_area_struct *vma,
+static struct page *dequeue_huge_page_vma(struct hstate *h,
+				struct vm_area_struct *vma,
 				unsigned long address, int avoid_reserve)
 {
 	int nid;
@@ -411,26 +409,26 @@ static struct page *dequeue_huge_page_vm
 	 * not "stolen". The child may still get SIGKILLed
 	 */
 	if (!vma_has_private_reserves(vma) &&
-			free_huge_pages - resv_huge_pages == 0)
+			h->free_huge_pages - h->resv_huge_pages == 0)
 		return NULL;
 
 	/* If reserves cannot be used, ensure enough pages are in the pool */
-	if (avoid_reserve && free_huge_pages - resv_huge_pages == 0)
+	if (avoid_reserve && h->free_huge_pages - h->resv_huge_pages == 0)
 		return NULL;
 
 	for_each_zone_zonelist_nodemask(zone, z, zonelist,
 						MAX_NR_ZONES - 1, nodemask) {
 		nid = zone_to_nid(zone);
 		if (cpuset_zone_allowed_softwall(zone, htlb_alloc_mask) &&
-		    !list_empty(&hugepage_freelists[nid])) {
-			page = list_entry(hugepage_freelists[nid].next,
+		    !list_empty(&h->hugepage_freelists[nid])) {
+			page = list_entry(h->hugepage_freelists[nid].next,
 					  struct page, lru);
 			list_del(&page->lru);
-			free_huge_pages--;
-			free_huge_pages_node[nid]--;
+			h->free_huge_pages--;
+			h->free_huge_pages_node[nid]--;
 
 			if (!avoid_reserve)
-				decrement_hugepage_resv_vma(vma);
+				decrement_hugepage_resv_vma(h, vma);
 
 			break;
 		}
@@ -439,12 +437,13 @@ static struct page *dequeue_huge_page_vm
 	return page;
 }
 
-static void update_and_free_page(struct page *page)
+static void update_and_free_page(struct hstate *h, struct page *page)
 {
 	int i;
-	nr_huge_pages--;
-	nr_huge_pages_node[page_to_nid(page)]--;
-	for (i = 0; i < (HPAGE_SIZE / PAGE_SIZE); i++) {
+
+	h->nr_huge_pages--;
+	h->nr_huge_pages_node[page_to_nid(page)]--;
+	for (i = 0; i < pages_per_huge_page(h); i++) {
 		page[i].flags &= ~(1 << PG_locked | 1 << PG_error | 1 << PG_referenced |
 				1 << PG_dirty | 1 << PG_active | 1 << PG_reserved |
 				1 << PG_private | 1<< PG_writeback);
@@ -452,11 +451,16 @@ static void update_and_free_page(struct 
 	set_compound_page_dtor(page, NULL);
 	set_page_refcounted(page);
 	arch_release_hugepage(page);
-	__free_pages(page, HUGETLB_PAGE_ORDER);
+	__free_pages(page, huge_page_order(h));
 }
 
 static void free_huge_page(struct page *page)
 {
+	/*
+	 * Can't pass hstate in here because it is called from the
+	 * compound page destructor.
+	 */
+	struct hstate *h = &default_hstate;
 	int nid = page_to_nid(page);
 	struct address_space *mapping;
 
@@ -466,12 +470,12 @@ static void free_huge_page(struct page *
 	INIT_LIST_HEAD(&page->lru);
 
 	spin_lock(&hugetlb_lock);
-	if (surplus_huge_pages_node[nid]) {
-		update_and_free_page(page);
-		surplus_huge_pages--;
-		surplus_huge_pages_node[nid]--;
+	if (h->surplus_huge_pages_node[nid]) {
+		update_and_free_page(h, page);
+		h->surplus_huge_pages--;
+		h->surplus_huge_pages_node[nid]--;
 	} else {
-		enqueue_huge_page(page);
+		enqueue_huge_page(h, page);
 	}
 	spin_unlock(&hugetlb_lock);
 	if (mapping)
@@ -483,7 +487,7 @@ static void free_huge_page(struct page *
  * balanced by operating on them in a round-robin fashion.
  * Returns 1 if an adjustment was made.
  */
-static int adjust_pool_surplus(int delta)
+static int adjust_pool_surplus(struct hstate *h, int delta)
 {
 	static int prev_nid;
 	int nid = prev_nid;
@@ -496,15 +500,15 @@ static int adjust_pool_surplus(int delta
 			nid = first_node(node_online_map);
 
 		/* To shrink on this node, there must be a surplus page */
-		if (delta < 0 && !surplus_huge_pages_node[nid])
+		if (delta < 0 && !h->surplus_huge_pages_node[nid])
 			continue;
 		/* Surplus cannot exceed the total number of pages */
-		if (delta > 0 && surplus_huge_pages_node[nid] >=
-						nr_huge_pages_node[nid])
+		if (delta > 0 && h->surplus_huge_pages_node[nid] >=
+						h->nr_huge_pages_node[nid])
 			continue;
 
-		surplus_huge_pages += delta;
-		surplus_huge_pages_node[nid] += delta;
+		h->surplus_huge_pages += delta;
+		h->surplus_huge_pages_node[nid] += delta;
 		ret = 1;
 		break;
 	} while (nid != prev_nid);
@@ -513,46 +517,46 @@ static int adjust_pool_surplus(int delta
 	return ret;
 }
 
-static void prep_new_huge_page(struct page *page, int nid)
+static void prep_new_huge_page(struct hstate *h, struct page *page, int nid)
 {
 	set_compound_page_dtor(page, free_huge_page);
 	spin_lock(&hugetlb_lock);
-	nr_huge_pages++;
-	nr_huge_pages_node[nid]++;
+	h->nr_huge_pages++;
+	h->nr_huge_pages_node[nid]++;
 	spin_unlock(&hugetlb_lock);
 	put_page(page); /* free it into the hugepage allocator */
 }
 
-static struct page *alloc_fresh_huge_page_node(int nid)
+static struct page *alloc_fresh_huge_page_node(struct hstate *h, int nid)
 {
 	struct page *page;
 
 	page = alloc_pages_node(nid,
 		htlb_alloc_mask|__GFP_COMP|__GFP_THISNODE|
 						__GFP_REPEAT|__GFP_NOWARN,
-		HUGETLB_PAGE_ORDER);
+		huge_page_order(h));
 	if (page) {
 		if (arch_prepare_hugepage(page)) {
 			__free_pages(page, HUGETLB_PAGE_ORDER);
 			return NULL;
 		}
-		prep_new_huge_page(page, nid);
+		prep_new_huge_page(h, page, nid);
 	}
 
 	return page;
 }
 
-static int alloc_fresh_huge_page(void)
+static int alloc_fresh_huge_page(struct hstate *h)
 {
 	struct page *page;
 	int start_nid;
 	int next_nid;
 	int ret = 0;
 
-	start_nid = hugetlb_next_nid;
+	start_nid = h->hugetlb_next_nid;
 
 	do {
-		page = alloc_fresh_huge_page_node(hugetlb_next_nid);
+		page = alloc_fresh_huge_page_node(h, h->hugetlb_next_nid);
 		if (page)
 			ret = 1;
 		/*
@@ -566,11 +570,11 @@ static int alloc_fresh_huge_page(void)
 		 * if we just successfully allocated a hugepage so that
 		 * the next caller gets hugepages on the next node.
 		 */
-		next_nid = next_node(hugetlb_next_nid, node_online_map);
+		next_nid = next_node(h->hugetlb_next_nid, node_online_map);
 		if (next_nid == MAX_NUMNODES)
 			next_nid = first_node(node_online_map);
-		hugetlb_next_nid = next_nid;
-	} while (!page && hugetlb_next_nid != start_nid);
+		h->hugetlb_next_nid = next_nid;
+	} while (!page && h->hugetlb_next_nid != start_nid);
 
 	if (ret)
 		count_vm_event(HTLB_BUDDY_PGALLOC);
@@ -580,8 +584,8 @@ static int alloc_fresh_huge_page(void)
 	return ret;
 }
 
-static struct page *alloc_buddy_huge_page(struct vm_area_struct *vma,
-						unsigned long address)
+static struct page *alloc_buddy_huge_page(struct hstate *h,
+			struct vm_area_struct *vma, unsigned long address)
 {
 	struct page *page;
 	unsigned int nid;
@@ -610,18 +614,18 @@ static struct page *alloc_buddy_huge_pag
 	 * per-node value is checked there.
 	 */
 	spin_lock(&hugetlb_lock);
-	if (surplus_huge_pages >= nr_overcommit_huge_pages) {
+	if (h->surplus_huge_pages >= h->nr_overcommit_huge_pages) {
 		spin_unlock(&hugetlb_lock);
 		return NULL;
 	} else {
-		nr_huge_pages++;
-		surplus_huge_pages++;
+		h->nr_huge_pages++;
+		h->surplus_huge_pages++;
 	}
 	spin_unlock(&hugetlb_lock);
 
 	page = alloc_pages(htlb_alloc_mask|__GFP_COMP|
 					__GFP_REPEAT|__GFP_NOWARN,
-					HUGETLB_PAGE_ORDER);
+					huge_page_order(h));
 
 	spin_lock(&hugetlb_lock);
 	if (page) {
@@ -636,12 +640,12 @@ static struct page *alloc_buddy_huge_pag
 		/*
 		 * We incremented the global counters already
 		 */
-		nr_huge_pages_node[nid]++;
-		surplus_huge_pages_node[nid]++;
+		h->nr_huge_pages_node[nid]++;
+		h->surplus_huge_pages_node[nid]++;
 		__count_vm_event(HTLB_BUDDY_PGALLOC);
 	} else {
-		nr_huge_pages--;
-		surplus_huge_pages--;
+		h->nr_huge_pages--;
+		h->surplus_huge_pages--;
 		__count_vm_event(HTLB_BUDDY_PGALLOC_FAIL);
 	}
 	spin_unlock(&hugetlb_lock);
@@ -653,16 +657,16 @@ static struct page *alloc_buddy_huge_pag
  * Increase the hugetlb pool such that it can accomodate a reservation
  * of size 'delta'.
  */
-static int gather_surplus_pages(int delta)
+static int gather_surplus_pages(struct hstate *h, int delta)
 {
 	struct list_head surplus_list;
 	struct page *page, *tmp;
 	int ret, i;
 	int needed, allocated;
 
-	needed = (resv_huge_pages + delta) - free_huge_pages;
+	needed = (h->resv_huge_pages + delta) - h->free_huge_pages;
 	if (needed <= 0) {
-		resv_huge_pages += delta;
+		h->resv_huge_pages += delta;
 		return 0;
 	}
 
@@ -673,7 +677,7 @@ static int gather_surplus_pages(int delt
 retry:
 	spin_unlock(&hugetlb_lock);
 	for (i = 0; i < needed; i++) {
-		page = alloc_buddy_huge_page(NULL, 0);
+		page = alloc_buddy_huge_page(h, NULL, 0);
 		if (!page) {
 			/*
 			 * We were not able to allocate enough pages to
@@ -694,7 +698,8 @@ retry:
 	 * because either resv_huge_pages or free_huge_pages may have changed.
 	 */
 	spin_lock(&hugetlb_lock);
-	needed = (resv_huge_pages + delta) - (free_huge_pages + allocated);
+	needed = (h->resv_huge_pages + delta) -
+			(h->free_huge_pages + allocated);
 	if (needed > 0)
 		goto retry;
 
@@ -707,7 +712,7 @@ retry:
 	 * before they are reserved.
 	 */
 	needed += allocated;
-	resv_huge_pages += delta;
+	h->resv_huge_pages += delta;
 	ret = 0;
 free:
 	/* Free the needed pages to the hugetlb pool */
@@ -715,7 +720,7 @@ free:
 		if ((--needed) < 0)
 			break;
 		list_del(&page->lru);
-		enqueue_huge_page(page);
+		enqueue_huge_page(h, page);
 	}
 
 	/* Free unnecessary surplus pages to the buddy allocator */
@@ -743,7 +748,8 @@ free:
  * allocated to satisfy the reservation must be explicitly freed if they were
  * never used.
  */
-static void return_unused_surplus_pages(unsigned long unused_resv_pages)
+static void return_unused_surplus_pages(struct hstate *h,
+					unsigned long unused_resv_pages)
 {
 	static int nid = -1;
 	struct page *page;
@@ -758,27 +764,27 @@ static void return_unused_surplus_pages(
 	unsigned long remaining_iterations = num_online_nodes();
 
 	/* Uncommit the reservation */
-	resv_huge_pages -= unused_resv_pages;
+	h->resv_huge_pages -= unused_resv_pages;
 
-	nr_pages = min(unused_resv_pages, surplus_huge_pages);
+	nr_pages = min(unused_resv_pages, h->surplus_huge_pages);
 
 	while (remaining_iterations-- && nr_pages) {
 		nid = next_node(nid, node_online_map);
 		if (nid == MAX_NUMNODES)
 			nid = first_node(node_online_map);
 
-		if (!surplus_huge_pages_node[nid])
+		if (!h->surplus_huge_pages_node[nid])
 			continue;
 
-		if (!list_empty(&hugepage_freelists[nid])) {
-			page = list_entry(hugepage_freelists[nid].next,
+		if (!list_empty(&h->hugepage_freelists[nid])) {
+			page = list_entry(h->hugepage_freelists[nid].next,
 					  struct page, lru);
 			list_del(&page->lru);
-			update_and_free_page(page);
-			free_huge_pages--;
-			free_huge_pages_node[nid]--;
-			surplus_huge_pages--;
-			surplus_huge_pages_node[nid]--;
+			update_and_free_page(h, page);
+			h->free_huge_pages--;
+			h->free_huge_pages_node[nid]--;
+			h->surplus_huge_pages--;
+			h->surplus_huge_pages_node[nid]--;
 			nr_pages--;
 			remaining_iterations = num_online_nodes();
 		}
@@ -794,13 +800,14 @@ static void return_unused_surplus_pages(
  * an instantiated the change should be committed via vma_commit_reservation.
  * No action is required on failure.
  */
-static int vma_needs_reservation(struct vm_area_struct *vma, unsigned long addr)
+static int vma_needs_reservation(struct hstate *h,
+			struct vm_area_struct *vma, unsigned long addr)
 {
 	struct address_space *mapping = vma->vm_file->f_mapping;
 	struct inode *inode = mapping->host;
 
 	if (vma->vm_flags & VM_SHARED) {
-		pgoff_t idx = vma_hugecache_offset(vma, addr);
+		pgoff_t idx = vma_hugecache_offset(h, vma, addr);
 		return region_chg(&inode->i_mapping->private_list,
 							idx, idx + 1);
 
@@ -809,7 +816,7 @@ static int vma_needs_reservation(struct 
 
 	} else  {
 		int err;
-		pgoff_t idx = vma_hugecache_offset(vma, addr);
+		pgoff_t idx = vma_hugecache_offset(h, vma, addr);
 		struct resv_map *reservations = vma_resv_map(vma);
 
 		err = region_chg(&reservations->regions, idx, idx + 1);
@@ -818,18 +825,18 @@ static int vma_needs_reservation(struct 
 		return 0;
 	}
 }
-static void vma_commit_reservation(struct vm_area_struct *vma,
-							unsigned long addr)
+static void vma_commit_reservation(struct hstate *h,
+			struct vm_area_struct *vma, unsigned long addr)
 {
 	struct address_space *mapping = vma->vm_file->f_mapping;
 	struct inode *inode = mapping->host;
 
 	if (vma->vm_flags & VM_SHARED) {
-		pgoff_t idx = vma_hugecache_offset(vma, addr);
+		pgoff_t idx = vma_hugecache_offset(h, vma, addr);
 		region_add(&inode->i_mapping->private_list, idx, idx + 1);
 
 	} else if (is_vma_resv_set(vma, HPAGE_RESV_OWNER)) {
-		pgoff_t idx = vma_hugecache_offset(vma, addr);
+		pgoff_t idx = vma_hugecache_offset(h, vma, addr);
 		struct resv_map *reservations = vma_resv_map(vma);
 
 		/* Mark this page used in the map. */
@@ -840,6 +847,7 @@ static void vma_commit_reservation(struc
 static struct page *alloc_huge_page(struct vm_area_struct *vma,
 				    unsigned long addr, int avoid_reserve)
 {
+	struct hstate *h = hstate_vma(vma);
 	struct page *page;
 	struct address_space *mapping = vma->vm_file->f_mapping;
 	struct inode *inode = mapping->host;
@@ -852,7 +860,7 @@ static struct page *alloc_huge_page(stru
 	 * MAP_NORESERVE mappings may also need pages and quota allocated
 	 * if no reserve mapping overlaps.
 	 */
-	chg = vma_needs_reservation(vma, addr);
+	chg = vma_needs_reservation(h, vma, addr);
 	if (chg < 0)
 		return ERR_PTR(chg);
 	if (chg)
@@ -860,11 +868,11 @@ static struct page *alloc_huge_page(stru
 			return ERR_PTR(-ENOSPC);
 
 	spin_lock(&hugetlb_lock);
-	page = dequeue_huge_page_vma(vma, addr, avoid_reserve);
+	page = dequeue_huge_page_vma(h, vma, addr, avoid_reserve);
 	spin_unlock(&hugetlb_lock);
 
 	if (!page) {
-		page = alloc_buddy_huge_page(vma, addr);
+		page = alloc_buddy_huge_page(h, vma, addr);
 		if (!page) {
 			hugetlb_put_quota(inode->i_mapping, chg);
 			return ERR_PTR(-VM_FAULT_OOM);
@@ -874,7 +882,7 @@ static struct page *alloc_huge_page(stru
 	set_page_refcounted(page);
 	set_page_private(page, (unsigned long) mapping);
 
-	vma_commit_reservation(vma, addr);
+	vma_commit_reservation(h, vma, addr);
 
 	return page;
 }
@@ -882,21 +890,28 @@ static struct page *alloc_huge_page(stru
 static int __init hugetlb_init(void)
 {
 	unsigned long i;
+	struct hstate *h = &default_hstate;
 
 	if (HPAGE_SHIFT == 0)
 		return 0;
 
+	if (!h->order) {
+		h->order = HPAGE_SHIFT - PAGE_SHIFT;
+		h->mask = HPAGE_MASK;
+	}
+
 	for (i = 0; i < MAX_NUMNODES; ++i)
-		INIT_LIST_HEAD(&hugepage_freelists[i]);
+		INIT_LIST_HEAD(&h->hugepage_freelists[i]);
 
-	hugetlb_next_nid = first_node(node_online_map);
+	h->hugetlb_next_nid = first_node(node_online_map);
 
 	for (i = 0; i < max_huge_pages; ++i) {
-		if (!alloc_fresh_huge_page())
+		if (!alloc_fresh_huge_page(h))
 			break;
 	}
-	max_huge_pages = free_huge_pages = nr_huge_pages = i;
-	printk("Total HugeTLB memory allocated, %ld\n", free_huge_pages);
+	max_huge_pages = h->free_huge_pages = h->nr_huge_pages = i;
+	printk(KERN_INFO "Total HugeTLB memory allocated, %ld\n",
+			h->free_huge_pages);
 	return 0;
 }
 module_init(hugetlb_init);
@@ -922,34 +937,36 @@ static unsigned int cpuset_mems_nr(unsig
 
 #ifdef CONFIG_SYSCTL
 #ifdef CONFIG_HIGHMEM
-static void try_to_free_low(unsigned long count)
+static void try_to_free_low(struct hstate *h, unsigned long count)
 {
 	int i;
 
 	for (i = 0; i < MAX_NUMNODES; ++i) {
 		struct page *page, *next;
-		list_for_each_entry_safe(page, next, &hugepage_freelists[i], lru) {
-			if (count >= nr_huge_pages)
+		struct list_head *freel = &h->hugepage_freelists[i];
+		list_for_each_entry_safe(page, next, freel, lru) {
+			if (count >= h->nr_huge_pages)
 				return;
 			if (PageHighMem(page))
 				continue;
 			list_del(&page->lru);
 			update_and_free_page(page);
-			free_huge_pages--;
-			free_huge_pages_node[page_to_nid(page)]--;
+			h->free_huge_pages--;
+			h->free_huge_pages_node[page_to_nid(page)]--;
 		}
 	}
 }
 #else
-static inline void try_to_free_low(unsigned long count)
+static inline void try_to_free_low(struct hstate *h, unsigned long count)
 {
 }
 #endif
 
-#define persistent_huge_pages (nr_huge_pages - surplus_huge_pages)
+#define persistent_huge_pages(h) (h->nr_huge_pages - h->surplus_huge_pages)
 static unsigned long set_max_huge_pages(unsigned long count)
 {
 	unsigned long min_count, ret;
+	struct hstate *h = &default_hstate;
 
 	/*
 	 * Increase the pool size
@@ -963,19 +980,19 @@ static unsigned long set_max_huge_pages(
 	 * within all the constraints specified by the sysctls.
 	 */
 	spin_lock(&hugetlb_lock);
-	while (surplus_huge_pages && count > persistent_huge_pages) {
-		if (!adjust_pool_surplus(-1))
+	while (h->surplus_huge_pages && count > persistent_huge_pages(h)) {
+		if (!adjust_pool_surplus(h, -1))
 			break;
 	}
 
-	while (count > persistent_huge_pages) {
+	while (count > persistent_huge_pages(h)) {
 		/*
 		 * If this allocation races such that we no longer need the
 		 * page, free_huge_page will handle it by freeing the page
 		 * and reducing the surplus.
 		 */
 		spin_unlock(&hugetlb_lock);
-		ret = alloc_fresh_huge_page();
+		ret = alloc_fresh_huge_page(h);
 		spin_lock(&hugetlb_lock);
 		if (!ret)
 			goto out;
@@ -997,21 +1014,21 @@ static unsigned long set_max_huge_pages(
 	 * and won't grow the pool anywhere else. Not until one of the
 	 * sysctls are changed, or the surplus pages go out of use.
 	 */
-	min_count = resv_huge_pages + nr_huge_pages - free_huge_pages;
+	min_count = h->resv_huge_pages + h->nr_huge_pages - h->free_huge_pages;
 	min_count = max(count, min_count);
-	try_to_free_low(min_count);
-	while (min_count < persistent_huge_pages) {
-		struct page *page = dequeue_huge_page();
+	try_to_free_low(h, min_count);
+	while (min_count < persistent_huge_pages(h)) {
+		struct page *page = dequeue_huge_page(h);
 		if (!page)
 			break;
-		update_and_free_page(page);
+		update_and_free_page(h, page);
 	}
-	while (count < persistent_huge_pages) {
-		if (!adjust_pool_surplus(1))
+	while (count < persistent_huge_pages(h)) {
+		if (!adjust_pool_surplus(h, 1))
 			break;
 	}
 out:
-	ret = persistent_huge_pages;
+	ret = persistent_huge_pages(h);
 	spin_unlock(&hugetlb_lock);
 	return ret;
 }
@@ -1041,9 +1058,10 @@ int hugetlb_overcommit_handler(struct ct
 			struct file *file, void __user *buffer,
 			size_t *length, loff_t *ppos)
 {
+	struct hstate *h = &default_hstate;
 	proc_doulongvec_minmax(table, write, file, buffer, length, ppos);
 	spin_lock(&hugetlb_lock);
-	nr_overcommit_huge_pages = sysctl_overcommit_huge_pages;
+	h->nr_overcommit_huge_pages = sysctl_overcommit_huge_pages;
 	spin_unlock(&hugetlb_lock);
 	return 0;
 }
@@ -1052,37 +1070,40 @@ int hugetlb_overcommit_handler(struct ct
 
 int hugetlb_report_meminfo(char *buf)
 {
+	struct hstate *h = &default_hstate;
 	return sprintf(buf,
 			"HugePages_Total: %5lu\n"
 			"HugePages_Free:  %5lu\n"
 			"HugePages_Rsvd:  %5lu\n"
 			"HugePages_Surp:  %5lu\n"
 			"Hugepagesize:    %5lu kB\n",
-			nr_huge_pages,
-			free_huge_pages,
-			resv_huge_pages,
-			surplus_huge_pages,
-			HPAGE_SIZE/1024);
+			h->nr_huge_pages,
+			h->free_huge_pages,
+			h->resv_huge_pages,
+			h->surplus_huge_pages,
+			1UL << (huge_page_order(h) + PAGE_SHIFT - 10));
 }
 
 int hugetlb_report_node_meminfo(int nid, char *buf)
 {
+	struct hstate *h = &default_hstate;
 	return sprintf(buf,
 		"Node %d HugePages_Total: %5u\n"
 		"Node %d HugePages_Free:  %5u\n"
 		"Node %d HugePages_Surp:  %5u\n",
-		nid, nr_huge_pages_node[nid],
-		nid, free_huge_pages_node[nid],
-		nid, surplus_huge_pages_node[nid]);
+		nid, h->nr_huge_pages_node[nid],
+		nid, h->free_huge_pages_node[nid],
+		nid, h->surplus_huge_pages_node[nid]);
 }
 
 /* Return the number pages of memory we physically have, in PAGE_SIZE units. */
 unsigned long hugetlb_total_pages(void)
 {
-	return nr_huge_pages * (HPAGE_SIZE / PAGE_SIZE);
+	struct hstate *h = &default_hstate;
+	return h->nr_huge_pages * pages_per_huge_page(h);
 }
 
-static int hugetlb_acct_memory(long delta)
+static int hugetlb_acct_memory(struct hstate *h, long delta)
 {
 	int ret = -ENOMEM;
 
@@ -1105,18 +1126,18 @@ static int hugetlb_acct_memory(long delt
 	 * semantics that cpuset has.
 	 */
 	if (delta > 0) {
-		if (gather_surplus_pages(delta) < 0)
+		if (gather_surplus_pages(h, delta) < 0)
 			goto out;
 
-		if (delta > cpuset_mems_nr(free_huge_pages_node)) {
-			return_unused_surplus_pages(delta);
+		if (delta > cpuset_mems_nr(h->free_huge_pages_node)) {
+			return_unused_surplus_pages(h, delta);
 			goto out;
 		}
 	}
 
 	ret = 0;
 	if (delta < 0)
-		return_unused_surplus_pages((unsigned long) -delta);
+		return_unused_surplus_pages(h, (unsigned long) -delta);
 
 out:
 	spin_unlock(&hugetlb_lock);
@@ -1141,14 +1162,15 @@ static void hugetlb_vm_op_open(struct vm
 
 static void hugetlb_vm_op_close(struct vm_area_struct *vma)
 {
+	struct hstate *h = hstate_vma(vma);
 	struct resv_map *reservations = vma_resv_map(vma);
 	unsigned long reserve;
 	unsigned long start;
 	unsigned long end;
 
 	if (reservations) {
-		start = vma_hugecache_offset(vma, vma->vm_start);
-		end = vma_hugecache_offset(vma, vma->vm_end);
+		start = vma_hugecache_offset(h, vma, vma->vm_start);
+		end = vma_hugecache_offset(h, vma, vma->vm_end);
 
 		reserve = (end - start) -
 			region_count(&reservations->regions, start, end);
@@ -1156,7 +1178,7 @@ static void hugetlb_vm_op_close(struct v
 		kref_put(&reservations->refs, resv_map_release);
 
 		if (reserve)
-			hugetlb_acct_memory(-reserve);
+			hugetlb_acct_memory(h, -reserve);
 	}
 }
 
@@ -1214,14 +1236,16 @@ int copy_hugetlb_page_range(struct mm_st
 	struct page *ptepage;
 	unsigned long addr;
 	int cow;
+	struct hstate *h = hstate_vma(vma);
+	unsigned long sz = huge_page_size(h);
 
 	cow = (vma->vm_flags & (VM_SHARED | VM_MAYWRITE)) == VM_MAYWRITE;
 
-	for (addr = vma->vm_start; addr < vma->vm_end; addr += HPAGE_SIZE) {
+	for (addr = vma->vm_start; addr < vma->vm_end; addr += sz) {
 		src_pte = huge_pte_offset(src, addr);
 		if (!src_pte)
 			continue;
-		dst_pte = huge_pte_alloc(dst, addr);
+		dst_pte = huge_pte_alloc(dst, addr, sz);
 		if (!dst_pte)
 			goto nomem;
 
@@ -1257,6 +1281,9 @@ void __unmap_hugepage_range(struct vm_ar
 	pte_t pte;
 	struct page *page;
 	struct page *tmp;
+	struct hstate *h = hstate_vma(vma);
+	unsigned long sz = huge_page_size(h);
+
 	/*
 	 * A page gathering list, protected by per file i_mmap_lock. The
 	 * lock is used to avoid list corruption from multiple unmapping
@@ -1265,11 +1292,11 @@ void __unmap_hugepage_range(struct vm_ar
 	LIST_HEAD(page_list);
 
 	WARN_ON(!is_vm_hugetlb_page(vma));
-	BUG_ON(start & ~HPAGE_MASK);
-	BUG_ON(end & ~HPAGE_MASK);
+	BUG_ON(start & ~huge_page_mask(h));
+	BUG_ON(end & ~huge_page_mask(h));
 
 	spin_lock(&mm->page_table_lock);
-	for (address = start; address < end; address += HPAGE_SIZE) {
+	for (address = start; address < end; address += sz) {
 		ptep = huge_pte_offset(mm, address);
 		if (!ptep)
 			continue;
@@ -1383,6 +1410,7 @@ static int hugetlb_cow(struct mm_struct 
 			unsigned long address, pte_t *ptep, pte_t pte,
 			struct page *pagecache_page)
 {
+	struct hstate *h = hstate_vma(vma);
 	struct page *old_page, *new_page;
 	int avoidcopy;
 	int outside_reserve = 0;
@@ -1443,7 +1471,7 @@ retry_avoidcopy:
 	__SetPageUptodate(new_page);
 	spin_lock(&mm->page_table_lock);
 
-	ptep = huge_pte_offset(mm, address & HPAGE_MASK);
+	ptep = huge_pte_offset(mm, address & huge_page_mask(h));
 	if (likely(pte_same(huge_ptep_get(ptep), pte))) {
 		/* Break COW */
 		huge_ptep_clear_flush(vma, address, ptep);
@@ -1458,14 +1486,14 @@ retry_avoidcopy:
 }
 
 /* Return the pagecache page at a given address within a VMA */
-static struct page *hugetlbfs_pagecache_page(struct vm_area_struct *vma,
-			unsigned long address)
+static struct page *hugetlbfs_pagecache_page(struct hstate *h,
+			struct vm_area_struct *vma, unsigned long address)
 {
 	struct address_space *mapping;
 	pgoff_t idx;
 
 	mapping = vma->vm_file->f_mapping;
-	idx = vma_hugecache_offset(vma, address);
+	idx = vma_hugecache_offset(h, vma, address);
 
 	return find_lock_page(mapping, idx);
 }
@@ -1473,6 +1501,7 @@ static struct page *hugetlbfs_pagecache_
 static int hugetlb_no_page(struct mm_struct *mm, struct vm_area_struct *vma,
 			unsigned long address, pte_t *ptep, int write_access)
 {
+	struct hstate *h = hstate_vma(vma);
 	int ret = VM_FAULT_SIGBUS;
 	pgoff_t idx;
 	unsigned long size;
@@ -1493,7 +1522,7 @@ static int hugetlb_no_page(struct mm_str
 	}
 
 	mapping = vma->vm_file->f_mapping;
-	idx = vma_hugecache_offset(vma, address);
+	idx = vma_hugecache_offset(h, vma, address);
 
 	/*
 	 * Use page lock to guard against racing truncation
@@ -1502,7 +1531,7 @@ static int hugetlb_no_page(struct mm_str
 retry:
 	page = find_lock_page(mapping, idx);
 	if (!page) {
-		size = i_size_read(mapping->host) >> HPAGE_SHIFT;
+		size = i_size_read(mapping->host) >> huge_page_shift(h);
 		if (idx >= size)
 			goto out;
 		page = alloc_huge_page(vma, address, 0);
@@ -1510,7 +1539,7 @@ retry:
 			ret = -PTR_ERR(page);
 			goto out;
 		}
-		clear_huge_page(page, address);
+		clear_huge_page(page, address, huge_page_size(h));
 		__SetPageUptodate(page);
 
 		if (vma->vm_flags & VM_SHARED) {
@@ -1526,14 +1555,14 @@ retry:
 			}
 
 			spin_lock(&inode->i_lock);
-			inode->i_blocks += BLOCKS_PER_HUGEPAGE;
+			inode->i_blocks += blocks_per_huge_page(h);
 			spin_unlock(&inode->i_lock);
 		} else
 			lock_page(page);
 	}
 
 	spin_lock(&mm->page_table_lock);
-	size = i_size_read(mapping->host) >> HPAGE_SHIFT;
+	size = i_size_read(mapping->host) >> huge_page_shift(h);
 	if (idx >= size)
 		goto backout;
 
@@ -1569,8 +1598,9 @@ int hugetlb_fault(struct mm_struct *mm, 
 	pte_t entry;
 	int ret;
 	static DEFINE_MUTEX(hugetlb_instantiation_mutex);
+	struct hstate *h = hstate_vma(vma);
 
-	ptep = huge_pte_alloc(mm, address);
+	ptep = huge_pte_alloc(mm, address, huge_page_size(h));
 	if (!ptep)
 		return VM_FAULT_OOM;
 
@@ -1594,7 +1624,7 @@ int hugetlb_fault(struct mm_struct *mm, 
 	if (likely(pte_same(entry, huge_ptep_get(ptep))))
 		if (write_access && !pte_write(entry)) {
 			struct page *page;
-			page = hugetlbfs_pagecache_page(vma, address);
+			page = hugetlbfs_pagecache_page(h, vma, address);
 			ret = hugetlb_cow(mm, vma, address, ptep, entry, page);
 			if (page) {
 				unlock_page(page);
@@ -1615,6 +1645,7 @@ int follow_hugetlb_page(struct mm_struct
 	unsigned long pfn_offset;
 	unsigned long vaddr = *position;
 	int remainder = *length;
+	struct hstate *h = hstate_vma(vma);
 
 	spin_lock(&mm->page_table_lock);
 	while (vaddr < vma->vm_end && remainder) {
@@ -1626,7 +1657,7 @@ int follow_hugetlb_page(struct mm_struct
 		 * each hugepage.  We have to make * sure we get the
 		 * first, for the page indexing below to work.
 		 */
-		pte = huge_pte_offset(mm, vaddr & HPAGE_MASK);
+		pte = huge_pte_offset(mm, vaddr & huge_page_mask(h));
 
 		if (!pte || huge_pte_none(huge_ptep_get(pte)) ||
 		    (write && !pte_write(huge_ptep_get(pte)))) {
@@ -1644,7 +1675,7 @@ int follow_hugetlb_page(struct mm_struct
 			break;
 		}
 
-		pfn_offset = (vaddr & ~HPAGE_MASK) >> PAGE_SHIFT;
+		pfn_offset = (vaddr & ~huge_page_mask(h)) >> PAGE_SHIFT;
 		page = pte_page(huge_ptep_get(pte));
 same_page:
 		if (pages) {
@@ -1660,7 +1691,7 @@ same_page:
 		--remainder;
 		++i;
 		if (vaddr < vma->vm_end && remainder &&
-				pfn_offset < HPAGE_SIZE/PAGE_SIZE) {
+				pfn_offset < pages_per_huge_page(h)) {
 			/*
 			 * We use pfn_offset to avoid touching the pageframes
 			 * of this compound page.
@@ -1682,13 +1713,14 @@ void hugetlb_change_protection(struct vm
 	unsigned long start = address;
 	pte_t *ptep;
 	pte_t pte;
+	struct hstate *h = hstate_vma(vma);
 
 	BUG_ON(address >= end);
 	flush_cache_range(vma, address, end);
 
 	spin_lock(&vma->vm_file->f_mapping->i_mmap_lock);
 	spin_lock(&mm->page_table_lock);
-	for (; address < end; address += HPAGE_SIZE) {
+	for (; address < end; address += huge_page_size(h)) {
 		ptep = huge_pte_offset(mm, address);
 		if (!ptep)
 			continue;
@@ -1711,6 +1743,7 @@ int hugetlb_reserve_pages(struct inode *
 					struct vm_area_struct *vma)
 {
 	long ret, chg;
+	struct hstate *h = hstate_inode(inode);
 
 	if (vma && vma->vm_flags & VM_NORESERVE)
 		return 0;
@@ -1739,7 +1772,7 @@ int hugetlb_reserve_pages(struct inode *
 
 	if (hugetlb_get_quota(inode->i_mapping, chg))
 		return -ENOSPC;
-	ret = hugetlb_acct_memory(chg);
+	ret = hugetlb_acct_memory(h, chg);
 	if (ret < 0) {
 		hugetlb_put_quota(inode->i_mapping, chg);
 		return ret;
@@ -1751,12 +1784,13 @@ int hugetlb_reserve_pages(struct inode *
 
 void hugetlb_unreserve_pages(struct inode *inode, long offset, long freed)
 {
+	struct hstate *h = hstate_inode(inode);
 	long chg = region_truncate(&inode->i_mapping->private_list, offset);
 
 	spin_lock(&inode->i_lock);
-	inode->i_blocks -= BLOCKS_PER_HUGEPAGE * freed;
+	inode->i_blocks -= blocks_per_huge_page(h);
 	spin_unlock(&inode->i_lock);
 
 	hugetlb_put_quota(inode->i_mapping, (chg - freed));
-	hugetlb_acct_memory(-(chg - freed));
+	hugetlb_acct_memory(h, -(chg - freed));
 }
diff -puN mm/memory.c~hugetlb-modular-state-for-hugetlb-page-size mm/memory.c
--- a/mm/memory.c~hugetlb-modular-state-for-hugetlb-page-size
+++ a/mm/memory.c
@@ -903,7 +903,7 @@ unsigned long unmap_vmas(struct mmu_gath
 			if (unlikely(is_vm_hugetlb_page(vma))) {
 				unmap_hugepage_range(vma, start, end, NULL);
 				zap_work -= (end - start) /
-						(HPAGE_SIZE / PAGE_SIZE);
+					pages_per_huge_page(hstate_vma(vma));
 				start = end;
 			} else
 				start = unmap_page_range(*tlbp, vma,
diff -puN mm/mempolicy.c~hugetlb-modular-state-for-hugetlb-page-size mm/mempolicy.c
--- a/mm/mempolicy.c~hugetlb-modular-state-for-hugetlb-page-size
+++ a/mm/mempolicy.c
@@ -1481,7 +1481,7 @@ struct zonelist *huge_zonelist(struct vm
 
 	if (unlikely((*mpol)->mode == MPOL_INTERLEAVE)) {
 		zl = node_zonelist(interleave_nid(*mpol, vma, addr,
-						HPAGE_SHIFT), gfp_flags);
+				huge_page_shift(hstate_vma(vma))), gfp_flags);
 	} else {
 		zl = policy_zonelist(gfp_flags, *mpol);
 		if ((*mpol)->mode == MPOL_BIND)
@@ -2220,9 +2220,12 @@ static void check_huge_range(struct vm_a
 {
 	unsigned long addr;
 	struct page *page;
+	struct hstate *h = hstate_vma(vma);
+	unsigned long sz = huge_page_size(h);
 
-	for (addr = start; addr < end; addr += HPAGE_SIZE) {
-		pte_t *ptep = huge_pte_offset(vma->vm_mm, addr & HPAGE_MASK);
+	for (addr = start; addr < end; addr += sz) {
+		pte_t *ptep = huge_pte_offset(vma->vm_mm,
+						addr & huge_page_mask(h));
 		pte_t pte;
 
 		if (!ptep)
diff -puN mm/mmap.c~hugetlb-modular-state-for-hugetlb-page-size mm/mmap.c
--- a/mm/mmap.c~hugetlb-modular-state-for-hugetlb-page-size
+++ a/mm/mmap.c
@@ -1812,7 +1812,8 @@ int split_vma(struct mm_struct * mm, str
 	struct mempolicy *pol;
 	struct vm_area_struct *new;
 
-	if (is_vm_hugetlb_page(vma) && (addr & ~HPAGE_MASK))
+	if (is_vm_hugetlb_page(vma) && (addr &
+					~(huge_page_mask(hstate_vma(vma)))))
 		return -EINVAL;
 
 	if (mm->map_count >= sysctl_max_map_count)
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
linux-next.patch
mmu-notifiers-add-list_del_init_rcu.patch
mmu-notifiers-add-mm_take_all_locks-operation.patch
mmu-notifier-core.patch
x86-implement-pte_special.patch
x86-implement-pte_special-fix.patch
mm-introduce-get_user_pages_fast.patch
mm-introduce-get_user_pages_fast-fix.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-2.patch
x86-lockless-get_user_pages_fast-fix-2-fix-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
dio-use-get_user_pages_fast.patch
splice-use-get_user_pages_fast.patch
x86-support-1gb-hugepages-with-get_user_pages_lockless.patch
mm-readahead-scan-lockless.patch
radix-tree-add-gang_lookup_slot-gang_lookup_slot_tag.patch
mm-speculative-page-references.patch
mm-speculative-page-references-fix.patch
mm-speculative-page-references-fix-add_to_page_cache.patch
mm-speculative-page-references-fix-add_to_page_cache-fix.patch
mm-lockless-pagecache.patch
mm-spinlock-tree_lock.patch
powerpc-implement-pte_special.patch
powerpc-implement-pte_special-update.patch
powerpc-lockless-get_user_pages.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
vmscan-move-isolate_lru_page-to-vmscanc-fix.patch
vmscan-split-lru-lists-into-anon-file-sets-splitlru-bdi_cap_swap_backed.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mlock-mlocked-pages-are-unevictable-fix-fix.patch
mlock-mlocked-pages-are-unevictable-fix-3.patch
mlock-mlocked-pages-are-unevictable-fix-fix-munlock-page-table-walk-now-requires-mm.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-cleanup.patch
fix-double-unlock_page-in-2626-rc5-mm3-kernel-bug-at-mm-filemapc-575.patch
vmstat-mlocked-pages-statistics.patch
vmstat-mlocked-pages-statistics-fix-incorrect-mlocked-field-of-proc-meminfo.patch
reiser4.patch
likeliness-accounting-change-and-cleanup.patch

