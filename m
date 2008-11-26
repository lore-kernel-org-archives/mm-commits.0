From: akpm@linux-foundation.org
Subject: + serial-uart-driver-changes-for-cavium-octeon.patch added to -mm tree
Date: Wed, 26 Nov 2008 14:49:57 -0800
Message-ID: <200811262249.mAQMnve3011741@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58751 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752810AbYKZWzz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Nov 2008 17:55:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ddaney@caviumnetworks.com, tpaoletti@caviumnetworks.com


The patch titled
     serial: UART driver changes for Cavium OCTEON
has been added to the -mm tree.  Its filename is
     serial-uart-driver-changes-for-cavium-octeon.patch

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
Subject: serial: UART driver changes for Cavium OCTEON
From: David Daney <ddaney@caviumnetworks.com>

Cavium UART implementation won't work with the standard 8250 driver as-is.
Define a new uart_config (PORT_OCTEON) and use it to enable special
handling required by the OCTEON's serial port.  Two new bug types are
defined.

Signed-off-by: Tomaso Paoletti <tpaoletti@caviumnetworks.com>
Signed-off-by: David Daney <ddaney@caviumnetworks.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250.c       |   10 +++++++++-
 drivers/serial/8250.h       |    1 +
 include/linux/serial_core.h |    3 ++-
 3 files changed, 12 insertions(+), 2 deletions(-)

diff -puN drivers/serial/8250.c~serial-uart-driver-changes-for-cavium-octeon drivers/serial/8250.c
--- a/drivers/serial/8250.c~serial-uart-driver-changes-for-cavium-octeon
+++ a/drivers/serial/8250.c
@@ -279,6 +279,14 @@ static const struct serial8250_config ua
 		.fcr		= UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_10,
 		.flags		= UART_CAP_FIFO,
 	},
+	[PORT_OCTEON] = {
+		.name		= "OCTEON",
+		.fifo_size	= 64,
+		.tx_loadsz	= 64,
+		.bugs		= UART_BUG_TIMEOUT,
+		.fcr		= UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_10,
+		.flags		= UART_CAP_FIFO,
+	},
 };
 
 #if defined (CONFIG_SERIAL_8250_AU1X00)
@@ -1714,7 +1722,7 @@ static void serial8250_timeout(unsigned 
 	unsigned int iir;
 
 	iir = serial_in(up, UART_IIR);
-	if (!(iir & UART_IIR_NO_INT))
+	if (!(iir & UART_IIR_NO_INT) || (up->bugs & UART_BUG_TIMEOUT))
 		serial8250_handle_port(up);
 	mod_timer(&up->timer, jiffies + poll_timeout(up->port.timeout));
 }
diff -puN drivers/serial/8250.h~serial-uart-driver-changes-for-cavium-octeon drivers/serial/8250.h
--- a/drivers/serial/8250.h~serial-uart-driver-changes-for-cavium-octeon
+++ a/drivers/serial/8250.h
@@ -49,6 +49,7 @@ struct serial8250_config {
 #define UART_BUG_TXEN	(1 << 1)	/* UART has buggy TX IIR status */
 #define UART_BUG_NOMSR	(1 << 2)	/* UART has buggy MSR status bits (Au1x00) */
 #define UART_BUG_THRE	(1 << 3)	/* UART has buggy THRE reassertion */
+#define UART_BUG_TIMEOUT (1 << 4)	/* UART should always handle timeout */
 
 #define PROBE_RSA	(1 << 0)
 #define PROBE_ANY	(~0)
diff -puN include/linux/serial_core.h~serial-uart-driver-changes-for-cavium-octeon include/linux/serial_core.h
--- a/include/linux/serial_core.h~serial-uart-driver-changes-for-cavium-octeon
+++ a/include/linux/serial_core.h
@@ -40,7 +40,8 @@
 #define PORT_NS16550A	14
 #define PORT_XSCALE	15
 #define PORT_RM9000	16	/* PMC-Sierra RM9xxx internal UART */
-#define PORT_MAX_8250	16	/* max port ID */
+#define PORT_OCTEON	17	/* Cavium OCTEON internal UART */
+#define PORT_MAX_8250	17	/* max port ID */
 
 /*
  * ARM specific type numbers.  These are not currently guaranteed
_

Patches currently in -mm which might be from ddaney@caviumnetworks.com are

mips-make-bug-__noreturn.patch
8250-dont-clobber-spinlocks.patch
8250-serial-driver-changes-to-support-future-cavium-octeon-serial-patches.patch
serial-allow-port-type-to-be-specified-when-calling-serial8250_register_port.patch
8250-allow-port-type-to-specify-bugs-that-are-not-probed-for.patch
serial-uart-driver-changes-for-cavium-octeon.patch

