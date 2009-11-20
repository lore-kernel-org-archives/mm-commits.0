From: akpm@linux-foundation.org
Subject: [merged] omap-fix-unlikelyx-y.patch removed from -mm tree
Date: Fri, 20 Nov 2009 11:30:36 -0800
Message-ID: <200911201930.nAKJUaON011021@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38302 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752033AbZKTTc7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Nov 2009 14:32:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, rmk@arm.linux.org.uk, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     omap: fix unlikely(x) < y
has been removed from the -mm tree.  Its filename was
     omap-fix-unlikelyx-y.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: omap: fix unlikely(x) < y
From: Roel Kluin <roel.kluin@gmail.com>

The closing parenthesis was not in the right location.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/plat-omap/gpio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/arm/plat-omap/gpio.c~omap-fix-unlikelyx-y arch/arm/plat-omap/gpio.c
--- a/arch/arm/plat-omap/gpio.c~omap-fix-unlikelyx-y
+++ a/arch/arm/plat-omap/gpio.c
@@ -391,7 +391,7 @@ static inline int gpio_valid(int gpio)
 
 static int check_gpio(int gpio)
 {
-	if (unlikely(gpio_valid(gpio)) < 0) {
+	if (unlikely(gpio_valid(gpio) < 0)) {
 		printk(KERN_ERR "omap-gpio: invalid GPIO %d\n", gpio);
 		dump_stack();
 		return -1;
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
fujitsu-laptop-fix-tests-of-acpi_evaluate_integer-return.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
sms-cards-make-id-unsigned-in-sms_get_board.patch
mtd-error-return-eio-instead-of-eio.patch
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

