From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-fix.patch
 removed from -mm tree
Date: Thu, 14 Jan 2016 14:43:15 -0800
Message-ID: <56982483.qG2GbzYYBHzBCcY8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46338 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756239AbcANWnQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Jan 2016 17:43:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill@shutemov.name, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-fix
has been removed from the -mm tree.  Its filename was
     mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-fix.patch

This patch was dropped because it was folded into mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting.patch

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-fix

x86_64 allnoconfig:

In file included from mm/rmap.c:47:
include/linux/mm.h: In function 'page_referenced':
include/linux/mm.h:448: error: call to '__compiletime_assert_448' declared with attribute error: BUILD_BUG failed
make[1]: *** [mm/rmap.o] Error 1
make: *** [mm/rmap.o] Error 2


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   20 +++++---------------
 mm/huge_memory.c   |   19 +++++++++++++++++++
 2 files changed, 24 insertions(+), 15 deletions(-)

diff -puN include/linux/mm.h~mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-fix include/linux/mm.h
--- a/include/linux/mm.h~mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-fix
+++ a/include/linux/mm.h
@@ -448,24 +448,14 @@ static inline int page_mapcount(struct p
 	return ret;
 }
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+int total_mapcount(struct page *page);
+#else
 static inline int total_mapcount(struct page *page)
 {
-	int i, ret;
-
-	VM_BUG_ON_PAGE(PageTail(page), page);
-
-	if (likely(!PageCompound(page)))
-		return atomic_read(&page->_mapcount) + 1;
-
-	ret = compound_mapcount(page);
-	if (PageHuge(page))
-		return ret;
-	for (i = 0; i < HPAGE_PMD_NR; i++)
-		ret += atomic_read(&page[i]._mapcount) + 1;
-	if (PageDoubleMap(page))
-		ret -= HPAGE_PMD_NR;
-	return ret;
+	return page_mapcount(page);
 }
+#endif
 
 static inline int page_count(struct page *page)
 {
diff -puN mm/huge_memory.c~mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-fix mm/huge_memory.c
--- a/mm/huge_memory.c~mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-fix
+++ a/mm/huge_memory.c
@@ -3216,6 +3216,25 @@ static void __split_huge_page(struct pag
 	}
 }
 
+int total_mapcount(struct page *page)
+{
+	int i, ret;
+
+	VM_BUG_ON_PAGE(PageTail(page), page);
+
+	if (likely(!PageCompound(page)))
+		return atomic_read(&page->_mapcount) + 1;
+
+	ret = compound_mapcount(page);
+	if (PageHuge(page))
+		return ret;
+	for (i = 0; i < HPAGE_PMD_NR; i++)
+		ret += atomic_read(&page[i]._mapcount) + 1;
+	if (PageDoubleMap(page))
+		ret -= HPAGE_PMD_NR;
+	return ret;
+}
+
 /*
  * This function splits huge page into normal pages. @page can point to any
  * subpage of huge page to split. Split doesn't change the position of @page.
_

Patches currently in -mm which might be from kirill@shutemov.name are

mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting.patch
thp-increase-split_huge_page-success-rate-fix.patch
mm-add-page_check_address_transhuge-helper-fix-fix.patch

