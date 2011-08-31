From: akpm@linux-foundation.org
Subject: + tty-make-ppp_synctty-and-hdlc-work-with-pseudo-terminals.patch added to -mm tree
Date: Wed, 31 Aug 2011 16:43:14 -0700
Message-ID: <201108312343.p7VNhEt2002341@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38996 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755796Ab1HaXoL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Aug 2011 19:44:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: utdilya@mail.ru, alan@lxorguk.ukuu.org.uk, aneesh.kumar@linux.vnet.ibm.com, greg@kroah.com, hirofumi@mail.parknet.co.jp, torvalds@linux-foundation.org


The patch titled
     tty: make ppp_synctty and hdlc work with pseudo terminals
has been added to the -mm tree.  Its filename is
     tty-make-ppp_synctty-and-hdlc-work-with-pseudo-terminals.patch

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

tty-make-ppp_synctty-and-hdlc-work-with-pseudo-terminals.patch

