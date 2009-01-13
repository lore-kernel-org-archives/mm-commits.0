From: akpm@linux-foundation.org
Subject: + serial-parisc-fix-early_serial_setup-regression.patch added to -mm tree
Date: Tue, 13 Jan 2009 14:25:56 -0800
Message-ID: <200901132225.n0DMPu5m029264@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55865 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751527AbZAMW1E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Jan 2009 17:27:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: deller@gmx.de, alan@lxorguk.ukuu.org.uk, ddaney@caviumnetworks.com, kyle@mcmartin.ca, tpaoletti@caviumnetworks.com


The patch titled
     serial/parisc: fix early_serial_setup() regression
has been added to the -mm tree.  Its filename is
     serial-parisc-fix-early_serial_setup-regression.patch

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
Subject: serial/parisc: fix early_serial_setup() regression
From: Helge Deller <deller@gmx.de>

commit b430428a188e8a434325e251d0704af4b88b4711,
	"8250: Don't clobber spinlocks."

introduced a regression on the parisc architecture, which broke the
handover to the serial port at boottime.

early_serial_setup() was changed to only copy a subset of the uart_port
fields, and sadly the "type" and "line" fields were forgotten and thus the
serial port was not initialized and could not be used for a handover. 
This patch fixes this by copying the missing fields.

As this change to early_serial_setup() doesn't need an initialized
spinlock in the uart_port struct any longer, we can drop the spinlock
initialization in the superio driver.

Cc: David Daney <ddaney@caviumnetworks.com>
Cc: Tomaso Paoletti <tpaoletti@caviumnetworks.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Acked-by: Kyle McMartin <kyle@mcmartin.ca>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/parisc/superio.c |    1 -
 drivers/serial/8250.c    |    2 ++
 2 files changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/parisc/superio.c~serial-parisc-fix-early_serial_setup-regression drivers/parisc/superio.c
--- a/drivers/parisc/superio.c~serial-parisc-fix-early_serial_setup-regression
+++ a/drivers/parisc/superio.c
@@ -405,7 +405,6 @@ static void __init superio_serial_init(v
 	serial_port.type	= PORT_16550A;
 	serial_port.uartclk	= 115200*16;
 	serial_port.fifosize	= 16;
-	spin_lock_init(&serial_port.lock);
 
 	/* serial port #1 */
 	serial_port.iobase	= sio_dev.sp1_base;
diff -puN drivers/serial/8250.c~serial-parisc-fix-early_serial_setup-regression drivers/serial/8250.c
--- a/drivers/serial/8250.c~serial-parisc-fix-early_serial_setup-regression
+++ a/drivers/serial/8250.c
@@ -2839,6 +2839,8 @@ int __init early_serial_setup(struct uar
 	p->flags        = port->flags;
 	p->mapbase      = port->mapbase;
 	p->private_data = port->private_data;
+	p->type		= port->type;
+	p->line		= port->line;
 
 	set_io_from_upio(p);
 	if (port->serial_in)
_

Patches currently in -mm which might be from deller@gmx.de are

serial-parisc-fix-early_serial_setup-regression.patch
input-keyboard-hilkbdc-fix-crash-when-removing-hilkbd-module.patch
drivers-input-serio-hp_sdcc-fix-crash-when-removing-hp_sdc-module.patch

