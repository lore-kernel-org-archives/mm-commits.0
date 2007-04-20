From: akpm@linux-foundation.org
Subject: + char-mxser_new-fix-recursive-locking.patch added to -mm tree
Date: Fri, 20 Apr 2007 11:21:09 -0700
Message-ID: <200704201821.l3KIL9w5020925@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52756 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993315AbXDTSVW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Apr 2007 14:21:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kas@fi.muni.cz, alan@lxorguk.ukuu.org.uk, jirislaby@gmail.com


The patch titled
     Char: mxser_new, fix recursive locking
has been added to the -mm tree.  Its filename is
     char-mxser_new-fix-recursive-locking.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: mxser_new, fix recursive locking
From: Jan Yenya Kasprzak <kas@fi.muni.cz>

Signed-off-by: Jan "Yenya" Kasprzak <kas@fi.muni.cz>
Acked-by: Jiri Slaby <jirislaby@gmail.com>
Acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mxser_new.c |    7 +++++++
 1 files changed, 7 insertions(+)

diff -puN drivers/char/mxser_new.c~char-mxser_new-fix-recursive-locking drivers/char/mxser_new.c
--- a/drivers/char/mxser_new.c~char-mxser_new-fix-recursive-locking
+++ a/drivers/char/mxser_new.c
@@ -2230,7 +2230,14 @@ end_intr:
 	port->mon_data.rxcnt += cnt;
 	port->mon_data.up_rxcnt += cnt;
 
+	/*
+	 * We are called from an interrupt context with &port->slock
+	 * being held. Drop it temporarily in order to prevent
+	 * recursive locking.
+	 */
+	spin_unlock(&port->slock);
 	tty_flip_buffer_push(tty);
+	spin_lock(&port->slock);
 }
 
 static void mxser_transmit_chars(struct mxser_port *port)
_

Patches currently in -mm which might be from kas@fi.muni.cz are

char-mxser_new-fix-recursive-locking.patch
