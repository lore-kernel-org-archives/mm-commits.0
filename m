From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-remove-useless-parameter-of-__free_pages_boot_core.patch
 removed from -mm tree
Date: Fri, 20 May 2016 14:04:35 -0700
Message-ID: <573f7be3.ZdqCsKa3LQPk93Y3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47004 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbcETVEg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 17:04:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhlcindy@linux.vnet.ibm.com, xinhui.pan@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: remove useless parameter of __free_pages_boot_core
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-remove-useless-parameter-of-__free_pages_boot_core.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Li Zhang <zhlcindy@linux.vnet.ibm.com>
Subject: mm/page_alloc: remove useless parameter of __free_pages_boot_core

__free_pages_boot_core has parameter pfn which is not used at all.  Remove
it.

Signed-off-by: Li Zhang <zhlcindy@linux.vnet.ibm.com>
Reviewed-by: Pan Xinhui <xinhui.pan@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-remove-useless-parameter-of-__free_pages_boot_core mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-remove-useless-parameter-of-__free_pages_boot_core
+++ a/mm/page_alloc.c
@@ -1076,8 +1076,7 @@ static void __free_pages_ok(struct page
 	local_irq_restore(flags);
 }
 
-static void __init __free_pages_boot_core(struct page *page,
-					unsigned long pfn, unsigned int order)
+static void __init __free_pages_boot_core(struct page *page, unsigned int order)
 {
 	unsigned int nr_pages = 1 << order;
 	struct page *p = page;
@@ -1154,7 +1153,7 @@ void __init __free_pages_bootmem(struct
 {
 	if (early_page_uninitialised(pfn))
 		return;
-	return __free_pages_boot_core(page, pfn, order);
+	return __free_pages_boot_core(page, order);
 }
 
 /*
@@ -1239,12 +1238,12 @@ static void __init deferred_free_range(s
 	if (nr_pages == MAX_ORDER_NR_PAGES &&
 	    (pfn & (MAX_ORDER_NR_PAGES-1)) == 0) {
 		set_pageblock_migratetype(page, MIGRATE_MOVABLE);
-		__free_pages_boot_core(page, pfn, MAX_ORDER-1);
+		__free_pages_boot_core(page, MAX_ORDER-1);
 		return;
 	}
 
-	for (i = 0; i < nr_pages; i++, page++, pfn++)
-		__free_pages_boot_core(page, pfn, 0);
+	for (i = 0; i < nr_pages; i++, page++)
+		__free_pages_boot_core(page, 0);
 }
 
 /* Completion tracking for deferred_init_memmap() threads */
_

Patches currently in -mm which might be from zhlcindy@linux.vnet.ibm.com are


