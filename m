From: akpm@linux-foundation.org
Subject: - char-specialix-isr-have-2-params.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:44:21 -0800
Message-ID: <200702122244.l1CMiLCt013581@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45132 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965439AbXBLWpn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:45:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Char: specialix, isr have 2 params
has been removed from the -mm tree.  Its filename was
     char-specialix-isr-have-2-params.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: specialix, isr have 2 params
From: Jiri Slaby <jirislaby@gmail.com>

specialix, isr have 2 params

pt_regs are no longer the third parameter of isr, call sx_interrupt without
it.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/specialix.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/specialix.c~char-specialix-isr-have-2-params drivers/char/specialix.c
--- a/drivers/char/specialix.c~char-specialix-isr-have-2-params
+++ a/drivers/char/specialix.c
@@ -459,7 +459,7 @@ void missed_irq (unsigned long data)
 	if (irq) {
 		printk (KERN_INFO "Missed interrupt... Calling int from timer. \n");
 		sx_interrupt (((struct specialix_board *)data)->irq,
-		              (void*)data, NULL);
+				(void*)data);
 	}
 	missed_irq_timer.expires = jiffies + sx_poll;
 	add_timer (&missed_irq_timer);
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
git-watchdog.patch
shrink_slab-handle-bad-shrinkers.patch
