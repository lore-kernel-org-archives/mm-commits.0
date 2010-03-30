From: akpm@linux-foundation.org
Subject: + powernow-k8-fix-frequency-reporting.patch added to -mm tree
Date: Tue, 30 Mar 2010 15:44:00 -0700
Message-ID: <201003302244.o2UMi18s009302@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36121 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750962Ab0C3Wo5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Mar 2010 18:44:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mark.langsdorf@amd.com, borislav.petkov@amd.com, davej@codemonkey.org.uk, hpa@zytor.com, mingo@elte.hu, stable@kernel.org, tglx@linutronix.de, trenn@suse.de


The patch titled
     powernow-k8: fix frequency reporting
has been added to the -mm tree.  Its filename is
     powernow-k8-fix-frequency-reporting.patch

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
Subject: powernow-k8: fix frequency reporting
From: Mark Langsdorf <mark.langsdorf@amd.com>

With F10, model 10, all valid frequencies are in the ACPI _PST table.

Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Reviewed-by: Thomas Renninger <trenn@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: Mark Langsdorf <mark.langsdorf@amd.com>
Cc: <stable@kernel.org> # 33.x 32.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN arch/x86/kernel/cpu/cpufreq/powernow-k8.c~powernow-k8-fix-frequency-reporting arch/x86/kernel/cpu/cpufreq/powernow-k8.c
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c~powernow-k8-fix-frequency-reporting
+++ a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -935,7 +935,8 @@ static int fill_powernow_table_pstate(st
 		powernow_table[i].index = index;
 
 		/* Frequency may be rounded for these */
-		if (boot_cpu_data.x86 == 0x10 || boot_cpu_data.x86 == 0x11) {
+		if ((boot_cpu_data.x86 == 0x10 && boot_cpu_data.x86_model < 10)
+				 || boot_cpu_data.x86 == 0x11) {
 			powernow_table[i].frequency =
 				freq_from_fid_did(lo & 0x3f, (lo >> 6) & 7);
 		} else
_

Patches currently in -mm which might be from mark.langsdorf@amd.com are

x86-cpu-add-amd-core-boosting-feature-flag-to-proc-cpuinfo.patch
powernow-k8-add-core-performance-boost-support.patch
x86-unify-aperf-mperf-support.patch
cpufreq-add-aperf-mperf-support-for-amd-processors.patch
powernow-k8-fix-frequency-reporting.patch
cpufreq-unify-sysfs-attribute-definition-macros.patch

