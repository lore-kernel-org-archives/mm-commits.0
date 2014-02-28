From: akpm@linux-foundation.org
Subject: +
 mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v2.patch
 added to -mm tree
Date: Fri, 28 Feb 2014 15:14:35 -0800
Message-ID: <5311185b.o1PDAhhpCW7Px4kN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52350 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384AbaB1XOf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 28 Feb 2014 18:14:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sasha.levin@oracle.com, riel@redhat.com, n-horiguchi@ah.jp.nec.com

Subject: + mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v2.patch added to -mm tree
To: n-horiguchi@ah.jp.nec.com,riel@redhat.com,sasha.levin@oracle.com
From: akpm@linux-foundation.org
Date: Fri, 28 Feb 2014 15:14:35 -0800


The patch titled
     Subject: mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v2
has been added to the -mm tree.  Its filename is
     mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -326,18 +326,21 @@ static inline loff_t page_file_offset(st
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
@@ -30,6 +30,7 @@
 
 #include <linux/io.h>
 #include <linux/hugetlb.h>
+#include <linux/hugetlb_inline.h>
 #include <linux/hugetlb_cgroup.h>
 #include <linux/node.h>
 #include "internal.h"
@@ -764,9 +765,9 @@ pgoff_t __basepage_index(struct page *pa
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

origin.patch
mm-hugetlb-unify-region-structure-handling.patch
mm-hugetlb-improve-cleanup-resv_map-parameters.patch
mm-hugetlb-fix-race-in-region-tracking.patch
mm-hugetlb-remove-resv_map_put.patch
mm-hugetlb-use-vma_resv_map-map-types.patch
mm-hugetlb-improve-page-fault-scalability.patch
mm-hugetlb-improve-page-fault-scalability-fix.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v2.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
madvise-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-call-vma_adjust_trans_huge-only-for-thp-enabled-vma.patch
mm-rename-__do_fault-do_fault.patch
mm-do_fault-extract-to-call-vm_ops-do_fault-to-separate-function.patch
mm-introduce-do_read_fault.patch
mm-introduce-do_cow_fault.patch
mm-introduce-do_shared_fault-and-drop-do_fault.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-consolidate-code-to-call-vm_ops-page_mkwrite.patch
mm-consolidate-code-to-call-vm_ops-page_mkwrite-fix.patch
mm-consolidate-code-to-setup-pte.patch

