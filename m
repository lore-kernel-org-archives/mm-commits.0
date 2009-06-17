From: akpm@linux-foundation.org
Subject: [merged] kmap_types-make-most-arches-use-generic-header-file.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:37:40 -0700
Message-ID: <200906171837.n5HIbewp003712@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54739 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758317AbZFQS6l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:58:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, a.p.zijlstra@chello.nl, arnd@arndb.de, cooloney@kernel.org, davem@davemloft.net, dhowells@redhat.com, geert@linux-m68k.org, hpa@zytor.com, ink@jurassic.park.ms


The patch titled
     kmap_types: make most arches use generic header file
has been removed from the -mm tree.  Its filename was
     kmap_types-make-most-arches-use-generic-header-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kmap_types: make most arches use generic header file
From: Randy Dunlap <randy.dunlap@oracle.com>

Convert most arches to use asm-generic/kmap_types.h.

Move the KM_FENCE_ macro additions into asm-generic/kmap_types.h,
controlled by __WITH_KM_FENCE from each arch's kmap_types.h file.

Would be nice to be able to add custom KM_types per arch, but I don't yet
see a nice, clean way to do that.

Built on x86_64, i386, mips, sparc, alpha(tonyb), powerpc(tonyb), and
68k(tonyb).

Note: avr32 should be able to remove KM_PTE2 (since it's not used) and
then just use the generic kmap_types.h file.  Get avr32 maintainer
approval.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: <linux-arch@vger.kernel.org>
Acked-by: Mike Frysinger <vapier@gentoo.org>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Bryan Wu <cooloney@kernel.org>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: "Luck Tony" <tony.luck@intel.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/kmap_types.h      |   24 ++----------------
 arch/blackfin/include/asm/kmap_types.h   |   17 -------------
 arch/cris/include/asm/kmap_types.h       |   17 -------------
 arch/h8300/include/asm/kmap_types.h      |   17 -------------
 arch/ia64/include/asm/kmap_types.h       |   24 ++----------------
 arch/m32r/include/asm/kmap_types.h       |   23 ++---------------
 arch/m68k/include/asm/kmap_types.h       |   17 -------------
 arch/microblaze/include/asm/kmap_types.h |   25 -------------------
 arch/mips/include/asm/kmap_types.h       |   24 ++----------------
 arch/mn10300/include/asm/kmap_types.h    |   27 ---------------------
 arch/parisc/include/asm/kmap_types.h     |   24 ++----------------
 arch/s390/include/asm/kmap_types.h       |   17 -------------
 arch/sh/include/asm/kmap_types.h         |   24 ++----------------
 arch/sparc/include/asm/kmap_types.h      |   17 -------------
 arch/x86/include/asm/kmap_types.h        |   23 ++---------------
 arch/xtensa/include/asm/kmap_types.h     |   27 ---------------------
 include/asm-generic/kmap_types.h         |    2 -
 17 files changed, 31 insertions(+), 318 deletions(-)

diff -puN arch/alpha/include/asm/kmap_types.h~kmap_types-make-most-arches-use-generic-header-file arch/alpha/include/asm/kmap_types.h
--- a/arch/alpha/include/asm/kmap_types.h~kmap_types-make-most-arches-use-generic-header-file
+++ a/arch/alpha/include/asm/kmap_types.h
@@ -3,30 +3,12 @@
 
 /* Dummy header just to define km_type. */
 
-
 #ifdef CONFIG_DEBUG_HIGHMEM
-# define D(n) __KM_FENCE_##n ,
-#else
-# define D(n)
+#define  __WITH_KM_FENCE
 #endif
 
-enum km_type {
-D(0)	KM_BOUNCE_READ,
-D(1)	KM_SKB_SUNRPC_DATA,
-D(2)	KM_SKB_DATA_SOFTIRQ,
-D(3)	KM_USER0,
-D(4)	KM_USER1,
-D(5)	KM_BIO_SRC_IRQ,
-D(6)	KM_BIO_DST_IRQ,
-D(7)	KM_PTE0,
-D(8)	KM_PTE1,
-D(9)	KM_IRQ0,
-D(10)	KM_IRQ1,
-D(11)	KM_SOFTIRQ0,
-D(12)	KM_SOFTIRQ1,
-D(13)	KM_TYPE_NR
-};
+#include <asm-generic/kmap_types.h>
 
-#undef D
+#undef __WITH_KM_FENCE
 
 #endif
diff -puN arch/blackfin/include/asm/kmap_types.h~kmap_types-make-most-arches-use-generic-header-file arch/blackfin/include/asm/kmap_types.h
--- a/arch/blackfin/include/asm/kmap_types.h~kmap_types-make-most-arches-use-generic-header-file
+++ a/arch/blackfin/include/asm/kmap_types.h
@@ -1,21 +1,6 @@
 #ifndef _ASM_KMAP_TYPES_H
 #define _ASM_KMAP_TYPES_H
 
-enum km_type {
-	KM_BOUNCE_READ,
-	KM_SKB_SUNRPC_DATA,
-	KM_SKB_DATA_SOFTIRQ,
-	KM_USER0,
-	KM_USER1,
-	KM_BIO_SRC_IRQ,
-	KM_BIO_DST_IRQ,
-	KM_PTE0,
-	KM_PTE1,
-	KM_IRQ0,
-	KM_IRQ1,
-	KM_SOFTIRQ0,
-	KM_SOFTIRQ1,
-	KM_TYPE_NR
-};
+#include <asm-generic/kmap_types.h>
 
 #endif
diff -puN arch/cris/include/asm/kmap_types.h~kmap_types-make-most-arches-use-generic-header-file arch/cris/include/asm/kmap_types.h
--- a/arch/cris/include/asm/kmap_types.h~kmap_types-make-most-arches-use-generic-header-file
+++ a/arch/cris/include/asm/kmap_types.h
@@ -5,21 +5,6 @@
  * is actually used on cris. 
  */
 
-enum km_type {
-	KM_BOUNCE_READ,
-	KM_SKB_SUNRPC_DATA,
-	KM_SKB_DATA_SOFTIRQ,
-	KM_USER0,
-	KM_USER1,
-	KM_BIO_SRC_IRQ,
-	KM_BIO_DST_IRQ,
-	KM_PTE0,
-	KM_PTE1,
-	KM_IRQ0,
-	KM_IRQ1,
-	KM_SOFTIRQ0,
-	KM_SOFTIRQ1,
-	KM_TYPE_NR
-};
+#include <asm-generic/kmap_types.h>
 
 #endif
diff -puN arch/h8300/include/asm/kmap_types.h~kmap_types-make-most-arches-use-generic-header-file arch/h8300/include/asm/kmap_types.h
--- a/arch/h8300/include/asm/kmap_types.h~kmap_types-make-most-arches-use-generic-header-file
+++ a/arch/h8300/include/asm/kmap_types.h
@@ -1,21 +1,6 @@
 #ifndef _ASM_H8300_KMAP_TYPES_H
 #define _ASM_H8300_KMAP_TYPES_H
 
-enum km_type {
-	KM_BOUNCE_READ,
-	KM_SKB_SUNRPC_DATA,
-	KM_SKB_DATA_SOFTIRQ,
-	KM_USER0,
-	KM_USER1,
-	KM_BIO_SRC_IRQ,
-	KM_BIO_DST_IRQ,
-	KM_PTE0,
-	KM_PTE1,
-	KM_IRQ0,
-	KM_IRQ1,
-	KM_SOFTIRQ0,
-	KM_SOFTIRQ1,
-	KM_TYPE_NR
-};
+#include <asm-generic/kmap_types.h>
 
 #endif
diff -puN arch/ia64/include/asm/kmap_types.h~kmap_types-make-most-arches-use-generic-header-file arch/ia64/include/asm/kmap_types.h
--- a/arch/ia64/include/asm/kmap_types.h~kmap_types-make-most-arches-use-generic-header-file
+++ a/arch/ia64/include/asm/kmap_types.h
@@ -1,30 +1,12 @@
 #ifndef _ASM_IA64_KMAP_TYPES_H
 #define _ASM_IA64_KMAP_TYPES_H
 
-
 #ifdef CONFIG_DEBUG_HIGHMEM
-# define D(n) __KM_FENCE_##n ,
-#else
-# define D(n)
+#define  __WITH_KM_FENCE
 #endif
 
-enum km_type {
-D(0)	KM_BOUNCE_READ,
-D(1)	KM_SKB_SUNRPC_DATA,
-D(2)	KM_SKB_DATA_SOFTIRQ,
-D(3)	KM_USER0,
-D(4)	KM_USER1,
-D(5)	KM_BIO_SRC_IRQ,
-D(6)	KM_BIO_DST_IRQ,
-D(7)	KM_PTE0,
-D(8)	KM_PTE1,
-D(9)	KM_IRQ0,
-D(10)	KM_IRQ1,
-D(11)	KM_SOFTIRQ0,
-D(12)	KM_SOFTIRQ1,
-D(13)	KM_TYPE_NR
-};
+#include <asm-generic/kmap_types.h>
 
-#undef D
+#undef __WITH_KM_FENCE
 
 #endif /* _ASM_IA64_KMAP_TYPES_H */
diff -puN arch/m32r/include/asm/kmap_types.h~kmap_types-make-most-arches-use-generic-header-file arch/m32r/include/asm/kmap_types.h
--- a/arch/m32r/include/asm/kmap_types.h~kmap_types-make-most-arches-use-generic-header-file
+++ a/arch/m32r/include/asm/kmap_types.h
@@ -2,28 +2,11 @@
 #define __M32R_KMAP_TYPES_H
 
 #ifdef CONFIG_DEBUG_HIGHMEM
-# define D(n) __KM_FENCE_##n ,
-#else
-# define D(n)
+#define  __WITH_KM_FENCE
 #endif
 
-enum km_type {
-D(0)	KM_BOUNCE_READ,
-D(1)	KM_SKB_SUNRPC_DATA,
-D(2)	KM_SKB_DATA_SOFTIRQ,
-D(3)	KM_USER0,
-D(4)	KM_USER1,
-D(5)	KM_BIO_SRC_IRQ,
-D(6)	KM_BIO_DST_IRQ,
-D(7)	KM_PTE0,
-D(8)	KM_PTE1,
-D(9)	KM_IRQ0,
-D(10)	KM_IRQ1,
-D(11)	KM_SOFTIRQ0,
-D(12)	KM_SOFTIRQ1,
-D(13)	KM_TYPE_NR
-};
+#include <asm-generic/kmap_types.h>
 
-#undef D
+#undef __WITH_KM_FENCE
 
 #endif /* __M32R_KMAP_TYPES_H */
diff -puN arch/m68k/include/asm/kmap_types.h~kmap_types-make-most-arches-use-generic-header-file arch/m68k/include/asm/kmap_types.h
--- a/arch/m68k/include/asm/kmap_types.h~kmap_types-make-most-arches-use-generic-header-file
+++ a/arch/m68k/include/asm/kmap_types.h
@@ -1,21 +1,6 @@
 #ifndef __ASM_M68K_KMAP_TYPES_H
 #define __ASM_M68K_KMAP_TYPES_H
 
-enum km_type {
-	KM_BOUNCE_READ,
-	KM_SKB_SUNRPC_DATA,
-	KM_SKB_DATA_SOFTIRQ,
-	KM_USER0,
-	KM_USER1,
-	KM_BIO_SRC_IRQ,
-	KM_BIO_DST_IRQ,
-	KM_PTE0,
-	KM_PTE1,
-	KM_IRQ0,
-	KM_IRQ1,
-	KM_SOFTIRQ0,
-	KM_SOFTIRQ1,
-	KM_TYPE_NR
-};
+#include <asm-generic/kmap_types.h>
 
 #endif	/* __ASM_M68K_KMAP_TYPES_H */
diff -puN arch/microblaze/include/asm/kmap_types.h~kmap_types-make-most-arches-use-generic-header-file arch/microblaze/include/asm/kmap_types.h
--- a/arch/microblaze/include/asm/kmap_types.h~kmap_types-make-most-arches-use-generic-header-file
+++ a/arch/microblaze/include/asm/kmap_types.h
@@ -1,29 +1,6 @@
-/*
- * Copyright (C) 2006 Atmark Techno, Inc.
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License. See the file "COPYING" in the main directory of this archive
- * for more details.
- */
-
 #ifndef _ASM_MICROBLAZE_KMAP_TYPES_H
 #define _ASM_MICROBLAZE_KMAP_TYPES_H
 
-enum km_type {
-	KM_BOUNCE_READ,
-	KM_SKB_SUNRPC_DATA,
-	KM_SKB_DATA_SOFTIRQ,
-	KM_USER0,
-	KM_USER1,
-	KM_BIO_SRC_IRQ,
-	KM_BIO_DST_IRQ,
-	KM_PTE0,
-	KM_PTE1,
-	KM_IRQ0,
-	KM_IRQ1,
-	KM_SOFTIRQ0,
-	KM_SOFTIRQ1,
-	KM_TYPE_NR,
-};
+#include <asm-generic/kmap_types.h>
 
 #endif /* _ASM_MICROBLAZE_KMAP_TYPES_H */
diff -puN arch/mips/include/asm/kmap_types.h~kmap_types-make-most-arches-use-generic-header-file arch/mips/include/asm/kmap_types.h
--- a/arch/mips/include/asm/kmap_types.h~kmap_types-make-most-arches-use-generic-header-file
+++ a/arch/mips/include/asm/kmap_types.h
@@ -1,30 +1,12 @@
 #ifndef _ASM_KMAP_TYPES_H
 #define _ASM_KMAP_TYPES_H
 
-
 #ifdef CONFIG_DEBUG_HIGHMEM
-# define D(n) __KM_FENCE_##n ,
-#else
-# define D(n)
+#define  __WITH_KM_FENCE
 #endif
 
-enum km_type {
-D(0)	KM_BOUNCE_READ,
-D(1)	KM_SKB_SUNRPC_DATA,
-D(2)	KM_SKB_DATA_SOFTIRQ,
-D(3)	KM_USER0,
-D(4)	KM_USER1,
-D(5)	KM_BIO_SRC_IRQ,
-D(6)	KM_BIO_DST_IRQ,
-D(7)	KM_PTE0,
-D(8)	KM_PTE1,
-D(9)	KM_IRQ0,
-D(10)	KM_IRQ1,
-D(11)	KM_SOFTIRQ0,
-D(12)	KM_SOFTIRQ1,
-D(13)	KM_TYPE_NR
-};
+#include <asm-generic/kmap_types.h>
 
-#undef D
+#undef __WITH_KM_FENCE
 
 #endif
diff -puN arch/mn10300/include/asm/kmap_types.h~kmap_types-make-most-arches-use-generic-header-file arch/mn10300/include/asm/kmap_types.h
--- a/arch/mn10300/include/asm/kmap_types.h~kmap_types-make-most-arches-use-generic-header-file
+++ a/arch/mn10300/include/asm/kmap_types.h
@@ -1,31 +1,6 @@
-/* MN10300 kmap_atomic() slot IDs
- *
- * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public Licence
- * as published by the Free Software Foundation; either version
- * 2 of the Licence, or (at your option) any later version.
- */
 #ifndef _ASM_KMAP_TYPES_H
 #define _ASM_KMAP_TYPES_H
 
-enum km_type {
-	KM_BOUNCE_READ,
-	KM_SKB_SUNRPC_DATA,
-	KM_SKB_DATA_SOFTIRQ,
-	KM_USER0,
-	KM_USER1,
-	KM_BIO_SRC_IRQ,
-	KM_BIO_DST_IRQ,
-	KM_PTE0,
-	KM_PTE1,
-	KM_IRQ0,
-	KM_IRQ1,
-	KM_SOFTIRQ0,
-	KM_SOFTIRQ1,
-	KM_TYPE_NR
-};
+#include <asm-generic/kmap_types.h>
 
 #endif /* _ASM_KMAP_TYPES_H */
diff -puN arch/parisc/include/asm/kmap_types.h~kmap_types-make-most-arches-use-generic-header-file arch/parisc/include/asm/kmap_types.h
--- a/arch/parisc/include/asm/kmap_types.h~kmap_types-make-most-arches-use-generic-header-file
+++ a/arch/parisc/include/asm/kmap_types.h
@@ -1,30 +1,12 @@
 #ifndef _ASM_KMAP_TYPES_H
 #define _ASM_KMAP_TYPES_H
 
-
 #ifdef CONFIG_DEBUG_HIGHMEM
-# define D(n) __KM_FENCE_##n ,
-#else
-# define D(n)
+#define  __WITH_KM_FENCE
 #endif
 
-enum km_type {
-D(0)	KM_BOUNCE_READ,
-D(1)	KM_SKB_SUNRPC_DATA,
-D(2)	KM_SKB_DATA_SOFTIRQ,
-D(3)	KM_USER0,
-D(4)	KM_USER1,
-D(5)	KM_BIO_SRC_IRQ,
-D(6)	KM_BIO_DST_IRQ,
-D(7)	KM_PTE0,
-D(8)	KM_PTE1,
-D(9)	KM_IRQ0,
-D(10)	KM_IRQ1,
-D(11)	KM_SOFTIRQ0,
-D(12)	KM_SOFTIRQ1,
-D(13)	KM_TYPE_NR
-};
+#include <asm-generic/kmap_types.h>
 
-#undef D
+#undef __WITH_KM_FENCE
 
 #endif
diff -puN arch/s390/include/asm/kmap_types.h~kmap_types-make-most-arches-use-generic-header-file arch/s390/include/asm/kmap_types.h
--- a/arch/s390/include/asm/kmap_types.h~kmap_types-make-most-arches-use-generic-header-file
+++ a/arch/s390/include/asm/kmap_types.h
@@ -2,22 +2,7 @@
 #ifndef _ASM_KMAP_TYPES_H
 #define _ASM_KMAP_TYPES_H
 
-enum km_type {
-	KM_BOUNCE_READ,
-	KM_SKB_SUNRPC_DATA,
-	KM_SKB_DATA_SOFTIRQ,
-	KM_USER0,
-	KM_USER1,
-	KM_BIO_SRC_IRQ,
-	KM_BIO_DST_IRQ,
-	KM_PTE0,
-	KM_PTE1,
-	KM_IRQ0,
-	KM_IRQ1,
-	KM_SOFTIRQ0,
-	KM_SOFTIRQ1,	
-	KM_TYPE_NR
-};
+#include <asm-generic/kmap_types.h>
 
 #endif
 #endif /* __KERNEL__ */
diff -puN arch/sh/include/asm/kmap_types.h~kmap_types-make-most-arches-use-generic-header-file arch/sh/include/asm/kmap_types.h
--- a/arch/sh/include/asm/kmap_types.h~kmap_types-make-most-arches-use-generic-header-file
+++ a/arch/sh/include/asm/kmap_types.h
@@ -3,30 +3,12 @@
 
 /* Dummy header just to define km_type. */
 
-
 #ifdef CONFIG_DEBUG_HIGHMEM
-# define D(n) __KM_FENCE_##n ,
-#else
-# define D(n)
+#define  __WITH_KM_FENCE
 #endif
 
-enum km_type {
-D(0)	KM_BOUNCE_READ,
-D(1)	KM_SKB_SUNRPC_DATA,
-D(2)	KM_SKB_DATA_SOFTIRQ,
-D(3)	KM_USER0,
-D(4)	KM_USER1,
-D(5)	KM_BIO_SRC_IRQ,
-D(6)	KM_BIO_DST_IRQ,
-D(7)	KM_PTE0,
-D(8)	KM_PTE1,
-D(9)	KM_IRQ0,
-D(10)	KM_IRQ1,
-D(11)	KM_SOFTIRQ0,
-D(12)	KM_SOFTIRQ1,
-D(13)	KM_TYPE_NR
-};
+#include <asm-generic/kmap_types.h>
 
-#undef D
+#undef __WITH_KM_FENCE
 
 #endif
diff -puN arch/sparc/include/asm/kmap_types.h~kmap_types-make-most-arches-use-generic-header-file arch/sparc/include/asm/kmap_types.h
--- a/arch/sparc/include/asm/kmap_types.h~kmap_types-make-most-arches-use-generic-header-file
+++ a/arch/sparc/include/asm/kmap_types.h
@@ -5,21 +5,6 @@
  * is actually used on sparc.  -DaveM
  */
 
-enum km_type {
-	KM_BOUNCE_READ,
-	KM_SKB_SUNRPC_DATA,
-	KM_SKB_DATA_SOFTIRQ,
-	KM_USER0,
-	KM_USER1,
-	KM_BIO_SRC_IRQ,
-	KM_BIO_DST_IRQ,
-	KM_PTE0,
-	KM_PTE1,
-	KM_IRQ0,
-	KM_IRQ1,
-	KM_SOFTIRQ0,
-	KM_SOFTIRQ1,
-	KM_TYPE_NR
-};
+#include <asm-generic/kmap_types.h>
 
 #endif
diff -puN arch/x86/include/asm/kmap_types.h~kmap_types-make-most-arches-use-generic-header-file arch/x86/include/asm/kmap_types.h
--- a/arch/x86/include/asm/kmap_types.h~kmap_types-make-most-arches-use-generic-header-file
+++ a/arch/x86/include/asm/kmap_types.h
@@ -2,28 +2,11 @@
 #define _ASM_X86_KMAP_TYPES_H
 
 #if defined(CONFIG_X86_32) && defined(CONFIG_DEBUG_HIGHMEM)
-# define D(n) __KM_FENCE_##n ,
-#else
-# define D(n)
+#define  __WITH_KM_FENCE
 #endif
 
-enum km_type {
-D(0)	KM_BOUNCE_READ,
-D(1)	KM_SKB_SUNRPC_DATA,
-D(2)	KM_SKB_DATA_SOFTIRQ,
-D(3)	KM_USER0,
-D(4)	KM_USER1,
-D(5)	KM_BIO_SRC_IRQ,
-D(6)	KM_BIO_DST_IRQ,
-D(7)	KM_PTE0,
-D(8)	KM_PTE1,
-D(9)	KM_IRQ0,
-D(10)	KM_IRQ1,
-D(11)	KM_SOFTIRQ0,
-D(12)	KM_SOFTIRQ1,
-D(13)	KM_TYPE_NR
-};
+#include <asm-generic/kmap_types.h>
 
-#undef D
+#undef __WITH_KM_FENCE
 
 #endif /* _ASM_X86_KMAP_TYPES_H */
diff -puN arch/xtensa/include/asm/kmap_types.h~kmap_types-make-most-arches-use-generic-header-file arch/xtensa/include/asm/kmap_types.h
--- a/arch/xtensa/include/asm/kmap_types.h~kmap_types-make-most-arches-use-generic-header-file
+++ a/arch/xtensa/include/asm/kmap_types.h
@@ -1,31 +1,6 @@
-/*
- * include/asm-xtensa/kmap_types.h
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 2001 - 2005 Tensilica Inc.
- */
-
 #ifndef _XTENSA_KMAP_TYPES_H
 #define _XTENSA_KMAP_TYPES_H
 
-enum km_type {
-  KM_BOUNCE_READ,
-  KM_SKB_SUNRPC_DATA,
-  KM_SKB_DATA_SOFTIRQ,
-  KM_USER0,
-  KM_USER1,
-  KM_BIO_SRC_IRQ,
-  KM_BIO_DST_IRQ,
-  KM_PTE0,
-  KM_PTE1,
-  KM_IRQ0,
-  KM_IRQ1,
-  KM_SOFTIRQ0,
-  KM_SOFTIRQ1,
-  KM_TYPE_NR
-};
+#include <asm-generic/kmap_types.h>
 
 #endif	/* _XTENSA_KMAP_TYPES_H */
diff -puN include/asm-generic/kmap_types.h~kmap_types-make-most-arches-use-generic-header-file include/asm-generic/kmap_types.h
--- a/include/asm-generic/kmap_types.h~kmap_types-make-most-arches-use-generic-header-file
+++ a/include/asm-generic/kmap_types.h
@@ -1,7 +1,7 @@
 #ifndef _ASM_GENERIC_KMAP_TYPES_H
 #define _ASM_GENERIC_KMAP_TYPES_H
 
-#ifdef CONFIG_DEBUG_HIGHMEM
+#ifdef __WITH_KM_FENCE
 # define D(n) __KM_FENCE_##n ,
 #else
 # define D(n)
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
irqs-add-irqf_sample_random-to-the-feature-removal-scheduletxt-deprecated-list.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
proctxt-update-kernel-filesystem-proctxt-documentation.patch
cgroups-make-messages-more-readable.patch
rapidio-fix-kerneldoc-for-rio_mem_ops.patch
linuxpps-core-support.patch
reiser4-export-remove_from_page_cache-fix.patch

