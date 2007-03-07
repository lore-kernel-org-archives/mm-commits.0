From: akpm@linux-foundation.org
Subject: - optimize-and-simplify-get_cycles_sync.patch removed from -mm tree
Date: Tue, 06 Mar 2007 20:20:08 -0800
Message-ID: <200703070420.l274K8kI018827@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46910 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161276AbXCGEUQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 23:20:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joerg.roedel@amd.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     optimize and simplify get_cycles_sync()
has been removed from the -mm tree.  Its filename was
     optimize-and-simplify-get_cycles_sync.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: optimize and simplify get_cycles_sync()
From: Joerg Roedel <joerg.roedel@amd.com>

This patch simplifies the get_cycles_sync() function by removing the #ifdefs
from it.  Further it introduces an optimization for AMD processors.  There the
RDTSCP instruction is used instead of CPUID;RDTSC which is helpfull if the
kernel runs as a KVM guest.  Running as a guest makes CPUID very expensive
because it causes an intercept of the guest.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-i386/cpufeature.h |    1 +
 include/asm-i386/tsc.h        |   21 +++++++--------------
 2 files changed, 8 insertions(+), 14 deletions(-)

diff -puN include/asm-i386/cpufeature.h~optimize-and-simplify-get_cycles_sync include/asm-i386/cpufeature.h
--- a/include/asm-i386/cpufeature.h~optimize-and-simplify-get_cycles_sync
+++ a/include/asm-i386/cpufeature.h
@@ -49,6 +49,7 @@
 #define X86_FEATURE_MP		(1*32+19) /* MP Capable. */
 #define X86_FEATURE_NX		(1*32+20) /* Execute Disable */
 #define X86_FEATURE_MMXEXT	(1*32+22) /* AMD MMX extensions */
+#define X86_FEATURE_RDTSCP      (1*32+27) /* RDTSCP */
 #define X86_FEATURE_LM		(1*32+29) /* Long Mode (x86-64) */
 #define X86_FEATURE_3DNOWEXT	(1*32+30) /* AMD 3DNow! extensions */
 #define X86_FEATURE_3DNOW	(1*32+31) /* 3DNow! */
diff -puN include/asm-i386/tsc.h~optimize-and-simplify-get_cycles_sync include/asm-i386/tsc.h
--- a/include/asm-i386/tsc.h~optimize-and-simplify-get_cycles_sync
+++ a/include/asm-i386/tsc.h
@@ -34,22 +34,15 @@ static inline cycles_t get_cycles(void)
 /* Like get_cycles, but make sure the CPU is synchronized. */
 static __always_inline cycles_t get_cycles_sync(void)
 {
-	unsigned long long ret;
-#ifdef X86_FEATURE_SYNC_RDTSC
-	unsigned eax;
+	unsigned int a, d;
 
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
+	alternative_io_two("cpuid\nrdtsc",
+			   "rdtsc", X86_FEATURE_SYNC_RDTSC,
+			   "rdtscp", X86_FEATURE_RDTSCP,
+			   ASM_OUTPUT2("=a" (a), "=d" (d)),
+			   "0" (1) : "ecx", "memory");
 
-	return ret;
+	return ((unsigned long long)a) | (((unsigned long long)d)<<32);
 }
 
 extern void tsc_init(void);
_

Patches currently in -mm which might be from joerg.roedel@amd.com are

origin.patch
git-kvm.patch
remove-constant_tsc-reporting-from-proc-cpuinfo-power.patch
i386-extend-alternative-instructions-framework.patch
x86_64-changes-to-x86_64-architecture-for.patch
optimize-and-simplify-get_cycles_sync.patch
revert-optimize-and-simplify-get_cycles_sync.patch
