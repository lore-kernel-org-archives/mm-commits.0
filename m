From: akpm@linux-foundation.org
Subject: [folded] workqueue-add-to_delayed_work-helper-function-update-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 02 Apr 2009 13:13:11 -0700
Message-ID: <200904022013.n32KDCpl022108@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33344 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765266AbZDBUNu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Apr 2009 16:13:50 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n32KDCJf030204
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Thu, 2 Apr 2009 13:13:48 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     workqueue-add-to_delayed_work-helper-function-update-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     workqueue-add-to_delayed_work-helper-function-update-checkpatch-fixes.patch

This patch was dropped because it was folded into workqueue-add-to_delayed_work-helper-function.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: workqueue-add-to_delayed_work-helper-function-update-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: code indent should use tabs where possible
#52: FILE: drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c:780:
+        struct delayed_work *dwork = to_delayed_work(work);$

ERROR: code indent should use tabs where possible
#64: FILE: drivers/staging/rtl8187se/r8180_core.c:5462:
+        struct delayed_work *dwork = to_delayed_work(work);$

ERROR: code indent should use tabs where possible
#73: FILE: drivers/staging/rtl8187se/r8180_core.c:6410:
+        struct delayed_work *dwork = to_delayed_work(work);$

total: 3 errors, 0 warnings, 41 lines checked

./patches/workqueue-add-to_delayed_work-helper-function-update.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c |    2 +-
 drivers/staging/rtl8187se/r8180_core.c                  |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c~workqueue-add-to_delayed_work-helper-function-update-checkpatch-fixes drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c~workqueue-add-to_delayed_work-helper-function-update-checkpatch-fixes
+++ a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
@@ -777,7 +777,7 @@ out:
 #if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20))
 void ieee80211_softmac_scan_wq(struct work_struct *work)
 {
-        struct delayed_work *dwork = to_delayed_work(work);
+	struct delayed_work *dwork = to_delayed_work(work);
         struct ieee80211_device *ieee = container_of(work, struct ieee80211_device, softmac_scan_wq);
 #else
 void ieee80211_softmac_scan_wq(struct ieee80211_device *ieee)
diff -puN drivers/staging/rtl8187se/r8180_core.c~workqueue-add-to_delayed_work-helper-function-update-checkpatch-fixes drivers/staging/rtl8187se/r8180_core.c
--- a/drivers/staging/rtl8187se/r8180_core.c~workqueue-add-to_delayed_work-helper-function-update-checkpatch-fixes
+++ a/drivers/staging/rtl8187se/r8180_core.c
@@ -5459,7 +5459,7 @@ void rtl8180_hw_sleep_wq (struct work_st
 //      struct r8180_priv *priv = container_of(work, struct r8180_priv, watch_dog_wq);
 //      struct ieee80211_device * ieee = (struct ieee80211_device*)
 //                                             container_of(work, struct ieee80211_device, watch_dog_wq);
-        struct delayed_work *dwork = to_delayed_work(work);
+	struct delayed_work *dwork = to_delayed_work(work);
         struct ieee80211_device *ieee = container_of(dwork,struct ieee80211_device,hw_sleep_wq);
         struct net_device *dev = ieee->dev;
 #else
@@ -6407,7 +6407,7 @@ priv->txnpring)/8);
 void rtl8180_tx_irq_wq(struct work_struct *work)
 {
 	//struct r8180_priv *priv = container_of(work, struct r8180_priv, reset_wq);
-        struct delayed_work *dwork = to_delayed_work(work);
+	struct delayed_work *dwork = to_delayed_work(work);
 	struct ieee80211_device * ieee = (struct ieee80211_device*)
 	                                       container_of(dwork, struct ieee80211_device, watch_dog_wq);
 	struct net_device *dev = ieee->dev;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
__tty_open-use-the-correct-type-for-saved_flags.patch
workqueue-add-to_delayed_work-helper-function.patch
workqueue-add-to_delayed_work-helper-function-update-checkpatch-fixes.patch
simplify-copy_thread-checkpatch-fixes.patch
i2c-too-much-compiler-noise.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
toshiba_acpi-add-full-hotkey-support-fix.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code.patch
arch-x86-mm-iomap_32c-fix-warning.patch
early-platform-driver-v3.patch
clocksource-pass-clocksource-to-read-callback.patch
input-bcm5974-declare-alignment-usage.patch
input-keyboard-introduce-lm8323-driver.patch
drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-checkpatch-fixes.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality-checkpatch-fixes.patch
leds-add-bd2802gu-led-driver.patch
flex-onenand-support-v2-fix.patch
misdn-l1oip-reduce-stack-memory-footprint.patch
drivers-net-82596c-suppress-warnings.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
xtensa-add-flat-support-checkpatch-fixes.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
input-add-a-dmi-table-for-the-i8042reset-option-make-msi-wind-u-100-work.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-99.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
flat-fix-data-sections-alignment.patch
rtc-v3020-add-ability-to-access-v3020-chip-with-gpios.patch
ext3-use-unsigned-instead-of-int-for-type-of-blocksize-in-fs-ext3-nameic-fix.patch
ext3-use-unsigned-instead-of-int-for-type-of-blocksize-in-fs-ext3-nameic-fix-checkpatch-fixes.patch
memcg-fix-oom-killer-under-memcg-fix2.patch
memcg-fix-oom-killer-under-memcg-fix.patch
memcg-show-memcg-information-during-oom-fix2.patch
memcg-show-memcg-information-during-oom-fix.patch
memcg-show-memcg-information-during-oom-fix-fix-checkpatch-fixes.patch
forget_original_parent-do-not-abuse-child-ptrace_entry-fix.patch
hpet-fix-the-possibility-of-insane-return-value-of-hpet_calibrate-against-smi-fix.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu-fix.patch
nbd-add-locking-to-nbd_ioctl-checkpatch-fixes.patch
nbd-add-locking-to-nbd_ioctl-fix.patch
namespaces-mqueue-namespace-adapt-sysctl-update-fix.patch
edac-new-ppc4xx-driver-module-update-checkpatch-fixes.patch
edac-new-ppc4xx-driver-module-update-checkpatch-fixes-checkpatch-fixes.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-checkpatch-fixes-cleanup.patch
kernel-auditscc-fix-warning.patch
nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
vfs-simple_set_mnt-should-return-void-fix-nilfs.patch
nilfs2-segment-buffer-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
page-owner-tracking.patch
page-owner-tracking-checkpatch-fixes.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch

