From: akpm@linux-foundation.org
Subject: +
 mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-fix.patch
 added to -mm tree
Date: Fri, 06 Nov 2015 14:31:22 -0800
Message-ID: <563d2a3a.hOyRIKvSy4RV115p%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51029 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1033702AbbKFWbX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 17:31:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill@shutemov.name, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-fix
has been added to the -mm tree.  Its filename is
     mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -433,24 +433,14 @@ static inline int page_mapcount(struct p
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
@@ -3204,6 +3204,25 @@ static void __split_huge_page(struct pag
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

futex-thp-remove-special-case-for-thp-in-get_futex_key-fix.patch
mm-thp-remove-infrastructure-for-handling-splitting-pmds-fix.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-4.patch
thp-reintroduce-split_huge_page-fix-2.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-fix.patch

