From: akpm@linux-foundation.org
Subject: - serial_txx9-fix-modem-control-line-handling.patch removed from -mm tree
Date: Fri, 24 Aug 2007 13:55:31 -0700
Message-ID: <200708242055.l7OKtVvk013966@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44109 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761899AbXHXVBB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 17:01:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anemo@mba.ocn.ne.jp, alan@lxorguk.ukuu.org.uk, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     serial_txx9: Fix modem control line handling
has been removed from the -mm tree.  Its filename was
     serial_txx9-fix-modem-control-line-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: serial_txx9: Fix modem control line handling
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

This chip does not have modem control lines.  Return TIOCM_CAR and
TIOCM_DSR always on get_mctrl() and ajust some bits in termios cflag.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Ralf Baechle <ralf@linux-mips.org>
Acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/serial_txx9.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff -puN drivers/serial/serial_txx9.c~serial_txx9-fix-modem-control-line-handling drivers/serial/serial_txx9.c
--- a/drivers/serial/serial_txx9.c~serial_txx9-fix-modem-control-line-handling
+++ a/drivers/serial/serial_txx9.c
@@ -37,7 +37,7 @@
 
 #include <asm/io.h>
 
-static char *serial_version = "1.09";
+static char *serial_version = "1.10";
 static char *serial_name = "TX39/49 Serial driver";
 
 #define PASS_LIMIT	256
@@ -436,8 +436,10 @@ static unsigned int serial_txx9_get_mctr
 	struct uart_txx9_port *up = (struct uart_txx9_port *)port;
 	unsigned int ret;
 
-	ret =  ((sio_in(up, TXX9_SIFLCR) & TXX9_SIFLCR_RTSSC) ? 0 : TIOCM_RTS)
-		| ((sio_in(up, TXX9_SICISR) & TXX9_SICISR_CTSS) ? 0 : TIOCM_CTS);
+	/* no modem control lines */
+	ret = TIOCM_CAR | TIOCM_DSR;
+	ret |= (sio_in(up, TXX9_SIFLCR) & TXX9_SIFLCR_RTSSC) ? 0 : TIOCM_RTS;
+	ret |= (sio_in(up, TXX9_SICISR) & TXX9_SICISR_CTSS) ? 0 : TIOCM_CTS;
 
 	return ret;
 }
@@ -557,6 +559,12 @@ serial_txx9_set_termios(struct uart_port
 	unsigned long flags;
 	unsigned int baud, quot;
 
+	/*
+	 * We don't support modem control lines.
+	 */
+	termios->c_cflag &= ~(HUPCL | CMSPAR);
+	termios->c_cflag |= CLOCAL;
+
 	cval = sio_in(up, TXX9_SILCR);
 	/* byte size and parity */
 	cval &= ~TXX9_SILCR_UMODE_MASK;
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

origin.patch
spi-driver-hotplug-coldplug-fixes-fix.patch
serial_txx9-cleanup-includes.patch
