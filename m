From: akpm@linux-foundation.org
Subject: + debug-pagealloc-add-support-for-highmem-pages.patch added to -mm tree
Date: Thu, 25 Aug 2011 17:03:08 -0700
Message-ID: <201108260003.p7Q038ej021352@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34741 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753620Ab1HZADK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Aug 2011 20:03:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com


The patch titled
     debug-pagealloc: add support for highmem pages
has been added to the -mm tree.  Its filename is
     debug-pagealloc-add-support-for-highmem-pages.patch

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
Subject: debug-pagealloc: add support for highmem pages
From: Akinobu Mita <akinobu.mita@gmail.com>

This adds support for highmem pages poisoning and verification to the
debug-pagealloc feature for no-architecture support.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug-pagealloc.c |   47 ++++++++++++-----------------------------
 1 file changed, 14 insertions(+), 33 deletions(-)

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
@@ -20,28 +21,16 @@ static inline bool page_poison(struct pa
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
 	void *addr;
 
-	if (PageHighMem(page)) {
-		poison_highpage(page);
-		return;
-	}
+	preempt_disable();
+	addr = kmap_atomic(page);
 	set_page_poison(page);
-	addr = page_address(page);
 	memset(addr, PAGE_POISON, PAGE_SIZE);
+	kunmap_atomic(addr);
+	preempt_enable();
 }
 
 static void poison_pages(struct page *page, int n)
@@ -86,27 +75,19 @@ static void check_poison_mem(unsigned ch
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
+	preempt_disable();
+	addr = kmap_atomic(page);
+	check_poison_mem(addr, PAGE_SIZE);
+	clear_page_poison(page);
+	kunmap_atomic(addr);
+	preempt_enable();
 }
 
 static void unpoison_pages(struct page *page, int n)
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

linux-next.patch
ext4-use-proper-little-endian-bitops.patch
ocfs2-avoid-unaligned-access-to-dqc_bitmap.patch
mm-debug-pageallocc-use-plain-__ratelimit-instead-of-printk_ratelimit.patch
lib-stringc-introduce-memchr_inv.patch
mm-debug-pageallocc-use-memchr_inv.patch
debug-pagealloc-add-support-for-highmem-pages.patch
debug-pagealloc-add-support-for-highmem-pages-fix.patch

