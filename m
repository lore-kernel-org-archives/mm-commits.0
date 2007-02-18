From: akpm@linux-foundation.org
Subject: - i386-adjustments-to-page-table-dump-during-oops-v4.patch removed from -mm tree
Date: Sat, 17 Feb 2007 18:15:50 -0800
Message-ID: <200702180215.l1I2FoxU008432@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55731 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993129AbXBRCQB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 21:16:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbeulich@novell.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     i386: adjustments to page table dump during oops (v4)
has been removed from the -mm tree.  Its filename was
     i386-adjustments-to-page-table-dump-during-oops-v4.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386: adjustments to page table dump during oops (v4)
From: "Jan Beulich" <jbeulich@novell.com>

- make the page table contents printing PAE capable
- make sure the address stored in current->thread.cr2 is unmodified
  from what was read from CR2
- don't call oops_may_print() multiple times, when one time suffices
- print pte even in highpte case, as long as the pte page isn't in
  actually in high memory (which is specifically the case for all page
  tables covering kernel space)

(Changes to v3: Use sizeof()*2 rather than the suggested sizeof()*4 for
printing width, use fixed 16-nibble width for PAE, and also apply the
max_low_pfn range check to the middle level lookup on PAE.)

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/mm/fault.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff -puN arch/i386/mm/fault.c~i386-adjustments-to-page-table-dump-during-oops-v4 arch/i386/mm/fault.c
--- a/arch/i386/mm/fault.c~i386-adjustments-to-page-table-dump-during-oops-v4
+++ a/arch/i386/mm/fault.c
@@ -535,8 +535,9 @@ no_context:
 		page = read_cr3();
 		page = ((__typeof__(page) *) __va(page))[address >> PGDIR_SHIFT];
 #ifdef CONFIG_X86_PAE
-		printk(KERN_ALERT "*pdpt = %0*Lx\n", sizeof(page)*4, (u64)page);
-		if (page & _PAGE_PRESENT) {
+		printk(KERN_ALERT "*pdpt = %016Lx\n", page);
+		if ((page >> PAGE_SHIFT) < max_low_pfn
+		    && page & _PAGE_PRESENT) {
 			page &= PAGE_MASK;
 			page = ((__typeof__(page) *) __va(page))[(address >> PMD_SHIFT)
 			                                         & (PTRS_PER_PMD - 1)];
@@ -558,7 +559,7 @@ no_context:
 			page &= PAGE_MASK;
 			page = ((__typeof__(page) *) __va(page))[(address >> PAGE_SHIFT)
 			                                         & (PTRS_PER_PTE - 1)];
-			printk(KERN_ALERT "*pte = %0*Lx\n", sizeof(page)*4, (u64)page);
+			printk(KERN_ALERT "*pte = %0*Lx\n", sizeof(page)*2, (u64)page);
 		}
 	}
 
_

Patches currently in -mm which might be from jbeulich@novell.com are

origin.patch
adjust-legacy-ide-resource-setting-v2.patch
