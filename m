From: akpm@linux-foundation.org
Subject: + smc91x-make-superh-use-default-config-v2.patch added to -mm tree
Date: Wed, 27 Feb 2008 13:27:26 -0800
Message-ID: <200802272127.m1RLRQ2v031152@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:54754 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757917AbYB0V1x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 16:27:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: magnus.damm@gmail.com, damm@igel.co.jp, jeff@garzik.org, lethal@linux-sh.org, nico@cam.org


The patch titled
     smc91x: make superh use default config
has been added to the -mm tree.  Its filename is
     smc91x-make-superh-use-default-config-v2.patch

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
Subject: smc91x: make superh use default config
From: Magnus Damm <magnus.damm@gmail.com>

Removes superh board specific configuration from the header file.  These
boards will instead be configured using platform data.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
Acked-by: Nicolas Pitre <nico@cam.org>
Cc: Paul Mundt <lethal@linux-sh.org>,
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/smc91x.h |   30 ------------------------------
 1 file changed, 30 deletions(-)

diff -puN drivers/net/smc91x.h~smc91x-make-superh-use-default-config-v2 drivers/net/smc91x.h
--- a/drivers/net/smc91x.h~smc91x-make-superh-use-default-config-v2
+++ a/drivers/net/smc91x.h
@@ -292,36 +292,6 @@ SMC_outw(u16 val, void __iomem *ioaddr, 
 #define SMC_insw(a, r, p, l)	insw((a) + (r), p, l)
 #define SMC_outsw(a, r, p, l)	outsw((a) + (r), p, l)
 
-#elif   defined(CONFIG_SUPERH)
-
-#ifdef CONFIG_SOLUTION_ENGINE
-#define SMC_IRQ_FLAGS		(0)
-#define SMC_CAN_USE_8BIT       0
-#define SMC_CAN_USE_16BIT      1
-#define SMC_CAN_USE_32BIT      0
-#define SMC_IO_SHIFT           0
-#define SMC_NOWAIT             1
-
-#define SMC_inw(a, r)          inw((a) + (r))
-#define SMC_outw(v, a, r)      outw(v, (a) + (r))
-#define SMC_insw(a, r, p, l)   insw((a) + (r), p, l)
-#define SMC_outsw(a, r, p, l)  outsw((a) + (r), p, l)
-
-#else /* BOARDS */
-
-#define SMC_CAN_USE_8BIT       1
-#define SMC_CAN_USE_16BIT      1
-#define SMC_CAN_USE_32BIT      0
-
-#define SMC_inb(a, r)          inb((a) + (r))
-#define SMC_inw(a, r)          inw((a) + (r))
-#define SMC_outb(v, a, r)      outb(v, (a) + (r))
-#define SMC_outw(v, a, r)      outw(v, (a) + (r))
-#define SMC_insw(a, r, p, l)   insw((a) + (r), p, l)
-#define SMC_outsw(a, r, p, l)  outsw((a) + (r), p, l)
-
-#endif  /* BOARDS */
-
 #elif   defined(CONFIG_M32R)
 
 #define SMC_CAN_USE_8BIT	0
_

Patches currently in -mm which might be from magnus.damm@gmail.com are

smc91x-pass-along-private-data-v2.patch
smc91x-introduce-platform-data-flags-v2.patch
smc91x-add-insw-outsw-to-default-config-v2.patch
smc91x-make-superh-use-default-config-v2.patch
sh-revert-dreamcast-pci-change.patch
sm501-add-uart-support.patch
