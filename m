From: akpm@linux-foundation.org
Subject: - rtc-remove-unneeded-declarations-of-hpet_rtc_interrupt.patch removed from -mm tree
Date: Sun, 04 May 2008 19:09:55 -0700
Message-ID: <200805050209.m4529tVw025870@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56612 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753910AbYEECNx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 4 May 2008 22:13:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     rtc: remove unneeded declarations of hpet_rtc_interrupt()
has been removed from the -mm tree.  Its filename was
     rtc-remove-unneeded-declarations-of-hpet_rtc_interrupt.patch

This patch was dropped because it was withdrawn

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: remove unneeded declarations of hpet_rtc_interrupt()
From: Andrew Morton <akpm@linux-foundation.org>

Should already be available via the hpet.h inclusion.

Could go further, by defining the do-nothing stub in hpet.h as well, perhaps.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/rtc.c     |    2 --
 drivers/rtc/rtc-cmos.c |    1 -
 2 files changed, 3 deletions(-)

diff -puN drivers/char/rtc.c~rtc-remove-unneeded-declarations-of-hpet_rtc_interrupt drivers/char/rtc.c
--- a/drivers/char/rtc.c~rtc-remove-unneeded-declarations-of-hpet_rtc_interrupt
+++ a/drivers/char/rtc.c
@@ -119,8 +119,6 @@ static irqreturn_t hpet_rtc_interrupt(in
 	return 0;
 }
 #endif
-#else
-extern irqreturn_t hpet_rtc_interrupt(int irq, void *dev_id);
 #endif
 
 /*
diff -puN drivers/rtc/rtc-cmos.c~rtc-remove-unneeded-declarations-of-hpet_rtc_interrupt drivers/rtc/rtc-cmos.c
--- a/drivers/rtc/rtc-cmos.c~rtc-remove-unneeded-declarations-of-hpet_rtc_interrupt
+++ a/drivers/rtc/rtc-cmos.c
@@ -52,7 +52,6 @@
 #define hpet_rtc_timer_init() 			do { } while (0)
 #define hpet_register_irq_handler(h) 		0
 #define hpet_unregister_irq_handler(h)		do { } while (0)
-extern irqreturn_t hpet_rtc_interrupt(int irq, void *dev_id);
 #endif
 
 struct cmos_rtc {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
revert-9p-convert-from-semaphore-to-spinlock.patch
sxc-fix-printk-warnings-on-sparc32.patch
revert-memory-hotplug-register-section-node-id-to-free.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
acpi-video-balcklist-fujitsu-lifebook-s6410.patch
git-x86-fixup.patch
rtc-remove-unneeded-declarations-of-hpet_rtc_interrupt.patch
x86-geode-cache-results-from-geode_has_vsa2-and-uninline.patch
cifs-suppress-warning.patch
sysfs-provide-a-clue-about-the-effects-of-config_usb_device_class=y.patch
i2c-renesas-highlander-fpga-smbus-support.patch
touch-screen-driver-for-the-superh-migor-board.patch
git-mips.patch
git-mips-git-rejects.patch
git-mmc.patch
sundance-set-carrier-status-on-link-change-events.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
fs-nfs-callback_xdrc-suppress-uninitialiized-variable-warnings.patch
arch-parisc-kernel-unalignedc-use-time_-macros.patch
pci-hotplug-introduce-pci_slot.patch
pci-hotplug-acpi-pci-slot-detection-driver.patch
drivers-base-topologyc-add-conditionals-around-show_cpumap.patch
git-unionfs.patch
git-unionfs-fixup.patch
git-v9fs.patch
git-watchdog.patch
git-watchdog-git-rejects.patch
watchdog-fix-booke_wdtc-on-mpc85xx-smp-system.patch
xfs-suppress-uninitialized-var-warnings.patch
git-xtensa.patch
ext4-is-busted-on-m68k.patch
pci-export-resource_wc-in-pci-sysfs-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-checkpatch-fixes.patch
add-warn_on_secs-macro.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
reiser4.patch
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

