From: akpm@linux-foundation.org
Subject: - x25_asy-fix-ref-count-rule-violation.patch removed from -mm tree
Date: Wed, 13 Feb 2008 12:14:54 -0800
Message-ID: <200802132014.m1DKEsYU011257@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43153 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761682AbYBMUPr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Feb 2008 15:15:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, davem@davemloft.net, jeff@garzik.org, khc@pm.waw.pl, mm-commits@vger.kernel.org


The patch titled
     x25_asy: Fix ref count rule violation
has been removed from the -mm tree.  Its filename was
     x25_asy-fix-ref-count-rule-violation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
libata-isolate-and-rework-cable-logic.patch
git-net.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
parisc-new-termios-definitions.patch
git-sh.patch
megaraid-outb_p-extermination.patch
git-watchdog.patch
tty-bkl-pushdown.patch
tty-bkl-pushdown-fix1.patch
