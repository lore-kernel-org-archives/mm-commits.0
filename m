From: akpm@linux-foundation.org
Subject: + rmap-support-file-thp.patch added to -mm tree
Date: Tue, 07 Jun 2016 14:03:51 -0700
Message-ID: <575736b7.veG+VaF9OBQfBdYB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39339 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161158AbcFGVDx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jun 2016 17:03:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, andreslc@google.com, aneesh.kumar@linux.vnet.ibm.com, cl@gentwo.org, dave.hansen@intel.com, hughd@google.com, jmarchan@redhat.com, n-horiguchi@ah.jp.nec.com, peterz@infradead.org, quning@gmail.com, sasha.levin@oracle.com, vbabka@suse.cz, yang.shi@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rmap: support file thp
has been added to the -mm tree.  Its filename is
     rmap-support-file-thp.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rmap-support-file-thp.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rmap-support-file-thp.patch

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
Subject: rmap: support file thp

Naive approach: on mapping/unmapping the page as compound we update
->_mapcount on each 4k page. That's not efficient, but it's not obvious
how we can optimize this. We can look into optimization later.

PG_double_map optimization doesn't work for file pages since lifecycle
of file pages is different comparing to anon pages: file page can be
mapped again at any time.

Link: http://lkml.kernel.org/r/1465297246-98985-6-git-send-email-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
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
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    2 -
 mm/huge_memory.c     |   10 +++++---
 mm/memory.c          |    4 +--
 mm/migrate.c         |    2 -
 mm/rmap.c            |   48 +++++++++++++++++++++++++++++------------
 mm/util.c            |    6 +++++
 6 files changed, 52 insertions(+), 20 deletions(-)

diff -puN include/linux/rmap.h~rmap-support-file-thp include/linux/rmap.h
--- a/include/linux/rmap.h~rmap-support-file-thp
+++ a/include/linux/rmap.h
@@ -165,7 +165,7 @@ void do_page_add_anon_rmap(struct page *
 			   unsigned long, int);
 void page_add_new_anon_rmap(struct page *, struct vm_area_struct *,
 		unsigned long, bool);
-void page_add_file_rmap(struct page *);
+void page_add_file_rmap(struct page *, bool);
 void page_remove_rmap(struct page *, bool);
 
 void hugepage_add_anon_rmap(struct page *, struct vm_area_struct *,
diff -puN mm/huge_memory.c~rmap-support-file-thp mm/huge_memory.c
--- a/mm/huge_memory.c~rmap-support-file-thp
+++ a/mm/huge_memory.c
@@ -3320,18 +3320,22 @@ static void __split_huge_page(struct pag
 
 int total_mapcount(struct page *page)
 {
-	int i, ret;
+	int i, compound, ret;
 
 	VM_BUG_ON_PAGE(PageTail(page), page);
 
 	if (likely(!PageCompound(page)))
 		return atomic_read(&page->_mapcount) + 1;
 
-	ret = compound_mapcount(page);
+	compound = compound_mapcount(page);
 	if (PageHuge(page))
-		return ret;
+		return compound;
+	ret = compound;
 	for (i = 0; i < HPAGE_PMD_NR; i++)
 		ret += atomic_read(&page[i]._mapcount) + 1;
+	/* File pages has compound_mapcount included in _mapcount */
+	if (!PageAnon(page))
+		return ret - compound * HPAGE_PMD_NR;
 	if (PageDoubleMap(page))
 		ret -= HPAGE_PMD_NR;
 	return ret;
diff -puN mm/memory.c~rmap-support-file-thp mm/memory.c
--- a/mm/memory.c~rmap-support-file-thp
+++ a/mm/memory.c
@@ -1494,7 +1494,7 @@ static int insert_page(struct vm_area_st
 	/* Ok, finally just insert the thing.. */
 	get_page(page);
 	inc_mm_counter_fast(mm, mm_counter_file(page));
-	page_add_file_rmap(page);
+	page_add_file_rmap(page, false);
 	set_pte_at(mm, addr, pte, mk_pte(page, prot));
 
 	retval = 0;
@@ -2965,7 +2965,7 @@ int alloc_set_pte(struct fault_env *fe,
 		lru_cache_add_active_or_unevictable(page, vma);
 	} else {
 		inc_mm_counter_fast(vma->vm_mm, mm_counter_file(page));
-		page_add_file_rmap(page);
+		page_add_file_rmap(page, false);
 	}
 	set_pte_at(vma->vm_mm, fe->address, fe->pte, entry);
 
diff -puN mm/migrate.c~rmap-support-file-thp mm/migrate.c
--- a/mm/migrate.c~rmap-support-file-thp
+++ a/mm/migrate.c
@@ -259,7 +259,7 @@ static int remove_migration_pte(struct p
 	} else if (PageAnon(new))
 		page_add_anon_rmap(new, vma, addr, false);
 	else
-		page_add_file_rmap(new);
+		page_add_file_rmap(new, false);
 
 	if (vma->vm_flags & VM_LOCKED && !PageTransCompound(new))
 		mlock_vma_page(new);
diff -puN mm/rmap.c~rmap-support-file-thp mm/rmap.c
--- a/mm/rmap.c~rmap-support-file-thp
+++ a/mm/rmap.c
@@ -1273,18 +1273,34 @@ void page_add_new_anon_rmap(struct page
  *
  * The caller needs to hold the pte lock.
  */
-void page_add_file_rmap(struct page *page)
+void page_add_file_rmap(struct page *page, bool compound)
 {
+	int i, nr = 1;
+
+	VM_BUG_ON_PAGE(compound && !PageTransHuge(page), page);
 	lock_page_memcg(page);
-	if (atomic_inc_and_test(&page->_mapcount)) {
-		__inc_zone_page_state(page, NR_FILE_MAPPED);
-		mem_cgroup_inc_page_stat(page, MEM_CGROUP_STAT_FILE_MAPPED);
+	if (compound && PageTransHuge(page)) {
+		for (i = 0, nr = 0; i < HPAGE_PMD_NR; i++) {
+			if (atomic_inc_and_test(&page[i]._mapcount))
+				nr++;
+		}
+		if (!atomic_inc_and_test(compound_mapcount_ptr(page)))
+			goto out;
+	} else {
+		if (!atomic_inc_and_test(&page->_mapcount))
+			goto out;
 	}
+	__mod_zone_page_state(page_zone(page), NR_FILE_MAPPED, nr);
+	mem_cgroup_inc_page_stat(page, MEM_CGROUP_STAT_FILE_MAPPED);
+out:
 	unlock_page_memcg(page);
 }
 
-static void page_remove_file_rmap(struct page *page)
+static void page_remove_file_rmap(struct page *page, bool compound)
 {
+	int i, nr = 1;
+
+	VM_BUG_ON_PAGE(compound && !PageTransHuge(page), page);
 	lock_page_memcg(page);
 
 	/* Hugepages are not counted in NR_FILE_MAPPED for now. */
@@ -1295,15 +1311,24 @@ static void page_remove_file_rmap(struct
 	}
 
 	/* page still mapped by someone else? */
-	if (!atomic_add_negative(-1, &page->_mapcount))
-		goto out;
+	if (compound && PageTransHuge(page)) {
+		for (i = 0, nr = 0; i < HPAGE_PMD_NR; i++) {
+			if (atomic_add_negative(-1, &page[i]._mapcount))
+				nr++;
+		}
+		if (!atomic_add_negative(-1, compound_mapcount_ptr(page)))
+			goto out;
+	} else {
+		if (!atomic_add_negative(-1, &page->_mapcount))
+			goto out;
+	}
 
 	/*
 	 * We use the irq-unsafe __{inc|mod}_zone_page_stat because
 	 * these counters are not modified in interrupt context, and
 	 * pte lock(a spinlock) is held, which implies preemption disabled.
 	 */
-	__dec_zone_page_state(page, NR_FILE_MAPPED);
+	__mod_zone_page_state(page_zone(page), NR_FILE_MAPPED, -nr);
 	mem_cgroup_dec_page_stat(page, MEM_CGROUP_STAT_FILE_MAPPED);
 
 	if (unlikely(PageMlocked(page)))
@@ -1359,11 +1384,8 @@ static void page_remove_anon_compound_rm
  */
 void page_remove_rmap(struct page *page, bool compound)
 {
-	if (!PageAnon(page)) {
-		VM_BUG_ON_PAGE(compound && !PageHuge(page), page);
-		page_remove_file_rmap(page);
-		return;
-	}
+	if (!PageAnon(page))
+		return page_remove_file_rmap(page, compound);
 
 	if (compound)
 		return page_remove_anon_compound_rmap(page);
diff -puN mm/util.c~rmap-support-file-thp mm/util.c
--- a/mm/util.c~rmap-support-file-thp
+++ a/mm/util.c
@@ -412,6 +412,12 @@ int __page_mapcount(struct page *page)
 	int ret;
 
 	ret = atomic_read(&page->_mapcount) + 1;
+	/*
+	 * For file THP page->_mapcount contains total number of mapping
+	 * of the page: no need to look into compound_mapcount.
+	 */
+	if (!PageAnon(page) && !PageHuge(page))
+		return ret;
 	page = compound_head(page);
 	ret += atomic_read(compound_mapcount_ptr(page)) + 1;
 	if (PageDoubleMap(page))
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

