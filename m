From: akpm@linux-foundation.org
Subject: + scsi-pcmcia-nsp_cs-time_out-reaches-1.patch added to -mm tree
Date: Thu, 26 Feb 2009 14:01:41 -0800
Message-ID: <200902262201.n1QM1fVr026753@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56226 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752301AbZBZWJw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Feb 2009 17:09:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, James.Bottomley@HansenPartnership.com


The patch titled
     scsi/pcmcia/nsp_cs: time_out reaches -1
has been added to the -mm tree.  Its filename is
     scsi-pcmcia-nsp_cs-time_out-reaches-1.patch

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
acpi-get_throttling_state-cannot-be-larger-state_count.patch
drm-fix-lock_test_with_return-macro.patch
dvb-negative-internal-sub_range-wont-get-noticed.patch
scsi-ncr53c8xx-div-reaches-1.patch
scsi-pcmcia-nsp_cs-time_out-reaches-1.patch
mm-get_nid_for_pfn-returns-int.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
alpha-fix-macros.patch
m68k-count-can-reach-51-not-50.patch
m68k-count-can-reach-51-not-50-checkpatch-fixes.patch
spi-limit-reaches-1-tested-0.patch
rtc-wm8350-retries-will-reach-1.patch
fbdev-newport-newport_wait-return-0-on-timeout.patch
drivers-video-omap-hwa742c-div-reaches-max_clk_div.patch
arkfb-fix-misplaced-parentheses.patch
uvesafb-bitwise-or-has-higher-precedence-than.patch
vesafb-bitwise-or-has-higher-precedence-than.patch
viafb-returns-0-two-too-early.patch
ufs-sector_t-cannot-be-negative.patch
rio-addition-has-higher-precedence-than.patch

