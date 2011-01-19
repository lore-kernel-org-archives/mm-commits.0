From: akpm@linux-foundation.org
Subject: + tty-serial-fix-apbuart-build.patch added to -mm tree
Date: Wed, 19 Jan 2011 14:34:35 -0800
Message-ID: <201101192234.p0JMYZup007455@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48617 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755078Ab1ASWew (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Jan 2011 17:34:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, daniel@gaisler.com, gregkh@suse.de


The patch titled
     tty/serial: fix apbuart build
has been added to the -mm tree.  Its filename is
     tty-serial-fix-apbuart-build.patch

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

backlight-fix-88pm860x_bl-macro-collision.patch
linux-next.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
tty-serial-fix-apbuart-build.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

