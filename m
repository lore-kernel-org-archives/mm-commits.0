From: akpm@linux-foundation.org
Subject: + bfa-comparison-with-wrong-msgtag-in-bfa_pport_isr.patch added to -mm tree
Date: Mon, 25 Jan 2010 16:52:17 -0800
Message-ID: <201001260052.o0Q0qHqt021353@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50826 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750883Ab0AZAwl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jan 2010 19:52:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, James.Bottomley@HansenPartnership.com, huangj@brocade.com


The patch titled
     bfa: comparison with wrong msgtag in bfa_pport_isr()
has been added to the -mm tree.  Its filename is
     bfa-comparison-with-wrong-msgtag-in-bfa_pport_isr.patch

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
Subject: bfa: comparison with wrong msgtag in bfa_pport_isr()
From: Roel Kluin <roel.kluin@gmail.com>

Compare it with the disable msgtag.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Jing Huang <huangj@brocade.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/bfa/bfa_fcport.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/bfa/bfa_fcport.c~bfa-comparison-with-wrong-msgtag-in-bfa_pport_isr drivers/scsi/bfa/bfa_fcport.c
--- a/drivers/scsi/bfa/bfa_fcport.c~bfa-comparison-with-wrong-msgtag-in-bfa_pport_isr
+++ a/drivers/scsi/bfa/bfa_fcport.c
@@ -918,7 +918,7 @@ bfa_pport_isr(struct bfa_s *bfa, struct 
 		break;
 
 	case BFI_PPORT_I2H_DISABLE_RSP:
-		if (pport->msgtag == i2hmsg.enable_rsp->msgtag)
+		if (pport->msgtag == i2hmsg.disable_rsp->msgtag)
 			bfa_sm_send_event(pport, BFA_PPORT_SM_FWRSP);
 		break;
 
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
musb-test-always-evaluates-to-false.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
cryptocop-fix-assertion-in-create_output_descriptors.patch
cris-v32-typo-in-crisv32_arbiter_unwatch.patch
asiliantfb-fix-test-of-unsigned-in-asiliant_calc_dclk2.patch
w1-fix-test-in-ds2482_wait_1wire_idle.patch

