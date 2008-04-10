From: akpm@linux-foundation.org
Subject: - ia64-remove-redundant-display-of-free-swap-space-in-show_mem.patch removed from -mm tree
Date: Thu, 10 Apr 2008 13:01:22 -0700
Message-ID: <200804102001.m3AK1MM1014969@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41398 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756757AbYDJUB7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Apr 2008 16:01:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@saeurebad.de, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     ia64: remove redundant display of free swap space in show_mem()
has been removed from the -mm tree.  Its filename was
     ia64-remove-redundant-display-of-free-swap-space-in-show_mem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ia64: remove redundant display of free swap space in show_mem()
From: Johannes Weiner <hannes@saeurebad.de>

show_mem() has no need to print the amount of free swap space manually because
show_free_areas() does this already and is called by the former.

The two outputs only differ in text formatting:

  printk("Free swap  = %lukB\n", ...);
  printk("Free swap:       %6ldkB\n", ...);

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/mm/contig.c    |    2 --
 arch/ia64/mm/discontig.c |    2 --
 2 files changed, 4 deletions(-)

diff -puN arch/ia64/mm/contig.c~ia64-remove-redundant-display-of-free-swap-space-in-show_mem arch/ia64/mm/contig.c
--- a/arch/ia64/mm/contig.c~ia64-remove-redundant-display-of-free-swap-space-in-show_mem
+++ a/arch/ia64/mm/contig.c
@@ -45,8 +45,6 @@ void show_mem(void)
 
 	printk(KERN_INFO "Mem-info:\n");
 	show_free_areas();
-	printk(KERN_INFO "Free swap:       %6ldkB\n",
-	       nr_swap_pages<<(PAGE_SHIFT-10));
 	printk(KERN_INFO "Node memory in pages:\n");
 	for_each_online_pgdat(pgdat) {
 		unsigned long present;
diff -puN arch/ia64/mm/discontig.c~ia64-remove-redundant-display-of-free-swap-space-in-show_mem arch/ia64/mm/discontig.c
--- a/arch/ia64/mm/discontig.c~ia64-remove-redundant-display-of-free-swap-space-in-show_mem
+++ a/arch/ia64/mm/discontig.c
@@ -522,8 +522,6 @@ void show_mem(void)
 
 	printk(KERN_INFO "Mem-info:\n");
 	show_free_areas();
-	printk(KERN_INFO "Free swap:       %6ldkB\n",
-	       nr_swap_pages<<(PAGE_SHIFT-10));
 	printk(KERN_INFO "Node memory in pages:\n");
 	for_each_online_pgdat(pgdat) {
 		unsigned long present;
_

Patches currently in -mm which might be from hannes@saeurebad.de are

git-x86.patch
arm-remove-redundant-display-of-free-swap-space-in-show_mem.patch
git-powerpc.patch
git-ia64.patch
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

