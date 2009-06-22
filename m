From: akpm@linux-foundation.org
Subject: [merged] char-moxa-prevent-opening-unavailable-ports.patch removed from -mm tree
Date: Mon, 22 Jun 2009 10:00:33 -0700
Message-ID: <200906221700.n5MH0XZX009846@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37494 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753839AbZFVRBU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Jun 2009 13:01:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eibach@gdsys.de, alan@lxorguk.ukuu.org.uk, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     char: moxa, prevent opening unavailable ports
has been removed from the -mm tree.  Its filename was
     char-moxa-prevent-opening-unavailable-ports.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: char: moxa, prevent opening unavailable ports
From: Dirk Eibach <eibach@gdsys.de>

In moxa.c there are 32 minor numbers reserved for each device.  The number
of ports actually available per device is stored in
moxa_board_conf->numPorts.  This number is not considered in moxa_open(). 
Opening a port that is not available results in a kernel oops.  This patch
adds a test to moxa_open() that prevents opening unavailable ports.

[akpm@linux-foundation.org: avoid multiple returns]
Signed-off-by: Dirk Eibach <eibach@gdsys.de>
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/moxa.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN drivers/char/moxa.c~char-moxa-prevent-opening-unavailable-ports drivers/char/moxa.c
--- a/drivers/char/moxa.c~char-moxa-prevent-opening-unavailable-ports
+++ a/drivers/char/moxa.c
@@ -1189,6 +1189,11 @@ static int moxa_open(struct tty_struct *
 		return -ENODEV;
 	}
 
+	if (port % MAX_PORTS_PER_BOARD >= brd->numPorts) {
+		retval = -ENODEV;
+		goto out_unlock;
+	}
+
 	ch = &brd->ports[port % MAX_PORTS_PER_BOARD];
 	ch->port.count++;
 	tty->driver_data = ch;
@@ -1213,8 +1218,8 @@ static int moxa_open(struct tty_struct *
 				moxa_close_port(tty);
 	} else
 		ch->port.flags |= ASYNC_NORMAL_ACTIVE;
+out_unlock:
 	mutex_unlock(&moxa_openlock);
