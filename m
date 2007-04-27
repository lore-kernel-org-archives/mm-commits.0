From: akpm@linux-foundation.org
Subject: + consolidate-asm-consth-to-linux-consth.patch added to -mm tree
Date: Fri, 27 Apr 2007 00:35:27 -0700
Message-ID: <200704270735.l3R7ZRf7022332@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:33501 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754141AbXD0HgH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Apr 2007 03:36:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, ak@suse.de, davem@davemloft.net


The patch titled
     consolidate asm/const.h to linux/const.h
has been added to the -mm tree.  Its filename is
     consolidate-asm-consth-to-linux-consth.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: consolidate asm/const.h to linux/const.h
From: Randy Dunlap <randy.dunlap@oracle.com>

Make a global linux/const.h header file instead of having multiple,
per-arch files, and convert current users of asm/const.h to use
linux/const.h.

Built on x86_64 and sparc64.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-sparc64/Kbuild    |    1 -
 include/asm-sparc64/const.h   |   19 -------------------
 include/asm-sparc64/lsu.h     |    2 +-
 include/asm-sparc64/mmu.h     |    2 +-
 include/asm-sparc64/page.h    |    2 +-
 include/asm-sparc64/pgtable.h |    2 +-
 include/asm-sparc64/pstate.h  |    2 +-
 include/asm-sparc64/sfafsr.h  |    2 +-
 include/asm-x86_64/const.h    |   20 --------------------
 include/asm-x86_64/page.h     |    2 +-
 include/asm-x86_64/pgtable.h  |    2 +-
 include/linux/Kbuild          |    1 +
 include/linux/const.h         |   19 +++++++++++++++++++
 13 files changed, 28 insertions(+), 48 deletions(-)

diff -puN include/asm-sparc64/const.h~consolidate-asm-consth-to-linux-consth /dev/null
--- a/include/asm-sparc64/const.h
+++ /dev/null
@@ -1,19 +0,0 @@
-/* const.h: Macros for dealing with constants.  */
-
-#ifndef _SPARC64_CONST_H
-#define _SPARC64_CONST_H
-
-/* Some constant macros are used in both assembler and
- * C code.  Therefore we cannot annotate them always with
- * 'UL' and other type specificers unilaterally.  We
- * use the following macros to deal with this.
- */
-
-#ifdef __ASSEMBLY__
-#define _AC(X,Y)	X
-#else
-#define _AC(X,Y)	(X##Y)
-#endif
-
-
-#endif /* !(_SPARC64_CONST_H) */
diff -puN include/asm-sparc64/Kbuild~consolidate-asm-consth-to-linux-consth include/asm-sparc64/Kbuild
--- a/include/asm-sparc64/Kbuild~consolidate-asm-consth-to-linux-consth
+++ a/include/asm-sparc64/Kbuild
@@ -8,7 +8,6 @@ header-y += apb.h
 header-y += asi.h
 header-y += bbc.h
 header-y += bpp.h
-header-y += const.h
 header-y += display7seg.h
 header-y += envctrl.h
 header-y += ipc.h
diff -puN include/asm-sparc64/lsu.h~consolidate-asm-consth-to-linux-consth include/asm-sparc64/lsu.h
--- a/include/asm-sparc64/lsu.h~consolidate-asm-consth-to-linux-consth
+++ a/include/asm-sparc64/lsu.h
@@ -2,7 +2,7 @@
 #ifndef _SPARC64_LSU_H
 #define _SPARC64_LSU_H
 
-#include <asm/const.h>
+#include <linux/const.h>
 
 /* LSU Control Register */
 #define LSU_CONTROL_PM _AC(0x000001fe00000000,UL) /* Phys-watchpoint byte mask*/
diff -puN include/asm-sparc64/mmu.h~consolidate-asm-consth-to-linux-consth include/asm-sparc64/mmu.h
--- a/include/asm-sparc64/mmu.h~consolidate-asm-consth-to-linux-consth
+++ a/include/asm-sparc64/mmu.h
@@ -1,8 +1,8 @@
 #ifndef __MMU_H
 #define __MMU_H
 
+#include <linux/const.h>
 #include <asm/page.h>
-#include <asm/const.h>
 #include <asm/hypervisor.h>
 
 #define CTX_NR_BITS		13
diff -puN include/asm-sparc64/page.h~consolidate-asm-consth-to-linux-consth include/asm-sparc64/page.h
--- a/include/asm-sparc64/page.h~consolidate-asm-consth-to-linux-consth
+++ a/include/asm-sparc64/page.h
@@ -5,7 +5,7 @@
 
 #ifdef __KERNEL__
 
-#include <asm/const.h>
+#include <linux/const.h>
 
 #if defined(CONFIG_SPARC64_PAGE_SIZE_8KB)
 #define PAGE_SHIFT   13
diff -puN include/asm-sparc64/pgtable.h~consolidate-asm-consth-to-linux-consth include/asm-sparc64/pgtable.h
--- a/include/asm-sparc64/pgtable.h~consolidate-asm-consth-to-linux-consth
+++ a/include/asm-sparc64/pgtable.h
@@ -15,13 +15,13 @@
 #include <asm-generic/pgtable-nopud.h>
 
 #include <linux/compiler.h>
+#include <linux/const.h>
 #include <asm/types.h>
 #include <asm/spitfire.h>
 #include <asm/asi.h>
 #include <asm/system.h>
 #include <asm/page.h>
 #include <asm/processor.h>
-#include <asm/const.h>
 
 /* The kernel image occupies 0x4000000 to 0x1000000 (4MB --> 32MB).
  * The page copy blockops can use 0x2000000 to 0x4000000.
diff -puN include/asm-sparc64/pstate.h~consolidate-asm-consth-to-linux-consth include/asm-sparc64/pstate.h
--- a/include/asm-sparc64/pstate.h~consolidate-asm-consth-to-linux-consth
+++ a/include/asm-sparc64/pstate.h
@@ -2,7 +2,7 @@
 #ifndef _SPARC64_PSTATE_H
 #define _SPARC64_PSTATE_H
 
-#include <asm/const.h>
+#include <linux/const.h>
 
 /* The V9 PSTATE Register (with SpitFire extensions).
  *
diff -puN include/asm-sparc64/sfafsr.h~consolidate-asm-consth-to-linux-consth include/asm-sparc64/sfafsr.h
--- a/include/asm-sparc64/sfafsr.h~consolidate-asm-consth-to-linux-consth
+++ a/include/asm-sparc64/sfafsr.h
@@ -1,7 +1,7 @@
 #ifndef _SPARC64_SFAFSR_H
 #define _SPARC64_SFAFSR_H
 
-#include <asm/const.h>
+#include <linux/const.h>
 
 /* Spitfire Asynchronous Fault Status register, ASI=0x4C VA<63:0>=0x0 */
 
diff -puN include/asm-x86_64/const.h~consolidate-asm-consth-to-linux-consth /dev/null
--- a/include/asm-x86_64/const.h
+++ /dev/null
@@ -1,20 +0,0 @@
-/* const.h: Macros for dealing with constants.  */
-
-#ifndef _X86_64_CONST_H
-#define _X86_64_CONST_H
-
-/* Some constant macros are used in both assembler and
- * C code.  Therefore we cannot annotate them always with
- * 'UL' and other type specificers unilaterally.  We
- * use the following macros to deal with this.
- */
-
-#ifdef __ASSEMBLY__
-#define _AC(X,Y)	X
-#else
-#define __AC(X,Y)	(X##Y)
-#define _AC(X,Y)	__AC(X,Y)
-#endif
-
-
-#endif /* !(_X86_64_CONST_H) */
diff -puN include/asm-x86_64/page.h~consolidate-asm-consth-to-linux-consth include/asm-x86_64/page.h
--- a/include/asm-x86_64/page.h~consolidate-asm-consth-to-linux-consth
+++ a/include/asm-x86_64/page.h
@@ -1,7 +1,7 @@
 #ifndef _X86_64_PAGE_H
 #define _X86_64_PAGE_H
 
-#include <asm/const.h>
+#include <linux/const.h>
 
 /* PAGE_SHIFT determines the page size */
 #define PAGE_SHIFT	12
diff -puN include/asm-x86_64/pgtable.h~consolidate-asm-consth-to-linux-consth include/asm-x86_64/pgtable.h
--- a/include/asm-x86_64/pgtable.h~consolidate-asm-consth-to-linux-consth
+++ a/include/asm-x86_64/pgtable.h
@@ -1,7 +1,7 @@
 #ifndef _X86_64_PGTABLE_H
 #define _X86_64_PGTABLE_H
 
-#include <asm/const.h>
+#include <linux/const.h>
 #ifndef __ASSEMBLY__
 
 /*
diff -puN /dev/null include/linux/const.h
--- /dev/null
+++ a/include/linux/const.h
@@ -0,0 +1,19 @@
+/* const.h: Macros for dealing with constants.  */
+
+#ifndef _LINUX_CONST_H
+#define _LINUX_CONST_H
+
+/* Some constant macros are used in both assembler and
+ * C code.  Therefore we cannot annotate them always with
+ * 'UL' and other type specifiers unilaterally.  We
+ * use the following macros to deal with this.
+ */
+
+#ifdef __ASSEMBLY__
+#define _AC(X,Y)	X
+#else
+#define __AC(X,Y)	(X##Y)
+#define _AC(X,Y)	__AC(X,Y)
+#endif
+
+#endif /* !(_LINUX_CONST_H) */
diff -puN include/linux/Kbuild~consolidate-asm-consth-to-linux-consth include/linux/Kbuild
--- a/include/linux/Kbuild~consolidate-asm-consth-to-linux-consth
+++ a/include/linux/Kbuild
@@ -45,6 +45,7 @@ header-y += coda_psdev.h
 header-y += coff.h
 header-y += comstats.h
 header-y += consolemap.h
+header-y += const.h
 header-y += cycx_cfm.h
 header-y += dlm_device.h
 header-y += dm-ioctl.h
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
consolidate-asm-consth-to-linux-consth.patch
some-grammatical-fixups-and-additions-to-atomich-kernel-doc.patch
s3fb-fix-pci-must_checks.patch
profile-likely-unlikely-macros.patch
