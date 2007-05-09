From: akpm@linux-foundation.org
Subject: - x86_64-kill-19000-sparse-warnings.patch removed from -mm tree
Date: Tue, 08 May 2007 19:51:46 -0700
Message-ID: <200705090251.l492pkDa009494@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41121 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032189AbXEICv7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:51:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     x86_64: kill 19000+ sparse warnings
has been removed from the -mm tree.  Its filename was
     x86_64-kill-19000-sparse-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64: kill 19000+ sparse warnings
From: Randy Dunlap <randy.dunlap@oracle.com>

Eliminate 19439 (!!) sparse warnings like:
include/linux/mm.h:321:22: warning: constant 0xffff810000000000 is so big it is unsigned long

Eliminate 56 sparse warnings like:
arch/x86_64/kernel/setup.c:248:16: warning: constant 0xffffffff80000000 is so big it is unsigned long

Eliminate 5 sparse warnings like:
arch/x86_64/kernel/module.c:49:13: warning: constant 0xfffffffffff00000 is so big it is unsigned long

Eliminate 23 sparse warnings like:
arch/x86_64/mm/init.c:551:37: warning: constant 0xffffc20000000000 is so big it is unsigned long

Eliminate 6 sparse warnings like:
arch/x86_64/kernel/module.c:49:13: warning: constant 0xffffffff88000000 is so big it is unsigned long

Eliminate 23 sparse warnings like:
arch/x86_64/mm/init.c:552:6: warning: constant 0xffffe1ffffffffff is so big it is unsigned long

Eliminate 3 sparse warnings like:
arch/x86_64/kernel/e820.c:186:17: warning: constant 0x3fffffffffff is so big it is long

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-x86_64/page.h    |    7 ++++---
 include/asm-x86_64/pgtable.h |   10 +++++-----
 2 files changed, 9 insertions(+), 8 deletions(-)

diff -puN include/asm-x86_64/page.h~x86_64-kill-19000-sparse-warnings include/asm-x86_64/page.h
--- a/include/asm-x86_64/page.h~x86_64-kill-19000-sparse-warnings
+++ a/include/asm-x86_64/page.h
@@ -79,9 +79,10 @@ extern unsigned long phys_base;
 
 #define __PHYSICAL_START	CONFIG_PHYSICAL_START
 #define __KERNEL_ALIGN		0x200000
+
 #define __START_KERNEL		(__START_KERNEL_map + __PHYSICAL_START)
-#define __START_KERNEL_map	0xffffffff80000000
-#define __PAGE_OFFSET           0xffff810000000000
+#define __START_KERNEL_map	_AC(0xffffffff80000000, UL)
+#define __PAGE_OFFSET           _AC(0xffff810000000000, UL)
 
 /* to align the pointer to the (next) page boundary */
 #define PAGE_ALIGN(addr)	(((addr)+PAGE_SIZE-1)&PAGE_MASK)
@@ -93,7 +94,7 @@ extern unsigned long phys_base;
 #define __VIRTUAL_MASK		((_AC(1,UL) << __VIRTUAL_MASK_SHIFT) - 1)
 
 #define KERNEL_TEXT_SIZE  (40*1024*1024)
-#define KERNEL_TEXT_START 0xffffffff80000000
+#define KERNEL_TEXT_START _AC(0xffffffff80000000, UL)
 #define PAGE_OFFSET		__PAGE_OFFSET
 
 #ifndef __ASSEMBLY__
diff -puN include/asm-x86_64/pgtable.h~x86_64-kill-19000-sparse-warnings include/asm-x86_64/pgtable.h
--- a/include/asm-x86_64/pgtable.h~x86_64-kill-19000-sparse-warnings
+++ a/include/asm-x86_64/pgtable.h
@@ -134,11 +134,11 @@ static inline pte_t ptep_get_and_clear_f
 #define USER_PTRS_PER_PGD	((TASK_SIZE-1)/PGDIR_SIZE+1)
 #define FIRST_USER_ADDRESS	0
 
-#define MAXMEM		 0x3fffffffffff
-#define VMALLOC_START    0xffffc20000000000
-#define VMALLOC_END      0xffffe1ffffffffff
-#define MODULES_VADDR    0xffffffff88000000
-#define MODULES_END      0xfffffffffff00000
+#define MAXMEM		 _AC(0x3fffffffffff, UL)
+#define VMALLOC_START    _AC(0xffffc20000000000, UL)
+#define VMALLOC_END      _AC(0xffffe1ffffffffff, UL)
+#define MODULES_VADDR    _AC(0xffffffff88000000, UL)
+#define MODULES_END      _AC(0xfffffffffff00000, UL)
 #define MODULES_LEN   (MODULES_END - MODULES_VADDR)
 
 #define _PAGE_BIT_PRESENT	0
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
krealloc-fix-kerneldoc-comments.patch
git-acpi.patch
git-ieee1394.patch
romfs-printk-format-warnings.patch
add-pci_try_set_mwi.patch
git-unionfs.patch
git-ipwireless_cs.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-doc-fix.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
lib-hexdump.patch
lib-hexdump-fix.patch
lib-hexdump-update-on-feedback.patch
doc-what-a-patch-series-is.patch
kernel-doc-small-kernel-doc-optimization.patch
profile-likely-unlikely-macros.patch
