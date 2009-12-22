From: akpm@linux-foundation.org
Subject: [nacked] fujitsu-laptop-fix-tests-of-acpi_evaluate_integer-return.patch removed from -mm tree
Date: Tue, 22 Dec 2009 12:43:22 -0800
Message-ID: <200912222043.nBMKhMP4023709@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41935 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752376AbZLVUom (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Dec 2009 15:44:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, jwoithe@physics.adelaide.edu.au, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     fujitsu-laptop: fix tests of acpi_evaluate_integer() return
has been removed from the -mm tree.  Its filename was
     fujitsu-laptop-fix-tests-of-acpi_evaluate_integer-return.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fujitsu-laptop: fix tests of acpi_evaluate_integer() return
From: Roel Kluin <roel.kluin@gmail.com>

The wrong test was used acpi_status status is unsigned.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/fujitsu-laptop.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/platform/x86/fujitsu-laptop.c~fujitsu-laptop-fix-tests-of-acpi_evaluate_integer-return drivers/platform/x86/fujitsu-laptop.c
--- a/drivers/platform/x86/fujitsu-laptop.c~fujitsu-laptop-fix-tests-of-acpi_evaluate_integer-return
+++ a/drivers/platform/x86/fujitsu-laptop.c
@@ -376,7 +376,7 @@ static int get_lcd_level(void)
 
 	status =
 	    acpi_evaluate_integer(fujitsu->acpi_handle, "GBLL", NULL, &state);
-	if (status < 0)
+	if (ACPI_FAILURE(status))
 		return status;
 
 	fujitsu->brightness_level = state & 0x0fffffff;
@@ -398,7 +398,7 @@ static int get_max_brightness(void)
 
 	status =
 	    acpi_evaluate_integer(fujitsu->acpi_handle, "RBLL", NULL, &state);
-	if (status < 0)
+	if (ACPI_FAILURE(status))
 		return status;
 
 	fujitsu->max_brightness = state;
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
fujitsu-laptop-fix-tests-of-acpi_evaluate_integer-return.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
powerpc-85xx-wrong-variable-returned-on-error.patch
imx-bit-confusion.patch
serial-fix-test-of-unsigned.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
ibmmca-buffer-overflow.patch
scsi-eata-fix-buffer-overflow.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-u14-34fc-fix-uffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
gdth-unmap-ccb_phys-when-scsi_add_host-fails-in-gdth_eisa_probe_one.patch
zfcp-test-kmalloc-failure-in-scsi_get_vpd_page.patch
ncr5380-bit-mr_dma_mode-set-twice-in-ncr5380_transfer_dma.patch
scsi-pmcraid-redundant-check-in-pmcraid_check_ioctl_buffer.patch
drbd-fix-test-of-unsigned-in-_drbd_fault_random.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
cryptocop-fix-assertion-in-create_output_descriptors.patch
asiliantfb-fix-test-of-unsigned-in-asiliant_calc_dclk2.patch
hvc_console-fix-test-on-unsigned-in-hvc_console_print.patch
zlib-optimize-inffast-when-copying-direct-from-output.patch

