From: akpm@linux-foundation.org
Subject: + mm-rename-arguments-to-find_subpage.patch added to -mm
 tree
Date: Mon, 23 Mar 2020 19:35:34 -0700
Message-ID: <20200324023534.ilEK_Bv8t%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726824AbgCXCff (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 23 Mar 2020 22:35:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, hch@lst.de, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org, pankaj.gupta.linux@gmail.com, willy@infradead.org


The patch titled
     Subject: include/linux/pagemap.h: rename arguments to find_subpage
has been added to the -mm tree.  Its filename is
     mm-rename-arguments-to-find_subpage.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-rename-arguments-to-find_subpage.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-rename-arguments-to-find_subpage.patch

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
Subject: include/linux/pagemap.h: rename arguments to find_subpage

This isn't just a random struct page, it's known to be a head page, and
calling it head makes the function better self-documenting.  The pgoff_t
is less confusing if it's named index instead of offset.  Also add a
couple of comments to explain why we're doing various things.

Link: http://lkml.kernel.org/r/20200318140253.6141-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/include/linux/pagemap.h~mm-rename-arguments-to-find_subpage
+++ a/include/linux/pagemap.h
@@ -331,14 +331,19 @@ static inline struct page *grab_cache_pa
 			mapping_gfp_mask(mapping));
 }
 
-static inline struct page *find_subpage(struct page *page, pgoff_t offset)
+/*
+ * Given the page we found in the page cache, return the page corresponding
+ * to this index in the file
+ */
+static inline struct page *find_subpage(struct page *head, pgoff_t index)
 {
-	if (PageHuge(page))
-		return page;
+	/* HugeTLBfs wants the head page regardless */
+	if (PageHuge(head))
+		return head;
 
-	VM_BUG_ON_PAGE(PageTail(page), page);
+	VM_BUG_ON_PAGE(PageTail(head), head);
 
-	return page + (offset & (compound_nr(page) - 1));
+	return head + (index & (compound_nr(head) - 1));
 }
 
 struct page *find_get_entry(struct address_space *mapping, pgoff_t offset);
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
