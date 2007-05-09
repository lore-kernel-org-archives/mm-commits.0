From: akpm@linux-foundation.org
Subject: - local_t-sparc64-cleanup.patch removed from -mm tree
Date: Tue, 08 May 2007 19:55:31 -0700
Message-ID: <200705090255.l492tV4P009937@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49364 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032307AbXEICzj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:55:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     local_t: sparc64 cleanup
has been removed from the -mm tree.  Its filename was
     local_t-sparc64-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: local_t: sparc64 cleanup
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

sparc64 local_t cleanup : simply use asm-generic/local.h.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-sparc64/local.h |   41 ----------------------------------
 1 file changed, 1 insertion(+), 40 deletions(-)

diff -puN include/asm-sparc64/local.h~local_t-sparc64-cleanup include/asm-sparc64/local.h
--- a/include/asm-sparc64/local.h~local_t-sparc64-cleanup
+++ a/include/asm-sparc64/local.h
@@ -1,40 +1 @@
-#ifndef _ARCH_SPARC64_LOCAL_H
-#define _ARCH_SPARC64_LOCAL_H
-
-#include <linux/percpu.h>
-#include <asm/atomic.h>
-
-typedef atomic64_t local_t;
-
-#define LOCAL_INIT(i)	ATOMIC64_INIT(i)
-#define local_read(v)	atomic64_read(v)
-#define local_set(v,i)	atomic64_set(v,i)
-
-#define local_inc(v)	atomic64_inc(v)
-#define local_dec(v)	atomic64_dec(v)
-#define local_add(i, v)	atomic64_add(i, v)
-#define local_sub(i, v)	atomic64_sub(i, v)
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
-#endif /* _ARCH_SPARC64_LOCAL_H */
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
