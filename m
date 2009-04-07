From: akpm@linux-foundation.org
Subject: + char-isicom-prolong-tty-reference-holding.patch added to -mm tree
Date: Tue, 07 Apr 2009 13:43:26 -0700
Message-ID: <200904072043.n37KhQ7N019268@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42546 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754218AbZDGUpa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 16:45:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk


The patch titled
     Char: isicom: prolong tty reference holding
has been added to the -mm tree.  Its filename is
     char-isicom-prolong-tty-reference-holding.patch

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
Subject: Char: isicom: prolong tty reference holding
From: Jiri Slaby <jirislaby@gmail.com>

Hold the tty reference a bit longer in isicom_shutdown_port, because we
use it later in the function, so that it won't disappear in the meantime.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/isicom.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/char/isicom.c~char-isicom-prolong-tty-reference-holding drivers/char/isicom.c
--- a/drivers/char/isicom.c~char-isicom-prolong-tty-reference-holding
+++ a/drivers/char/isicom.c
@@ -897,8 +897,6 @@ static void isicom_shutdown_port(struct 
 
 	tty_port_free_xmit_buf(&port->port);
 	port->port.flags &= ~ASYNC_INITIALIZED;
-	/* 3rd October 2000 : Vinayak P Risbud */
-	tty_port_tty_set(&port->port, NULL);
 
 	/*Fix done by Anil .S on 30-04-2001
 	remote login through isi port has dtr toggle problem
@@ -925,6 +923,7 @@ static void isicom_shutdown_port(struct 
 		if (!card->count)
 			isicom_shutdown_board(card);
 	}
+	tty_port_tty_set(&port->port, NULL);
 	tty_kref_put(tty);
 }
 
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
linux-next.patch
icom-converting-space-to-tabs.patch
char-isicom-prolong-tty-reference-holding.patch
char-isicom-fix-build-warning.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

