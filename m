From: akpm@linux-foundation.org
Subject: + x25_asy-fix-ref-count-rule-violation.patch added to -mm tree
Date: Fri, 08 Feb 2008 13:37:37 -0800
Message-ID: <200802082137.m18LbbU4014577@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47482 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752852AbYBHVkn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 16:40:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, davem@davemloft.net, jeff@garzik.org, khc@pm.waw.pl


The patch titled
     x25_asy: Fix ref count rule violation
has been added to the -mm tree.  Its filename is
     x25_asy-fix-ref-count-rule-violation.patch

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
Subject: x25_asy: Fix ref count rule violation
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

x25_asy does not take an ldisc reference before calling the flush method.
Fix it to use the helper function we provide.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Krzysztof Halasa <khc@pm.waw.pl>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wan/x25_asy.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/net/wan/x25_asy.c~x25_asy-fix-ref-count-rule-violation drivers/net/wan/x25_asy.c
--- a/drivers/net/wan/x25_asy.c~x25_asy-fix-ref-count-rule-violation
+++ a/drivers/net/wan/x25_asy.c
@@ -554,6 +554,7 @@ static void x25_asy_receive_buf(struct t
 static int x25_asy_open_tty(struct tty_struct *tty)
 {
 	struct x25_asy *sl = (struct x25_asy *) tty->disc_data;
+	struct tty_ldisc *ld;
 	int err;
 
 	/* First make sure we're not already connected. */
@@ -572,9 +573,7 @@ static int x25_asy_open_tty(struct tty_s
 	if (tty->driver->flush_buffer)  {
 		tty->driver->flush_buffer(tty);
 	}
-	if (tty->ldisc.flush_buffer)  {
-		tty->ldisc.flush_buffer(tty);
-	}
+	tty_ldisc_flush(tty);
 
 	/* Restore default settings */
 	sl->dev->type = ARPHRD_X25;
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
x25_asy-fix-ref-count-rule-violation.patch
libata-isolate-and-rework-cable-logic.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
hci_ldisc-fix-null-pointer-deref.patch
parisc-new-termios-definitions.patch
git-sh.patch
megaraid-outb_p-extermination.patch
git-watchdog.patch
tty-bkl-pushdown.patch
