From: akpm@linux-foundation.org
Subject: - git-tests-git-rejects.patch removed from -mm tree
Date: Sat, 18 Oct 2008 15:27:07 -0700
Message-ID: <200810182227.m9IMR82o021849@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36466 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750933AbYJRW1M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 18:27:12 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m9IMRAZ3010401
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Sat, 18 Oct 2008 15:27:11 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     git-tests-git-rejects
has been removed from the -mm tree.  Its filename was
     git-tests-git-rejects.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: git-tests-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |  112 --------------------------------------------
 1 file changed, 112 deletions(-)

diff -puN lib/Kconfig.debug~git-tests-git-rejects lib/Kconfig.debug
--- a/lib/Kconfig.debug~git-tests-git-rejects
+++ a/lib/Kconfig.debug
@@ -558,118 +558,6 @@ config BOOT_PRINTK_DELAY
 	  BOOT_PRINTK_DELAY also may cause DETECT_SOFTLOCKUP to detect
 	  what it believes to be lockup conditions.
 
-<<<<<<< HEAD:lib/Kconfig.debug
-config RCU_TORTURE_TEST
-	tristate "torture tests for RCU"
-	depends on DEBUG_KERNEL
-	default n
-	help
-	  This option provides a kernel module that runs torture tests
-	  on the RCU infrastructure.  The kernel module may be built
-	  after the fact on the running kernel to be tested, if desired.
-
-	  Say Y here if you want RCU torture tests to be built into
-	  the kernel.
-	  Say M if you want the RCU torture tests to build as a module.
-	  Say N if you are unsure.
-
-config RCU_TORTURE_TEST_RUNNABLE
-	bool "torture tests for RCU runnable by default"
-	depends on RCU_TORTURE_TEST = y
-	default n
-	help
-	  This option provides a way to build the RCU torture tests
-	  directly into the kernel without them starting up at boot
-	  time.  You can use /proc/sys/kernel/rcutorture_runnable
-	  to manually override this setting.  This /proc file is
-	  available only when the RCU torture tests have been built
-	  into the kernel.
-
-	  Say Y here if you want the RCU torture tests to start during
-	  boot (you probably don't).
-	  Say N here if you want the RCU torture tests to start only
-	  after being manually enabled via /proc.
-
-config RCU_CPU_STALL_DETECTOR
-	bool "Check for stalled CPUs delaying RCU grace periods"
-	depends on CLASSIC_RCU
-	default n
-	help
-	  This option causes RCU to printk information on which
-	  CPUs are delaying the current grace period, but only when
-	  the grace period extends for excessive time periods.
-
-	  Say Y if you want RCU to perform such checks.
-
-	  Say N if you are unsure.
-
-config KPROBES_SANITY_TEST
-	bool "Kprobes sanity tests"
-	depends on DEBUG_KERNEL
-	depends on KPROBES
-	default n
-	help
-	  This option provides for testing basic kprobes functionality on
-	  boot. A sample kprobe, jprobe and kretprobe are inserted and
-	  verified for functionality.
-
-	  Say N if you are unsure.
-
-config BACKTRACE_SELF_TEST
-	tristate "Self test for the backtrace code"
-	depends on DEBUG_KERNEL
-	default n
-	help
-	  This option provides a kernel module that can be used to test
-	  the kernel stack backtrace code. This option is not useful
-	  for distributions or general kernels, but only for kernel
-	  developers working on architecture code.
-
-	  Note that if you want to also test saved backtraces, you will
-	  have to enable STACKTRACE as well.
-
-	  Say N if you are unsure.
-
-config DEBUG_BLOCK_EXT_DEVT
-        bool "Force extended block device numbers and spread them"
-	depends on DEBUG_KERNEL
-	depends on BLOCK
-	default n
-	help
-	  Conventionally, block device numbers are allocated from
-	  predetermined contiguous area.  However, extended block area
-	  may introduce non-contiguous block device numbers.  This
-	  option forces most block device numbers to be allocated from
-	  the extended space and spreads them to discover kernel or
-	  userland code paths which assume predetermined contiguous
-	  device number allocation.
-
-	  Note that turning on this debug option shuffles all the
-	  device numbers for all IDE and SCSI devices including libata
-	  ones, so root partition specified using device number
-	  directly (via rdev or root=MAJ:MIN) won't work anymore.
-	  Textual device names (root=/dev/sdXn) will continue to work.
-
-	  Say N if you are unsure.
-
-config LKDTM
-	tristate "Linux Kernel Dump Test Tool Module"
-	depends on DEBUG_KERNEL
-	depends on KPROBES
-	depends on BLOCK
-	default n
-	help
-	This module enables testing of the different dumping mechanisms by
-	inducing system failures at predefined crash points.
-	If you don't need it: say N
-	Choose M here to compile this code as a module. The module will be
-	called lkdtm.
-
-	Documentation on how to use the module can be found in
-	drivers/misc/lkdtm.c
-
-=======
->>>>>>> FETCH_HEAD:lib/Kconfig.debug
 config FAULT_INJECTION
 	bool "Fault-injection framework"
 	depends on DEBUG_KERNEL
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
linux-next-git-rejects.patch
git-tests-git-rejects.patch
git-acpi.patch
git-acpi-git-rejects.patch
revert-i7300_idle-driver-v155.patch
git-vfs-git-rejects.patch
drivers-mfd-ucb1400_corec-needs-gpio.patch
drivers-mfd-ucb1400_corec-further-unbork.patch
arch-x86-kernel-setupc-omit-dmi_low_memory_corruption-when-it-is-unneeded.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
kbuild-prevent-modpost-from-looking-for-a-cmd-file-for-a-static-library-linked-into-a-module-checkpatch-fixes.patch
led-driver-for-leds-on-pcengines-alix2-and-alix3-boards.patch
leds-driver-for-hp-harddisk-protection-led-fix.patch
drivers-rtc-rtc-ds1286c-is-borked.patch
drivers-rtc-rtc-m48t35c-is-borked-too.patch
drivers-net-sfc-falconc-fix-min-warnings.patch
backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc.patch
drivers-scsi-sdh-use-inlined-c-functions-not-macros.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
vmscan-fix-pagecache-reclaim-referenced-bit-check-fix.patch
vmscan-fix-pagecache-reclaim-referenced-bit-check-fix-fix.patch
vmscan-fix-pagecache-reclaim-referenced-bit-check-fix-fix-fix.patch
unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
mlock-mlocked-pages-are-unevictable.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-resubmit-locked_vm-adjustment-as-separate-patch-fix.patch
vmscan-unevictable-lru-scan-sysctl.patch
mlock-make-mlock-error-return-posixly-correct-fix.patch
mm-vmallocc-revert-git-tip-change.patch
mm-rewrite-vmap-layer-fix.patch
mm-rewrite-vmap-layer-fix-fix.patch
mm-rewrite-vmap-layer-fix-fix-fix.patch
revert-mm-vmallocc-revert-git-tip-change.patch
memory_probe-fix-wrong-sysfs-file-attribute-fix.patch
container-freezer-add-tif_freeze-flag-to-all-architectures-fix.patch
container-freezer-implement-freezer-cgroup-subsystem-checkpatch-fixes.patch
container-freezer-implement-freezer-cgroup-subsystem-uninline-thaw_process-fix.patch
hwmon-pc87360-separate-alarm-files-add-in-min-max-alarms-cleanup.patch
hwmon-pc87360-separate-alarm-files-add-temp-min-max-crit-fault-alarms-cleanup.patch
hwmon-pc87360-separate-alarm-files-add-therm-min-max-crit-alarms-cleanup.patch
drivers-hwmon-applesmcc-remove-unneeded-casts.patch
mfd-drivers-mfd-wm8350-corec-doesnt-work-on-x86.patch
fb-push-down-the-bkl-in-the-ioctl-handler-checkpatch-fixes.patch
ext3-fix-ext3_dx_readdir-hash-collision-handling-checkpatch-fixes.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set-fix.patch
memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix-checkpatch-fixes.patch
message-queues-increase-range-limits-checkpatch-fixes.patch
drivers-rtc-rtc-bq4802c-dont-use-bin_2_bcd-and-bcd_2_bin.patch
x86-sysfs-kill-owner-field-from-attribute-fix.patch
x86-sysfs-kill-owner-field-from-attribute-fix-3.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

