From: akpm@linux-foundation.org
Subject: + markers-define-the-linker-macro-extra_rwdata.patch added to -mm tree
Date: Tue, 10 Apr 2007 21:46:34 -0700
Message-ID: <200704110446.l3B4kZf8028596@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58833 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030781AbXDKEqz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Apr 2007 00:46:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, linux-arch@vger.kernel.org


The patch titled
     markers: define the linker macro EXTRA_RWDATA
has been added to the -mm tree.  Its filename is
     markers-define-the-linker-macro-extra_rwdata.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: markers: define the linker macro EXTRA_RWDATA
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Defines the linker macro EXTRA_RWDATA for the marker data section.  It puts
the marker data in a separate section that will not pollute the normal .data
section, which minimize the cache impact.  Markers need such a special section
because they define a lot of spreaded and small data structures at multiple
sites.

This patch also creates the __markers_strings section (ro marker strings) and
makes sure the __markers section is aligned by putting it before the
__ksymtab_strings (not after).

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/vmlinux.lds.h |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff -puN include/asm-generic/vmlinux.lds.h~markers-define-the-linker-macro-extra_rwdata include/asm-generic/vmlinux.lds.h
--- a/include/asm-generic/vmlinux.lds.h~markers-define-the-linker-macro-extra_rwdata
+++ a/include/asm-generic/vmlinux.lds.h
@@ -116,21 +116,19 @@
 		*(__kcrctab_gpl_future)					\
 		VMLINUX_SYMBOL(__stop___kcrctab_gpl_future) = .;	\
 	}								\
-									\
-	/* Kernel symbol table: strings */				\
-        __ksymtab_strings : AT(ADDR(__ksymtab_strings) - LOAD_OFFSET) {	\
-		*(__ksymtab_strings)					\
-	}								\
 	/* Kernel markers : pointers */					\
-	.markers : AT(ADDR(.markers) - LOAD_OFFSET) {			\
+	__markers : AT(ADDR(__markers) - LOAD_OFFSET) {			\
 		VMLINUX_SYMBOL(__start___markers) = .;			\
-		*(.markers)						\
+		*(__markers)						\
 		VMLINUX_SYMBOL(__stop___markers) = .;			\
 	}								\
-	.markers.c : AT(ADDR(.markers.c) - LOAD_OFFSET) {		\
-		VMLINUX_SYMBOL(__start___markers_c) = .;		\
-		*(.markers.c)						\
-		VMLINUX_SYMBOL(__stop___markers_c) = .;			\
+	/* Kernel symbol table: strings */				\
+        __ksymtab_strings : AT(ADDR(__ksymtab_strings) - LOAD_OFFSET) {	\
+		*(__ksymtab_strings)					\
+	}								\
+	/* Kernel markers : strings */					\
+	__markers_strings : AT(ADDR(__markers_strings) - LOAD_OFFSET) {	\
+		*(__markers_strings)					\
 	}								\
 	__end_rodata = .;						\
 	. = ALIGN(4096);						\
@@ -147,6 +145,10 @@
 									\
 	. = ALIGN(4096);
 
+#define EXTRA_RWDATA							\
+	. = ALIGN(8);							\
+	*(__markers_data)						\
+
 #define SECURITY_INIT							\
 	.security_initcall.init : AT(ADDR(.security_initcall.init) - LOAD_OFFSET) { \
 		VMLINUX_SYMBOL(__security_initcall_start) = .;		\
@@ -263,4 +265,3 @@
   	*(.initcall6s.init)						\
   	*(.initcall7.init)						\
   	*(.initcall7s.init)
-
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

avr32-remove-unneeded-cast-in-atomich.patch
git-powerpc.patch
ppc4xx_sgdma-needs-dma_mappingh.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-alpha.patch
atomich-complete-atomic_long-operations-in-asm-generic.patch
atomich-i386-type-safety-fix.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-ia64.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-mips.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-parisc.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc-fix.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-sparc64.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-x86_64.patch
atomich-atomic_add_unless-as-inline-remove-systemh-atomich-circular-dependency.patch
local_t-architecture-independant-extension.patch
local_t-alpha-extension.patch
local_t-i386-extension.patch
local_t-ia64-extension.patch
local_t-mips-extension.patch
local_t-parisc-cleanup.patch
local_t-powerpc-extension.patch
local_t-sparc64-cleanup.patch
local_t-x86_64-extension.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-powerpc-optimization.patch
linux-kernel-markers-i386-optimization.patch
linux-kernel-markers-i386-optimization-fix.patch
linux-kernel-markers-non-optimized-architectures.patch
linux-kernel-markers-documentation.patch
markers-define-the-linker-macro-extra_rwdata.patch
markers-linker-m68knommu.patch
