From: akpm@linux-foundation.org
Subject: - oops-handling-ensure-that-any-oops-is-flushed-to-the-mtdoops-console-fix.patch removed from -mm tree
Date: Tue, 04 Nov 2008 15:59:27 -0800
Message-ID: <200811042359.mA4NxR8Y008848@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38514 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751580AbYKDX7y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Nov 2008 18:59:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, dwmw2@infradead.org, mingo@elte.hu, viktor.rosendahl@nokia.com, mm-commits@vger.kernel.org


The patch titled
     bust_spinlocks(): simplify unblank handling
has been removed from the -mm tree.  Its filename was
     oops-handling-ensure-that-any-oops-is-flushed-to-the-mtdoops-console-fix.patch

This patch was dropped because it was withdrawn

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bust_spinlocks(): simplify unblank handling
From: Andrew Morton <akpm@linux-foundation.org>

We can now remove that unblank_screen(), because the console_unblank()
will call vt_console_driver.unblank() for us.

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Viktor Rosendahl <viktor.rosendahl@nokia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bust_spinlocks.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN lib/bust_spinlocks.c~oops-handling-ensure-that-any-oops-is-flushed-to-the-mtdoops-console-fix lib/bust_spinlocks.c
--- a/lib/bust_spinlocks.c~oops-handling-ensure-that-any-oops-is-flushed-to-the-mtdoops-console-fix
+++ a/lib/bust_spinlocks.c
@@ -11,7 +11,6 @@
 #include <linux/spinlock.h>
 #include <linux/tty.h>
 #include <linux/wait.h>
-#include <linux/vt_kern.h>
 #include <linux/console.h>
 
 
@@ -20,9 +19,6 @@ void __attribute__((weak)) bust_spinlock
 	if (yes) {
 		++oops_in_progress;
 	} else {
-#ifdef CONFIG_VT
-		unblank_screen();
-#endif
 		console_unblank();
 		if (--oops_in_progress == 0)
 			wake_up_klogd();
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

autofs4-collect-version-check-return-checkpatch-fixes.patch
maintainers-make-ioat-easier-to-find.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
next-remove-localversion.patch
arch-x86-kernel-setupc-omit-dmi_low_memory_corruption-when-it-is-unneeded.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
linux-timexh-cleanup-for-userspace.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
pci-uninline-pci_ioremap_bar.patch
pcie-add-option-to-passively-listen-for-pcie-hotplug-events-checkpatch-fixes.patch
cpusets-update-mems-allowed-in-page-allocator-fix.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
mm-invoke-oom-killer-from-page-fault-fix-fix-2.patch
mm-write_cache_pages-more-terminate-quickly.patch
init-properly-placing-noinline-keyword.patch
oops-handling-ensure-that-any-oops-is-flushed-to-the-mtdoops-console-fix.patch
spi_gpio-driver-cleanups.patch
rtc-rtc-wm8350-add-support-for-wm8350-rtc.patch
rtc-basic-implementation-of-epson-rx-8581-i2c-real-time-clock-fix.patch
quota-permit-separately-enabling-quota-accounting-and-enforcing-limits-fix.patch
quota-move-quotaio_vh-from-include-linux-to-fs-fix.patch
quota-move-quotaio_vh-from-include-linux-to-fs-fix-2.patch
quota-convert-union-in-mem_dqinfo-to-a-pointer-cleanup.patch
quota-support-64-bit-quota-format-fix.patch
quota-support-64-bit-quota-format-fix-2.patch
memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch
edac-struct-device-replace-bus_id-with-dev_name-dev_set_name-checkpatch-fixes.patch
w1-export-w1_read_8-function-checkpatch-fixes.patch
filesystem-freeze-implement-generic-freeze-feature-fix.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
reiser4-broke.patch
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

