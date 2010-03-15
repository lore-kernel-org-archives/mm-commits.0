From: akpm@linux-foundation.org
Subject: [merged] obsolete-config-in-kernel-source-lwmon5.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:57:12 -0400
Message-ID: <201003150657.o2F6vj64016397@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41125 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934967Ab0COG6C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:58:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: siccegge@stud.informatik.uni-erlangen.de, virtuoso@slind.org, mm-commits@vger.kernel.org


The patch titled
     obsolete config in kernel source: LWMON5
has been removed from the -mm tree.  Its filename was
     obsolete-config-in-kernel-source-lwmon5.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: obsolete config in kernel source: LWMON5
From: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>

There was some conditionalizing for the LWMON5 boards in kernel source. 
However infrastructure for enabling this isn't here so probably the
special case code can go as well.

Signed-off-by: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
Acked-by: Alexander Shishkin <virtuoso@slind.org>
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
