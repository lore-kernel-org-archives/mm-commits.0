From: akpm@linux-foundation.org
Subject: + serial-fix-driver_name-conflicts.patch added to -mm tree
Date: Thu, 29 May 2008 00:13:55 -0700
Message-ID: <200805290713.m4T7DtMu021959@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51595 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750780AbYE2HTv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 May 2008 03:19:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@ru.mvista.com, alan@redhat.com, macro@linux-mips.org, timur@freescale.com


The patch titled
     serial: fix driver_name conflicts
has been added to the -mm tree.  Its filename is
     serial-fix-driver_name-conflicts.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial: fix driver_name conflicts
From: Anton Vorontsov <avorontsov@ru.mvista.com>

Some drivers are using too generic "serial" name for driver_name, this
might cause issues, like this:

Freescale QUICC Engine UART device driver
proc_dir_entry 'serial' already registered
Call Trace:
[cf82de50] [c0007f7c] show_stack+0x4c/0x1ac (unreliable)
[cf82de90] [c00b03fc] proc_register+0xfc/0x1ac
[cf82dec0] [c00b05c8] create_proc_entry+0x60/0xac
[cf82dee0] [c00b23dc] proc_tty_register_driver+0x60/0x98
[cf82def0] [c016dbd8] tty_register_driver+0x1b4/0x228
[cf82df20] [c0184d70] uart_register_driver+0x144/0x194
[cf82df40] [c030a378] ucc_uart_init+0x2c/0x94
[cf82df50] [c02f21a0] kernel_init+0x98/0x27c
[cf82dff0] [c000fa74] kernel_thread+0x44/0x60

^^ The board is using ucc_uart.c and 8250.c, both registered as
   "serial".

This patch fixes two drivers that are using "serial" for driver_name and
not "ttyS" for dev_name.  Drivers that are using "ttyS" for dev_name, will
conflict anyway, so we don't bother with these.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Acked-by: Alan Cox <alan@redhat.com>
Acked-By: Timur Tabi <timur@freescale.com>
Acked-by: Maciej W. Rozycki <macro@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/sb1250-duart.c |    2 +-
 drivers/serial/ucc_uart.c     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/serial/sb1250-duart.c~serial-fix-driver_name-conflicts drivers/serial/sb1250-duart.c
--- a/drivers/serial/sb1250-duart.c~serial-fix-driver_name-conflicts
+++ a/drivers/serial/sb1250-duart.c
@@ -924,7 +924,7 @@ console_initcall(sbd_serial_console_init
 
 static struct uart_driver sbd_reg = {
 	.owner		= THIS_MODULE,
-	.driver_name	= "serial",
+	.driver_name	= "sb1250_duart",
 	.dev_name	= "duart",
 	.major		= TTY_MAJOR,
 	.minor		= SB1250_DUART_MINOR_BASE,
diff -puN drivers/serial/ucc_uart.c~serial-fix-driver_name-conflicts drivers/serial/ucc_uart.c
--- a/drivers/serial/ucc_uart.c~serial-fix-driver_name-conflicts
+++ a/drivers/serial/ucc_uart.c
@@ -195,7 +195,7 @@ struct uart_qe_port {
 
 static struct uart_driver ucc_uart_driver = {
 	.owner  	= THIS_MODULE,
-	.driver_name    = "serial",
+	.driver_name    = "ucc_uart",
 	.dev_name       = "ttyQE",
 	.major  	= SERIAL_QE_MAJOR,
 	.minor  	= SERIAL_QE_MINOR,
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

mmc_spih-should-include-linux-interruptsh.patch
linux-next.patch
serial-fix-driver_name-conflicts.patch

