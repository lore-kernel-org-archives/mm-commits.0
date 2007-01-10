From: akpm@osdl.org
Subject: - handle-32-bit-perfmon-counter-writes-cleanly-in-oprofile.patch removed from -mm tree
Date: Wed, 10 Jan 2007 15:04:00 -0800
Message-ID: <200701102304.l0AN40ho010875@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34219 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965237AbXAJXLM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Jan 2007 18:11:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: venkatesh.pallipadi@intel.com, ak@suse.de, eranian@hpl.hp.com, levon@movementarian.org, mingo@elte.hu, phil.el@wanadoo.fr, mm-commits@vger.kernel.org


The patch titled
     Handle 32 bit PerfMon Counter writes cleanly in oprofile
has been removed from the -mm tree.  Its filename was
     handle-32-bit-perfmon-counter-writes-cleanly-in-oprofile.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Handle 32 bit PerfMon Counter writes cleanly in oprofile
From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

Handle these 32 bit perfmon counter MSR writes cleanly in oprofile.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Stephane Eranian <eranian@hpl.hp.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Philippe Elie <phil.el@wanadoo.fr>
Cc: John Levon <levon@movementarian.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/oprofile/op_model_ppro.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff -puN arch/i386/oprofile/op_model_ppro.c~handle-32-bit-perfmon-counter-writes-cleanly-in-oprofile arch/i386/oprofile/op_model_ppro.c
--- a/arch/i386/oprofile/op_model_ppro.c~handle-32-bit-perfmon-counter-writes-cleanly-in-oprofile
+++ a/arch/i386/oprofile/op_model_ppro.c
@@ -24,7 +24,8 @@
 
 #define CTR_IS_RESERVED(msrs,c) (msrs->counters[(c)].addr ? 1 : 0)
 #define CTR_READ(l,h,msrs,c) do {rdmsr(msrs->counters[(c)].addr, (l), (h));} while (0)
-#define CTR_WRITE(l,msrs,c) do {wrmsr(msrs->counters[(c)].addr, -(u32)(l), -1);} while (0)
+#define CTR_32BIT_WRITE(l,msrs,c)	\
+	do {wrmsr(msrs->counters[(c)].addr, -(u32)(l), 0);} while (0)
 #define CTR_OVERFLOWED(n) (!((n) & (1U<<31)))
 
 #define CTRL_IS_RESERVED(msrs,c) (msrs->controls[(c)].addr ? 1 : 0)
@@ -79,7 +80,7 @@ static void ppro_setup_ctrs(struct op_ms
 	for (i = 0; i < NUM_COUNTERS; ++i) {
 		if (unlikely(!CTR_IS_RESERVED(msrs,i)))
 			continue;
-		CTR_WRITE(1, msrs, i);
+		CTR_32BIT_WRITE(1, msrs, i);
 	}
 
 	/* enable active counters */
@@ -87,7 +88,7 @@ static void ppro_setup_ctrs(struct op_ms
 		if ((counter_config[i].enabled) && (CTR_IS_RESERVED(msrs,i))) {
 			reset_value[i] = counter_config[i].count;
 
-			CTR_WRITE(counter_config[i].count, msrs, i);
+			CTR_32BIT_WRITE(counter_config[i].count, msrs, i);
 
 			CTRL_READ(low, high, msrs, i);
 			CTRL_CLEAR(low);
@@ -116,7 +117,7 @@ static int ppro_check_ctrs(struct pt_reg
 		CTR_READ(low, high, msrs, i);
 		if (CTR_OVERFLOWED(low)) {
 			oprofile_add_sample(regs, i);
-			CTR_WRITE(reset_value[i], msrs, i);
+			CTR_32BIT_WRITE(reset_value[i], msrs, i);
 		}
 	}
 
_

Patches currently in -mm which might be from venkatesh.pallipadi@intel.com are

rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues.patch
rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues-fix.patch
rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues-fix-2.patch
rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues-fix-3.patch
ondemand-governor-restructure-the-work-callback.patch
ondemand-governor-use-new-cpufreq-rwsem-locking-in-work-callback.patch
