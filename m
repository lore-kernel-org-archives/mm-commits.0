From: akpm@linux-foundation.org
Subject: + asoc-wrong-variable-returned-on-error.patch added to -mm tree
Date: Tue, 08 Dec 2009 15:02:35 -0800
Message-ID: <200912082302.nB8N2ZQP012190@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41099 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966910AbZLHXCj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Dec 2009 18:02:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, lrg@slimlogic.co.uk, tiwai@suse.de


The patch titled
     ASoC: wrong variable returned on error
has been added to the -mm tree.  Its filename is
     asoc-wrong-variable-returned-on-error.patch

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
Subject: ASoC: wrong variable returned on error
From: Roel Kluin <roel.kluin@gmail.com>

The wrong variable was returned in the case of an error

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/soc/imx/mx1_mx2-pcm.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN sound/soc/imx/mx1_mx2-pcm.c~asoc-wrong-variable-returned-on-error sound/soc/imx/mx1_mx2-pcm.c
--- a/sound/soc/imx/mx1_mx2-pcm.c~asoc-wrong-variable-returned-on-error
+++ a/sound/soc/imx/mx1_mx2-pcm.c
@@ -322,12 +322,12 @@ static int mx1_mx2_pcm_open(struct snd_p
 
 	pr_debug("%s: Requesting dma channel (%s)\n", __func__,
 						prtd->dma_params->name);
-	prtd->dma_ch = imx_dma_request_by_prio(prtd->dma_params->name,
-						DMA_PRIO_HIGH);
-	if (prtd->dma_ch < 0) {
+	ret = imx_dma_request_by_prio(prtd->dma_params->name, DMA_PRIO_HIGH);
+	if (ret < 0) {
 		printk(KERN_ERR "Error %d requesting dma channel\n", ret);
 		return ret;
 	}
+	prtd->dma_ch = ret;
 	imx_dma_config_burstlen(prtd->dma_ch,
 				prtd->dma_params->watermark_level);
 
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
fujitsu-laptop-fix-tests-of-acpi_evaluate_integer-return.patch
asoc-wrong-variable-returned-on-error.patch
omap-return-ptr_err-rather-than-is_err.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
powerpc-85xx-wrong-variable-returned-on-error.patch
ib-uverbs-ptr_err-return-of-wrong-pointer-in-ib_uverbs_get_context.patch
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
wusb-use-sizeof-struct-rather-than-pointer.patch
page-types-unsigned-cannot-be-less-than-0-in-add_page.patch
keys-ptr_err-return-of-wrong-pointer-in-keyctl_get_security.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
cryptocop-fix-assertion-in-create_output_descriptors.patch
gpio-fix-test-on-unsigned-in-lnw_irq_type.patch
fbdev-tv_paln-bit-set-twice-in-sisfb_detect_vb_connect.patch
hvc_console-fix-test-on-unsigned-in-hvc_console_print.patch
zlib-optimize-inffast-when-copying-direct-from-output.patch

