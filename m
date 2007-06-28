From: akpm@linux-foundation.org
Subject: + serial_txx9-fix-modem-control-line-handling.patch added to -mm tree
Date: Thu, 28 Jun 2007 15:14:06 -0700
Message-ID: <200706282214.l5SME634002675@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60482 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764912AbXF1WO1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Jun 2007 18:14:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anemo@mba.ocn.ne.jp, ralf@linux-mips.org


The patch titled
     serial_txx9: Fix modem control line handling
has been added to the -mm tree.  Its filename is
     serial_txx9-fix-modem-control-line-handling.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: serial_txx9: Fix modem control line handling
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

This chip does not have modem control lines.  Return TIOCM_CAR and
TIOCM_DSR always on get_mctrl() and ajust some bits in termios cflag.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Ralf Baechle <ralf@linux-mips.org>
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
git-kbuild.patch
git-mips.patch
mips-make-resources-for-ds1742-static-__initdata.patch
serial_txx9-fix-modem-control-line-handling.patch
serial_txx9-cleanup-includes.patch
rtc-add-rtc-m41t80-driver-take-2.patch
rtc-add-rtc-m41t80-driver-take-2-fix.patch
rtc-watchdog-support-for-rtc-m41t80-driver-take-2.patch
