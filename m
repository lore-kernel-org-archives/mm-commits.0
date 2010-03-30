From: akpm@linux-foundation.org
Subject: + x86-unify-aperf-mperf-support.patch added to -mm tree
Date: Tue, 30 Mar 2010 15:43:55 -0700
Message-ID: <201003302243.o2UMht9M009295@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38105 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750962Ab0C3Wov (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Mar 2010 18:44:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: borislav.petkov@amd.com, davej@codemonkey.org.uk, hpa@zytor.com, mark.langsdorf@amd.com, mingo@elte.hu, tglx@linutronix.de, trenn@suse.de


The patch titled
     x86: unify APERF/MPERF support
has been added to the -mm tree.  Its filename is
     x86-unify-aperf-mperf-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: unify APERF/MPERF support
From: Borislav Petkov <borislav.petkov@amd.com>

Initialize this CPUID flag feature in common code.  It could be made a
standalone function later, maybe, if more functionality is duplicated.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Reviewed-by: Thomas Renninger <trenn@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: Mark Langsdorf <mark.langsdorf@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/addon_cpuid_features.c |    8 ++++++++
 arch/x86/kernel/cpu/intel.c                |    6 ------
 2 files changed, 8 insertions(+), 6 deletions(-)

diff -puN arch/x86/kernel/cpu/addon_cpuid_features.c~x86-unify-aperf-mperf-support arch/x86/kernel/cpu/addon_cpuid_features.c
--- a/arch/x86/kernel/cpu/addon_cpuid_features.c~x86-unify-aperf-mperf-support
+++ a/arch/x86/kernel/cpu/addon_cpuid_features.c
@@ -54,6 +54,14 @@ void __cpuinit init_scattered_cpuid_feat
 		if (regs[cb->reg] & (1 << cb->bit))
 			set_cpu_cap(c, cb->feature);
 	}
+
+	/*
+	 * common AMD/Intel features
+	 */
+	if (c->cpuid_level >= 6) {
+		if (cpuid_ecx(6) & 0x1)
+			set_cpu_cap(c, X86_FEATURE_APERFMPERF);
+	}
 }
 
 /* leaf 0xb SMT level */
diff -puN arch/x86/kernel/cpu/intel.c~x86-unify-aperf-mperf-support arch/x86/kernel/cpu/intel.c
--- a/arch/x86/kernel/cpu/intel.c~x86-unify-aperf-mperf-support
+++ a/arch/x86/kernel/cpu/intel.c
@@ -352,12 +352,6 @@ static void __cpuinit init_intel(struct 
 			set_cpu_cap(c, X86_FEATURE_ARCH_PERFMON);
 	}
 
-	if (c->cpuid_level > 6) {
-		unsigned ecx = cpuid_ecx(6);
-		if (ecx & 0x01)
-			set_cpu_cap(c, X86_FEATURE_APERFMPERF);
-	}
