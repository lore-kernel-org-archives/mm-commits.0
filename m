From: akpm@linux-foundation.org
Subject: - pm2fb-replace-busy-waiting-with-cpu_relax.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:44:27 -0700
Message-ID: <200710162044.l9GKiRrw016147@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36122 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936110AbXJPVHd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:07:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     pm2fb: replace busy waiting with cpu_relax
has been removed from the -mm tree.  Its filename was
     pm2fb-replace-busy-waiting-with-cpu_relax.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pm2fb: replace busy waiting with cpu_relax
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch replaces busy waiting with the cpu_relax() call.  This makes
scrolling faster.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/pm2fb.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN drivers/video/pm2fb.c~pm2fb-replace-busy-waiting-with-cpu_relax drivers/video/pm2fb.c
--- a/drivers/video/pm2fb.c~pm2fb-replace-busy-waiting-with-cpu_relax
+++ a/drivers/video/pm2fb.c
@@ -193,8 +193,8 @@ static inline void pm2v_RDAC_WR(struct p
 #else
 static inline void WAIT_FIFO(struct pm2fb_par *p, u32 a)
 {
-	while (pm2_RD(p, PM2R_IN_FIFO_SPACE) < a);
-	mb();
+	while (pm2_RD(p, PM2R_IN_FIFO_SPACE) < a)
+		cpu_relax();
 }
 #endif
 
@@ -328,7 +328,7 @@ static void reset_card(struct pm2fb_par 
 	pm2_WR(p, PM2R_RESET_STATUS, 0);
 	mb();
 	while (pm2_RD(p, PM2R_RESET_STATUS) & PM2F_BEING_RESET)
-		;
+		cpu_relax();
 	mb();
 #ifdef CONFIG_FB_PM2_FIFO_DISCONNECT
 	DPRINTK("FIFO disconnect enabled\n");
@@ -1041,8 +1041,7 @@ static int pm2fb_sync(struct fb_info *in
 	mb();
 	do {
 		while (pm2_RD(par, PM2R_OUT_FIFO_WORDS) == 0)
-			udelay(10);
-		rmb();
+			cpu_relax();
 	} while (pm2_RD(par, PM2R_OUT_FIFO) != PM2TAG(PM2R_SYNC));
 
 	return 0;
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
git-alsa.patch
cyber2000fb-checkpatch-fixes.patch
