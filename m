From: akpm@linux-foundation.org
Subject: + atmel_serial-fix-rts-high-after-initialization-in-rs485-mode.patch added to -mm tree
Date: Mon, 25 Oct 2010 15:54:32 -0700
Message-ID: <201010252254.o9PMsW6a021074@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48268 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752049Ab0JYWyk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Oct 2010 18:54:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: claudio@evidence.eu.com, arkadiusz.bubala@gmail.com, greg@kroah.com, nicolas.ferre@atmel.com


The patch titled
     atmel_serial: fix RTS high after initialization in RS485 mode
has been added to the -mm tree.  Its filename is
     atmel_serial-fix-rts-high-after-initialization-in-rs485-mode.patch

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
Subject: atmel_serial: fix RTS high after initialization in RS485 mode
From: Claudio Scordino <claudio@evidence.eu.com>

When working in RS485 mode, the atmel_serial driver keeps RTS high after
the initialization of the serial port.  It goes low only after the first
character has been sent.

Signed-off-by: Claudio Scordino <claudio@evidence.eu.com>
Signed-off-by: Arkadiusz Bubala <arkadiusz.bubala@gmail.com>
Tested-by: Arkadiusz Bubala <arkadiusz.bubala@gmail.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/atmel_serial.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN drivers/serial/atmel_serial.c~atmel_serial-fix-rts-high-after-initialization-in-rs485-mode drivers/serial/atmel_serial.c
--- a/drivers/serial/atmel_serial.c~atmel_serial-fix-rts-high-after-initialization-in-rs485-mode
+++ a/drivers/serial/atmel_serial.c
@@ -1732,6 +1732,15 @@ static int __devinit atmel_serial_probe(
 	device_init_wakeup(&pdev->dev, 1);
 	platform_set_drvdata(pdev, port);
 
+	if (port->rs485.flags & SER_RS485_ENABLED) {
+		unsigned int control = 0;
+		unsigned int mode = 0;
+		control |= ATMEL_US_RTSEN;
+		mode |= ATMEL_US_USMODE_NORMAL;
+		UART_PUT_MR(&port->uart, mode);
+		UART_PUT_CR(&port->uart, control);
+	}
+
 	return 0;
 
 err_add_port:
_

Patches currently in -mm which might be from claudio@evidence.eu.com are

atmel_serial-fix-rts-high-after-initialization-in-rs485-mode.patch
atmel_serial-fix-rts-high-after-initialization-in-rs485-mode-fix.patch

