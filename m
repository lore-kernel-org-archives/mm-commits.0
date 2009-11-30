From: akpm@linux-foundation.org
Subject: [merged] irq-fix-test-in-__exit-parport_mfc3_exit.patch removed from -mm tree
Date: Mon, 30 Nov 2009 12:34:39 -0800
Message-ID: <200911302034.nAUKYdab024108@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48560 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753075AbZK3UfI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Nov 2009 15:35:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     parport: fix IRQ test in __exit parport_mfc3_exit()
has been removed from the -mm tree.  Its filename was
     irq-fix-test-in-__exit-parport_mfc3_exit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: parport: fix IRQ test in __exit parport_mfc3_exit()
From: Roel Kluin <roel.kluin@gmail.com>

Not makes it a bool before the comparison.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/parport/parport_mfc3.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/parport/parport_mfc3.c~irq-fix-test-in-__exit-parport_mfc3_exit drivers/parport/parport_mfc3.c
--- a/drivers/parport/parport_mfc3.c~irq-fix-test-in-__exit-parport_mfc3_exit
+++ a/drivers/parport/parport_mfc3.c
@@ -386,7 +386,7 @@ static void __exit parport_mfc3_exit(voi
 		if (!this_port[i])
 			continue;
 		parport_remove_port(this_port[i]);
-		if (!this_port[i]->irq != PARPORT_IRQ_NONE) {
+		if (this_port[i]->irq != PARPORT_IRQ_NONE) {
 			if (--use_cnt == 0) 
 				free_irq(IRQ_AMIGA_PORTS, &pp_mfc3_ops);
 		}
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

