From: akpm@linux-foundation.org
Subject: + v4l-dvb-mxl5007tc-fix-test-in-copy_reg_bits.patch added to -mm tree
Date: Mon, 23 Nov 2009 15:13:10 -0800
Message-ID: <200911232313.nANNDAdA021208@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37105 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756786AbZKWXOf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Nov 2009 18:14:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, mchehab@infradead.org, mkrufky@linuxtv.org, stable@kernel.org


The patch titled
     v4l/dvb: mxl5007t.c: fix test in copy_reg_bits()
has been added to the -mm tree.  Its filename is
     v4l-dvb-mxl5007tc-fix-test-in-copy_reg_bits.patch

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
Subject: v4l/dvb: mxl5007t.c: fix test in copy_reg_bits()
From: Roel Kluin <roel.kluin@gmail.com>

The reg_pair2[j].reg was tested twice.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: Michael Krufky <mkrufky@linuxtv.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/common/tuners/mxl5007t.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/common/tuners/mxl5007t.c~v4l-dvb-mxl5007tc-fix-test-in-copy_reg_bits drivers/media/common/tuners/mxl5007t.c
--- a/drivers/media/common/tuners/mxl5007t.c~v4l-dvb-mxl5007tc-fix-test-in-copy_reg_bits
+++ a/drivers/media/common/tuners/mxl5007t.c
@@ -196,7 +196,7 @@ static void copy_reg_bits(struct reg_pai
 	i = j = 0;
 
 	while (reg_pair1[i].reg || reg_pair1[i].val) {
-		while (reg_pair2[j].reg || reg_pair2[j].reg) {
+		while (reg_pair2[j].reg || reg_pair2[j].val) {
 			if (reg_pair1[i].reg != reg_pair2[j].reg) {
 				j++;
 				continue;
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
v4l-dvb-mxl5007tc-fix-test-in-copy_reg_bits.patch
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

