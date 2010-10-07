From: akpm@linux-foundation.org
Subject: + arm-imx-serial-driver-fix-resume.patch added to -mm tree
Date: Thu, 07 Oct 2010 15:56:20 -0700
Message-ID: <201010072256.o97MuKxi029346@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53006 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750992Ab0JGW45 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Oct 2010 18:56:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: volker.ernst@txtr.com, andy@warmcat.com, daniel@caiaq.de, greg@kroah.com, s.hauer@pengutronix.de


The patch titled
     ARM: imx serial driver: fix resume
has been added to the -mm tree.  Its filename is
     arm-imx-serial-driver-fix-resume.patch

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
Subject: ARM: imx serial driver: fix resume
From: Volker Ernst <volker.ernst@txtr.com>

I just came across a bug in the IMX31 serial driver which is still present
in the newest kernels and which prevents successful resume-operation for
the IMX31 serial ports.

What happens is that in "drivers/serial/imx.c" on resume function
"serial_imx_resume" gets called.  This function in turn calls
"uart_resume_port" (in the generic serial driver "serial_core.c"), which
in turn calls "imx_start_tx" in "imx.c" (in case the SIO-port was really
suspended) which in turn calls "imx_transmit_buffer".

However calling "imx_transmit_buffer" with an empty TX-fifo (as is usually
the case) will result in the serial port starting to transmit (actually
the old [already sent] tx-buffer), as there is no check if the tx-buffer
is empty before starting to feed tx-fifo-data to the serial port hardware.

Signed-off-by: Volker Ernst <volker.ernst@txtr.com>
Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Andy Green <andy@warmcat.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/imx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/serial/imx.c~arm-imx-serial-driver-fix-resume drivers/serial/imx.c
--- a/drivers/serial/imx.c~arm-imx-serial-driver-fix-resume
+++ a/drivers/serial/imx.c
@@ -328,13 +328,13 @@ static inline void imx_transmit_buffer(s
 	struct circ_buf *xmit = &sport->port.state->xmit;
 
 	while (!(readl(sport->port.membase + UTS) & UTS_TXFULL)) {
+		if (uart_circ_empty(xmit))
+			break;
 		/* send xmit->buf[xmit->tail]
 		 * out the port here */
 		writel(xmit->buf[xmit->tail], sport->port.membase + URTX0);
 		xmit->tail = (xmit->tail + 1) & (UART_XMIT_SIZE - 1);
 		sport->port.icount.tx++;
-		if (uart_circ_empty(xmit))
-			break;
 	}
 
 	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
_

Patches currently in -mm which might be from volker.ernst@txtr.com are

arm-imx-serial-driver-fix-resume.patch

