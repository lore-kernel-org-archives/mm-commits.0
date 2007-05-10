From: akpm@linux-foundation.org
Subject: - markers-define-the-linker-macro-extra_rwdata.patch removed from -mm tree
Date: Thu, 10 May 2007 15:32:32 -0700
Message-ID: <200705102232.l4AMWWpw032629@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34954 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759354AbXEJWcj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 18:32:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, linux-arch@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     markers: define the linker macro EXTRA_RWDATA
has been removed from the -mm tree.  Its filename was
     markers-define-the-linker-macro-extra_rwdata.patch

This patch was dropped because an updated version will be merged

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

 include/asm-generic/vmlinux.lds.h |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

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
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
git-avr32.patch
powerpc-promc-remove-undef-printk.patch
markers-define-the-linker-macro-extra_rwdata.patch
markers-use-extra_rwdata-in-architectures.patch
port-of-blktrace-to-the-linux-kernel-markers.patch
