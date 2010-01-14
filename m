From: akpm@linux-foundation.org
Subject: + gemini-wrong-registers-used-to-set-reg_level-in-gpio_set_irq_type.patch added to -mm tree
Date: Thu, 14 Jan 2010 15:53:57 -0800
Message-ID: <201001142353.o0ENrvM5007371@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52458 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751456Ab0ANXyQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Jan 2010 18:54:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, linux@arm.linux.org.uk, paulius.zaleckas@teltonika.lt


The patch titled
     arch/arm/mach-gemini/gpio.c: wrong registers used to set reg_level in gpio_set_irq_type()
has been added to the -mm tree.  Its filename is
     gemini-wrong-registers-used-to-set-reg_level-in-gpio_set_irq_type.patch

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
Subject: arch/arm/mach-gemini/gpio.c: wrong registers used to set reg_level in gpio_set_irq_type()
From: Roel Kluin <roel.kluin@gmail.com>

It appears the wrong GPIO registers were used

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-gemini/gpio.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/arm/mach-gemini/gpio.c~gemini-wrong-registers-used-to-set-reg_level-in-gpio_set_irq_type arch/arm/mach-gemini/gpio.c
--- a/arch/arm/mach-gemini/gpio.c~gemini-wrong-registers-used-to-set-reg_level-in-gpio_set_irq_type
+++ a/arch/arm/mach-gemini/gpio.c
@@ -86,7 +86,7 @@ static int gpio_set_irq_type(unsigned in
 	unsigned int reg_both, reg_level, reg_type;
 
 	reg_type = __raw_readl(base + GPIO_INT_TYPE);
-	reg_level = __raw_readl(base + GPIO_INT_BOTH_EDGE);
+	reg_level = __raw_readl(base + GPIO_INT_LEVEL);
 	reg_both = __raw_readl(base + GPIO_INT_BOTH_EDGE);
 
 	switch (type) {
@@ -117,7 +117,7 @@ static int gpio_set_irq_type(unsigned in
 	}
 
 	__raw_writel(reg_type, base + GPIO_INT_TYPE);
-	__raw_writel(reg_level, base + GPIO_INT_BOTH_EDGE);
+	__raw_writel(reg_level, base + GPIO_INT_LEVEL);
 	__raw_writel(reg_both, base + GPIO_INT_BOTH_EDGE);
 
 	gpio_ack_irq(irq);
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
acpi-fix-confusion-in-acpi_evaluate_string-in-comment.patch
asus-acpi-remove-duplicate-comparison-of-asus_model-strings.patch
gemini-wrong-registers-used-to-set-reg_level-in-gpio_set_irq_type.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
hisax-timeout-off-by-one-in-waitrecmsg.patch
das_net-not-copied-but-assigned-to-itself-in-aarp_rcv.patch
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
dc395x-decrease-iteration-for-tag_number-of-max_command-in-start_scsi.patch
mpt2sas-fix-confusion-in-_scsih_sas_device_status_change_event.patch
paride-fix-off-by-one-test.patch
80211core-fix-confusion.patch
rtl8192u-ieee80211-currentmpdudensity-assigned-to-itself-in-htusedefaultsetting.patch
musb-test-always-evaluates-to-false.patch
musb-dont-dereference-null-tusb_dma-in-dma_controller_destroy.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
cryptocop-fix-assertion-in-create_output_descriptors.patch
asiliantfb-fix-test-of-unsigned-in-asiliant_calc_dclk2.patch
w1-fix-test-in-ds2482_wait_1wire_idle.patch

