From: akpm@linux-foundation.org
Subject: [merged] hwmon-fix-check-on-unsigned-in-watchdog_release.patch removed from -mm tree
Date: Mon, 26 Oct 2009 15:23:39 -0700
Message-ID: <200910262223.n9QMNd9d011387@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34097 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753946AbZJZWY3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Oct 2009 18:24:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, hdegoede@redhat.com, khali@linux-fr.org, mm-commits@vger.kernel.org


The patch titled
     hwmon: fix check on unsigned in watchdog_release()
has been removed from the -mm tree.  Its filename was
     hwmon-fix-check-on-unsigned-in-watchdog_release.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hwmon: fix check on unsigned in watchdog_release()
From: Roel Kluin <roel.kluin@gmail.com>

If unsigned the watchdog_trigger() return value will not be checked
correctly.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/hwmon/fschmd.c~hwmon-fix-check-on-unsigned-in-watchdog_release drivers/hwmon/fschmd.c
--- a/drivers/hwmon/fschmd.c~hwmon-fix-check-on-unsigned-in-watchdog_release
+++ a/drivers/hwmon/fschmd.c
@@ -819,7 +819,7 @@ static int watchdog_release(struct inode
 static ssize_t watchdog_write(struct file *filp, const char __user *buf,
 	size_t count, loff_t *offset)
 {
-	size_t ret;
+	int ret;
 	struct fschmd_data *data = filp->private_data;
 
 	if (count) {
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
frv-fix-check-on-unsigned-in-do_signal.patch
linux-next.patch
fujitsu-laptop-fix-tests-of-acpi_evaluate_integer-return.patch
omap-fix-unlikelyx-y.patch
powernow-k8-fix-test-in-get_transition_latency.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
hfc_usb-fix-read-buffer-overflow.patch
hisax-fix-test-in-waitforxfw.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
ibmmca-buffer-overflow.patch
scsi-eata-fix-buffer-overflow.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-u14-34fc-fix-uffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
gdth-unmap-ccb_phys-when-scsi_add_host-fails-in-gdth_eisa_probe_one.patch
zfcp-test-kmalloc-failure-in-scsi_get_vpd_page.patch
st-fix-test-of-value-range-in-st_set_options.patch
ncr5380-bit-mr_dma_mode-set-twice-in-ncr5380_transfer_dma.patch
bfa-fix-test-in-bfad_os_fc_host_init.patch
drivers-staging-octeon-ethernet-rgmiic-dont-ignore-request_irq-return-code.patch
page-types-unsigned-cannot-be-less-than-0-in-add_page.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
cryptocop-fix-assertion-in-create_output_descriptors.patch
gpio-fix-test-on-unsigned-in-lnw_irq_type.patch
fbdev-tv_paln-bit-set-twice-in-sisfb_detect_vb_connect.patch
hvc_console-fix-test-on-unsigned-in-hvc_console_print.patch
irq-fix-test-in-__exit-parport_mfc3_exit.patch
cachefiles-cleanup-redundant-tests-on-unsigned.patch

