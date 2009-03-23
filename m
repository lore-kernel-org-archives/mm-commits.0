From: akpm@linux-foundation.org
Subject: + moxa-fix-refcounting-in-moxa_poll_port.patch added to -mm tree
Date: Sun, 22 Mar 2009 18:02:48 -0700
Message-ID: <200903230107.n2N176Ok002073@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59566 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753720AbZCWBKE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 22 Mar 2009 21:10:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, kas@fi.muni.cz


The patch titled
     moxa: fix refcounting in moxa_poll_port
has been added to the -mm tree.  Its filename is
     moxa-fix-refcounting-in-moxa_poll_port.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
icom-converting-space-to-tabs.patch
moxa-fix-refcounting-in-moxa_poll_port.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

