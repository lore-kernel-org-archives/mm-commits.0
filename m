From: akpm@linux-foundation.org
Subject: + pm2fb-permedia-2v-memory-clock-setting.patch added to -mm tree
Date: Wed, 25 Apr 2007 17:33:27 -0700
Message-ID: <200704260033.l3Q0XRx8017023@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43489 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423453AbXDZAda (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 20:33:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@gmail.com


The patch titled
     pm2fb: Permedia 2V memory clock setting
has been added to the -mm tree.  Its filename is
     pm2fb-permedia-2v-memory-clock-setting.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pm2fb: Permedia 2V memory clock setting
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Permedia 2V uses its own registers to set a memory clock. The
patch adds these registers and uses them in the set_memclock()
function.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/pm2fb.c     |   52 +++++++++++++++++++++++++-----------
 include/video/permedia2.h |    4 ++
 2 files changed, 41 insertions(+), 15 deletions(-)

diff -puN drivers/video/pm2fb.c~pm2fb-permedia-2v-memory-clock-setting drivers/video/pm2fb.c
--- a/drivers/video/pm2fb.c~pm2fb-permedia-2v-memory-clock-setting
+++ a/drivers/video/pm2fb.c
@@ -462,21 +462,43 @@ static void set_memclock(struct pm2fb_pa
 	int i;
 	unsigned char m, n, p;
 
-	pm2_mnp(clk, &m, &n, &p);
-	WAIT_FIFO(par, 10);
-	pm2_RDAC_WR(par, PM2I_RD_MEMORY_CLOCK_3, 6);
-	wmb();
-	pm2_RDAC_WR(par, PM2I_RD_MEMORY_CLOCK_1, m);
-	pm2_RDAC_WR(par, PM2I_RD_MEMORY_CLOCK_2, n);
-	wmb();
-	pm2_RDAC_WR(par, PM2I_RD_MEMORY_CLOCK_3, 8|p);
-	wmb();
-	pm2_RDAC_RD(par, PM2I_RD_MEMORY_CLOCK_STATUS);
-	rmb();
-	for (i = 256;
-	     i && !(pm2_RD(par, PM2R_RD_INDEXED_DATA) & PM2F_PLL_LOCKED);
-	     i--)
-		;
+	switch (par->type) {
+	case PM2_TYPE_PERMEDIA2V:
+		pm2v_mnp(clk/2, &m, &n, &p);
+		WAIT_FIFO(par, 8);
+		pm2_WR(par, PM2VR_RD_INDEX_HIGH, PM2VI_RD_MCLK_CONTROL >> 8);
+		pm2v_RDAC_WR(par, PM2VI_RD_MCLK_CONTROL, 0);
+		wmb();
+		pm2v_RDAC_WR(par, PM2VI_RD_MCLK_PRESCALE, m);
+		pm2v_RDAC_WR(par, PM2VI_RD_MCLK_FEEDBACK, n);
+		pm2v_RDAC_WR(par, PM2VI_RD_MCLK_POSTSCALE, p);
+		wmb();
+		pm2v_RDAC_WR(par, PM2VI_RD_MCLK_CONTROL, 1);
+		rmb();
+		for (i = 256;
+		     i && !(pm2_RDAC_RD(par, PM2VI_RD_MCLK_CONTROL) & 2);
+		     i--)
+			;
+		pm2_WR(par, PM2VR_RD_INDEX_HIGH, 0);
+		break;
+	case PM2_TYPE_PERMEDIA2:
+		pm2_mnp(clk, &m, &n, &p);
+		WAIT_FIFO(par, 10);
+		pm2_RDAC_WR(par, PM2I_RD_MEMORY_CLOCK_3, 6);
+		wmb();
+		pm2_RDAC_WR(par, PM2I_RD_MEMORY_CLOCK_1, m);
+		pm2_RDAC_WR(par, PM2I_RD_MEMORY_CLOCK_2, n);
+		wmb();
+		pm2_RDAC_WR(par, PM2I_RD_MEMORY_CLOCK_3, 8|p);
+		wmb();
+		pm2_RDAC_RD(par, PM2I_RD_MEMORY_CLOCK_STATUS);
+		rmb();
+		for (i = 256;
+		     i && !(pm2_RD(par, PM2R_RD_INDEXED_DATA) & PM2F_PLL_LOCKED);
+		     i--)
+			;
+		break;
+	}
 }
 
 static void set_pixclock(struct pm2fb_par* par, u32 clk)
diff -puN include/video/permedia2.h~pm2fb-permedia-2v-memory-clock-setting include/video/permedia2.h
--- a/include/video/permedia2.h~pm2fb-permedia-2v-memory-clock-setting
+++ a/include/video/permedia2.h
@@ -154,6 +154,10 @@
 #define PM2VI_RD_CLK1_PRESCALE				0x204
 #define PM2VI_RD_CLK1_FEEDBACK				0x205
 #define PM2VI_RD_CLK1_POSTSCALE				0x206
+#define PM2VI_RD_MCLK_CONTROL				0x20D
+#define PM2VI_RD_MCLK_PRESCALE				0x20E
+#define PM2VI_RD_MCLK_FEEDBACK				0x20F
+#define PM2VI_RD_MCLK_POSTSCALE				0x210
 #define PM2VI_RD_CURSOR_PALETTE				0x303
 #define PM2VI_RD_CURSOR_PATTERN				0x400
 
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

skeletonfb-various-corrections.patch
pm2fb-3dlabs-permedia-2v-reference-board-added.patch
pm2fb-permedia-2v-memory-clock-setting.patch
pm2fb-pixclock-setting-restriction.patch
