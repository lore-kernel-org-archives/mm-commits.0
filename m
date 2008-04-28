From: akpm@linux-foundation.org
Subject: - m68k-remove-redundant-display-of-free-swap-space-in-show_mem.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:54:36 -0700
Message-ID: <200804282154.m3SLsaLu018023@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58961 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932523AbYD1Vyu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:54:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@saeurebad.de, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     m68k: remove redundant display of free swap space in show_mem()
has been removed from the -mm tree.  Its filename was
     m68k-remove-redundant-display-of-free-swap-space-in-show_mem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: m68k: remove redundant display of free swap space in show_mem()
From: Johannes Weiner <hannes@saeurebad.de>

show_mem() has no need to print the amount of free swap space manually because
show_free_areas() does this already and is called by the former.

The two outputs only differ in text formatting:

  printk("Free swap  = %lukB\n", ...);
  printk("Free swap:       %6ldkB\n", ...);

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/mm/init.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/m68k/mm/init.c~m68k-remove-redundant-display-of-free-swap-space-in-show_mem arch/m68k/mm/init.c
--- a/arch/m68k/mm/init.c~m68k-remove-redundant-display-of-free-swap-space-in-show_mem
+++ a/arch/m68k/mm/init.c
@@ -79,7 +79,6 @@ void show_mem(void)
 
 	printk("\nMem-info:\n");
 	show_free_areas();
-	printk("Free swap:       %6ldkB\n", nr_swap_pages<<(PAGE_SHIFT-10));
 	for_each_online_pgdat(pgdat) {
 		for (i = 0; i < pgdat->node_spanned_pages; i++) {
 			struct page *page = pgdat->node_mem_map + i;
_

Patches currently in -mm which might be from hannes@saeurebad.de are

origin.patch
git-mips.patch
parisc-remove-redundant-display-of-free-swap-space-in-show_mem.patch
git-xtensa.patch
add-warn_on_secs-macro-simplification.patch
add-warn_on_secs-macro-simplification-fix.patch
add-warn_on_secs-macro-simplification-fix-fix.patch

