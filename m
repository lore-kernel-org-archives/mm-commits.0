From: akpm@linux-foundation.org
Subject: [folded] drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 12 May 2009 13:40:49 -0700
Message-ID: <200905122100.n4CL05jr005280@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59734 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752208AbZELVDo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 May 2009 17:03:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dtor@mail.ru, mamurph@cs.clemson.edu, mm-commits@vger.kernel.org


The patch titled
     input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-checkpatch-fixes.patch

This patch was dropped because it was folded into input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: trailing whitespace
#476: FILE: drivers/input/joystick/xpad.c:332:
+^I$

ERROR: trailing whitespace
#1354: FILE: drivers/input/joystick/xpad.c:1294:
+^I$

WARNING: kfree(NULL) is safe this check is probably not required
#1396: FILE: drivers/input/joystick/xpad.c:1333:
+		if (xpad->id_packet)
+			kfree(xpad->id_packet);

ERROR: space required after that ',' (ctx:VxV)
#1555: FILE: drivers/input/joystick/xpad.h:133:
+#define XPAD_XBOX360_VENDOR_PROTOCOL(vend,pr) \
                                          ^

ERROR: Macros with multiple statements should be enclosed in a do - while loop
#1562: FILE: drivers/input/joystick/xpad.h:140:
+#define XPAD_XBOX360_VENDOR(vend) \
+	{ XPAD_XBOX360_VENDOR_PROTOCOL(vend, 1) }, \
+	{ XPAD_XBOX360_VENDOR_PROTOCOL(vend, 129) }

ERROR: trailing whitespace
#1608: FILE: drivers/input/joystick/xpad.h:186:
+^I$

total: 5 errors, 1 warnings, 1769 lines checked

./patches/drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Mike Murphy <mamurph@cs.clemson.edu>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/joystick/xpad.c |    3 +--
 drivers/input/joystick/xpad.h |    2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/input/joystick/xpad.c~drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-checkpatch-fixes drivers/input/joystick/xpad.c
--- a/drivers/input/joystick/xpad.c~drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-checkpatch-fixes
+++ a/drivers/input/joystick/xpad.c
@@ -1329,8 +1329,7 @@ static void xpad_disconnect(struct usb_i
 		usb_free_urb(xpad->irq_in);
 		usb_buffer_free(xpad->udev, XPAD_PKT_LEN,
 				xpad->idata, xpad->idata_dma);
-		if (xpad->id_packet)
-			kfree(xpad->id_packet);
+		kfree(xpad->id_packet);
 		kfree(xpad);
 	}
 }
diff -puN drivers/input/joystick/xpad.h~drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-checkpatch-fixes drivers/input/joystick/xpad.h
--- a/drivers/input/joystick/xpad.h~drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-checkpatch-fixes
+++ a/drivers/input/joystick/xpad.h
@@ -130,7 +130,7 @@ struct xpad_led {
  * USB_INTERFACE_INFO (also specifically refused by USB subsystem), so we
  * match against vendor id as well. Wired Xbox 360 devices have protocol 1,
  * wireless controllers have protocol 129. */
-#define XPAD_XBOX360_VENDOR_PROTOCOL(vend,pr) \
+#define XPAD_XBOX360_VENDOR_PROTOCOL(vend, pr) \
 	.match_flags = USB_DEVICE_ID_MATCH_VENDOR | \
 			USB_DEVICE_ID_MATCH_INT_INFO, \
 	.idVendor = (vend), \
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

alpha-unbreak-percpu-again.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
drivers-gpu-drm-i915-intel_fbc-remove-sysrq-g-handler.patch
dvb-core-fix-potential-mutex_unlock-without-mutex_lock-in-dvb_dvr_read.patch
input-keyboard-introduce-lm8323-driver.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-checkpatch-fixes.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality-checkpatch-fixes.patch
mtd-flex-onenand-support.patch
misdn-l1oip-reduce-stack-memory-footprint.patch
drivers-net-82596c-suppress-warnings.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
fs-sysfs-filec-use-create_singlethread_workqueue.patch
leds-of_register_platform_driver-doesnt-exist-on-sparc64.patch
squashfs-fix-breakage-when-pagesize-blocksize.patch
mm-madvisec-dont-open-code-is_vm_hugetlb_page.patch
mm-consolidate-init_mm-definition-fix.patch
readahead-record-mmap-read-around-states-in-file_ra_state-checkpatch-fixes.patch
mm-clean-up-get_user_pages_fast-documentation-checkpatch-fixes.patch
ksm-add-get_pte-helper-function-fetching-pte-for-va-fix.patch
ksm-add-ksm-kernel-shared-memory-driver-checkpatch-fixes.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path-fix.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once-fix.patch
page-allocator-remove-a-branch-by-assuming-__gfp_high-==-alloc_high.patch
page-allocator-warn-if-__gfp_nofail-is-used-for-a-large-allocation.patch
mm-pm-freezer-disable-oom-killer-when-tasks-are-frozen-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
headers-move-module_bug_finalize-module_bug_cleanup-definitions-into-moduleh.patch
remove-put_cpu_no_resched-fix.patch
lib-do-code-optimization-for-radix_tree_lookup-and-radix_tree_lookup_slot-checkpatch-fixes.patch
rb_tree-reorganize-code-in-rb_erase-for-additional-changes-checkpatch-fixes.patch
flat-fix-data-sections-alignment.patch
drivers-char-memc-memory_open-cleanup-lookup-minor-device-number-from-devlist-checkpatch-fixes.patch
edac-add-cpc925-memory-controller-driver-cleanup.patch
edac-add-edac_device_alloc_index-cleanup.patch
kexec-sysrq-simplify-sysrq-c-handler.patch
gru-support-for-asynchronous-gru-instructions-fix.patch
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

