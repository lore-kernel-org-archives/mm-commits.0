From: akpm@linux-foundation.org
Subject: - smc911x-remove-unused-8-bit-i-o-operations.patch removed from -mm tree
Date: Sun, 15 Jun 2008 23:04:18 -0700
Message-ID: <200806160604.m5G64IeB010675@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44808 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751696AbYFPGEa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jun 2008 02:04:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: magnus.damm@gmail.com, damm@igel.co.jp, jeff@garzik.org, lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     smc911x: remove unused 8-bit I/O operations
has been removed from the -mm tree.  Its filename was
     smc911x-remove-unused-8-bit-i-o-operations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: smc911x: remove unused 8-bit I/O operations
From: Magnus Damm <magnus.damm@gmail.com>

Remove unused SMC_inb() and SMC_outb() functions.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/smc911x.h |    4 ----
 1 file changed, 4 deletions(-)

diff -puN drivers/net/smc911x.h~smc911x-remove-unused-8-bit-i-o-operations drivers/net/smc911x.h
--- a/drivers/net/smc911x.h~smc911x-remove-unused-8-bit-i-o-operations
+++ a/drivers/net/smc911x.h
@@ -50,10 +50,8 @@
  */
 
 #if	SMC_USE_16BIT
-#define SMC_inb(a, r)			 readb((a) + (r))
 #define SMC_inw(a, r)			 readw((a) + (r))
 #define SMC_inl(a, r)			 ((SMC_inw(a, r) & 0xFFFF)+(SMC_inw(a+2, r)<<16))
-#define SMC_outb(v, a, r)		 writeb(v, (a) + (r))
 #define SMC_outw(v, a, r)		 writew(v, (a) + (r))
 #define SMC_outl(v, a, r) 			 \
 	do{					 \
@@ -64,10 +62,8 @@
 #define SMC_outsl(a, r, p, l)	 writesw((short*)((a) + (r)), p, l*2)
 
 #elif	SMC_USE_32BIT
-#define SMC_inb(a, r)		 readb((a) + (r))
 #define SMC_inw(a, r)		 readw((a) + (r))
 #define SMC_inl(a, r)		 readl((a) + (r))
-#define SMC_outb(v, a, r)	 writeb(v, (a) + (r))
 #define SMC_outl(v, a, r)	 writel(v, (a) + (r))
 #define SMC_insl(a, r, p, l)	 readsl((int*)((a) + (r)), p, l)
 #define SMC_outsl(a, r, p, l)	 writesl((int*)((a) + (r)), p, l)
_

Patches currently in -mm which might be from magnus.damm@gmail.com are

linux-next.patch
video-superh-mobile-lcdc-driver.patch
video-superh-mobile-lcdc-driver-update.patch

