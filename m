From: akpm@linux-foundation.org
Subject: + thp-introduce-config_transparent_huge_pagecache.patch added to
 -mm tree
Date: Tue, 07 Jun 2016 14:04:59 -0700
Message-ID: <575736fb.1v6DN8Lb46/uOo9I%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39660 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423268AbcFGVFB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jun 2016 17:05:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, andreslc@google.com, aneesh.kumar@linux.vnet.ibm.com, cl@gentwo.org, dave.hansen@intel.com, hughd@google.com, jmarchan@redhat.com, n-horiguchi@ah.jp.nec.com, peterz@infradead.org, quning@gmail.com, sasha.levin@oracle.com, vbabka@suse.cz, yang.shi@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: introduce CONFIG_TRANSPARENT_HUGE_PAGECACHE
has been added to the -mm tree.  Its filename is
     thp-introduce-config_transparent_huge_pagecache.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/thp-introduce-config_transparent_huge_pagecache.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/thp-introduce-config_transparent_huge_pagecache.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp: introduce CONFIG_TRANSPARENT_HUGE_PAGECACHE

For file mappings, we don't deposit page tables on THP allocation
because it's not strictly required to implement split_huge_pmd(): we
can just clear pmd and let following page faults to reconstruct the
page table.

But Power makes use of deposited page table to address MMU quirk.

Let's hide THP page cache, including huge tmpfs, under separate config
option, so it can be forbidden on Power.

We can revert the patch later once solution for Power found.

Link: http://lkml.kernel.org/r/1465297246-98985-31-git-send-email-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Yang Shi <yang.shi@linaro.org>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Ning Qu <quning@gmail.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shmem_fs.h |   10 +++++++++-
 mm/Kconfig               |    8 ++++++++
 mm/huge_memory.c         |    2 +-
 mm/khugepaged.c          |   11 +++++++----
 mm/memory.c              |    5 +++--
 mm/shmem.c               |   26 +++++++++++++-------------
 6 files changed, 41 insertions(+), 21 deletions(-)

diff -puN include/linux/shmem_fs.h~thp-introduce-config_transparent_huge_pagecache include/linux/shmem_fs.h
--- a/include/linux/shmem_fs.h~thp-introduce-config_transparent_huge_pagecache
+++ a/include/linux/shmem_fs.h
@@ -54,7 +54,6 @@ extern unsigned long shmem_get_unmapped_
 		unsigned long len, unsigned long pgoff, unsigned long flags);
 extern int shmem_lock(struct file *file, int lock, struct user_struct *user);
 extern bool shmem_mapping(struct address_space *mapping);
-extern bool shmem_huge_enabled(struct vm_area_struct *vma);
 extern void shmem_unlock_mapping(struct address_space *mapping);
 extern struct page *shmem_read_mapping_page_gfp(struct address_space *mapping,
 					pgoff_t index, gfp_t gfp_mask);
@@ -112,4 +111,13 @@ static inline long shmem_fcntl(struct fi
 
 #endif
 
+#ifdef CONFIG_TRANSPARENT_HUGE_PAGECACHE
+extern bool shmem_huge_enabled(struct vm_area_struct *vma);
+#else
+static inline bool shmem_huge_enabled(struct vm_area_struct *vma)
+{
+	return false;
+}
+#endif
+
 #endif
diff -puN mm/Kconfig~thp-introduce-config_transparent_huge_pagecache mm/Kconfig
--- a/mm/Kconfig~thp-introduce-config_transparent_huge_pagecache
+++ a/mm/Kconfig
@@ -440,6 +440,14 @@ choice
 endchoice
 
 #
+# We don't deposit page tables on file THP mapping,
+# but Power makes use of them to address MMU quirk.
+#
+config	TRANSPARENT_HUGE_PAGECACHE
+	def_bool y
+	depends on TRANSPARENT_HUGEPAGE && !PPC
+
+#
 # UP and nommu archs use km based percpu allocator
 #
 config NEED_PER_CPU_KM
diff -puN mm/huge_memory.c~thp-introduce-config_transparent_huge_pagecache mm/huge_memory.c
--- a/mm/huge_memory.c~thp-introduce-config_transparent_huge_pagecache
+++ a/mm/huge_memory.c
@@ -292,7 +292,7 @@ static struct attribute *hugepage_attr[]
 	&enabled_attr.attr,
 	&defrag_attr.attr,
 	&use_zero_page_attr.attr,
-#ifdef CONFIG_SHMEM
+#if defined(CONFIG_SHMEM) && defined(CONFIG_TRANSPARENT_HUGE_PAGECACHE)
 	&shmem_enabled_attr.attr,
 #endif
 #ifdef CONFIG_DEBUG_VM
diff -puN mm/khugepaged.c~thp-introduce-config_transparent_huge_pagecache mm/khugepaged.c
--- a/mm/khugepaged.c~thp-introduce-config_transparent_huge_pagecache
+++ a/mm/khugepaged.c
@@ -806,6 +806,8 @@ static bool hugepage_vma_check(struct vm
 	    (vma->vm_flags & VM_NOHUGEPAGE))
 		return false;
 	if (shmem_file(vma->vm_file)) {
+		if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGE_PAGECACHE))
+			return false;
 		return IS_ALIGNED((vma->vm_start >> PAGE_SHIFT) - vma->vm_pgoff,
 				HPAGE_PMD_NR);
 	}
@@ -1212,7 +1214,7 @@ static void collect_mm_slot(struct mm_sl
 	}
 }
 
-#ifdef CONFIG_SHMEM
+#if defined(CONFIG_SHMEM) && defined(CONFIG_TRANSPARENT_HUGE_PAGECACHE)
 static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
 {
 	struct vm_area_struct *vma;
@@ -1671,8 +1673,6 @@ skip:
 		if (khugepaged_scan.address < hstart)
 			khugepaged_scan.address = hstart;
 		VM_BUG_ON(khugepaged_scan.address & ~HPAGE_PMD_MASK);
-		if (shmem_file(vma->vm_file) && !shmem_huge_enabled(vma))
-			goto skip;
 
 		while (khugepaged_scan.address < hend) {
 			int ret;
@@ -1684,9 +1684,12 @@ skip:
 				  khugepaged_scan.address + HPAGE_PMD_SIZE >
 				  hend);
 			if (shmem_file(vma->vm_file)) {
-				struct file *file = get_file(vma->vm_file);
+				struct file *file;
 				pgoff_t pgoff = linear_page_index(vma,
 						khugepaged_scan.address);
+				if (!shmem_huge_enabled(vma))
+					goto skip;
+				file = get_file(vma->vm_file);
 				up_read(&mm->mmap_sem);
 				ret = 1;
 				khugepaged_scan_shmem(mm, file->f_mapping,
diff -puN mm/memory.c~thp-introduce-config_transparent_huge_pagecache mm/memory.c
--- a/mm/memory.c~thp-introduce-config_transparent_huge_pagecache
+++ a/mm/memory.c
@@ -2921,7 +2921,7 @@ map_pte:
 	return 0;
 }
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+#ifdef CONFIG_TRANSPARENT_HUGE_PAGECACHE
 
 #define HPAGE_CACHE_INDEX_MASK (HPAGE_PMD_NR - 1)
 static inline bool transhuge_vma_suitable(struct vm_area_struct *vma,
@@ -3003,7 +3003,8 @@ int alloc_set_pte(struct fault_env *fe,
 	pte_t entry;
 	int ret;
 
-	if (pmd_none(*fe->pmd) && PageTransCompound(page)) {
+	if (pmd_none(*fe->pmd) && PageTransCompound(page) &&
+			IS_ENABLED(CONFIG_TRANSPARENT_HUGE_PAGECACHE)) {
 		/* THP on COW? */
 		VM_BUG_ON_PAGE(memcg, page);
 
diff -puN mm/shmem.c~thp-introduce-config_transparent_huge_pagecache mm/shmem.c
--- a/mm/shmem.c~thp-introduce-config_transparent_huge_pagecache
+++ a/mm/shmem.c
@@ -363,7 +363,7 @@ static bool shmem_confirm_swap(struct ad
 #define SHMEM_HUGE_DENY		(-1)
 #define SHMEM_HUGE_FORCE	(-2)
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+#ifdef CONFIG_TRANSPARENT_HUGE_PAGECACHE
 /* ifdef here to avoid bloating shmem.o when not necessary */
 
 int shmem_huge __read_mostly;
@@ -406,11 +406,11 @@ static const char *shmem_format_huge(int
 	}
 }
 
-#else /* !CONFIG_TRANSPARENT_HUGEPAGE */
+#else /* !CONFIG_TRANSPARENT_HUGE_PAGECACHE */
 
 #define shmem_huge SHMEM_HUGE_DENY
 
-#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
+#endif /* CONFIG_TRANSPARENT_HUGE_PAGECACHE */
 
 /*
  * Like add_to_page_cache_locked, but error if expected item has gone.
@@ -1229,7 +1229,7 @@ static struct page *shmem_alloc_hugepage
 	void __rcu **results;
 	struct page *page;
 
-	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
+	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGE_PAGECACHE))
 		return NULL;
 
 	rcu_read_lock();
@@ -1270,7 +1270,7 @@ static struct page *shmem_alloc_and_acct
 	int nr;
 	int err = -ENOSPC;
 
-	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
+	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGE_PAGECACHE))
 		huge = false;
 	nr = huge ? HPAGE_PMD_NR : 1;
 
@@ -1773,7 +1773,7 @@ unsigned long shmem_get_unmapped_area(st
 	get_area = current->mm->get_unmapped_area;
 	addr = get_area(file, uaddr, len, pgoff, flags);
 
-	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
+	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGE_PAGECACHE))
 		return addr;
 	if (IS_ERR_VALUE(addr))
 		return addr;
@@ -1890,7 +1890,7 @@ static int shmem_mmap(struct file *file,
 {
 	file_accessed(file);
 	vma->vm_ops = &shmem_vm_ops;
-	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGE_PAGECACHE) &&
 			((vma->vm_start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK) <
 			(vma->vm_end & HPAGE_PMD_MASK)) {
 		khugepaged_enter(vma, vma->vm_flags);
@@ -3285,7 +3285,7 @@ static int shmem_parse_options(char *opt
 			sbinfo->gid = make_kgid(current_user_ns(), gid);
 			if (!gid_valid(sbinfo->gid))
 				goto bad_val;
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+#ifdef CONFIG_TRANSPARENT_HUGE_PAGECACHE
 		} else if (!strcmp(this_char, "huge")) {
 			int huge;
 			huge = shmem_parse_huge(value);
@@ -3382,7 +3382,7 @@ static int shmem_show_options(struct seq
 	if (!gid_eq(sbinfo->gid, GLOBAL_ROOT_GID))
 		seq_printf(seq, ",gid=%u",
 				from_kgid_munged(&init_user_ns, sbinfo->gid));
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+#ifdef CONFIG_TRANSPARENT_HUGE_PAGECACHE
 	/* Rightly or wrongly, show huge mount option unmasked by shmem_huge */
 	if (sbinfo->huge)
 		seq_printf(seq, ",huge=%s", shmem_format_huge(sbinfo->huge));
@@ -3728,7 +3728,7 @@ int __init shmem_init(void)
 		goto out1;
 	}
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+#ifdef CONFIG_TRANSPARENT_HUGE_PAGECACHE
 	if (has_transparent_hugepage() && shmem_huge < SHMEM_HUGE_DENY)
 		SHMEM_SB(shm_mnt->mnt_sb)->huge = shmem_huge;
 	else
@@ -3745,7 +3745,7 @@ out3:
 	return error;
 }
 
-#if defined(CONFIG_TRANSPARENT_HUGEPAGE) && defined(CONFIG_SYSFS)
+#if defined(CONFIG_TRANSPARENT_HUGE_PAGECACHE) && defined(CONFIG_SYSFS)
 static ssize_t shmem_enabled_show(struct kobject *kobj,
 		struct kobj_attribute *attr, char *buf)
 {
@@ -3828,7 +3828,7 @@ bool shmem_huge_enabled(struct vm_area_s
 			return false;
 	}
 }
-#endif /* CONFIG_TRANSPARENT_HUGEPAGE && CONFIG_SYSFS */
+#endif /* CONFIG_TRANSPARENT_HUGE_PAGECACHE && CONFIG_SYSFS */
 
 #else /* !CONFIG_SHMEM */
 
@@ -4008,7 +4008,7 @@ int shmem_zero_setup(struct vm_area_stru
 	vma->vm_file = file;
 	vma->vm_ops = &shmem_vm_ops;
 
-	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGE_PAGECACHE) &&
 			((vma->vm_start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK) <
 			(vma->vm_end & HPAGE_PMD_MASK)) {
 		khugepaged_enter(vma, vma->vm_flags);
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch
mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix.patch
thp-mlock-update-unevictable-lrutxt.patch
mm-do-not-pass-mm_struct-into-handle_mm_fault.patch
mm-introduce-fault_env.patch
mm-postpone-page-table-allocation-until-we-have-page-to-map.patch
rmap-support-file-thp.patch
mm-introduce-do_set_pmd.patch
thp-vmstats-add-counters-for-huge-file-pages.patch
thp-support-file-pages-in-zap_huge_pmd.patch
thp-handle-file-pages-in-split_huge_pmd.patch
thp-handle-file-cow-faults.patch
thp-skip-file-huge-pmd-on-copy_huge_pmd.patch
thp-prepare-change_huge_pmd-for-file-thp.patch
thp-run-vma_adjust_trans_huge-outside-i_mmap_rwsem.patch
thp-file-pages-support-for-split_huge_page.patch
thp-mlock-do-not-mlock-pte-mapped-file-huge-pages.patch
vmscan-split-file-huge-pages-before-paging-them-out.patch
page-flags-relax-policy-for-pg_mappedtodisk-and-pg_reclaim.patch
radix-tree-implement-radix_tree_maybe_preload_order.patch
filemap-prepare-find-and-delete-operations-for-huge-pages.patch
truncate-handle-file-thp.patch
mm-rmap-account-shmem-thp-pages.patch
shmem-prepare-huge=-mount-option-and-sysfs-knob.patch
shmem-add-huge-pages-support.patch
shmem-thp-respect-madv_nohugepage-for-file-mappings.patch
thp-extract-khugepaged-from-mm-huge_memoryc.patch
khugepaged-move-up_readmmap_sem-out-of-khugepaged_alloc_page.patch
shmem-make-shmem_inode_info-lock-irq-safe.patch
khugepaged-add-support-of-collapse-for-tmpfs-shmem-pages.patch
thp-introduce-config_transparent_huge_pagecache.patch
shmem-split-huge-pages-beyond-i_size-under-memory-pressure.patch
thp-update-documentation-vm-transhugefilesystems-proctxt.patch
a.patch

