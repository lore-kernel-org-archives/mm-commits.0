From: akpm@linux-foundation.org
Subject: + forbid-asm-bitopsh-direct-inclusion.patch added to -mm tree
Date: Thu, 13 Sep 2007 16:39:32 -0700
Message-ID: <200709132339.l8DNdWi1011480@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59808 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752571AbXIMXjw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Sep 2007 19:39:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, bunk@kernel.org


The patch titled
     forbid asm/bitops.h direct inclusion
has been added to the -mm tree.  Its filename is
     forbid-asm-bitopsh-direct-inclusion.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: forbid asm/bitops.h direct inclusion
From: Jiri Slaby <jirislaby@gmail.com>

forbid asm/bitops.h direct inclusion

Because of compile errors that may occur after bit changes if asm/bitops.h is
included directly without e.g.  linux/kernel.h which includes linux/bitops.h,
forbid direct inclusion of asm/bitops.h.  Thanks to Adrian Bunk.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-alpha/bitops.h     |    4 ++++
 include/asm-arm/bitops.h       |    4 ++++
 include/asm-avr32/bitops.h     |    4 ++++
 include/asm-blackfin/bitops.h  |    4 ++++
 include/asm-cris/bitops.h      |    4 ++++
 include/asm-frv/bitops.h       |    4 ++++
 include/asm-generic/bitops.h   |    4 ++++
 include/asm-h8300/bitops.h     |    5 +++++
 include/asm-i386/bitops.h      |    4 ++++
 include/asm-ia64/bitops.h      |    4 ++++
 include/asm-m32r/bitops.h      |    4 ++++
 include/asm-m68k/bitops.h      |    4 ++++
 include/asm-m68knommu/bitops.h |    4 ++++
 include/asm-mips/bitops.h      |    4 ++++
 include/asm-parisc/bitops.h    |    4 ++++
 include/asm-powerpc/bitops.h   |    4 ++++
 include/asm-s390/bitops.h      |    4 ++++
 include/asm-sh/bitops.h        |    5 +++++
 include/asm-sh64/bitops.h      |    5 +++++
 include/asm-sparc/bitops.h     |    4 ++++
 include/asm-sparc64/bitops.h   |    4 ++++
 include/asm-um/bitops.h        |    4 ++++
 include/asm-v850/bitops.h      |    3 +++
 include/asm-x86_64/bitops.h    |    4 ++++
 include/asm-xtensa/bitops.h    |    4 ++++
 25 files changed, 102 insertions(+)

diff -puN include/asm-alpha/bitops.h~forbid-asm-bitopsh-direct-inclusion include/asm-alpha/bitops.h
--- a/include/asm-alpha/bitops.h~forbid-asm-bitopsh-direct-inclusion
+++ a/include/asm-alpha/bitops.h
@@ -1,6 +1,10 @@
 #ifndef _ALPHA_BITOPS_H
 #define _ALPHA_BITOPS_H
 
+#ifndef _LINUX_BITOPS_H
+#error only <linux/bitops.h> can be included directly
+#endif
+
 #include <asm/compiler.h>
 
 /*
diff -puN include/asm-arm/bitops.h~forbid-asm-bitopsh-direct-inclusion include/asm-arm/bitops.h
--- a/include/asm-arm/bitops.h~forbid-asm-bitopsh-direct-inclusion
+++ a/include/asm-arm/bitops.h
@@ -19,6 +19,10 @@
 
 #ifdef __KERNEL__
 
+#ifndef _LINUX_BITOPS_H
+#error only <linux/bitops.h> can be included directly
+#endif
+
 #include <linux/compiler.h>
 #include <asm/system.h>
 
diff -puN include/asm-avr32/bitops.h~forbid-asm-bitopsh-direct-inclusion include/asm-avr32/bitops.h
--- a/include/asm-avr32/bitops.h~forbid-asm-bitopsh-direct-inclusion
+++ a/include/asm-avr32/bitops.h
@@ -8,6 +8,10 @@
 #ifndef __ASM_AVR32_BITOPS_H
 #define __ASM_AVR32_BITOPS_H
 
+#ifndef _LINUX_BITOPS_H
+#error only <linux/bitops.h> can be included directly
+#endif
+
 #include <asm/byteorder.h>
 #include <asm/system.h>
 
diff -puN include/asm-blackfin/bitops.h~forbid-asm-bitopsh-direct-inclusion include/asm-blackfin/bitops.h
--- a/include/asm-blackfin/bitops.h~forbid-asm-bitopsh-direct-inclusion
+++ a/include/asm-blackfin/bitops.h
@@ -11,6 +11,10 @@
 
 #ifdef __KERNEL__
 
+#ifndef _LINUX_BITOPS_H
+#error only <linux/bitops.h> can be included directly
+#endif
+
 #include <asm-generic/bitops/ffs.h>
 #include <asm-generic/bitops/__ffs.h>
 #include <asm-generic/bitops/sched.h>
diff -puN include/asm-cris/bitops.h~forbid-asm-bitopsh-direct-inclusion include/asm-cris/bitops.h
--- a/include/asm-cris/bitops.h~forbid-asm-bitopsh-direct-inclusion
+++ a/include/asm-cris/bitops.h
@@ -14,6 +14,10 @@
 /* Currently this is unsuitable for consumption outside the kernel.  */
 #ifdef __KERNEL__ 
 
+#ifndef _LINUX_BITOPS_H
+#error only <linux/bitops.h> can be included directly
+#endif
+
 #include <asm/arch/bitops.h>
 #include <asm/system.h>
 #include <asm/atomic.h>
diff -puN include/asm-frv/bitops.h~forbid-asm-bitopsh-direct-inclusion include/asm-frv/bitops.h
--- a/include/asm-frv/bitops.h~forbid-asm-bitopsh-direct-inclusion
+++ a/include/asm-frv/bitops.h
@@ -21,6 +21,10 @@
 
 #ifdef __KERNEL__
 
+#ifndef _LINUX_BITOPS_H
+#error only <linux/bitops.h> can be included directly
+#endif
+
 #include <asm-generic/bitops/ffz.h>
 
 /*
diff -puN include/asm-generic/bitops.h~forbid-asm-bitopsh-direct-inclusion include/asm-generic/bitops.h
--- a/include/asm-generic/bitops.h~forbid-asm-bitopsh-direct-inclusion
+++ a/include/asm-generic/bitops.h
@@ -19,6 +19,10 @@
 
 #ifdef __KERNEL__
 
+#ifndef _LINUX_BITOPS_H
+#error only <linux/bitops.h> can be included directly
+#endif
+
 #include <asm-generic/bitops/sched.h>
 #include <asm-generic/bitops/ffs.h>
 #include <asm-generic/bitops/hweight.h>
diff -puN include/asm-h8300/bitops.h~forbid-asm-bitopsh-direct-inclusion include/asm-h8300/bitops.h
--- a/include/asm-h8300/bitops.h~forbid-asm-bitopsh-direct-inclusion
+++ a/include/asm-h8300/bitops.h
@@ -10,6 +10,11 @@
 #include <asm/system.h>
 
 #ifdef __KERNEL__
+
+#ifndef _LINUX_BITOPS_H
+#error only <linux/bitops.h> can be included directly
+#endif
+
 /*
  * Function prototypes to keep gcc -Wall happy
  */
diff -puN include/asm-i386/bitops.h~forbid-asm-bitopsh-direct-inclusion include/asm-i386/bitops.h
--- a/include/asm-i386/bitops.h~forbid-asm-bitopsh-direct-inclusion
+++ a/include/asm-i386/bitops.h
@@ -5,6 +5,10 @@
  * Copyright 1992, Linus Torvalds.
  */
 
+#ifndef _LINUX_BITOPS_H
+#error only <linux/bitops.h> can be included directly
+#endif
+
 #include <linux/compiler.h>
 #include <asm/alternative.h>
 
diff -puN include/asm-ia64/bitops.h~forbid-asm-bitopsh-direct-inclusion include/asm-ia64/bitops.h
--- a/include/asm-ia64/bitops.h~forbid-asm-bitopsh-direct-inclusion
+++ a/include/asm-ia64/bitops.h
@@ -9,6 +9,10 @@
  * O(1) scheduler patch
  */
 
+#ifndef _LINUX_BITOPS_H
+#error only <linux/bitops.h> can be included directly
+#endif
+
 #include <linux/compiler.h>
 #include <linux/types.h>
 #include <asm/intrinsics.h>
diff -puN include/asm-m32r/bitops.h~forbid-asm-bitopsh-direct-inclusion include/asm-m32r/bitops.h
--- a/include/asm-m32r/bitops.h~forbid-asm-bitopsh-direct-inclusion
+++ a/include/asm-m32r/bitops.h
@@ -11,6 +11,10 @@
  *    Copyright (C) 2004  Hirokazu Takata <takata at linux-m32r.org>
  */
 
+#ifndef _LINUX_BITOPS_H
+#error only <linux/bitops.h> can be included directly
+#endif
+
 #include <linux/compiler.h>
 #include <asm/assembler.h>
 #include <asm/system.h>
diff -puN include/asm-m68k/bitops.h~forbid-asm-bitopsh-direct-inclusion include/asm-m68k/bitops.h
--- a/include/asm-m68k/bitops.h~forbid-asm-bitopsh-direct-inclusion
+++ a/include/asm-m68k/bitops.h
@@ -8,6 +8,10 @@
  * for more details.
  */
 
+#ifndef _LINUX_BITOPS_H
+#error only <linux/bitops.h> can be included directly
+#endif
+
 #include <linux/compiler.h>
 
 /*
diff -puN include/asm-m68knommu/bitops.h~forbid-asm-bitopsh-direct-inclusion include/asm-m68knommu/bitops.h
--- a/include/asm-m68knommu/bitops.h~forbid-asm-bitopsh-direct-inclusion
+++ a/include/asm-m68knommu/bitops.h
@@ -10,6 +10,10 @@
 
 #ifdef __KERNEL__
 
+#ifndef _LINUX_BITOPS_H
+#error only <linux/bitops.h> can be included directly
+#endif
+
 #include <asm-generic/bitops/ffs.h>
 #include <asm-generic/bitops/__ffs.h>
 #include <asm-generic/bitops/sched.h>
diff -puN include/asm-mips/bitops.h~forbid-asm-bitopsh-direct-inclusion include/asm-mips/bitops.h
--- a/include/asm-mips/bitops.h~forbid-asm-bitopsh-direct-inclusion
+++ a/include/asm-mips/bitops.h
@@ -9,6 +9,10 @@
 #ifndef _ASM_BITOPS_H
 #define _ASM_BITOPS_H
 
+#ifndef _LINUX_BITOPS_H
+#error only <linux/bitops.h> can be included directly
+#endif
+
 #include <linux/compiler.h>
 #include <linux/irqflags.h>
 #include <linux/types.h>
diff -puN include/asm-parisc/bitops.h~forbid-asm-bitopsh-direct-inclusion include/asm-parisc/bitops.h
--- a/include/asm-parisc/bitops.h~forbid-asm-bitopsh-direct-inclusion
+++ a/include/asm-parisc/bitops.h
@@ -1,6 +1,10 @@
 #ifndef _PARISC_BITOPS_H
 #define _PARISC_BITOPS_H
 
+#ifndef _LINUX_BITOPS_H
+#error only <linux/bitops.h> can be included directly
+#endif
+
 #include <linux/compiler.h>
 #include <asm/types.h>		/* for BITS_PER_LONG/SHIFT_PER_LONG */
 #include <asm/byteorder.h>
diff -puN include/asm-powerpc/bitops.h~forbid-asm-bitopsh-direct-inclusion include/asm-powerpc/bitops.h
--- a/include/asm-powerpc/bitops.h~forbid-asm-bitopsh-direct-inclusion
+++ a/include/asm-powerpc/bitops.h
@@ -38,6 +38,10 @@
 
 #ifdef __KERNEL__
 
+#ifndef _LINUX_BITOPS_H
+#error only <linux/bitops.h> can be included directly
+#endif
+
 #include <linux/compiler.h>
 #include <asm/asm-compat.h>
 #include <asm/synch.h>
diff -puN include/asm-s390/bitops.h~forbid-asm-bitopsh-direct-inclusion include/asm-s390/bitops.h
--- a/include/asm-s390/bitops.h~forbid-asm-bitopsh-direct-inclusion
+++ a/include/asm-s390/bitops.h
@@ -15,6 +15,10 @@
 
 #ifdef __KERNEL__
 
+#ifndef _LINUX_BITOPS_H
+#error only <linux/bitops.h> can be included directly
+#endif
+
 #include <linux/compiler.h>
 
 /*
diff -puN include/asm-sh/bitops.h~forbid-asm-bitopsh-direct-inclusion include/asm-sh/bitops.h
--- a/include/asm-sh/bitops.h~forbid-asm-bitopsh-direct-inclusion
+++ a/include/asm-sh/bitops.h
@@ -2,6 +2,11 @@
 #define __ASM_SH_BITOPS_H
 
 #ifdef __KERNEL__
+
+#ifndef _LINUX_BITOPS_H
+#error only <linux/bitops.h> can be included directly
+#endif
+
 #include <asm/system.h>
 /* For __swab32 */
 #include <asm/byteorder.h>
diff -puN include/asm-sh64/bitops.h~forbid-asm-bitopsh-direct-inclusion include/asm-sh64/bitops.h
--- a/include/asm-sh64/bitops.h~forbid-asm-bitopsh-direct-inclusion
+++ a/include/asm-sh64/bitops.h
@@ -13,6 +13,11 @@
  */
 
 #ifdef __KERNEL__
+
+#ifndef _LINUX_BITOPS_H
+#error only <linux/bitops.h> can be included directly
+#endif
+
 #include <linux/compiler.h>
 #include <asm/system.h>
 /* For __swab32 */
diff -puN include/asm-sparc/bitops.h~forbid-asm-bitopsh-direct-inclusion include/asm-sparc/bitops.h
--- a/include/asm-sparc/bitops.h~forbid-asm-bitopsh-direct-inclusion
+++ a/include/asm-sparc/bitops.h
@@ -14,6 +14,10 @@
 
 #ifdef __KERNEL__
 
+#ifndef _LINUX_BITOPS_H
+#error only <linux/bitops.h> can be included directly
+#endif
+
 extern unsigned long ___set_bit(unsigned long *addr, unsigned long mask);
 extern unsigned long ___clear_bit(unsigned long *addr, unsigned long mask);
 extern unsigned long ___change_bit(unsigned long *addr, unsigned long mask);
diff -puN include/asm-sparc64/bitops.h~forbid-asm-bitopsh-direct-inclusion include/asm-sparc64/bitops.h
--- a/include/asm-sparc64/bitops.h~forbid-asm-bitopsh-direct-inclusion
+++ a/include/asm-sparc64/bitops.h
@@ -7,6 +7,10 @@
 #ifndef _SPARC64_BITOPS_H
 #define _SPARC64_BITOPS_H
 
+#ifndef _LINUX_BITOPS_H
+#error only <linux/bitops.h> can be included directly
+#endif
+
 #include <linux/compiler.h>
 #include <asm/byteorder.h>
 
diff -puN include/asm-um/bitops.h~forbid-asm-bitopsh-direct-inclusion include/asm-um/bitops.h
--- a/include/asm-um/bitops.h~forbid-asm-bitopsh-direct-inclusion
+++ a/include/asm-um/bitops.h
@@ -1,6 +1,10 @@
 #ifndef __UM_BITOPS_H
 #define __UM_BITOPS_H
 
+#ifndef _LINUX_BITOPS_H
+#error only <linux/bitops.h> can be included directly
+#endif
+
 #include "asm/arch/bitops.h"
 
 #endif
diff -puN include/asm-v850/bitops.h~forbid-asm-bitopsh-direct-inclusion include/asm-v850/bitops.h
--- a/include/asm-v850/bitops.h~forbid-asm-bitopsh-direct-inclusion
+++ a/include/asm-v850/bitops.h
@@ -13,6 +13,9 @@
 #ifndef __V850_BITOPS_H__
 #define __V850_BITOPS_H__
 
+#ifndef _LINUX_BITOPS_H
+#error only <linux/bitops.h> can be included directly
+#endif
 
 #include <linux/compiler.h>	/* unlikely  */
 #include <asm/byteorder.h>	/* swab32 */
diff -puN include/asm-x86_64/bitops.h~forbid-asm-bitopsh-direct-inclusion include/asm-x86_64/bitops.h
--- a/include/asm-x86_64/bitops.h~forbid-asm-bitopsh-direct-inclusion
+++ a/include/asm-x86_64/bitops.h
@@ -5,6 +5,10 @@
  * Copyright 1992, Linus Torvalds.
  */
 
+#ifndef _LINUX_BITOPS_H
+#error only <linux/bitops.h> can be included directly
+#endif
+
 #include <asm/alternative.h>
 
 #if __GNUC__ < 4 || (__GNUC__ == 4 && __GNUC_MINOR__ < 1)
diff -puN include/asm-xtensa/bitops.h~forbid-asm-bitopsh-direct-inclusion include/asm-xtensa/bitops.h
--- a/include/asm-xtensa/bitops.h~forbid-asm-bitopsh-direct-inclusion
+++ a/include/asm-xtensa/bitops.h
@@ -15,6 +15,10 @@
 
 #ifdef __KERNEL__
 
+#ifndef _LINUX_BITOPS_H
+#error only <linux/bitops.h> can be included directly
+#endif
+
 #include <asm/processor.h>
 #include <asm/byteorder.h>
 #include <asm/system.h>
_

Patches currently in -mm which might be from jirislaby@gmail.com are

v4l-stk11xx-add-a-new-webcam-driver.patch
v4l-stk11xx-use-array_size-in-another-2-cases.patch
v4l-stk11xx-use-retval-from-stk11xx_check_device.patch
v4l-stk11xx-add-static-to-tables.patch
ata-pata_marvell-use-ioread-for-iomap-ped-memory.patch
git-net.patch
git-wireless.patch
net-add-ath5k-wireless-driver-fix.patch
ath5k-panic-fix.patch
epcac-reformat-comments-and-coding-style-improvements.patch
char-mxser_new-upgrade-to-110.patch
char-mxser_new-move-to-pci_vdevice.patch
char-mxser_new-remove-useless-comments-in-mxser_cards.patch
mxser-remove-commented-crap.patch
mxser-fix-compiler-warning-when-building-withoug-config_pci.patch
mxser-fix-compiler-warning-when-building-withoug-config_pci-fix.patch
char-moxa-fix-and-optimise-empty-timer.patch
char-cyclades-remove-bottom-half-processing.patch
char-cyclades-make-the-isr-code-readable.patch
char-cyclades-move-spin_lock-to-one-place.patch
char-cyclades-fix-some-w-warnings.patch
cyclades-avoid-label-defined-but-not-used-warning.patch
char-moxa-cleanup-prints.patch
char-moxa-function-names-cleanup.patch
char-moxa-remove-sleep_on.patch
fs-select-remove-unused-macros.patch
remove-asm-bitopsh-includes.patch
forbid-asm-bitopsh-direct-inclusion.patch
cyber2000fb-rename-bit-macro.patch
i2c-pxa-rename-bit-macro-to-pxa_bit.patch
s2io-rename-bit-macro.patch
amba-pl011-rename-bit-macro.patch
define-first-set-of-bit-macros.patch
get-rid-of-input-bit-duplicate-defines.patch
define-global-bit-macro.patch
flashpoint-use-bit-instead-of-bitw.patch
remove-bits_to_type-macro.patch
remove-bits_to_type-macro-fix.patch
remove-asm-bitopsh-includes-reiser4.patch
shrink_slab-handle-bad-shrinkers.patch
