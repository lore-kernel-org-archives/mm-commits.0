From: akpm@linux-foundation.org
Subject: [merged] mm-rmap-account-shmem-thp-pages.patch removed from -mm
 tree
Date: Wed, 27 Jul 2016 12:02:50 -0700
Message-ID: <5799055a.8iWLkLLO6bmbI1SW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40721 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932311AbcG0TCv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jul 2016 15:02:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, rmap: account shmem thp pages
has been removed from the -mm tree.  Its filename was
     mm-rmap-account-shmem-thp-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm, rmap: account shmem thp pages

Let's add ShmemHugePages and ShmemPmdMapped fields into meminfo and
smaps. It indicates how many times we allocate and map shmem THP.

NR_ANON_TRANSPARENT_HUGEPAGES is renamed to NR_ANON_THPS.

Link: http://lkml.kernel.org/r/1466021202-61880-27-git-send-email-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c    |   13 +++++++++----
 fs/proc/meminfo.c      |    7 +++++--
 fs/proc/task_mmu.c     |   10 +++++++++-
 include/linux/mmzone.h |    4 +++-
 mm/huge_memory.c       |    4 +++-
 mm/page_alloc.c        |   19 +++++++++++++++++++
 mm/rmap.c              |   14 ++++++++------
 mm/vmstat.c            |    2 ++
 8 files changed, 58 insertions(+), 15 deletions(-)

diff -puN drivers/base/node.c~mm-rmap-account-shmem-thp-pages drivers/base/node.c
--- a/drivers/base/node.c~mm-rmap-account-shmem-thp-pages
+++ a/drivers/base/node.c
@@ -113,6 +113,8 @@ static ssize_t node_read_meminfo(struct
 		       "Node %d SUnreclaim:     %8lu kB\n"
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 		       "Node %d AnonHugePages:  %8lu kB\n"
+		       "Node %d ShmemHugePages: %8lu kB\n"
+		       "Node %d ShmemPmdMapped: %8lu kB\n"
 #endif
 			,
 		       nid, K(node_page_state(nid, NR_FILE_DIRTY)),
@@ -131,10 +133,13 @@ static ssize_t node_read_meminfo(struct
 				node_page_state(nid, NR_SLAB_UNRECLAIMABLE)),
 		       nid, K(node_page_state(nid, NR_SLAB_RECLAIMABLE)),
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-		       nid, K(node_page_state(nid, NR_SLAB_UNRECLAIMABLE))
-			, nid,
-			K(node_page_state(nid, NR_ANON_TRANSPARENT_HUGEPAGES) *
-			HPAGE_PMD_NR));
+		       nid, K(node_page_state(nid, NR_SLAB_UNRECLAIMABLE)),
+		       nid, K(node_page_state(nid, NR_ANON_THPS) *
+				       HPAGE_PMD_NR),
+		       nid, K(node_page_state(nid, NR_SHMEM_THPS) *
+				       HPAGE_PMD_NR),
+		       nid, K(node_page_state(nid, NR_SHMEM_PMDMAPPED) *
+				       HPAGE_PMD_NR));
 #else
 		       nid, K(node_page_state(nid, NR_SLAB_UNRECLAIMABLE)));
 #endif
diff -puN fs/proc/meminfo.c~mm-rmap-account-shmem-thp-pages fs/proc/meminfo.c
--- a/fs/proc/meminfo.c~mm-rmap-account-shmem-thp-pages
+++ a/fs/proc/meminfo.c
@@ -105,6 +105,8 @@ static int meminfo_proc_show(struct seq_
 #endif
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 		"AnonHugePages:  %8lu kB\n"
+		"ShmemHugePages: %8lu kB\n"
+		"ShmemPmdMapped: %8lu kB\n"
 #endif
 #ifdef CONFIG_CMA
 		"CmaTotal:       %8lu kB\n"
@@ -162,8 +164,9 @@ static int meminfo_proc_show(struct seq_
 		, atomic_long_read(&num_poisoned_pages) << (PAGE_SHIFT - 10)
 #endif
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-		, K(global_page_state(NR_ANON_TRANSPARENT_HUGEPAGES) *
-		   HPAGE_PMD_NR)
+		, K(global_page_state(NR_ANON_THPS) * HPAGE_PMD_NR)
+		, K(global_page_state(NR_SHMEM_THPS) * HPAGE_PMD_NR)
+		, K(global_page_state(NR_SHMEM_PMDMAPPED) * HPAGE_PMD_NR)
 #endif
 #ifdef CONFIG_CMA
 		, K(totalcma_pages)
diff -puN fs/proc/task_mmu.c~mm-rmap-account-shmem-thp-pages fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-rmap-account-shmem-thp-pages
+++ a/fs/proc/task_mmu.c
@@ -448,6 +448,7 @@ struct mem_size_stats {
 	unsigned long referenced;
 	unsigned long anonymous;
 	unsigned long anonymous_thp;
+	unsigned long shmem_thp;
 	unsigned long swap;
 	unsigned long shared_hugetlb;
 	unsigned long private_hugetlb;
@@ -576,7 +577,12 @@ static void smaps_pmd_entry(pmd_t *pmd,
 	page = follow_trans_huge_pmd(vma, addr, pmd, FOLL_DUMP);
 	if (IS_ERR_OR_NULL(page))
 		return;
-	mss->anonymous_thp += HPAGE_PMD_SIZE;
+	if (PageAnon(page))
+		mss->anonymous_thp += HPAGE_PMD_SIZE;
+	else if (PageSwapBacked(page))
+		mss->shmem_thp += HPAGE_PMD_SIZE;
+	else
+		VM_BUG_ON_PAGE(1, page);
 	smaps_account(mss, page, true, pmd_young(*pmd), pmd_dirty(*pmd));
 }
 #else
@@ -770,6 +776,7 @@ static int show_smap(struct seq_file *m,
 		   "Referenced:     %8lu kB\n"
 		   "Anonymous:      %8lu kB\n"
 		   "AnonHugePages:  %8lu kB\n"
+		   "ShmemPmdMapped: %8lu kB\n"
 		   "Shared_Hugetlb: %8lu kB\n"
 		   "Private_Hugetlb: %7lu kB\n"
 		   "Swap:           %8lu kB\n"
@@ -787,6 +794,7 @@ static int show_smap(struct seq_file *m,
 		   mss.referenced >> 10,
 		   mss.anonymous >> 10,
 		   mss.anonymous_thp >> 10,
+		   mss.shmem_thp >> 10,
 		   mss.shared_hugetlb >> 10,
 		   mss.private_hugetlb >> 10,
 		   mss.swap >> 10,
diff -puN include/linux/mmzone.h~mm-rmap-account-shmem-thp-pages include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-rmap-account-shmem-thp-pages
+++ a/include/linux/mmzone.h
@@ -154,7 +154,9 @@ enum zone_stat_item {
 	WORKINGSET_REFAULT,
 	WORKINGSET_ACTIVATE,
 	WORKINGSET_NODERECLAIM,
-	NR_ANON_TRANSPARENT_HUGEPAGES,
+	NR_ANON_THPS,
+	NR_SHMEM_THPS,
+	NR_SHMEM_PMDMAPPED,
 	NR_FREE_CMA_PAGES,
 	NR_VM_ZONE_STAT_ITEMS };
 
diff -puN mm/huge_memory.c~mm-rmap-account-shmem-thp-pages mm/huge_memory.c
--- a/mm/huge_memory.c~mm-rmap-account-shmem-thp-pages
+++ a/mm/huge_memory.c
@@ -3067,7 +3067,7 @@ static void __split_huge_pmd_locked(stru
 
 	if (atomic_add_negative(-1, compound_mapcount_ptr(page))) {
 		/* Last compound_mapcount is gone. */
-		__dec_zone_page_state(page, NR_ANON_TRANSPARENT_HUGEPAGES);
+		__dec_zone_page_state(page, NR_ANON_THPS);
 		if (TestClearPageDoubleMap(page)) {
 			/* No need in mapcount reference anymore */
 			for (i = 0; i < HPAGE_PMD_NR; i++)
@@ -3539,6 +3539,8 @@ int split_huge_page_to_list(struct page
 			pgdata->split_queue_len--;
 			list_del(page_deferred_list(head));
 		}
+		if (mapping)
+			__dec_zone_page_state(page, NR_SHMEM_THPS);
 		spin_unlock(&pgdata->split_queue_lock);
 		__split_huge_page(page, list, flags);
 		ret = 0;
diff -puN mm/page_alloc.c~mm-rmap-account-shmem-thp-pages mm/page_alloc.c
--- a/mm/page_alloc.c~mm-rmap-account-shmem-thp-pages
+++ a/mm/page_alloc.c
@@ -4312,6 +4312,9 @@ void show_free_areas(unsigned int filter
 		" unevictable:%lu dirty:%lu writeback:%lu unstable:%lu\n"
 		" slab_reclaimable:%lu slab_unreclaimable:%lu\n"
 		" mapped:%lu shmem:%lu pagetables:%lu bounce:%lu\n"
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+		" anon_thp: %lu shmem_thp: %lu shmem_pmdmapped: %lu\n"
+#endif
 		" free:%lu free_pcp:%lu free_cma:%lu\n",
 		global_page_state(NR_ACTIVE_ANON),
 		global_page_state(NR_INACTIVE_ANON),
@@ -4329,6 +4332,11 @@ void show_free_areas(unsigned int filter
 		global_page_state(NR_SHMEM),
 		global_page_state(NR_PAGETABLE),
 		global_page_state(NR_BOUNCE),
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+		global_page_state(NR_ANON_THPS) * HPAGE_PMD_NR,
+		global_page_state(NR_SHMEM_THPS) * HPAGE_PMD_NR,
+		global_page_state(NR_SHMEM_PMDMAPPED) * HPAGE_PMD_NR,
+#endif
 		global_page_state(NR_FREE_PAGES),
 		free_pcp,
 		global_page_state(NR_FREE_CMA_PAGES));
@@ -4363,6 +4371,11 @@ void show_free_areas(unsigned int filter
 			" writeback:%lukB"
 			" mapped:%lukB"
 			" shmem:%lukB"
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+			" shmem_thp: %lukB"
+			" shmem_pmdmapped: %lukB"
+			" anon_thp: %lukB"
+#endif
 			" slab_reclaimable:%lukB"
 			" slab_unreclaimable:%lukB"
 			" kernel_stack:%lukB"
@@ -4395,6 +4408,12 @@ void show_free_areas(unsigned int filter
 			K(zone_page_state(zone, NR_WRITEBACK)),
 			K(zone_page_state(zone, NR_FILE_MAPPED)),
 			K(zone_page_state(zone, NR_SHMEM)),
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+			K(zone_page_state(zone, NR_SHMEM_THPS) * HPAGE_PMD_NR),
+			K(zone_page_state(zone, NR_SHMEM_PMDMAPPED)
+					* HPAGE_PMD_NR),
+			K(zone_page_state(zone, NR_ANON_THPS) * HPAGE_PMD_NR),
+#endif
 			K(zone_page_state(zone, NR_SLAB_RECLAIMABLE)),
 			K(zone_page_state(zone, NR_SLAB_UNRECLAIMABLE)),
 			zone_page_state(zone, NR_KERNEL_STACK) *
diff -puN mm/rmap.c~mm-rmap-account-shmem-thp-pages mm/rmap.c
--- a/mm/rmap.c~mm-rmap-account-shmem-thp-pages
+++ a/mm/rmap.c
@@ -1212,10 +1212,8 @@ void do_page_add_anon_rmap(struct page *
 		 * pte lock(a spinlock) is held, which implies preemption
 		 * disabled.
 		 */
-		if (compound) {
-			__inc_zone_page_state(page,
-					      NR_ANON_TRANSPARENT_HUGEPAGES);
-		}
+		if (compound)
+			__inc_zone_page_state(page, NR_ANON_THPS);
 		__mod_zone_page_state(page_zone(page), NR_ANON_PAGES, nr);
 	}
 	if (unlikely(PageKsm(page)))
@@ -1253,7 +1251,7 @@ void page_add_new_anon_rmap(struct page
 		VM_BUG_ON_PAGE(!PageTransHuge(page), page);
 		/* increment count (starts at -1) */
 		atomic_set(compound_mapcount_ptr(page), 0);
-		__inc_zone_page_state(page, NR_ANON_TRANSPARENT_HUGEPAGES);
+		__inc_zone_page_state(page, NR_ANON_THPS);
 	} else {
 		/* Anon THP always mapped first with PMD */
 		VM_BUG_ON_PAGE(PageTransCompound(page), page);
@@ -1283,6 +1281,8 @@ void page_add_file_rmap(struct page *pag
 		}
 		if (!atomic_inc_and_test(compound_mapcount_ptr(page)))
 			goto out;
+		VM_BUG_ON_PAGE(!PageSwapBacked(page), page);
+		__inc_zone_page_state(page, NR_SHMEM_PMDMAPPED);
 	} else {
 		if (PageTransCompound(page)) {
 			VM_BUG_ON_PAGE(!PageLocked(page), page);
@@ -1321,6 +1321,8 @@ static void page_remove_file_rmap(struct
 		}
 		if (!atomic_add_negative(-1, compound_mapcount_ptr(page)))
 			goto out;
+		VM_BUG_ON_PAGE(!PageSwapBacked(page), page);
+		__dec_zone_page_state(page, NR_SHMEM_PMDMAPPED);
 	} else {
 		if (!atomic_add_negative(-1, &page->_mapcount))
 			goto out;
@@ -1354,7 +1356,7 @@ static void page_remove_anon_compound_rm
 	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
 		return;
 
-	__dec_zone_page_state(page, NR_ANON_TRANSPARENT_HUGEPAGES);
+	__dec_zone_page_state(page, NR_ANON_THPS);
 
 	if (TestClearPageDoubleMap(page)) {
 		/*
diff -puN mm/vmstat.c~mm-rmap-account-shmem-thp-pages mm/vmstat.c
--- a/mm/vmstat.c~mm-rmap-account-shmem-thp-pages
+++ a/mm/vmstat.c
@@ -733,6 +733,8 @@ const char * const vmstat_text[] = {
 	"workingset_activate",
 	"workingset_nodereclaim",
 	"nr_anon_transparent_hugepages",
+	"nr_shmem_hugepages",
+	"nr_shmem_pmdmapped",
 	"nr_free_cma",
 
 	/* enum writeback_stat_item counters */
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are


