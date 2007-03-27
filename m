From: akpm@linux-foundation.org
Subject: - 8250-make-probing-for-txen-bug-a-config-option.patch removed from -mm tree
Date: Mon, 26 Mar 2007 21:52:12 -0800
Message-ID: <200703270552.l2R5qCoV008481@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40581 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934030AbXC0FwV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Mar 2007 01:52:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vitalywool@gmail.com, david-b@pacbell.net, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     8250: make probing for TXEN bug a config option
has been removed from the -mm tree.  Its filename was
     8250-make-probing-for-txen-bug-a-config-option.patch

This patch was dropped because it should at least be a module param/boot option, not a config option

------------------------------------------------------
Subject: 8250: make probing for TXEN bug a config option
From: Vitaly Wool <vitalywool@gmail.com>

Probing for UART_BUG_TXEN in 8250 driver leads to weird effects on some ARM
boards (pnx4008 for instance).  That is, the driver detects UART_BUG_TXEN
(though it apparently shouldn't) and it leads to symbol loss in console on
input (i.  e.  you input 'a' and you get nothing, then you input 'b' and
you get 'a', then you input 'c' and get 'b' and so on).

The patch makes this very probing a configuration option turned on by
default.

Signed-off-by: Vitaly Wool <vitalywool@gmail.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250.c  |    5 ++++-
 drivers/serial/Kconfig |   10 ++++++++++
 2 files changed, 14 insertions(+), 1 deletion(-)

diff -puN drivers/serial/8250.c~8250-make-probing-for-txen-bug-a-config-option drivers/serial/8250.c
--- a/drivers/serial/8250.c~8250-make-probing-for-txen-bug-a-config-option
+++ a/drivers/serial/8250.c
@@ -1770,6 +1770,7 @@ static int serial8250_startup(struct uar
 
 	serial8250_set_mctrl(&up->port, up->port.mctrl);
 
+#ifndef CONFIG_SERIAL_8250_DONT_TEST_BUG_TXEN
 	/*
 	 * Do a quick test to see if we receive an
 	 * interrupt when we enable the TX irq.
@@ -1785,7 +1786,9 @@ static int serial8250_startup(struct uar
 			pr_debug("ttyS%d - enabling bad tx status workarounds\n",
 				 port->line);
 		}
-	} else {
+	} else
+#endif
+	{
 		up->bugs &= ~UART_BUG_TXEN;
 	}
 
diff -puN drivers/serial/Kconfig~8250-make-probing-for-txen-bug-a-config-option drivers/serial/Kconfig
--- a/drivers/serial/Kconfig~8250-make-probing-for-txen-bug-a-config-option
+++ a/drivers/serial/Kconfig
@@ -223,6 +223,16 @@ config SERIAL_8250_DETECT_IRQ
 
 	  If unsure, say N.
 
+config SERIAL_8250_DONT_TEST_BUG_TXEN
+	bool "Don't probe for TXEN bug"
+	depends on SERIAL_8250_EXTENDED
+	help
+	  Say Y here if you don't want the kernel to probe for TXEN bug
+	  on your serial port and try to workaround it. It might lead to
+	  character loss on some boards, though this is quite a rare case.
+
+	  If unsure, say N.
+
 config SERIAL_8250_RSA
 	bool "Support RSA serial ports"
 	depends on SERIAL_8250_EXTENDED
_

Patches currently in -mm which might be from vitalywool@gmail.com are

8250-make-probing-for-txen-bug-a-config-option.patch
