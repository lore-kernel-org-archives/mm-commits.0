From: akpm@linux-foundation.org
Subject: + serial-serial_txx9-driver-update-fix.patch added to -mm tree
Date: Wed, 21 Feb 2007 17:07:45 -0800
Message-ID: <200702220107.l1M17jr4032411@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60840 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965010AbXBVBLM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 20:11:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anemo@mba.ocn.ne.jp, alan@lxorguk.ukuu.org.uk, ralf@linux-mips.org, rmk@arm.linux.org.uk


The patch titled
     serial: serial_txx9 driver update (fix)
has been added to the -mm tree.  Its filename is
     serial-serial_txx9-driver-update-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: serial: serial_txx9 driver update (fix)
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/serial_txx9.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff -puN drivers/serial/serial_txx9.c~serial-serial_txx9-driver-update-fix drivers/serial/serial_txx9.c
--- a/drivers/serial/serial_txx9.c~serial-serial_txx9-driver-update-fix
+++ a/drivers/serial/serial_txx9.c
@@ -277,16 +277,15 @@ static void serial_txx9_enable_ms(struct
 static void serial_txx9_initialize(struct uart_port *port)
 {
 	struct uart_txx9_port *up = (struct uart_txx9_port *)port;
+	unsigned int tmout = 10000;
 
 	sio_out(up, TXX9_SIFCR, TXX9_SIFCR_SWRST);
-#ifdef CONFIG_CPU_TX49XX
 	/* TX4925 BUG WORKAROUND.  Accessing SIOC register
 	 * immediately after soft reset causes bus error. */
-	iob();
+	mmiowb();
 	udelay(1);
-#endif
-	while (sio_in(up, TXX9_SIFCR) & TXX9_SIFCR_SWRST)
-		;
+	while ((sio_in(up, TXX9_SIFCR) & TXX9_SIFCR_SWRST) && --tmout)
+		udelay(1);
 	/* TX Int by FIFO Empty, RX Int by Receiving 1 char. */
 	sio_set(up, TXX9_SIFCR,
 		TXX9_SIFCR_TDIL_MAX | TXX9_SIFCR_RDIL_1);
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

git-mips.patch
serial-serial_txx9-driver-update.patch
serial-serial_txx9-driver-update-fix.patch
