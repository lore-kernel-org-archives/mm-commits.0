From: akpm@linux-foundation.org
Subject: - mm-print-out-meminit-for-memmap.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:33:50 -0700
Message-ID: <200810202033.m9KKXoJP010708@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44922 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753579AbYJTUe1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:34:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yhlu.kernel@gmail.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     mm: print out meminit for memmap
has been removed from the -mm tree.  Its filename was
     mm-print-out-meminit-for-memmap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: print out meminit for memmap
From: Yinghai Lu <yhlu.kernel@gmail.com>

Improve debuggability of memory setup problems.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN mm/page_alloc.c~mm-print-out-meminit-for-memmap mm/page_alloc.c
--- a/mm/page_alloc.c~mm-print-out-meminit-for-memmap
+++ a/mm/page_alloc.c
@@ -3457,8 +3457,8 @@ static void __paginginit free_area_init_
 			PAGE_ALIGN(size * sizeof(struct page)) >> PAGE_SHIFT;
 		if (realsize >= memmap_pages) {
 			realsize -= memmap_pages;
-			mminit_dprintk(MMINIT_TRACE, "memmap_init",
-				"%s zone: %lu pages used for memmap\n",
+			printk(KERN_DEBUG
+				"  %s zone: %lu pages used for memmap\n",
 				zone_names[j], memmap_pages);
 		} else
 			printk(KERN_WARNING
@@ -3468,8 +3468,7 @@ static void __paginginit free_area_init_
 		/* Account for reserved pages */
 		if (j == 0 && realsize > dma_reserve) {
 			realsize -= dma_reserve;
-			mminit_dprintk(MMINIT_TRACE, "memmap_init",
-					"%s zone: %lu pages reserved\n",
+			printk(KERN_DEBUG "  %s zone: %lu pages reserved\n",
 					zone_names[0], dma_reserve);
 		}
 
_

Patches currently in -mm which might be from yhlu.kernel@gmail.com are

origin.patch
linux-next.patch

