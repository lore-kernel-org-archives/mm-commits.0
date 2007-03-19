From: akpm@linux-foundation.org
Subject: - git-hid-fix.patch removed from -mm tree
Date: Mon, 19 Mar 2007 14:04:14 -0800
Message-ID: <200703192204.l2JM4EhM018935@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58766 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030696AbXCSWET (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Mar 2007 18:04:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jkosina@suse.cz, mm-commits@vger.kernel.org


The patch titled
     git-hid-fix
has been removed from the -mm tree.  Its filename was
     git-hid-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: git-hid-fix
From: Andrew Morton <akpm@linux-foundation.org>

drivers/hid/usbhid/hid-core.c:906: error: redefinition of 'hid_set_idle'
drivers/hid/usbhid/hid-core.c:597: error: previous definition of 'hid_set_idle' was here

Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hid/usbhid/hid-core.c |    7 -------
 1 file changed, 7 deletions(-)

diff -puN drivers/hid/usbhid/hid-core.c~git-hid-fix drivers/hid/usbhid/hid-core.c
--- a/drivers/hid/usbhid/hid-core.c~git-hid-fix
+++ a/drivers/hid/usbhid/hid-core.c
@@ -593,13 +593,6 @@ static int usbhid_output_raw_report(stru
 	return ret;
 }
 
-static int hid_set_idle(struct usb_device *dev, int ifnum, int report, int idle)
-{
-	return usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
-		HID_REQ_SET_IDLE, USB_TYPE_CLASS | USB_RECIP_INTERFACE, (idle << 8) | report,
-		ifnum, NULL, 0, USB_CTRL_SET_TIMEOUT);
-}
-
 /*
  * Input interrupt completion handler.
  */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
slab-introduce-krealloc-fix.patch
make-aout-executables-work-again-fix.patch
git-acpi.patch
git-alsa.patch
git-drm.patch
git-dvb.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-input.patch
git-kvm.patch
git-libata-all.patch
revert-rm-pointless-dmaengine-exports.patch
git-md-accel-fix.patch
git-mmc-versus-uevent-use-add_uevent_var-instead-of-open-coding-it.patch
git-ubi.patch
git-netdev-all.patch
bonding-replace-system-timer-with-work-queue-tidy.patch
git-parisc.patch
rm9000-serial-driver-tidy.patch
git-pciseg.patch
git-s390.patch
git-scsi-rc-fixes.patch
git-unionfs.patch
git-wireless.patch
git-wireless-fixup.patch
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
linux-sysdevh-needs-to-include-linux-moduleh.patch
i386-vdso_prelink-warning-fix.patch
allow-i386-crash-kernels-to-handle-x86_64-dumps-fix.patch
prevent-acpi-quirk-warning-mass-spamming-in-logs-tidy.patch
revert-ac97-fix-microphone-and-line_in-selection-logic.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-fix.patch
mm-debug-check-for-the-fault-vs-invalidate-race-tidy.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-tidy.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks-tidy.patch
driver_bfin_serial_core-update.patch
blackfin-blackfin-i2c-driver-update-2.patch
uml-driver-formatting-fixes-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
add-an-anonymous-inode-source-tidy.patch
virtual_eisa_root_init-should-be-__init.patch
proc-maps-protection-fix.patch
proc-maps-protection-tidy.patch
proc-maps-protection-fix-2.patch
fix-cycladesh-for-x86_64-and-probably-others-fix.patch
rtc-add-rtc-rs5c313-driver-tidy.patch
rtc-add-rtc-rs5c313-driver-is-busted.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
speedup-divides-by-cpu_power-in-scheduler.patch
lists-add-list-splice-tail.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64.patch
proc-maps-protection-vs-utrace.patch
utrace-prep-2.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
utrace-printk-borkage.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
local_t-powerpc-extension.patch
revoke-core-code-fix-shared-mapping-revoke.patch
fbdev-hecuba-framebuffer-driver.patch
mm-only-free-swap-space-of-reactivated-pages-debug.patch
