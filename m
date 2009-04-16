From: akpm@linux-foundation.org
Subject: + char-cyclades-remove-spurious-check-in-isr.patch added to -mm tree
Date: Thu, 16 Apr 2009 16:51:25 -0700
Message-ID: <200904162351.n3GNpPqG032566@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33694 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757791AbZDPXxQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Apr 2009 19:53:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk


The patch titled
     char: cyclades, remove spurious check in ISR
has been added to the -mm tree.  Its filename is
     char-cyclades-remove-spurious-check-in-isr.patch

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
Subject: char: cyclades, remove spurious check in ISR
From: Jiri Slaby <jirislaby@gmail.com>

No need to check if dev_id is NULL, it never is.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c |    8 --------
 1 file changed, 8 deletions(-)

diff -puN drivers/char/cyclades.c~char-cyclades-remove-spurious-check-in-isr drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~char-cyclades-remove-spurious-check-in-isr
+++ a/drivers/char/cyclades.c
@@ -1737,14 +1737,6 @@ static irqreturn_t cyz_interrupt(int irq
 {
 	struct cyclades_card *cinfo = dev_id;
 
-	if (unlikely(cinfo == NULL)) {
-#ifdef CY_DEBUG_INTERRUPTS
-		printk(KERN_DEBUG "cyz_interrupt: spurious interrupt %d\n",
-									irq);
-#endif
-		return IRQ_NONE;	/* spurious interrupt */
-	}
