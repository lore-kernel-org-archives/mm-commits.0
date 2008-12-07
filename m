From: akpm@linux-foundation.org
Subject: + fix-for-tty-serial-move-port.patch added to -mm tree
Date: Sat, 06 Dec 2008 23:50:52 -0800
Message-ID: <200812070750.mB77oqdn007385@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50973 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751126AbYLGHvC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 7 Dec 2008 02:51:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.beregalov@gmail.com, alan@lxorguk.ukuu.org.uk


The patch titled
     fix for tty-serial-move-port
has been added to the -mm tree.  Its filename is
     fix-for-tty-serial-move-port.patch

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
Subject: fix for tty-serial-move-port
From: Alexander Beregalov <a.beregalov@gmail.com>

next-20081204 crashes with the following message:

BUG: unable to handle kernel paging request at ffff88007d320248
IP: [<ffffffff803de934>] uart_remove_one_port+0xef/0x111
                kfree(info);
     393:       49 8d 7d 10             lea    0x10(%r13),%rdi
     397:       e8 00 00 00 00          callq  39c <uart_remove_one_port+0xef>

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/serial_core.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/serial/serial_core.c~fix-for-tty-serial-move-port drivers/serial/serial_core.c
--- a/drivers/serial/serial_core.c~fix-for-tty-serial-move-port
+++ a/drivers/serial/serial_core.c
@@ -2530,10 +2530,8 @@ int uart_remove_one_port(struct uart_dri
 	/*
 	 * Kill the tasklet, and free resources.
 	 */
-	if (info) {
+	if (info)
 		tasklet_kill(&info->tlet);
-		kfree(info);
-	}
 
 	state->port = NULL;
 	mutex_unlock(&port_mutex);
_

Patches currently in -mm which might be from a.beregalov@gmail.com are

linux-next.patch
fix-for-tty-serial-move-port.patch

