From: akpm@linux-foundation.org
Subject: - i386-make-x86_64-tsc-header-require-i386-rather-than-vice-versa.patch removed from -mm tree
Date: Tue, 06 Mar 2007 20:21:09 -0800
Message-ID: <200703070421.l274L9qu018874@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47015 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161297AbXCGEVX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 23:21:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dilinger@debian.org, ak@suse.de, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     i386: make x86_64 tsc header require i386 rather than vice-versa
has been removed from the -mm tree.  Its filename was
     i386-make-x86_64-tsc-header-require-i386-rather-than-vice-versa.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386: make x86_64 tsc header require i386 rather than vice-versa
From: Andres Salomon <dilinger@debian.org>

Prior to commit 95492e4646e5de8b43d9a7908d6177fb737b61f0 ([PATCH] x86:
rewrite SMP TSC sync code), the headers in asm-i386 did not really require
anything in include/asm-x86_64.  This means that distributions such as
fedora did not include asm-x86_64 in kernel-devel headers for i386.  Ingo's
commit changed that, and broke things.  This is easy enough to hack around
in package builds by just including asm-x86_64 on i386, but that's kind of
annoying.  If anything, x86_64 should depend upon i386, not the other way
around.

This patch changes it so that asm-x86_64/tsc.h includes asm-i386/tsc.h,
rather than vice-versa.

Signed-off-by: Andres Salomon <dilinger@debian.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-i386/tsc.h   |   68 ++++++++++++++++++++++++++++++++++++-
 include/asm-x86_64/tsc.h |   68 -------------------------------------
 2 files changed, 68 insertions(+), 68 deletions(-)

diff -puN include/asm-i386/tsc.h~i386-make-x86_64-tsc-header-require-i386-rather-than-vice-versa include/asm-i386/tsc.h
--- a/include/asm-i386/tsc.h~i386-make-x86_64-tsc-header-require-i386-rather-than-vice-versa
+++ a/include/asm-i386/tsc.h
@@ -1 +1,67 @@
-#include <asm-x86_64/tsc.h>
+/*
+ * linux/include/asm-i386/tsc.h
+ *
+ * i386 TSC related functions
+ */
+#ifndef _ASM_i386_TSC_H
+#define _ASM_i386_TSC_H
+
+#include <asm/processor.h>
+
+/*
+ * Standard way to access the cycle counter.
+ */
+typedef unsigned long long cycles_t;
+
+extern unsigned int cpu_khz;
+extern unsigned int tsc_khz;
+
+static inline cycles_t get_cycles(void)
+{
+	unsigned long long ret = 0;
+
+#ifndef CONFIG_X86_TSC
+	if (!cpu_has_tsc)
+		return 0;
+#endif
+
+#if defined(CONFIG_X86_GENERIC) || defined(CONFIG_X86_TSC)
+	rdtscll(ret);
+#endif
+	return ret;
+}
+
+/* Like get_cycles, but make sure the CPU is synchronized. */
+static __always_inline cycles_t get_cycles_sync(void)
+{
+	unsigned long long ret;
+#ifdef X86_FEATURE_SYNC_RDTSC
+	unsigned eax;
+
+	/*
+	 * Don't do an additional sync on CPUs where we know
+	 * RDTSC is already synchronous:
+	 */
+	alternative_io("cpuid", ASM_NOP2, X86_FEATURE_SYNC_RDTSC,
+			  "=a" (eax), "0" (1) : "ebx","ecx","edx","memory");
+#else
+	sync_core();
+#endif
+	rdtscll(ret);
+
+	return ret;
+}
+
+extern void tsc_init(void);
+extern void mark_tsc_unstable(void);
+extern int unsynchronized_tsc(void);
+extern void init_tsc_clocksource(void);
+
+/*
+ * Boot-time check whether the TSCs are synchronized across
+ * all CPUs/cores:
+ */
+extern void check_tsc_sync_source(int cpu);
+extern void check_tsc_sync_target(void);
+
+#endif
diff -puN include/asm-x86_64/tsc.h~i386-make-x86_64-tsc-header-require-i386-rather-than-vice-versa include/asm-x86_64/tsc.h
--- a/include/asm-x86_64/tsc.h~i386-make-x86_64-tsc-header-require-i386-rather-than-vice-versa
+++ a/include/asm-x86_64/tsc.h
@@ -1,67 +1 @@
-/*
- * linux/include/asm-x86_64/tsc.h
- *
- * x86_64 TSC related functions
- */
-#ifndef _ASM_x86_64_TSC_H
-#define _ASM_x86_64_TSC_H
-
-#include <asm/processor.h>
-
-/*
- * Standard way to access the cycle counter.
- */
-typedef unsigned long long cycles_t;
-
-extern unsigned int cpu_khz;
-extern unsigned int tsc_khz;
-
-static inline cycles_t get_cycles(void)
-{
-	unsigned long long ret = 0;
-
-#ifndef CONFIG_X86_TSC
-	if (!cpu_has_tsc)
-		return 0;
-#endif
-
-#if defined(CONFIG_X86_GENERIC) || defined(CONFIG_X86_TSC)
-	rdtscll(ret);
-#endif
-	return ret;
-}
-
-/* Like get_cycles, but make sure the CPU is synchronized. */
-static __always_inline cycles_t get_cycles_sync(void)
-{
-	unsigned long long ret;
-#ifdef X86_FEATURE_SYNC_RDTSC
-	unsigned eax;
-
-	/*
-	 * Don't do an additional sync on CPUs where we know
-	 * RDTSC is already synchronous:
-	 */
-	alternative_io("cpuid", ASM_NOP2, X86_FEATURE_SYNC_RDTSC,
-			  "=a" (eax), "0" (1) : "ebx","ecx","edx","memory");
-#else
-	sync_core();
-#endif
-	rdtscll(ret);
-
-	return ret;
-}
-
-extern void tsc_init(void);
-extern void mark_tsc_unstable(void);
-extern int unsynchronized_tsc(void);
-extern void init_tsc_clocksource(void);
-
-/*
- * Boot-time check whether the TSCs are synchronized across
- * all CPUs/cores:
- */
-extern void check_tsc_sync_source(int cpu);
-extern void check_tsc_sync_target(void);
-
-#endif
+#include <asm-i386/tsc.h>
_

Patches currently in -mm which might be from dilinger@debian.org are

origin.patch
