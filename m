From: akpm@linux-foundation.org
Subject: - mm-add-alloc_pages_exact-and-free_pages_exact.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:24:18 -0700
Message-ID: <200807242324.m6ONOIkD010772@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60880 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755269AbYGXXYa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:24:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: timur@freescale.com, andi@firstfloor.org, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     mm: add alloc_pages_exact() and free_pages_exact()
has been removed from the -mm tree.  Its filename was
     mm-add-alloc_pages_exact-and-free_pages_exact.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: add alloc_pages_exact() and free_pages_exact()
From: Timur Tabi <timur@freescale.com>

alloc_pages_exact() is similar to alloc_pages(), except that it allocates
the minimum number of pages to fulfill the request.  This is useful if you
want to allocate a very large buffer that is slightly larger than an even
power-of-two number of pages.  In that case, alloc_pages() will waste a
lot of memory.

I have a video driver that wants to allocate a 5MB buffer.  alloc_pages()
wiill waste 3MB of physically-contiguous memory.

Signed-off-by: Timur Tabi <timur@freescale.com>
Cc: Andi Kleen <andi@firstfloor.org>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    3 ++
 mm/page_alloc.c     |   53 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+)

diff -puN include/linux/gfp.h~mm-add-alloc_pages_exact-and-free_pages_exact include/linux/gfp.h
--- a/include/linux/gfp.h~mm-add-alloc_pages_exact-and-free_pages_exact
+++ a/include/linux/gfp.h
@@ -228,6 +228,9 @@ extern struct page *alloc_page_vma(gfp_t
 extern unsigned long __get_free_pages(gfp_t gfp_mask, unsigned int order);
 extern unsigned long get_zeroed_page(gfp_t gfp_mask);
 
+void *alloc_pages_exact(size_t size, gfp_t gfp_mask);
+void free_pages_exact(void *virt, size_t size);
+
 #define __get_free_page(gfp_mask) \
 		__get_free_pages((gfp_mask),0)
 
diff -puN mm/page_alloc.c~mm-add-alloc_pages_exact-and-free_pages_exact mm/page_alloc.c
--- a/mm/page_alloc.c~mm-add-alloc_pages_exact-and-free_pages_exact
+++ a/mm/page_alloc.c
@@ -1697,6 +1697,59 @@ void free_pages(unsigned long addr, unsi
 
 EXPORT_SYMBOL(free_pages);
 
+/**
+ * alloc_pages_exact - allocate an exact number physically-contiguous pages.
+ * @size: the number of bytes to allocate
+ * @gfp_mask: GFP flags for the allocation
+ *
+ * This function is similar to alloc_pages(), except that it allocates the
+ * minimum number of pages to satisfy the request.  alloc_pages() can only
+ * allocate memory in power-of-two pages.
+ *
+ * This function is also limited by MAX_ORDER.
+ *
+ * Memory allocated by this function must be released by free_pages_exact().
+ */
+void *alloc_pages_exact(size_t size, gfp_t gfp_mask)
+{
+	unsigned int order = get_order(size);
+	unsigned long addr;
+
+	addr = __get_free_pages(gfp_mask, order);
+	if (addr) {
+		unsigned long alloc_end = addr + (PAGE_SIZE << order);
+		unsigned long used = addr + PAGE_ALIGN(size);
+
+		split_page(virt_to_page(addr), order);
+		while (used < alloc_end) {
+			free_page(used);
+			used += PAGE_SIZE;
+		}
+	}
+
+	return (void *)addr;
+}
+EXPORT_SYMBOL(alloc_pages_exact);
+
+/**
+ * free_pages_exact - release memory allocated via alloc_pages_exact()
+ * @virt: the value returned by alloc_pages_exact.
+ * @size: size of allocation, same value as passed to alloc_pages_exact().
+ *
+ * Release the memory allocated by a previous call to alloc_pages_exact.
+ */
+void free_pages_exact(void *virt, size_t size)
+{
+	unsigned long addr = (unsigned long)virt;
+	unsigned long end = addr + PAGE_ALIGN(size);
+
+	while (addr < end) {
+		free_page(addr);
+		addr += PAGE_SIZE;
+	}
+}
+EXPORT_SYMBOL(free_pages_exact);
+
 static unsigned int nr_free_zone_pages(int offset)
 {
 	struct zoneref *z;
_

Patches currently in -mm which might be from timur@freescale.com are

origin.patch

