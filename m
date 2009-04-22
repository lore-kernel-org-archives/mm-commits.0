From: akpm@linux-foundation.org
Subject: [merged] char-cyclades-remove-spurious-check-in-isr.patch removed from -mm tree
Date: Wed, 22 Apr 2009 11:31:36 -0700
Message-ID: <200904221831.n3MIVavU006849@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40875 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753462AbZDVSeJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Apr 2009 14:34:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     char: cyclades, remove spurious check in ISR
has been removed from the -mm tree.  Its filename was
     char-cyclades-remove-spurious-check-in-isr.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
