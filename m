From: akpm@linux-foundation.org
Subject: + spi-error-status-should-be-negative.patch added to -mm tree
Date: Thu, 12 Nov 2009 15:41:45 -0800
Message-ID: <200911122341.nACNfjTJ022861@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33842 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755164AbZKLXmS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Nov 2009 18:42:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, dbrownell@users.sourceforge.net, dpervushin@embeddedalley.com


The patch titled
     spi: error status should be negative
has been added to the -mm tree.  Its filename is
     spi-error-status-should-be-negative.patch

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
Subject: spi: error status should be negative
From: Roel Kluin <roel.kluin@gmail.com>

Return a negative error value instead of a positive

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: dmitry pervushin <dpervushin@embeddedalley.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_stmp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/spi/spi_stmp.c~spi-error-status-should-be-negative drivers/spi/spi_stmp.c
--- a/drivers/spi/spi_stmp.c~spi-error-status-should-be-negative
+++ a/drivers/spi/spi_stmp.c
@@ -242,7 +242,7 @@ static int stmp_spi_txrx_dma(struct stmp
 	wait_for_completion(&ss->done);
 
 	if (!busy_wait(readl(ss->regs + HW_SSP_CTRL0) & BM_SSP_CTRL0_RUN))
-		status = ETIMEDOUT;
+		status = -ETIMEDOUT;
 
 	if (!dma_buf)
 		dma_unmap_single(ss->master_dev, spi_buf_dma, len, dir);
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
get_maintainer-fix-usage-comment.patch
spi-error-status-should-be-negative.patch
linux-next.patch
fujitsu-laptop-fix-tests-of-acpi_evaluate_integer-return.patch
omap-fix-unlikelyx-y.patch
omap-cs-should-be-positive-in-gpmc_cs_free.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
sms-cards-make-id-unsigned-in-sms_get_board.patch
mtd-error-return-eio-instead-of-eio.patch
ocfs2-error-return-should-be-negative.patch
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
scsi-pmcraid-redundant-check-in-pmcraid_check_ioctl_buffer.patch
page-types-unsigned-cannot-be-less-than-0-in-add_page.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
cryptocop-fix-assertion-in-create_output_descriptors.patch
gpio-fix-test-on-unsigned-in-lnw_irq_type.patch
fbdev-tv_paln-bit-set-twice-in-sisfb_detect_vb_connect.patch
hvc_console-fix-test-on-unsigned-in-hvc_console_print.patch
irq-fix-test-in-__exit-parport_mfc3_exit.patch

