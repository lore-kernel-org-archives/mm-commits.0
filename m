From: akpm@linux-foundation.org
Subject: - x86-64-fix-overlap-of-modules-and-fixmap-areas.patch removed from -mm tree
Date: Mon, 18 Aug 2008 12:40:37 -0700
Message-ID: <200808181940.m7IJebA6008473@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49983 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754634AbYHRTw6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Aug 2008 15:52:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbeulich@novell.com, hpa@zytor.com, jeremy@goop.org, mingo@elte.hu, stable@kernel.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86-64: fix overlap of modules and fixmap areas
has been removed from the -mm tree.  Its filename was
     x86-64-fix-overlap-of-modules-and-fixmap-areas.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86-64: fix overlap of modules and fixmap areas
From: "Jan Beulich" <jbeulich@novell.com>

Plus add a build time check so this doesn't go unnoticed again.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: <stable@kernel.org>

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

