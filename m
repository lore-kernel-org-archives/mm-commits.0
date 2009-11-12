From: akpm@linux-foundation.org
Subject: + sms-cards-make-id-unsigned-in-sms_get_board.patch added to -mm tree
Date: Thu, 12 Nov 2009 15:13:23 -0800
Message-ID: <200911122313.nACNDNBh020525@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56321 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754922AbZKLXN1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Nov 2009 18:13:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, mchehab@infradead.org, mkrufky@kernellabs.com


The patch titled
     sms-cards: make id unsigned in sms_get_board()
has been added to the -mm tree.  Its filename is
     sms-cards-make-id-unsigned-in-sms_get_board.patch

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
Subject: sms-cards: make id unsigned in sms_get_board()
From: Roel Kluin <roel.kluin@gmail.com>

Make id signed so we can't get an invalid pointer when we pass a negative
id.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Michael Krufky <mkrufky@kernellabs.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/siano/sms-cards.c |    2 +-
 drivers/media/dvb/siano/sms-cards.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/media/dvb/siano/sms-cards.c~sms-cards-make-id-unsigned-in-sms_get_board drivers/media/dvb/siano/sms-cards.c
--- a/drivers/media/dvb/siano/sms-cards.c~sms-cards-make-id-unsigned-in-sms_get_board
+++ a/drivers/media/dvb/siano/sms-cards.c
@@ -97,7 +97,7 @@ static struct sms_board sms_boards[] = {
 	},
 };
 
-struct sms_board *sms_get_board(int id)
+struct sms_board *sms_get_board(unsigned id)
 {
 	BUG_ON(id >= ARRAY_SIZE(sms_boards));
 
diff -puN drivers/media/dvb/siano/sms-cards.h~sms-cards-make-id-unsigned-in-sms_get_board drivers/media/dvb/siano/sms-cards.h
--- a/drivers/media/dvb/siano/sms-cards.h~sms-cards-make-id-unsigned-in-sms_get_board
+++ a/drivers/media/dvb/siano/sms-cards.h
@@ -81,7 +81,7 @@ struct sms_board {
 	int led_power, led_hi, led_lo, lna_ctrl, rf_switch;
 };
 
-struct sms_board *sms_get_board(int id);
+struct sms_board *sms_get_board(unsigned id);
 
 extern struct smscore_device_t *coredev;
 
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
get_maintainer-fix-usage-comment.patch
linux-next.patch
fujitsu-laptop-fix-tests-of-acpi_evaluate_integer-return.patch
omap-fix-unlikelyx-y.patch
omap-cs-should-be-positive-in-gpmc_cs_free.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
sms-cards-make-id-unsigned-in-sms_get_board.patch
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

