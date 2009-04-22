From: akpm@linux-foundation.org
Subject: [merged] bfin_5xx-misplaced-parentheses.patch removed from -mm tree
Date: Wed, 22 Apr 2009 11:30:58 -0700
Message-ID: <200904221830.n3MIUwtr006466@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53217 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753356AbZDVSfy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Apr 2009 14:35:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, alan@lxorguk.ukuu.org.uk, cooloney@kernel.org, sonic.zhang@analog.com, mm-commits@vger.kernel.org


The patch titled
     bfin_5xx: misplaced parentheses
has been removed from the -mm tree.  Its filename was
     bfin_5xx-misplaced-parentheses.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bfin_5xx: misplaced parentheses
From: Roel Kluin <roel.kluin@gmail.com>

`!' has a higher precedence than `&', parentheses are misplaced.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Acked-by: Sonic Zhang <sonic.zhang@analog.com>
Cc: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/bfin_5xx.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/serial/bfin_5xx.c~bfin_5xx-misplaced-parentheses drivers/serial/bfin_5xx.c
--- a/drivers/serial/bfin_5xx.c~bfin_5xx-misplaced-parentheses
+++ a/drivers/serial/bfin_5xx.c
@@ -166,7 +166,7 @@ static void bfin_serial_start_tx(struct 
 	struct tty_struct *tty = uart->port.info->port.tty;
 
 #ifdef CONFIG_SERIAL_BFIN_HARD_CTSRTS
-	if (uart->scts && (!bfin_serial_get_mctrl(&uart->port)&TIOCM_CTS)) {
+	if (uart->scts && !(bfin_serial_get_mctrl(&uart->port) & TIOCM_CTS)) {
 		uart->scts = 0;
 		uart_handle_cts_change(&uart->port, uart->scts);
 	}
@@ -368,7 +368,7 @@ static irqreturn_t bfin_serial_tx_int(in
 	struct bfin_serial_port *uart = dev_id;
 
 #ifdef CONFIG_SERIAL_BFIN_HARD_CTSRTS
-	if (uart->scts && (!bfin_serial_get_mctrl(&uart->port)&TIOCM_CTS)) {
+	if (uart->scts && !(bfin_serial_get_mctrl(&uart->port) & TIOCM_CTS)) {
 		uart->scts = 0;
 		uart_handle_cts_change(&uart->port, uart->scts);
 	}
@@ -504,7 +504,7 @@ static irqreturn_t bfin_serial_dma_tx_in
 	struct circ_buf *xmit = &uart->port.info->xmit;
 
 #ifdef CONFIG_SERIAL_BFIN_HARD_CTSRTS
-	if (uart->scts && (!bfin_serial_get_mctrl(&uart->port)&TIOCM_CTS)) {
+	if (uart->scts && !(bfin_serial_get_mctrl(&uart->port)&TIOCM_CTS)) {
 		uart->scts = 0;
 		uart_handle_cts_change(&uart->port, uart->scts);
 	}
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
drm-fix-lock_test_with_return-macro.patch
pata-rb532-cf-platform_get_irq-failure-ignored.patch
microblaze-iowrite-upon-timeout.patch
uwb-event_size-should-be-signed.patch
scsi-ncr53c8xx-div-reaches-1.patch
scsi-pcmcia-nsp_cs-time_out-reaches-1.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
serial-z85c30-bcm1480-loops-reach-1.patch
spi_bfin5xx-limit-reaches-1.patch
ufs-sector_t-cannot-be-negative.patch

