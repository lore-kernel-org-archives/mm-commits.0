From: akpm@linux-foundation.org
Subject: + char-tty-fix-tty_port_block_til_ready-waiting.patch added to -mm tree
Date: Tue, 23 Jun 2009 16:30:13 -0700
Message-ID: <200906232330.n5NNUDE0028354@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34078 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757869AbZFWXaU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jun 2009 19:30:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk


The patch titled
     Char: tty, fix tty_port_block_til_ready waiting
has been added to the -mm tree.  Its filename is
     char-tty-fix-tty_port_block_til_ready-waiting.patch

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
char-tty-fix-tty_port_block_til_ready-waiting.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

