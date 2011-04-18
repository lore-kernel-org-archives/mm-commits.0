From: akpm@linux-foundation.org
Subject: + mm-make-new-alloc_pages_exact.patch added to -mm tree
Date: Mon, 18 Apr 2011 11:49:30 -0700
Message-ID: <201104181849.p3IInVrF018643@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50157 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754890Ab1DRSuz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Apr 2011 14:50:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dave@linux.vnet.ibm.com, ak@linux.intel.com, mel@csn.ul.ie, rientjes@google.com, timur@freescale.com


The patch titled
     mm: make new alloc_pages_exact()
has been added to the -mm tree.  Its filename is
     mm-make-new-alloc_pages_exact.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: make new alloc_pages_exact()
From: Dave Hansen <dave@linux.vnet.ibm.com>

What I really wanted in the end was a highmem-capable alloc_pages_exact(),
so here it is.  This function can be used to allocate unmapped (like
highmem) non-power-of-two-sized areas of memory.  This is in constast to
get_free_pages_exact() which can only allocate from lowmem.

My plan is to use this in the virtio_balloon driver to allocate large,
oddly-sized contiguous areas.

The new __alloc_pages_exact() now takes a size in numbers of pages, and
returns a 'struct page', which means it can now address highmem.  The
(new) argument order mirrors alloc_pages() itself.

It's a bit unfortunate that this introduces __free_pages_exact() alongside
free_pages_exact().  But that mess already exists with __free_pages() vs. 
free_pages_exact().  So, at worst, this mirrors the mess that we already
have.

I'm also a bit worried that I've not put in something named
alloc_pages_exact(), but that behaves differently than it did before this
set.  I got all of the in-tree cases, but I'm a bit worried about
stragglers elsewhere.  So, I'm calling this __alloc_pages_exact() for the
moment.  We can take out the __ some day if it bothers people.

Note that the __get_free_pages() has a !GFP_HIGHMEM check.  Now that we
are using alloc_pages_exact() instead of __get_free_pages() for
get_free_pages_exact(), we had to add a new check in
get_free_pages_exact().

This has been compile and boot tested, and I checked that

	echo 2 > /sys/kernel/profiling

still works, since it uses get_free_pages_exact().

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Timur Tabi <timur@freescale.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    4 +
 mm/page_alloc.c     |   85 +++++++++++++++++++++++++++++++-----------
 2 files changed, 68 insertions(+), 21 deletions(-)

diff -puN include/linux/gfp.h~mm-make-new-alloc_pages_exact include/linux/gfp.h
--- a/include/linux/gfp.h~mm-make-new-alloc_pages_exact
+++ a/include/linux/gfp.h
@@ -346,6 +346,10 @@ extern struct page *alloc_pages_vma(gfp_
 extern unsigned long __get_free_pages(gfp_t gfp_mask, unsigned int order);
 extern unsigned long get_zeroed_page(gfp_t gfp_mask);
 
+/* 'struct page' version */
+struct page *__alloc_pages_exact(gfp_t gfp_mask, unsigned long nr_pages);
+void __free_pages_exact(struct page *page, unsigned long nr_pages);
+/* virtual address version */
 void *get_free_pages_exact(gfp_t gfp_mask, size_t size);
 void free_pages_exact(void *virt, size_t size);
 
diff -puN mm/page_alloc.c~mm-make-new-alloc_pages_exact mm/page_alloc.c
--- a/mm/page_alloc.c~mm-make-new-alloc_pages_exact
+++ a/mm/page_alloc.c
@@ -2319,9 +2319,10 @@ void free_pages(unsigned long addr, unsi
 EXPORT_SYMBOL(free_pages);
 
 /**
- * get_free_pages_exact - allocate an exact number physically-contiguous pages.
- * @size: the number of bytes to allocate
+ * __alloc_pages_exact - allocate an exact number physically-contiguous pages.
+ * @nr_pages: the number of pages to allocate
  * @gfp_mask: GFP flags for the allocation
+ * returns: struct page for allocated memory
  *
  * This function is similar to alloc_pages(), except that it allocates the
  * minimum number of pages to satisfy the request.  alloc_pages() can only
@@ -2331,29 +2332,76 @@ EXPORT_SYMBOL(free_pages);
  *
  * Memory allocated by this function must be released by free_pages_exact().
  */
-void *get_free_pages_exact(gfp_t gfp_mask, size_t size)
+struct page *__alloc_pages_exact(gfp_t gfp_mask, unsigned long nr_pages)
 {
-	unsigned int order = get_order(size);
-	unsigned long addr;
+	unsigned int order = get_order(nr_pages * PAGE_SIZE);
+	struct page *page;
 
-	addr = __get_free_pages(gfp_mask, order);
-	if (addr) {
-		unsigned long alloc_end = addr + (PAGE_SIZE << order);
-		unsigned long used = addr + PAGE_ALIGN(size);
+	page = alloc_pages(gfp_mask, order);
+	if (page) {
+		struct page *alloc_end = page + (1 << order);
+		struct page *used = page + nr_pages;
 
-		split_page(virt_to_page((void *)addr), order);
+		split_page(page, order);
 		while (used < alloc_end) {
-			free_page(used);
-			used += PAGE_SIZE;
+			__free_page(used);
+			used++;
 		}
 	}
 
-	return (void *)addr;
+	return page;
+}
+EXPORT_SYMBOL(__alloc_pages_exact);
+
+/**
+ * __free_pages_exact - release memory allocated via __alloc_pages_exact()
+ * @virt: the value returned by get_free_pages_exact.
+ * @nr_pages: size in pages, same value as passed to __alloc_pages_exact().
+ *
+ * Release the memory allocated by a previous call to __alloc_pages_exact().
+ */
+void __free_pages_exact(struct page *page, unsigned long nr_pages)
+{
+	struct page *end = page + nr_pages;
+
+	while (page < end) {
+		__free_page(page);
+		page++;
+	}
+}
+EXPORT_SYMBOL(__free_pages_exact);
+
+/**
+ * get_free_pages_exact - allocate an exact number physically-contiguous pages.
+ * @gfp_mask: GFP flags for the allocation
+ * @size: the number of bytes to allocate
+ * returns: virtual address of allocated memory
+ *
+ * This function is similar to __get_free_pages(), except that it allocates the
+ * minimum number of pages to satisfy the request.  get_free_pages() can only
+ * allocate memory in power-of-two pages.
+ *
+ * This function is also limited by MAX_ORDER.
+ *
+ * Memory allocated by this function must be released by free_pages_exact().
+ */
+void *get_free_pages_exact(gfp_t gfp_mask, size_t size)
+{
+	struct page *page;
+	unsigned long nr_pages = PAGE_ALIGN(size) / PAGE_SIZE;
+
+	/* If we are using page_address(), we can not allow highmem */
+	VM_BUG_ON((gfp_mask & __GFP_HIGHMEM) != 0);
+
+	page = __alloc_pages_exact(gfp_mask, nr_pages);
+	if (page)
+		return (void *) page_address(page);
+	return NULL;
 }
 EXPORT_SYMBOL(get_free_pages_exact);
 
 /**
- * free_pages_exact - release memory allocated via get_free_pages_exact()
+ * __free_pages_exact - release memory allocated via get_free_pages_exact()
  * @virt: the value returned by get_free_pages_exact.
  * @size: size of allocation, same value as passed to get_free_pages_exact().
  *
@@ -2361,13 +2409,8 @@ EXPORT_SYMBOL(get_free_pages_exact);
  */
 void free_pages_exact(void *virt, size_t size)
 {
-	unsigned long addr = (unsigned long)virt;
-	unsigned long end = addr + PAGE_ALIGN(size);
