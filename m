From: akpm@linux-foundation.org
Subject: [to-be-updated] acpi-fix-pmtimer-overflow-which-makes-cx-states-time-incorrect-checkpatch-fixes.patch removed from -mm tree
Date: Mon, 02 Feb 2009 23:17:39 -0800
Message-ID: <200902030717.n137HdRw013320@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57966 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750852AbZBCHRt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Feb 2009 02:17:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alex.shi@intel.com, lenb@kernel.org, yakui.zhao@intel.com, mm-commits@vger.kernel.org


The patch titled
     acpi-fix-pmtimer-overflow-which-makes-cx-states-time-incorrect-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     acpi-fix-pmtimer-overflow-which-makes-cx-states-time-incorrect-checkpatch-fixes.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi-fix-pmtimer-overflow-which-makes-cx-states-time-incorrect-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: space prohibited after that open parenthesis '('
#127: FILE: drivers/acpi/processor_idle.c:545:
+		sleep_ticks = US_TO_PM_TIMER_TICKS( idle_time);

ERROR: space prohibited after that open parenthesis '('
#156: FILE: drivers/acpi/processor_idle.c:611:
+		sleep_ticks = US_TO_PM_TIMER_TICKS( idle_time);

ERROR: space prohibited after that open parenthesis '('
#218: FILE: drivers/acpi/processor_idle.c:1535:
+	sleep_ticks = US_TO_PM_TIMER_TICKS( idle_time);

total: 3 errors, 0 warnings, 192 lines checked

./patches/acpi-fix-pmtimer-overflow-which-makes-cx-states-time-incorrect.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Alex Shi <alex.shi@intel.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Yakui.zhao <yakui.zhao@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/processor_idle.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/acpi/processor_idle.c~acpi-fix-pmtimer-overflow-which-makes-cx-states-time-incorrect-checkpatch-fixes drivers/acpi/processor_idle.c
--- a/drivers/acpi/processor_idle.c~acpi-fix-pmtimer-overflow-which-makes-cx-states-time-incorrect-checkpatch-fixes
+++ a/drivers/acpi/processor_idle.c
@@ -542,7 +542,7 @@ static void acpi_processor_idle(void)
 			mark_tsc_unstable("possible TSC halt in C2");
 #endif
 		/* Compute time (ticks) that we were actually asleep */
-		sleep_ticks = US_TO_PM_TIMER_TICKS( idle_time);
+		sleep_ticks = US_TO_PM_TIMER_TICKS(idle_time);
 
 		/* Tell the scheduler how much we idled: */
 		sched_clock_idle_wakeup_event(sleep_ticks*PM_TIMER_TICK_NS);
@@ -608,7 +608,7 @@ static void acpi_processor_idle(void)
 			mark_tsc_unstable("TSC halts in C3");
 #endif
 		/* Compute time (ticks) that we were actually asleep */
-		sleep_ticks = US_TO_PM_TIMER_TICKS( idle_time);
+		sleep_ticks = US_TO_PM_TIMER_TICKS(idle_time);
 		/* Tell the scheduler how much we idled: */
 		sched_clock_idle_wakeup_event(sleep_ticks*PM_TIMER_TICK_NS);
 
@@ -1532,7 +1532,7 @@ static int acpi_idle_enter_simple(struct
 	if (tsc_halts_in_c(cx->type))
 		mark_tsc_unstable("TSC halts in idle");;
 #endif
-	sleep_ticks = US_TO_PM_TIMER_TICKS( idle_time);
+	sleep_ticks = US_TO_PM_TIMER_TICKS(idle_time);
 
 	/* Tell the scheduler how much we idled: */
 	sched_clock_idle_wakeup_event(sleep_ticks*PM_TIMER_TICK_NS);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
kernel-asyncc-fix-printk-warnings.patch
revert-rlimit-permit-setting-rlimit_nofile-to-rlim_infinity.patch
hp-wmi-fix-error-path-in-hp_wmi_bios_setup.patch
wait-prevent-exclusive-waiter-starvation-checkpatch-fixes.patch
i-need-old-gcc.patch
linux-next.patch
next-remove-localversion.patch
kvm-unbork.patch
fix-sparseirq-use-kstat_irqs_cpu-on-non-x86-architectures-too.patch
acpi-fix-pmtimer-overflow-which-makes-cx-states-time-incorrect-checkpatch-fixes.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code-checkpatch-fixes.patch
x86-define-arch_want_frame_pointers-fix.patch
kernel-auditscc-fix-warning.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-fix.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-checkpatch-fixes.patch
sysfs-reference-sysfs_dirent-from-sysfs-inodes-fix.patch
early-platform-driver-v3-checkpatch-fixes.patch
clocksource-pass-clocksource-to-read-callback.patch
input-bcm5974-declare-alignment-usage-checkpatch-fixes.patch
mtd-rbtx4939-add-mtd-support-fix.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
drivers-ata-sata_silc-needs-dmih.patch
net-dont-use-in_atomic-in-gfp_any.patch
documentation-connector-cn_testc-dont-use-gfp_any.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
mm-unify-some-pmd_-functions-fix-s390.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-checkpatch-fixes.patch
do_pipe-drop-its-last-user-in-arch-alpha-checkpatch-fixes.patch
rtc-convert-leap_year-into-an-inline.patch
rtc-add-platform-driver-for-efi-fix.patch
drivers-video-uvesafbc-dont-use-gfp_any.patch
cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set.patch
cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set-fix-2.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu-fix.patch
nbd-add-locking-to-nbd_ioctl-checkpatch-fixes.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix.patch
nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch
a.patch

