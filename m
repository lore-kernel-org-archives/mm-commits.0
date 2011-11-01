From: akpm@linux-foundation.org
Subject: [merged] debug-pagealloc-add-support-for-highmem-pages.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:10:33 -0700
Message-ID: <201111012110.pA1LAXPB023808@hpaq6.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:29064 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab1KAVKg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:10:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: debug-pagealloc: add support for highmem pages
has been removed from the -mm tree.  Its filename was
     debug-pagealloc-add-support-for-highmem-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: debug-pagealloc: add support for highmem pages

This adds support for highmem pages poisoning and verification to the
debug-pagealloc feature for no-architecture support.

[akpm@linux-foundation.org: remove unneeded preempt_disable/enable]
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug-pagealloc.c |   44 +++++++++--------------------------------
 1 file changed, 10 insertions(+), 34 deletions(-)

diff -puN mm/debug-pagealloc.c~debug-pagealloc-add-support-for-highmem-pages mm/debug-pagealloc.c
--- a/mm/debug-pagealloc.c~debug-pagealloc-add-support-for-highmem-pages
+++ a/mm/debug-pagealloc.c
@@ -1,6 +1,7 @@
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/mm.h>
+#include <linux/highmem.h>
 #include <linux/page-debug-flags.h>
 #include <linux/poison.h>
 #include <linux/ratelimit.h>
@@ -20,28 +21,13 @@ static inline bool page_poison(struct pa
 	return test_bit(PAGE_DEBUG_FLAG_POISON, &page->debug_flags);
 }
 
-static void poison_highpage(struct page *page)
-{
-	/*
-	 * Page poisoning for highmem pages is not implemented.
-	 *
-	 * This can be called from interrupt contexts.
-	 * So we need to create a new kmap_atomic slot for this
-	 * application and it will need interrupt protection.
-	 */
-}
-
 static void poison_page(struct page *page)
 {
-	void *addr;
+	void *addr = kmap_atomic(page);
 
-	if (PageHighMem(page)) {
-		poison_highpage(page);
-		return;
-	}
 	set_page_poison(page);
-	addr = page_address(page);
 	memset(addr, PAGE_POISON, PAGE_SIZE);
+	kunmap_atomic(addr);
 }
 
 static void poison_pages(struct page *page, int n)
@@ -86,27 +72,17 @@ static void check_poison_mem(unsigned ch
 	dump_stack();
 }
 
-static void unpoison_highpage(struct page *page)
-{
-	/*
-	 * See comment in poison_highpage().
-	 * Highmem pages should not be poisoned for now
-	 */
-	BUG_ON(page_poison(page));
-}
-
 static void unpoison_page(struct page *page)
 {
-	if (PageHighMem(page)) {
-		unpoison_highpage(page);
+	void *addr;
+
+	if (!page_poison(page))
 		return;
-	}
-	if (page_poison(page)) {
-		void *addr = page_address(page);
 
-		check_poison_mem(addr, PAGE_SIZE);
-		clear_page_poison(page);
-	}
+	addr = kmap_atomic(page);
+	check_poison_mem(addr, PAGE_SIZE);
+	clear_page_poison(page);
+	kunmap_atomic(addr);
 }
 
 static void unpoison_pages(struct page *page, int n)
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
linux-next.patch
ext4-use-proper-little-endian-bitops.patch
ocfs2-avoid-unaligned-access-to-dqc_bitmap.patch

