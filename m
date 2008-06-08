From: akpm@linux-foundation.org
Subject: - serial-fix-driver_name-conflicts.patch removed from -mm tree
Date: Sun, 08 Jun 2008 12:47:12 -0700
Message-ID: <200806081947.m58JlCpU017402@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50599 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754742AbYFHTyS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 15:54:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avorontsov@ru.mvista.com, alan@redhat.com, macro@linux-mips.org, timur@freescale.com, mm-commits@vger.kernel.org


The patch titled
     serial: fix driver_name conflicts
has been removed from the -mm tree.  Its filename was
     serial-fix-driver_name-conflicts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
git-leds.patch
mpc83xx_wdt-convert-to-the-of-platform-driver.patch
mpc83xx_wdt-add-support-for-mpc86xx-cpus.patch
mpc83xx_wdt-rename-to-mpc8xxx_wdt.patch
mpc8xxx_wdt-various-renames-mostly-s-mpc83xx-mpc8xxx-g.patch
mpc8xxx_wdt-add-support-for-mpc8xx-watchdogs.patch
powerpc-fsl_soc-remove-mpc83xx_wdt-code.patch
powerpc-86xx-mpc8610_hpcd-add-watchdog-node.patch
hgafb-convert-to-new-platform-driver-api-bugzilla-9689.patch

