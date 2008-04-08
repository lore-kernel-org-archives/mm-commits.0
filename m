From: akpm@linux-foundation.org
Subject: - x86-remove-redundant-display-of-free-swap-space-in-show_mem.patch removed from -mm tree
Date: Tue, 08 Apr 2008 11:59:01 -0700
Message-ID: <200804081859.m38Ix1v4006943@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52402 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753703AbYDHS70 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2008 14:59:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@saeurebad.de, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86: remove redundant display of free swap space in show_mem()
has been removed from the -mm tree.  Its filename was
     x86-remove-redundant-display-of-free-swap-space-in-show_mem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: remove redundant display of free swap space in show_mem()
From: Johannes Weiner <hannes@saeurebad.de>

show_mem() has no need to print the amount of free swap space manually because
show_free_areas() does this already and is called by the former.

The two outputs only differ in text formatting:

  printk("Free swap  = %lukB\n", ...);
  printk("Free swap:       %6ldkB\n", ...);

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init_64.c    |    3 ---
 arch/x86/mm/pgtable_32.c |    1 -
 2 files changed, 4 deletions(-)

diff -puN arch/x86/mm/init_64.c~x86-remove-redundant-display-of-free-swap-space-in-show_mem arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~x86-remove-redundant-display-of-free-swap-space-in-show_mem
+++ a/arch/x86/mm/init_64.c
@@ -89,9 +89,6 @@ void show_mem(void)
 
 	printk(KERN_INFO "Mem-info:\n");
 	show_free_areas();
-	printk(KERN_INFO "Free swap:       %6ldkB\n",
-		nr_swap_pages << (PAGE_SHIFT-10));
-
 	for_each_online_pgdat(pgdat) {
 		for (i = 0; i < pgdat->node_spanned_pages; ++i) {
 			/*
diff -puN arch/x86/mm/pgtable_32.c~x86-remove-redundant-display-of-free-swap-space-in-show_mem arch/x86/mm/pgtable_32.c
--- a/arch/x86/mm/pgtable_32.c~x86-remove-redundant-display-of-free-swap-space-in-show_mem
+++ a/arch/x86/mm/pgtable_32.c
@@ -36,7 +36,6 @@ void show_mem(void)
 
 	printk(KERN_INFO "Mem-info:\n");
 	show_free_areas();
-	printk(KERN_INFO "Free swap:       %6ldkB\n", nr_swap_pages<<(PAGE_SHIFT-10));
 	for_each_online_pgdat(pgdat) {
 		pgdat_resize_lock(pgdat, &flags);
 		for (i = 0; i < pgdat->node_spanned_pages; ++i) {
_

Patches currently in -mm which might be from hannes@saeurebad.de are

git-x86.patch
arm-remove-redundant-display-of-free-swap-space-in-show_mem.patch
git-powerpc.patch
ia64-remove-redundant-display-of-free-swap-space-in-show_mem.patch
git-mips.patch
parisc-remove-redundant-display-of-free-swap-space-in-show_mem.patch
git-xtensa.patch
mm-remove-unused-max_nodes_shift.patch
m68k-remove-redundant-display-of-free-swap-space-in-show_mem.patch
cris-remove-redundant-display-of-free-swap-space-in-show_mem.patch
add-warn_on_secs-macro-simplification.patch
add-warn_on_secs-macro-simplification-fix.patch
add-warn_on_secs-macro-simplification-fix-fix.patch

