From: akpm@linux-foundation.org
Subject: + markers-alpha-and-avr32-supportadd-alpha-markerh-add-arm26-markerh.patch added to -mm tree
Date: Tue, 10 Apr 2007 22:03:46 -0700
Message-ID: <200704110503.l3B53knD028920@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59213 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161196AbXDKFEM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Apr 2007 01:04:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, ink@jurassic.park.msu.ru, rth@twiddle.net, spyro@f2s.com


The patch titled
     markers: alpha and avr32 supportAdd alpha marker.h, add arm26 marker.h
has been added to the -mm tree.  Its filename is
     markers-alpha-and-avr32-supportadd-alpha-markerh-add-arm26-markerh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: markers: alpha and avr32 supportAdd alpha marker.h, add arm26 marker.h
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

use the new MF_* bitmask for asm-generic/marker.h.  Document
asm-generic/marker.h.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ian Molton <spyro@f2s.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-alpha/marker.h   |   13 +++++++++++++
 include/asm-arm26/marker.h   |   13 +++++++++++++
 include/asm-generic/marker.h |   11 +++++++++--
 3 files changed, 35 insertions(+), 2 deletions(-)

diff -puN /dev/null include/asm-alpha/marker.h
--- /dev/null
+++ a/include/asm-alpha/marker.h
@@ -0,0 +1,13 @@
+/*
+ * marker.h
+ *
+ * Code markup for dynamic and static tracing. Architecture specific
+ * optimisations.
+ *
+ * No optimisation implemented.
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ */
+
+#include <asm-generic/marker.h>
diff -puN /dev/null include/asm-arm26/marker.h
--- /dev/null
+++ a/include/asm-arm26/marker.h
@@ -0,0 +1,13 @@
+/*
+ * marker.h
+ *
+ * Code markup for dynamic and static tracing. Architecture specific
+ * optimisations.
+ *
+ * No optimisation implemented.
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ */
+
+#include <asm-generic/marker.h>
diff -puN include/asm-generic/marker.h~markers-alpha-and-avr32-supportadd-alpha-markerh-add-arm26-markerh include/asm-generic/marker.h
--- a/include/asm-generic/marker.h~markers-alpha-and-avr32-supportadd-alpha-markerh-add-arm26-markerh
+++ a/include/asm-generic/marker.h
@@ -13,11 +13,18 @@
  * "used" attribute to fix a gcc 4.1.x bug.
  */
 
-#define _MF_DEFAULT			(_MF_LOCKDEP | _MF_PRINTK)
+/* Default flags, used by MARK() */
+#define MF_DEFAULT			(MF_LOCKDEP | MF_PRINTK)
 
+/* Fallback on the generic markers, since no optimized version is available */
 #define MARK_OPTIMIZED			MARK_GENERIC
 #define _MARK				MARK_GENERIC
-#define MARK(format, args...)		_MARK(_MF_DEFAULT, format, ## args)
+
+/* Marker with default behavior */
+#define MARK(format, args...)		_MARK(MF_DEFAULT, format, ## args)
+
+/* Architecture dependant marker information, used internally for marker
+ * activation. */
 
 #define MARK_OPTIMIZED_ENABLE_IMMEDIATE_OFFSET \
 		MARK_GENERIC_ENABLE_IMMEDIATE_OFFSET
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
linux-kernel-markers-architecture-independant-code-markers-document-the-linux-markerh-header.patch
linux-kernel-markers-powerpc-optimization.patch
linux-kernel-markers-powerpc-optimization-markers-changes-to-the-powerpc-marker-header.patch
linux-kernel-markers-i386-optimization.patch
linux-kernel-markers-i386-optimization-fix.patch
linux-kernel-markers-i386-optimization-markers-document-the-i386-marker-header.patch
linux-kernel-markers-non-optimized-architectures.patch
markers-alpha-and-avr32-supportadd-alpha-markerh-add-arm26-markerh.patch
linux-kernel-markers-documentation.patch
markers-define-the-linker-macro-extra_rwdata.patch
markers-use-extra_rwdata-in-architectures.patch
markers-update-documentation.patch
markers-add-instrumentation-markers-menus-to-avr32.patch
markers-add-documentation-to-the-modulec-marker-functions.patch
