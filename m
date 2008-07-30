From: akpm@linux-foundation.org
Subject: - uml-fix-tty-related-build-error.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:14:53 -0700
Message-ID: <200807301914.m6UJErPi010940@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50729 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752592AbYG3TPo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:15:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiyou.wangcong@gmail.com, alan@redhat.com, jdike@addtoit.com, wangcong@zeuux.org, mm-commits@vger.kernel.org


The patch titled
     uml: fix tty-related build error
has been removed from the -mm tree.  Its filename was
     uml-fix-tty-related-build-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
