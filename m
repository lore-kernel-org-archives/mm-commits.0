From: akpm@linux-foundation.org
Subject: [patch 062/117] mm: uninline page_mapped()
Date: Thu, 19 May 2016 17:12:00 -0700
Message-ID: <573e5650.v2oEXic6Brh49rZ+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46244 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932418AbcETAMC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 20:12:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, kirill.shutemov@linux.intel.com, steve.capper@arm.com

From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm: uninline page_mapped()

It's huge.  Uninlining it saves 206 bytes per callsite.  Shaves 4924 bytes
from the x86_64 allmodconfig vmlinux.

[akpm@linux-foundation.org: coding-style fixes]
Cc: Steve Capper <steve.capper@arm.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   21 +--------------------
 mm/util.c          |   23 +++++++++++++++++++++++
 2 files changed, 24 insertions(+), 20 deletions(-)

diff -puN include/linux/mm.h~mm-uninline-page_mapped include/linux/mm.h
--- a/include/linux/mm.h~mm-uninline-page_mapped
+++ a/include/linux/mm.h
@@ -1032,26 +1032,7 @@ static inline pgoff_t page_file_index(st
 	return page->index;
 }
 
-/*
- * Return true if this page is mapped into pagetables.
- * For compound page it returns true if any subpage of compound page is mapped.
- */
-static inline bool page_mapped(struct page *page)
-{
-	int i;
-	if (likely(!PageCompound(page)))
-		return atomic_read(&page->_mapcount) >= 0;
-	page = compound_head(page);
-	if (atomic_read(compound_mapcount_ptr(page)) >= 0)
-		return true;
-	if (PageHuge(page))
-		return false;
-	for (i = 0; i < hpage_nr_pages(page); i++) {
-		if (atomic_read(&page[i]._mapcount) >= 0)
-			return true;
-	}
-	return false;
-}
+bool page_mapped(struct page *page);
 
 /*
  * Return true only if the page has been allocated with
diff -puN mm/util.c~mm-uninline-page_mapped mm/util.c
--- a/mm/util.c~mm-uninline-page_mapped
+++ a/mm/util.c
@@ -346,6 +346,29 @@ void *page_rmapping(struct page *page)
 	return __page_rmapping(page);
 }
 
+/*
+ * Return true if this page is mapped into pagetables.
+ * For compound page it returns true if any subpage of compound page is mapped.
+ */
+bool page_mapped(struct page *page)
+{
+	int i;
+
+	if (likely(!PageCompound(page)))
+		return atomic_read(&page->_mapcount) >= 0;
+	page = compound_head(page);
+	if (atomic_read(compound_mapcount_ptr(page)) >= 0)
+		return true;
+	if (PageHuge(page))
+		return false;
+	for (i = 0; i < hpage_nr_pages(page); i++) {
+		if (atomic_read(&page[i]._mapcount) >= 0)
+			return true;
+	}
+	return false;
+}
+EXPORT_SYMBOL(page_mapped);
+
 struct anon_vma *page_anon_vma(struct page *page)
 {
 	unsigned long mapping;
_
