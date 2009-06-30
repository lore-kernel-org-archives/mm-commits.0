From: akpm@linux-foundation.org
Subject: + drivers-usb-serial-ti_usb_3410_5052c-fix-uninitialied-var-warning.patch added to -mm tree
Date: Mon, 29 Jun 2009 17:08:16 -0700
Message-ID: <200906300028.n5U0Sfad008535@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34694 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753272AbZF3A2t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Jun 2009 20:28:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, greg@kroah.com, oliver@neukum.org, stern@rowland.harvard.edu


The patch titled
     drivers/usb/serial/ti_usb_3410_5052.c: fix uninitialied var warning
has been added to the -mm tree.  Its filename is
     drivers-usb-serial-ti_usb_3410_5052c-fix-uninitialied-var-warning.patch

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
Subject: drivers/usb/serial/ti_usb_3410_5052.c: fix uninitialied var warning
From: Andrew Morton <akpm@linux-foundation.org>

drivers/usb/serial/ti_usb_3410_5052.c: In function 'ti_startup':
drivers/usb/serial/ti_usb_3410_5052.c:1661: warning: 'status' may be used uninitialized in this function

Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oliver@neukum.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/ti_usb_3410_5052.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/usb/serial/ti_usb_3410_5052.c~drivers-usb-serial-ti_usb_3410_5052c-fix-uninitialied-var-warning drivers/usb/serial/ti_usb_3410_5052.c
--- a/drivers/usb/serial/ti_usb_3410_5052.c~drivers-usb-serial-ti_usb_3410_5052c-fix-uninitialied-var-warning
+++ a/drivers/usb/serial/ti_usb_3410_5052.c
@@ -1658,7 +1658,6 @@ static int ti_do_download(struct usb_dev
 	u8 cs = 0;
 	int done;
 	struct ti_firmware_header *header;
-	int status;
 	int len;
 
 	for (pos = sizeof(struct ti_firmware_header); pos < size; pos++)
@@ -1671,13 +1670,15 @@ static int ti_do_download(struct usb_dev
 
 	dbg("%s - downloading firmware", __func__);
 	for (pos = 0; pos < size; pos += done) {
+		int status;
+
 		len = min(size - pos, TI_DOWNLOAD_MAX_PACKET_SIZE);
 		status = usb_bulk_msg(dev, pipe, buffer + pos, len,
 								&done, 1000);
 		if (status)
-			break;
+			return status;
 	}
-	return status;
+	return 0;
 }
 
 static int ti_download_firmware(struct ti_device *tdev)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
3x59x-fix-pci-resource-management-checkpatch-fixes.patch
drivers-serial-bfin_sport_uartc-remove-wrong-and-unneeded-memset.patch
drivers-usb-gadget-s3c2410_udcc-fix.patch
drivers-usb-serial-ti_usb_3410_5052c-fix-uninitialied-var-warning.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
fs-fix-overflow-in-sys_mount-for-in-kernel-calls-fix.patch
arch-x86-oprofile-op_model_amdc-fix-op_amd_handle_ibs-return-type.patch
drivers-rtc-rtc-cmosc-cmos_init-dont-ignore-pnp_register_driver-return-value.patch
mm-make-swap-token-dummies-static-inlines-fix.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
memory-hotplug-update-zone-pcp-at-memory-online-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
arch-m68k-include-asm-motorola_pgalloch-fix-kunmap-arg.patch
printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec-fix.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-fix.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-cleanup.patch
proc-connector-add-event-for-process-becoming-session-leader-checkpatch-fixes.patch
rtc-add-driver-for-mxcs-internal-rtc-module-fix.patch
rtc-philips-nxp-pcf2123-driver-v03-fix.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
memcg-add-comments-explaining-memory-barriers-checkpatch-fixes.patch
n_hdlc-add-buffer-flushing-checkpatch-fixes.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

