From: akpm@linux-foundation.org
Subject: + char-moxa-prevent-opening-unavailable-ports.patch added to -mm tree
Date: Tue, 09 Jun 2009 12:26:45 -0700
Message-ID: <200906091926.n59JQjoM014390@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53663 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753327AbZFIT1A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jun 2009 15:27:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eibach@gdsys.de, alan@lxorguk.ukuu.org.uk, jirislaby@gmail.com


The patch titled
     char: moxa, prevent opening unavailable ports
has been added to the -mm tree.  Its filename is
     char-moxa-prevent-opening-unavailable-ports.patch

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
Subject: char: moxa, prevent opening unavailable ports
From: Dirk Eibach <eibach@gdsys.de>

In moxa.c there are 32 minor numbers reserved for each device.  The number
of ports actually available per device is stored in
moxa_board_conf->numPorts.  This number is not considered in moxa_open(). 
Opening a port that is not available results in a kernel oops.  This patch
adds a test to moxa_open() that prevents opening unavailable ports.

Signed-off-by: Dirk Eibach <eibach@gdsys.de>
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/moxa.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN drivers/char/moxa.c~char-moxa-prevent-opening-unavailable-ports drivers/char/moxa.c
--- a/drivers/char/moxa.c~char-moxa-prevent-opening-unavailable-ports
+++ a/drivers/char/moxa.c
@@ -1184,6 +1184,11 @@ static int moxa_open(struct tty_struct *
 		return -ENODEV;
 	}
 
+	if (port % MAX_PORTS_PER_BOARD >= brd->numPorts) {
+		mutex_unlock(&moxa_openlock);
+		return -ENODEV;
+	}
+
 	ch = &brd->ports[port % MAX_PORTS_PER_BOARD];
 	ch->port.count++;
 	tty->driver_data = ch;
_

Patches currently in -mm which might be from eibach@gdsys.de are

char-moxa-prevent-opening-unavailable-ports.patch
char-moxa-prevent-opening-unavailable-ports-fix.patch

