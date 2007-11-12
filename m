From: akpm@linux-foundation.org
Subject: + char-stallion-fix-compiler-warnings.patch added to -mm tree
Date: Mon, 12 Nov 2007 13:51:14 -0800
Message-ID: <200711122151.lACLpEC0010607@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43559 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753023AbXKLVvb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Nov 2007 16:51:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk


The patch titled
     Char: stallion, fix compiler warnings
has been added to the -mm tree.  Its filename is
     char-stallion-fix-compiler-warnings.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: stallion, fix compiler warnings
From: Jiri Slaby <jirislaby@gmail.com>

Don't emit warnings on 64 bit platforms from min(). sizeof() on those
is not uint, neither 2 pointers difference, cast it to uint by min_t in
both cases.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/stallion.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN drivers/char/stallion.c~char-stallion-fix-compiler-warnings drivers/char/stallion.c
--- a/drivers/char/stallion.c~char-stallion-fix-compiler-warnings
+++ a/drivers/char/stallion.c
@@ -3546,7 +3546,8 @@ static void stl_cd1400txisr(struct stlpa
 	} else {
 		len = min(len, CD1400_TXFIFOSIZE);
 		portp->stats.txtotal += len;
-		stlen = min(len, ((portp->tx.buf + STL_TXBUFSIZE) - tail));
+		stlen = min_t(unsigned int, len,
+				(portp->tx.buf + STL_TXBUFSIZE) - tail);
 		outb((TDR + portp->uartaddr), ioaddr);
 		outsb((ioaddr + EREG_DATA), tail, stlen);
 		len -= stlen;
@@ -3599,7 +3600,7 @@ static void stl_cd1400rxisr(struct stlpa
 		outb((RDCR + portp->uartaddr), ioaddr);
 		len = inb(ioaddr + EREG_DATA);
 		if (tty == NULL || (buflen = tty_buffer_request_room(tty, len)) == 0) {
-			len = min(len, sizeof(stl_unwanted));
+			len = min_t(unsigned int, len, sizeof(stl_unwanted));
 			outb((RDSR + portp->uartaddr), ioaddr);
 			insb((ioaddr + EREG_DATA), &stl_unwanted[0], len);
 			portp->stats.rxlost += len;
@@ -4465,7 +4466,8 @@ static void stl_sc26198txisr(struct stlp
 	} else {
 		len = min(len, SC26198_TXFIFOSIZE);
 		portp->stats.txtotal += len;
-		stlen = min(len, ((portp->tx.buf + STL_TXBUFSIZE) - tail));
+		stlen = min_t(unsigned int, len,
+				(portp->tx.buf + STL_TXBUFSIZE) - tail);
 		outb(GTXFIFO, (ioaddr + XP_ADDR));
 		outsb((ioaddr + XP_DATA), tail, stlen);
 		len -= stlen;
@@ -4506,7 +4508,7 @@ static void stl_sc26198rxisr(struct stlp
 
 	if ((iack & IVR_TYPEMASK) == IVR_RXDATA) {
 		if (tty == NULL || (buflen = tty_buffer_request_room(tty, len)) == 0) {
-			len = min(len, sizeof(stl_unwanted));
+			len = min_t(unsigned int, len, sizeof(stl_unwanted));
 			outb(GRXFIFO, (ioaddr + XP_ADDR));
 			insb((ioaddr + XP_DATA), &stl_unwanted[0], len);
 			portp->stats.rxlost += len;
_

Patches currently in -mm which might be from jirislaby@gmail.com are

fs-sysfs-remove-spin_lock_unlocked.patch
net-sunrpc-remove-spin_lock_unlocked.patch
net-ibm_newemac-remove-spin_lock_unlocked.patch
sbus-cpwatchdog-remove-spin_lock_unlocked.patch
watchdog-bfin_wdt-remove-spin_lock_unlocked.patch
git-wireless.patch
crisv10-serial-driver-rewrite-take-three.patch
dzh-remove-useless-unused-module-junk.patch
dz-always-check-if-it-is-safe-to-console_putchar.patch
dz-dont-panic-when-request_irq-fails.patch
dz-add-and-reorder-inclusions-remove-unneeded-ones.patch
dz-update-kconfig-description.patch
dz-rename-the-serial-console-structure.patch
dz-fix-locking-issues.patch
dz-handle-special-conditions-on-reception-correctly.patch
maintainers-add-self-for-the-dz-serial-driver.patch
char-rocket-switch-long-delay-to-sleep.patch
char-rocket-printk-cleanup.patch
char-rocket-remove-useless-macros.patch
char-char-serial-remove-serial_type_normal-redefines.patch
char-mxser_new-ioaddresses-are-ulong.patch
char-stallion-fix-compiler-warnings.patch
char-riscom8-change-rc_init_drivers-prototype.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch
