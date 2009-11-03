From: akpm@linux-foundation.org
Subject: + scsi-pmcraid-redundant-check-in-pmcraid_check_ioctl_buffer.patch added to -mm tree
Date: Tue, 03 Nov 2009 15:26:21 -0800
Message-ID: <200911032326.nA3NQLjf030525@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50687 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751165AbZKCX1K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Nov 2009 18:27:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, James.Bottomley@HansenPartnership.com, anil_ravindranath@pmc-sierra.com


The patch titled
     scsi/pmcraid: redundant check in pmcraid_check_ioctl_buffer()?
has been added to the -mm tree.  Its filename is
     scsi-pmcraid-redundant-check-in-pmcraid_check_ioctl_buffer.patch

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
Subject: scsi/pmcraid: redundant check in pmcraid_check_ioctl_buffer()?
From: Roel Kluin <roel.kluin@gmail.com>

struct pmcraid_ioctl_header member buffer_length is unsigned, so this
check appears redundant.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/scsi/pmcraid.c~scsi-pmcraid-redundant-check-in-pmcraid_check_ioctl_buffer drivers/scsi/pmcraid.c
--- a/drivers/scsi/pmcraid.c~scsi-pmcraid-redundant-check-in-pmcraid_check_ioctl_buffer
+++ a/drivers/scsi/pmcraid.c
@@ -3736,12 +3736,6 @@ static int pmcraid_check_ioctl_buffer(
 		return -EINVAL;
 	}
 
-	/* buffer length can't be negetive */
-	if (hdr->buffer_length < 0) {
-		pmcraid_err("ioctl: invalid buffer length specified\n");
-		return -EINVAL;
-	}
-
 	/* check for appropriate buffer access */
 	if ((_IOC_DIR(cmd) & _IOC_READ) == _IOC_READ)
 		access = VERIFY_WRITE;
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
get_maintainer-fix-usage-comment.patch
linux-next.patch
fujitsu-laptop-fix-tests-of-acpi_evaluate_integer-return.patch
omap-fix-unlikelyx-y.patch
pxa-add-missing-underscores-in-define.patch
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
scsi-pmcraid-redundant-check-in-pmcraid_check_ioctl_buffer.patch
page-types-unsigned-cannot-be-less-than-0-in-add_page.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
cryptocop-fix-assertion-in-create_output_descriptors.patch
gpio-fix-test-on-unsigned-in-lnw_irq_type.patch
fbdev-tv_paln-bit-set-twice-in-sisfb_detect_vb_connect.patch
hvc_console-fix-test-on-unsigned-in-hvc_console_print.patch
irq-fix-test-in-__exit-parport_mfc3_exit.patch

