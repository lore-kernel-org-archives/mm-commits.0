From: akpm@linux-foundation.org
Subject: - powerpc-remove-redundant-display-of-free-swap-space-in-show_mem.patch removed from -mm tree
Date: Tue, 01 Apr 2008 14:37:50 -0700
Message-ID: <200804012137.m31Lborj014865@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47658 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760484AbYDAVh5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Apr 2008 17:37:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@saeurebad.de, benh@kernel.crashing.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     powerpc: remove redundant display of free swap space in show_mem()
has been removed from the -mm tree.  Its filename was
     powerpc-remove-redundant-display-of-free-swap-space-in-show_mem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: powerpc: remove redundant display of free swap space in show_mem()
From: Johannes Weiner <hannes@saeurebad.de>

show_mem() has no need to print the amount of free swap space manually because
show_free_areas() does this already and is called by the former.

The two outputs only differ in text formatting:

  printk("Free swap  = %lukB\n", ...);
  printk("Free swap:       %6ldkB\n", ...);

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/mem.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/powerpc/mm/mem.c~powerpc-remove-redundant-display-of-free-swap-space-in-show_mem arch/powerpc/mm/mem.c
--- a/arch/powerpc/mm/mem.c~powerpc-remove-redundant-display-of-free-swap-space-in-show_mem
+++ a/arch/powerpc/mm/mem.c
@@ -175,7 +175,6 @@ void show_mem(void)
 
 	printk("Mem-info:\n");
 	show_free_areas();
-	printk("Free swap:       %6ldkB\n", nr_swap_pages<<(PAGE_SHIFT-10));
 	for_each_online_pgdat(pgdat) {
 		unsigned long flags;
 		pgdat_resize_lock(pgdat, &flags);
_

Patches currently in -mm which might be from hannes@saeurebad.de are

x86-remove-redundant-display-of-free-swap-space-in-show_mem.patch
arm-remove-redundant-display-of-free-swap-space-in-show_mem.patch
git-powerpc.patch
ia64-remove-redundant-display-of-free-swap-space-in-show_mem.patch
git-mips.patch
parisc-remove-redundant-display-of-free-swap-space-in-show_mem.patch
git-s390.patch
git-xtensa.patch
mm-remove-unused-max_nodes_shift.patch
m68k-remove-redundant-display-of-free-swap-space-in-show_mem.patch
cris-remove-redundant-display-of-free-swap-space-in-show_mem.patch
add-warn_on_secs-macro-simplification.patch
add-warn_on_secs-macro-simplification-fix.patch
add-warn_on_secs-macro-simplification-fix-fix.patch

