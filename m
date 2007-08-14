From: akpm@linux-foundation.org
Subject: - fix-some-x86-x86-64-acpi-cpufreq-driver-issues.patch removed from -mm tree
Date: Tue, 14 Aug 2007 12:15:09 -0700
Message-ID: <200708141915.l7EJF9EG016765@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58812 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932518AbXHNTUx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 15:20:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fenghua.yu@intel.com, akpm@linux-foundation.org, davej@codemonkey.org.uk, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Fix some x86/x86-64 acpi-cpufreq driver issues
has been removed from the -mm tree.  Its filename was
     fix-some-x86-x86-64-acpi-cpufreq-driver-issues.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix some x86/x86-64 acpi-cpufreq driver issues
From: Fenghua Yu <fenghua.yu@intel.com>

This patch addresses some issues in x86/x86-64 acpi-cpufreq driver:

1.  Current memory allocation for acpi_perf_data is actually open-coded
   alloc_percpu().  The patch defines and handles acpi_perf_data as percpu
   data.  The code will be cleaner and easier to be maintained with this
   change.

2. Won't load driver in acpi_cpufreq_early_init() failure case.

3. Add __init for acpi_cpufreq_early_init().

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c |   41 ++++++------------
 drivers/acpi/processor_perflib.c            |    6 +-
 include/acpi/processor.h                    |    2 
 3 files changed, 19 insertions(+), 30 deletions(-)

diff -puN arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c~fix-some-x86-x86-64-acpi-cpufreq-driver-issues arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c
--- a/arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c~fix-some-x86-x86-64-acpi-cpufreq-driver-issues
+++ a/arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -68,7 +68,8 @@ struct acpi_cpufreq_data {
 };
 
 static struct acpi_cpufreq_data *drv_data[NR_CPUS];
-static struct acpi_processor_performance *acpi_perf_data[NR_CPUS];
+/* acpi_perf_data is a pointer to percpu data. */
+static struct acpi_processor_performance *acpi_perf_data;
 
 static struct cpufreq_driver acpi_cpufreq_driver;
 
@@ -508,24 +509,14 @@ acpi_cpufreq_guess_freq(struct acpi_cpuf
  * do _PDC and _PSD and find out the processor dependency for the
  * actual init that will happen later...
  */
-static int acpi_cpufreq_early_init(void)
+static int __init acpi_cpufreq_early_init(void)
 {
-	struct acpi_processor_performance *data;
-	unsigned int i, j;
-
 	dprintk("acpi_cpufreq_early_init\n");
 
-	for_each_possible_cpu(i) {
-		data = kzalloc(sizeof(struct acpi_processor_performance),
-			       GFP_KERNEL);
-		if (!data) {
-			for_each_possible_cpu(j) {
-				kfree(acpi_perf_data[j]);
-				acpi_perf_data[j] = NULL;
-			}
-			return -ENOMEM;
-		}
-		acpi_perf_data[i] = data;
+	acpi_perf_data = alloc_percpu(struct acpi_processor_performance);
+	if (!acpi_perf_data) {
+		dprintk("Memory allocation error for acpi_perf_data.\n");
+		return -ENOMEM;
 	}
 
 	/* Do initialization in ACPI core */
@@ -574,14 +565,11 @@ static int acpi_cpufreq_cpu_init(struct 
 
 	dprintk("acpi_cpufreq_cpu_init\n");
 
-	if (!acpi_perf_data[cpu])
-		return -ENODEV;
-
 	data = kzalloc(sizeof(struct acpi_cpufreq_data), GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
 
-	data->acpi_data = acpi_perf_data[cpu];
+	data->acpi_data = percpu_ptr(acpi_perf_data, cpu);
 	drv_data[cpu] = data;
 
 	if (cpu_has(c, X86_FEATURE_CONSTANT_TSC))
@@ -777,24 +765,25 @@ static struct cpufreq_driver acpi_cpufre
 
 static int __init acpi_cpufreq_init(void)
 {
+	int ret;
+
 	dprintk("acpi_cpufreq_init\n");
 
-	acpi_cpufreq_early_init();
+	ret = acpi_cpufreq_early_init();
+	if (ret)
+		return ret;
 
 	return cpufreq_register_driver(&acpi_cpufreq_driver);
 }
 
 static void __exit acpi_cpufreq_exit(void)
 {
-	unsigned int i;
 	dprintk("acpi_cpufreq_exit\n");
 
 	cpufreq_unregister_driver(&acpi_cpufreq_driver);
 
-	for_each_possible_cpu(i) {
-		kfree(acpi_perf_data[i]);
-		acpi_perf_data[i] = NULL;
-	}
+	free_percpu(acpi_perf_data);
+
 	return;
 }
 
diff -puN drivers/acpi/processor_perflib.c~fix-some-x86-x86-64-acpi-cpufreq-driver-issues drivers/acpi/processor_perflib.c
--- a/drivers/acpi/processor_perflib.c~fix-some-x86-x86-64-acpi-cpufreq-driver-issues
+++ a/drivers/acpi/processor_perflib.c
@@ -539,7 +539,7 @@ end:
 }
 
 int acpi_processor_preregister_performance(
-		struct acpi_processor_performance **performance)
+		struct acpi_processor_performance *performance)
 {
 	int count, count_target;
 	int retval = 0;
@@ -567,12 +567,12 @@ int acpi_processor_preregister_performan
 			continue;
 		}
 
-		if (!performance || !performance[i]) {
+		if (!performance || !percpu_ptr(performance, i)) {
 			retval = -EINVAL;
 			continue;
 		}
 
-		pr->performance = performance[i];
+		pr->performance = percpu_ptr(performance, i);
 		cpu_set(i, pr->performance->shared_cpu_map);
 		if (acpi_processor_get_psd(pr)) {
 			retval = -EINVAL;
diff -puN include/acpi/processor.h~fix-some-x86-x86-64-acpi-cpufreq-driver-issues include/acpi/processor.h
--- a/include/acpi/processor.h~fix-some-x86-x86-64-acpi-cpufreq-driver-issues
+++ a/include/acpi/processor.h
@@ -233,7 +233,7 @@ struct acpi_processor_errata {
 
 extern int acpi_processor_preregister_performance(struct
 						  acpi_processor_performance
-						  **performance);
+						  *performance);
 
 extern int acpi_processor_register_performance(struct acpi_processor_performance
 					       *performance, unsigned int cpu);
_

Patches currently in -mm which might be from fenghua.yu@intel.com are
