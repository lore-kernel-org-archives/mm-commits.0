From: akpm@linux-foundation.org
Subject: + x86-64-fix-overlap-of-modules-and-fixmap-areas.patch added to -mm tree
Date: Thu, 31 Jul 2008 14:33:52 -0700
Message-ID: <200807312133.m6VLXq5U013355@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43356 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754922AbYGaVeo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 Jul 2008 17:34:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbeulich@novell.com, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86-64: fix overlap of modules and fixmap areas
has been added to the -mm tree.  Its filename is
     x86-64-fix-overlap-of-modules-and-fixmap-areas.patch

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
Subject: x86-64: fix overlap of modules and fixmap areas
From: "Jan Beulich" <jbeulich@novell.com>

Plus add a build time check so this doesn't go unnoticed again.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/head64.c     |    1 +
 include/asm-x86/pgtable_64.h |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff -puN arch/x86/kernel/head64.c~x86-64-fix-overlap-of-modules-and-fixmap-areas arch/x86/kernel/head64.c
--- a/arch/x86/kernel/head64.c~x86-64-fix-overlap-of-modules-and-fixmap-areas
+++ a/arch/x86/kernel/head64.c
@@ -88,6 +88,7 @@ void __init x86_64_start_kernel(char * r
 	BUILD_BUG_ON(!(MODULES_VADDR > __START_KERNEL));
 	BUILD_BUG_ON(!(((MODULES_END - 1) & PGDIR_MASK) ==
 				(__START_KERNEL & PGDIR_MASK)));
+	BUILD_BUG_ON(__fix_to_virt(__end_of_fixed_addresses) <= MODULES_END);
 
 	/* clear bss before set_intr_gate with early_idt_handler */
 	clear_bss();
diff -puN include/asm-x86/pgtable_64.h~x86-64-fix-overlap-of-modules-and-fixmap-areas include/asm-x86/pgtable_64.h
--- a/include/asm-x86/pgtable_64.h~x86-64-fix-overlap-of-modules-and-fixmap-areas
+++ a/include/asm-x86/pgtable_64.h
@@ -151,7 +151,7 @@ static inline void native_pgd_clear(pgd_
 #define VMALLOC_END      _AC(0xffffe1ffffffffff, UL)
 #define VMEMMAP_START	 _AC(0xffffe20000000000, UL)
 #define MODULES_VADDR    _AC(0xffffffffa0000000, UL)
-#define MODULES_END      _AC(0xfffffffffff00000, UL)
+#define MODULES_END      _AC(0xffffffffff000000, UL)
 #define MODULES_LEN   (MODULES_END - MODULES_VADDR)
 
 #ifndef __ASSEMBLY__
_

Patches currently in -mm which might be from jbeulich@novell.com are

origin.patch
x86-64-fix-overlap-of-modules-and-fixmap-areas.patch
dma-fix-order-calculation-in-dma_mark_declared_memory_occupied.patch

