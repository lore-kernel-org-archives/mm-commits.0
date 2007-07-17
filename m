From: akpm@linux-foundation.org
Subject: - char-istallion-initlocking-fixes-try-2.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:06:36 -0700
Message-ID: <200707172306.l6HN6aH0012035@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41745 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936169AbXGQXP3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ml@akana.de, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: istallion, init+locking fixes
has been removed from the -mm tree.  Its filename was
     char-istallion-initlocking-fixes-try-2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: istallion, init+locking fixes
From: Ingo Korb <ml@akana.de>

Move brdp->iosize assignment in stli_initecp up a few lines to stop the
driver from requesting an I/O region of length 0.

Remove spin_lock_irqsave/spin_unlock_irqrestore from __stli_sendcmd as
all users of that function take the lock already.

Signed-off-by: Ingo Korb <ml@akana.de>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/istallion.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff -puN drivers/char/istallion.c~char-istallion-initlocking-fixes-try-2 drivers/char/istallion.c
--- a/drivers/char/istallion.c~char-istallion-initlocking-fixes-try-2
+++ a/drivers/char/istallion.c
@@ -2163,14 +2163,10 @@ static void __stli_sendcmd(struct stlibr
 	cdkhdr_t __iomem *hdrp;
 	cdkctrl_t __iomem *cp;
 	unsigned char __iomem *bits;
-	unsigned long flags;
-
-	spin_lock_irqsave(&brd_lock, flags);
 
 	if (test_bit(ST_CMDING, &portp->state)) {
 		printk(KERN_ERR "STALLION: command already busy, cmd=%x!\n",
 				(int) cmd);
-		spin_unlock_irqrestore(&brd_lock, flags);
 		return;
 	}
 
@@ -2191,7 +2187,6 @@ static void __stli_sendcmd(struct stlibr
 	writeb(readb(bits) | portp->portbit, bits);
 	set_bit(ST_CMDING, &portp->state);
 	EBRDDISABLE(brdp);
-	spin_unlock_irqrestore(&brd_lock, flags);
 }
 
 static void stli_sendcmd(struct stlibrd *brdp, struct stliport *portp, unsigned long cmd, void *arg, int size, int copyback)
@@ -3215,13 +3210,13 @@ static int stli_initecp(struct stlibrd *
 		goto err;
 	}
 
+	brdp->iosize = ECP_IOSIZE;
+
 	if (!request_region(brdp->iobase, brdp->iosize, "istallion")) {
 		retval = -EIO;
 		goto err;
 	}
 
-	brdp->iosize = ECP_IOSIZE;
-
 /*
  *	Based on the specific board type setup the common vars to access
  *	and enable shared memory. Set all board specific information now
_

Patches currently in -mm which might be from ml@akana.de are

origin.patch
