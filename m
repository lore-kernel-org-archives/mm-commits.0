From: akpm@linux-foundation.org
Subject: + thermal-add-generic-cpufreq-cooling-implementation-fix.patch added to -mm tree
Date: Tue, 15 May 2012 14:01:36 -0700
Message-ID: <20120515210136.F0466A0333@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:54780 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966022Ab2EOVBj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 May 2012 17:01:39 -0400
Received: by bkty5 with SMTP id y5so1087bkt.1
        for <mm-commits@vger.kernel.org>; Tue, 15 May 2012 14:01:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, amit.kachhap@linaro.org, dg77.kim@samsung.com, durgadoss.r@intel.com, guenter.roeck@ericsson.com, khali@linux-fr.org, lenb@kernel.org, sw.ju@samsung.com


The patch titled
     Subject: thermal-add-generic-cpufreq-cooling-implementation-fix
has been added to the -mm tree.  Its filename is
     thermal-add-generic-cpufreq-cooling-implementation-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: thermal-add-generic-cpufreq-cooling-implementation-fix

fix comment layout

Cc: Amit Daniel Kachhap <amit.kachhap@linaro.org>
Cc: Donggeun Kim <dg77.kim@samsung.com>
Cc: Durgadoss <durgadoss.r@intel.com>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Len Brown <lenb@kernel.org>
Cc: SangWook Ju <sw.ju@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/thermal/cpu_cooling.c |   32 ++++++++++++++++----------------
 include/linux/cpu_cooling.h   |    4 ++--
 2 files changed, 18 insertions(+), 18 deletions(-)

diff -puN drivers/thermal/cpu_cooling.c~thermal-add-generic-cpufreq-cooling-implementation-fix drivers/thermal/cpu_cooling.c
--- a/drivers/thermal/cpu_cooling.c~thermal-add-generic-cpufreq-cooling-implementation-fix
+++ a/drivers/thermal/cpu_cooling.c
@@ -62,14 +62,14 @@ static LIST_HEAD(cooling_cpufreq_list);
 static DEFINE_MUTEX(cooling_cpufreq_lock);
 static DEFINE_IDR(cpufreq_idr);
 
-/*per cpu variable to store the previous max frequency allowed*/
+/* per cpu variable to store the previous max frequency allowed */
 static DEFINE_PER_CPU(unsigned int, max_policy_freq);
 
-/*notify_table passes value to the CPUFREQ_ADJUST callback function.*/
+/* notify_table passes value to the CPUFREQ_ADJUST callback function. */
 #define NOTIFY_INVALID NULL
 static struct freq_clip_table *notify_table;
 
-/*Head of the blocking notifier chain to inform about frequency clamping*/
+/* Head of the blocking notifier chain to inform about frequency clamping */
 static BLOCKING_NOTIFIER_HEAD(cputherm_state_notifier_list);
 
 /**
@@ -160,7 +160,7 @@ int cputherm_unregister_notifier(struct 
 }
 EXPORT_SYMBOL(cputherm_unregister_notifier);
 
-/*Below codes defines functions to be used for cpufreq as cooling device*/
+/* Below code defines functions to be used for cpufreq as cooling device */
 
 /**
  * is_cpufreq_valid - function to check if a cpu has frequency transition policy.
@@ -189,11 +189,11 @@ static int cpufreq_apply_cooling(struct 
 	if (cooling_state > cpufreq_device->tab_size)
 		return -EINVAL;
 
-	/*Check if the old cooling action is same as new cooling action*/
+	/* Check if the old cooling action is same as new cooling action */
 	if (cpufreq_device->cpufreq_state == cooling_state)
 		return 0;
 
-	/*pass cooling table info to the cpufreq_thermal_notifier callback*/
+	/* pass cooling table info to the cpufreq_thermal_notifier callback */
 	notify_table = NOTIFY_INVALID;
 
 	if (cooling_state > 0) {
@@ -201,7 +201,7 @@ static int cpufreq_apply_cooling(struct 
 		notify_table = th_table;
 	}
 
-	/*check if any lower clip frequency active in other cpufreq_device's*/
+	/* check if any lower clip frequency active in other cpufreq_device's */
 	list_for_each_entry(cpufreq_ptr, &cooling_cpufreq_list, node) {
 
 		state = cpufreq_ptr->cpufreq_state;
@@ -356,14 +356,14 @@ static int cpufreq_set_cur_state(struct 
 	return ret;
 }
 
-/*Bind cpufreq callbacks to thermal cooling device ops*/
+/* Bind cpufreq callbacks to thermal cooling device ops */
 static struct thermal_cooling_device_ops const cpufreq_cooling_ops = {
 	.get_max_state = cpufreq_get_max_state,
 	.get_cur_state = cpufreq_get_cur_state,
 	.set_cur_state = cpufreq_set_cur_state,
 };
 
-/*Notifier for cpufreq policy change*/
+/* Notifier for cpufreq policy change */
 static struct notifier_block thermal_cpufreq_notifier_block = {
 	.notifier_call = cpufreq_thermal_notifier,
 };
@@ -396,7 +396,7 @@ struct thermal_cooling_device *cpufreq_c
 	if (!cpufreq_dev)
 		return ERR_PTR(-ENOMEM);
 
-	/*Verify that all the entries of freq_clip_table are present*/
+	/* Verify that all the entries of freq_clip_table are present */
 	for (i = 0; i < tab_size; i++) {
 		clip_tab = ((struct freq_clip_table *)&tab_ptr[i]);
 		if (!clip_tab->freq_clip_max || !clip_tab->mask_val
@@ -405,10 +405,10 @@ struct thermal_cooling_device *cpufreq_c
 			return ERR_PTR(-EINVAL);
 		}
 		/*
-		 *Consolidate all the cpumask for all the individual entries
-		 *of the trip table. This is useful in resetting all the
-		 *clipped frequencies to the normal level for each cpufreq
-		 *cooling device.
+		 * Consolidate all the cpumask for all the individual entries
+		 * of the trip table. This is useful in resetting all the
+		 * clipped frequencies to the normal level for each cpufreq
+		 * cooling device.
 		 */
 		cpumask_or(&cpufreq_dev->allowed_cpus,
 			&cpufreq_dev->allowed_cpus, clip_tab->mask_val);
@@ -437,7 +437,7 @@ struct thermal_cooling_device *cpufreq_c
 	mutex_lock(&cooling_cpufreq_lock);
 	list_add_tail(&cpufreq_dev->node, &cooling_cpufreq_list);
 
-	/*Register the notifier for first cpufreq cooling device*/
+	/* Register the notifier for first cpufreq cooling device */
 	if (cpufreq_dev_count == 0)
 		cpufreq_register_notifier(&thermal_cpufreq_notifier_block,
 						CPUFREQ_POLICY_NOTIFIER);
@@ -470,7 +470,7 @@ void cpufreq_cooling_unregister(struct t
 
 	list_del(&cpufreq_dev->node);
 
-	/*Unregister the notifier for the last cpufreq cooling device*/
+	/* Unregister the notifier for the last cpufreq cooling device */
 	if (cpufreq_dev_count == 1) {
 		cpufreq_unregister_notifier(&thermal_cpufreq_notifier_block,
 					CPUFREQ_POLICY_NOTIFIER);
diff -puN include/linux/cpu_cooling.h~thermal-add-generic-cpufreq-cooling-implementation-fix include/linux/cpu_cooling.h
--- a/include/linux/cpu_cooling.h~thermal-add-generic-cpufreq-cooling-implementation-fix
+++ a/include/linux/cpu_cooling.h
@@ -83,7 +83,7 @@ struct thermal_cooling_device *cpufreq_c
  * @cdev: thermal cooling device pointer.
  */
 void cpufreq_cooling_unregister(struct thermal_cooling_device *cdev);
-#else /*!CONFIG_CPU_FREQ*/
+#else /* !CONFIG_CPU_FREQ */
 static inline struct thermal_cooling_device *cpufreq_cooling_register(
 	struct freq_clip_table *tab_ptr, unsigned int tab_size);
 {
@@ -94,6 +94,6 @@ static inline void cpufreq_cooling_unreg
 {
 	return;
 }
-#endif	/*CONFIG_CPU_FREQ*/
+#endif	/* CONFIG_CPU_FREQ */
 
 #endif /* __CPU_COOLING_H__ */
_
Subject: Subject: thermal-add-generic-cpufreq-cooling-implementation-fix

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
perf-x86-fix-undefined-reference-to-get_ibs_caps.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
thermal-add-generic-cpufreq-cooling-implementation-fix.patch
thermal-exynos5-add-exynos5-thermal-sensor-driver-support-fix.patch
thermal-exynos-register-the-tmu-sensor-with-the-kernel-thermal-layer-fix.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
mm.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix-fix.patch
memcg-add-hugetlb-extension-fix-fix.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix-fix.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration-fix.patch
mm-mmapc-find_vma-remove-unnecessary-ifmm-check-fix.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
mm-do_migrate_pages-calls-migrate_to_node-even-if-task-is-already-on-a-correct-node-fix.patch
mm-do_migrate_pages-rename-arguments.patch
mm-memcg-count-pte-references-from-every-member-of-the-reclaimed-hierarchy-fix.patch
mm-rename-is_mlocked_vma-to-mlocked_vma_newpage-fix.patch
mm-page_allocc-remove-pageblock_default_order.patch
mm-remove-sparsemem-allocation-details-from-the-bootmem-allocator-fix.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
memcg-add-mlock-statistic-in-memorystat-fix.patch
security-keys-keyctlc-suppress-memory-allocation-failure-warning.patch
spinlockstxt-add-a-discussion-on-why-spin_is_locked-is-bad-fix.patch
isdn-add-missing-kern_cont-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-v2-fix.patch
kernel-irq-managec-use-the-pr_foo-infrastructure-to-prefix-printks.patch
vsprintf-correctly-handle-width-when-flag-used-in-%p-format-checkpatch-fixes.patch
vsprintf-further-optimize-decimal-conversion-checkpatch-fixes.patch
drivers-video-backlight-apple_blc-include-header-for-exported-symbol-prototypes-fix.patch
backlight-add-lm3533-backlight-driver-fix.patch
backlight-add-lm3533-backlight-driver-fix-fix.patch
leds-led-module-for-da9052-53-pmic-v2-fix.patch
leds-add-led-driver-for-lm3556-chip-checkpatch-fixes.patch
leds-add-led-driver-for-lm3556-chip-fix-fix.patch
leds-heartbeat-stop-on-shutdown-checkpatch-fixes.patch
drivers-leds-leds-pca955xc-fix-race-condition-while-setting-brightness-on-several-leds-fix.patch
lib-string_helpersc-make-arrays-static.patch
lib-bitmapc-fix-documentation-for-scnprintf-functions.patch
rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc-fix.patch
kmod-avoid-deadlock-by-recursive-kmod-call.patch
proc-clean-up-proc-pid-environ-handling-checkpatch-fixes.patch
kernel-cpuc-document-clear_tasks_mm_cpumask.patch
kernel-cpuc-document-clear_tasks_mm_cpumask-fix.patch
ipc-mqueue-improve-performance-of-send-recv-fix.patch
ipc-mqueue-correct-mq_attr_ok-test-fix.patch
ipc-mqueue-strengthen-checks-on-mqueue-creation-fix.patch
tools-selftests-add-mq_perf_tests-checkpatch-fixes.patch
pidns-make-killed-children-autoreap-checkpatch-fixes.patch
eventfd-change-int-to-__u64-in-eventfd_signal-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-comment-update-fix.patch
c-r-prctl-simplify-pr_set_mm-on-mm-code-data-assignment-fix.patch
c-r-prctl-add-ability-to-get-clear_tid_address.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

