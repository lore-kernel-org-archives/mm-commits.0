From: akpm@linux-foundation.org
Subject: - linux-kernel-markers-non-optimized-architectures.patch removed from -mm tree
Date: Thu, 10 May 2007 15:32:24 -0700
Message-ID: <200705102232.l4AMWOjc032617@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54398 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759150AbXEJWcb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 18:32:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, mm-commits@vger.kernel.org


The patch titled
     Linux Kernel Markers: non optimized architectures
has been removed from the -mm tree.  Its filename was
     linux-kernel-markers-non-optimized-architectures.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Linux Kernel Markers: non optimized architectures
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

This patch also includes marker code for non optimized architectures.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-arm/marker.h       |   13 +++++++++++++
 include/asm-cris/marker.h      |   13 +++++++++++++
 include/asm-frv/marker.h       |   13 +++++++++++++
 include/asm-generic/marker.h   |   30 ++++++++++++++++++++++++++++++
 include/asm-h8300/marker.h     |   13 +++++++++++++
 include/asm-ia64/marker.h      |   13 +++++++++++++
 include/asm-m32r/marker.h      |   13 +++++++++++++
 include/asm-m68k/marker.h      |   13 +++++++++++++
 include/asm-m68knommu/marker.h |   13 +++++++++++++
 include/asm-mips/marker.h      |   13 +++++++++++++
 include/asm-parisc/marker.h    |   13 +++++++++++++
 include/asm-ppc/marker.h       |   13 +++++++++++++
 include/asm-s390/marker.h      |   13 +++++++++++++
 include/asm-sh/marker.h        |   13 +++++++++++++
 include/asm-sh64/marker.h      |   13 +++++++++++++
 include/asm-sparc/marker.h     |   13 +++++++++++++
 include/asm-sparc64/marker.h   |   13 +++++++++++++
 include/asm-um/marker.h        |   13 +++++++++++++
 include/asm-v850/marker.h      |   13 +++++++++++++
 include/asm-x86_64/marker.h    |   13 +++++++++++++
 include/asm-xtensa/marker.h    |   13 +++++++++++++
 21 files changed, 290 insertions(+)

diff -puN /dev/null include/asm-arm/marker.h
--- /dev/null
+++ a/include/asm-arm/marker.h
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
diff -puN /dev/null include/asm-cris/marker.h
--- /dev/null
+++ a/include/asm-cris/marker.h
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
diff -puN /dev/null include/asm-frv/marker.h
--- /dev/null
+++ a/include/asm-frv/marker.h
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
diff -puN /dev/null include/asm-generic/marker.h
--- /dev/null
+++ a/include/asm-generic/marker.h
@@ -0,0 +1,30 @@
+#ifndef _ASM_GENERIC_MARKER_H
+#define _ASM_GENERIC_MARKER_H
+
+/*
+ * marker.h
+ *
+ * Code markup for dynamic and static tracing. Generic header.
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ *
+ * Note : the empty asm volatile with read constraint is used here instead of a
+ * "used" attribute to fix a gcc 4.1.x bug.
+ */
+
+#define _MF_DEFAULT			(_MF_LOCKDEP | _MF_PRINTK)
+
+#define MARK_OPTIMIZED			MARK_GENERIC
+#define _MARK				MARK_GENERIC
+#define trace_mark(format, args...)	_trace_mark(_MF_DEFAULT, format, ## args)
+
+#define MARK_OPTIMIZED_ENABLE_IMMEDIATE_OFFSET \
+		MARK_GENERIC_ENABLE_IMMEDIATE_OFFSET
+#define MARK_OPTIMIZED_ENABLE_TYPE	MARK_GENERIC_ENABLE_TYPE
+/* Dereference enable as lvalue from a pointer to its instruction */
+#define MARK_OPTIMIZED_ENABLE		MARK_GENERIC_ENABLE
+
+#define marker_optimized_set_enable marker_generic_set_enable
+
+#endif /* _ASM_GENERIC_MARKER_H */
diff -puN /dev/null include/asm-h8300/marker.h
--- /dev/null
+++ a/include/asm-h8300/marker.h
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
diff -puN /dev/null include/asm-ia64/marker.h
--- /dev/null
+++ a/include/asm-ia64/marker.h
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
diff -puN /dev/null include/asm-m32r/marker.h
--- /dev/null
+++ a/include/asm-m32r/marker.h
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
diff -puN /dev/null include/asm-m68k/marker.h
--- /dev/null
+++ a/include/asm-m68k/marker.h
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
diff -puN /dev/null include/asm-m68knommu/marker.h
--- /dev/null
+++ a/include/asm-m68knommu/marker.h
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
diff -puN /dev/null include/asm-mips/marker.h
--- /dev/null
+++ a/include/asm-mips/marker.h
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
diff -puN /dev/null include/asm-parisc/marker.h
--- /dev/null
+++ a/include/asm-parisc/marker.h
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
diff -puN /dev/null include/asm-ppc/marker.h
--- /dev/null
+++ a/include/asm-ppc/marker.h
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
diff -puN /dev/null include/asm-s390/marker.h
--- /dev/null
+++ a/include/asm-s390/marker.h
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
diff -puN /dev/null include/asm-sh/marker.h
--- /dev/null
+++ a/include/asm-sh/marker.h
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
diff -puN /dev/null include/asm-sh64/marker.h
--- /dev/null
+++ a/include/asm-sh64/marker.h
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
diff -puN /dev/null include/asm-sparc/marker.h
--- /dev/null
+++ a/include/asm-sparc/marker.h
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
diff -puN /dev/null include/asm-sparc64/marker.h
--- /dev/null
+++ a/include/asm-sparc64/marker.h
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
diff -puN /dev/null include/asm-um/marker.h
--- /dev/null
+++ a/include/asm-um/marker.h
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
diff -puN /dev/null include/asm-v850/marker.h
--- /dev/null
+++ a/include/asm-v850/marker.h
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
diff -puN /dev/null include/asm-x86_64/marker.h
--- /dev/null
+++ a/include/asm-x86_64/marker.h
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
diff -puN /dev/null include/asm-xtensa/marker.h
--- /dev/null
+++ a/include/asm-xtensa/marker.h
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
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
git-avr32.patch
powerpc-promc-remove-undef-printk.patch
linux-kernel-markers-non-optimized-architectures.patch
linux-kernel-markers-non-optimized-architectures-update.patch
linux-kernel-markers-documentation.patch
linux-kernel-markers-documentation-update.patch
markers-define-the-linker-macro-extra_rwdata.patch
markers-use-extra_rwdata-in-architectures.patch
port-of-blktrace-to-the-linux-kernel-markers.patch
