From: akpm@linux-foundation.org
Subject: + comedi-g1-3-status-registers-not-read-in-ni_gpct_to_660x_register.patch added to -mm tree
Date: Mon, 25 Jan 2010 16:58:06 -0800
Message-ID: <201001260058.o0Q0w6t2021627@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48925 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1749667Ab0AZA6N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jan 2010 19:58:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, devel@driverdev.osuosl.org, gregkh@suse.de, wfp5p@virginia.edu


The patch titled
     comedi: G1-3 status registers not read in ni_gpct_to_660x_register()
has been added to the -mm tree.  Its filename is
     comedi-g1-3-status-registers-not-read-in-ni_gpct_to_660x_register.patch

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
Subject: comedi: G1-3 status registers not read in ni_gpct_to_660x_register()
From: Roel Kluin <roel.kluin@gmail.com>

Read from the right status register

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Bill Pemberton <wfp5p@virginia.edu>
Cc: <devel@driverdev.osuosl.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/comedi/drivers/ni_660x.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/staging/comedi/drivers/ni_660x.c~comedi-g1-3-status-registers-not-read-in-ni_gpct_to_660x_register drivers/staging/comedi/drivers/ni_660x.c
--- a/drivers/staging/comedi/drivers/ni_660x.c~comedi-g1-3-status-registers-not-read-in-ni_gpct_to_660x_register
+++ a/drivers/staging/comedi/drivers/ni_660x.c
@@ -691,13 +691,13 @@ static enum NI_660x_Register ni_gpct_to_
 		ni_660x_register = G0StatusRegister;
 		break;
 	case NITIO_G1_Status_Reg:
-		ni_660x_register = G0StatusRegister;
+		ni_660x_register = G1StatusRegister;
 		break;
 	case NITIO_G2_Status_Reg:
-		ni_660x_register = G0StatusRegister;
+		ni_660x_register = G2StatusRegister;
 		break;
 	case NITIO_G3_Status_Reg:
-		ni_660x_register = G0StatusRegister;
+		ni_660x_register = G3StatusRegister;
 		break;
 	case NITIO_G0_Interrupt_Enable_Reg:
 		ni_660x_register = G0InterruptEnable;
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
acpi-fix-confusion-in-acpi_evaluate_string-in-comment.patch
asus-acpi-remove-duplicate-comparison-of-asus_model-strings.patch
thinkpad-acpi-wrong-thermal-attribute_group-removed-in-thermal_exit.patch
gemini-wrong-registers-used-to-set-reg_level-in-gpio_set_irq_type.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
drivers-gpu-drm-drm_crtc_helperc-fix-setting-of-fb_changed-in-drm_crtc_helper_set_config.patch
ia64-wrong-attribute-of-hub-chip-written-in-uv_setup.patch
hisax-timeout-off-by-one-in-waitrecmsg.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
gdth-unmap-ccb_phys-when-scsi_add_host-fails-in-gdth_eisa_probe_one.patch
ncr5380-bit-mr_dma_mode-set-twice-in-ncr5380_transfer_dma.patch
scsi-pmcraid-redundant-check-in-pmcraid_check_ioctl_buffer.patch
dc395x-decrease-iteration-for-tag_number-of-max_command-in-start_scsi.patch
mpt2sas-fix-confusion-in-_scsih_sas_device_status_change_event.patch
lpfc-two-branches-the-same-in-lpfc_decode_firmware_rev.patch
bfa-comparison-with-wrong-msgtag-in-bfa_pport_isr.patch
paride-fix-off-by-one-test.patch
rt2860-sta_ioctlc-two-branches-the-same-in-rt_ioctl_giwscan.patch
serqt_usb2-two-branches-the-same-in-qt_set_termios.patch
comedi-g1-3-status-registers-not-read-in-ni_gpct_to_660x_register.patch
musb-test-always-evaluates-to-false.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
cryptocop-fix-assertion-in-create_output_descriptors.patch
cris-v32-typo-in-crisv32_arbiter_unwatch.patch
asiliantfb-fix-test-of-unsigned-in-asiliant_calc_dclk2.patch
w1-fix-test-in-ds2482_wait_1wire_idle.patch

