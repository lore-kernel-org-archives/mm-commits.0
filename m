From: akpm@linux-foundation.org
Subject: - smc91x-make-superh-use-default-config-v2.patch removed from -mm tree
Date: Mon, 24 Mar 2008 17:19:17 -0700
Message-ID: <200803250019.m2P0JHY5032669@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48412 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753828AbYCYAUN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Mar 2008 20:20:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: magnus.damm@gmail.com, damm@igel.co.jp, jeff@garzik.org, lethal@linux-sh.org, nico@cam.org, mm-commits@vger.kernel.org


The patch titled
     smc91x: make superh use default config
has been removed from the -mm tree.  Its filename was
     smc91x-make-superh-use-default-config-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
