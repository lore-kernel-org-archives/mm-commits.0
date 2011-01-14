From: akpm@linux-foundation.org
Subject: [merged] thp-clear_copy_huge_page.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:47:09 -0800
Message-ID: <201101142249.p0EMnx6s005352@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40272 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753861Ab1ANWuE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:50:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, mel@csn.ul.ie, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     thp: clear_copy_huge_page
has been removed from the -mm tree.  Its filename was
     thp-clear_copy_huge_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: clear_copy_huge_page
From: Andrea Arcangeli <aarcange@redhat.com>

Move the copy/clear_huge_page functions to common code to share between
hugetlb.c and huge_memory.c.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    9 +++++
 mm/hugetlb.c       |   70 +-----------------------------------------
 mm/memory.c        |   71 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 83 insertions(+), 67 deletions(-)

diff -puN include/linux/mm.h~thp-clear_copy_huge_page include/linux/mm.h
--- a/include/linux/mm.h~thp-clear_copy_huge_page
+++ a/include/linux/mm.h
@@ -1589,5 +1589,14 @@ static inline int is_hwpoison_address(un
 
 extern void dump_page(struct page *page);
 
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE) || defined(CONFIG_HUGETLBFS)
+extern void clear_huge_page(struct page *page,
+			    unsigned long addr,
+			    unsigned int pages_per_huge_page);
+extern void copy_user_huge_page(struct page *dst, struct page *src,
+				unsigned long addr, struct vm_area_struct *vma,
+				unsigned int pages_per_huge_page);
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_HUGETLBFS */
+
 #endif /* __KERNEL__ */
 #endif /* _LINUX_MM_H */
diff -puN mm/hugetlb.c~thp-clear_copy_huge_page mm/hugetlb.c
--- a/mm/hugetlb.c~thp-clear_copy_huge_page
+++ a/mm/hugetlb.c
@@ -394,71 +394,6 @@ static int vma_has_reserves(struct vm_ar
 	return 0;
 }
 
-static void clear_gigantic_page(struct page *page,
-			unsigned long addr, unsigned long sz)
-{
-	int i;
-	struct page *p = page;
-
-	might_sleep();
-	for (i = 0; i < sz/PAGE_SIZE; i++, p = mem_map_next(p, page, i)) {
-		cond_resched();
-		clear_user_highpage(p, addr + i * PAGE_SIZE);
-	}
-}
-static void clear_huge_page(struct page *page,
-			unsigned long addr, unsigned long sz)
-{
-	int i;
-
-	if (unlikely(sz/PAGE_SIZE > MAX_ORDER_NR_PAGES)) {
-		clear_gigantic_page(page, addr, sz);
-		return;
-	}
-
-	might_sleep();
-	for (i = 0; i < sz/PAGE_SIZE; i++) {
-		cond_resched();
-		clear_user_highpage(page + i, addr + i * PAGE_SIZE);
-	}
-}
-
-static void copy_user_gigantic_page(struct page *dst, struct page *src,
-			   unsigned long addr, struct vm_area_struct *vma)
-{
-	int i;
-	struct hstate *h = hstate_vma(vma);
-	struct page *dst_base = dst;
-	struct page *src_base = src;
-
-	for (i = 0; i < pages_per_huge_page(h); ) {
-		cond_resched();
-		copy_user_highpage(dst, src, addr + i*PAGE_SIZE, vma);
-
-		i++;
-		dst = mem_map_next(dst, dst_base, i);
-		src = mem_map_next(src, src_base, i);
-	}
-}
-
-static void copy_user_huge_page(struct page *dst, struct page *src,
-			   unsigned long addr, struct vm_area_struct *vma)
-{
-	int i;
-	struct hstate *h = hstate_vma(vma);
-
-	if (unlikely(pages_per_huge_page(h) > MAX_ORDER_NR_PAGES)) {
-		copy_user_gigantic_page(dst, src, addr, vma);
-		return;
-	}
-
-	might_sleep();
-	for (i = 0; i < pages_per_huge_page(h); i++) {
-		cond_resched();
-		copy_user_highpage(dst + i, src + i, addr + i*PAGE_SIZE, vma);
-	}
-}
-
 static void copy_gigantic_page(struct page *dst, struct page *src)
 {
 	int i;
@@ -2454,7 +2389,8 @@ retry_avoidcopy:
 		return VM_FAULT_OOM;
 	}
 
-	copy_user_huge_page(new_page, old_page, address, vma);
+	copy_user_huge_page(new_page, old_page, address, vma,
+			    pages_per_huge_page(h));
 	__SetPageUptodate(new_page);
 
 	/*
@@ -2558,7 +2494,7 @@ retry:
 			ret = -PTR_ERR(page);
 			goto out;
 		}
-		clear_huge_page(page, address, huge_page_size(h));
+		clear_huge_page(page, address, pages_per_huge_page(h));
 		__SetPageUptodate(page);
 
 		if (vma->vm_flags & VM_MAYSHARE) {
diff -puN mm/memory.c~thp-clear_copy_huge_page mm/memory.c
--- a/mm/memory.c~thp-clear_copy_huge_page
+++ a/mm/memory.c
@@ -3645,3 +3645,74 @@ void might_fault(void)
 }
 EXPORT_SYMBOL(might_fault);
 #endif
+
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE) || defined(CONFIG_HUGETLBFS)
+static void clear_gigantic_page(struct page *page,
+				unsigned long addr,
+				unsigned int pages_per_huge_page)
+{
+	int i;
+	struct page *p = page;
+
+	might_sleep();
+	for (i = 0; i < pages_per_huge_page;
+	     i++, p = mem_map_next(p, page, i)) {
+		cond_resched();
+		clear_user_highpage(p, addr + i * PAGE_SIZE);
+	}
+}
+void clear_huge_page(struct page *page,
+		     unsigned long addr, unsigned int pages_per_huge_page)
+{
+	int i;
+
+	if (unlikely(pages_per_huge_page > MAX_ORDER_NR_PAGES)) {
+		clear_gigantic_page(page, addr, pages_per_huge_page);
+		return;
+	}
+
+	might_sleep();
+	for (i = 0; i < pages_per_huge_page; i++) {
+		cond_resched();
+		clear_user_highpage(page + i, addr + i * PAGE_SIZE);
+	}
+}
+
+static void copy_user_gigantic_page(struct page *dst, struct page *src,
+				    unsigned long addr,
+				    struct vm_area_struct *vma,
+				    unsigned int pages_per_huge_page)
+{
+	int i;
+	struct page *dst_base = dst;
+	struct page *src_base = src;
+
+	for (i = 0; i < pages_per_huge_page; ) {
+		cond_resched();
+		copy_user_highpage(dst, src, addr + i*PAGE_SIZE, vma);
+
+		i++;
+		dst = mem_map_next(dst, dst_base, i);
+		src = mem_map_next(src, src_base, i);
+	}
+}
+
+void copy_user_huge_page(struct page *dst, struct page *src,
+			 unsigned long addr, struct vm_area_struct *vma,
+			 unsigned int pages_per_huge_page)
+{
+	int i;
+
+	if (unlikely(pages_per_huge_page > MAX_ORDER_NR_PAGES)) {
+		copy_user_gigantic_page(dst, src, addr, vma,
+					pages_per_huge_page);
+		return;
+	}
+
+	might_sleep();
+	for (i = 0; i < pages_per_huge_page; i++) {
+		cond_resched();
+		copy_user_highpage(dst + i, src + i, addr + i*PAGE_SIZE, vma);
+	}
+}
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_HUGETLBFS */
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
thp-add-pagetranscompound.patch

