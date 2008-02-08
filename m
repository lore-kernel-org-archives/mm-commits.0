From: akpm@linux-foundation.org
Subject: - dz-clean-up-and-improve-the-setup-of-termios-settings.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:06:29 -0800
Message-ID: <200802080806.m1886AZH014411@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48155 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761528AbYBHIUV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:20:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: macro@linux-mips.org, alan@lxorguk.ukuu.org.uk, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     dz: clean up and improve the setup of termios settings
has been removed from the -mm tree.  Its filename was
     dz-clean-up-and-improve-the-setup-of-termios-settings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dz: clean up and improve the setup of termios settings
From: "Maciej W. Rozycki" <macro@linux-mips.org>

A set of changes to the way termios settings are propagated to the serial
port hardware.  The DZ11 only supports a selection of fixed baud settings,
so some requests may not be fulfilled.  Keep the old setting in such a case
and failing that resort to 9600bps.  Also add a missing update of the
transmit timeout.  And remove the explicit encoding of the line selected
from writes to the Line Parameters Register as it has been preencoded by
the ->set_termios() call already.  Finally, remove a duplicate macro for
the Receiver Enable bit.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/dz.c |  103 ++++++++++++++++++++++--------------------
 drivers/serial/dz.h |    4 -
 2 files changed, 56 insertions(+), 51 deletions(-)

diff -puN drivers/serial/dz.c~dz-clean-up-and-improve-the-setup-of-termios-settings drivers/serial/dz.c
--- a/drivers/serial/dz.c~dz-clean-up-and-improve-the-setup-of-termios-settings
+++ a/drivers/serial/dz.c
@@ -128,8 +128,8 @@ static void dz_stop_rx(struct uart_port 
 {
 	struct dz_port *dport = (struct dz_port *)uport;
 
-	dport->cflag &= ~DZ_CREAD;
-	dz_out(dport, DZ_LPR, dport->cflag | dport->port.line);
+	dport->cflag &= ~DZ_RXENAB;
+	dz_out(dport, DZ_LPR, dport->cflag);
 }
 
 static void dz_enable_ms(struct uart_port *port)
@@ -464,12 +464,51 @@ static void dz_break_ctl(struct uart_por
 	spin_unlock_irqrestore(&uport->lock, flags);
 }
 
+static int dz_encode_baud_rate(unsigned int baud)
+{
+	switch (baud) {
+	case 50:
+		return DZ_B50;
+	case 75:
+		return DZ_B75;
+	case 110:
+		return DZ_B110;
+	case 134:
+		return DZ_B134;
+	case 150:
+		return DZ_B150;
+	case 300:
+		return DZ_B300;
+	case 600:
+		return DZ_B600;
+	case 1200:
+		return DZ_B1200;
+	case 1800:
+		return DZ_B1800;
+	case 2000:
+		return DZ_B2000;
+	case 2400:
+		return DZ_B2400;
+	case 3600:
+		return DZ_B3600;
+	case 4800:
+		return DZ_B4800;
+	case 7200:
+		return DZ_B7200;
+	case 9600:
+		return DZ_B9600;
+	default:
+		return -1;
+	}
+}
+
 static void dz_set_termios(struct uart_port *uport, struct ktermios *termios,
 			   struct ktermios *old_termios)
 {
 	struct dz_port *dport = (struct dz_port *)uport;
 	unsigned long flags;
 	unsigned int cflag, baud;
+	int bflag;
 
 	cflag = dport->port.line;
 
@@ -496,60 +535,26 @@ static void dz_set_termios(struct uart_p
 		cflag |= DZ_PARODD;
 
 	baud = uart_get_baud_rate(uport, termios, old_termios, 50, 9600);
-	switch (baud) {
-	case 50:
-		cflag |= DZ_B50;
-		break;
-	case 75:
-		cflag |= DZ_B75;
-		break;
-	case 110:
-		cflag |= DZ_B110;
-		break;
-	case 134:
-		cflag |= DZ_B134;
-		break;
-	case 150:
-		cflag |= DZ_B150;
-		break;
-	case 300:
-		cflag |= DZ_B300;
-		break;
-	case 600:
-		cflag |= DZ_B600;
-		break;
-	case 1200:
-		cflag |= DZ_B1200;
-		break;
-	case 1800:
-		cflag |= DZ_B1800;
-		break;
-	case 2000:
-		cflag |= DZ_B2000;
-		break;
-	case 2400:
-		cflag |= DZ_B2400;
-		break;
-	case 3600:
-		cflag |= DZ_B3600;
-		break;
-	case 4800:
-		cflag |= DZ_B4800;
-		break;
-	case 7200:
-		cflag |= DZ_B7200;
-		break;
-	case 9600:
-	default:
-		cflag |= DZ_B9600;
+	bflag = dz_encode_baud_rate(baud);
+	if (bflag < 0)	{			/* Try to keep unchanged.  */
+		baud = uart_get_baud_rate(uport, old_termios, NULL, 50, 9600);
+		bflag = dz_encode_baud_rate(baud);
+		if (bflag < 0)	{		/* Resort to 9600.  */
+			baud = 9600;
+			bflag = DZ_B9600;
+		}
+		tty_termios_encode_baud_rate(termios, baud, baud);
 	}
+	cflag |= bflag;
 
 	if (termios->c_cflag & CREAD)
 		cflag |= DZ_RXENAB;
 
 	spin_lock_irqsave(&dport->port.lock, flags);
 
-	dz_out(dport, DZ_LPR, cflag | dport->port.line);
+	uart_update_timeout(uport, termios->c_cflag, baud);
+
+	dz_out(dport, DZ_LPR, cflag);
 	dport->cflag = cflag;
 
 	/* setup accept flag */
diff -puN drivers/serial/dz.h~dz-clean-up-and-improve-the-setup-of-termios-settings drivers/serial/dz.h
--- a/drivers/serial/dz.h~dz-clean-up-and-improve-the-setup-of-termios-settings
+++ a/drivers/serial/dz.h
@@ -109,8 +109,8 @@
 #define DZ_B7200         0x0D00
 #define DZ_B9600         0x0E00
 
-#define DZ_CREAD         0x1000               /* Enable receiver */
-#define DZ_RXENAB        0x1000               /* enable receive char */
+#define DZ_RXENAB        0x1000               /* Receiver Enable */
+
 /*
  * Addresses for the DZ registers
  */
_

Patches currently in -mm which might be from macro@linux-mips.org are

origin.patch
