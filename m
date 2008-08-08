From: akpm@linux-foundation.org
Subject: - drivers-usb-class-cdc-wdmc-fix-build-with-config_pm=n.patch removed from -mm tree
Date: Fri, 08 Aug 2008 15:04:46 -0700
Message-ID: <200808082204.m78M4kSJ031054@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41939 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761970AbYHHWFk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Aug 2008 18:05:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, gregkh@suse.de, oneukum@suse.de, mm-commits@vger.kernel.org


The patch titled
     drivers/usb/class/cdc-wdm.c: fix build with CONFIG_PM=n
has been removed from the -mm tree.  Its filename was
     drivers-usb-class-cdc-wdmc-fix-build-with-config_pm=n.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/usb/class/cdc-wdm.c: fix build with CONFIG_PM=n
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Oliver Neukum <oneukum@suse.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/class/cdc-wdm.c |   28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff -puN drivers/usb/class/cdc-wdm.c~drivers-usb-class-cdc-wdmc-fix-build-with-config_pm=n drivers/usb/class/cdc-wdm.c
--- a/drivers/usb/class/cdc-wdm.c~drivers-usb-class-cdc-wdmc-fix-build-with-config_pm=n
+++ a/drivers/usb/class/cdc-wdm.c
@@ -742,6 +742,19 @@ static void wdm_disconnect(struct usb_in
 	mutex_unlock(&wdm_mutex);
 }
 
+static int recover_from_urb_loss(struct wdm_device *desc)
+{
+	int rv = 0;
+
+	if (desc->count) {
+		rv = usb_submit_urb(desc->validity, GFP_NOIO);
+		if (rv < 0)
+			err("Error resume submitting int urb - %d", rv);
+	}
+	return rv;
+}
+
+#ifdef CONFIG_PM
 static int wdm_suspend(struct usb_interface *intf, pm_message_t message)
 {
 	struct wdm_device *desc = usb_get_intfdata(intf);
@@ -765,17 +778,6 @@ static int wdm_suspend(struct usb_interf
 	return rv;
 }
 
-static int recover_from_urb_loss(struct wdm_device *desc)
-{
-	int rv = 0;
-
-	if (desc->count) {
-		rv = usb_submit_urb(desc->validity, GFP_NOIO);
-		if (rv < 0)
-			err("Error resume submitting int urb - %d", rv);
-	}
-	return rv;
-}
 static int wdm_resume(struct usb_interface *intf)
 {
 	struct wdm_device *desc = usb_get_intfdata(intf);
@@ -787,6 +789,10 @@ static int wdm_resume(struct usb_interfa
 	mutex_unlock(&desc->plock);
 	return rv;
 }
+#else
+#define wdm_suspend NULL
+#define wdm_resume NULL
+#endif
 
 static int wdm_pre_reset(struct usb_interface *intf)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
printk-robustify-printk-fix.patch
seq_file-fix-bug-when-seq_read-reads-nothing.patch
linux-next.patch
next-remove-localversion.patch
linux-next-git-rejects.patch
arch-x86-pci-irqc-attempt-to-clean-up-code-layout.patch
zero-based-percpu-use-vmlinux_symbol-in-include-asm-generic-vmlinuxldsh.patch
ppc-use-the-common-ascii-hex-helpers.patch
powerpc-replace-__function__-with-__func__.patch
i2c-renesas-highlander-fpga-smbus-support-update-fix.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
drivers-input-serio-xilinx_ps2c-fix-warning.patch
git-jg-misc.patch
git-ubi-git-rejects.patch
sundance-set-carrier-status-on-link-change-events.patch
cassini-use-request_firmware.patch
e1000e-remove-inapplicable-test-for-ioport-checkpatch-fixes.patch
sched-type-fix.patch
lockdep-spin_lock_nest_lock-fix-checkpatch-fixes.patch
scsi-gdthc-use-unaligned-access-helpers.patch
git-unionfs.patch
git-logfs-git-rejects.patch
git-logfs-fixup.patch
drivers-usb-class-cdc-wdmc-fix-build-with-config_pm=n.patch
git-xtensa.patch
git-pekka.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
hwmon-adc124s501-generic-driver.patch
drivers-net-netxen-netxen_nic_hwc-fix-printk-warnings.patch
rcu-fix-synchronize_rcu-so-that-kernel-doc-works.patch
ftrace-disable-function-tracing-bringing-up-new-cpu.patch
scsi-megaraid_sas-add-the-new-controllers-support-checkpatch-fixes.patch
unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
mlock-mlocked-pages-are-unevictable.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
vmscan-unevictable-lru-scan-sysctl.patch
slb-drop-kmem-cache-argument-from-constructor-fix-fix-logfs.patch
h8300-generic_bug-support-checkpatch-fixes.patch
autofs4-track-uid-and-gid-of-last-mount-requester-fix.patch
autofs4-add-miscellaneous-device-for-ioctls-fix.patch
fb-push-down-the-bkl-in-the-ioctl-handler-checkpatch-fixes.patch
eink_apollofb-new-driver-for-apollo-eink-controller.patch
devpts-switch-to-ida-checkpatch-fixes.patch
gcov-architecture-specific-compile-flag-adjustments-powerpc-moved-stuff.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
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

