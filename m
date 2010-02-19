From: akpm@linux-foundation.org
Subject: + dvb-usb-opera1-misplaced-parenthesis.patch added to -mm tree
Date: Fri, 19 Feb 2010 13:18:56 -0800
Message-ID: <201002192118.o1JLIup7004840@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45361 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751417Ab0BSVTG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Feb 2010 16:19:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, mchehab@infradead.org


The patch titled
     dvb-usb/opera1: misplaced parenthesis
has been added to the -mm tree.  Its filename is
     dvb-usb-opera1-misplaced-parenthesis.patch

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
Subject: dvb-usb/opera1: misplaced parenthesis
From: Roel Kluin <roel.kluin@gmail.com>

The parenthesis was misplaced, tmp is set to 0 or break occurs,
while debugging opera1_usb_i2c_msgxfer() retval was not shown.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/dvb-usb/opera1.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/dvb/dvb-usb/opera1.c~dvb-usb-opera1-misplaced-parenthesis drivers/media/dvb/dvb-usb/opera1.c
--- a/drivers/media/dvb/dvb-usb/opera1.c~dvb-usb-opera1-misplaced-parenthesis
+++ a/drivers/media/dvb/dvb-usb/opera1.c
@@ -138,7 +138,7 @@ static int opera1_i2c_xfer(struct i2c_ad
 					(msg[i].addr<<1)|(msg[i].flags&I2C_M_RD?0x01:0),
 					msg[i].buf,
 					msg[i].len
-					)!= msg[i].len)) {
+					)) != msg[i].len) {
 			break;
 		}
 		if (dvb_usb_opera1_debug & 0x10)
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
gemini-wrong-registers-used-to-set-reg_level-in-gpio_set_irq_type.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
dvb-usb-opera1-misplaced-parenthesis.patch
ia64-wrong-attribute-of-hub-chip-written-in-uv_setup.patch
mtd-hot-spin-and-code-duplication-in-nand_bcm_umi_bch_read_oobecc.patch
mtd-change-positive-error-return-into-negative-in-mtd_do_writeoob.patch
score-fix-dereference-of-null-pointer-in-local_flush_tlb_page.patch
isdn-misplaced-parenthesis-in-pof_handle_data.patch
obsolete-config-in-kernel-source-use_internal_timer.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
gdth-unmap-ccb_phys-when-scsi_add_host-fails-in-gdth_eisa_probe_one.patch
ncr5380-bit-mr_dma_mode-set-twice-in-ncr5380_transfer_dma.patch
scsi-pmcraid-redundant-check-in-pmcraid_check_ioctl_buffer.patch
dc395x-decrease-iteration-for-tag_number-of-max_command-in-start_scsi.patch
mpt2sas-fix-confusion-in-_scsih_sas_device_status_change_event.patch
lpfc-positive-error-return-into-negative.patch
scsi-bfa-correct-onstack-wait_queue_head-declaration.patch
paride-fix-off-by-one-test.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
alpha-ptr_err-overwrites-einval-in-syscall-osf_mount.patch
cryptocop-fix-assertion-in-create_output_descriptors.patch
cris-v32-typo-in-crisv32_arbiter_unwatch.patch
asiliantfb-fix-test-of-unsigned-in-asiliant_calc_dclk2.patch
w1-fix-test-in-ds2482_wait_1wire_idle.patch

