From: akpm@linux-foundation.org
Subject: + tridentfb-register-should-be-left-in-non-locked-state.patch added to -mm tree
Date: Wed, 05 Mar 2008 13:49:32 -0800
Message-ID: <200803052149.m25LnYG9022721@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43642 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751645AbYCEVuK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 16:50:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@pol.net


The patch titled
     tridentfb: register should be left in non-locked state
has been added to the -mm tree.  Its filename is
     tridentfb-register-should-be-left-in-non-locked-state.patch

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
Subject: tridentfb: register should be left in non-locked state
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Remove locking registers after they are unlocked during switch to/from MMIO
mode.  This fixes regression on the Blade3D (Trident 9880) caused by the
previous patch (probe fixes).

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tridentfb.c |   12 ------------
 1 file changed, 12 deletions(-)

diff -puN drivers/video/tridentfb.c~tridentfb-register-should-be-left-in-non-locked-state drivers/video/tridentfb.c
--- a/drivers/video/tridentfb.c~tridentfb-register-should-be-left-in-non-locked-state
+++ a/drivers/video/tridentfb.c
@@ -566,44 +566,32 @@ static inline void write3CE(int reg, uns
 
 static void enable_mmio(void)
 {
-	unsigned char tmp;
-
 	/* Goto New Mode */
 	outb(0x0B, 0x3C4);
 	inb(0x3C5);
 
 	/* Unprotect registers */
 	outb(NewMode1, 0x3C4);
-	tmp = inb(0x3C5);
 	outb(0x80, 0x3C5);
 
 	/* Enable MMIO */
 	outb(PCIReg, 0x3D4);
 	outb(inb(0x3D5) | 0x01, 0x3D5);
-
-	t_outb(NewMode1, 0x3C4);
-	t_outb(tmp, 0x3C5);
 }
 
 static void disable_mmio(void)
 {
-	unsigned char tmp;
-
 	/* Goto New Mode */
 	t_outb(0x0B, 0x3C4);
 	t_inb(0x3C5);
 
 	/* Unprotect registers */
 	t_outb(NewMode1, 0x3C4);
-	tmp = t_inb(0x3C5);
 	t_outb(0x80, 0x3C5);
 
 	/* Disable MMIO */
 	t_outb(PCIReg, 0x3D4);
 	t_outb(t_inb(0x3D5) & ~0x01, 0x3D5);
