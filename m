From: akpm@linux-foundation.org
Subject: + x86-move-mtrr-cpu-cap-setting-early-in-early_init_xxxx.patch added to -mm tree
Date: Tue, 02 Sep 2008 16:12:40 -0700
Message-ID: <200809022312.m82NCfeh017737@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45750 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753902AbYIBXNJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Sep 2008 19:13:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yhlu.kernel@gmail.com, krzysztof.h1@wp.pl, mingo@elte.hu, rct@gherkin.frus.com, tglx@linutronix.de


The patch titled
     x86: move mtrr cpu cap setting early in early_init_xxxx
has been added to the -mm tree.  Its filename is
     x86-move-mtrr-cpu-cap-setting-early-in-early_init_xxxx.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: move mtrr cpu cap setting early in early_init_xxxx
From: Yinghai Lu <yhlu.kernel@gmail.com>

Krzysztof Helt <krzysztof.h1@wp.pl> found mtrr is not detected on k6-2

root cause: we move mtrr_bp_init early for mtrr trimming.  and in
early_detect, only read cap from cpuid, so some cpu doesn't have that bit
in cpuid and need to set workaround bit will have problem.

Need to add early_init_xxxx to preset those bit before mtrr_bp_init for
those earlier cpus.

Reported-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Bob Tracy <rct@gherkin.frus.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/amd.c     |    9 +++++----
 arch/x86/kernel/cpu/centaur.c |   11 +++++++++++
 arch/x86/kernel/cpu/cyrix.c   |   32 ++++++++++++++++++++++++++++----
 3 files changed, 44 insertions(+), 8 deletions(-)

diff -puN arch/x86/kernel/cpu/amd.c~x86-move-mtrr-cpu-cap-setting-early-in-early_init_xxxx arch/x86/kernel/cpu/amd.c
--- a/arch/x86/kernel/cpu/amd.c~x86-move-mtrr-cpu-cap-setting-early-in-early_init_xxxx
+++ a/arch/x86/kernel/cpu/amd.c
@@ -31,6 +31,11 @@ static void __cpuinit early_init_amd(str
 		if (c->x86_power & (1<<8))
 			set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
 	}
+
+	/*  Set MTRR capability flag if appropriate */
+	if (c->x86_model == 13 || c->x86_model == 9 ||
+	   (c->x86_model == 8 && c->x86_mask >= 8))
+		set_cpu_cap(c, X86_FEATURE_K6_MTRR);
 }
 
 static void __cpuinit init_amd(struct cpuinfo_x86 *c)
@@ -166,10 +171,6 @@ static void __cpuinit init_amd(struct cp
 						mbytes);
 				}
 
-				/*  Set MTRR capability flag if appropriate */
-				if (c->x86_model == 13 || c->x86_model == 9 ||
-				   (c->x86_model == 8 && c->x86_mask >= 8))
-					set_cpu_cap(c, X86_FEATURE_K6_MTRR);
 				break;
 			}
 
diff -puN arch/x86/kernel/cpu/centaur.c~x86-move-mtrr-cpu-cap-setting-early-in-early_init_xxxx arch/x86/kernel/cpu/centaur.c
--- a/arch/x86/kernel/cpu/centaur.c~x86-move-mtrr-cpu-cap-setting-early-in-early_init_xxxx
+++ a/arch/x86/kernel/cpu/centaur.c
@@ -314,6 +314,16 @@ enum {
 		EAMD3D		= 1<<20,
 };
 
+static void __cpuinit early_init_centaur(struct cpuinfo_x86 *c)
+{
+	switch (c->x86) {
+	case 5:
+		/* Emulate MTRRs using Centaur's MCR. */
+		set_cpu_cap(c, X86_FEATURE_CENTAUR_MCR);
+		break;
+	}
+}
+
 static void __cpuinit init_centaur(struct cpuinfo_x86 *c)
 {
 
@@ -462,6 +472,7 @@ centaur_size_cache(struct cpuinfo_x86 *c
 static struct cpu_dev centaur_cpu_dev __cpuinitdata = {
 	.c_vendor	= "Centaur",
 	.c_ident	= { "CentaurHauls" },
+	.c_early_init	= early_init_centaur,
 	.c_init		= init_centaur,
 	.c_size_cache	= centaur_size_cache,
 };
diff -puN arch/x86/kernel/cpu/cyrix.c~x86-move-mtrr-cpu-cap-setting-early-in-early_init_xxxx arch/x86/kernel/cpu/cyrix.c
--- a/arch/x86/kernel/cpu/cyrix.c~x86-move-mtrr-cpu-cap-setting-early-in-early_init_xxxx
+++ a/arch/x86/kernel/cpu/cyrix.c
@@ -15,13 +15,11 @@
 /*
  * Read NSC/Cyrix DEVID registers (DIR) to get more detailed info. about the CPU
  */
-static void __cpuinit do_cyrix_devid(unsigned char *dir0, unsigned char *dir1)
+static void __cpuinit __do_cyrix_devid(unsigned char *dir0, unsigned char *dir1)
 {
 	unsigned char ccr2, ccr3;
-	unsigned long flags;
 
 	/* we test for DEVID by checking whether CCR3 is writable */
-	local_irq_save(flags);
 	ccr3 = getCx86(CX86_CCR3);
 	setCx86(CX86_CCR3, ccr3 ^ 0x80);
 	getCx86(0xc0);   /* dummy to change bus */
@@ -44,9 +42,16 @@ static void __cpuinit do_cyrix_devid(uns
 		*dir0 = getCx86(CX86_DIR0);
 		*dir1 = getCx86(CX86_DIR1);
 	}
-	local_irq_restore(flags);
 }
 
+static void __cpuinit do_cyrix_devid(unsigned char *dir0, unsigned char *dir1)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	__do_cyrix_devid(dir0, dir1);
+	local_irq_restore(flags);
+}
 /*
  * Cx86_dir0_msb is a HACK needed by check_cx686_cpuid/slop in bugs.h in
  * order to identify the Cyrix CPU model after we're out of setup.c
@@ -161,6 +166,24 @@ static void __cpuinit geode_configure(vo
 	local_irq_restore(flags);
 }
 
+static void __cpuinit early_init_cyrix(struct cpuinfo_x86 *c)
+{
+	unsigned char dir0, dir0_msn, dir1 = 0;
+
+	__do_cyrix_devid(&dir0, &dir1);
+	dir0_msn = dir0 >> 4; /* identifies CPU "family"   */
+
+	switch (dir0_msn) {
+	case 3: /* 6x86/6x86L */
+		/* Emulate MTRRs using Cyrix's ARRs. */
+		set_cpu_cap(c, X86_FEATURE_CYRIX_ARR);
+		break;
+	case 5: /* 6x86MX/M II */
+		/* Emulate MTRRs using Cyrix's ARRs. */
+		set_cpu_cap(c, X86_FEATURE_CYRIX_ARR);
+		break;
+	}
+}
 
 static void __cpuinit init_cyrix(struct cpuinfo_x86 *c)
 {
@@ -416,6 +439,7 @@ static void __cpuinit cyrix_identify(str
 static struct cpu_dev cyrix_cpu_dev __cpuinitdata = {
 	.c_vendor	= "Cyrix",
 	.c_ident	= { "CyrixInstead" },
+	.c_early_init	= early_init_cyrix,
 	.c_init		= init_cyrix,
 	.c_identify	= cyrix_identify,
 };
_

Patches currently in -mm which might be from yhlu.kernel@gmail.com are

origin.patch
linux-next.patch
dyn_array-use-%pf-instead-of-print_fn_descriptor_symbol.patch
dyn_array-fix-typo.patch
forcedeth-fix-kexec-regression.patch
x86-delay-early-cpu-initialization-until-cpuid-is-done.patch
x86-move-mtrr-cpu-cap-setting-early-in-early_init_xxxx.patch

