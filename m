From: akpm@linux-foundation.org
Subject: - h8300-use-generic-show_mem.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:17:50 -0700
Message-ID: <200807262117.m6QLHoSc020030@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59476 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757997AbYGZVSE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:18:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@saeurebad.de, ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     h8300: use generic show_mem()
has been removed from the -mm tree.  Its filename was
     h8300-use-generic-show_mem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: h8300: use generic show_mem()
From: Johannes Weiner <hannes@saeurebad.de>

Remove arch-specific show_mem() in favor of the generic version.

This also removes the following redundant information display:

	- free pages, printed by show_free_areas()
	- pages in swapcache, printed by show_swap_cache_info()

where show_mem() calls show_free_areas(), which calls
show_swap_cache_info().

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/h8300/mm/init.c |   27 ---------------------------
 1 file changed, 27 deletions(-)

diff -puN arch/h8300/mm/init.c~h8300-use-generic-show_mem arch/h8300/mm/init.c
--- a/arch/h8300/mm/init.c~h8300-use-generic-show_mem
+++ a/arch/h8300/mm/init.c
@@ -64,33 +64,6 @@ unsigned long empty_zero_page;
 
 extern unsigned long rom_length;
 
-void show_mem(void)
-{
-    unsigned long i;
-    int free = 0, total = 0, reserved = 0, shared = 0;
-    int cached = 0;
-
-    printk("\nMem-info:\n");
-    show_free_areas();
-    i = max_mapnr;
-    while (i-- > 0) {
-	total++;
-	if (PageReserved(mem_map+i))
-	    reserved++;
-	else if (PageSwapCache(mem_map+i))
-	    cached++;
-	else if (!page_count(mem_map+i))
-	    free++;
-	else
-	    shared += page_count(mem_map+i) - 1;
-    }
-    printk("%d pages of RAM\n",total);
-    printk("%d free pages\n",free);
-    printk("%d reserved pages\n",reserved);
-    printk("%d pages shared\n",shared);
-    printk("%d pages swap cached\n",cached);
-}
