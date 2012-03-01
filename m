From: akpm@linux-foundation.org
Subject: [folded] procfs-mark-thread-stack-correctly-in-proc-pid-maps-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 01 Mar 2012 15:18:38 -0800
Message-ID: <20120301231838.6DB2EA02AE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vx0-f202.google.com ([209.85.220.202]:61110 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755692Ab2CAXSj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Mar 2012 18:18:39 -0500
Received: by vcbfk26 with SMTP id fk26so153754vcb.1
        for <mm-commits@vger.kernel.org>; Thu, 01 Mar 2012 15:18:38 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, siddhesh.poyarekar@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: procfs-mark-thread-stack-correctly-in-proc-pid-maps-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     procfs-mark-thread-stack-correctly-in-proc-pid-maps-checkpatch-fixes.patch

This patch was dropped because it was folded into procfs-mark-thread-stack-correctly-in-proc-pid-maps.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: procfs-mark-thread-stack-correctly-in-proc-pid-maps-checkpatch-fixes

WARNING: line over 80 characters
#265: FILE: fs/proc/task_mmu.c:212:
+static void show_map_vma(struct seq_file *m, struct vm_area_struct *vma, int is_pid)

ERROR: code indent should use tabs where possible
#464: FILE: fs/proc/task_mmu.c:1183:
+        .show   = show_pid_numa_map,$

WARNING: please, no spaces at the start of a line
#464: FILE: fs/proc/task_mmu.c:1183:
+        .show   = show_pid_numa_map,$

ERROR: code indent should use tabs where possible
#469: FILE: fs/proc/task_mmu.c:1187:
+        .start  = m_start,$

WARNING: please, no spaces at the start of a line
#469: FILE: fs/proc/task_mmu.c:1187:
+        .start  = m_start,$

ERROR: code indent should use tabs where possible
#470: FILE: fs/proc/task_mmu.c:1188:
+        .next   = m_next,$

WARNING: please, no spaces at the start of a line
#470: FILE: fs/proc/task_mmu.c:1188:
+        .next   = m_next,$

ERROR: code indent should use tabs where possible
#471: FILE: fs/proc/task_mmu.c:1189:
+        .stop   = m_stop,$

WARNING: please, no spaces at the start of a line
#471: FILE: fs/proc/task_mmu.c:1189:
+        .stop   = m_stop,$

ERROR: code indent should use tabs where possible
#472: FILE: fs/proc/task_mmu.c:1190:
+        .show   = show_tid_numa_map,$

WARNING: please, no spaces at the start of a line
#472: FILE: fs/proc/task_mmu.c:1190:
+        .show   = show_tid_numa_map,$

WARNING: line over 80 characters
#639: FILE: include/linux/mm.h:1050:
+extern int vm_is_stack(struct task_struct *task, struct vm_area_struct *vma, int in_group);

total: 5 errors, 7 warnings, 468 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/procfs-mark-thread-stack-correctly-in-proc-pid-maps.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Cc: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   19 ++++++++++---------
 include/linux/mm.h |    3 ++-
 2 files changed, 12 insertions(+), 10 deletions(-)

diff -puN fs/proc/task_mmu.c~procfs-mark-thread-stack-correctly-in-proc-pid-maps-checkpatch-fixes fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~procfs-mark-thread-stack-correctly-in-proc-pid-maps-checkpatch-fixes
+++ a/fs/proc/task_mmu.c
@@ -209,7 +209,8 @@ static int do_maps_open(struct inode *in
 	return ret;
 }
 
-static void show_map_vma(struct seq_file *m, struct vm_area_struct *vma, int is_pid)
+static void
+show_map_vma(struct seq_file *m, struct vm_area_struct *vma, int is_pid)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct file *file = vma->vm_file;
@@ -1177,17 +1178,17 @@ static int show_tid_numa_map(struct seq_
 }
 
 static const struct seq_operations proc_pid_numa_maps_op = {
-        .start  = m_start,
-        .next   = m_next,
-        .stop   = m_stop,
-        .show   = show_pid_numa_map,
+	.start  = m_start,
+	.next   = m_next,
+	.stop   = m_stop,
+	.show   = show_pid_numa_map,
 };
 
 static const struct seq_operations proc_tid_numa_maps_op = {
-        .start  = m_start,
-        .next   = m_next,
-        .stop   = m_stop,
-        .show   = show_tid_numa_map,
+	.start  = m_start,
+	.next   = m_next,
+	.stop   = m_stop,
+	.show   = show_tid_numa_map,
 };
 
 static int numa_maps_open(struct inode *inode, struct file *file,
diff -puN include/linux/mm.h~procfs-mark-thread-stack-correctly-in-proc-pid-maps-checkpatch-fixes include/linux/mm.h
--- a/include/linux/mm.h~procfs-mark-thread-stack-correctly-in-proc-pid-maps-checkpatch-fixes
+++ a/include/linux/mm.h
@@ -1047,7 +1047,8 @@ static inline int vm_is_stack_for_task(s
 	return (vma->vm_start <= KSTK_ESP(t) && vma->vm_end >= KSTK_ESP(t));
 }
 
-extern int vm_is_stack(struct task_struct *task, struct vm_area_struct *vma, int in_group);
+extern int
+vm_is_stack(struct task_struct *task, struct vm_area_struct *vma, int in_group);
 
 extern unsigned long move_page_tables(struct vm_area_struct *vma,
 		unsigned long old_addr, struct vm_area_struct *new_vma,
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
drivers-media-video-uvc-uvc_driverc-use-linux-atomich.patch
hpet-factor-timer-allocate-from-open.patch
thermal-thermal_sys-fix-build-warning.patch
thermal-add-support-for-thermal-sensor-present-on-spear13xx-machines-fix.patch
thermal-add-support-for-thermal-sensor-present-on-spear13xx-machines-fix-fix.patch
net-netfilter-nfnetlink_acctc-use-linux-atomich.patch
slab-introduce-kmalloc_array.patch
mm.patch
make-swapin-readahead-skip-over-holes-fix.patch
vmscan-kswapd-carefully-call-compaction-fix.patch
mm-compaction-make-compact_control-order-signed-fix.patch
hugetlb-try-to-search-again-if-it-is-really-needed-fix.patch
thp-optimize-away-unnecessary-page-table-locking-fix-checkpatch-fixes.patch
mm-vmscan-forcibly-scan-highmem-if-there-are-too-many-buffer_heads-pinning-highmem-fix-fix.patch
procfs-mark-thread-stack-correctly-in-proc-pid-maps.patch
procfs-mark-thread-stack-correctly-in-proc-pid-maps-fix.patch
procfs-mark-stack-vma-with-pid-of-the-owning-task-fix.patch
mm-fix-move-migrate_pages-race-on-task-struct-checkpatch-fixes.patch
bootmem-sparsemem-remove-limit-constraint-in-alloc_bootmem_section-fix.patch
ksm-cleanup-introduce-ksm_check_mm-fix.patch
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

