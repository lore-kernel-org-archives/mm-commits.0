From: akpm@linux-foundation.org
Subject: + linux-kernel-markers-non-optimized-architectures-update.patch added to -mm tree
Date: Wed, 09 May 2007 20:44:37 -0700
Message-ID: <200705100344.l4A3ibxU011252@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36217 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754345AbXEJDot (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 23:44:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca


The patch titled
     linux-kernel-markers-non-optimized-architectures update
has been added to the -mm tree.  Its filename is
     linux-kernel-markers-non-optimized-architectures-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: linux-kernel-markers-non-optimized-architectures update
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-alpha/marker.h   |   13 +++++++++++++
 include/asm-arm26/marker.h   |   13 +++++++++++++
 include/asm-generic/marker.h |   15 +++++++++++----
 3 files changed, 37 insertions(+), 4 deletions(-)

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
diff -puN include/asm-generic/marker.h~linux-kernel-markers-non-optimized-architectures-update include/asm-generic/marker.h
--- a/include/asm-generic/marker.h~linux-kernel-markers-non-optimized-architectures-update
+++ a/include/asm-generic/marker.h
@@ -13,11 +13,18 @@
  * "used" attribute to fix a gcc 4.1.x bug.
  */
 
-#define _MF_DEFAULT			(_MF_LOCKDEP | _MF_PRINTK)
+/* Default flags, used by MARK() */
+#define MF_DEFAULT			(MF_LOCKDEP | MF_PRINTK)
 
-#define MARK_OPTIMIZED			MARK_GENERIC
-#define _MARK				MARK_GENERIC
-#define trace_mark(format, args...)	_trace_mark(_MF_DEFAULT, format, ## args)
+/* Fallback on the generic markers, since no optimized version is available */
+#define trace_mark_optimized		trace_mark_generic
+#define _trace_mark			trace_mark_generic
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
linux-kernel-markers-documentation.patch
linux-kernel-markers-documentation-update.patch
markers-define-the-linker-macro-extra_rwdata.patch
markers-use-extra_rwdata-in-architectures.patch
port-of-blktrace-to-the-linux-kernel-markers.patch
