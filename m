From: akpm@linux-foundation.org
Subject: [merged] tty-serial-fix-apbuart-build.patch removed from -mm tree
Date: Mon, 31 Jan 2011 11:14:47 -0800
Message-ID: <201101311914.p0VJElBl027718@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38670 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755844Ab1AaTPD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 31 Jan 2011 14:15:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, daniel@gaisler.com, gregkh@suse.de, mm-commits@vger.kernel.org


The patch titled
     tty/serial: fix apbuart build
has been removed from the -mm tree.  Its filename was
     tty-serial-fix-apbuart-build.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tty/serial: fix apbuart build
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix build errors by selecting SERIAL_CORE:

ERROR: "uart_register_driver" [drivers/tty/serial/apbuart.ko] undefined!
ERROR: "uart_write_wakeup" [drivers/tty/serial/apbuart.ko] undefined!
ERROR: "uart_update_timeout" [drivers/tty/serial/apbuart.ko] undefined!
ERROR: "uart_get_divisor" [drivers/tty/serial/apbuart.ko] undefined!
ERROR: "uart_get_baud_rate" [drivers/tty/serial/apbuart.ko] undefined!
ERROR: "uart_add_one_port" [drivers/tty/serial/apbuart.ko] undefined!
ERROR: "uart_unregister_driver" [drivers/tty/serial/apbuart.ko] undefined!
ERROR: "uart_remove_one_port" [drivers/tty/serial/apbuart.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Daniel Hellstrom <daniel@gaisler.com>
Cc: Greg KH <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/tty/serial/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/tty/serial/Kconfig~tty-serial-fix-apbuart-build drivers/tty/serial/Kconfig
--- a/drivers/tty/serial/Kconfig~tty-serial-fix-apbuart-build
+++ a/drivers/tty/serial/Kconfig
@@ -1518,6 +1518,7 @@ config SERIAL_BCM63XX_CONSOLE
 config SERIAL_GRLIB_GAISLER_APBUART
 	tristate "GRLIB APBUART serial support"
 	depends on OF
+	select SERIAL_CORE
 	---help---
 	Add support for the GRLIB APBUART serial port.
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
backlight-apple_bl-depends-on-acpi.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

