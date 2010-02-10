From: akpm@linux-foundation.org
Subject: [merged] mx1-mx2-einval-overwritten-in-second-iteration-in-mxc_gpio_setup_multiple_pins.patch removed from -mm tree
Date: Wed, 10 Feb 2010 11:26:35 -0800
Message-ID: <201002101926.o1AJQZwa026825@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52010 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753179Ab0BJT1Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Feb 2010 14:27:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, rmk@arm.linux.org.uk, u.kleine-koenig@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     arm: mx1/mx2: -EINVAL overwritten in second iteration in mxc_gpio_=
setup_multiple_pins()
has been removed from the -mm tree.  Its filename was
     mx1-mx2-einval-overwritten-in-second-iteration-in-mxc_gpio_setup_m=
ultiple_pins.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: arm: mx1/mx2: -EINVAL overwritten in second iteration in mxc_g=
pio_setup_multiple_pins()
=46rom: Roel Kluin <roel.kluin@gmail.com>

Due to the `ret =3D gpio_request()' below in the loop, the initial -EIN=
VAL
value of ret is overwritten.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Acked-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/plat-mxc/iomux-mx1-mx2.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN arch/arm/plat-mxc/iomux-mx1-mx2.c~mx1-mx2-einval-overwritten-=
in-second-iteration-in-mxc_gpio_setup_multiple_pins arch/arm/plat-mxc/i=
omux-mx1-mx2.c
--- a/arch/arm/plat-mxc/iomux-mx1-mx2.c~mx1-mx2-einval-overwritten-in-s=
econd-iteration-in-mxc_gpio_setup_multiple_pins
+++ a/arch/arm/plat-mxc/iomux-mx1-mx2.c
@@ -116,14 +116,16 @@ int mxc_gpio_setup_multiple_pins(const i
 	int i;
 	unsigned gpio;
 	unsigned mode;
-	int ret =3D -EINVAL;
+	int ret;
=20
 	for (i =3D 0; i < count; i++) {
 		gpio =3D *p & (GPIO_PIN_MASK | GPIO_PORT_MASK);
 		mode =3D *p & ~(GPIO_PIN_MASK | GPIO_PORT_MASK);
=20
-		if (gpio >=3D (GPIO_PORT_MAX + 1) * 32)
+		if (gpio >=3D (GPIO_PORT_MAX + 1) * 32) {
+			ret =3D -EINVAL;
 			goto setup_error;
+		}
=20
 		ret =3D gpio_request(gpio, label);
 		if (ret)
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
thinkpad-acpi-wrong-thermal-attribute_group-removed-in-thermal_exit.pat=
ch
acpi-fix-confusion-in-acpi_evaluate_string-in-comment.patch
asus-acpi-remove-duplicate-comparison-of-asus_model-strings.patch
gemini-wrong-registers-used-to-set-reg_level-in-gpio_set_irq_type.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
ia64-wrong-attribute-of-hub-chip-written-in-uv_setup.patch
mtd-hot-spin-and-code-duplication-in-nand_bcm_umi_bch_read_oobecc.patch
mtd-change-positive-error-return-into-negative-in-mtd_do_writeoob.patch
score-fix-dereference-of-null-pointer-in-local_flush_tlb_page.patch
obsolete-config-in-kernel-source-use_internal_timer.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
gdth-unmap-ccb_phys-when-scsi_add_host-fails-in-gdth_eisa_probe_one.pat=
ch
ncr5380-bit-mr_dma_mode-set-twice-in-ncr5380_transfer_dma.patch
scsi-pmcraid-redundant-check-in-pmcraid_check_ioctl_buffer.patch
dc395x-decrease-iteration-for-tag_number-of-max_command-in-start_scsi.p=
atch
mpt2sas-fix-confusion-in-_scsih_sas_device_status_change_event.patch
lpfc-two-branches-the-same-in-lpfc_decode_firmware_rev.patch
lpfc-positive-error-return-into-negative.patch
qla2xxx-negative-error-return-in-qla2x00_change_queue_depth.patch
scsi-bfa-correct-onstack-wait_queue_head-declaration.patch
paride-fix-off-by-one-test.patch
musb-test-always-evaluates-to-false.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
alpha-ptr_err-overwrites-einval-in-syscall-osf_mount.patch
cryptocop-fix-assertion-in-create_output_descriptors.patch
cris-v32-typo-in-crisv32_arbiter_unwatch.patch
asiliantfb-fix-test-of-unsigned-in-asiliant_calc_dclk2.patch
w1-fix-test-in-ds2482_wait_1wire_idle.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
