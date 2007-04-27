From: akpm@linux-foundation.org
Subject: + x86_64-kill-19000-sparse-warnings.patch added to -mm tree
Date: Fri, 27 Apr 2007 00:31:36 -0700
Message-ID: <200704270731.l3R7VaAp022275@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55827 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754153AbXD0HcM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Apr 2007 03:32:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, ak@suse.de


The patch titled
     x86_64: kill 19000+ sparse warnings
has been added to the -mm tree.  Its filename is
     x86_64-kill-19000-sparse-warnings.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

 include/asm-x86_64/page.h    |   11 +++++++++++
 include/asm-x86_64/pgtable.h |    9 +++++++++
 2 files changed, 20 insertions(+)

diff -puN include/asm-x86_64/page.h~x86_64-kill-19000-sparse-warnings include/asm-x86_64/page.h
--- a/include/asm-x86_64/page.h~x86_64-kill-19000-sparse-warnings
+++ a/include/asm-x86_64/page.h
@@ -79,9 +79,16 @@ extern unsigned long phys_base;
 
 #define __PHYSICAL_START	CONFIG_PHYSICAL_START
 #define __KERNEL_ALIGN		0x200000
+
+#ifdef __ASSEMBLY__
 #define __START_KERNEL		(__START_KERNEL_map + __PHYSICAL_START)
 #define __START_KERNEL_map	0xffffffff80000000
 #define __PAGE_OFFSET           0xffff810000000000
+#else
+#define __START_KERNEL		(__START_KERNEL_map + __PHYSICAL_START)
+#define __START_KERNEL_map	0xffffffff80000000UL
+#define __PAGE_OFFSET           0xffff810000000000UL
+#endif
 
 /* to align the pointer to the (next) page boundary */
 #define PAGE_ALIGN(addr)	(((addr)+PAGE_SIZE-1)&PAGE_MASK)
@@ -93,7 +100,11 @@ extern unsigned long phys_base;
 #define __VIRTUAL_MASK		((_AC(1,UL) << __VIRTUAL_MASK_SHIFT) - 1)
 
 #define KERNEL_TEXT_SIZE  (40*1024*1024)
+#ifdef __ASSEMBLY__
 #define KERNEL_TEXT_START 0xffffffff80000000
+#else
+#define KERNEL_TEXT_START 0xffffffff80000000UL
+#endif
 
 #ifndef __ASSEMBLY__
 
diff -puN include/asm-x86_64/pgtable.h~x86_64-kill-19000-sparse-warnings include/asm-x86_64/pgtable.h
--- a/include/asm-x86_64/pgtable.h~x86_64-kill-19000-sparse-warnings
+++ a/include/asm-x86_64/pgtable.h
@@ -134,12 +134,21 @@ static inline pte_t ptep_get_and_clear_f
 #define USER_PTRS_PER_PGD	((TASK_SIZE-1)/PGDIR_SIZE+1)
 #define FIRST_USER_ADDRESS	0
 
+#ifdef __ASSEMBLY__
 #define MAXMEM		 0x3fffffffffff
 #define VMALLOC_START    0xffffc20000000000
 #define VMALLOC_END      0xffffe1ffffffffff
 #define MODULES_VADDR    0xffffffff88000000
 #define MODULES_END      0xfffffffffff00000
 #define MODULES_LEN   (MODULES_END - MODULES_VADDR)
+#else
+#define MAXMEM		 0x3fffffffffffUL
+#define VMALLOC_START    0xffffc20000000000UL
+#define VMALLOC_END      0xffffe1ffffffffffUL
+#define MODULES_VADDR    0xffffffff88000000UL
+#define MODULES_END      0xfffffffffff00000UL
+#define MODULES_LEN   (MODULES_END - MODULES_VADDR)
+#endif
 
 #define _PAGE_BIT_PRESENT	0
 #define _PAGE_BIT_RW		1
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

git-acpi.patch
git-drm.patch
git-ieee1394.patch
git-kbuild.patch
romfs-printk-format-warnings.patch
git-netdev-all.patch
8250_pci-fix-pci-must_checks.patch
git-scsi-misc.patch
git-ipwireless_cs.patch
fix-mtrr-sections.patch
x86_64-kill-19000-sparse-warnings.patch
scripts-kernel-doc-whitespace-cleanup.patch
reiserfs-proc-support-requires-proc_fs.patch
kprobes-fix-sparse-null-warning.patch
header-cleaning-dont-include-smp_lockh-when-not-used.patch
expose-range-checking-functions-from-arch-specific.patch
expose-range-checking-functions-from-arch-specific-update.patch
expose-range-checking-functions-from-arch-specific-update-fix.patch
parport_serial-fix-pci-must_checks.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
kernel-doc-handle-arrays-with-arithmetic-expressions-as.patch
generate-main-index-page-when-building-htmldocs.patch
alphabetically-sorted-entries-in.patch
kernel-doc-html-mode-struct-highlights.patch
taskstats-fix-getdelays-usage-information.patch
introduce-a-handy-list_first_entry-macro-v2.patch
add-pci_try_set_mwi.patch
some-grammatical-fixups-and-additions-to-atomich-kernel-doc.patch
s3fb-fix-pci-must_checks.patch
profile-likely-unlikely-macros.patch
