From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v2.patch
 removed from -mm tree
Date: Mon, 07 Jul 2014 13:00:06 -0700
Message-ID: <53bafc46.A6N9CjMTbe3fp43P%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:42504 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbaGGUAH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jul 2014 16:00:07 -0400
Received: by mail-ob0-f202.google.com with SMTP id va2so1027663obc.5
        for <mm-commits@vger.kernel.org>; Mon, 07 Jul 2014 13:00:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, riel@redhat.com, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v2
has been removed from the -mm tree.  Its filename was
     mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v2.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v2

- fix wrong shift direction
- introduce page_size_order() and huge_page_size_order()
- move the declaration of PageHuge() to include/linux/hugetlb_inline.h
  to avoid macro definition.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h        |    7 -------
 include/linux/hugetlb_inline.h |   13 +++++++++++++
 include/linux/pagemap.h        |   17 ++++++++++-------
 mm/hugetlb.c                   |    5 +++--
 4 files changed, 26 insertions(+), 16 deletions(-)

diff -puN include/linux/hugetlb.h~mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v2 include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v2
+++ a/include/linux/hugetlb.h
@@ -41,8 +41,6 @@ extern int hugetlb_max_hstate __read_mos
 struct hugepage_subpool *hugepage_new_subpool(long nr_blocks);
 void hugepage_put_subpool(struct hugepage_subpool *spool);
 
-int PageHuge(struct page *page);
-
 void reset_vma_resv_huge_pages(struct vm_area_struct *vma);
 int hugetlb_sysctl_handler(struct ctl_table *, int, void __user *, size_t *, loff_t *);
 int hugetlb_overcommit_handler(struct ctl_table *, int, void __user *, size_t *, loff_t *);
@@ -109,11 +107,6 @@ unsigned long hugetlb_change_protection(
 
 #else /* !CONFIG_HUGETLB_PAGE */
 
-static inline int PageHuge(struct page *page)
-{
-	return 0;
-}
-
 static inline void reset_vma_resv_huge_pages(struct vm_area_struct *vma)
 {
 }
diff -puN include/linux/hugetlb_inline.h~mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v2 include/linux/hugetlb_inline.h
--- a/include/linux/hugetlb_inline.h~mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v2
+++ a/include/linux/hugetlb_inline.h
@@ -10,12 +10,25 @@ static inline int is_vm_hugetlb_page(str
 	return !!(vma->vm_flags & VM_HUGETLB);
 }
 
+int PageHuge(struct page *page);
+unsigned int huge_page_size_order(struct page *page);
+
 #else
 
 static inline int is_vm_hugetlb_page(struct vm_area_struct *vma)
 {
 	return 0;
 }
+
+static inline int PageHuge(struct page *page)
+{
+	return 0;
+}
+
+static inline unsigned int huge_page_size_order(struct page *page)
+{
+	return 0;
+}
 
 #endif
 
diff -puN include/linux/pagemap.h~mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v2 include/linux/pagemap.h
--- a/include/linux/pagemap.h~mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v2
+++ a/include/linux/pagemap.h
@@ -411,18 +411,21 @@ static inline loff_t page_file_offset(st
 	return ((loff_t)page_file_index(page)) << PAGE_CACHE_SHIFT;
 }
 
-extern pgoff_t hugepage_pgoff(struct page *page);
+static inline unsigned int page_size_order(struct page *page)
+{
+	return unlikely(PageHuge(page)) ?
+		huge_page_size_order(page) :
+		(PAGE_CACHE_SHIFT - PAGE_SHIFT);
+}
 
 /*
  * page->index stores pagecache index whose unit is not always PAGE_SIZE.
  * This function converts it into PAGE_SIZE offset.
  */
-#define page_pgoff(page)					\
-({								\
-	unlikely(PageHuge(page)) ?				\
-		hugepage_pgoff(page) :				\
-		page->index >> (PAGE_CACHE_SHIFT - PAGE_SHIFT);	\
-})
+static inline pgoff_t page_pgoff(struct page *page)
+{
+        return page->index << page_size_order(page);
+}
 
 extern pgoff_t linear_hugepage_index(struct vm_area_struct *vma,
 				     unsigned long address);
diff -puN mm/hugetlb.c~mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v2 mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v2
+++ a/mm/hugetlb.c
@@ -31,6 +31,7 @@
 
 #include <linux/io.h>
 #include <linux/hugetlb.h>
+#include <linux/hugetlb_inline.h>
 #include <linux/hugetlb_cgroup.h>
 #include <linux/node.h>
 #include "internal.h"
@@ -981,9 +982,9 @@ pgoff_t __basepage_index(struct page *pa
 	return (index << compound_order(page_head)) + compound_idx;
 }
 
-pgoff_t hugepage_pgoff(struct page *page)
+unsigned int huge_page_size_order(struct page *page)
 {
-	return page->index << huge_page_order(page_hstate(page));
+	return huge_page_order(page_hstate(page));
 }
 
 static struct page *alloc_fresh_huge_page_node(struct hstate *h, int nid)
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

rmap-fix-pgoff-calculation-to-handle-hugepage-correctly.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
mm-update-the-description-for-madvise_remove.patch
mm-hwpoison-injectc-remove-unnecessary-null-test-before-debugfs_remove_recursive.patch
hwpoison-fix-race-with-changing-page-during-offlining-v2.patch
mm-hugetlb-generalize-writes-to-nr_hugepages.patch
mm-hugetlb-remove-hugetlb_zero-and-hugetlb_infinity.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

