From: akpm@linux-foundation.org
Subject: + mm-introduce-pagehuge-for-testing-huge-gigantic-pages.patch added to -mm tree
Date: Tue, 28 Apr 2009 14:32:57 -0700
Message-ID: <200904282132.n3SLWvSm022760@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40959 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754158AbZD1Vhc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Apr 2009 17:37:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, adobriyan@gmail.com, andi@firstfloor.org, kosaki.motohiro@jp.fujitsu.com, mpm@selenic.com


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

Introduce PageHuge(), which identifies huge/gigantic pages by their
dedicated compound destructor functions.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   24 ++++++++++++++++++++++++
 mm/hugetlb.c       |    2 +-
 mm/page_alloc.c    |   11 ++++++++++-
 3 files changed, 35 insertions(+), 2 deletions(-)

diff -puN include/linux/mm.h~mm-introduce-pagehuge-for-testing-huge-gigantic-pages include/linux/mm.h
--- a/include/linux/mm.h~mm-introduce-pagehuge-for-testing-huge-gigantic-pages
+++ a/include/linux/mm.h
@@ -354,6 +354,30 @@ static inline void set_compound_order(st
 	page[1].lru.prev = (void *)order;
 }
 
+#ifdef CONFIG_HUGETLBFS
+void free_huge_page(struct page *page);
+void free_gigantic_page(struct page *page);
+
+static inline int PageHuge(struct page *page)
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
@@ -550,7 +550,7 @@ struct hstate *size_to_hstate(unsigned l
 	return NULL;
 }
 
-static void free_huge_page(struct page *page)
+void free_huge_page(struct page *page)
 {
 	/*
 	 * Can't pass hstate in here because it is called from the
diff -puN mm/page_alloc.c~mm-introduce-pagehuge-for-testing-huge-gigantic-pages mm/page_alloc.c
--- a/mm/page_alloc.c~mm-introduce-pagehuge-for-testing-huge-gigantic-pages
+++ a/mm/page_alloc.c
@@ -305,13 +305,22 @@ void prep_compound_page(struct page *pag
 }
 
 #ifdef CONFIG_HUGETLBFS
+/*
+ * This (duplicated) destructor function distinguishes gigantic pages from
+ * normal compound pages.
+ */
+void free_gigantic_page(struct page *page)
+{
+	__free_pages_ok(page, compound_order(page));
+}
+
 void prep_compound_gigantic_page(struct page *page, unsigned long order)
 {
 	int i;
 	int nr_pages = 1 << order;
 	struct page *p = page + 1;
 
-	set_compound_page_dtor(page, free_compound_page);
+	set_compound_page_dtor(page, free_gigantic_page);
 	set_compound_order(page, order);
 	__SetPageHead(page);
 	for (i = 1; i < nr_pages; i++, p = mem_map_next(p, page, i)) {
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

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
pagemap-document-clarifications.patch
pagemap-documentation-9-more-exported-page-flags.patch
mm-introduce-pagehuge-for-testing-huge-gigantic-pages.patch
proc-kpagecount-kpageflags-code-cleanup.patch
proc-export-more-page-flags-in-proc-kpageflags.patch

