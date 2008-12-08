From: akpm@linux-foundation.org
Subject: - fix-for-tty-serial-move-port.patch removed from -mm tree
Date: Mon, 08 Dec 2008 15:24:03 -0800
Message-ID: <200812082324.mB8NO4pt006746@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57143 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753053AbYLHXYO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Dec 2008 18:24:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.beregalov@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     fix for tty-serial-move-port
has been removed from the -mm tree.  Its filename was
     fix-for-tty-serial-move-port.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

