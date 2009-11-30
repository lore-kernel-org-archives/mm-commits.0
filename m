From: akpm@linux-foundation.org
Subject: [merged] st-fix-test-of-value-range-in-st_set_options.patch removed from -mm tree
Date: Mon, 30 Nov 2009 12:34:17 -0800
Message-ID: <200911302034.nAUKYH8J023172@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53021 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752057AbZK3Uei (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Nov 2009 15:34:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, James.Bottomley@HansenPartnership.com, kai.makisara@kolumbus.fi, osst@riede.org, mm-commits@vger.kernel.org


The patch titled
     st: fix test of value range in st_set_options()
has been removed from the -mm tree.  Its filename was
     st-fix-test-of-value-range-in-st_set_options.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: st: fix test of value range in st_set_options()
From: Roel Kluin <roel.kluin@gmail.com>

value cannot logically be less than START and greater than BUFFERSIZE.

#define EXTENDED_SENSE_START  18

// vi include/scsi/scsi_cmnd.h +105
#define SCSI_SENSE_BUFFERSIZE 	96

[akpm@linux-foundation.org: fix warning]
Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Willem Riede <osst@riede.org>
Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Acked-by: Kai Makisara <kai.makisara@kolumbus.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/st.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/st.c~st-fix-test-of-value-range-in-st_set_options drivers/scsi/st.c
--- a/drivers/scsi/st.c~st-fix-test-of-value-range-in-st_set_options
+++ a/drivers/scsi/st.c
@@ -2280,7 +2280,8 @@ static int st_set_options(struct scsi_ta
 	} else if (code == MT_ST_SET_CLN) {
 		value = (options & ~MT_ST_OPTIONS) & 0xff;
 		if (value != 0 &&
-		    value < EXTENDED_SENSE_START && value >= SCSI_SENSE_BUFFERSIZE)
+			(value < EXTENDED_SENSE_START ||
+				value >= SCSI_SENSE_BUFFERSIZE))
 			return (-EINVAL);
 		STp->cln_mode = value;
 		STp->cln_sense_mask = (options >> 8) & 0xff;
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
fujitsu-laptop-fix-tests-of-acpi_evaluate_integer-return.patch
omap-return-ptr_err-rather-than-is_err.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
mtd-error-return-eio-instead-of-eio.patch
jffs2-fix-min-max-confusion.patch
imx-bit-confusion.patch
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
r8192u_core-test-for-negative-error-in-rtl8192_rx_isr.patch
wusb-use-sizeof-struct-rather-than-pointer.patch
page-types-unsigned-cannot-be-less-than-0-in-add_page.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
cryptocop-fix-assertion-in-create_output_descriptors.patch
gpio-fix-test-on-unsigned-in-lnw_irq_type.patch
fbdev-tv_paln-bit-set-twice-in-sisfb_detect_vb_connect.patch
hvc_console-fix-test-on-unsigned-in-hvc_console_print.patch
zlib-optimize-inffast-when-copying-direct-from-output.patch

