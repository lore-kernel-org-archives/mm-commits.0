From: akpm@linux-foundation.org
Subject: [merged] moxa-fix-refcounting-in-moxa_poll_port.patch removed from -mm tree
Date: Mon, 30 Mar 2009 12:07:07 -0700
Message-ID: <200903301907.n2UJ77lC019271@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41933 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759427AbZC3TKw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Mar 2009 15:10:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, kas@fi.muni.cz, mm-commits@vger.kernel.org


The patch titled
     moxa: fix refcounting in moxa_poll_port
has been removed from the -mm tree.  Its filename was
     moxa-fix-refcounting-in-moxa_poll_port.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: moxa: fix refcounting in moxa_poll_port
From: Jiri Slaby <jirislaby@gmail.com>

There is a missing tty_kref_put() on some paths in moxa_poll_port(), although
the reference is always taken.  Fix it.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Reported-by: Jan 'Yenya' Kasprzak <kas@fi.muni.cz>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/moxa.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN drivers/char/moxa.c~moxa-fix-refcounting-in-moxa_poll_port drivers/char/moxa.c
--- a/drivers/char/moxa.c~moxa-fix-refcounting-in-moxa_poll_port
+++ a/drivers/char/moxa.c
@@ -1486,11 +1486,11 @@ static int moxa_poll_port(struct moxa_po
 	}
 
 	if (!handle) /* nothing else to do */
-		return 0;
+		goto put;
 
 	intr = readw(ip); /* port irq status */
 	if (intr == 0)
-		return 0;
+		goto put;
 
 	writew(0, ip); /* ACK port */
 	ofsAddr = p->tableAddr;
@@ -1499,16 +1499,17 @@ static int moxa_poll_port(struct moxa_po
 				ofsAddr + HostStat);
 
 	if (!inited)
-		return 0;
+		goto put;
 
 	if (tty && (intr & IntrBreak) && !I_IGNBRK(tty)) { /* BREAK */
 		tty_insert_flip_char(tty, 0, TTY_BREAK);
 		tty_schedule_flip(tty);
 	}
-	tty_kref_put(tty);
 
 	if (intr & IntrLine)
 		moxa_new_dcdstate(p, readb(ofsAddr + FlagStat) & DCD_state);
+put:
+	tty_kref_put(tty);
 
 	return 0;
 }
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
linux-next.patch
tty-pty-lookup-retval-fixup.patch
isicom-isicom-kref-leak-fix-fix.patch
icom-converting-space-to-tabs.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

