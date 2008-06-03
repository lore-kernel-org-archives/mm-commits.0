From: akpm@linux-foundation.org
Subject: + smc911x-remove-unused-8-bit-i-o-operations.patch added to -mm tree
Date: Tue, 03 Jun 2008 15:46:49 -0700
Message-ID: <200806032246.m53MknAE023811@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38531 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751756AbYFCWrI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jun 2008 18:47:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: magnus.damm@gmail.com, damm@igel.co.jp, jeff@garzik.org, lethal@linux-sh.org


The patch titled
     smc911x: remove unused 8-bit I/O operations
has been added to the -mm tree.  Its filename is
     smc911x-remove-unused-8-bit-i-o-operations.patch

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
smc911x-remove-unused-8-bit-i-o-operations.patch
smc911x-fix-16-bit-i-o-operations.patch
smc911x-pass-along-private-data-and-use-iomem.patch
smc911x-introduce-platform-data-flags.patch
smc911x-superh-architecture-support.patch
video-superh-mobile-lcdc-driver.patch
video-superh-mobile-lcdc-driver-update.patch

