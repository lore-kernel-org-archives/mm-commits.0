From: akpm@linux-foundation.org
Subject: + dont-optimise-away-baud-rate-changes-when-bother-is-used.patch added to -mm tree
Date: Fri, 08 Jun 2007 11:18:44 -0700
Message-ID: <200706081818.l58IIjFb007634@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32964 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968736AbXFHSTK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2007 14:19:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dwmw2@infradead.org, alan@redhat.com, rmk@arm.linux.org.uk


The patch titled
     serial: don't optimise away baud rate changes when BOTHER is used
has been added to the -mm tree.  Its filename is
     dont-optimise-away-baud-rate-changes-when-bother-is-used.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: serial: don't optimise away baud rate changes when BOTHER is used
From: David Woodhouse <dwmw2@infradead.org>

The uart_set_termios() function will bail out early without bothering to
touch the hardware, if it decides that nothing "relevant" has changed. 
Unfortunately, its idea of "relevant" doesn't include c_[io]speed.  So if
the baud rate bits are BOTHER and you just change the speed, the change
gets optimised away.

This patch makes it ignore the old Bfoo bits in c_cflag and just check
whether c_ispeed and c_ospeed have changed.  Those integers are always set
appropriately for us by set_termios().

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
Acked-by: Alan Cox <alan@redhat.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/serial_core.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff -puN drivers/serial/serial_core.c~dont-optimise-away-baud-rate-changes-when-bother-is-used drivers/serial/serial_core.c
--- a/drivers/serial/serial_core.c~dont-optimise-away-baud-rate-changes-when-bother-is-used
+++ a/drivers/serial/serial_core.c
@@ -1146,11 +1146,19 @@ static void uart_set_termios(struct tty_
 
 	/*
 	 * These are the bits that are used to setup various
-	 * flags in the low level driver.
-	 */
+	 * flags in the low level driver. We can ignore the Bfoo
+	 * bits in c_cflag; c_[io]speed will always be set
+	 * appropriately by set_termios() in tty_ioctl.c
+	 */
+#ifdef CIBAUD
+#define RELEVANT_CFLAG(cflag)	((cflag) & ~(CIBAUD|CBAUD)
+#else
+#define RELEVANT_CFLAG(cflag)	((cflag) & ~(CIBAUD|CBAUD)
+#endif
 #define RELEVANT_IFLAG(iflag)	((iflag) & (IGNBRK|BRKINT|IGNPAR|PARMRK|INPCK))
-
 	if ((cflag ^ old_termios->c_cflag) == 0 &&
+	    tty->termios->c_ospeed == old_termios->c_ospeed &&
+	    tty->termios->c_ispeed == old_termios->c_ispeed &&
 	    RELEVANT_IFLAG(tty->termios->c_iflag ^ old_termios->c_iflag) == 0)
 		return;
 
_

Patches currently in -mm which might be from dwmw2@infradead.org are

origin.patch
use-mutex-instead-of-semaphore-in-the-mtd-st-m25pxx-driver.patch
use-mutex-instead-of-semaphore-in-the-mtd-dataflash-driver.patch
git-ubi.patch
git-battery.patch
dont-optimise-away-baud-rate-changes-when-bother-is-used.patch
jffs2-convert-to-new-aops.patch
char-n_r3964-use-wait_event_interruptible.patch
mismatching-declarations-of-revision-strings-in-hisax.patch
