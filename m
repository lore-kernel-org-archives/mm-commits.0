From: akpm@linux-foundation.org
Subject: [merged] atmel_serial-fix-rts-high-after-initialization-in-rs485-mode.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:44:14 -0800
Message-ID: <201101142247.p0EMl45C004957@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60159 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752525Ab1ANWrU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:47:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: claudio@evidence.eu.com, arkadiusz.bubala@gmail.com, greg@kroah.com, nicolas.ferre@atmel.com, mm-commits@vger.kernel.org


The patch titled
     atmel_serial: fix RTS high after initialization in RS485 mode
has been removed from the -mm tree.  Its filename was
     atmel_serial-fix-rts-high-after-initialization-in-rs485-mode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atmel_serial: fix RTS high after initialization in RS485 mode
From: Claudio Scordino <claudio@evidence.eu.com>

When working in RS485 mode, the atmel_serial driver keeps RTS high after
the initialization of the serial port.  It goes low only after the first
character has been sent.

[akpm@linux-foundation.org: simplify code]
Signed-off-by: Claudio Scordino <claudio@evidence.eu.com>
Signed-off-by: Arkadiusz Bubala <arkadiusz.bubala@gmail.com>
Tested-by: Arkadiusz Bubala <arkadiusz.bubala@gmail.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/atmel_serial.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN drivers/serial/atmel_serial.c~atmel_serial-fix-rts-high-after-initialization-in-rs485-mode drivers/serial/atmel_serial.c
--- a/drivers/serial/atmel_serial.c~atmel_serial-fix-rts-high-after-initialization-in-rs485-mode
+++ a/drivers/serial/atmel_serial.c
@@ -1732,6 +1732,11 @@ static int __devinit atmel_serial_probe(
 	device_init_wakeup(&pdev->dev, 1);
 	platform_set_drvdata(pdev, port);
 
+	if (port->rs485.flags & SER_RS485_ENABLED) {
+		UART_PUT_MR(&port->uart, ATMEL_US_USMODE_NORMAL);
+		UART_PUT_CR(&port->uart, ATMEL_US_RTSEN);
+	}
+
 	return 0;
 
 err_add_port:
_

Patches currently in -mm which might be from claudio@evidence.eu.com are

origin.patch

