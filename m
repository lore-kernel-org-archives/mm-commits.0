From: akpm@linux-foundation.org
Subject: + git-tests-git-rejects.patch added to -mm tree
Date: Mon, 20 Oct 2008 13:41:28 -0700
Message-ID: <200810202041.m9KKfSee012460@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59432 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752780AbYJTUlr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:41:47 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m9KKfSRG017923
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Mon, 20 Oct 2008 13:41:29 -0700
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

 lib/Kconfig.debug |  117 --------------------------------------------
 1 file changed, 117 deletions(-)

diff -puN lib/Kconfig.debug~git-tests-git-rejects lib/Kconfig.debug
--- a/lib/Kconfig.debug~git-tests-git-rejects
+++ a/lib/Kconfig.debug
@@ -568,123 +568,6 @@ config BOOT_PRINTK_DELAY
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
-	  BIG FAT WARNING: ENABLING THIS OPTION MIGHT BREAK BOOTING ON
-	  SOME DISTRIBUTIONS.  DO NOT ENABLE THIS UNLESS YOU KNOW WHAT
-	  YOU ARE DOING.  Distros, please enable this and fix whatever
-	  is broken.
-
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
revert-i7300_idle-driver-v155.patch
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
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch
mfd-drivers-mfd-wm8350-corec-doesnt-work-on-x86.patch
memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix-checkpatch-fixes.patch
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

