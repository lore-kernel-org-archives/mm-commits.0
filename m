From: akpm@linux-foundation.org
Subject: [merged] scsi-pcmcia-nsp_cs-time_out-reaches-1.patch removed from -mm tree
Date: Tue, 16 Jun 2009 11:27:54 -0700
Message-ID: <200906161827.n5GIRspj028269@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57253 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755191AbZFPS1y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Jun 2009 14:27:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, James.Bottomley@HansenPartnership.com, mm-commits@vger.kernel.org


The patch titled
     scsi/pcmcia/nsp_cs: time_out reaches -1
has been removed from the -mm tree.  Its filename was
     scsi-pcmcia-nsp_cs-time_out-reaches-1.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scsi/pcmcia/nsp_cs: time_out reaches -1
From: Roel Kluin <roel.kluin@gmail.com>

With a postfix decrement timeouts will reach -1 rather than 0, so the
errors do not appear.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/pcmcia/nsp_cs.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/pcmcia/nsp_cs.c~scsi-pcmcia-nsp_cs-time_out-reaches-1 drivers/scsi/pcmcia/nsp_cs.c
--- a/drivers/scsi/pcmcia/nsp_cs.c~scsi-pcmcia-nsp_cs-time_out-reaches-1
+++ a/drivers/scsi/pcmcia/nsp_cs.c
@@ -530,7 +530,7 @@ static int nsp_negate_signal(struct scsi
 		if (reg == 0xff) {
 			break;
 		}
-	} while ((time_out-- != 0) && (reg & mask) != 0);
+	} while ((--time_out != 0) && (reg & mask) != 0);
 
 	if (time_out == 0) {
 		nsp_msg(KERN_DEBUG, " %s signal off timeut", str);
@@ -801,7 +801,7 @@ static void nsp_pio_read(struct scsi_cmn
 
 	data->FifoCount = ocount;
 
-	if (time_out == 0) {
+	if (time_out < 0) {
 		nsp_msg(KERN_DEBUG, "pio read timeout resid=%d this_residual=%d buffers_residual=%d",
 			scsi_get_resid(SCpnt), SCpnt->SCp.this_residual,
 			SCpnt->SCp.buffers_residual);
@@ -897,7 +897,7 @@ static void nsp_pio_write(struct scsi_cm
 
 	data->FifoCount = ocount;
 
-	if (time_out == 0) {
+	if (time_out < 0) {
 		nsp_msg(KERN_DEBUG, "pio write timeout resid=0x%x",
 		                                        scsi_get_resid(SCpnt));
 	}
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
serial-fix-off-by-one-errors.patch
usb-mutually-exclusive-port_status.patch
spi-size-of-a-pointer-to-determine-the-size-of-the-pointed-to-type.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
alpha-bad-macro-expansion-parameter-is-member.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
uml-bad-macro-expansion-parameter-is-member.patch
spi_bfin5xx-limit-reaches-1.patch
carminefb-fix-possible-access-beyond-end-of-carmine_modedb.patch
radeon-p2g2clk_always_onb-tested-twice-should-2nd-be-p2g2clk_dac_always_onb.patch
radeon-p2g2clk_always_onb-tested-twice-should-2nd-be-p2g2clk_dac_always_onb-fix.patch
platinumfb-misplaced-parenthesis.patch
ufs-sector_t-cannot-be-negative.patch
dtlk-off-by-one-in-readwrite_tts.patch

