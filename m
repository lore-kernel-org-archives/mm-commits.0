From: akpm@linux-foundation.org
Subject: + 8250-allow-port-type-to-specify-bugs-that-are-not-probed-for.patch added to -mm tree
Date: Wed, 26 Nov 2008 14:49:54 -0800
Message-ID: <200811262249.mAQMnt4q011738@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60158 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752802AbYKZWu1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Nov 2008 17:50:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ddaney@caviumnetworks.com


The patch titled
     8250: allow port type to specify bugs that are not probed for
has been added to the -mm tree.  Its filename is
     8250-allow-port-type-to-specify-bugs-that-are-not-probed-for.patch

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
Subject: 8250: allow port type to specify bugs that are not probed for
From: David Daney <ddaney@caviumnetworks.com>

Add a bugs field to the serial8250_config and propagate it to the port's
bugs field when the port is registered and configured.

This is a follow on to the previous patch.  Now that we can specify the
port type and don't have to probe for it, we can avoid probing for bugs if
they are known with certainty to exist.

The alternative is to load up 8250.c with a bunch of OCTEON specific
special cases in the probing code.

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250.c |    2 ++
 drivers/serial/8250.h |    1 +
 2 files changed, 3 insertions(+)

diff -puN drivers/serial/8250.c~8250-allow-port-type-to-specify-bugs-that-are-not-probed-for drivers/serial/8250.c
--- a/drivers/serial/8250.c~8250-allow-port-type-to-specify-bugs-that-are-not-probed-for
+++ a/drivers/serial/8250.c
@@ -1212,6 +1212,7 @@ static void autoconfig(struct uart_8250_
 	up->port.fifosize = uart_config[up->port.type].fifo_size;
 	up->capabilities = uart_config[up->port.type].flags;
 	up->tx_loadsz = uart_config[up->port.type].tx_loadsz;
+	up->bugs |= uart_config[up->port.type].bugs;
 
 	if (up->port.type == PORT_UNKNOWN)
 		goto out;
@@ -3065,6 +3066,7 @@ int serial8250_register_port(struct uart
 			uart->port.fifosize = uart_config[port->type].fifo_size;
 			uart->capabilities = uart_config[port->type].flags;
 			uart->tx_loadsz = uart_config[port->type].tx_loadsz;
+			uart->bugs = uart_config[port->type].bugs;
 		}
 
 		set_io_from_upio(&uart->port);
diff -puN drivers/serial/8250.h~8250-allow-port-type-to-specify-bugs-that-are-not-probed-for drivers/serial/8250.h
--- a/drivers/serial/8250.h~8250-allow-port-type-to-specify-bugs-that-are-not-probed-for
+++ a/drivers/serial/8250.h
@@ -34,6 +34,7 @@ struct serial8250_config {
 	const char	*name;
 	unsigned short	fifo_size;
 	unsigned short	tx_loadsz;
+	unsigned short	bugs;
 	unsigned char	fcr;
 	unsigned int	flags;
 };
_

Patches currently in -mm which might be from ddaney@caviumnetworks.com are

mips-make-bug-__noreturn.patch
8250-dont-clobber-spinlocks.patch
8250-serial-driver-changes-to-support-future-cavium-octeon-serial-patches.patch
serial-allow-port-type-to-be-specified-when-calling-serial8250_register_port.patch
8250-allow-port-type-to-specify-bugs-that-are-not-probed-for.patch
serial-uart-driver-changes-for-cavium-octeon.patch

