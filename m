From: akpm@linux-foundation.org
Subject: + s3c2410_wdt-fix-build-breakage.patch added to -mm tree
Date: Thu, 07 Aug 2008 14:46:55 -0700
Message-ID: <200808072146.m77Lktjb007232@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52634 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752771AbYHGVsN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2008 17:48:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rmk@arm.linux.org.uk, alan@lxorguk.ukuu.org.uk, ben-linux@fluff.org, wim@iguana.be


The patch titled
     s3c2410_wdt: fix build breakage
has been added to the -mm tree.  Its filename is
     s3c2410_wdt-fix-build-breakage.patch

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
Subject: s3c2410_wdt: fix build breakage
From: Russell King <rmk@arm.linux.org.uk>

Not sure what happened, but it looks like a mismerge in
41dc8b72e37c514f7332cbc3f3dd864910c2a1fa ("s3c2410_wdt watchdog driver:
Locking and coding style").

We seem to have two functions which are almost identical called the same
thing...

  CC      drivers/watchdog/s3c2410_wdt.o
drivers/watchdog/s3c2410_wdt.c:130: error: redefinition of '__s3c2410wdt_stop'
drivers/watchdog/s3c2410_wdt.c:119: error: previous definition of '__s3c2410wdt_stop' was here
drivers/watchdog/s3c2410_wdt.c: In function `s3c2410wdt_start':
drivers/watchdog/s3c2410_wdt.c:172: warning: `return' with a value, in function returning void
drivers/watchdog/s3c2410_wdt.c: At top level:
drivers/watchdog/s3c2410_wdt.c:119: warning: '__s3c2410wdt_stop' defined but not used

Acked-by: Ben Dooks <ben-linux@fluff.org>
Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/s3c2410_wdt.c |   13 -------------
 1 file changed, 13 deletions(-)

diff -puN drivers/watchdog/s3c2410_wdt.c~s3c2410_wdt-fix-build-breakage drivers/watchdog/s3c2410_wdt.c
--- a/drivers/watchdog/s3c2410_wdt.c~s3c2410_wdt-fix-build-breakage
+++ a/drivers/watchdog/s3c2410_wdt.c
@@ -119,17 +119,6 @@ static void __s3c2410wdt_stop(void)
 {
 	unsigned long wtcon;
 
-	spin_lock(&wdt_lock);
-	wtcon = readl(wdt_base + S3C2410_WTCON);
-	wtcon &= ~(S3C2410_WTCON_ENABLE | S3C2410_WTCON_RSTEN);
-	writel(wtcon, wdt_base + S3C2410_WTCON);
-	spin_unlock(&wdt_lock);
-}
-
-static void __s3c2410wdt_stop(void)
-{
-	unsigned long wtcon;
-
 	wtcon = readl(wdt_base + S3C2410_WTCON);
 	wtcon &= ~(S3C2410_WTCON_ENABLE | S3C2410_WTCON_RSTEN);
 	writel(wtcon, wdt_base + S3C2410_WTCON);
@@ -168,8 +157,6 @@ static void s3c2410wdt_start(void)
 	writel(wdt_count, wdt_base + S3C2410_WTCNT);
 	writel(wtcon, wdt_base + S3C2410_WTCON);
 	spin_unlock(&wdt_lock);
