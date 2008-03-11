From: akpm@linux-foundation.org
Subject: + x86-remove-redundant-display-of-free-swap-space-in-show_mem.patch added to -mm tree
Date: Mon, 10 Mar 2008 22:54:39 -0700
Message-ID: <200803110554.m2B5sdar025160@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54453 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753522AbYCKFzI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Mar 2008 01:55:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@saeurebad.de, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86: remove redundant display of free swap space in show_mem()
has been added to the -mm tree.  Its filename is
     x86-remove-redundant-display-of-free-swap-space-in-show_mem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: remove redundant display of free swap space in show_mem()
From: Johannes Weiner <hannes@saeurebad.de>

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

arm-remove-redundant-display-of-free-swap-space-in-show_mem.patch
cris-remove-redundant-display-of-free-swap-space-in-show_mem.patch
m68k-remove-redundant-display-of-free-swap-space-in-show_mem.patch
mips-remove-redundant-display-of-free-swap-space-in-show_mem.patch
powerpc-remove-redundant-display-of-free-swap-space-in-show_mem.patch
ppc-remove-redundant-display-of-free-swap-space-in-show_mem.patch
s390-remove-redundant-display-of-free-swap-space-in-show_mem.patch
x86-remove-redundant-display-of-free-swap-space-in-show_mem.patch
xtensa-remove-redundant-display-of-free-swap-space-in-show_mem.patch
parisc-remove-redundant-display-of-free-swap-space-in-show_mem.patch
ia64-remove-redundant-display-of-free-swap-space-in-show_mem.patch

