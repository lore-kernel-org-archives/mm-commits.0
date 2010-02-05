From: akpm@linux-foundation.org
Subject: + obsolete-config-in-kernel-source-lwmon5.patch added to -mm tree
Date: Fri, 05 Feb 2010 14:21:53 -0800
Message-ID: <201002052221.o15MLrgK024673@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37331 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933791Ab0BEWWc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Feb 2010 17:22:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: siccegge@stud.informatik.uni-erlangen.de


The patch titled
     obsolete config in kernel source: LWMON5
has been added to the -mm tree.  Its filename is
     obsolete-config-in-kernel-source-lwmon5.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: obsolete config in kernel source: LWMON5
From: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>

There was some conditionalizing for the LWMON5 boards in kernel source. 
However infrastructure for enabling this isn't here so probably the
special case code can go as well.

Signed-off-by: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/mb862xx/mb862xxfb.c |   13 -------------
 1 file changed, 13 deletions(-)

diff -puN drivers/video/mb862xx/mb862xxfb.c~obsolete-config-in-kernel-source-lwmon5 drivers/video/mb862xx/mb862xxfb.c
--- a/drivers/video/mb862xx/mb862xxfb.c~obsolete-config-in-kernel-source-lwmon5
+++ a/drivers/video/mb862xx/mb862xxfb.c
@@ -31,15 +31,6 @@
 #define CARMINE_MEM_SIZE	0x8000000
 #define DRV_NAME		"mb862xxfb"
 
-#if defined(CONFIG_LWMON5)
-static struct mb862xx_gc_mode lwmon5_gc_mode = {
-	/* Mode for Sharp LQ104V1DG61 TFT LCD Panel */
-	{ "640x480", 60, 640, 480, 40000, 48, 16, 32, 11, 96, 2, 0, 0, 0 },
-	/* 16 bits/pixel, 32MB, 100MHz, SDRAM memory mode value */
-	16, 0x2000000, GC_CCF_COT_100, 0x414fb7f2
-};
-#endif
-
 #if defined(CONFIG_SOCRATES)
 static struct mb862xx_gc_mode socrates_gc_mode = {
 	/* Mode for Prime View PM070WL4 TFT LCD Panel */
@@ -600,10 +591,6 @@ static int __devinit of_platform_mb862xx
 		goto irqdisp;
 	}
 
-#if defined(CONFIG_LWMON5)
-	par->gc_mode = &lwmon5_gc_mode;
-#endif
