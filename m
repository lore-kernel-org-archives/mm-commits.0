From: akpm@linux-foundation.org
Subject: - local_t-parisc-cleanup.patch removed from -mm tree
Date: Tue, 08 May 2007 19:55:25 -0700
Message-ID: <200705090255.l492tPKc009927@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43471 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032418AbXEIC4Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:56:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, grundler@parisc-linux.org, kyle@mcmartin.ca, willy@debian.org, mm-commits@vger.kernel.org


The patch titled
     local_t: parisc cleanup
has been removed from the -mm tree.  Its filename was
     local_t-parisc-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: local_t: parisc cleanup
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

parisc architecture local_t cleanup : use asm-generic/local.h.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Matthew Wilcox <willy@debian.org>
Cc: Grant Grundler <grundler@parisc-linux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-parisc/local.h |   41 -----------------------------------
 1 file changed, 1 insertion(+), 40 deletions(-)

diff -puN include/asm-parisc/local.h~local_t-parisc-cleanup include/asm-parisc/local.h
--- a/include/asm-parisc/local.h~local_t-parisc-cleanup
+++ a/include/asm-parisc/local.h
@@ -1,40 +1 @@
-#ifndef _ARCH_PARISC_LOCAL_H
-#define _ARCH_PARISC_LOCAL_H
-
-#include <linux/percpu.h>
-#include <asm/atomic.h>
-
-typedef atomic_long_t local_t;
-
-#define LOCAL_INIT(i)	ATOMIC_LONG_INIT(i)
-#define local_read(v)	atomic_long_read(v)
-#define local_set(v,i)	atomic_long_set(v,i)
-
-#define local_inc(v)	atomic_long_inc(v)
-#define local_dec(v)	atomic_long_dec(v)
-#define local_add(i, v)	atomic_long_add(i, v)
-#define local_sub(i, v)	atomic_long_sub(i, v)
-
-#define __local_inc(v)		((v)->counter++)
-#define __local_dec(v)		((v)->counter--)
-#define __local_add(i,v)	((v)->counter+=(i))
-#define __local_sub(i,v)	((v)->counter-=(i))
-
-/* Use these for per-cpu local_t variables: on some archs they are
- * much more efficient than these naive implementations.  Note they take
- * a variable, not an address.
- */
-#define cpu_local_read(v)	local_read(&__get_cpu_var(v))
-#define cpu_local_set(v, i)	local_set(&__get_cpu_var(v), (i))
-
-#define cpu_local_inc(v)	local_inc(&__get_cpu_var(v))
-#define cpu_local_dec(v)	local_dec(&__get_cpu_var(v))
-#define cpu_local_add(i, v)	local_add((i), &__get_cpu_var(v))
-#define cpu_local_sub(i, v)	local_sub((i), &__get_cpu_var(v))
-
-#define __cpu_local_inc(v)	__local_inc(&__get_cpu_var(v))
-#define __cpu_local_dec(v)	__local_dec(&__get_cpu_var(v))
-#define __cpu_local_add(i, v)	__local_add((i), &__get_cpu_var(v))
-#define __cpu_local_sub(i, v)	__local_sub((i), &__get_cpu_var(v))
-
-#endif /* _ARCH_PARISC_LOCAL_H */
+#include <asm-generic/local.h>
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
git-avr32.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-powerpc-optimization.patch
linux-kernel-markers-i386-optimization.patch
markers-add-instrumentation-markers-menus-to-avr32.patch
linux-kernel-markers-non-optimized-architectures.patch
markers-alpha-and-avr32-supportadd-alpha-markerh-add-arm26-markerh.patch
linux-kernel-markers-documentation.patch
markers-define-the-linker-macro-extra_rwdata.patch
markers-use-extra_rwdata-in-architectures.patch
