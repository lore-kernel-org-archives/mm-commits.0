From: akpm@linux-foundation.org
Subject: - dont-optimise-away-baud-rate-changes-when-bother-is-used.patch removed from -mm tree
Date: Fri, 24 Aug 2007 13:55:25 -0700
Message-ID: <200708242055.l7OKtPRP013958@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60755 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756727AbXHXU4B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 16:56:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwmw2@infradead.org, alan@redhat.com, m.kozlowski@tuxland.pl, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     serial: don't optimise away baud rate changes when BOTHER is used
has been removed from the -mm tree.  Its filename was
     dont-optimise-away-baud-rate-changes-when-bother-is-used.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Cc: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/serial_core.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff -puN drivers/serial/serial_core.c~dont-optimise-away-baud-rate-changes-when-bother-is-used drivers/serial/serial_core.c
--- a/drivers/serial/serial_core.c~dont-optimise-away-baud-rate-changes-when-bother-is-used
+++ a/drivers/serial/serial_core.c
@@ -1146,11 +1146,14 @@ static void uart_set_termios(struct tty_
 
 	/*
 	 * These are the bits that are used to setup various
-	 * flags in the low level driver.
+	 * flags in the low level driver. We can ignore the Bfoo
+	 * bits in c_cflag; c_[io]speed will always be set
+	 * appropriately by set_termios() in tty_ioctl.c
 	 */
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
git-mtd.patch
mtd-add-module-license-to-mtdbdi.patch
mtd-fix-ctrl-alt-del-cant-reboot-for-intel-flash-bug.patch
remove-fs-jffs2-ioctlc.patch
drivers-mtd-mtdbdic-is-no-longer-an-own-module.patch
git-nfs.patch
jffs2-convert-to-new-aops.patch
fix-config_debug_shirq-trigger-on-free_irq.patch
do-not-export-usr-include-scsi-in-make-headers_install.patch
unicode-diacritics-support.patch
unicode-diacritics-support-s390-fix.patch
documentation-make-headers_installtxt.patch
whitespace-fixes-audit-filtering.patch
whitespace-fixes-syscall-auditing.patch
whitespace-fixes-system-auditing.patch
add-missing-newlines-to-some-uses-of-dev_level-messages.patch
