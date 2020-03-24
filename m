From: akpm@linux-foundation.org
Subject: + mm-remove-config_transparent_huge_pagecache.patch added
 to -mm tree
Date: Mon, 23 Mar 2020 19:35:40 -0700
Message-ID: <20200324023540.PSK1oqqS6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727102AbgCXCfm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 23 Mar 2020 22:35:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, hch@lst.de, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org, pankaj.gupta.linux@gmail.com, willy@infradead.org


The patch titled
     Subject: mm: remove CONFIG_TRANSPARENT_HUGE_PAGECACHE
has been added to the -mm tree.  Its filename is
     mm-remove-config_transparent_huge_pagecache.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-remove-config_transparent_huge_pagecache.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-config_transparent_huge_pagecache.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove CONFIG_TRANSPARENT_HUGE_PAGECACHE

Commit e496cf3d7821 ("thp: introduce CONFIG_TRANSPARENT_HUGE_PAGECACHE")
notes that it should be reverted when the PowerPC problem was fixed.  The
commit fixing the PowerPC problem (953c66c2b22a) did not revert the
commit; instead setting CONFIG_TRANSPARENT_HUGE_PAGECACHE to the same as
CONFIG_TRANSPARENT_HUGEPAGE.  Checking with Kirill and Aneesh, this was an
oversight, so remove the Kconfig symbol and undo the work of commit
e496cf3d7821.

Link: http://lkml.kernel.org/r/20200318140253.6141-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shmem_fs.h |   10 +---------
 mm/Kconfig               |    6 +-----
 mm/huge_memory.c         |    2 +-
 mm/khugepaged.c          |   12 ++++--------
 mm/memory.c              |    5 ++---
 mm/rmap.c                |    2 +-
 mm/shmem.c               |   34 +++++++++++++++++-----------------
 7 files changed, 27 insertions(+), 44 deletions(-)

--- a/include/linux/shmem_fs.h~mm-remove-config_transparent_huge_pagecache
+++ a/include/linux/shmem_fs.h
@@ -78,6 +78,7 @@ extern void shmem_truncate_range(struct
 extern int shmem_unuse(unsigned int type, bool frontswap,
 		       unsigned long *fs_pages_to_unuse);
 
+extern bool shmem_huge_enabled(struct vm_area_struct *vma);
 extern unsigned long shmem_swap_usage(struct vm_area_struct *vma);
 extern unsigned long shmem_partial_swap_usage(struct address_space *mapping,
 						pgoff_t start, pgoff_t end);
@@ -114,15 +115,6 @@ static inline bool shmem_file(struct fil
 extern bool shmem_charge(struct inode *inode, long pages);
 extern void shmem_uncharge(struct inode *inode, long pages);
 
-#ifdef CONFIG_TRANSPARENT_HUGE_PAGECACHE
-extern bool shmem_huge_enabled(struct vm_area_struct *vma);
-#else
-static inline bool shmem_huge_enabled(struct vm_area_struct *vma)
-{
-	return false;
-}
-#endif
-
 #ifdef CONFIG_SHMEM
 extern int shmem_mcopy_atomic_pte(struct mm_struct *dst_mm, pmd_t *dst_pmd,
 				  struct vm_area_struct *dst_vma,
--- a/mm/huge_memory.c~mm-remove-config_transparent_huge_pagecache
+++ a/mm/huge_memory.c
@@ -326,7 +326,7 @@ static struct attribute *hugepage_attr[]
 	&defrag_attr.attr,
 	&use_zero_page_attr.attr,
 	&hpage_pmd_size_attr.attr,
-#if defined(CONFIG_SHMEM) && defined(CONFIG_TRANSPARENT_HUGE_PAGECACHE)
+#ifdef CONFIG_SHMEM
 	&shmem_enabled_attr.attr,
 #endif
 #ifdef CONFIG_DEBUG_VM
--- a/mm/Kconfig~mm-remove-config_transparent_huge_pagecache
+++ a/mm/Kconfig
@@ -431,10 +431,6 @@ config THP_SWAP
 
 	  For selection by architectures with reasonable THP sizes.
 
-config	TRANSPARENT_HUGE_PAGECACHE
-	def_bool y
-	depends on TRANSPARENT_HUGEPAGE
-
 #
 # UP and nommu archs use km based percpu allocator
 #
@@ -841,7 +837,7 @@ config GUP_GET_PTE_LOW_HIGH
 
 config READ_ONLY_THP_FOR_FS
 	bool "Read-only THP for filesystems (EXPERIMENTAL)"
-	depends on TRANSPARENT_HUGE_PAGECACHE && SHMEM
+	depends on TRANSPARENT_HUGEPAGE && SHMEM
 
 	help
 	  Allow khugepaged to put read-only file-backed pages in THP.
--- a/mm/khugepaged.c~mm-remove-config_transparent_huge_pagecache
+++ a/mm/khugepaged.c
@@ -415,8 +415,6 @@ static bool hugepage_vma_check(struct vm
 	    (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
 	     vma->vm_file &&
 	     (vm_flags & VM_DENYWRITE))) {
-		if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGE_PAGECACHE))
-			return false;
 		return IS_ALIGNED((vma->vm_start >> PAGE_SHIFT) - vma->vm_pgoff,
 				HPAGE_PMD_NR);
 	}
@@ -1281,7 +1279,7 @@ static void collect_mm_slot(struct mm_sl
 	}
 }
 
-#if defined(CONFIG_SHMEM) && defined(CONFIG_TRANSPARENT_HUGE_PAGECACHE)
+#ifdef CONFIG_SHMEM
 /*
  * Notify khugepaged that given addr of the mm is pte-mapped THP. Then
  * khugepaged should try to collapse the page table.
@@ -1996,6 +1994,8 @@ skip:
 		if (khugepaged_scan.address < hstart)
 			khugepaged_scan.address = hstart;
 		VM_BUG_ON(khugepaged_scan.address & ~HPAGE_PMD_MASK);
+		if (shmem_file(vma->vm_file) && !shmem_huge_enabled(vma))
+			goto skip;
 
 		while (khugepaged_scan.address < hend) {
 			int ret;
@@ -2007,14 +2007,10 @@ skip:
 				  khugepaged_scan.address + HPAGE_PMD_SIZE >
 				  hend);
 			if (IS_ENABLED(CONFIG_SHMEM) && vma->vm_file) {
-				struct file *file;
+				struct file *file = get_file(vma->vm_file);
 				pgoff_t pgoff = linear_page_index(vma,
 						khugepaged_scan.address);
 
-				if (shmem_file(vma->vm_file)
-				    && !shmem_huge_enabled(vma))
-					goto skip;
-				file = get_file(vma->vm_file);
 				up_read(&mm->mmap_sem);
 				ret = 1;
 				khugepaged_scan_file(mm, file, pgoff, hpage);
--- a/mm/memory.c~mm-remove-config_transparent_huge_pagecache
+++ a/mm/memory.c
@@ -3394,7 +3394,7 @@ map_pte:
 	return 0;
 }
 
-#ifdef CONFIG_TRANSPARENT_HUGE_PAGECACHE
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 static void deposit_prealloc_pte(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
@@ -3496,8 +3496,7 @@ vm_fault_t alloc_set_pte(struct vm_fault
 	pte_t entry;
 	vm_fault_t ret;
 
-	if (pmd_none(*vmf->pmd) && PageTransCompound(page) &&
-			IS_ENABLED(CONFIG_TRANSPARENT_HUGE_PAGECACHE)) {
+	if (pmd_none(*vmf->pmd) && PageTransCompound(page)) {
 		/* THP on COW? */
 		VM_BUG_ON_PAGE(memcg, page);
 
--- a/mm/rmap.c~mm-remove-config_transparent_huge_pagecache
+++ a/mm/rmap.c
@@ -933,7 +933,7 @@ static bool page_mkclean_one(struct page
 			set_pte_at(vma->vm_mm, address, pte, entry);
 			ret = 1;
 		} else {
-#ifdef CONFIG_TRANSPARENT_HUGE_PAGECACHE
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 			pmd_t *pmd = pvmw.pmd;
 			pmd_t entry;
 
--- a/mm/shmem.c~mm-remove-config_transparent_huge_pagecache
+++ a/mm/shmem.c
@@ -410,7 +410,7 @@ static bool shmem_confirm_swap(struct ad
 #define SHMEM_HUGE_DENY		(-1)
 #define SHMEM_HUGE_FORCE	(-2)
 
-#ifdef CONFIG_TRANSPARENT_HUGE_PAGECACHE
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 /* ifdef here to avoid bloating shmem.o when not necessary */
 
 static int shmem_huge __read_mostly;
@@ -580,7 +580,7 @@ static long shmem_unused_huge_count(stru
 	struct shmem_sb_info *sbinfo = SHMEM_SB(sb);
 	return READ_ONCE(sbinfo->shrinklist_len);
 }
-#else /* !CONFIG_TRANSPARENT_HUGE_PAGECACHE */
+#else /* !CONFIG_TRANSPARENT_HUGEPAGE */
 
 #define shmem_huge SHMEM_HUGE_DENY
 
@@ -589,11 +589,11 @@ static unsigned long shmem_unused_huge_s
 {
 	return 0;
 }
-#endif /* CONFIG_TRANSPARENT_HUGE_PAGECACHE */
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 static inline bool is_huge_enabled(struct shmem_sb_info *sbinfo)
 {
-	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGE_PAGECACHE) &&
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
 	    (shmem_huge == SHMEM_HUGE_FORCE || sbinfo->huge) &&
 	    shmem_huge != SHMEM_HUGE_DENY)
 		return true;
@@ -1047,7 +1047,7 @@ static int shmem_setattr(struct dentry *
 			 * Part of the huge page can be beyond i_size: subject
 			 * to shrink under memory pressure.
 			 */
-			if (IS_ENABLED(CONFIG_TRANSPARENT_HUGE_PAGECACHE)) {
+			if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
 				spin_lock(&sbinfo->shrinklist_lock);
 				/*
 				 * _careful to defend against unlocked access to
@@ -1498,7 +1498,7 @@ static struct page *shmem_alloc_and_acct
 	int nr;
 	int err = -ENOSPC;
 
-	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGE_PAGECACHE))
+	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
 		huge = false;
 	nr = huge ? HPAGE_PMD_NR : 1;
 
@@ -2084,7 +2084,7 @@ unsigned long shmem_get_unmapped_area(st
 	get_area = current->mm->get_unmapped_area;
 	addr = get_area(file, uaddr, len, pgoff, flags);
 
-	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGE_PAGECACHE))
+	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
 		return addr;
 	if (IS_ERR_VALUE(addr))
 		return addr;
@@ -2223,7 +2223,7 @@ static int shmem_mmap(struct file *file,
 
 	file_accessed(file);
 	vma->vm_ops = &shmem_vm_ops;
-	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGE_PAGECACHE) &&
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
 			((vma->vm_start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK) <
 			(vma->vm_end & HPAGE_PMD_MASK)) {
 		khugepaged_enter(vma, vma->vm_flags);
@@ -3447,7 +3447,7 @@ static int shmem_parse_one(struct fs_con
 	case Opt_huge:
 		ctx->huge = result.uint_32;
 		if (ctx->huge != SHMEM_HUGE_NEVER &&
-		    !(IS_ENABLED(CONFIG_TRANSPARENT_HUGE_PAGECACHE) &&
+		    !(IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
 		      has_transparent_hugepage()))
 			goto unsupported_parameter;
 		ctx->seen |= SHMEM_SEEN_HUGE;
@@ -3593,7 +3593,7 @@ static int shmem_show_options(struct seq
 	if (!gid_eq(sbinfo->gid, GLOBAL_ROOT_GID))
 		seq_printf(seq, ",gid=%u",
 				from_kgid_munged(&init_user_ns, sbinfo->gid));
-#ifdef CONFIG_TRANSPARENT_HUGE_PAGECACHE
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	/* Rightly or wrongly, show huge mount option unmasked by shmem_huge */
 	if (sbinfo->huge)
 		seq_printf(seq, ",huge=%s", shmem_format_huge(sbinfo->huge));
@@ -3838,7 +3838,7 @@ static const struct super_operations shm
 	.evict_inode	= shmem_evict_inode,
 	.drop_inode	= generic_delete_inode,
 	.put_super	= shmem_put_super,
-#ifdef CONFIG_TRANSPARENT_HUGE_PAGECACHE
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	.nr_cached_objects	= shmem_unused_huge_count,
 	.free_cached_objects	= shmem_unused_huge_scan,
 #endif
@@ -3900,7 +3900,7 @@ int __init shmem_init(void)
 		goto out1;
 	}
 
-#ifdef CONFIG_TRANSPARENT_HUGE_PAGECACHE
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	if (has_transparent_hugepage() && shmem_huge > SHMEM_HUGE_DENY)
 		SHMEM_SB(shm_mnt->mnt_sb)->huge = shmem_huge;
 	else
@@ -3916,7 +3916,7 @@ out2:
 	return error;
 }
 
-#if defined(CONFIG_TRANSPARENT_HUGE_PAGECACHE) && defined(CONFIG_SYSFS)
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE) && defined(CONFIG_SYSFS)
 static ssize_t shmem_enabled_show(struct kobject *kobj,
 		struct kobj_attribute *attr, char *buf)
 {
@@ -3968,9 +3968,9 @@ static ssize_t shmem_enabled_store(struc
 
 struct kobj_attribute shmem_enabled_attr =
 	__ATTR(shmem_enabled, 0644, shmem_enabled_show, shmem_enabled_store);
-#endif /* CONFIG_TRANSPARENT_HUGE_PAGECACHE && CONFIG_SYSFS */
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE && CONFIG_SYSFS */
 
-#ifdef CONFIG_TRANSPARENT_HUGE_PAGECACHE
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 bool shmem_huge_enabled(struct vm_area_struct *vma)
 {
 	struct inode *inode = file_inode(vma->vm_file);
@@ -4005,7 +4005,7 @@ bool shmem_huge_enabled(struct vm_area_s
 			return false;
 	}
 }
-#endif /* CONFIG_TRANSPARENT_HUGE_PAGECACHE */
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 #else /* !CONFIG_SHMEM */
 
@@ -4174,7 +4174,7 @@ int shmem_zero_setup(struct vm_area_stru
 	vma->vm_file = file;
 	vma->vm_ops = &shmem_vm_ops;
 
-	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGE_PAGECACHE) &&
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
 			((vma->vm_start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK) <
 			(vma->vm_end & HPAGE_PMD_MASK)) {
 		khugepaged_enter(vma, vma->vm_flags);
_

Patches currently in -mm which might be from willy@infradead.org are

mm-improve-dump_page-for-compound-pages.patch
mm-add-pagemaph-to-the-fine-documentation.patch
mm-use-vm_fault-error-code-directly.patch
mm-rename-arguments-to-find_subpage.patch
mm-check-pagetail-in-hpage_nr_pages-even-when-thp.patch
mm-optimise-find_subpage-for-thp.patch
mm-remove-config_transparent_huge_pagecache.patch
mm-use-vm_bug_on_page-in-clear_page_dirty_for_io.patch
mm-unexport-find_get_entry.patch
mm-rewrite-pagecache_get_page-documentation.patch
proc-inline-vma_stop-into-m_stop.patch
proc-remove-m_cache_vma.patch
proc-use-ppos-instead-of-m-version.patch
seq_file-remove-m-version.patch
proc-inline-m_next_vma-into-m_next.patch
