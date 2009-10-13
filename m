From: akpm@linux-foundation.org
Subject: + fbdev-tv_paln-bit-set-twice-in-sisfb_detect_vb_connect.patch added to -mm tree
Date: Tue, 13 Oct 2009 16:35:06 -0700
Message-ID: <200910132335.n9DNZ675019276@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44263 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759957AbZJMXfu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Oct 2009 19:35:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, krzysztof.h1@poczta.fm, thomas@winischhofer.net


The patch titled
     fbdev: TV_PALN bit set twice in sisfb_detect_VB_connect()
has been added to the -mm tree.  Its filename is
     fbdev-tv_paln-bit-set-twice-in-sisfb_detect_vb_connect.patch

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
Subject: fbdev: TV_PALN bit set twice in sisfb_detect_VB_connect()
From: Roel Kluin <roel.kluin@gmail.com>

The TV_PALN bit was tested twice, replace one by TV_PALM.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Thomas Winischhofer <thomas@winischhofer.net>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/video/sis/sis_main.c~fbdev-tv_paln-bit-set-twice-in-sisfb_detect_vb_connect drivers/video/sis/sis_main.c
--- a/drivers/video/sis/sis_main.c~fbdev-tv_paln-bit-set-twice-in-sisfb_detect_vb_connect
+++ a/drivers/video/sis/sis_main.c
@@ -2115,7 +2115,7 @@ sisfb_detect_VB_connect(struct sis_video
 	   if( (!(ivideo->vbflags2 & VB2_SISBRIDGE)) &&
 	       (!((ivideo->sisvga_engine == SIS_315_VGA) &&
 			(ivideo->vbflags2 & VB2_CHRONTEL))) ) {
-	      if(ivideo->sisfb_tvstd & (TV_PALN | TV_PALN | TV_NTSCJ)) {
+	      if(ivideo->sisfb_tvstd & (TV_PALM | TV_PALN | TV_NTSCJ)) {
 		 ivideo->sisfb_tvstd = -1;
 		 printk(KERN_ERR "sisfb: PALM/PALN/NTSCJ not supported\n");
 	      }
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
fujitsu-laptop-fix-tests-of-acpi_evaluate_integer-return.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
sn-unsigned-cannot-be-less-than-0-in-sn_hwperf_ioctl.patch
hfc_usb-fix-read-buffer-overflow.patch
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
drivers-staging-octeon-ethernet-rgmiic-dont-ignore-request_irq-return-code.patch
page-types-unsigned-cannot-be-less-than-0-in-add_page.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
cryptocop-fix-assertion-in-create_output_descriptors.patch
gpio-fix-test-on-unsigned-in-lnw_irq_type.patch
fbdev-tv_paln-bit-set-twice-in-sisfb_detect_vb_connect.patch

