From: akpm@linux-foundation.org
Subject: + omap-fix-unlikelyx-y.patch added to -mm tree
Date: Tue, 13 Oct 2009 19:06:38 -0700
Message-ID: <200910140206.n9E26c0r013217@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56336 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760840AbZJNCH0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Oct 2009 22:07:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, rmk@arm.linux.org.uk, tony@atomide.com


The patch titled
     omap: fix unlikely(x) < y
has been added to the -mm tree.  Its filename is
     omap-fix-unlikelyx-y.patch

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
@@ -343,7 +343,7 @@ static inline int gpio_valid(int gpio)
 
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
omap-fix-unlikelyx-y.patch
powernow-k8-fix-test-in-get_transition_latency.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
sn-unsigned-cannot-be-less-than-0-in-sn_hwperf_ioctl.patch
hfc_usb-fix-read-buffer-overflow.patch
sb1250-mac-duplicate-setting-of-bit-v_mac_rx_pl_thrsh4-in-sbmac_channel_start.patch
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
irq-fix-test-in-__exit-parport_mfc3_exit.patch

