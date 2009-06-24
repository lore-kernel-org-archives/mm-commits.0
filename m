From: akpm@linux-foundation.org
Subject: [merged] char-tty-fix-tty_port_block_til_ready-waiting.patch removed from -mm tree
Date: Wed, 24 Jun 2009 12:11:17 -0700
Message-ID: <200906241911.n5OJBH8w011517@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43862 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758683AbZFXTLX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jun 2009 15:11:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     Char: tty, fix tty_port_block_til_ready waiting
has been removed from the -mm tree.  Its filename was
     char-tty-fix-tty_port_block_til_ready-waiting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Char: tty, fix tty_port_block_til_ready waiting
From: Jiri Slaby <jirislaby@gmail.com>

Since commit 3e3b5c087799e536871c8261b05bc28e4783c8da ("tty: use
prepare/finish_wait"), tty_port_block_til_ready() is using
prepare_to_wait()/finish_wait().  Those functions require that the
wait_queue_t be initialised with .func=autoremove_wake_function, via
DEFINE_WAIT().

But the conversion from DECLARE_WAITQUEUE() to DEFINE_WAIT() was not made,
so this code will oops in finish_wait().

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tty_port.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/tty_port.c~char-tty-fix-tty_port_block_til_ready-waiting drivers/char/tty_port.c
--- a/drivers/char/tty_port.c~char-tty-fix-tty_port_block_til_ready-waiting
+++ a/drivers/char/tty_port.c
@@ -193,7 +193,7 @@ int tty_port_block_til_ready(struct tty_
 {
 	int do_clocal = 0, retval;
 	unsigned long flags;
-	DECLARE_WAITQUEUE(wait, current);
+	DEFINE_WAIT(wait);
 	int cd;
 
 	/* block if port is in the process of being closed */
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
linux-next.patch
icom-converting-space-to-tabs.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

