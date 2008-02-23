From: akpm@linux-foundation.org
Subject: + uart_get_baud_rate-stop-mangling-termios.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:34:14 -0800
Message-ID: <200802230735.m1N7Z3Lv018328@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:35611 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754027AbYBWH7o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:59:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, rmk@arm.linux.org.uk


The patch titled
     uart_get_baud_rate: stop mangling termios
has been added to the -mm tree.  Its filename is
     uart_get_baud_rate-stop-mangling-termios.patch

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
Subject: uart_get_baud_rate: stop mangling termios
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Russell King noticed this one: We have to avoid replacing B0 when we pick a
baud rate for a "hung up" port.  Ugly but the proper fix is in the tty layer
and means changing the tty<->serial interfaces so we will defer that for now.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/serial_core.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff -puN drivers/serial/serial_core.c~uart_get_baud_rate-stop-mangling-termios drivers/serial/serial_core.c
--- a/drivers/serial/serial_core.c~uart_get_baud_rate-stop-mangling-termios
+++ a/drivers/serial/serial_core.c
@@ -329,13 +329,15 @@ EXPORT_SYMBOL(uart_update_timeout);
  *	If it's still invalid, we try 9600 baud.
  *
  *	Update the @termios structure to reflect the baud rate
- *	we're actually going to be using.
+ *	we're actually going to be using. Don't do this for the case
+ *	where B0 is requested ("hang up").
  */
 unsigned int
 uart_get_baud_rate(struct uart_port *port, struct ktermios *termios,
 		   struct ktermios *old, unsigned int min, unsigned int max)
 {
 	unsigned int try, baud, altbaud = 38400;
+	int hung_up;
 	upf_t flags = port->flags & UPF_SPD_MASK;
 
 	if (flags == UPF_SPD_HI)
@@ -360,8 +362,10 @@ uart_get_baud_rate(struct uart_port *por
 		/*
 		 * Special case: B0 rate.
 		 */
-		if (baud == 0)
+		if (baud == 0) {
+			hung_up = 1;
 			baud = 9600;
+		}
 
 		if (baud >= min && baud <= max)
 			return baud;
@@ -373,7 +377,9 @@ uart_get_baud_rate(struct uart_port *por
 		termios->c_cflag &= ~CBAUD;
 		if (old) {
 			baud = tty_termios_baud_rate(old);
-			tty_termios_encode_baud_rate(termios, baud, baud);
+			if (!hung_up)
+				tty_termios_encode_baud_rate(termios,
+								baud, baud);
 			old = NULL;
 			continue;
 		}
@@ -382,7 +388,8 @@ uart_get_baud_rate(struct uart_port *por
 		 * As a last resort, if the quotient is zero,
 		 * default to 9600 bps
 		 */
-		tty_termios_encode_baud_rate(termios, 9600, 9600);
+		if (!hung_up)
+			tty_termios_encode_baud_rate(termios, 9600, 9600);
 	}
 
 	return 0;
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
libata-isolate-and-rework-cable-logic.patch
pata_amd-fix-sparse-warning.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
parisc-new-termios-definitions.patch
megaraid-outb_p-extermination.patch
usb-serial-prepare-for-bkl-push-down.patch
ftdi_sio-note-missing-locking.patch
usb-serial-note-mos7480-and-option-dont-lock-modem-status.patch
io_ti-lock-mcr-and-msr-shadows-properly.patch
iuu_phoenix-lock-priv-tiostatus-properly.patch
kobil_sct-get-rid-of-unneeded-priv-line_state.patch
ti_usb_3410_5052-extend-locking-to-msr-and-shadow-mcr.patch
git-watchdog.patch
crisv10-prepare-for-bkl-push-down.patch
fix-tty-speed-handling-on-8250.patch
uart_get_baud_rate-stop-mangling-termios.patch
do_task_stat-dont-take-rcu_read_lock.patch
amiserial-prepare-for-locking-relaxation-in-caller.patch
cyclades-prepare-for-relaxed-locking-in-callers.patch
epca-lock_kernel-push-down.patch
esp-lock_kernel-push-down.patch
isicom-prepare-for-lock_kernel-push-down.patch
isicom-istallion-prepare-for-lock_kernel-pushdown.patch
mxser-prepare-for-bkl-pushdown.patch
nozomi-prepare-for-bkl-pushdown.patch
riscom8-prepare-for-bkl-pushdown.patch
rocket-prepare-for-bkl-pushdown.patch
serial167-prepare-to-push-bkl-down-into-drivers.patch
specialix-prepare-for-bkl-pushdown.patch
stallion-prepare-for-bkl-push-down.patch
sx-prepare-for-bkl-pushdown.patch
synclink-series-prepare-for-bkl-pushdown.patch
viocons-bkl-locking.patch
vt_ioctl-prepare-for-bkl-push-down.patch
isdn_tty-prepare-for-bkl-push-down.patch
68360serial-note-that-there-isnt-any-info-mcr-locking.patch
serial_core-prepare-for-bkl-push-down.patch
tty-bkl-pushdown.patch
tty-bkl-pushdown-fix1.patch
redo-locking-of-tty-pgrp.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch
