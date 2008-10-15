From: akpm@linux-foundation.org
Subject: + git-tests-git-rejects.patch added to -mm tree
Date: Wed, 15 Oct 2008 13:47:30 -0700
Message-ID: <200810152047.m9FKlUNU002631@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33898 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751932AbYJOUrd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Oct 2008 16:47:33 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m9FKlUIN009962
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Wed, 15 Oct 2008 13:47:31 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     git-tests-git-rejects
has been added to the -mm tree.  Its filename is
     git-tests-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
git-tests-git-rejects.patch
git-acpi.patch
drivers-mfd-ucb1400_corec-needs-gpio.patch
drivers-mfd-ucb1400_corec-further-unbork.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
kbuild-prevent-modpost-from-looking-for-a-cmd-file-for-a-static-library-linked-into-a-module-checkpatch-fixes.patch
led-driver-for-leds-on-pcengines-alix2-and-alix3-boards.patch
drivers-net-sfc-falconc-fix-min-warnings.patch
backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc.patch
drivers-scsi-sdh-use-inlined-c-functions-not-macros.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-page_allocc-free_area_init_nodes-fix-inappropriate-use-of-enum.patch
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
mlock-mlocked-pages-are-unevictable-fix.patch
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
mm-use-a-radix-tree-to-make-do_move_pages-complexity-linear-checkpatch-fixes.patch
h8300-generic_bug-support-checkpatch-fixes.patch
pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation-cleanup.patch
container-freezer-add-tif_freeze-flag-to-all-architectures-fix.patch
container-freezer-implement-freezer-cgroup-subsystem-checkpatch-fixes.patch
container-freezer-implement-freezer-cgroup-subsystem-uninline-thaw_process-fix.patch
separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh.patch
make-taint-bit-reliable-v3-fix.patch
kernel-sysc-improve-code-generation.patch
compat-generic-compat-get-settimeofday-checkpatch-fixes.patch
hwmon-pc87360-separate-alarm-files-add-in-min-max-alarms-cleanup.patch
hwmon-pc87360-separate-alarm-files-add-temp-min-max-crit-fault-alarms-cleanup.patch
hwmon-pc87360-separate-alarm-files-add-therm-min-max-crit-alarms-cleanup.patch
drivers-hwmon-applesmcc-remove-unneeded-casts.patch
allow-recursion-in-binfmt_script-and-binfmt_misc-fix.patch
autofs4-track-uid-and-gid-of-last-mount-requester-fix.patch
autofs4-add-miscellaneous-device-for-ioctls-fix.patch
autofs4-add-miscellaneous-device-for-ioctls-fix-2.patch
rtc-add-device-driver-for-dallas-ds3234-spi-rtc-chip-fix.patch
fb-push-down-the-bkl-in-the-ioctl-handler-checkpatch-fixes.patch
viafb-viafbmodes-viafbtxt-fix-fix.patch
viafb-accelc-accelh-checkpatch-fixes.patch
viafb-dvic-dvih-globalc-and-globalh-checkpatch-fixes.patch
viafb-hwc-hwh-checkpatch-fixes.patch
viafb-viafbdevc-viafbdevh-checkpatch-fixes.patch
fbdev-kconfig-update-fix.patch
fbdev-allow-more-chip-revisions-in-epson-s1d13-video-driver-cleanups.patch
ext2-avoid-printk-floods-in-the-face-of-directory-corruption-checkpatch-fixes.patch
ext3-fix-ext3_dx_readdir-hash-collision-handling-checkpatch-fixes.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set-fix.patch
memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix-checkpatch-fixes.patch
message-queues-increase-range-limits-checkpatch-fixes.patch
applicomc-fix-apparently-broken-code-in-do_ac_read.patch
drivers-char-tpm-tpmc-fix-error-patch-memory-leak.patch
tpm-addition-of-pnp_remove-checkpatch-fixes.patch
w1-be-able-to-manually-add-and-remove-slaves-fix.patch
w1-new-driver-ds2431-chip-fix.patch
gru-driver-minor-updates-fix.patch
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

