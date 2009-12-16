From: akpm@linux-foundation.org
Subject: [merged] gpio-fix-test-on-unsigned-in-lnw_irq_type.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:35:16 -0800
Message-ID: <200912162035.nBGKZGpS013088@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55029 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935261AbZLPUfU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:35:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, alek.du@intel.com, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     gpio: fix test on unsigned in lnw_irq_type()
has been removed from the -mm tree.  Its filename was
     gpio-fix-test-on-unsigned-in-lnw_irq_type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpio: fix test on unsigned in lnw_irq_type()
From: Roel Kluin <roel.kluin@gmail.com>

The wrong test was used, gpio is unsigned and it had an off-by-one.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Alek Du <alek.du@intel.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/langwell_gpio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/gpio/langwell_gpio.c~gpio-fix-test-on-unsigned-in-lnw_irq_type drivers/gpio/langwell_gpio.c
--- a/drivers/gpio/langwell_gpio.c~gpio-fix-test-on-unsigned-in-lnw_irq_type
+++ a/drivers/gpio/langwell_gpio.c
@@ -123,7 +123,7 @@ static int lnw_irq_type(unsigned irq, un
 	void __iomem *grer = (void __iomem *)(&lnw->reg_base->GRER[reg]);
 	void __iomem *gfer = (void __iomem *)(&lnw->reg_base->GFER[reg]);
 
-	if (gpio < 0 || gpio > lnw->chip.ngpio)
+	if (gpio >= lnw->chip.ngpio)
 		return -EINVAL;
 	spin_lock_irqsave(&lnw->lock, flags);
 	if (type & IRQ_TYPE_EDGE_RISING)
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
fujitsu-laptop-fix-tests-of-acpi_evaluate_integer-return.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
powerpc-85xx-wrong-variable-returned-on-error.patch
hidp-ptr_err-return-of-wrong-pointer-in-hidp_setup_hid.patch
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
keys-ptr_err-return-of-wrong-pointer-in-keyctl_get_security.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
cryptocop-fix-assertion-in-create_output_descriptors.patch
hvc_console-fix-test-on-unsigned-in-hvc_console_print.patch
zlib-optimize-inffast-when-copying-direct-from-output.patch

