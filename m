From: akpm@linux-foundation.org
Subject: [merged] misdn-fix-error-return-in-hfcmulti_init.patch removed from -mm tree
Date: Tue, 17 Nov 2009 13:13:27 -0800
Message-ID: <200911172113.nAHLDRwh009388@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54465 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752675AbZKQVN1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Nov 2009 16:13:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, davem@davemloft.net, keil@b1-systems.de, mm-commits@vger.kernel.org


The patch titled
     mISDN: fix error return in HFCmulti_init()
has been removed from the -mm tree.  Its filename was
     misdn-fix-error-return-in-hfcmulti_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mISDN: fix error return in HFCmulti_init()
From: Roel Kluin <roel.kluin@gmail.com>

The returned error should stay negative

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: Karsten Keil <keil@b1-systems.de>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/hardware/mISDN/hfcmulti.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/isdn/hardware/mISDN/hfcmulti.c~misdn-fix-error-return-in-hfcmulti_init drivers/isdn/hardware/mISDN/hfcmulti.c
--- a/drivers/isdn/hardware/mISDN/hfcmulti.c~misdn-fix-error-return-in-hfcmulti_init
+++ a/drivers/isdn/hardware/mISDN/hfcmulti.c
@@ -5481,7 +5481,7 @@ HFCmulti_init(void)
 		if (err) {
 			printk(KERN_ERR "error registering embedded driver: "
 				"%x\n", err);
-			return -err;
+			return err;
 		}
 		HFC_cnt++;
 		printk(KERN_INFO "%d devices registered\n", HFC_cnt);
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
spi-error-status-should-be-negative.patch
drivers-video-da8xx-fbc-fix-error-return.patch
linux-next.patch
fujitsu-laptop-fix-tests-of-acpi_evaluate_integer-return.patch
omap-fix-unlikelyx-y.patch
omap-cs-should-be-positive-in-gpmc_cs_free.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
sms-cards-make-id-unsigned-in-sms_get_board.patch
mtd-error-return-eio-instead-of-eio.patch
net-netfilter-xt_osfc-xt_osf_remove_callback-should-return-negative-on-errors.patch
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
zlib-optimize-inffast-when-copying-direct-from-output.patch

