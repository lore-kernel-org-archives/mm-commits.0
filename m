From: akpm@linux-foundation.org
Subject: [merged] irda-count-reaches-1.patch removed from -mm tree
Date: Tue, 09 Jun 2009 11:12:21 -0700
Message-ID: <200906091812.n59ICLC4018593@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37187 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758825AbZFISMi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jun 2009 14:12:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, samuel@sortiz.org, mm-commits@vger.kernel.org


The patch titled
     irda: count reaches -1
has been removed from the -mm tree.  Its filename was
     irda-count-reaches-1.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: irda: count reaches -1
From: Roel Kluin <roel.kluin@gmail.com>

Count reaches -1 rather than 0,

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Samuel Ortiz <samuel@sortiz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/irda/smsc-ircc2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/irda/smsc-ircc2.c~irda-count-reaches-1 drivers/net/irda/smsc-ircc2.c
--- a/drivers/net/irda/smsc-ircc2.c~irda-count-reaches-1
+++ a/drivers/net/irda/smsc-ircc2.c
@@ -2124,7 +2124,7 @@ static void smsc_ircc_sir_wait_hw_transm
 	while (count-- > 0 && !(inb(iobase + UART_LSR) & UART_LSR_TEMT))
 		udelay(1);
 
-	if (count == 0)
+	if (count < 0)
 		IRDA_DEBUG(0, "%s(): stuck transmitter\n", __func__);
 }
 
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
drm-fix-lock_test_with_return-macro.patch
tvp514x-try_count-off-by-one.patch
drivers-isdn-i4l-isdn_ttyc-fix-check-for-array-overindexing.patch
atl1c-wake_mcast-tested-twice-not-wake_ucast.patch
scsi-ncr53c8xx-div-reaches-1.patch
scsi-pcmcia-nsp_cs-time_out-reaches-1.patch
spi-size-of-a-pointer-to-determine-the-size-of-the-pointed-to-type.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
alpha-bad-macro-expansion-parameter-is-member.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
uml-bad-macro-expansion-parameter-is-member.patch
serial-fix-off-by-one-errors.patch
spi_bfin5xx-limit-reaches-1.patch
carminefb-fix-possible-access-beyond-end-of-carmine_modedb.patch
radeon-p2g2clk_always_onb-tested-twice-should-2nd-be-p2g2clk_dac_always_onb.patch
radeon-p2g2clk_always_onb-tested-twice-should-2nd-be-p2g2clk_dac_always_onb-fix.patch
platinumfb-misplaced-parenthesis.patch
ufs-sector_t-cannot-be-negative.patch
dtlk-off-by-one-in-readwrite_tts.patch

