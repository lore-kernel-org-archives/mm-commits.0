From: akpm@linux-foundation.org
Subject: [merged] x86-cpu-add-amd-core-boosting-feature-flag-to-proc-cpuinfo.patch removed from -mm tree
Date: Wed, 31 Mar 2010 11:53:11 -0400
Message-ID: <201003311854.o2VIsL14002108@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40932 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751285Ab0CaSyv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Mar 2010 14:54:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: borislav.petkov@amd.com, davej@codemonkey.org.uk, hpa@zytor.com, mark.langsdorf@amd.com, mingo@elte.hu, tglx@linutronix.de, trenn@suse.de, mm-commits@vger.kernel.org


The patch titled
     x86, cpu: add AMD core boosting feature flag to /proc/cpuinfo
has been removed from the -mm tree.  Its filename was
     x86-cpu-add-amd-core-boosting-feature-flag-to-proc-cpuinfo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86, cpu: add AMD core boosting feature flag to /proc/cpuinfo
From: Borislav Petkov <borislav.petkov@amd.com>

By semi-popular demand, this adds the Core Performance Boost feature flag
to /proc/cpuinfo.  Possible use case for this is userspace tools like
cpufreq-aperf, for example, so that they don't have to jump through hoops
of accessing "/dev/cpu/%d/cpuid" in order to check for CPB hw support, or
call cpuid from userspace.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Reviewed-by: Thomas Renninger <trenn@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: Mark Langsdorf <mark.langsdorf@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/cpufeature.h          |    1 +
 arch/x86/kernel/cpu/addon_cpuid_features.c |    5 +++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff -puN arch/x86/include/asm/cpufeature.h~x86-cpu-add-amd-core-boosting-feature-flag-to-proc-cpuinfo arch/x86/include/asm/cpufeature.h
--- a/arch/x86/include/asm/cpufeature.h~x86-cpu-add-amd-core-boosting-feature-flag-to-proc-cpuinfo
+++ a/arch/x86/include/asm/cpufeature.h
@@ -161,6 +161,7 @@
  */
 #define X86_FEATURE_IDA		(7*32+ 0) /* Intel Dynamic Acceleration */
 #define X86_FEATURE_ARAT	(7*32+ 1) /* Always Running APIC Timer */
+#define X86_FEATURE_CPB		(7*32+ 2) /* AMD Core Performance Boost */
 
 /* Virtualization flags: Linux defined */
 #define X86_FEATURE_TPR_SHADOW  (8*32+ 0) /* Intel TPR Shadow */
diff -puN arch/x86/kernel/cpu/addon_cpuid_features.c~x86-cpu-add-amd-core-boosting-feature-flag-to-proc-cpuinfo arch/x86/kernel/cpu/addon_cpuid_features.c
--- a/arch/x86/kernel/cpu/addon_cpuid_features.c~x86-cpu-add-amd-core-boosting-feature-flag-to-proc-cpuinfo
+++ a/arch/x86/kernel/cpu/addon_cpuid_features.c
@@ -30,8 +30,9 @@ void __cpuinit init_scattered_cpuid_feat
 	const struct cpuid_bit *cb;
 
 	static const struct cpuid_bit __cpuinitconst cpuid_bits[] = {
-		{ X86_FEATURE_IDA, CR_EAX, 1, 0x00000006 },
-		{ X86_FEATURE_ARAT, CR_EAX, 2, 0x00000006 },
+		{ X86_FEATURE_IDA,   CR_EAX, 1, 0x00000006 },
+		{ X86_FEATURE_ARAT,  CR_EAX, 2, 0x00000006 },
+		{ X86_FEATURE_CPB,   CR_EDX, 9, 0x80000007 },
 		{ X86_FEATURE_NPT,   CR_EDX, 0, 0x8000000a },
 		{ X86_FEATURE_LBRV,  CR_EDX, 1, 0x8000000a },
 		{ X86_FEATURE_SVML,  CR_EDX, 2, 0x8000000a },
_

Patches currently in -mm which might be from borislav.petkov@amd.com are

linux-next.patch
x86-add-optimized-popcnt-variants.patch

