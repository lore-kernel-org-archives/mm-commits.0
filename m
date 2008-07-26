From: akpm@linux-foundation.org
Subject: - cris-use-generic-show_mem.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:18:02 -0700
Message-ID: <200807262118.m6QLI2Yh020054@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32960 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758023AbYGZVSH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:18:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@saeurebad.de, starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     cris: use generic show_mem()
has been removed from the -mm tree.  Its filename was
     cris-use-generic-show_mem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cris: use generic show_mem()
From: Johannes Weiner <hannes@saeurebad.de>

Remove arch-specific show_mem() in favor of the generic version.

This also removes the following redundant information display:

	- free pages, printed by show_free_areas()
	- pages in swapcache, printed by show_swap_cache_info()

where show_mem() calls show_free_areas(), which calls
show_swap_cache_info().

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Acked-by: Mikael Starvik <starvik@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/mm/init.c |   30 ------------------------------
 1 file changed, 30 deletions(-)

diff -puN arch/cris/mm/init.c~cris-use-generic-show_mem arch/cris/mm/init.c
--- a/arch/cris/mm/init.c~cris-use-generic-show_mem
+++ a/arch/cris/mm/init.c
@@ -19,36 +19,6 @@ unsigned long empty_zero_page;
 extern char _stext, _edata, _etext; /* From linkerscript */
 extern char __init_begin, __init_end;
 
-void 
-show_mem(void)
-{
-	int i,free = 0,total = 0,cached = 0, reserved = 0, nonshared = 0;
-	int shared = 0;
-
-	printk("\nMem-info:\n");
-	show_free_areas();
-	i = max_mapnr;
-	while (i-- > 0) {
-		total++;
-		if (PageReserved(mem_map+i))
-			reserved++;
-		else if (PageSwapCache(mem_map+i))
-			cached++;
-		else if (!page_count(mem_map+i))
-			free++;
-		else if (page_count(mem_map+i) == 1)
-			nonshared++;
-		else
-			shared += page_count(mem_map+i) - 1;
-	}
-	printk("%d pages of RAM\n",total);
-	printk("%d free pages\n",free);
-	printk("%d reserved pages\n",reserved);
-	printk("%d pages nonshared\n",nonshared);
-	printk("%d pages shared\n",shared);
-	printk("%d pages swap cached\n",cached);
-}
