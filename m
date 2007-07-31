From: akpm@linux-foundation.org
Subject: - fix-uninitialized-local-variable-covered-in-i386-acpi-cpufreq-driver.patch removed from -mm tree
Date: Tue, 31 Jul 2007 16:54:36 -0700
Message-ID: <200707312354.l6VNsaVt029159@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57106 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756356AbXGaXyn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 19:54:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fenghua.yu@intel.com, venkatesh.pallipadi@intel.com, mm-commits@vger.kernel.org


The patch titled
     Fix uninitialized local variable "covered" in i386 acpi-cpufreq driver
has been removed from the -mm tree.  Its filename was
     fix-uninitialized-local-variable-covered-in-i386-acpi-cpufreq-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix uninitialized local variable "covered" in i386 acpi-cpufreq driver
From: Fenghua Yu <fenghua.yu@intel.com>

The local variable "covered" is used without initialization in i386
acpi-cpufreq driver.  The initial value of covered should be 0.  The bug
will cause memory leak when hit.  The following patch fixes this bug.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c~fix-uninitialized-local-variable-covered-in-i386-acpi-cpufreq-driver arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c
--- a/arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c~fix-uninitialized-local-variable-covered-in-i386-acpi-cpufreq-driver
+++ a/arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -511,7 +511,6 @@ acpi_cpufreq_guess_freq(struct acpi_cpuf
 static int acpi_cpufreq_early_init(void)
 {
 	struct acpi_processor_performance *data;
-	cpumask_t covered;
 	unsigned int i, j;
 
 	dprintk("acpi_cpufreq_early_init\n");
@@ -520,14 +519,13 @@ static int acpi_cpufreq_early_init(void)
 		data = kzalloc(sizeof(struct acpi_processor_performance),
 			       GFP_KERNEL);
 		if (!data) {
-			for_each_cpu_mask(j, covered) {
+			for_each_possible_cpu(j) {
 				kfree(acpi_perf_data[j]);
 				acpi_perf_data[j] = NULL;
 			}
 			return -ENOMEM;
 		}
 		acpi_perf_data[i] = data;
-		cpu_set(i, covered);
 	}
 
 	/* Do initialization in ACPI core */
_

Patches currently in -mm which might be from fenghua.yu@intel.com are

origin.patch
