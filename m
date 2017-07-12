From: akpm@linux-foundation.org
Subject: [patch 86/96] m68k: coldfire: move inline before return
 type
Date: Wed, 12 Jul 2017 14:37:22 -0700
Message-ID: <20170712213722.eLef8eKp2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55258 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752363AbdGLVhX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2017 17:37:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, geert@linux-m68k.org, gerg@linux-m68k.org, joe@perches.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Joe Perches <joe@perches.com>
Subject: m68k: coldfire: move inline before return type

Make the code like the rest of the kernel.

Link: http://lkml.kernel.org/r/14db9c166d5b68efa77e337cfe49bb9b29bca3f7.1499284835.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Greg Ungerer <gerg@linux-m68k.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/coldfire/intc-simr.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/m68k/coldfire/intc-simr.c~m68k-coldfire-move-inline-before-return-type arch/m68k/coldfire/intc-simr.c
--- a/arch/m68k/coldfire/intc-simr.c~m68k-coldfire-move-inline-before-return-type
+++ a/arch/m68k/coldfire/intc-simr.c
@@ -35,7 +35,7 @@
 #define	EINT7	67	/* EDGE Port interrupt 7 */
 
 static unsigned int irqebitmap[] = { 0, 1, 4, 7 };
-static unsigned int inline irq2ebit(unsigned int irq)
+static inline unsigned int irq2ebit(unsigned int irq)
 {
 	return irqebitmap[irq - EINT0];
 }
@@ -51,7 +51,7 @@ static unsigned int inline irq2ebit(unsi
 #define	EINT1	65	/* EDGE Port interrupt 1 */
 #define	EINT7	71	/* EDGE Port interrupt 7 */
 
-static unsigned int inline irq2ebit(unsigned int irq)
+static inline unsigned int irq2ebit(unsigned int irq)
 {
 	return irq - EINT0;
 }
_
