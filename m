From: akpm@linux-foundation.org
Subject: [folded] brlocks-lglocks-cleanups-checkpatch-fixes.patch removed from -mm tree
Date: Mon, 27 Feb 2012 15:52:13 -0800
Message-ID: <20120227235213.6075EA011D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:61791 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754672Ab2B0XwO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2012 18:52:14 -0500
Received: by ggnp1 with SMTP id p1so623031ggn.1
        for <mm-commits@vger.kernel.org>; Mon, 27 Feb 2012 15:52:13 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ak@linux.intel.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: brlocks-lglocks-cleanups-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     brlocks-lglocks-cleanups-checkpatch-fixes.patch

This patch was dropped because it was folded into brlocks-lglocks-cleanups.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: brlocks-lglocks-cleanups-checkpatch-fixes

ERROR: trailing whitespace
#788: FILE: include/linux/lglock.h:59:
+#endif $

WARNING: line over 80 characters
#792: FILE: include/linux/lglock.h:63:
+	DEFINE_PER_CPU(arch_spinlock_t, name ## _lock) = __ARCH_SPIN_LOCK_UNLOCKED; \

WARNING: line over 80 characters
#793: FILE: include/linux/lglock.h:64:
+	struct lglock name = { .lock = &name ## _lock, 				\

WARNING: please, no space before tabs
#793: FILE: include/linux/lglock.h:64:
+^Istruct lglock name = { .lock = &name ## _lock, ^I^I^I^I\$

WARNING: line over 80 characters
#794: FILE: include/linux/lglock.h:65:
+			       .cpu_lock = __SPIN_LOCK_UNLOCKED(cpu_lock), 	\

WARNING: please, no space before tabs
#794: FILE: include/linux/lglock.h:65:
+^I^I^I       .cpu_lock = __SPIN_LOCK_UNLOCKED(cpu_lock), ^I\$

WARNING: line over 80 characters
#808: FILE: include/linux/lglock.h:79:
+int lg_cpu_callback(struct notifier_block *nb, unsigned long action, void *hcpu);

ERROR: trailing whitespace
#970: FILE: kernel/lglock.c:7:
+/* Note there is no uninit, so lglocks cannot be defined in $

ERROR: trailing whitespace
#971: FILE: kernel/lglock.c:8:
+ * modules (but it's fine to use them from there) $

ERROR: trailing whitespace
#975: FILE: kernel/lglock.c:12:
+void lg_lock_init(struct lglock *lg, char *name) $

WARNING: space prohibited between function name and open parenthesis '('
#983: FILE: kernel/lglock.c:20:
+	for_each_online_cpu (i)

ERROR: trailing whitespace
#989: FILE: kernel/lglock.c:26:
+void lg_local_lock(struct lglock *lg) $

ERROR: trailing whitespace
#999: FILE: kernel/lglock.c:36:
+void lg_local_unlock(struct lglock *lg) $

ERROR: trailing whitespace
#1009: FILE: kernel/lglock.c:46:
+void lg_local_lock_cpu(struct lglock *lg, int cpu) $

ERROR: trailing whitespace
#1019: FILE: kernel/lglock.c:56:
+void lg_local_unlock_cpu(struct lglock *lg, int cpu) $

ERROR: trailing whitespace
#1029: FILE: kernel/lglock.c:66:
+void lg_global_lock_online(struct lglock *lg) $

ERROR: code indent should use tabs where possible
#1082: FILE: kernel/lglock.c:119:
+                              unsigned long action, void *hcpu)$

WARNING: please, no spaces at the start of a line
#1082: FILE: kernel/lglock.c:119:
+                              unsigned long action, void *hcpu)$

ERROR: trailing whitespace
#1083: FILE: kernel/lglock.c:120:
+{                                                                     $

ERROR: trailing whitespace
#1085: FILE: kernel/lglock.c:122:
+^Iswitch (action & ~CPU_TASKS_FROZEN) {                           $

ERROR: trailing whitespace
#1086: FILE: kernel/lglock.c:123:
+^Icase CPU_UP_PREPARE:                                            $

ERROR: trailing whitespace
#1087: FILE: kernel/lglock.c:124:
+^I^Ispin_lock(&lglock->cpu_lock);                            $

ERROR: trailing whitespace
#1088: FILE: kernel/lglock.c:125:
+^I^Icpu_set((unsigned long)hcpu, lglock->cpus);              $

ERROR: trailing whitespace
#1089: FILE: kernel/lglock.c:126:
+^I^Ispin_unlock(&lglock->cpu_lock);                          $

ERROR: trailing whitespace
#1090: FILE: kernel/lglock.c:127:
+^I^Ibreak;                                                  $

ERROR: trailing whitespace
#1091: FILE: kernel/lglock.c:128:
+^Icase CPU_UP_CANCELED: case CPU_DEAD:                            $

ERROR: trailing whitespace
#1092: FILE: kernel/lglock.c:129:
+^I^Ispin_lock(&lglock->cpu_lock);                            $

ERROR: trailing whitespace
#1093: FILE: kernel/lglock.c:130:
+^I^Icpu_clear((unsigned long)hcpu, lglock->cpus);            $

ERROR: trailing whitespace
#1094: FILE: kernel/lglock.c:131:
+^I^Ispin_unlock(&lglock->cpu_lock);                          $

ERROR: trailing whitespace
#1095: FILE: kernel/lglock.c:132:
+^I}                                                               $

ERROR: trailing whitespace
#1096: FILE: kernel/lglock.c:133:
+^Ireturn NOTIFY_OK;              $

total: 23 errors, 8 warnings, 974 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/brlocks-lglocks-cleanups.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/lglock.h |    2 -
 kernel/lglock.c        |   42 +++++++++++++++++++--------------------
 2 files changed, 22 insertions(+), 22 deletions(-)

diff -puN include/linux/lglock.h~brlocks-lglocks-cleanups-checkpatch-fixes include/linux/lglock.h
--- a/include/linux/lglock.h~brlocks-lglocks-cleanups-checkpatch-fixes
+++ a/include/linux/lglock.h
@@ -56,7 +56,7 @@ struct lglock {
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lock_class_key lock_key;
 	struct lockdep_map    lock_dep_map;
-#endif 
+#endif
 };
 
 #define DEFINE_LGLOCK(name) \
diff -puN kernel/lglock.c~brlocks-lglocks-cleanups-checkpatch-fixes kernel/lglock.c
--- a/kernel/lglock.c~brlocks-lglocks-cleanups-checkpatch-fixes
+++ a/kernel/lglock.c
@@ -4,12 +4,12 @@
 #include <linux/cpu.h>
 #include <linux/string.h>
 
-/* Note there is no uninit, so lglocks cannot be defined in 
- * modules (but it's fine to use them from there) 
+/* Note there is no uninit, so lglocks cannot be defined in
+ * modules (but it's fine to use them from there)
  * Could be added though, just undo lg_lock_init
  */
 
-void lg_lock_init(struct lglock *lg, char *name) 
+void lg_lock_init(struct lglock *lg, char *name)
 {
 	int i;
 
@@ -23,7 +23,7 @@ void lg_lock_init(struct lglock *lg, cha
 }
 EXPORT_SYMBOL(lg_lock_init);
 
-void lg_local_lock(struct lglock *lg) 
+void lg_local_lock(struct lglock *lg)
 {
 	arch_spinlock_t *lock;
 	preempt_disable();
@@ -33,7 +33,7 @@ void lg_local_lock(struct lglock *lg) 
 }
 EXPORT_SYMBOL(lg_local_lock);
 
-void lg_local_unlock(struct lglock *lg) 
+void lg_local_unlock(struct lglock *lg)
 {
 	arch_spinlock_t *lock;
 	rwlock_release(&lg->lock_dep_map, 1, _RET_IP_);
@@ -43,7 +43,7 @@ void lg_local_unlock(struct lglock *lg) 
 }
 EXPORT_SYMBOL(lg_local_unlock);
 
-void lg_local_lock_cpu(struct lglock *lg, int cpu) 
+void lg_local_lock_cpu(struct lglock *lg, int cpu)
 {
 	arch_spinlock_t *lock;
 	preempt_disable();
@@ -53,7 +53,7 @@ void lg_local_lock_cpu(struct lglock *lg
 }
 EXPORT_SYMBOL(lg_local_lock_cpu);
 
-void lg_local_unlock_cpu(struct lglock *lg, int cpu) 
+void lg_local_unlock_cpu(struct lglock *lg, int cpu)
 {
 	arch_spinlock_t *lock;
 	rwlock_release(&lg->lock_dep_map, 1, _RET_IP_);
@@ -63,7 +63,7 @@ void lg_local_unlock_cpu(struct lglock *
 }
 EXPORT_SYMBOL(lg_local_unlock_cpu);
 
-void lg_global_lock_online(struct lglock *lg) 
+void lg_global_lock_online(struct lglock *lg)
 {
 	int i;
 	spin_lock(&lg->cpu_lock);
@@ -117,20 +117,20 @@ EXPORT_SYMBOL(lg_global_unlock);
 
 int lg_cpu_callback(struct notifier_block *nb,
                               unsigned long action, void *hcpu)
-{                                                                     
+{
 	struct lglock *lglock = container_of(nb, struct lglock, cpu_notifier);
-	switch (action & ~CPU_TASKS_FROZEN) {                           
-	case CPU_UP_PREPARE:                                            
-		spin_lock(&lglock->cpu_lock);                            
-		cpu_set((unsigned long)hcpu, lglock->cpus);              
-		spin_unlock(&lglock->cpu_lock);                          
-		break;                                                  
-	case CPU_UP_CANCELED: case CPU_DEAD:                            
-		spin_lock(&lglock->cpu_lock);                            
-		cpu_clear((unsigned long)hcpu, lglock->cpus);            
-		spin_unlock(&lglock->cpu_lock);                          
-	}                                                               
-	return NOTIFY_OK;              
+	switch (action & ~CPU_TASKS_FROZEN) {
+	case CPU_UP_PREPARE:
+		spin_lock(&lglock->cpu_lock);
+		cpu_set((unsigned long)hcpu, lglock->cpus);
+		spin_unlock(&lglock->cpu_lock);
+		break;
+	case CPU_UP_CANCELED: case CPU_DEAD:
+		spin_lock(&lglock->cpu_lock);
+		cpu_clear((unsigned long)hcpu, lglock->cpus);
+		spin_unlock(&lglock->cpu_lock);
+	}
+	return NOTIFY_OK;
 }
 EXPORT_SYMBOL(lg_cpu_callback);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-mfd-twl-corec-wtf-isnt-this-fixed-yet.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs.patch
drivers-platform-x86-sony-laptopc-fix-scancodes.patch
net5501-platform-driver-for-soekris-engineering-net5501-single-board-computer.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
x86-change-percpu_read_stable-to-this_cpu_read_stable-fix.patch
x86-pci-increase-the-number-of-iommus-supported-to-be-max_io_apics-v2-fix.patch
hpet-factor-timer-allocate-from-open.patch
thermal-thermal_sys-fix-build-warning.patch
thermal-add-support-for-thermal-sensor-present-on-spear13xx-machines-fix.patch
thermal-add-support-for-thermal-sensor-present-on-spear13xx-machines-fix-fix.patch
slab-introduce-kmalloc_array.patch
mm.patch
make-swapin-readahead-skip-over-holes-fix.patch
vmscan-kswapd-carefully-call-compaction-fix.patch
mm-compaction-make-compact_control-order-signed-fix.patch
hugetlb-try-to-search-again-if-it-is-really-needed-fix.patch
thp-optimize-away-unnecessary-page-table-locking-fix-checkpatch-fixes.patch
mm-vmscan-forcibly-scan-highmem-if-there-are-too-many-buffer_heads-pinning-highmem-fix-fix.patch
procfs-mark-thread-stack-correctly-in-proc-pid-maps-checkpatch-fixes.patch
procfs-mark-thread-stack-correctly-in-proc-pid-maps-fix.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
memcg-remove-pcg_cache-page_cgroup-flag-checkpatch-fixes.patch
memcg-simplify-move_account-check-fix.patch
memcg-use-new-logic-for-page-stat-accounting-fix.patch
memcg-fix-performance-of-mem_cgroup_begin_update_page_stat-fix.patch
mm-memcontrolc-s-stealed-stolen.patch
percpu-remove-percpu_xxx-functions-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix.patch
kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any-fix.patch
smp-start-up-non-boot-cpus-asynchronously-fix.patch
brlocks-lglocks-cleanups.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions-fix.patch
backlight-add-driver-for-bachmanns-ot200-fix.patch
leds-lp5521-support-led-pattern-data-checkpatch-fixes.patch
drivers-leds-leds-lp5523c-constify-some-data.patch
drivers-leds-add-driver-for-pca9663-i2c-chip-fix.patch
leds-lm3530-replace-i2c_client-with-led_classdev-fix.patch
drivers-leds-leds-lm3530c-move-the-code-setting-gen_config-to-one-place-fix.patch
crc32-move-long-comment-about-crc32-fundamentals-to-documentation-fix.patch
rtc-rtc-driver-for-da9052-53-pmic-v1-fix.patch
kmod-avoid-deadlock-by-recursive-kmod-call-fix.patch
procfs-add-num_to_str-to-speed-up-proc-stat-fix.patch
procfs-speed-up-proc-pid-stat-statm-checkpatch-fixes.patch
seq_file-add-seq_set_overflow-seq_overflow-fix.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-fix.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-update-fix.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-v9.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-v9-fix.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-fix.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-checkpatch-fixes.patch
fs-proc-namespacesc-prevent-crash-when-ns_entries-is-empty.patch
selftests-makefile-make-run_tests-depend-on-all.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm-fix.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm-fix-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix-2.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

