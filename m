From: akpm@linux-foundation.org
Subject: [merged] serial-add-driver-for-the-altera-uart-update.patch removed from -mm tree
Date: Fri, 07 May 2010 12:11:46 -0400
Message-ID: <201005071913.o47JDG9F006603@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40267 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758070Ab0EGTN2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 May 2010 15:13:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tklauser@distanz.ch, alan@lxorguk.ukuu.org.uk, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     serial-add-driver-for-the-altera-uart-update
has been removed from the -mm tree.  Its filename was
     serial-add-driver-for-the-altera-uart-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial-add-driver-for-the-altera-uart-update
From: Tobias Klauser <tklauser@distanz.ch>

Add an UART driver for the UART component available as a SOPC (System on
Programmable Chip) component for Altera FPGAs.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/serial/Kconfig~serial-add-driver-for-the-altera-uart-update drivers/serial/Kconfig
--- a/drivers/serial/Kconfig~serial-add-driver-for-the-altera-uart-update
+++ a/drivers/serial/Kconfig
@@ -1552,7 +1552,7 @@ config SERIAL_ALTERA_JTAGUART_CONSOLE_BY
 	  JTAG terminal connection with the host.
 
 config SERIAL_ALTERA_UART
-	bool "Altera UART support"
+	tristate "Altera UART support"
 	select SERIAL_CORE
 	help
 	  This driver supports the Altera softcore UART port.
@@ -1577,7 +1577,7 @@ config SERIAL_ALTERA_UART_BAUDRATE
 
 config SERIAL_ALTERA_UART_CONSOLE
 	bool "Altera UART console support"
-	depends on SERIAL_ALTERA_UART
+	depends on SERIAL_ALTERA_UART=y
 	select SERIAL_CORE_CONSOLE
 	help
 	  Enable a Altera UART port to be the system console.
_

Patches currently in -mm which might be from tklauser@distanz.ch are

linux-next.patch

