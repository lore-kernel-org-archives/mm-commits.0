From: akpm@osdl.org
Subject: + 8250-make-probing-for-txen-bug-a-config-option.patch added to -mm tree
Date: Wed, 27 Dec 2006 00:55:43 -0800
Message-ID: <200612270855.kBR8thAx006164@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:41581 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753655AbWL0I4J (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Dec 2006 03:56:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vitalywool@gmail.com, rmk@arm.linux.org.uk


The patch titled
     8250: make probing for TXEN bug a config option
has been added to the -mm tree.  Its filename is
     8250-make-probing-for-txen-bug-a-config-option.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/serial/8250.c  |    5 ++++-
 drivers/serial/Kconfig |   10 ++++++++++
 2 files changed, 14 insertions(+), 1 deletion(-)

diff -puN drivers/serial/8250.c~8250-make-probing-for-txen-bug-a-config-option drivers/serial/8250.c
--- a/drivers/serial/8250.c~8250-make-probing-for-txen-bug-a-config-option
+++ a/drivers/serial/8250.c
@@ -1771,6 +1771,7 @@ static int serial8250_startup(struct uar
 
 	serial8250_set_mctrl(&up->port, up->port.mctrl);
 
+#ifndef CONFIG_SERIAL_8250_DONT_TEST_BUG_TXEN
 	/*
 	 * Do a quick test to see if we receive an
 	 * interrupt when we enable the TX irq.
@@ -1786,7 +1787,9 @@ static int serial8250_startup(struct uar
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

fix-pnx8550-serial-breakage.patch
pnx8550-uart-driver.patch
pnx8550-uart-driver-fixes.patch
8250-make-probing-for-txen-bug-a-config-option.patch

