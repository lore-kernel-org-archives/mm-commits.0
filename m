From: akpm@linux-foundation.org
Subject: + uml-fix-tty-related-build-error.patch added to -mm tree
Date: Tue, 29 Jul 2008 00:02:05 -0700
Message-ID: <200807290702.m6T72556020043@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56892 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752648AbYG2HD7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 03:03:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiyou.wangcong@gmail.com, alan@redhat.com, jdike@addtoit.com, wangcong@zeuux.org


The patch titled
     uml: fix tty-related build error
has been added to the -mm tree.  Its filename is
     uml-fix-tty-related-build-error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: fix tty-related build error
From: WANG Cong <xiyou.wangcong@gmail.com>

  /home/wangcong/Projects/linux-2.6/arch/um/drivers/line.c: In function `line_write_interrupt':
/home/wangcong/Projects/linux-2.6/arch/um/drivers/line.c:366: error: `struct tty_ldisc' has no member named `write_wakeup'
/home/wangcong/Projects/linux-2.6/arch/um/drivers/line.c:367: error: `struct tty_ldisc' has no member named `write_wakeup'

Signed-off-by: WANG Cong <wangcong@zeuux.org>
Cc: Jeff Dike <jdike@addtoit.com>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/line.c |   14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff -puN arch/um/drivers/line.c~uml-fix-tty-related-build-error arch/um/drivers/line.c
--- a/arch/um/drivers/line.c~uml-fix-tty-related-build-error
+++ a/arch/um/drivers/line.c
@@ -362,19 +362,7 @@ static irqreturn_t line_write_interrupt(
 	if (tty == NULL)
 		return IRQ_NONE;
 
-	if (test_bit(TTY_DO_WRITE_WAKEUP, &tty->flags) &&
-	   (tty->ldisc.write_wakeup != NULL))
-		(tty->ldisc.write_wakeup)(tty);
-
-	/*
-	 * BLOCKING mode
-	 * In blocking mode, everything sleeps on tty->write_wait.
-	 * Sleeping in the console driver would break non-blocking
-	 * writes.
-	 */
