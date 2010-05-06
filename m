From: akpm@linux-foundation.org
Subject: + serial-add-driver-for-the-altera-jtag-uart-update.patch added to -mm tree
Date: Thu, 06 May 2010 14:51:39 -0700
Message-ID: <201005062151.o46LpdSv016757@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42538 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751778Ab0EFVw0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 May 2010 17:52:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tklauser@distanz.ch, alan@lxorguk.ukuu.org.uk, greg@kroah.com


The patch titled
     serial-add-driver-for-the-altera-jtag-uart-update
has been added to the -mm tree.  Its filename is
     serial-add-driver-for-the-altera-jtag-uart-update.patch

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
Subject: serial-add-driver-for-the-altera-jtag-uart-update
From: Tobias Klauser <tklauser@distanz.ch>

Add an UART driver for the JTAG UART component available as a SOPC
(System on Programmable Chip) component for Altera FPGAs.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/serial/Kconfig~serial-add-driver-for-the-altera-jtag-uart-update drivers/serial/Kconfig
--- a/drivers/serial/Kconfig~serial-add-driver-for-the-altera-jtag-uart-update
+++ a/drivers/serial/Kconfig
@@ -1531,14 +1531,14 @@ config SERIAL_GRLIB_GAISLER_APBUART_CONS
 	Support for running a console on the GRLIB APBUART
 
 config SERIAL_ALTERA_JTAGUART
-	bool "Altera JTAG UART support"
+	tristate "Altera JTAG UART support"
 	select SERIAL_CORE
 	help
 	  This driver supports the Altera JTAG UART port.
 
 config SERIAL_ALTERA_JTAGUART_CONSOLE
 	bool "Altera JTAG UART console support"
-	depends on SERIAL_ALTERA_JTAGUART
+	depends on SERIAL_ALTERA_JTAGUART=y
 	select SERIAL_CORE_CONSOLE
 	help
 	  Enable a Altera JTAG UART port to be the system console.
_

Patches currently in -mm which might be from tklauser@distanz.ch are

linux-next.patch
serial-add-driver-for-the-altera-jtag-uart.patch
serial-add-driver-for-the-altera-jtag-uart-update.patch
serial-add-driver-for-the-altera-uart.patch
serial-add-driver-for-the-altera-uart-update.patch

