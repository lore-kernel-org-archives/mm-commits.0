From: akpm@linux-foundation.org
Subject: - immediate-values-non-optimized-architectures.patch removed from -mm tree
Date: Fri, 06 Jul 2007 17:28:39 -0700
Message-ID: <200707070032.l670Woj0029801@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60300 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753044AbXGGAdC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jul 2007 20:33:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, mm-commits@vger.kernel.org


The patch titled
     Immediate Values: non Optimized Architectures
has been removed from the -mm tree.  Its filename was
     immediate-values-non-optimized-architectures.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: Immediate Values: non Optimized Architectures
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Architecture agnostic, generic, version of the immediate values.  It uses a
global variable to mimic the immediate values.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-alpha/immediate.h     |    1 +
 include/asm-arm/immediate.h       |    1 +
 include/asm-arm26/immediate.h     |    1 +
 include/asm-cris/immediate.h      |    1 +
 include/asm-frv/immediate.h       |    1 +
 include/asm-generic/immediate.h   |   14 ++++++++++++++
 include/asm-h8300/immediate.h     |    1 +
 include/asm-i386/immediate.h      |    1 +
 include/asm-ia64/immediate.h      |    1 +
 include/asm-m32r/immediate.h      |    1 +
 include/asm-m68k/immediate.h      |    1 +
 include/asm-m68knommu/immediate.h |    1 +
 include/asm-mips/immediate.h      |    1 +
 include/asm-parisc/immediate.h    |    1 +
 include/asm-powerpc/immediate.h   |    1 +
 include/asm-ppc/immediate.h       |    1 +
 include/asm-s390/immediate.h      |    1 +
 include/asm-sh/immediate.h        |    1 +
 include/asm-sh64/immediate.h      |    1 +
 include/asm-sparc/immediate.h     |    1 +
 include/asm-sparc64/immediate.h   |    1 +
 include/asm-um/immediate.h        |    1 +
 include/asm-v850/immediate.h      |    1 +
 include/asm-x86_64/immediate.h    |    1 +
 include/asm-xtensa/immediate.h    |    1 +
 25 files changed, 38 insertions(+)

diff -puN /dev/null include/asm-alpha/immediate.h
--- /dev/null
+++ a/include/asm-alpha/immediate.h
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
diff -puN /dev/null include/asm-arm/immediate.h
--- /dev/null
+++ a/include/asm-arm/immediate.h
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
diff -puN /dev/null include/asm-arm26/immediate.h
--- /dev/null
+++ a/include/asm-arm26/immediate.h
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
diff -puN /dev/null include/asm-cris/immediate.h
--- /dev/null
+++ a/include/asm-cris/immediate.h
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
diff -puN /dev/null include/asm-frv/immediate.h
--- /dev/null
+++ a/include/asm-frv/immediate.h
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
diff -puN /dev/null include/asm-generic/immediate.h
--- /dev/null
+++ a/include/asm-generic/immediate.h
@@ -0,0 +1,14 @@
+#ifndef _ASM_GENERIC_IMMEDIATE_H
+#define _ASM_GENERIC_IMMEDIATE_H
+
+/* Default flags, used by _immediate() */
+#define IF_DEFAULT			0
+
+/* Fallback on the generic immediate, since no optimized version is available */
+#define immediate_optimized		immediate_generic
+#define _immediate(flags, var)		immediate_generic(flags, var)
+
+/* immediate with default behavior */
+#define immediate(var)		_immediate(IF_DEFAULT, var)
+
+#endif /* _ASM_GENERIC_IMMEDIATE_H */
diff -puN /dev/null include/asm-h8300/immediate.h
--- /dev/null
+++ a/include/asm-h8300/immediate.h
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
diff -puN /dev/null include/asm-i386/immediate.h
--- /dev/null
+++ a/include/asm-i386/immediate.h
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
diff -puN /dev/null include/asm-ia64/immediate.h
--- /dev/null
+++ a/include/asm-ia64/immediate.h
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
diff -puN /dev/null include/asm-m32r/immediate.h
--- /dev/null
+++ a/include/asm-m32r/immediate.h
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
diff -puN /dev/null include/asm-m68k/immediate.h
--- /dev/null
+++ a/include/asm-m68k/immediate.h
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
diff -puN /dev/null include/asm-m68knommu/immediate.h
--- /dev/null
+++ a/include/asm-m68knommu/immediate.h
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
diff -puN /dev/null include/asm-mips/immediate.h
--- /dev/null
+++ a/include/asm-mips/immediate.h
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
diff -puN /dev/null include/asm-parisc/immediate.h
--- /dev/null
+++ a/include/asm-parisc/immediate.h
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
diff -puN /dev/null include/asm-powerpc/immediate.h
--- /dev/null
+++ a/include/asm-powerpc/immediate.h
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
diff -puN /dev/null include/asm-ppc/immediate.h
--- /dev/null
+++ a/include/asm-ppc/immediate.h
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
diff -puN /dev/null include/asm-s390/immediate.h
--- /dev/null
+++ a/include/asm-s390/immediate.h
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
diff -puN /dev/null include/asm-sh/immediate.h
--- /dev/null
+++ a/include/asm-sh/immediate.h
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
diff -puN /dev/null include/asm-sh64/immediate.h
--- /dev/null
+++ a/include/asm-sh64/immediate.h
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
diff -puN /dev/null include/asm-sparc/immediate.h
--- /dev/null
+++ a/include/asm-sparc/immediate.h
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
diff -puN /dev/null include/asm-sparc64/immediate.h
--- /dev/null
+++ a/include/asm-sparc64/immediate.h
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
diff -puN /dev/null include/asm-um/immediate.h
--- /dev/null
+++ a/include/asm-um/immediate.h
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
diff -puN /dev/null include/asm-v850/immediate.h
--- /dev/null
+++ a/include/asm-v850/immediate.h
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
diff -puN /dev/null include/asm-x86_64/immediate.h
--- /dev/null
+++ a/include/asm-x86_64/immediate.h
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
diff -puN /dev/null include/asm-xtensa/immediate.h
--- /dev/null
+++ a/include/asm-xtensa/immediate.h
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

powerpc-promc-remove-undef-printk.patch
immediate-values-non-optimized-architectures.patch
immediate-value-add-kconfig-menus.patch
immediate-values-kprobe-header-fix.patch
immediate-value-i386-optimization.patch
immediate-value-powerpc-optimization.patch
immediate-value-documentation.patch
f00f-bug-fixup-for-i386-use-immediate-values.patch
scheduler-profiling-use-immediate-values.patch
scheduler-profiling-use-immediate-values-fix.patch
cxgb3-vs-immediate-stuff.patch
use-data_data-in-cris.patch
add-missing-data_data-in-powerpc.patch
use-data_data-in-xtensa.patch
linux-kernel-markers-architecture-independent-code.patch
linux-kernel-markers-add-kconfig-menus-for-the-marker-code.patch
linux-kernel-markers-documentation.patch
port-of-blktrace-to-the-linux-kernel-markers.patch
port-of-blktrace-to-the-linux-kernel-markers-fix.patch
