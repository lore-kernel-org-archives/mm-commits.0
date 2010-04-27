From: akpm@linux-foundation.org
Subject: [folded] serial-add-driver-for-the-altera-uart-update.patch removed from -mm tree
Date: Tue, 27 Apr 2010 11:39:59 -0700
Message-ID: <201004271907.o3RJ7Ocj014138@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58589 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753766Ab0D0THy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Apr 2010 15:07:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tklauser@distanz.ch, alan@lxorguk.ukuu.org.uk, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     serial-add-driver-for-the-altera-uart-update
has been removed from the -mm tree.  Its filename was
     serial-add-driver-for-the-altera-uart-update.patch

This patch was dropped because it was folded into serial-add-driver-for-the-altera-uart.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial-add-driver-for-the-altera-uart-update
From: Tobias Klauser <tklauser@distanz.ch>

- altera_uart: Remove usage of altera_uart_getppdcd, altera_uart_getppdtr,
   altera_uart_setppdtr. This makes altera_uart actually compile again (verified
   on x86_64 with Linus' master branch as of today).

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/altera_uart.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN drivers/serial/altera_uart.c~serial-add-driver-for-the-altera-uart-update drivers/serial/altera_uart.c
--- a/drivers/serial/altera_uart.c~serial-add-driver-for-the-altera-uart-update
+++ a/drivers/serial/altera_uart.c
@@ -97,8 +97,6 @@ static unsigned int altera_uart_get_mctr
 	    (readl(port->membase + ALTERA_UART_STATUS_REG) &
 	     ALTERA_UART_STATUS_CTS_MSK) ? TIOCM_CTS : 0;
 	sigs |= (pp->sigs & TIOCM_RTS);
-	sigs |= (altera_uart_getppdcd(port->line) ? TIOCM_CD : 0);
-	sigs |= (altera_uart_getppdtr(port->line) ? TIOCM_DTR : 0);
 	spin_unlock_irqrestore(&port->lock, flags);
 
 	return sigs;
@@ -111,7 +109,6 @@ static void altera_uart_set_mctrl(struct
 
 	spin_lock_irqsave(&port->lock, flags);
 	pp->sigs = sigs;
-	altera_uart_setppdtr(port->line, (sigs & TIOCM_DTR));
 	if (sigs & TIOCM_RTS)
 		pp->imr |= ALTERA_UART_CONTROL_RTS_MSK;
 	else
_

Patches currently in -mm which might be from tklauser@distanz.ch are

linux-next.patch
serial-add-driver-for-the-altera-jtag-uart.patch
serial-add-driver-for-the-altera-uart.patch
serial-add-driver-for-the-altera-uart-update.patch

