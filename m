From: akpm@linux-foundation.org
Subject: + revert-preregister-support-for-powernow-k8.patch added to -mm tree
Date: Tue, 19 Aug 2008 13:06:57 -0700
Message-ID: <200808192006.m7JK6wwY003794@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58123 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750828AbYHSUIb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Aug 2008 16:08:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, davej@redhat.com, frank.arnold@amd.com, mark.langsdorf@amd.com


The patch titled
     Revert "[CPUFREQ][2/2] preregister support for powernow-k8"
has been added to the -mm tree.  Its filename is
     revert-preregister-support-for-powernow-k8.patch

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
Subject: Revert "[CPUFREQ][2/2] preregister support for powernow-k8"
From: Rafael J. Wysocki <rjw@sisk.pl>

Revert "[CPUFREQ][2/2] preregister support for powernow-k8"

Revert commit 34ae7f35a21694aa5cb8829dc5142c39d73d6ba0
("[CPUFREQ][2/2] preregister support for powernow-k8") that causes
regressions tracked as:
http://bugzilla.kernel.org/show_bug.cgi?id=11296 ,
http://bugzilla.kernel.org/show_bug.cgi?id=11339 .
Namely, my test box with the Asus M3A32-MVP mainboard and the AMD
Phenom 9850 CPU crashes during hibernation, suspend to RAM and ACPI
power off, apparently due to a failing CPU hotplug notifier.  In
turn, on the Torsten Kaiser's test system only one CPU is correctly
handled by cpufreq.  These problems go away after reverting
34ae7f35a21694aa5cb8829dc5142c39d73d6ba0, but unfortunately they are
quite difficult to debug.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Dave Jones <davej@redhat.com>
Cc: Mark Langsdorf <mark.langsdorf@amd.com>
Cc: Frank Arnold <frank.arnold@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |  109 ++++++--------------
 arch/x86/kernel/cpu/cpufreq/powernow-k8.h |    3 
 2 files changed, 37 insertions(+), 75 deletions(-)

diff -puN arch/x86/kernel/cpu/cpufreq/powernow-k8.c~revert-preregister-support-for-powernow-k8 arch/x86/kernel/cpu/cpufreq/powernow-k8.c
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c~revert-preregister-support-for-powernow-k8
+++ a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -737,63 +737,44 @@ static int find_psb_table(struct powerno
 #ifdef CONFIG_X86_POWERNOW_K8_ACPI
 static void powernow_k8_acpi_pst_values(struct powernow_k8_data *data, unsigned int index)
 {
-	if (!data->acpi_data->state_count || (cpu_family == CPU_HW_PSTATE))
+	if (!data->acpi_data.state_count || (cpu_family == CPU_HW_PSTATE))
 		return;
 
-	data->irt = (data->acpi_data->states[index].control >> IRT_SHIFT) & IRT_MASK;
-	data->rvo = (data->acpi_data->states[index].control >> RVO_SHIFT) & RVO_MASK;
-	data->exttype = (data->acpi_data->states[index].control >> EXT_TYPE_SHIFT) & EXT_TYPE_MASK;
-	data->plllock = (data->acpi_data->states[index].control >> PLL_L_SHIFT) & PLL_L_MASK;
-	data->vidmvs = 1 << ((data->acpi_data->states[index].control >> MVS_SHIFT) & MVS_MASK);
-	data->vstable = (data->acpi_data->states[index].control >> VST_SHIFT) & VST_MASK;
-}
-
-
-static struct acpi_processor_performance *acpi_perf_data;
-static int preregister_valid;
-
-static int powernow_k8_cpu_preinit_acpi(void)
-{
-	acpi_perf_data = alloc_percpu(struct acpi_processor_performance);
-	if (!acpi_perf_data)
-		return -ENODEV;
-
-	if (acpi_processor_preregister_performance(acpi_perf_data))
-		return -ENODEV;
-	else
-		preregister_valid = 1;
-	return 0;
+	data->irt = (data->acpi_data.states[index].control >> IRT_SHIFT) & IRT_MASK;
+	data->rvo = (data->acpi_data.states[index].control >> RVO_SHIFT) & RVO_MASK;
+	data->exttype = (data->acpi_data.states[index].control >> EXT_TYPE_SHIFT) & EXT_TYPE_MASK;
+	data->plllock = (data->acpi_data.states[index].control >> PLL_L_SHIFT) & PLL_L_MASK;
+	data->vidmvs = 1 << ((data->acpi_data.states[index].control >> MVS_SHIFT) & MVS_MASK);
+	data->vstable = (data->acpi_data.states[index].control >> VST_SHIFT) & VST_MASK;
 }
 
 static int powernow_k8_cpu_init_acpi(struct powernow_k8_data *data)
 {
 	struct cpufreq_frequency_table *powernow_table;
 	int ret_val;
-	int cpu = 0;
 
-	data->acpi_data = percpu_ptr(acpi_perf_data, cpu);
-	if (acpi_processor_register_performance(data->acpi_data, data->cpu)) {
+	if (acpi_processor_register_performance(&data->acpi_data, data->cpu)) {
 		dprintk("register performance failed: bad ACPI data\n");
 		return -EIO;
 	}
 
 	/* verify the data contained in the ACPI structures */
-	if (data->acpi_data->state_count <= 1) {
+	if (data->acpi_data.state_count <= 1) {
 		dprintk("No ACPI P-States\n");
 		goto err_out;
 	}
 
-	if ((data->acpi_data->control_register.space_id != ACPI_ADR_SPACE_FIXED_HARDWARE) ||
-		(data->acpi_data->status_register.space_id != ACPI_ADR_SPACE_FIXED_HARDWARE)) {
+	if ((data->acpi_data.control_register.space_id != ACPI_ADR_SPACE_FIXED_HARDWARE) ||
+		(data->acpi_data.status_register.space_id != ACPI_ADR_SPACE_FIXED_HARDWARE)) {
 		dprintk("Invalid control/status registers (%x - %x)\n",
-			data->acpi_data->control_register.space_id,
-			data->acpi_data->status_register.space_id);
+			data->acpi_data.control_register.space_id,
+			data->acpi_data.status_register.space_id);
 		goto err_out;
 	}
 
 	/* fill in data->powernow_table */
 	powernow_table = kmalloc((sizeof(struct cpufreq_frequency_table)
-		* (data->acpi_data->state_count + 1)), GFP_KERNEL);
+		* (data->acpi_data.state_count + 1)), GFP_KERNEL);
 	if (!powernow_table) {
 		dprintk("powernow_table memory alloc failure\n");
 		goto err_out;
@@ -806,12 +787,12 @@ static int powernow_k8_cpu_init_acpi(str
 	if (ret_val)
 		goto err_out_mem;
 
-	powernow_table[data->acpi_data->state_count].frequency = CPUFREQ_TABLE_END;
-	powernow_table[data->acpi_data->state_count].index = 0;
+	powernow_table[data->acpi_data.state_count].frequency = CPUFREQ_TABLE_END;
+	powernow_table[data->acpi_data.state_count].index = 0;
 	data->powernow_table = powernow_table;
 
 	/* fill in data */
-	data->numps = data->acpi_data->state_count;
+	data->numps = data->acpi_data.state_count;
 	if (first_cpu(per_cpu(cpu_core_map, data->cpu)) == data->cpu)
 		print_basics(data);
 	powernow_k8_acpi_pst_values(data, 0);
@@ -819,31 +800,16 @@ static int powernow_k8_cpu_init_acpi(str
 	/* notify BIOS that we exist */
 	acpi_processor_notify_smm(THIS_MODULE);
 
-	/* determine affinity, from ACPI if available */
-	if (preregister_valid) {
-		if ((data->acpi_data->shared_type == CPUFREQ_SHARED_TYPE_ALL) ||
-			(data->acpi_data->shared_type == CPUFREQ_SHARED_TYPE_ANY))
-			data->starting_core_affinity = data->acpi_data->shared_cpu_map;
-		else
-			data->starting_core_affinity = cpumask_of_cpu(data->cpu);
-	} else {
-	/* best guess from family if not */
-		if (cpu_family == CPU_HW_PSTATE)
-			data->starting_core_affinity = cpumask_of_cpu(data->cpu);
-		else
-			data->starting_core_affinity = per_cpu(cpu_core_map, data->cpu);
-	}
-
 	return 0;
 
 err_out_mem:
 	kfree(powernow_table);
 
 err_out:
-	acpi_processor_unregister_performance(data->acpi_data, data->cpu);
+	acpi_processor_unregister_performance(&data->acpi_data, data->cpu);
 
 	/* data->acpi_data.state_count informs us at ->exit() whether ACPI was used */
-	data->acpi_data->state_count = 0;
+	data->acpi_data.state_count = 0;
 
 	return -ENODEV;
 }
@@ -855,10 +821,10 @@ static int fill_powernow_table_pstate(st
 	rdmsr(MSR_PSTATE_CUR_LIMIT, hi, lo);
 	data->max_hw_pstate = (hi & HW_PSTATE_MAX_MASK) >> HW_PSTATE_MAX_SHIFT;
 
-	for (i = 0; i < data->acpi_data->state_count; i++) {
+	for (i = 0; i < data->acpi_data.state_count; i++) {
 		u32 index;
 
-		index = data->acpi_data->states[i].control & HW_PSTATE_MASK;
+		index = data->acpi_data.states[i].control & HW_PSTATE_MASK;
 		if (index > data->max_hw_pstate) {
 			printk(KERN_ERR PFX "invalid pstate %d - bad value %d.\n", i, index);
 			printk(KERN_ERR PFX "Please report to BIOS manufacturer\n");
@@ -874,7 +840,7 @@ static int fill_powernow_table_pstate(st
 
 		powernow_table[i].index = index;
 
-		powernow_table[i].frequency = data->acpi_data->states[i].core_frequency * 1000;
+		powernow_table[i].frequency = data->acpi_data.states[i].core_frequency * 1000;
 	}
 	return 0;
 }
@@ -883,16 +849,16 @@ static int fill_powernow_table_fidvid(st
 {
 	int i;
 	int cntlofreq = 0;
-	for (i = 0; i < data->acpi_data->state_count; i++) {
+	for (i = 0; i < data->acpi_data.state_count; i++) {
 		u32 fid;
 		u32 vid;
 
 		if (data->exttype) {
-			fid = data->acpi_data->states[i].status & EXT_FID_MASK;
-			vid = (data->acpi_data->states[i].status >> VID_SHIFT) & EXT_VID_MASK;
+			fid = data->acpi_data.states[i].status & EXT_FID_MASK;
+			vid = (data->acpi_data.states[i].status >> VID_SHIFT) & EXT_VID_MASK;
 		} else {
-			fid = data->acpi_data->states[i].control & FID_MASK;
-			vid = (data->acpi_data->states[i].control >> VID_SHIFT) & VID_MASK;
+			fid = data->acpi_data.states[i].control & FID_MASK;
+			vid = (data->acpi_data.states[i].control >> VID_SHIFT) & VID_MASK;
 		}
 
 		dprintk("   %d : fid 0x%x, vid 0x%x\n", i, fid, vid);
@@ -933,10 +899,10 @@ static int fill_powernow_table_fidvid(st
 				cntlofreq = i;
 		}
 
-		if (powernow_table[i].frequency != (data->acpi_data->states[i].core_frequency * 1000)) {
+		if (powernow_table[i].frequency != (data->acpi_data.states[i].core_frequency * 1000)) {
 			printk(KERN_INFO PFX "invalid freq entries %u kHz vs. %u kHz\n",
 				powernow_table[i].frequency,
-				(unsigned int) (data->acpi_data->states[i].core_frequency * 1000));
+				(unsigned int) (data->acpi_data.states[i].core_frequency * 1000));
 			powernow_table[i].frequency = CPUFREQ_ENTRY_INVALID;
 			continue;
 		}
@@ -946,12 +912,11 @@ static int fill_powernow_table_fidvid(st
 
 static void powernow_k8_cpu_exit_acpi(struct powernow_k8_data *data)
 {
-	if (data->acpi_data->state_count)
-		acpi_processor_unregister_performance(data->acpi_data, data->cpu);
+	if (data->acpi_data.state_count)
+		acpi_processor_unregister_performance(&data->acpi_data, data->cpu);
 }
 
 #else
-static int powernow_k8_cpu_preinit_acpi(void) { return -ENODEV; }
 static int powernow_k8_cpu_init_acpi(struct powernow_k8_data *data) { return -ENODEV; }
 static void powernow_k8_cpu_exit_acpi(struct powernow_k8_data *data) { return; }
 static void powernow_k8_acpi_pst_values(struct powernow_k8_data *data, unsigned int index) { return; }
@@ -1136,7 +1101,7 @@ static int powernowk8_verify(struct cpuf
 static int __cpuinit powernowk8_cpu_init(struct cpufreq_policy *pol)
 {
 	struct powernow_k8_data *data;
-	cpumask_t oldmask = CPU_MASK_ALL;
+	cpumask_t oldmask;
 	int rc;
 
 	if (!cpu_online(pol->cpu))
@@ -1209,7 +1174,10 @@ static int __cpuinit powernowk8_cpu_init
 	/* run on any CPU again */
 	set_cpus_allowed_ptr(current, &oldmask);
 
-	pol->cpus = data->starting_core_affinity;
+	if (cpu_family == CPU_HW_PSTATE)
+		pol->cpus = cpumask_of_cpu(pol->cpu);
+	else
+		pol->cpus = per_cpu(cpu_core_map, pol->cpu);
 	data->available_cores = &(pol->cpus);
 
 	/* Take a crude guess here.
@@ -1332,7 +1300,6 @@ static int __cpuinit powernowk8_init(voi
 	}
 
 	if (supported_cpus == num_online_cpus()) {
-		powernow_k8_cpu_preinit_acpi();
 		printk(KERN_INFO PFX "Found %d %s "
 			"processors (%d cpu cores) (" VERSION ")\n",
 			num_online_nodes(),
@@ -1349,10 +1316,6 @@ static void __exit powernowk8_exit(void)
 	dprintk("exit\n");
 
 	cpufreq_unregister_driver(&cpufreq_amd64_driver);
-
-#ifdef CONFIG_X86_POWERNOW_K8_ACPI
-	free_percpu(acpi_perf_data);
-#endif
 }
 
 MODULE_AUTHOR("Paul Devriendt <paul.devriendt@amd.com> and Mark Langsdorf <mark.langsdorf@amd.com>");
diff -puN arch/x86/kernel/cpu/cpufreq/powernow-k8.h~revert-preregister-support-for-powernow-k8 arch/x86/kernel/cpu/cpufreq/powernow-k8.h
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.h~revert-preregister-support-for-powernow-k8
+++ a/arch/x86/kernel/cpu/cpufreq/powernow-k8.h
@@ -33,13 +33,12 @@ struct powernow_k8_data {
 #ifdef CONFIG_X86_POWERNOW_K8_ACPI
 	/* the acpi table needs to be kept. it's only available if ACPI was
 	 * used to determine valid frequency/vid/fid states */
-	struct acpi_processor_performance *acpi_data;
+	struct acpi_processor_performance acpi_data;
 #endif
 	/* we need to keep track of associated cores, but let cpufreq
 	 * handle hotplug events - so just point at cpufreq pol->cpus
 	 * structure */
 	cpumask_t *available_cores;
-	cpumask_t starting_core_affinity;
 };
 
 
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
revert-preregister-support-for-powernow-k8.patch
linux-next.patch
skge-adapt-skge-to-use-reworked-pci-pm.patch
skty2-adapt-to-the-reworked-pci-pm.patch
e100-adapt-to-the-reworked-pci-pm.patch
pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation.patch
container-freezer-add-tif_freeze-flag-to-all-architectures.patch
container-freezer-make-refrigerator-always-available.patch
container-freezer-skip-frozen-cgroups-during-power-management-resume.patch
shrink_slab-handle-bad-shrinkers.patch

