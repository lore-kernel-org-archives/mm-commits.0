From: akpm@osdl.org
Subject: - cpufreq-set-policy-curfreq-on-initialization.patch removed from -mm tree
Date: Mon, 18 Dec 2006 14:51:08 -0800
Message-ID: <200612182251.kBIMp8wQ015016@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:54140 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754733AbWLRWvP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Dec 2006 17:51:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: malattia@linux.it, venkatesh.pallipadi@intel.com, mm-commits@vger.kernel.org


The patch titled
     cpufreq: set policy->curfreq on initialization
has been removed from the -mm tree.  Its filename was
     cpufreq-set-policy-curfreq-on-initialization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cpufreq: set policy->curfreq on initialization
From: Mattia Dongili <malattia@linux.it>

Check the correct variable and set policy->cur upon acpi-cpufreq
initialization to allow the userspace governor to be used as default.

Signed-off-by: Mattia Dongili <malattia@linux.it>
Acked-by: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c~cpufreq-set-policy-curfreq-on-initialization arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c
--- a/arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c~cpufreq-set-policy-curfreq-on-initialization
+++ a/arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -699,14 +699,14 @@ static int acpi_cpufreq_cpu_init(struct 
 	if (result)
 		goto err_freqfree;
 
-	switch (data->cpu_feature) {
+	switch (perf->control_register.space_id) {
 	case ACPI_ADR_SPACE_SYSTEM_IO:
 		/* Current speed is unknown and not detectable by IO port */
 		policy->cur = acpi_cpufreq_guess_freq(data, policy->cpu);
 		break;
 	case ACPI_ADR_SPACE_FIXED_HARDWARE:
 		acpi_cpufreq_driver.get = get_cur_freq_on_cpu;
-		get_cur_freq_on_cpu(cpu);
+		policy->cur = get_cur_freq_on_cpu(cpu);
 		break;
 	default:
 		break;
_

Patches currently in -mm which might be from malattia@linux.it are

origin.patch
fix-x86_64-mm-i386-config-core2.patch

