From: akpm@linux-foundation.org
Subject: + pm2fb-rdac_wr-barriers-clean-up.patch added to -mm tree
Date: Thu, 17 May 2007 12:00:26 -0700
Message-ID: <200705171900.l4HJ0QJk030585@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48967 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754483AbXEQTCG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 May 2007 15:02:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@gmail.com


The patch titled
     pm2fb: RDAC_WR barriers clean up
has been added to the -mm tree.  Its filename is
     pm2fb-rdac_wr-barriers-clean-up.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pm2fb: RDAC_WR barriers clean up
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch fixes a possible barriers problem in RDAC_WR functions, then remove
redudant ones.

It also removes one unneeded register load from blitter function().

Signed-off-by: Krzysztof.Helt <krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/pm2fb.c |   17 +++++------------
 1 files changed, 5 insertions(+), 12 deletions(-)

diff -puN drivers/video/pm2fb.c~pm2fb-rdac_wr-barriers-clean-up drivers/video/pm2fb.c
--- a/drivers/video/pm2fb.c~pm2fb-rdac_wr-barriers-clean-up
+++ a/drivers/video/pm2fb.c
@@ -183,15 +183,17 @@ static inline void pm2_RDAC_WR(struct pm
 		index = PM2VR_RD_INDEXED_DATA;
 		break;
 	}	
-	mb();
+	wmb();
 	pm2_WR(p, index, v);
+	wmb();
 }
 
 static inline void pm2v_RDAC_WR(struct pm2fb_par* p, s32 idx, u32 v)
 {
 	pm2_WR(p, PM2VR_RD_INDEX_LOW, idx & 0xff);
-	mb();
+	wmb();
 	pm2_WR(p, PM2VR_RD_INDEXED_DATA, v);
+	wmb();
 }
 
 #ifdef CONFIG_FB_PM2_FIFO_DISCONNECT
@@ -466,11 +468,9 @@ static void set_memclock(struct pm2fb_pa
 		WAIT_FIFO(par, 8);
 		pm2_WR(par, PM2VR_RD_INDEX_HIGH, PM2VI_RD_MCLK_CONTROL >> 8);
 		pm2v_RDAC_WR(par, PM2VI_RD_MCLK_CONTROL, 0);
-		wmb();
 		pm2v_RDAC_WR(par, PM2VI_RD_MCLK_PRESCALE, m);
 		pm2v_RDAC_WR(par, PM2VI_RD_MCLK_FEEDBACK, n);
 		pm2v_RDAC_WR(par, PM2VI_RD_MCLK_POSTSCALE, p);
-		wmb();
 		pm2v_RDAC_WR(par, PM2VI_RD_MCLK_CONTROL, 1);
 		rmb();
 		for (i = 256;
@@ -483,12 +483,9 @@ static void set_memclock(struct pm2fb_pa
 		pm2_mnp(clk, &m, &n, &p);
 		WAIT_FIFO(par, 10);
 		pm2_RDAC_WR(par, PM2I_RD_MEMORY_CLOCK_3, 6);
-		wmb();
 		pm2_RDAC_WR(par, PM2I_RD_MEMORY_CLOCK_1, m);
 		pm2_RDAC_WR(par, PM2I_RD_MEMORY_CLOCK_2, n);
-		wmb();
 		pm2_RDAC_WR(par, PM2I_RD_MEMORY_CLOCK_3, 8|p);
-		wmb();
 		pm2_RDAC_RD(par, PM2I_RD_MEMORY_CLOCK_STATUS);
 		rmb();
 		for (i = 256;
@@ -509,12 +506,9 @@ static void set_pixclock(struct pm2fb_pa
 		pm2_mnp(clk, &m, &n, &p);
 		WAIT_FIFO(par, 8);
 		pm2_RDAC_WR(par, PM2I_RD_PIXEL_CLOCK_A3, 0);
-		wmb();
 		pm2_RDAC_WR(par, PM2I_RD_PIXEL_CLOCK_A1, m);
 		pm2_RDAC_WR(par, PM2I_RD_PIXEL_CLOCK_A2, n);
-		wmb();
 		pm2_RDAC_WR(par, PM2I_RD_PIXEL_CLOCK_A3, 8|p);
-		wmb();
 		pm2_RDAC_RD(par, PM2I_RD_PIXEL_CLOCK_STATUS);
 		rmb();
 		for (i = 256;
@@ -1066,10 +1060,9 @@ static void pm2fb_block_op(struct fb_inf
 
 	if (!w || !h)
 		return;
-	WAIT_FIFO(par, 6);
+	WAIT_FIFO(par, 5);
 	pm2_WR(par, PM2R_CONFIG, PM2F_CONFIG_FB_WRITE_ENABLE |
 		PM2F_CONFIG_FB_READ_SOURCE_ENABLE);
-	pm2_WR(par, PM2R_FB_PIXEL_OFFSET, 0);
 	if (copy)
 		pm2_WR(par, PM2R_FB_SOURCE_DELTA,
 			((ysrc-y) & 0xfff) << 16 | ((xsrc-x) & 0xfff));
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

fbdev-cleanup-of-sparc-fb-options.patch
pm2fb-rdac_wr-barriers-clean-up.patch
pm3fb-various-fixes.patch
fbcon-smart-blitter-usage-for-scrolling.patch
