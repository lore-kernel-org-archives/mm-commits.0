From: akpm@linux-foundation.org
Subject: - smc91x-sh-solution-engine-fixes.patch removed from -mm tree
Date: Mon, 04 Jun 2007 13:56:40 -0700
Message-ID: <200706042056.l54KucGm018912@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48452 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758070AbXFDU4q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jun 2007 16:56:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     smc91x: sh solution engine fixes
has been removed from the -mm tree.  Its filename was
     smc91x-sh-solution-engine-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: smc91x: sh solution engine fixes
From: Paul Mundt <lethal@linux-sh.org>

The current smc91x I/O routines ifdef the solution engine subtypes
individually, which is rather bogus, as they can simply use
CONFIG_SOLUTION_ENGINE instead.  This fixes it for some of the other
solution engines that weren't included in the ifdef list (SH7206
specifically).

There are also inb/outb definitions which are totally bogus (missing
brackets in _both_ cases, SMC_CAN_USE_8BIT == 0, and even better, they try
to use a 16-bit access to fake 8-bit access).  Kill that nonsense off
completely.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/smc91x.h |    5 +----
 1 files changed, 1 insertion(+), 4 deletions(-)

diff -puN drivers/net/smc91x.h~smc91x-sh-solution-engine-fixes drivers/net/smc91x.h
--- a/drivers/net/smc91x.h~smc91x-sh-solution-engine-fixes
+++ a/drivers/net/smc91x.h
@@ -281,17 +281,14 @@ SMC_outw(u16 val, void __iomem *ioaddr, 
 
 #elif   defined(CONFIG_SUPERH)
 
-#if defined(CONFIG_SH_7780_SOLUTION_ENGINE) || defined(CONFIG_SH_7722_SOLUTION_ENGINE)
+#ifdef CONFIG_SOLUTION_ENGINE
 #define SMC_CAN_USE_8BIT       0
 #define SMC_CAN_USE_16BIT      1
 #define SMC_CAN_USE_32BIT      0
 #define SMC_IO_SHIFT           0
 #define SMC_NOWAIT             1
 
-#define SMC_inb(a, r)          (inw((a) + ((r)&~1)) >> (8*(r%2)))&0xff
 #define SMC_inw(a, r)          inw((a) + (r))
-#define SMC_outb(v, a, r)      outw(((inw((a)+((r)&~1))*(0xff<<8*(r%2)))) | ((v)<<(8*(r&2)))), (a) + ((r)&~1))
-
 #define SMC_outw(v, a, r)      outw(v, (a) + (r))
 #define SMC_insw(a, r, p, l)   insw((a) + (r), p, l)
 #define SMC_outsw(a, r, p, l)  outsw((a) + (r), p, l)
_

Patches currently in -mm which might be from lethal@linux-sh.org are

origin.patch
lots-of-architectures-enable-arbitary-speed-tty-support.patch
git-sh.patch
slab-fix-slab-debug-for-non-alien-caches.patch
pvr2fb-fix-pseudo_palette-array-overrun-and-typecast.patch
