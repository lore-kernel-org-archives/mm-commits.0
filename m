From: akpm@linux-foundation.org
Subject: [merged] mm-methods-for-teaching-filesystems-about-pg_swapcache-pages.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:16:53 -0700
Message-ID: <20120801201654.5DD735C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:52821 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237Ab2HAUQ6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:16:58 -0400
Received: by lbbgp10 with SMTP id gp10so47421lbb.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:16:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, Trond.Myklebust@netapp.com, a.p.zijlstra@chello.nl, davem@davemloft.net, dfeng@redhat.com, emunson@mgebm.net, eparis@redhat.com, hch@infradead.org, jmorris@namei.org, michaelc@cs.wisc.edu, neilb@suse.de, riel@redhat.com, sebastian@breakpoint.cc, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: methods for teaching filesystems about PG_swapcache pages
has been removed from the -mm tree.  Its filename was
     mm-methods-for-teaching-filesystems-about-pg_swapcache-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: methods for teaching filesystems about PG_swapcache pages

In order to teach filesystems to handle swap cache pages, three new page
functions are introduced:

  pgoff_t page_file_index(struct page *);
  loff_t page_file_offset(struct page *);
  struct address_space *page_file_mapping(struct page *);

page_file_index() - gives the offset of this page in the file in
PAGE_CACHE_SIZE blocks.  Like page->index is for mapped pages, this
function also gives the correct index for PG_swapcache pages.

page_file_offset() - uses page_file_index(), so that it will give the
expected result, even for PG_swapcache pages.

page_file_mapping() - gives the mapping backing the actual page; that is
for swap cache pages it will give swap_file->f_mapping.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Eric B Munson <emunson@mgebm.net>
Cc: Eric Paris <eparis@redhat.com>
Cc: James Morris <jmorris@namei.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Neil Brown <neilb@suse.de>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Xiaotian Feng <dfeng@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h      |   25 +++++++++++++++++++++++++
 include/linux/pagemap.h |    5 +++++
 include/linux/swap.h    |    1 +
 mm/swapfile.c           |   26 ++++++++++++++++++++++++++
 4 files changed, 57 insertions(+)

diff -puN include/linux/mm.h~mm-methods-for-teaching-filesystems-about-pg_swapcache-pages include/linux/mm.h
--- a/include/linux/mm.h~mm-methods-for-teaching-filesystems-about-pg_swapcache-pages
+++ a/include/linux/mm.h
@@ -805,6 +805,17 @@ static inline void *page_rmapping(struct
 	return (void *)((unsigned long)page->mapping & ~PAGE_MAPPING_FLAGS);
 }
 
+extern struct address_space *__page_file_mapping(struct page *);
+
+static inline
+struct address_space *page_file_mapping(struct page *page)
+{
+	if (unlikely(PageSwapCache(page)))
+		return __page_file_mapping(page);
+
+	return page->mapping;
+}
+
 static inline int PageAnon(struct page *page)
 {
 	return ((unsigned long)page->mapping & PAGE_MAPPING_ANON) != 0;
@@ -821,6 +832,20 @@ static inline pgoff_t page_index(struct 
 	return page->index;
 }
 
+extern pgoff_t __page_file_index(struct page *page);
+
+/*
+ * Return the file index of the page. Regular pagecache pages use ->index
+ * whereas swapcache pages use swp_offset(->private)
+ */
+static inline pgoff_t page_file_index(struct page *page)
+{
+	if (unlikely(PageSwapCache(page)))
+		return __page_file_index(page);
+
+	return page->index;
+}
+
 /*
  * Return true if this page is mapped into pagetables.
  */
diff -puN include/linux/pagemap.h~mm-methods-for-teaching-filesystems-about-pg_swapcache-pages include/linux/pagemap.h
--- a/include/linux/pagemap.h~mm-methods-for-teaching-filesystems-about-pg_swapcache-pages
+++ a/include/linux/pagemap.h
@@ -286,6 +286,11 @@ static inline loff_t page_offset(struct 
 	return ((loff_t)page->index) << PAGE_CACHE_SHIFT;
 }
 
+static inline loff_t page_file_offset(struct page *page)
+{
+	return ((loff_t)page_file_index(page)) << PAGE_CACHE_SHIFT;
+}
+
 extern pgoff_t linear_hugepage_index(struct vm_area_struct *vma,
 				     unsigned long address);
 
diff -puN include/linux/swap.h~mm-methods-for-teaching-filesystems-about-pg_swapcache-pages include/linux/swap.h
--- a/include/linux/swap.h~mm-methods-for-teaching-filesystems-about-pg_swapcache-pages
+++ a/include/linux/swap.h
@@ -356,6 +356,7 @@ extern unsigned int count_swap_pages(int
 extern sector_t map_swap_page(struct page *, struct block_device **);
 extern sector_t swapdev_block(int, pgoff_t);
 extern int page_swapcount(struct page *);
+extern struct swap_info_struct *page_swap_info(struct page *);
 extern int reuse_swap_page(struct page *);
 extern int try_to_free_swap(struct page *);
 struct backing_dev_info;
diff -puN mm/swapfile.c~mm-methods-for-teaching-filesystems-about-pg_swapcache-pages mm/swapfile.c
--- a/mm/swapfile.c~mm-methods-for-teaching-filesystems-about-pg_swapcache-pages
+++ a/mm/swapfile.c
@@ -33,6 +33,7 @@
 #include <linux/oom.h>
 #include <linux/frontswap.h>
 #include <linux/swapfile.h>
+#include <linux/export.h>
 
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
@@ -2285,6 +2286,31 @@ int swapcache_prepare(swp_entry_t entry)
 	return __swap_duplicate(entry, SWAP_HAS_CACHE);
 }
 
+struct swap_info_struct *page_swap_info(struct page *page)
+{
+	swp_entry_t swap = { .val = page_private(page) };
+	BUG_ON(!PageSwapCache(page));
+	return swap_info[swp_type(swap)];
+}
+
+/*
+ * out-of-line __page_file_ methods to avoid include hell.
+ */
+struct address_space *__page_file_mapping(struct page *page)
+{
+	VM_BUG_ON(!PageSwapCache(page));
+	return page_swap_info(page)->swap_file->f_mapping;
+}
+EXPORT_SYMBOL_GPL(__page_file_mapping);
+
+pgoff_t __page_file_index(struct page *page)
+{
+	swp_entry_t swap = { .val = page_private(page) };
+	VM_BUG_ON(!PageSwapCache(page));
+	return swp_offset(swap);
+}
+EXPORT_SYMBOL_GPL(__page_file_index);
+
 /*
  * add_swap_count_continuation - called when a swap count is duplicated
  * beyond SWAP_MAP_MAX, it allocates a new page and links that to the entry's
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
linux-next.patch

