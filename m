From: akpm@linux-foundation.org
Subject: + revert-i7300_idle-driver-v155.patch added to -mm tree
Date: Wed, 15 Oct 2008 23:28:35 -0700
Message-ID: <200810160628.m9G6SZf9007593@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41695 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751231AbYJPG3K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Oct 2008 02:29:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, andrew.d.henroid@intel.com, len.brown@intel.com, sfr@canb.auug.org.au, venkatesh.pallipadi@intel.com


The patch titled
     revert "i7300_idle driver v1.55"
has been added to the -mm tree.  Its filename is
     revert-i7300_idle-driver-v155.patch

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

origin.patch
mm-page_allocc-free_area_init_nodes-fix-inappropriate-use-of-enum.patch
h8300-generic_bug-support.patch
pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation.patch
make-taint-bit-reliable-v3.patch
kernel-sysc-improve-code-generation.patch
compat-generic-compat-get-settimeofday.patch
allow-recursion-in-binfmt_script-and-binfmt_misc.patch
autofs4-track-uid-and-gid-of-last-mount-requester.patch
autofs4-add-miscellaneous-device-for-ioctls.patch
rtc-add-device-driver-for-dallas-ds3234-spi-rtc-chip.patch
viafb-accelc-accelh.patch
viafb-dvic-dvih-globalc-and-globalh.patch
viafb-hwc-hwh.patch
viafb-viafbdevc-viafbdevh.patch
fbdev-kconfig-update.patch
fbdev-allow-more-chip-revisions-in-epson-s1d13-video-driver.patch
ext2-avoid-printk-floods-in-the-face-of-directory-corruption.patch
applicomc-fix-apparently-broken-code-in-do_ac_read.patch
drivers-char-tpm-tpmc-fix-error-patch-memory-leak.patch
w1-be-able-to-manually-add-and-remove-slaves.patch
w1-new-driver-ds2431-chip.patch
gru-driver-minor-updates.patch
mm-remove-the-might_sleep-from-lock_page.patch
git-tests-git-rejects.patch
git-acpi.patch
git-acpi-git-rejects.patch
drivers-mfd-ucb1400_corec-needs-gpio.patch
drivers-mfd-ucb1400_corec-further-unbork.patch
arch-x86-kernel-setupc-omit-dmi_low_memory_corruption-when-it-is-unneeded.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
kbuild-prevent-modpost-from-looking-for-a-cmd-file-for-a-static-library-linked-into-a-module-checkpatch-fixes.patch
led-driver-for-leds-on-pcengines-alix2-and-alix3-boards.patch
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
revert-i7300_idle-driver-v155.patch

