From: akpm@linux-foundation.org
Subject: + ncr5380-bit-mr_dma_mode-set-twice-in-ncr5380_transfer_dma.patch added to -mm tree
Date: Tue, 13 Oct 2009 16:40:21 -0700
Message-ID: <200910132340.n9DNeL2d030265@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42231 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752509AbZJMXlH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Oct 2009 19:41:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, James.Bottomley@HansenPartnership.com, alan@lxorguk.ukuu.org.uk


The patch titled
     NCR5380: bit MR_DMA_MODE set twice in NCR5380_transfer_dma()
has been added to the -mm tree.  Its filename is
     ncr5380-bit-mr_dma_mode-set-twice-in-ncr5380_transfer_dma.patch

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
Subject: NCR5380: bit MR_DMA_MODE set twice in NCR5380_transfer_dma()
From: Roel Kluin <roel.kluin@gmail.com>

Besides keeping the line short, the second setting of the MR_DMA_MODE bit
was removed.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/scsi/NCR5380.c~ncr5380-bit-mr_dma_mode-set-twice-in-ncr5380_transfer_dma drivers/scsi/NCR5380.c
--- a/drivers/scsi/NCR5380.c~ncr5380-bit-mr_dma_mode-set-twice-in-ncr5380_transfer_dma
+++ a/drivers/scsi/NCR5380.c
@@ -1857,7 +1857,9 @@ static int NCR5380_transfer_dma(struct S
 #endif
 	/* KLL May need eop and parity in 53c400 */
 	if (hostdata->flags & FLAG_NCR53C400)
-		NCR5380_write(MODE_REG, MR_BASE | MR_DMA_MODE | MR_ENABLE_PAR_CHECK | MR_ENABLE_PAR_INTR | MR_ENABLE_EOP_INTR | MR_DMA_MODE | MR_MONITOR_BSY);
+		NCR5380_write(MODE_REG, MR_BASE | MR_DMA_MODE |
+				MR_ENABLE_PAR_CHECK | MR_ENABLE_PAR_INTR |
+				MR_ENABLE_EOP_INTR | MR_MONITOR_BSY);
 	else
 		NCR5380_write(MODE_REG, MR_BASE | MR_DMA_MODE);
 #endif				/* def REAL_DMA */
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
fujitsu-laptop-fix-tests-of-acpi_evaluate_integer-return.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
sn-unsigned-cannot-be-less-than-0-in-sn_hwperf_ioctl.patch
hfc_usb-fix-read-buffer-overflow.patch
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
drivers-staging-octeon-ethernet-rgmiic-dont-ignore-request_irq-return-code.patch
page-types-unsigned-cannot-be-less-than-0-in-add_page.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
cryptocop-fix-assertion-in-create_output_descriptors.patch
gpio-fix-test-on-unsigned-in-lnw_irq_type.patch
fbdev-tv_paln-bit-set-twice-in-sisfb_detect_vb_connect.patch

