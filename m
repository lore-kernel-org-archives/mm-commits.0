From: akpm@linux-foundation.org
Subject: - acpi-delete-the-irq-operation-in-throttling-controll-via-ptc.patch removed from -mm tree
Date: Mon, 03 Dec 2007 23:38:46 -0800
Message-ID: <200712040738.lB47ckHF006926@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55765 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751662AbXLDHtK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Dec 2007 02:49:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yakui.zhao@intel.com, mm-commits@vger.kernel.org


The patch titled
     ACPI: delete the IRQ operation in throttling controll via PTC
has been removed from the -mm tree.  Its filename was
     acpi-delete-the-irq-operation-in-throttling-controll-via-ptc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ACPI: delete the IRQ operation in throttling controll via PTC
From: Zhao Yakui <yakui.zhao@intel.com>

The IRQ operation(enable/disable) should be avoided when throttling is
controlled via PTC method.  It is replaced by the migration of task.

Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/processor_throttling.c |   36 ++++++++++++++++++++------
 1 file changed, 28 insertions(+), 8 deletions(-)

diff -puN drivers/acpi/processor_throttling.c~acpi-delete-the-irq-operation-in-throttling-controll-via-ptc drivers/acpi/processor_throttling.c
--- a/drivers/acpi/processor_throttling.c~acpi-delete-the-irq-operation-in-throttling-controll-via-ptc
+++ a/drivers/acpi/processor_throttling.c
@@ -29,6 +29,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/sched.h>
 #include <linux/cpufreq.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
@@ -413,7 +414,7 @@ static int acpi_throttling_rdmsr(struct 
 	} else {
 		msr_low = 0;
 		msr_high = 0;
-		rdmsr_on_cpu(cpu, MSR_IA32_THERM_CONTROL,
+		rdmsr_safe(MSR_IA32_THERM_CONTROL,
 			(u32 *)&msr_low , (u32 *) &msr_high);
 		msr = (msr_high << 32) | msr_low;
 		*value = (acpi_integer) msr;
@@ -438,7 +439,7 @@ static int acpi_throttling_wrmsr(struct 
 			"HARDWARE addr space,NOT supported yet\n");
 	} else {
 		msr = value;
-		wrmsr_on_cpu(cpu, MSR_IA32_THERM_CONTROL,
+		wrmsr_safe(MSR_IA32_THERM_CONTROL,
 			msr & 0xffffffff, msr >> 32);
 		ret = 0;
 	}
@@ -572,21 +573,32 @@ static int acpi_processor_get_throttling
 		return -ENODEV;
 
 	pr->throttling.state = 0;
-	local_irq_disable();
+
 	value = 0;
 	ret = acpi_read_throttling_status(pr, &value);
 	if (ret >= 0) {
 		state = acpi_get_throttling_state(pr, value);
 		pr->throttling.state = state;
 	}
-	local_irq_enable();
 
 	return 0;
 }
 
 static int acpi_processor_get_throttling(struct acpi_processor *pr)
 {
-	return pr->throttling.acpi_processor_get_throttling(pr);
+	cpumask_t saved_mask;
+	int ret;
+
+	/*
+	 * Migrate task to the cpu pointed by pr.
+	 */
+	saved_mask = current->cpus_allowed;
+	set_cpus_allowed(current, cpumask_of_cpu(pr->id));
+	ret = pr->throttling.acpi_processor_get_throttling(pr);
+	/* restore the previous state */
+	set_cpus_allowed(current, saved_mask);
+
+	return ret;
 }
 
 static int acpi_processor_get_fadt_info(struct acpi_processor *pr)
@@ -717,21 +729,29 @@ static int acpi_processor_set_throttling
 	if (state < pr->throttling_platform_limit)
 		return -EPERM;
 
-	local_irq_disable();
 	value = 0;
 	ret = acpi_get_throttling_value(pr, state, &value);
 	if (ret >= 0) {
 		acpi_write_throttling_state(pr, value);
 		pr->throttling.state = state;
 	}
-	local_irq_enable();
 
 	return 0;
 }
 
 int acpi_processor_set_throttling(struct acpi_processor *pr, int state)
 {
-	return pr->throttling.acpi_processor_set_throttling(pr, state);
+	cpumask_t saved_mask;
+	int ret;
+	/*
+	 * Migrate task to the cpu pointed by pr.
+	 */
+	saved_mask = current->cpus_allowed;
+	set_cpus_allowed(current, cpumask_of_cpu(pr->id));
+	ret = pr->throttling.acpi_processor_set_throttling(pr, state);
+	/* restore the previous state */
+	set_cpus_allowed(current, saved_mask);
+	return ret;
 }
 
 int acpi_processor_get_throttling_info(struct acpi_processor *pr)
_

Patches currently in -mm which might be from yakui.zhao@intel.com are
