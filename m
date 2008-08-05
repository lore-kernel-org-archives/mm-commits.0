From: akpm@linux-foundation.org
Subject: - usb-hubc-fix-build-with-config_pm=n.patch removed from -mm tree
Date: Tue, 05 Aug 2008 14:21:05 -0700
Message-ID: <200808052121.m75LL5RU024124@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32810 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755203AbYHEVVK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Aug 2008 17:21:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, greg@kroah.com, stern@rowland.harvard.edu, mm-commits@vger.kernel.org


The patch titled
     usb: hub.c: fix build with CONFIG_PM=n
has been removed from the -mm tree.  Its filename was
     usb-hubc-fix-build-with-config_pm=n.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb: hub.c: fix build with CONFIG_PM=n
From: Andrew Morton <akpm@linux-foundation.org>

alpha allmodconfig:

ERROR: "usb_forced_unbind_intf" [drivers/usb/core/usbcore.ko] undefined!
ERROR: "usb_rebind_intf" [drivers/usb/core/usbcore.ko] undefined!

Cc: Greg KH <greg@kroah.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/core/usb.h |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN drivers/usb/core/usb.h~usb-hubc-fix-build-with-config_pm=n drivers/usb/core/usb.h
--- a/drivers/usb/core/usb.h~usb-hubc-fix-build-with-config_pm=n
+++ a/drivers/usb/core/usb.h
@@ -29,8 +29,6 @@ extern int usb_choose_configuration(stru
 extern void usb_kick_khubd(struct usb_device *dev);
 extern int usb_match_device(struct usb_device *dev,
 			    const struct usb_device_id *id);
-extern void usb_forced_unbind_intf(struct usb_interface *intf);
-extern void usb_rebind_intf(struct usb_interface *intf);
 
 extern int  usb_hub_init(void);
 extern void usb_hub_cleanup(void);
@@ -47,6 +45,8 @@ extern int usb_port_resume(struct usb_de
 extern int usb_external_suspend_device(struct usb_device *udev,
 		pm_message_t msg);
 extern int usb_external_resume_device(struct usb_device *udev);
+extern void usb_forced_unbind_intf(struct usb_interface *intf);
+extern void usb_rebind_intf(struct usb_interface *intf);
 
 static inline void usb_pm_lock(struct usb_device *udev)
 {
@@ -70,6 +70,14 @@ static inline int usb_port_resume(struct
 	return 0;
 }
 
+static inline void usb_forced_unbind_intf(struct usb_interface *intf)
+{
+}
+
+static inline void usb_rebind_intf(struct usb_interface *intf)
+{
+}
+
 static inline void usb_pm_lock(struct usb_device *udev) {}
 static inline void usb_pm_unlock(struct usb_device *udev) {}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm_initc-avoid-ifdef-inside-macro-expansion.patch
pm_qos-spelling-fixes.patch
drivers-media-video-vinoc-needs-v4l2-ioctlh.patch
seq_file-fix-bug-when-seq_read-reads-nothing.patch
linux-next.patch
next-remove-localversion.patch
arch-x86-pci-irqc-attempt-to-clean-up-code-layout.patch
zero-based-percpu-use-vmlinux_symbol-in-include-asm-generic-vmlinuxldsh.patch
ppc-use-the-common-ascii-hex-helpers.patch
powerpc-replace-__function__-with-__func__.patch
i2c-renesas-highlander-fpga-smbus-support.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
drivers-input-serio-xilinx_ps2c-fix-warning.patch
git-jg-misc.patch
git-ubi-git-rejects.patch
sundance-set-carrier-status-on-link-change-events.patch
cassini-use-request_firmware.patch
e1000e-remove-inapplicable-test-for-ioport-checkpatch-fixes.patch
sched-type-fix.patch
scsi-gdthc-use-unaligned-access-helpers.patch
git-block-git-rejects.patch
git-unionfs.patch
git-logfs-git-rejects.patch
git-logfs-fixup.patch
drivers-usb-class-cdc-acmc-use-correct-type-for-cpu-flags.patch
drivers-usb-class-cdc-wdmc-fix-build-with-config_pm=n.patch
usb-hubc-fix-build-with-config_pm=n.patch
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

