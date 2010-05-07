From: akpm@linux-foundation.org
Subject: [merged] serial-add-driver-for-the-altera-jtag-uart-update.patch removed from -mm tree
Date: Fri, 07 May 2010 12:11:40 -0400
Message-ID: <201005071913.o47JDA5A006597@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48313 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758066Ab0EGTNW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 May 2010 15:13:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tklauser@distanz.ch, alan@lxorguk.ukuu.org.uk, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     serial-add-driver-for-the-altera-jtag-uart-update
has been removed from the -mm tree.  Its filename was
     serial-add-driver-for-the-altera-jtag-uart-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

