From: akpm@linux-foundation.org
Subject: - serial-add-vr41xx_siu_early_setup-for-serial-console.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:55:27 -0700
Message-ID: <200804282155.m3SLtR1x018103@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45020 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935084AbYD1Vzk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:55:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yoichi_yuasa@tripeaks.co.jp, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     serial: add vr41xx_siu_early_setup() for serial console
has been removed from the -mm tree.  Its filename was
     serial-add-vr41xx_siu_early_setup-for-serial-console.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial: add vr41xx_siu_early_setup() for serial console
From: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>

Add vr41xx_siu_early_setup() for serial console.

Signed-off-by: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/vr41xx_siu.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff -puN drivers/serial/vr41xx_siu.c~serial-add-vr41xx_siu_early_setup-for-serial-console drivers/serial/vr41xx_siu.c
--- a/drivers/serial/vr41xx_siu.c~serial-add-vr41xx_siu_early_setup-for-serial-console
+++ a/drivers/serial/vr41xx_siu.c
@@ -1,7 +1,7 @@
 /*
  *  Driver for NEC VR4100 series Serial Interface Unit.
  *
- *  Copyright (C) 2004-2007  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ *  Copyright (C) 2004-2008  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
  *
  *  Based on drivers/serial/8250.c, by Russell King.
  *
@@ -840,6 +840,19 @@ static int __devinit siu_console_init(vo
 
 console_initcall(siu_console_init);
 
+void __init vr41xx_siu_early_setup(struct uart_port *port)
+{
+	if (port->type == PORT_UNKNOWN)
+		return;
+
+	siu_uart_ports[port->line].line = port->line;
+	siu_uart_ports[port->line].type = port->type;
+	siu_uart_ports[port->line].uartclk = SIU_BAUD_BASE * 16;
+	siu_uart_ports[port->line].mapbase = port->mapbase;
+	siu_uart_ports[port->line].mapbase = port->mapbase;
+	siu_uart_ports[port->line].ops = &siu_uart_ops;
+}
+
 #define SERIAL_VR41XX_CONSOLE	&siu_console
 #else
 #define SERIAL_VR41XX_CONSOLE	NULL
_

Patches currently in -mm which might be from yoichi_yuasa@tripeaks.co.jp are

origin.patch

