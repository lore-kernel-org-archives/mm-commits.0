From: akpm@linux-foundation.org
Subject: [alternative-merged] serial-z85c30-bcm1480-loops-reach-1.patch removed from -mm tree
Date: Thu, 04 Jun 2009 15:23:43 -0700
Message-ID: <200906042223.n54MNird031818@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46863 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751308AbZFDWX5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Jun 2009 18:23:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, alan@lxorguk.ukuu.org.uk, macro@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     serial: Z85C30: BCM1480: loops reach -1
has been removed from the -mm tree.  Its filename was
     serial-z85c30-bcm1480-loops-reach-1.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial: Z85C30: BCM1480: loops reach -1
From: Roel Kluin <roel.kluin@gmail.com>

With a postfix decrement 'loops' reaches -1, which is subsequently
returned.  In drivers/serial/zs.c, line 1137 it is considered as a boolean
with 0 as failure:

if (zs_transmit_drain(zport, irq))
                write_zsdata(zport, ch);

so to use it as such loops should end at 0 after the loop rather than -1.
This also fixes similar loops in other functions.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/sb1250-duart.c |    6 +++---
 drivers/serial/zs.c           |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/serial/sb1250-duart.c~serial-z85c30-bcm1480-loops-reach-1 drivers/serial/sb1250-duart.c
--- a/drivers/serial/sb1250-duart.c~serial-z85c30-bcm1480-loops-reach-1
+++ a/drivers/serial/sb1250-duart.c
@@ -204,7 +204,7 @@ static int sbd_receive_drain(struct sbd_
 {
 	int loops = 10000;
 
-	while (sbd_receive_ready(sport) && loops--)
+	while (sbd_receive_ready(sport) && --loops)
 		read_sbdchn(sport, R_DUART_RX_HOLD);
 	return loops;
 }
@@ -218,7 +218,7 @@ static int __maybe_unused sbd_transmit_d
 {
 	int loops = 10000;
 
-	while (!sbd_transmit_ready(sport) && loops--)
+	while (!sbd_transmit_ready(sport) && --loops)
 		udelay(2);
 	return loops;
 }
@@ -232,7 +232,7 @@ static int sbd_line_drain(struct sbd_por
 {
 	int loops = 10000;
 
-	while (!sbd_transmit_empty(sport) && loops--)
+	while (!sbd_transmit_empty(sport) && --loops)
 		udelay(2);
 	return loops;
 }
diff -puN drivers/serial/zs.c~serial-z85c30-bcm1480-loops-reach-1 drivers/serial/zs.c
--- a/drivers/serial/zs.c~serial-z85c30-bcm1480-loops-reach-1
+++ a/drivers/serial/zs.c
@@ -231,7 +231,7 @@ static int zs_receive_drain(struct zs_po
 {
 	int loops = 10000;
 
-	while ((read_zsreg(zport, R0) & Rx_CH_AV) && loops--)
+	while ((read_zsreg(zport, R0) & Rx_CH_AV) && --loops)
 		read_zsdata(zport);
 	return loops;
 }
@@ -241,7 +241,7 @@ static int zs_transmit_drain(struct zs_p
 	struct zs_scc *scc = zport->scc;
 	int loops = 10000;
 
-	while (!(read_zsreg(zport, R0) & Tx_BUF_EMP) && loops--) {
+	while (!(read_zsreg(zport, R0) & Tx_BUF_EMP) && --loops) {
 		zs_spin_unlock_cond_irq(&scc->zlock, irq);
 		udelay(2);
 		zs_spin_lock_cond_irq(&scc->zlock, irq);
@@ -254,7 +254,7 @@ static int zs_line_drain(struct zs_port 
 	struct zs_scc *scc = zport->scc;
 	int loops = 10000;
 
-	while (!(read_zsreg(zport, R1) & ALL_SNT) && loops--) {
+	while (!(read_zsreg(zport, R1) & ALL_SNT) && --loops) {
 		zs_spin_unlock_cond_irq(&scc->zlock, irq);
 		udelay(2);
 		zs_spin_lock_cond_irq(&scc->zlock, irq);
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
drm-fix-lock_test_with_return-macro.patch
irda-count-reaches-1.patch
drivers-isdn-i4l-isdn_ttyc-fix-check-for-array-overindexing.patch
atl1c-wake_mcast-tested-twice-not-wake_ucast.patch
scsi-ncr53c8xx-div-reaches-1.patch
scsi-pcmcia-nsp_cs-time_out-reaches-1.patch
lguest-fix-array-indexing-check.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
alpha-bad-macro-expansion-parameter-is-member.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
uml-bad-macro-expansion-parameter-is-member.patch
serial-fix-off-by-one-errors.patch
serial-z85c30-bcm1480-loops-reach-1.patch
spi_bfin5xx-limit-reaches-1.patch
carminefb-fix-possible-access-beyond-end-of-carmine_modedb.patch
radeon-p2g2clk_always_onb-tested-twice-should-2nd-be-p2g2clk_dac_always_onb.patch
radeon-p2g2clk_always_onb-tested-twice-should-2nd-be-p2g2clk_dac_always_onb-fix.patch
platinumfb-misplaced-parenthesis.patch
ufs-sector_t-cannot-be-negative.patch
dtlk-off-by-one-in-readwrite_tts.patch

