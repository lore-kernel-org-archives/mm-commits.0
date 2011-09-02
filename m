From: akpm@linux-foundation.org
Subject: [nacked] tty-make-ppp_synctty-and-hdlc-work-with-pseudo-terminals.patch removed from -mm tree
Date: Fri, 02 Sep 2011 16:26:48 -0700
Message-ID: <201109022326.p82NQmNQ016731@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55067 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750724Ab1IBX1F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Sep 2011 19:27:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: utdilya@mail.ru, alan@lxorguk.ukuu.org.uk, aneesh.kumar@linux.vnet.ibm.com, greg@kroah.com, hirofumi@mail.parknet.co.jp, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     tty: make ppp_synctty and hdlc work with pseudo terminals
has been removed from the -mm tree.  Its filename was
     tty-make-ppp_synctty-and-hdlc-work-with-pseudo-terminals.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tty: make ppp_synctty and hdlc work with pseudo terminals
From: ilya <utdilya@mail.ru>

Taken from https://bugzilla.kernel.org/show_bug.cgi?id=40482.

If frames are sent very fast from one side(master/slave) to other one,
the frames merge in one (merge point "flip buffer") and the other side can read
only one big frame. But sync line disciplines need one frame in one read.

To push one frame to ldisc I propose this small patch.  It fixes a
regression introduced by commit e043e42bdb6 ("pty: avoid forcing
'low_latency' tty flag").

Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/tty/pty.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/tty/pty.c~tty-make-ppp_synctty-and-hdlc-work-with-pseudo-terminals drivers/tty/pty.c
--- a/drivers/tty/pty.c~tty-make-ppp_synctty-and-hdlc-work-with-pseudo-terminals
+++ a/drivers/tty/pty.c
@@ -221,6 +221,7 @@ static int pty_open(struct tty_struct *t
 	clear_bit(TTY_OTHER_CLOSED, &tty->link->flags);
 	set_bit(TTY_THROTTLED, &tty->flags);
 	retval = 0;
+	tty->low_latency = 1;
 out:
 	return retval;
 }
_

Patches currently in -mm which might be from utdilya@mail.ru are


