From: akpm@linux-foundation.org
Subject: + dma-cases-ipu_pix_fmt_bgra32-bgr32-and-abgr32-are-the-same-in-ipu_ch_param_set_size.patch added to -mm tree
Date: Mon, 25 Jan 2010 17:02:14 -0800
Message-ID: <201001260102.o0Q12ErR021868@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54375 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751119Ab0AZBCU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jan 2010 20:02:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, dan.j.williams@intel.com, g.liakhovetski@gmx.de, maciej.sosnowski@intel.com


The patch titled
     dma: cases IPU_PIX_FMT_BGRA32, BGR32 and ABGR32 are the same in ipu_ch_param_set_size()
has been added to the -mm tree.  Its filename is
     dma-cases-ipu_pix_fmt_bgra32-bgr32-and-abgr32-are-the-same-in-ipu_ch_param_set_size.patch

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
Subject: dma: cases IPU_PIX_FMT_BGRA32, BGR32 and ABGR32 are the same in ipu_ch_param_set_size()
From: Roel Kluin <roel.kluin@gmail.com>

In these cases the same statements are executed.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Maciej Sosnowski <maciej.sosnowski@intel.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/ipu/ipu_idmac.c |   15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff -puN drivers/dma/ipu/ipu_idmac.c~dma-cases-ipu_pix_fmt_bgra32-bgr32-and-abgr32-are-the-same-in-ipu_ch_param_set_size drivers/dma/ipu/ipu_idmac.c
--- a/drivers/dma/ipu/ipu_idmac.c~dma-cases-ipu_pix_fmt_bgra32-bgr32-and-abgr32-are-the-same-in-ipu_ch_param_set_size
+++ a/drivers/dma/ipu/ipu_idmac.c
@@ -348,6 +348,7 @@ static void ipu_ch_param_set_size(union 
 		break;
 	case IPU_PIX_FMT_BGRA32:
 	case IPU_PIX_FMT_BGR32:
+	case IPU_PIX_FMT_ABGR32:
 		params->ip.bpp	= 0;
 		params->ip.pfs	= 4;
 		params->ip.npb	= 7;
@@ -376,20 +377,6 @@ static void ipu_ch_param_set_size(union 
 		params->ip.wid2	= 7;		/* Blue bit width - 1 */
 		params->ip.wid3	= 7;		/* Alpha bit width - 1 */
 		break;
-	case IPU_PIX_FMT_ABGR32:
-		params->ip.bpp	= 0;
-		params->ip.pfs	= 4;
-		params->ip.npb	= 7;
-		params->ip.sat	= 2;		/* SAT = 32-bit access */
-		params->ip.ofs0	= 8;		/* Red bit offset */
-		params->ip.ofs1	= 16;		/* Green bit offset */
-		params->ip.ofs2	= 24;		/* Blue bit offset */
-		params->ip.ofs3	= 0;		/* Alpha bit offset */
-		params->ip.wid0	= 7;		/* Red bit width - 1 */
-		params->ip.wid1	= 7;		/* Green bit width - 1 */
-		params->ip.wid2	= 7;		/* Blue bit width - 1 */
-		params->ip.wid3	= 7;		/* Alpha bit width - 1 */
-		break;
 	case IPU_PIX_FMT_UYVY:
 		params->ip.bpp	= 2;
 		params->ip.pfs	= 6;
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
acpi-fix-confusion-in-acpi_evaluate_string-in-comment.patch
asus-acpi-remove-duplicate-comparison-of-asus_model-strings.patch
thinkpad-acpi-wrong-thermal-attribute_group-removed-in-thermal_exit.patch
gemini-wrong-registers-used-to-set-reg_level-in-gpio_set_irq_type.patch
dma-cases-ipu_pix_fmt_bgra32-bgr32-and-abgr32-are-the-same-in-ipu_ch_param_set_size.patch
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

