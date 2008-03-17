From: akpm@linux-foundation.org
Subject: + serial-add-vr41xx_siu_early_setup-for-serial-console.patch added to -mm tree
Date: Mon, 17 Mar 2008 15:39:03 -0700
Message-ID: <200803172239.m2HMd3IT001959@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45945 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752355AbYCQWjo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Mar 2008 18:39:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yoichi_yuasa@tripeaks.co.jp, ralf@linux-mips.org


The patch titled
     serial: add vr41xx_siu_early_setup() for serial console
has been added to the -mm tree.  Its filename is
     serial-add-vr41xx_siu_early_setup-for-serial-console.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial: add vr41xx_siu_early_setup() for serial console
From: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>

Add vr41xx_siu_early_setup() for serial console

Signed-off-by: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/vr41xx_siu.c   |   15 ++++++++++++++-
 include/asm-mips/vr41xx/siu.h |    8 +++++++-
 2 files changed, 21 insertions(+), 2 deletions(-)

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
diff -puN include/asm-mips/vr41xx/siu.h~serial-add-vr41xx_siu_early_setup-for-serial-console include/asm-mips/vr41xx/siu.h
--- a/include/asm-mips/vr41xx/siu.h~serial-add-vr41xx_siu_early_setup-for-serial-console
+++ a/include/asm-mips/vr41xx/siu.h
@@ -1,7 +1,7 @@
 /*
  *  Include file for NEC VR4100 series Serial Interface Unit.
  *
- *  Copyright (C) 2005  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ *  Copyright (C) 2005-2008  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
@@ -49,4 +49,10 @@ typedef enum {
 
 extern void vr41xx_select_irda_module(irda_module_t module, irda_speed_t speed);
 
+#ifdef CONFIG_SERIAL_VR41XX_CONSOLE
+extern void vr41xx_siu_early_setup(struct uart_port *port);
+#else
+static inline void vr41xx_siu_early_setup(struct uart_port *port) {}
+#endif
+
 #endif /* __NEC_VR41XX_SIU_H */
_

Patches currently in -mm which might be from yoichi_yuasa@tripeaks.co.jp are

git-input.patch
serial-add-vr41xx_siu_early_setup-for-serial-console.patch

