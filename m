From: akpm@linux-foundation.org
Subject: + drivers-char-amiserialc-remove-unused-variable-icount.patch added to -mm tree
Date: Thu, 28 Oct 2010 15:19:06 -0700
Message-ID: <201010282219.o9SMJ6vU024532@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51876 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751725Ab0J1WTw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Oct 2010 18:19:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org, greg@kroah.com


The patch titled
     drivers/char/amiserial.c: remove unused variable icount
has been added to the -mm tree.  Its filename is
     drivers-char-amiserialc-remove-unused-variable-icount.patch

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
Subject: drivers/char/amiserial.c: remove unused variable icount
From: Geert Uytterhoeven <geert@linux-m68k.org>

drivers/char/amiserial.c: In function `rs_ioctl':
drivers/char/amiserial.c:1302: warning: unused variable `icount'

commit 0587102cf9f427c185bfdeb2cef41e13ee0264b1 ("tty: icount changeover
for other main devices") removed the users, but not the actual variable.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/amiserial.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/char/amiserial.c~drivers-char-amiserialc-remove-unused-variable-icount drivers/char/amiserial.c
--- a/drivers/char/amiserial.c~drivers-char-amiserialc-remove-unused-variable-icount
+++ a/drivers/char/amiserial.c
@@ -1299,7 +1299,6 @@ static int rs_ioctl(struct tty_struct *t
 {
 	struct async_struct * info = tty->driver_data;
 	struct async_icount cprev, cnow;	/* kernel counter temps */
-	struct serial_icounter_struct icount;
 	void __user *argp = (void __user *)arg;
 	unsigned long flags;
 
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
drivers-macintosh-adb-iopc-flags-should-be-unsigned-long.patch
linux-next.patch
drivers-char-amiserialc-remove-unused-variable-icount.patch

