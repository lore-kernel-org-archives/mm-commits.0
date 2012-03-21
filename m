From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Wed, 21 Mar 2012 12:40:35 -0700
Message-ID: <20120321194038.D8838A00AA@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:47547 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919Ab2CUTkn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 21 Mar 2012 15:40:43 -0400
Received: by faaa19 with SMTP id a19so87136faa.1
        for <mm-commits@vger.kernel.org>; Wed, 21 Mar 2012 12:40:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/kernel/smp.c    |    3 ---
 drivers/cpuidle/cpuidle.c |    8 --------
 include/net/sock.h        |    3 ---
 tools/perf/util/header.c  |   34 ----------------------------------
 tools/perf/util/header.h  |    3 ---
 5 files changed, 51 deletions(-)

diff -puN tools/perf/util/header.h~linux-next-git-rejects tools/perf/util/header.h
--- a/tools/perf/util/header.h~linux-next-git-rejects
+++ a/tools/perf/util/header.h
@@ -28,10 +28,7 @@ enum {
 	HEADER_CPU_TOPOLOGY,
 	HEADER_NUMA_TOPOLOGY,
 	HEADER_BRANCH_STACK,
-<<<<<<< HEAD
-=======
 	HEADER_PMU_MAPPINGS,
->>>>>>> linux-next/akpm-end
 	HEADER_LAST_FEATURE,
 	HEADER_FEAT_BITS	= 256,
 };
diff -puN tools/perf/util/header.c~linux-next-git-rejects tools/perf/util/header.c
--- a/tools/perf/util/header.c~linux-next-git-rejects
+++ a/tools/perf/util/header.c
@@ -1394,40 +1394,6 @@ static void print_branch_stack(struct pe
 	fprintf(fp, "# contains samples with branch stack\n");
 }
 
-<<<<<<< HEAD
-=======
-static void print_pmu_mappings(struct perf_header *ph, int fd, FILE *fp)
-{
-	const char *delimiter = "# pmu mappings: ";
-	char *name;
-	int ret;
-	u32 pmu_num;
-	u32 type;
-
-	ret = read(fd, &pmu_num, sizeof(pmu_num));
-	if (ret != sizeof(pmu_num))
-		goto error;
-
-	if (!pmu_num)
-		goto error;
-
-	while (pmu_num--) {
-		if (read(fd, &type, sizeof(type)) != sizeof(type))
-			goto error;
-		name = do_read_string(fd, ph);
-		fprintf(fp, "%s%s = %" PRIu32, delimiter, name, type);
-		free(name);
-		delimiter = ", ";
-	}
-
-	fprintf(fp, "\n");
-
-	return;
-error:
-	fprintf(fp, "# pmu mappings: not available\n");
-}
-
->>>>>>> linux-next/akpm-end
 static int __event_process_build_id(struct build_id_event *bev,
 				    char *filename,
 				    struct perf_session *session)
diff -puN include/net/sock.h~linux-next-git-rejects include/net/sock.h
--- a/include/net/sock.h~linux-next-git-rejects
+++ a/include/net/sock.h
@@ -56,11 +56,8 @@
 #include <linux/memcontrol.h>
 #include <linux/res_counter.h>
 #include <linux/static_key.h>
-<<<<<<< HEAD
-=======
 #include <linux/aio.h>
 #include <linux/sched.h>
->>>>>>> linux-next/akpm-end
 
 #include <linux/filter.h>
 #include <linux/rculist_nulls.h>
diff -puN drivers/cpuidle/cpuidle.c~linux-next-git-rejects drivers/cpuidle/cpuidle.c
--- a/drivers/cpuidle/cpuidle.c~linux-next-git-rejects
+++ a/drivers/cpuidle/cpuidle.c
@@ -112,16 +112,8 @@ int cpuidle_idle_call(void)
 	trace_power_start_rcuidle(POWER_CSTATE, next_state, dev->cpu);
 	trace_cpu_idle_rcuidle(next_state, dev->cpu);
 
-<<<<<<< HEAD
-	trace_power_start_rcuidle(POWER_CSTATE, next_state, dev->cpu);
-	trace_cpu_idle_rcuidle(next_state, dev->cpu);
-
-	entered_state = target_state->enter(dev, drv, next_state);
-
-=======
 	entered_state = cpuidle_enter_ops(dev, drv, next_state);
 
->>>>>>> linux-next/akpm-end
 	trace_power_end_rcuidle(dev->cpu);
 	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, dev->cpu);
 
diff -puN arch/s390/kernel/smp.c~linux-next-git-rejects arch/s390/kernel/smp.c
--- a/arch/s390/kernel/smp.c~linux-next-git-rejects
+++ a/arch/s390/kernel/smp.c
@@ -714,15 +714,12 @@ static void __cpuinit smp_start_secondar
 	ipi_call_lock();
 	set_cpu_online(smp_processor_id(), true);
 	ipi_call_unlock();
-<<<<<<< HEAD
 	__ctl_clear_bit(0, 28); /* Disable lowcore protection */
 	S390_lowcore.restart_psw.mask =
 		PSW_DEFAULT_KEY | PSW_MASK_BASE | PSW_MASK_EA | PSW_MASK_BA;
 	S390_lowcore.restart_psw.addr =
 		PSW_ADDR_AMODE | (unsigned long) psw_restart_int_handler;
 	__ctl_set_bit(0, 28); /* Enable lowcore protection */
-=======
->>>>>>> linux-next/akpm-end
 	local_irq_enable();
 	/* cpu_idle will call schedule for us */
 	cpu_idle();
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-mfd-twl-corec-wtf-isnt-this-fixed-yet.patch
drivers-mfd-twl-corec-unbork.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
mm-thp-fix-pmd_bad-triggering-in-code-paths-holding-mmap_sem-read-mode-checkpatch-fixes.patch
fs-nameic-fix-warnings-on-32-bit.patch
drivers-platform-x86-samsung-laptopc-fix-build.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
percpu-remove-percpu_xxx-functions-fix.patch
thermal-thermal_sys-fix-build-warning.patch
thermal-add-support-for-thermal-sensor-present-on-spear13xx-machines.patch
net-netfilter-nfnetlink_acctc-use-linux-atomich.patch
brlocks-lglocks-cleanups.patch
simple_open-automatically-convert-to-simple_open-checkpatch-fixes.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions-fix.patch
mm.patch
make-swapin-readahead-skip-over-holes-fix.patch
vmscan-kswapd-carefully-call-compaction-fix.patch
mm-compaction-make-compact_control-order-signed-fix.patch
hugetlb-try-to-search-again-if-it-is-really-needed-fix.patch
thp-optimize-away-unnecessary-page-table-locking-fix-checkpatch-fixes.patch
mm-vmscan-forcibly-scan-highmem-if-there-are-too-many-buffer_heads-pinning-highmem-fix-fix.patch
procfs-mark-thread-stack-correctly-in-proc-pid-maps.patch
procfs-mark-thread-stack-correctly-in-proc-pid-maps-v3-checkpatch-fixes.patch
mm-fix-move-migrate_pages-race-on-task-struct-checkpatch-fixes.patch
bootmem-sparsemem-remove-limit-constraint-in-alloc_bootmem_section-fix.patch
hugetlbfs-fix-alignment-of-huge-page-requests-fix.patch
hugetlbfs-return-error-code-when-initializing-module-fix.patch
mmapc-fix-comment-for-__insert_vm_struct-fix.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
memcg-remove-pcg_cache-page_cgroup-flag-checkpatch-fixes.patch
memcg-simplify-move_account-check-fix.patch
memcg-use-new-logic-for-page-stat-accounting-fix.patch
memcg-fix-performance-of-mem_cgroup_begin_update_page_stat-fix.patch
mm-memcontrolc-s-stealed-stolen.patch
cpuidle-add-a-sysfs-entry-to-disable-specific-c-state-for-debug-purpose-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix.patch
kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any-fix.patch
arch-powerpc-platforms-pseries-eeh_eventc-slightly-fix-set_current_state-wart.patch
kernel-watchdogc-convert-to-pr_foo.patch
kernel-watchdogc-add-comment-to-watchdog-exit-path.patch
smp-start-up-non-boot-cpus-asynchronously-fix.patch
backlight-add-driver-for-bachmanns-ot200-fix.patch
leds-lp5521-support-led-pattern-data-checkpatch-fixes.patch
drivers-leds-leds-lp5523c-constify-some-data.patch
drivers-leds-add-driver-for-pca9663-i2c-chip-fix.patch
leds-lm3530-replace-i2c_client-with-led_classdev-fix.patch
drivers-leds-leds-lm3530c-move-the-code-setting-gen_config-to-one-place-fix.patch
crc32-move-long-comment-about-crc32-fundamentals-to-documentation-fix.patch
rtc-rtc-driver-for-da9052-53-pmic-v1-fix.patch
kmod-avoid-deadlock-by-recursive-kmod-call-fix.patch
coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix.patch
coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix-fix.patch
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
radix-tree-introduce-bit-optimized-iterator-v3-fix.patch
selftests-makefile-make-run_tests-depend-on-all.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm-fix.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm-fix-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix-2.patch
c-r-prctl-add-ability-to-get-clear_tid_address-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

