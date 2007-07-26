From: akpm@linux-foundation.org
Subject: + char-moxa-fix-and-optimise-empty-timer.patch added to -mm tree
Date: Wed, 25 Jul 2007 22:08:31 -0700
Message-ID: <200707260508.l6Q58VLg015232@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55057 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761595AbXGZFJZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 01:09:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: moxa, fix and optimise empty timer
has been added to the -mm tree.  Its filename is
     char-moxa-fix-and-optimise-empty-timer.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: moxa, fix and optimise empty timer
From: Jiri Slaby <jirislaby@gmail.com>

moxa, fix and optimise empty timer

don't wait and delete empty timer in empty timer function. Also fire next
empty timer at rounded jiffies to save power.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/moxa.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/char/moxa.c~char-moxa-fix-and-optimise-empty-timer drivers/char/moxa.c
--- a/drivers/char/moxa.c~char-moxa-fix-and-optimise-empty-timer
+++ a/drivers/char/moxa.c
@@ -1040,14 +1040,14 @@ static void check_xmit_empty(unsigned lo
 	struct moxa_port *ch;
 
 	ch = (struct moxa_port *) data;
-	del_timer_sync(&moxa_ports[ch->port].emptyTimer);
 	if (ch->tty && (ch->statusflags & EMPTYWAIT)) {
 		if (MoxaPortTxQueue(ch->port) == 0) {
 			ch->statusflags &= ~EMPTYWAIT;
 			tty_wakeup(ch->tty);
 			return;
 		}
-		mod_timer(&moxa_ports[ch->port].emptyTimer, jiffies + HZ);
+		mod_timer(&moxa_ports[ch->port].emptyTimer,
+				round_jiffies(jiffies + HZ));
 	} else
 		ch->statusflags &= ~EMPTYWAIT;
 }
_

Patches currently in -mm which might be from jirislaby@gmail.com are

char-moxa-fix-and-optimise-empty-timer.patch
shrink_slab-handle-bad-shrinkers.patch
