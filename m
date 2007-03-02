From: akpm@linux-foundation.org
Subject: + i386-add-the-x86_feature_sync_rdtsc-flag.patch added to -mm tree
Date: Fri, 02 Mar 2007 13:29:45 -0800
Message-ID: <200703022129.l22LTjmB019452@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41691 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965671AbXCBV3w (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 16:29:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joerg.roedel@amd.com, ak@suse.de


The patch titled
     i386: add the X86_FEATURE_SYNC_RDTSC flag
has been added to the -mm tree.  Its filename is
     i386-add-the-x86_feature_sync_rdtsc-flag.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386: add the X86_FEATURE_SYNC_RDTSC flag
From: Joerg Roedel <joerg.roedel@amd.com>

This patch adds the X86_FEATURE_SYNC_RDTSC to the i386 architecture.  This is
very helpfull to simplify the get_cycles_sync() function and remove the
#ifdefs from it.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/amd.c    |    2 ++
 arch/i386/kernel/cpu/intel.c  |    5 ++++-
 include/asm-i386/cpufeature.h |    1 +
 3 files changed, 7 insertions(+), 1 deletion(-)

diff -puN arch/i386/kernel/cpu/amd.c~i386-add-the-x86_feature_sync_rdtsc-flag arch/i386/kernel/cpu/amd.c
--- a/arch/i386/kernel/cpu/amd.c~i386-add-the-x86_feature_sync_rdtsc-flag
+++ a/arch/i386/kernel/cpu/amd.c
@@ -241,6 +241,8 @@ static void __cpuinit init_amd(struct cp
 
 	if (cpuid_eax(0x80000000) >= 0x80000006)
 		num_cache_leaves = 3;
+
+	clear_bit(X86_FEATURE_SYNC_RDTSC, c->x86_capability);
 }
 
 static unsigned int __cpuinit amd_size_cache(struct cpuinfo_x86 * c, unsigned int size)
diff -puN arch/i386/kernel/cpu/intel.c~i386-add-the-x86_feature_sync_rdtsc-flag arch/i386/kernel/cpu/intel.c
--- a/arch/i386/kernel/cpu/intel.c~i386-add-the-x86_feature_sync_rdtsc-flag
+++ a/arch/i386/kernel/cpu/intel.c
@@ -188,8 +188,11 @@ static void __cpuinit init_intel(struct 
 	}
 #endif
 
-	if (c->x86 == 15)
+	if (c->x86 == 15) {
 		set_bit(X86_FEATURE_P4, c->x86_capability);
+		set_bit(X86_FEATURE_SYNC_RDTSC, c->x86_capability);
+	} else
+		clear_bit(X86_FEATURE_SYNC_RDTSC, c->x86_capability);
 	if (c->x86 == 6) 
 		set_bit(X86_FEATURE_P3, c->x86_capability);
 	if ((c->x86 == 0xf && c->x86_model >= 0x03) ||
diff -puN include/asm-i386/cpufeature.h~i386-add-the-x86_feature_sync_rdtsc-flag include/asm-i386/cpufeature.h
--- a/include/asm-i386/cpufeature.h~i386-add-the-x86_feature_sync_rdtsc-flag
+++ a/include/asm-i386/cpufeature.h
@@ -75,6 +75,7 @@
 #define X86_FEATURE_ARCH_PERFMON (3*32+11) /* Intel Architectural PerfMon */
 #define X86_FEATURE_PEBS	(3*32+12)  /* Precise-Event Based Sampling */
 #define X86_FEATURE_BTS		(3*32+13)  /* Branch Trace Store */
+#define X86_FEATURE_SYNC_RDTSC  (3*32+14)  /* RDTSC is serializing */
 
 /* Intel-defined CPU features, CPUID level 0x00000001 (ecx), word 4 */
 #define X86_FEATURE_XMM3	(4*32+ 0) /* Streaming SIMD Extensions-3 */
_

Patches currently in -mm which might be from joerg.roedel@amd.com are

git-kvm.patch
remove-constant_tsc-reporting-from-proc-cpuinfo-power.patch
i386-extend-alternative-instructions-framework.patch
x86_64-changes-to-x86_64-architecture-for.patch
i386-add-the-x86_feature_sync_rdtsc-flag.patch
optimize-and-simplify-get_cycles_sync.patch
