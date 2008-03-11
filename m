From: akpm@linux-foundation.org
Subject: - tridentfb-register-should-be-left-in-non-locked-state.patch removed from -mm tree
Date: Mon, 10 Mar 2008 20:21:38 -0700
Message-ID: <200803110321.m2B3Lc5R019733@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40421 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751875AbYCKDWJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 23:22:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     tridentfb: register should be left in non-locked state
has been removed from the -mm tree.  Its filename was
     tridentfb-register-should-be-left-in-non-locked-state.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
