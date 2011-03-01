From: akpm@linux-foundation.org
Subject: + ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages.patch added to -mm tree
Date: Tue, 01 Mar 2011 15:41:06 -0800
Message-ID: <201103012341.p21Nf64e006469@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43406 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756866Ab1CAXlW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Mar 2011 18:41:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nai.xia@gmail.com, aarcange@redhat.com, chrisw@sous-sol.org, hugh.dickins@tiscali.co.uk, ieidus@redhat.com, riel@redhat.com


The patch titled
     ksm: add vm_stat and meminfo entry to reflect pte mapping to ksm pages
has been added to the -mm tree.  Its filename is
     ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages.patch

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
Subject: ksm: add vm_stat and meminfo entry to reflect pte mapping to ksm pages
From: Nai Xia <nai.xia@gmail.com>

ksm_pages_sharing is updated by ksmd periodically.  In some cases, it
cannot reflect the actual savings and makes the benchmarks on volatile
VMAs very inaccurate.

This patch adds a vm_stat entry and lets the /proc/meminfo show
information about how much virutal address pte is being mapped to ksm
pages.  With default ksm paramters (pages_to_scan==100 &&
sleep_millisecs==20), this can result in 50% more accurate averaged
savings result for the following test program.  Bigger sleep_millisecs
values will increase this deviation.

/*
 * This test program triggers frequent faults on merged ksm pages but 
 * still keeps the faulted pages mergeable.
 */

#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <unistd.h>
#include <sys/mman.h>

#define MADV_MERGEABLE   12
#define MADV_UNMERGEABLE 13


#define SIZE (1000*1024*1024)
#define SEED	1
#define PAGE_SIZE 4096

int main(int argc, char **argv)
{
	char *p;
	int j;
	long feed = 1, new_feed, tmp;
	unsigned int offset;
	int status;
	int ret;

	pid_t child;

	child = fork();

	p = mmap(NULL, SIZE, PROT_WRITE|PROT_READ, 
		 MAP_PRIVATE|MAP_ANONYMOUS, 0, 0);
    	if (p == MAP_FAILED) {
    		printf("mmap error\n");
    		return 0;
    	}

	ret = madvise(p, SIZE, MADV_MERGEABLE);

	if (ret==-1) {
		printf("madvise failed \n");
		return 0;
	}

	memset(p, feed, SIZE);

	while (1) {
		for (j=0; j<SIZE; j+= PAGE_SIZE) {
			    p[j] *= p[j]*1;
		}
	}

	return 0;
}

Some of the patch lines removes trailing spaces in related files.

Signed-off-by: Nai Xia <nai.xia@gmail.com>
Cc: Izik Eidus <ieidus@redhat.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/meminfo.c      |    6 ++++++
 include/linux/mmzone.h |    7 +++++--
 mm/ksm.c               |    5 +++++
 mm/memory.c            |    4 +++-
 mm/rmap.c              |   11 ++++++++---
 5 files changed, 27 insertions(+), 6 deletions(-)

diff -puN fs/proc/meminfo.c~ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages fs/proc/meminfo.c
--- a/fs/proc/meminfo.c~ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages
+++ a/fs/proc/meminfo.c
@@ -87,6 +87,9 @@ static int meminfo_proc_show(struct seq_
 		"SUnreclaim:     %8lu kB\n"
 		"KernelStack:    %8lu kB\n"
 		"PageTables:     %8lu kB\n"
+#ifdef CONFIG_KSM
+		"KsmSharing:     %8lu kB\n"
+#endif
 #ifdef CONFIG_QUICKLIST
 		"Quicklists:     %8lu kB\n"
 #endif
@@ -145,6 +148,9 @@ static int meminfo_proc_show(struct seq_
 		K(global_page_state(NR_SLAB_UNRECLAIMABLE)),
 		global_page_state(NR_KERNEL_STACK) * THREAD_SIZE / 1024,
 		K(global_page_state(NR_PAGETABLE)),
+#ifdef CONFIG_KSM
+		K(global_page_state(NR_KSM_PAGES_SHARING)),
+#endif
 #ifdef CONFIG_QUICKLIST
 		K(quicklist_total_size()),
 #endif
diff -puN include/linux/mmzone.h~ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages include/linux/mmzone.h
--- a/include/linux/mmzone.h~ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages
+++ a/include/linux/mmzone.h
@@ -115,6 +115,9 @@ enum zone_stat_item {
 	NUMA_OTHER,		/* allocation from other node */
 #endif
 	NR_ANON_TRANSPARENT_HUGEPAGES,
+#ifdef CONFIG_KSM
+	NR_KSM_PAGES_SHARING,
+#endif
 	NR_VM_ZONE_STAT_ITEMS };
 
 /*
@@ -344,7 +347,7 @@ struct zone {
 	ZONE_PADDING(_pad1_)
 
 	/* Fields commonly accessed by the page reclaim scanner */
-	spinlock_t		lru_lock;	
+	spinlock_t		lru_lock;
 	struct zone_lru {
 		struct list_head list;
 	} lru[NR_LRU_LISTS];
@@ -722,7 +725,7 @@ static inline int is_normal_idx(enum zon
 }
 
 /**
- * is_highmem - helper function to quickly check if a struct zone is a 
+ * is_highmem - helper function to quickly check if a struct zone is a
  *              highmem zone or not.  This is an attempt to keep references
  *              to ZONE_{DMA/NORMAL/HIGHMEM/etc} in general code to a minimum.
  * @zone - pointer to struct zone variable
diff -puN mm/ksm.c~ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages mm/ksm.c
--- a/mm/ksm.c~ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages
+++ a/mm/ksm.c
@@ -883,6 +883,7 @@ static int try_to_merge_one_page(struct 
 	 */
 	if (write_protect_page(vma, page, &orig_pte) == 0) {
 		if (!kpage) {
+			long mapcount = page_mapcount(page);
 			/*
 			 * While we hold page lock, upgrade page from
 			 * PageAnon+anon_vma to PageKsm+NULL stable_node:
@@ -890,6 +891,10 @@ static int try_to_merge_one_page(struct 
 			 */
 			set_page_stable_node(page, NULL);
 			mark_page_accessed(page);
+			if (mapcount)
+				add_zone_page_state(page_zone(page),
+						    NR_KSM_PAGES_SHARING,
+						    mapcount);
 			err = 0;
 		} else if (pages_identical(page, kpage))
 			err = replace_page(vma, page, kpage, orig_pte);
diff -puN mm/memory.c~ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages mm/memory.c
--- a/mm/memory.c~ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages
+++ a/mm/memory.c
@@ -719,6 +719,8 @@ copy_one_pte(struct mm_struct *dst_mm, s
 			rss[MM_ANONPAGES]++;
 		else
 			rss[MM_FILEPAGES]++;
+		if (PageKsm(page)) /* follows page_dup_rmap() */
+			inc_zone_page_state(page, NR_KSM_PAGES_SHARING);
 	}
 
 out_set_pte:
@@ -1472,7 +1474,7 @@ int __get_user_pages(struct task_struct 
 
 	VM_BUG_ON(!!pages != !!(gup_flags & FOLL_GET));
 
-	/* 
+	/*
 	 * Require read or write permissions.
 	 * If FOLL_FORCE is set, we only require the "MAY" flags.
 	 */
diff -puN mm/rmap.c~ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages mm/rmap.c
--- a/mm/rmap.c~ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages
+++ a/mm/rmap.c
@@ -805,9 +805,9 @@ void page_move_anon_rmap(struct page *pa
 
 /**
  * __page_set_anon_rmap - set up new anonymous rmap
- * @page:	Page to add to rmap	
+ * @page:	Page to add to rmap
  * @vma:	VM area to add page to.
- * @address:	User virtual address of the mapping	
+ * @address:	User virtual address of the mapping
  * @exclusive:	the page is exclusively owned by the current process
  */
 static void __page_set_anon_rmap(struct page *page,
@@ -893,8 +893,10 @@ void do_page_add_anon_rmap(struct page *
 			__inc_zone_page_state(page,
 					      NR_ANON_TRANSPARENT_HUGEPAGES);
 	}
-	if (unlikely(PageKsm(page)))
+	if (unlikely(PageKsm(page))) {
+		__inc_zone_page_state(page, NR_KSM_PAGES_SHARING);
 		return;
+	}
 
 	VM_BUG_ON(!PageLocked(page));
 	VM_BUG_ON(address < vma->vm_start || address >= vma->vm_end);
@@ -953,6 +955,9 @@ void page_add_file_rmap(struct page *pag
  */
 void page_remove_rmap(struct page *page)
 {
+	if (PageKsm(page))
+		__dec_zone_page_state(page, NR_KSM_PAGES_SHARING);
+
 	/* page still mapped by someone else? */
 	if (!atomic_add_negative(-1, &page->_mapcount))
 		return;
_

Patches currently in -mm which might be from nai.xia@gmail.com are

ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages.patch

