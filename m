From: akpm@linux-foundation.org
Subject: - xtensa-use-generic-show_mem.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:17:34 -0700
Message-ID: <200807262117.m6QLHYqP020006@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55960 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757895AbYGZVRi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:17:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@saeurebad.de, chris@zankel.net, mm-commits@vger.kernel.org


The patch titled
     xtensa: use generic show_mem()
has been removed from the -mm tree.  Its filename was
     xtensa-use-generic-show_mem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: xtensa: use generic show_mem()
From: Johannes Weiner <hannes@saeurebad.de>

Remove arch-specific show_mem() in favor of the generic version.

This also removes the following redundant information display:

	- free pages, printed by show_free_areas()
	- pages in swapcache, printed by show_swap_cache_info()

where show_mem() calls show_free_areas(), which calls
show_swap_cache_info().

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Cc: Chris Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/mm/init.c |   27 ---------------------------
 1 file changed, 27 deletions(-)

diff -puN arch/xtensa/mm/init.c~xtensa-use-generic-show_mem arch/xtensa/mm/init.c
--- a/arch/xtensa/mm/init.c~xtensa-use-generic-show_mem
+++ a/arch/xtensa/mm/init.c
@@ -280,33 +280,6 @@ void free_initmem(void)
 	       (&__init_end - &__init_begin) >> 10);
 }
 
-void show_mem(void)
-{
-	int i, free = 0, total = 0, reserved = 0;
-	int shared = 0, cached = 0;
-
-	printk("Mem-info:\n");
-	show_free_areas();
-	printk("Free swap:       %6ldkB\n", nr_swap_pages<<(PAGE_SHIFT-10));
-	i = max_mapnr;
-	while (i-- > 0) {
-		total++;
-		if (PageReserved(mem_map+i))
-			reserved++;
-		else if (PageSwapCache(mem_map+i))
-			cached++;
-		else if (!page_count(mem_map + i))
-			free++;
-		else
-			shared += page_count(mem_map + i) - 1;
-	}
-	printk("%d pages of RAM\n", total);
-	printk("%d reserved pages\n", reserved);
-	printk("%d pages shared\n", shared);
-	printk("%d pages swap cached\n",cached);
-	printk("%d free pages\n", free);
-}
