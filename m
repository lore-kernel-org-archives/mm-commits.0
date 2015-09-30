From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-sanitize-page-mapping-for-tail-pages.patch
 removed from -mm tree
Date: Wed, 30 Sep 2015 14:57:06 -0700
Message-ID: <560c5ab2.KiiD8ByAKZ2qILDK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52785 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813AbbI3V5H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Sep 2015 17:57:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, cl@linux.com, dave.hansen@intel.com, hannes@cmpxchg.org, hughd@google.com, jmarchan@redhat.com, mgorman@suse.de, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, riel@redhat.com, steve.capper@linaro.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: sanitize page->mapping for tail pages
has been removed from the -mm tree.  Its filename was
     mm-sanitize-page-mapping-for-tail-pages.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: sanitize page->mapping for tail pages

We don't define meaning of page->mapping for tail pages.  Currently it's
always NULL, which can be inconsistent with head page and potentially lead
to problems.

Let's poison the pointer to catch all illigal uses.

page_rmapping(), page_mapping() and page_anon_vma() are changed to look on
head page.

The only illegal use I've caught so far is __GPF_COMP pages from sound
subsystem, mapped with PTEs.  do_shared_fault() is changed to use
page_rmapping() instead of direct access to fault_page->mapping.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Steve Capper <steve.capper@linaro.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Jerome Marchand <jmarchan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/poison.h |    4 ++++
 mm/huge_memory.c       |    2 +-
 mm/memory.c            |    2 +-
 mm/page_alloc.c        |    6 ++++++
 mm/util.c              |   10 ++++++----
 5 files changed, 18 insertions(+), 6 deletions(-)

diff -puN include/linux/poison.h~mm-sanitize-page-mapping-for-tail-pages include/linux/poison.h
--- a/include/linux/poison.h~mm-sanitize-page-mapping-for-tail-pages
+++ a/include/linux/poison.h
@@ -32,6 +32,10 @@
 /********** mm/debug-pagealloc.c **********/
 #define PAGE_POISON 0xaa
 
+/********** mm/page_alloc.c ************/
+
+#define TAIL_MAPPING	((void *) 0x01014A11 + POISON_POINTER_DELTA)
+
 /********** mm/slab.c **********/
 /*
  * Magic nums for obj red zoning.
diff -puN mm/huge_memory.c~mm-sanitize-page-mapping-for-tail-pages mm/huge_memory.c
--- a/mm/huge_memory.c~mm-sanitize-page-mapping-for-tail-pages
+++ a/mm/huge_memory.c
@@ -1836,7 +1836,7 @@ static void __split_huge_page_refcount(s
 		*/
 		page_tail->_mapcount = page->_mapcount;
 
-		BUG_ON(page_tail->mapping);
+		BUG_ON(page_tail->mapping != TAIL_MAPPING);
 		page_tail->mapping = page->mapping;
 
 		page_tail->index = page->index + i;
diff -puN mm/memory.c~mm-sanitize-page-mapping-for-tail-pages mm/memory.c
--- a/mm/memory.c~mm-sanitize-page-mapping-for-tail-pages
+++ a/mm/memory.c
@@ -3087,7 +3087,7 @@ static int do_shared_fault(struct mm_str
 	 * pinned by vma->vm_file's reference.  We rely on unlock_page()'s
 	 * release semantics to prevent the compiler from undoing this copying.
 	 */
-	mapping = fault_page->mapping;
+	mapping = page_rmapping(fault_page);
 	unlock_page(fault_page);
 	if ((dirtied || vma->vm_ops->page_mkwrite) && mapping) {
 		/*
diff -puN mm/page_alloc.c~mm-sanitize-page-mapping-for-tail-pages mm/page_alloc.c
--- a/mm/page_alloc.c~mm-sanitize-page-mapping-for-tail-pages
+++ a/mm/page_alloc.c
@@ -473,6 +473,7 @@ void prep_compound_page(struct page *pag
 	for (i = 1; i < nr_pages; i++) {
 		struct page *p = page + i;
 		set_page_count(p, 0);
+		p->mapping = TAIL_MAPPING;
 		set_compound_head(p, page);
 	}
 }
@@ -863,6 +864,10 @@ static int free_tail_pages_check(struct
 		ret = 0;
 		goto out;
 	}
+	if (page->mapping != TAIL_MAPPING) {
+		bad_page(page, "corrupted mapping in tail page", 0);
+		goto out;
+	}
 	if (unlikely(!PageTail(page))) {
 		bad_page(page, "PageTail not set", 0);
 		goto out;
@@ -873,6 +878,7 @@ static int free_tail_pages_check(struct
 	}
 	ret = 0;
 out:
+	page->mapping = NULL;
 	clear_compound_head(page);
 	return ret;
 }
diff -puN mm/util.c~mm-sanitize-page-mapping-for-tail-pages mm/util.c
--- a/mm/util.c~mm-sanitize-page-mapping-for-tail-pages
+++ a/mm/util.c
@@ -355,7 +355,9 @@ struct anon_vma *page_anon_vma(struct pa
 
 struct address_space *page_mapping(struct page *page)
 {
-	unsigned long mapping;
+	struct address_space *mapping;
+
+	page = compound_head(page);
 
 	/* This happens if someone calls flush_dcache_page on slab page */
 	if (unlikely(PageSlab(page)))
@@ -368,10 +370,10 @@ struct address_space *page_mapping(struc
 		return swap_address_space(entry);
 	}
 
-	mapping = (unsigned long)page->mapping;
-	if (mapping & PAGE_MAPPING_FLAGS)
+	mapping = page->mapping;
+	if ((unsigned long)mapping & PAGE_MAPPING_FLAGS)
 		return NULL;
-	return page->mapping;
+	return mapping;
 }
 
 int overcommit_ratio_handler(struct ctl_table *table, int write,
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

rcu-force-alignment-on-struct-callback_head-rcu_head.patch
mm-make-optimistic-check-for-swapin-readahead-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch
mm-drop-page-slab_page.patch
slab-slub-use-page-rcu_head-instead-of-page-lru-plus-cast.patch
zsmalloc-use-page-private-instead-of-page-first_page.patch
mm-pack-compound_dtor-and-compound_order-into-one-word-in-struct-page.patch
mm-make-compound_head-robust.patch
mm-use-unsigned-int-for-page-order.patch
mm-use-unsigned-int-for-compound_dtor-compound_order-on-64bit.patch
mm-support-madvisemadv_free-fix-3.patch

