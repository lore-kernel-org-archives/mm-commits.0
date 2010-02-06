From: akpm@linux-foundation.org
Subject: [nacked] usb-qti-directemp-usb-thermometer-hygrometer-driver-support-fix.patch removed from -mm tree
Date: Fri, 05 Feb 2010 19:03:30 -0800
Message-ID: <201002060303.o1633U1l003647@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33753 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751310Ab0BFDEJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Feb 2010 22:04:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, chrisv@cyberswitching.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     usb-qti-directemp-usb-thermometer-hygrometer-driver-support-fix
has been removed from the -mm tree.  Its filename was
     usb-qti-directemp-usb-thermometer-hygrometer-driver-support-fix.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb-qti-directemp-usb-thermometer-hygrometer-driver-support-fix
From: Andrew Morton <akpm@linux-foundation.org>

- `pid' is a well-understood term for a process ID.  Rename it.

- clean up some memsets

- Change the `raw' file's permissions to S_IWUSR.  We shouldn't permit
  unprivileged users to cause a printk spew into the logs.

Cc: "Chris Verges" <chrisv@cyberswitching.com>
Cc: Chris Verges <chrisv@cyberswitching.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/misc/directemp.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/usb/misc/directemp.c~usb-qti-directemp-usb-thermometer-hygrometer-driver-support-fix drivers/usb/misc/directemp.c
--- a/drivers/usb/misc/directemp.c~usb-qti-directemp-usb-thermometer-hygrometer-driver-support-fix
+++ a/drivers/usb/misc/directemp.c
@@ -40,7 +40,7 @@
 struct usb_directemp {
 	struct usb_device	*udev;
 	struct usb_interface	*interface;
-	uint16_t		pid;
+	uint16_t		product_id;
 
 	uint8_t			read_temp;
 };
@@ -114,7 +114,7 @@ static ssize_t show_temp(struct device *
 
 	/* Read twice due to a buffer issue on the DirecTEMP */
 	for (i = 0; i < DIRECTEMP_MAX_RETRIES; i++) {
-		memset(data, 0, (DIRECTEMP_MSG_SIZE + 1) * sizeof(char));
+		memset(data, 0, sizeof(data));
 		data[0] = directemp->read_temp;
 		err = show_helper(dev, attr, data, data, DIRECTEMP_MSG_SIZE);
 		if (err < 0)
@@ -156,7 +156,7 @@ static ssize_t show_rh(struct device *de
 
 	/* Read twice due to a buffer issue on the DirecTEMP */
 	for (i = 0; i < DIRECTEMP_MAX_RETRIES; i++) {
-		memset(data, 0, (DIRECTEMP_MSG_SIZE + 1) * sizeof(char));
+		memset(data, 0, sizeof(data));
 		data[0] = DIRECTEMP_HUMIDITY;
 		err = show_helper(dev, attr, data, data, DIRECTEMP_MSG_SIZE);
 		if (err < 0)
@@ -199,7 +199,7 @@ static ssize_t set_raw(struct device *de
 	if (count > DIRECTEMP_MSG_SIZE)
 		count = DIRECTEMP_MSG_SIZE;
 
-	memset(data, 0, (DIRECTEMP_MSG_SIZE + 1) * sizeof(char));
+	memset(data, 0, sizeof(data));
 	memcpy(data, buf, count);
 
 	printk("Request:\n");
@@ -219,7 +219,7 @@ static ssize_t set_raw(struct device *de
 	return 0;
 }
 
-static DEVICE_ATTR(raw, S_IWUGO, NULL, set_raw);
+static DEVICE_ATTR(raw, S_IWUSR, NULL, set_raw);
 
 static int directemp_probe(struct usb_interface *interface,
 			 const struct usb_device_id *id)
@@ -234,10 +234,10 @@ static int directemp_probe(struct usb_in
 
 	dev->udev = usb_get_dev(udev);
 	usb_set_intfdata(interface, dev);
-	dev->pid = id->idProduct;
+	dev->product_id = id->idProduct;
 
 	dev_dbg(&interface->dev, "Product:       %s (ID 0x%04X)\n",
-			udev->product, dev->pid);
+			udev->product, dev->product_id);
 	dev_dbg(&interface->dev, "Manufacturer:  %s\n",
 			udev->manufacturer);
 	dev_dbg(&interface->dev, "Serial Number: %s\n",
@@ -253,7 +253,7 @@ static int directemp_probe(struct usb_in
 	if (err)
 		goto exit_free_sysfs;
 
-	switch (dev->pid) {
+	switch (dev->product_id) {
 	case 0x0002:
 		dev->read_temp = '2';
 		break;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
bitops-rename-for_each_bit-to-for_each_set_bit.patch
bitops-rename-for_each_bit-to-for_each_set_bit-fix.patch
bitops-rename-for_each_bit-to-for_each_set_bit-fix-fix-2.patch
pci-update-pci_set_vga_state-to-call-arch-functions.patch
arch-arm-include-asm-elfh-forward-declare-the-task-struct.patch
cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-present.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
jffs2-avoid-using-c-keyword-new-in-userspace-visible-header.patch
3x59x-fix-pci-resource-management.patch
ibmphp-read-the-length-of-ebda-and-map-entire-ebda-region-fix.patch
kernel-schedc-suppress-unused-var-warning.patch
usb-qti-directemp-usb-thermometer-hygrometer-driver-support-fix.patch
mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes.patch
mm-count-swap-usage-checkpatch-fixes.patch
vmscan-check-high-watermark-after-shrink-zone-fix.patch
mm-remove-function-free_hot_page-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch
memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory-fix.patch
include-linux-fsh-convert-fmode_-constants-to-hex.patch
mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue-fix.patch
mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
uml-linec-avoid-null-pointer-dereference-simplify.patch
add-generic-sys_ipc-wrapper-fix.patch
lib-more-scalable-list_sort-fix.patch
fs-compat_ioctlc-suppress-two-warnings.patch
hwmon-driver-for-ti-tmp102-temperature-sensor-checkpatch-fixes.patch
hwmon-driver-for-ti-tmp102-temperature-sensor-fix.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency-fix.patch
gpio-pca953xc-add-interrupt-handling-capability-fix.patch
broadsheetfb-support-storing-waveform-fix.patch
memcg-move-charges-of-anonymous-page-cleanup.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
sysctl-clean-up-vm-related-variable-declarations-fix.patch
kmod-add-init-function-to-usermodehelper-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
notify_change-callers-must-hold-i_mutex.patch

