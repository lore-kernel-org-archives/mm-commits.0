From: akpm@linux-foundation.org
Subject: - revert-i7300_idle-driver-v155.patch removed from -mm tree
Date: Fri, 24 Oct 2008 12:26:46 -0700
Message-ID: <200810241926.m9OJQk4J030566@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59776 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751801AbYJXT10 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Oct 2008 15:27:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andrew.d.henroid@intel.com, len.brown@intel.com, sfr@canb.auug.org.au, venkatesh.pallipadi@intel.com, mm-commits@vger.kernel.org


The patch titled
     revert "i7300_idle driver v1.55"
has been removed from the -mm tree.  Its filename was
     revert-i7300_idle-driver-v155.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: revert "i7300_idle driver v1.55"
From: Andrew Morton <akpm@linux-foundation.org>

revert this partially-applied git-acpi patch.  It breaks lots of things.

Cc: Andy Henroid <andrew.d.henroid@intel.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS                  |    6 ------
 arch/x86/Kconfig             |    2 --
 arch/x86/kernel/process_64.c |    7 -------
 drivers/Makefile             |    1 -
 drivers/dma/ioat_dma.c       |    3 ---
 include/asm-x86/idle.h       |    1 -
 include/linux/pci_ids.h      |    1 -
 7 files changed, 21 deletions(-)

diff -puN MAINTAINERS~revert-i7300_idle-driver-v155 MAINTAINERS
--- a/MAINTAINERS~revert-i7300_idle-driver-v155
+++ a/MAINTAINERS
@@ -2103,12 +2103,6 @@ L:	linux-ide@vger.kernel.org
 L:	linux-scsi@vger.kernel.org
 S:	Orphan
 
-IDLE-I7300
-P:	Andy Henroid
-M:	andrew.d.henroid@intel.com
-L:	linux-pm@lists.linux-foundation.org
-S:	Supported
-
 IEEE 1394 SUBSYSTEM (drivers/ieee1394)
 P:	Ben Collins
 M:	ben.collins@ubuntu.com
diff -puN arch/x86/Kconfig~revert-i7300_idle-driver-v155 arch/x86/Kconfig
--- a/arch/x86/Kconfig~revert-i7300_idle-driver-v155
+++ a/arch/x86/Kconfig
@@ -1643,8 +1643,6 @@ source "arch/x86/kernel/cpu/cpufreq/Kcon
 
 source "drivers/cpuidle/Kconfig"
 
-source "drivers/idle/Kconfig"
-
 endmenu
 
 
diff -puN arch/x86/kernel/process_64.c~revert-i7300_idle-driver-v155 arch/x86/kernel/process_64.c
--- a/arch/x86/kernel/process_64.c~revert-i7300_idle-driver-v155
+++ a/arch/x86/kernel/process_64.c
@@ -63,13 +63,6 @@ void idle_notifier_register(struct notif
 {
 	atomic_notifier_chain_register(&idle_notifier, n);
 }
-EXPORT_SYMBOL_GPL(idle_notifier_register);
-
-void idle_notifier_unregister(struct notifier_block *n)
-{
-	atomic_notifier_chain_unregister(&idle_notifier, n);
-}
-EXPORT_SYMBOL_GPL(idle_notifier_unregister);
 
 void enter_idle(void)
 {
diff -puN drivers/Makefile~revert-i7300_idle-driver-v155 drivers/Makefile
--- a/drivers/Makefile~revert-i7300_idle-driver-v155
+++ a/drivers/Makefile
@@ -82,7 +82,6 @@ obj-$(CONFIG_EISA)		+= eisa/
 obj-y				+= lguest/
 obj-$(CONFIG_CPU_FREQ)		+= cpufreq/
 obj-$(CONFIG_CPU_IDLE)		+= cpuidle/
-obj-y				+= idle/
 obj-$(CONFIG_MMC)		+= mmc/
 obj-$(CONFIG_MEMSTICK)		+= memstick/
 obj-$(CONFIG_NEW_LEDS)		+= leds/
diff -puN drivers/dma/ioat_dma.c~revert-i7300_idle-driver-v155 drivers/dma/ioat_dma.c
--- a/drivers/dma/ioat_dma.c~revert-i7300_idle-driver-v155
+++ a/drivers/dma/ioat_dma.c
@@ -171,9 +171,6 @@ static int ioat_dma_enumerate_channels(s
 	xfercap_scale = readb(device->reg_base + IOAT_XFERCAP_OFFSET);
 	xfercap = (xfercap_scale == 0 ? -1 : (1UL << xfercap_scale));
 
-#if CONFIG_I7300_IDLE_IOAT_CHANNEL
-	device->common.chancnt--;
-#endif
 	for (i = 0; i < device->common.chancnt; i++) {
 		ioat_chan = kzalloc(sizeof(*ioat_chan), GFP_KERNEL);
 		if (!ioat_chan) {
diff -puN include/asm-x86/idle.h~revert-i7300_idle-driver-v155 include/asm-x86/idle.h
--- a/include/asm-x86/idle.h~revert-i7300_idle-driver-v155
+++ a/include/asm-x86/idle.h
@@ -6,7 +6,6 @@
 
 struct notifier_block;
 void idle_notifier_register(struct notifier_block *n);
-void idle_notifier_unregister(struct notifier_block *n);
 
 void enter_idle(void);
 void exit_idle(void);
diff -puN include/linux/pci_ids.h~revert-i7300_idle-driver-v155 include/linux/pci_ids.h
--- a/include/linux/pci_ids.h~revert-i7300_idle-driver-v155
+++ a/include/linux/pci_ids.h
@@ -2451,7 +2451,6 @@
 #define PCI_DEVICE_ID_INTEL_MCH_PC1	0x359a
 #define PCI_DEVICE_ID_INTEL_E7525_MCH	0x359e
 #define PCI_DEVICE_ID_INTEL_IOAT_CNB	0x360b
-#define PCI_DEVICE_ID_INTEL_FBD_CNB	0x360c
 #define PCI_DEVICE_ID_INTEL_ICH10_0	0x3a14
 #define PCI_DEVICE_ID_INTEL_ICH10_1	0x3a16
 #define PCI_DEVICE_ID_INTEL_ICH10_2	0x3a18
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

epoll-avoid-double-inserts-in-case-of-efault-checkpatch-fixes.patch
freezer_cg-use-thaw_process-in-unfreeze_cgroup-fix.patch
fs-remove-prepare_write-commit_write-fix.patch
mm-write_cache_pages-writepage-error-fix.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
next-remove-localversion.patch
revert-i7300_idle-driver-v155.patch
git-tip.patch
arch-x86-kernel-setupc-omit-dmi_low_memory_corruption-when-it-is-unneeded.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
kbuild-prevent-modpost-from-looking-for-a-cmd-file-for-a-static-library-linked-into-a-module-checkpatch-fixes.patch
led-driver-for-leds-on-pcengines-alix2-and-alix3-boards.patch
leds-driver-for-hp-harddisk-protection-led-fix-fix-2.patch
drivers-rtc-rtc-ds1286c-is-borked.patch
drivers-rtc-rtc-m48t35c-is-borked-too.patch
drivers-net-sfc-falconc-fix-min-warnings.patch
pci-uninline-pci_ioremap_bar.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
init-properly-placing-noinline-keyword.patch
spi_gpio-driver-cleanups.patch
add-new-framebuffer-driver-for-fujitsu-mb862xx-gdcs-fix.patch
ext3-add-support-for-non-native-signed-unsigned-htree-hash-algorithms-checkpatch-fixes.patch
devpts-fix-unused-function-warning.patch
w1-export-w1_read_8-function-checkpatch-fixes.patch
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

