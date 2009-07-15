From: akpm@linux-foundation.org
Subject: + char-nozomi-fix-tty-refcounting-bug.patch added to -mm tree
Date: Wed, 15 Jul 2009 14:30:25 -0700
Message-ID: <200907152130.n6FLUPJS008412@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44476 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752245AbZGOVa4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Jul 2009 17:30:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: nozomi, fix tty refcounting bug
has been added to the -mm tree.  Its filename is
     char-nozomi-fix-tty-refcounting-bug.patch

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
Subject: Char: nozomi, fix tty refcounting bug
From: Jiri Slaby <jirislaby@gmail.com>

Don't forget to drop a tty refererence on fail paths in receive_data().

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/nozomi.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN drivers/char/nozomi.c~char-nozomi-fix-tty-refcounting-bug drivers/char/nozomi.c
--- a/drivers/char/nozomi.c~char-nozomi-fix-tty-refcounting-bug
+++ a/drivers/char/nozomi.c
@@ -828,7 +828,7 @@ static int receive_data(enum port_type i
 	struct port *port = &dc->port[index];
 	void __iomem *addr = port->dl_addr[port->toggle_dl];
 	struct tty_struct *tty = tty_port_tty_get(&port->port);
-	int i;
+	int i, ret;
 
 	if (unlikely(!tty)) {
 		DBG1("tty not open for port: %d?", index);
@@ -844,12 +844,14 @@ static int receive_data(enum port_type i
 
 		/* disable interrupt in downlink... */
 		disable_transmit_dl(index, dc);
-		return 0;
+		ret = 0;
+		goto put;
 	}
 
 	if (unlikely(size == 0)) {
 		dev_err(&dc->pdev->dev, "size == 0?\n");
-		return 1;
+		ret = 1;
+		goto put;
 	}
 
 	tty_buffer_request_room(tty, size);
@@ -871,8 +873,10 @@ static int receive_data(enum port_type i
 	}
 
 	set_bit(index, &dc->flip);
+	ret = 1;
+put:
 	tty_kref_put(tty);
-	return 1;
+	return ret;
 }
 
 /* Debug for interrupts */
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
linux-next.patch
toshiba_acpi-return-on-a-fail-path.patch
isdn-hisax-fix-lock-imbalance.patch
icom-converting-space-to-tabs.patch
char-nozomi-fix-tty-refcounting-bug.patch
reiser4.patch

