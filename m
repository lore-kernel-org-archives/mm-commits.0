From: akpm@linux-foundation.org
Subject: [merged] serial-fix-off-by-one-errors.patch removed from -mm tree
Date: Tue, 23 Jun 2009 11:05:28 -0700
Message-ID: <200906231805.n5NI5S7W009505@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54801 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753309AbZFWSF6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jun 2009 14:05:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, alan@lxorguk.ukuu.org.uk, davem@davemloft.net, macro@linux-mips.org, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     serial: fix off by one errors
has been removed from the -mm tree.  Its filename was
     serial-fix-off-by-one-errors.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial: fix off by one errors
From: Roel Kluin <roel.kluin@gmail.com>

In zs_console_putchar() occurs:

	if (zs_transmit_drain(zport, irq))
		write_zsdata(zport, ch);

However if in zs_transmit_drain() no empty Tx Buffer occurs, limit reaches
-1 => true, and the write still occurs.

This patch changes postfix to prefix decrements in this and similar
functions to prevent similar mistakes in the future.  This decreases the
iterations with one but the chosen loop count was arbitrary anyway.

In sunhv limit reaches -1, not 0, so the test is off by one.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: David S. Miller <davem@davemloft.net>
Cc: Ralf Baechle <ralf@linux-mips.org>
Acked-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/sb1250-duart.c |    6 +++---
 drivers/serial/sunhv.c        |    2 +-
 drivers/serial/zs.c           |    6 +++---
 3 files changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/serial/sb1250-duart.c~serial-fix-off-by-one-errors drivers/serial/sb1250-duart.c
--- a/drivers/serial/sb1250-duart.c~serial-fix-off-by-one-errors
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
diff -puN drivers/serial/sunhv.c~serial-fix-off-by-one-errors drivers/serial/sunhv.c
--- a/drivers/serial/sunhv.c~serial-fix-off-by-one-errors
+++ a/drivers/serial/sunhv.c
@@ -461,7 +461,7 @@ static void sunhv_console_write_paged(st
 					break;
 				udelay(1);
 			}
-			if (limit <= 0)
+			if (limit < 0)
 				break;
 			page_bytes -= written;
 			ra += written;
diff -puN drivers/serial/zs.c~serial-fix-off-by-one-errors drivers/serial/zs.c
--- a/drivers/serial/zs.c~serial-fix-off-by-one-errors
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

origin.patch
linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
ehca-enforce-a-positive-guid_entry-index.patch
usb-mutually-exclusive-port_status.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
platinumfb-misplaced-parenthesis.patch

