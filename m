From: akpm@linux-foundation.org
Subject: - consolidate-asm-consth-to-linux-consth.patch removed from -mm tree
Date: Tue, 08 May 2007 19:51:42 -0700
Message-ID: <200705090251.l492pgiw009488@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57277 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032191AbXEICvy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:51:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, ak@suse.de, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     consolidate asm/const.h to linux/const.h
has been removed from the -mm tree.  Its filename was
     consolidate-asm-consth-to-linux-consth.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: consolidate asm/const.h to linux/const.h
From: Randy Dunlap <randy.dunlap@oracle.com>

Make a global linux/const.h header file instead of having multiple,
per-arch files, and convert current users of asm/const.h to use
linux/const.h.

Built on x86_64 and sparc64.

[akpm@linux-foundation.org: fix include/asm-x86_64/Kbuild]
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
 include/asm-x86_64/Kbuild     |    1 -
 include/asm-x86_64/const.h    |   20 --------------------
 include/asm-x86_64/page.h     |    2 +-
 include/asm-x86_64/pgtable.h  |    2 +-
 include/linux/Kbuild          |    1 +
 include/linux/const.h         |   19 +++++++++++++++++++
 14 files changed, 28 insertions(+), 49 deletions(-)

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
 
diff -puN include/asm-x86_64/Kbuild~consolidate-asm-consth-to-linux-consth include/asm-x86_64/Kbuild
--- a/include/asm-x86_64/Kbuild~consolidate-asm-consth-to-linux-consth
+++ a/include/asm-x86_64/Kbuild
@@ -19,4 +19,3 @@ unifdef-y += mce.h
 unifdef-y += msr.h
 unifdef-y += mtrr.h
 unifdef-y += vsyscall.h
-unifdef-y += const.h
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
