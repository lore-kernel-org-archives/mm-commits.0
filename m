From: akpm@linux-foundation.org
Subject: - char-stallion-fix-compiler-warnings.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:09:36 -0800
Message-ID: <200802080809.m1889HUW014815@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43829 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754985AbYBHITA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:19:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     Char: stallion, fix compiler warnings
has been removed from the -mm tree.  Its filename was
     char-stallion-fix-compiler-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

origin.patch
git-drm.patch
drm-i915-fix-oops-after-killing-x.patch
git-watchdog.patch
moxa-first-pass-at-termios-reporting.patch
char-applicom-use-pci_resource_start.patch
char-applicom-use-pci_match_id.patch
char-applicom-use-pci_match_id-fix.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch
