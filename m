From: akpm@linux-foundation.org
Subject: - markers-alpha-and-avr32-supportadd-alpha-markerh-add-arm26-markerh.patch removed from -mm tree
Date: Wed, 09 May 2007 20:40:29 -0700
Message-ID: <200705100340.l4A3eTK5011196@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48249 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753205AbXEJDla (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 23:41:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, ink@jurassic.park.msu.ru, rth@twiddle.net, spyro@f2s.com, mm-commits@vger.kernel.org


The patch titled
     markers: alpha and avr32 supportAdd alpha marker.h, add arm26 marker.h
has been removed from the -mm tree.  Its filename was
     markers-alpha-and-avr32-supportadd-alpha-markerh-add-arm26-markerh.patch

This patch was dropped because it is obsolete

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
+/* Default flags, used by trace_mark() */
+#define MF_DEFAULT			(MF_LOCKDEP | MF_PRINTK)
 
+/* Fallback on the generic markers, since no optimized version is available */
 #define MARK_OPTIMIZED			MARK_GENERIC
 #define _MARK				MARK_GENERIC
-#define trace_mark(format, args...)	_trace_mark(_MF_DEFAULT, format, ## args)
+
+/* Marker with default behavior */
+#define trace_mark(format, args...)	_trace_mark(MF_DEFAULT, format, ## args)
+
+/* Architecture dependant marker information, used internally for marker
+ * activation. */
 
 #define MARK_OPTIMIZED_ENABLE_IMMEDIATE_OFFSET \
 		MARK_GENERIC_ENABLE_IMMEDIATE_OFFSET
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
x86_64-fix-default_do_nmi-missing-return-after-a-if.patch
git-avr32.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-kconfig-menus-update.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-architecture-independant-code-update.patch
allow-userspace-applications-to-use-markerh-to-parse-the-markers-section-in-the-kernel-binary.patch
linux-kernel-markers-powerpc-optimization.patch
linux-kernel-markers-powerpc-optimization-update.patch
linux-kernel-markers-i386-optimization.patch
linux-kernel-markers-i386-optimization-update.patch
linux-kernel-markers-non-optimized-architectures.patch
linux-kernel-markers-non-optimized-architectures-update.patch
markers-alpha-and-avr32-supportadd-alpha-markerh-add-arm26-markerh.patch
linux-kernel-markers-documentation.patch
markers-define-the-linker-macro-extra_rwdata.patch
markers-use-extra_rwdata-in-architectures.patch
