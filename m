From: akpm@linux-foundation.org
Subject: + mm-introduce-pagehuge-for-testing-huge-gigantic-pages.patch added to -mm tree
Date: Fri, 08 May 2009 13:40:39 -0700
Message-ID: <200905082040.n48Kednl010358@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57193 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755875AbZEHUpj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 May 2009 16:45:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, adobriyan@gmail.com, andi@firstfloor.org, kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu, mpm@selenic.com


The patch titled
     mm: introduce PageHuge() for testing huge/gigantic pages
has been added to the -mm tree.  Its filename is
     mm-introduce-pagehuge-for-testing-huge-gigantic-pages.patch

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
Subject: mm: introduce PageHuge() for testing huge/gigantic pages
From: Wu Fengguang <fengguang.wu@intel.com>

A series of patches to enhance the /proc/pagemap interface and to add a
userspace executable which can be used to present the pagemap data.

Export 10 more flags to end users (and more for kernel developers):

        11. KPF_MMAP            (pseudo flag) memory mapped page
        12. KPF_ANON            (pseudo flag) memory mapped page (anonymous)
        13. KPF_SWAPCACHE       page is in swap cache
        14. KPF_SWAPBACKED      page is swap/RAM backed
        15. KPF_COMPOUND_HEAD   (*)
        16. KPF_COMPOUND_TAIL   (*)
        17. KPF_HUGE		hugeTLB pages
        18. KPF_UNEVICTABLE     page is in the unevictable LRU list
        19. KPF_HWPOISON        hardware detected corruption
        20. KPF_NOPAGE          (pseudo flag) no page frame at the address

        (*) For compound pages, exporting _both_ head/tail info enables
            users to tell where a compound page starts/ends, and its order.


a simple demo of the page-types tool

# ./page-types -h
page-types [options]
            -r|--raw                  Raw mode, for kernel developers
            -a|--addr    addr-spec    Walk a range of pages
            -b|--bits    bits-spec    Walk pages with specified bits
            -l|--list                 Show page details in ranges
            -L|--list-each            Show page details one by one
            -N|--no-summary           Don't show summay info
            -h|--help                 Show this usage message
addr-spec:
            N                         one page at offset N (unit: pages)
            N+M                       pages range from N to N+M-1
            N,M                       pages range from N to M-1
            N,                        pages range from N to end
            ,M                        pages range from 0 to M
bits-spec:
            bit1,bit2                 (flags & (bit1|bit2)) != 0
            bit1,bit2=bit1            (flags & (bit1|bit2)) == bit1
            bit1,~bit2                (flags & (bit1|bit2)) == bit1
            =bit1,bit2                flags == (bit1|bit2)
bit-names:
          locked              error         referenced           uptodate   
           dirty                lru             active               slab   
       writeback            reclaim              buddy               mmap   
       anonymous          swapcache         swapbacked      compound_head   
   compound_tail               huge        unevictable           hwpoison   
          nopage           reserved(r)         mlocked(r)    mappedtodisk(r)
         private(r)       private_2(r)   owner_private(r)            arch(r)
        uncached(r)       readahead(o)       slob_free(o)     slub_frozen(o)
      slub_debug(o)
                                   (r) raw mode bits  (o) overloaded bits


# ./page-types
             flags      page-count       MB  symbolic-flags                     long-symbolic-flags
0x0000000000000000          487369     1903  _________________________________
0x0000000000000014               5        0  __R_D____________________________  referenced,dirty
0x0000000000000020               1        0  _____l___________________________  lru
0x0000000000000024              34        0  __R__l___________________________  referenced,lru
0x0000000000000028            3838       14  ___U_l___________________________  uptodate,lru
0x0001000000000028              48        0  ___U_l_______________________I___  uptodate,lru,readahead
0x000000000000002c            6478       25  __RU_l___________________________  referenced,uptodate,lru
0x000100000000002c              47        0  __RU_l_______________________I___  referenced,uptodate,lru,readahead
0x0000000000000040            8344       32  ______A__________________________  active
0x0000000000000060               1        0  _____lA__________________________  lru,active
0x0000000000000068             348        1  ___U_lA__________________________  uptodate,lru,active
0x0001000000000068              12        0  ___U_lA______________________I___  uptodate,lru,active,readahead
0x000000000000006c             988        3  __RU_lA__________________________  referenced,uptodate,lru,active
0x000100000000006c              48        0  __RU_lA______________________I___  referenced,uptodate,lru,active,readahead
0x0000000000004078               1        0  ___UDlA_______b__________________  uptodate,dirty,lru,active,swapbacked
0x000000000000407c              34        0  __RUDlA_______b__________________  referenced,uptodate,dirty,lru,active,swapbacked
0x0000000000000400             503        1  __________B______________________  buddy
0x0000000000000804               1        0  __R________M_____________________  referenced,mmap
0x0000000000000828            1029        4  ___U_l_____M_____________________  uptodate,lru,mmap
0x0001000000000828              43        0  ___U_l_____M_________________I___  uptodate,lru,mmap,readahead
0x000000000000082c             382        1  __RU_l_____M_____________________  referenced,uptodate,lru,mmap
0x000100000000082c              12        0  __RU_l_____M_________________I___  referenced,uptodate,lru,mmap,readahead
0x0000000000000868             192        0  ___U_lA____M_____________________  uptodate,lru,active,mmap
0x0001000000000868              12        0  ___U_lA____M_________________I___  uptodate,lru,active,mmap,readahead
0x000000000000086c             800        3  __RU_lA____M_____________________  referenced,uptodate,lru,active,mmap
0x000100000000086c              31        0  __RU_lA____M_________________I___  referenced,uptodate,lru,active,mmap,readahead
0x0000000000004878               2        0  ___UDlA____M__b__________________  uptodate,dirty,lru,active,mmap,swapbacked
0x0000000000001000             492        1  ____________a____________________  anonymous
0x0000000000005808               4        0  ___U_______Ma_b__________________  uptodate,mmap,anonymous,swapbacked
0x0000000000005868            2839       11  ___U_lA____Ma_b__________________  uptodate,lru,active,mmap,anonymous,swapbacked
0x000000000000586c              30        0  __RU_lA____Ma_b__________________  referenced,uptodate,lru,active,mmap,anonymous,swapbacked
             total          513968     2007


# ./page-types -r
             flags      page-count       MB  symbolic-flags                     long-symbolic-flags
0x0000000000000000          468002     1828  _________________________________
0x0000000100000000           19102       74  _____________________r___________  reserved
0x0000000000008000              41        0  _______________H_________________  compound_head
0x0000000000010000             188        0  ________________T________________  compound_tail
0x0000000000008014               1        0  __R_D__________H_________________  referenced,dirty,compound_head
0x0000000000010014               4        0  __R_D___________T________________  referenced,dirty,compound_tail
0x0000000000000020               1        0  _____l___________________________  lru
0x0000000800000024              34        0  __R__l__________________P________  referenced,lru,private
0x0000000000000028            3794       14  ___U_l___________________________  uptodate,lru
0x0001000000000028              46        0  ___U_l_______________________I___  uptodate,lru,readahead
0x0000000400000028              44        0  ___U_l_________________d_________  uptodate,lru,mappedtodisk
0x0001000400000028               2        0  ___U_l_________________d_____I___  uptodate,lru,mappedtodisk,readahead
0x000000000000002c            6434       25  __RU_l___________________________  referenced,uptodate,lru
0x000100000000002c              47        0  __RU_l_______________________I___  referenced,uptodate,lru,readahead
0x000000040000002c              14        0  __RU_l_________________d_________  referenced,uptodate,lru,mappedtodisk
0x000000080000002c              30        0  __RU_l__________________P________  referenced,uptodate,lru,private
0x0000000800000040            8124       31  ______A_________________P________  active,private
0x0000000000000040             219        0  ______A__________________________  active
0x0000000800000060               1        0  _____lA_________________P________  lru,active,private
0x0000000000000068             322        1  ___U_lA__________________________  uptodate,lru,active
0x0001000000000068              12        0  ___U_lA______________________I___  uptodate,lru,active,readahead
0x0000000400000068              13        0  ___U_lA________________d_________  uptodate,lru,active,mappedtodisk
0x0000000800000068              12        0  ___U_lA_________________P________  uptodate,lru,active,private
0x000000000000006c             977        3  __RU_lA__________________________  referenced,uptodate,lru,active
0x000100000000006c              48        0  __RU_lA______________________I___  referenced,uptodate,lru,active,readahead
0x000000040000006c               5        0  __RU_lA________________d_________  referenced,uptodate,lru,active,mappedtodisk
0x000000080000006c               3        0  __RU_lA_________________P________  referenced,uptodate,lru,active,private
0x0000000c0000006c               3        0  __RU_lA________________dP________  referenced,uptodate,lru,active,mappedtodisk,private
0x0000000c00000068               1        0  ___U_lA________________dP________  uptodate,lru,active,mappedtodisk,private
0x0000000000004078               1        0  ___UDlA_______b__________________  uptodate,dirty,lru,active,swapbacked
0x000000000000407c              34        0  __RUDlA_______b__________________  referenced,uptodate,dirty,lru,active,swapbacked
0x0000000000000400             538        2  __________B______________________  buddy
0x0000000000000804               1        0  __R________M_____________________  referenced,mmap
0x0000000000000828            1029        4  ___U_l_____M_____________________  uptodate,lru,mmap
0x0001000000000828              43        0  ___U_l_____M_________________I___  uptodate,lru,mmap,readahead
0x000000000000082c             382        1  __RU_l_____M_____________________  referenced,uptodate,lru,mmap
0x000100000000082c              12        0  __RU_l_____M_________________I___  referenced,uptodate,lru,mmap,readahead
0x0000000000000868             192        0  ___U_lA____M_____________________  uptodate,lru,active,mmap
0x0001000000000868              12        0  ___U_lA____M_________________I___  uptodate,lru,active,mmap,readahead
0x000000000000086c             800        3  __RU_lA____M_____________________  referenced,uptodate,lru,active,mmap
0x000100000000086c              31        0  __RU_lA____M_________________I___  referenced,uptodate,lru,active,mmap,readahead
0x0000000000004878               2        0  ___UDlA____M__b__________________  uptodate,dirty,lru,active,mmap,swapbacked
0x0000000000001000             492        1  ____________a____________________  anonymous
0x0000000000005008               2        0  ___U________a_b__________________  uptodate,anonymous,swapbacked
0x0000000000005808               4        0  ___U_______Ma_b__________________  uptodate,mmap,anonymous,swapbacked
0x000000000000580c               1        0  __RU_______Ma_b__________________  referenced,uptodate,mmap,anonymous,swapbacked
0x0000000000005868            2839       11  ___U_lA____Ma_b__________________  uptodate,lru,active,mmap,anonymous,swapbacked
0x000000000000586c              29        0  __RU_lA____Ma_b__________________  referenced,uptodate,lru,active,mmap,anonymous,swapbacked
             total          513968     2007


# ./page-types --raw --list --no-summary --bits reserved
offset  count   flags
0       15      _____________________r___________
31      4       _____________________r___________
159     97      _____________________r___________
4096    2067    _____________________r___________
6752    2390    _____________________r___________
9355    3       _____________________r___________
9728    14526   _____________________r___________



This patch:

Introduce PageHuge(), which identifies huge/gigantic pages by their
dedicated compound destructor functions.

Also move prep_compound_gigantic_page() to hugetlb.c and make
__free_pages_ok() non-static.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    9 +++
 mm/hugetlb.c       |   98 ++++++++++++++++++++++++++++---------------
 mm/internal.h      |    6 +-
 mm/page_alloc.c    |   21 ---------
 4 files changed, 79 insertions(+), 55 deletions(-)

diff -puN include/linux/mm.h~mm-introduce-pagehuge-for-testing-huge-gigantic-pages include/linux/mm.h
--- a/include/linux/mm.h~mm-introduce-pagehuge-for-testing-huge-gigantic-pages
+++ a/include/linux/mm.h
@@ -355,6 +355,15 @@ static inline void set_compound_order(st
 	page[1].lru.prev = (void *)order;
 }
 
+#ifdef CONFIG_HUGETLBFS
+int PageHuge(struct page *page);
+#else
+static inline int PageHuge(struct page *page)
+{
+	return 0;
+}
+#endif
+
 /*
  * Multiple processes may "see" the same page. E.g. for untouched
  * mappings of /dev/null, all processes see the same page full of
diff -puN mm/hugetlb.c~mm-introduce-pagehuge-for-testing-huge-gigantic-pages mm/hugetlb.c
--- a/mm/hugetlb.c~mm-introduce-pagehuge-for-testing-huge-gigantic-pages
+++ a/mm/hugetlb.c
@@ -578,39 +578,9 @@ static void free_huge_page(struct page *
 		hugetlb_put_quota(mapping, 1);
 }
 
-/*
- * Increment or decrement surplus_huge_pages.  Keep node-specific counters
- * balanced by operating on them in a round-robin fashion.
- * Returns 1 if an adjustment was made.
- */
-static int adjust_pool_surplus(struct hstate *h, int delta)
+static void free_gigantic_page(struct page *page)
 {
-	static int prev_nid;
-	int nid = prev_nid;
-	int ret = 0;
-
-	VM_BUG_ON(delta != -1 && delta != 1);
-	do {
-		nid = next_node(nid, node_online_map);
-		if (nid == MAX_NUMNODES)
-			nid = first_node(node_online_map);
-
-		/* To shrink on this node, there must be a surplus page */
-		if (delta < 0 && !h->surplus_huge_pages_node[nid])
-			continue;
-		/* Surplus cannot exceed the total number of pages */
-		if (delta > 0 && h->surplus_huge_pages_node[nid] >=
-						h->nr_huge_pages_node[nid])
-			continue;
-
-		h->surplus_huge_pages += delta;
-		h->surplus_huge_pages_node[nid] += delta;
-		ret = 1;
-		break;
-	} while (nid != prev_nid);
-
-	prev_nid = nid;
-	return ret;
+	__free_pages_ok(page, compound_order(page));
 }
 
 static void prep_new_huge_page(struct hstate *h, struct page *page, int nid)
@@ -623,6 +593,35 @@ static void prep_new_huge_page(struct hs
 	put_page(page); /* free it into the hugepage allocator */
 }
 
+static void prep_compound_gigantic_page(struct page *page, unsigned long order)
+{
+	int i;
+	int nr_pages = 1 << order;
+	struct page *p = page + 1;
+
+	set_compound_page_dtor(page, free_gigantic_page);
+	set_compound_order(page, order);
+	__SetPageHead(page);
+	for (i = 1; i < nr_pages; i++, p = mem_map_next(p, page, i)) {
+		__SetPageTail(p);
+		p->first_page = page;
+	}
+}
+
+int PageHuge(struct page *page)
+{
+	compound_page_dtor *dtor;
+
+	if (!PageCompound(page))
+		return 0;
+
+	page = compound_head(page);
+	dtor = get_compound_page_dtor(page);
+
+	return  dtor == free_huge_page ||
+		dtor == free_gigantic_page;
+}
+
 static struct page *alloc_fresh_huge_page_node(struct hstate *h, int nid)
 {
 	struct page *page;
@@ -1140,6 +1139,41 @@ static inline void try_to_free_low(struc
 }
 #endif
 
+/*
+ * Increment or decrement surplus_huge_pages.  Keep node-specific counters
+ * balanced by operating on them in a round-robin fashion.
+ * Returns 1 if an adjustment was made.
+ */
+static int adjust_pool_surplus(struct hstate *h, int delta)
+{
+	static int prev_nid;
+	int nid = prev_nid;
+	int ret = 0;
+
+	VM_BUG_ON(delta != -1 && delta != 1);
+	do {
+		nid = next_node(nid, node_online_map);
+		if (nid == MAX_NUMNODES)
+			nid = first_node(node_online_map);
+
+		/* To shrink on this node, there must be a surplus page */
+		if (delta < 0 && !h->surplus_huge_pages_node[nid])
+			continue;
+		/* Surplus cannot exceed the total number of pages */
+		if (delta > 0 && h->surplus_huge_pages_node[nid] >=
+						h->nr_huge_pages_node[nid])
+			continue;
+
+		h->surplus_huge_pages += delta;
+		h->surplus_huge_pages_node[nid] += delta;
+		ret = 1;
+		break;
+	} while (nid != prev_nid);
+
+	prev_nid = nid;
+	return ret;
+}
+
 #define persistent_huge_pages(h) (h->nr_huge_pages - h->surplus_huge_pages)
 static unsigned long set_max_huge_pages(struct hstate *h, unsigned long count)
 {
diff -puN mm/internal.h~mm-introduce-pagehuge-for-testing-huge-gigantic-pages mm/internal.h
--- a/mm/internal.h~mm-introduce-pagehuge-for-testing-huge-gigantic-pages
+++ a/mm/internal.h
@@ -16,9 +16,6 @@
 void free_pgtables(struct mmu_gather *tlb, struct vm_area_struct *start_vma,
 		unsigned long floor, unsigned long ceiling);
 
-extern void prep_compound_page(struct page *page, unsigned long order);
-extern void prep_compound_gigantic_page(struct page *page, unsigned long order);
-
 static inline void set_page_count(struct page *page, int v)
 {
 	atomic_set(&page->_count, v);
@@ -51,6 +48,9 @@ extern void putback_lru_page(struct page
  */
 extern unsigned long highest_memmap_pfn;
 extern void __free_pages_bootmem(struct page *page, unsigned int order);
+extern void __free_pages_ok(struct page *page, unsigned int order);
+extern void prep_compound_page(struct page *page, unsigned long order);
+
 
 /*
  * function for dealing with page's order in buddy system.
diff -puN mm/page_alloc.c~mm-introduce-pagehuge-for-testing-huge-gigantic-pages mm/page_alloc.c
--- a/mm/page_alloc.c~mm-introduce-pagehuge-for-testing-huge-gigantic-pages
+++ a/mm/page_alloc.c
@@ -77,8 +77,6 @@ int percpu_pagelist_fraction;
 int pageblock_order __read_mostly;
 #endif
 
-static void __free_pages_ok(struct page *page, unsigned int order);
-
 /*
  * results with 256, 32 in the lowmem_reserve sysctl:
  *	1G machine -> (16M dma, 800M-16M normal, 1G-800M high)
@@ -304,23 +302,6 @@ void prep_compound_page(struct page *pag
 	}
 }
 
-#ifdef CONFIG_HUGETLBFS
-void prep_compound_gigantic_page(struct page *page, unsigned long order)
-{
-	int i;
-	int nr_pages = 1 << order;
-	struct page *p = page + 1;
-
-	set_compound_page_dtor(page, free_compound_page);
-	set_compound_order(page, order);
-	__SetPageHead(page);
-	for (i = 1; i < nr_pages; i++, p = mem_map_next(p, page, i)) {
-		__SetPageTail(p);
-		p->first_page = page;
-	}
-}
-#endif
-
 static int destroy_compound_page(struct page *page, unsigned long order)
 {
 	int i;
@@ -570,7 +551,7 @@ static void free_one_page(struct zone *z
 	spin_unlock(&zone->lock);
 }
 
-static void __free_pages_ok(struct page *page, unsigned int order)
+void __free_pages_ok(struct page *page, unsigned int order)
 {
 	unsigned long flags;
 	int i;
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
linux-next.patch
readahead-make-mmap_miss-an-unsigned-int.patch
readahead-move-max_sane_readahead-calls-into-force_page_cache_readahead.patch
readahead-apply-max_sane_readahead-limit-in-ondemand_readahead.patch
readahead-remove-one-unnecessary-radix-tree-lookup.patch
readahead-increase-interleaved-readahead-size.patch
readahead-remove-sync-async-readahead-call-dependency.patch
readahead-clean-up-and-simplify-the-code-for-filemap-page-fault-readahead.patch
readahead-sequential-mmap-readahead.patch
readahead-enforce-full-readahead-size-on-async-mmap-readahead.patch
readahead-record-mmap-read-around-states-in-file_ra_state.patch
radix-tree-add-radix_tree_prev_hole.patch
readahead-move-the-random-read-case-to-bottom.patch
readahead-introduce-context-readahead-algorithm.patch
readahead-introduce-context-readahead-algorithm-update.patch
readahead-remove-redundant-test-in-shrink_readahead_size_eio.patch
readahead-enforce-full-sync-mmap-readahead-size.patch
mm-introduce-pagehuge-for-testing-huge-gigantic-pages.patch
slob-use-pg_slab-for-identifying-slob-pages.patch
proc-kpagecount-kpageflags-code-cleanup.patch
proc-export-more-page-flags-in-proc-kpageflags.patch
pagemap-document-clarifications.patch
pagemap-document-9-more-exported-page-flags.patch
pagemap-add-page-types-tool.patch
pagemap-export-pg_hwpoison.patch
vmscan-cleanup-the-scan-batching-code.patch
vmscan-dont-export-nr_saved_scan-in-proc-zoneinfo.patch
vmscan-zvc-updates-in-shrink_active_list-can-be-done-once.patch
inotify-reimplement-inotify-using-fsnotify-report-rounded-up-event-size-to-user-space.patch

