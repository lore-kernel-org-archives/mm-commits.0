From: akpm@linux-foundation.org
Subject: - h8300-fix-section-mismatch.patch removed from -mm tree
Date: Wed, 13 Aug 2008 01:52:22 -0700
Message-ID: <200808130852.m7D8qMrR008201@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39578 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752232AbYHMJCd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Aug 2008 05:02:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     h8300: fix section mismatches
has been removed from the -mm tree.  Its filename was
     h8300-fix-section-mismatch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: h8300: fix section mismatches
From: Yoshinori Sato <ysato@users.sourceforge.jp>

WARNING: vmlinux.o(.text+0x2fdf): Section mismatch in reference from the variable .LM3 to the variable .init.text:___alloc_bootmem
The function .LM3() references
the variable __init ___alloc_bootmem.
This is often because .LM3 lacks a __init
annotation or the annotation of ___alloc_bootmem is wrong.

WARNING: vmlinux.o(.text+0x2ff5): Section mismatch in reference from the variable .LM4 to the variable .init.text:___alloc_bootmem
The function .LM4() references
the variable __init ___alloc_bootmem.
This is often because .LM4 lacks a __init
annotation or the annotation of ___alloc_bootmem is wrong.

WARNING: vmlinux.o(.text+0x300b): Section mismatch in reference from the variable .LM5 to the variable .init.text:___alloc_bootmem
The function .LM5() references
the variable __init ___alloc_bootmem.
This is often because .LM5 lacks a __init
annotation or the annotation of ___alloc_bootmem is wrong.

WARNING: vmlinux.o(.text+0x304b): Section mismatch in reference from the variable .LM10 to the variable .init.text:_free_area_init
The function .LM10() references
the variable __init _free_area_init.
This is often because .LM10 lacks a __init
annotation or the annotation of _free_area_init is wrong.

WARNING: vmlinux.o(.text+0x30a3): Section mismatch in reference from the variable .LM17 to the variable .init.text:_free_all_bootmem
The function .LM17() references
the variable __init _free_all_bootmem.
This is often because .LM17 lacks a __init
annotation or the annotation of _free_all_bootmem is wrong.

Signed-off-by: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/h8300/mm/init.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff -puN arch/h8300/mm/init.c~h8300-fix-section-mismatch arch/h8300/mm/init.c
--- a/arch/h8300/mm/init.c~h8300-fix-section-mismatch
+++ a/arch/h8300/mm/init.c
@@ -40,9 +40,6 @@
 
 #undef DEBUG
 
-extern void die_if_kernel(char *,struct pt_regs *,long);
-extern void free_initmem(void);
-
 /*
  * BAD_PAGE is the page that is used for page faults when linux
  * is out-of-memory. Older versions of linux just did a
@@ -73,7 +70,7 @@ extern unsigned long memory_end;
  * The parameters are pointers to where to stick the starting and ending
  * addresses of available kernel virtual memory.
  */
-void paging_init(void)
+void __init paging_init(void)
 {
 	/*
 	 * Make sure start_mem is page aligned,  otherwise bootmem and
@@ -122,7 +119,7 @@ void paging_init(void)
 	}
 }
 
-void mem_init(void)
+void __init mem_init(void)
 {
 	int codek = 0, datak = 0, initk = 0;
 	/* DAVIDM look at setup memory map generically with reserved area */
@@ -178,7 +175,7 @@ void free_initrd_mem(unsigned long start
 #endif
 
 void
-free_initmem()
+free_initmem(void)
 {
 #ifdef CONFIG_RAMKERNEL
 	unsigned long addr;
_

Patches currently in -mm which might be from ysato@users.sourceforge.jp are

linux-next.patch
h8300-kallsyms-exclude-local-symbols.patch
h8300-kallsyms-exclude-local-symbols-update.patch
h8300-update-timer-handler-delete-files.patch
h8300-update-timer-handler-new-files.patch
h8300-update-timer-handler-misc-update.patch
h8300-kconfig-cleanup.patch
h8300-generic_bug-support.patch
h8300-generic_bug-support-checkpatch-fixes.patch
asm-h8300-mdh-remove-cvs-keyword.patch
alpha-miata-remove-dead-url.patch

