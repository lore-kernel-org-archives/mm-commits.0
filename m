From: akpm@linux-foundation.org
Subject: + arm-samsung-remove-pixclock-from-several-boards.patch added to -mm tree
Date: Thu, 15 Jul 2010 12:36:23 -0700
Message-ID: <201007151936.o6FJaNdT015168@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36312 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934474Ab0GOTgz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Jul 2010 15:36:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mcuelenaere@gmail.com, ben-linux@fluff.org, inki.dae@samsung.com, kyungmin.park@samsung.com, m.szyprowski@samsung.com, p.osciak@samsung.com, rmk@arm.linux.org.uk


The patch titled
     arm: samsung: remove pixclock from several boards
has been added to the -mm tree.  Its filename is
     arm-samsung-remove-pixclock-from-several-boards.patch

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
Subject: arm: samsung: remove pixclock from several boards
From: Maurus Cuelenaere <mcuelenaere@gmail.com>

Since "s3c-fb: Automatically calculate pixel clock when none is given",
there's no need for manually calculating the pixel clock anymore so remove
these lines and add the correct refresh rate where appropriately.

Signed-off-by: Maurus Cuelenaere <mcuelenaere@gmail.com>
Cc: Pawel Osciak <p.osciak@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: InKi Dae <inki.dae@samsung.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-s3c64xx/mach-anw6410.c  |    1 -
 arch/arm/mach-s3c64xx/mach-hmt.c      |    1 -
 arch/arm/mach-s3c64xx/mach-smartq5.c  |    3 +--
 arch/arm/mach-s3c64xx/mach-smartq7.c  |    3 +--
 arch/arm/mach-s3c64xx/mach-smdk6410.c |    1 -
 arch/arm/mach-s5pc100/mach-smdkc100.c |    2 +-
 arch/arm/mach-s5pv210/mach-aquila.c   |    2 --
 7 files changed, 3 insertions(+), 10 deletions(-)

diff -puN arch/arm/mach-s3c64xx/mach-anw6410.c~arm-samsung-remove-pixclock-from-several-boards arch/arm/mach-s3c64xx/mach-anw6410.c
--- a/arch/arm/mach-s3c64xx/mach-anw6410.c~arm-samsung-remove-pixclock-from-several-boards
+++ a/arch/arm/mach-s3c64xx/mach-anw6410.c
@@ -134,7 +134,6 @@ static struct platform_device anw6410_lc
 static struct s3c_fb_pd_win anw6410_fb_win0 = {
 	/* this is to ensure we use win0 */
 	.win_mode	= {
-		.pixclock	= 41094,
 		.left_margin	= 8,
 		.right_margin	= 13,
 		.upper_margin	= 7,
diff -puN arch/arm/mach-s3c64xx/mach-hmt.c~arm-samsung-remove-pixclock-from-several-boards arch/arm/mach-s3c64xx/mach-hmt.c
--- a/arch/arm/mach-s3c64xx/mach-hmt.c~arm-samsung-remove-pixclock-from-several-boards
+++ a/arch/arm/mach-s3c64xx/mach-hmt.c
@@ -128,7 +128,6 @@ static struct platform_device hmt_backli
 
 static struct s3c_fb_pd_win hmt_fb_win0 = {
 	.win_mode	= {
-		.pixclock	= 41094,
 		.left_margin	= 8,
 		.right_margin	= 13,
 		.upper_margin	= 7,
diff -puN arch/arm/mach-s3c64xx/mach-smartq5.c~arm-samsung-remove-pixclock-from-several-boards arch/arm/mach-s3c64xx/mach-smartq5.c
--- a/arch/arm/mach-s3c64xx/mach-smartq5.c~arm-samsung-remove-pixclock-from-several-boards
+++ a/arch/arm/mach-s3c64xx/mach-smartq5.c
@@ -134,8 +134,6 @@ static struct platform_device smartq5_bu
 
 static struct s3c_fb_pd_win smartq5_fb_win0 = {
 	.win_mode	= {
-		.pixclock	= 1000000000000ULL /
-				((40+1+216+800)*(10+1+35+480)*80),
 		.left_margin	= 40,
 		.right_margin	= 216,
 		.upper_margin	= 10,
@@ -144,6 +142,7 @@ static struct s3c_fb_pd_win smartq5_fb_w
 		.vsync_len	= 1,
 		.xres		= 800,
 		.yres		= 480,
+		.refresh	= 80,
 	},
 	.max_bpp	= 32,
 	.default_bpp	= 16,
diff -puN arch/arm/mach-s3c64xx/mach-smartq7.c~arm-samsung-remove-pixclock-from-several-boards arch/arm/mach-s3c64xx/mach-smartq7.c
--- a/arch/arm/mach-s3c64xx/mach-smartq7.c~arm-samsung-remove-pixclock-from-several-boards
+++ a/arch/arm/mach-s3c64xx/mach-smartq7.c
@@ -150,8 +150,6 @@ static struct platform_device smartq7_bu
 
 static struct s3c_fb_pd_win smartq7_fb_win0 = {
 	.win_mode	= {
-		.pixclock	= 1000000000000ULL /
-				((3+10+5+800)*(1+3+20+480)*80),
 		.left_margin	= 3,
 		.right_margin	= 5,
 		.upper_margin	= 1,
@@ -160,6 +158,7 @@ static struct s3c_fb_pd_win smartq7_fb_w
 		.vsync_len	= 3,
 		.xres		= 800,
 		.yres		= 480,
+		.refresh	= 80,
 	},
 	.max_bpp	= 32,
 	.default_bpp	= 16,
diff -puN arch/arm/mach-s3c64xx/mach-smdk6410.c~arm-samsung-remove-pixclock-from-several-boards arch/arm/mach-s3c64xx/mach-smdk6410.c
--- a/arch/arm/mach-s3c64xx/mach-smdk6410.c~arm-samsung-remove-pixclock-from-several-boards
+++ a/arch/arm/mach-s3c64xx/mach-smdk6410.c
@@ -142,7 +142,6 @@ static struct platform_device smdk6410_l
 static struct s3c_fb_pd_win smdk6410_fb_win0 = {
 	/* this is to ensure we use win0 */
 	.win_mode	= {
-		.pixclock	= 41094,
 		.left_margin	= 8,
 		.right_margin	= 13,
 		.upper_margin	= 7,
diff -puN arch/arm/mach-s5pc100/mach-smdkc100.c~arm-samsung-remove-pixclock-from-several-boards arch/arm/mach-s5pc100/mach-smdkc100.c
--- a/arch/arm/mach-s5pc100/mach-smdkc100.c~arm-samsung-remove-pixclock-from-several-boards
+++ a/arch/arm/mach-s5pc100/mach-smdkc100.c
@@ -131,7 +131,6 @@ static struct platform_device smdkc100_l
 static struct s3c_fb_pd_win smdkc100_fb_win0 = {
 	/* this is to ensure we use win0 */
 	.win_mode	= {
-		.pixclock = 1000000000000ULL / ((8+13+3+800)*(7+5+1+480)*80),
 		.left_margin	= 8,
 		.right_margin	= 13,
 		.upper_margin	= 7,
@@ -140,6 +139,7 @@ static struct s3c_fb_pd_win smdkc100_fb_
 		.vsync_len	= 1,
 		.xres		= 800,
 		.yres		= 480,
+		.refresh	= 80,
 	},
 	.max_bpp	= 32,
 	.default_bpp	= 16,
diff -puN arch/arm/mach-s5pv210/mach-aquila.c~arm-samsung-remove-pixclock-from-several-boards arch/arm/mach-s5pv210/mach-aquila.c
--- a/arch/arm/mach-s5pv210/mach-aquila.c~arm-samsung-remove-pixclock-from-several-boards
+++ a/arch/arm/mach-s5pv210/mach-aquila.c
@@ -90,7 +90,6 @@ static struct s3c2410_uartcfg aquila_uar
 /* Frame Buffer */
 static struct s3c_fb_pd_win aquila_fb_win0 = {
 	.win_mode = {
-		.pixclock = 1000000000000ULL / ((16+16+2+480)*(28+3+2+800)*60),
 		.left_margin = 16,
 		.right_margin = 16,
 		.upper_margin = 3,
@@ -106,7 +105,6 @@ static struct s3c_fb_pd_win aquila_fb_wi
 
 static struct s3c_fb_pd_win aquila_fb_win1 = {
 	.win_mode = {
-		.pixclock = 1000000000000ULL / ((16+16+2+480)*(28+3+2+800)*60),
 		.left_margin = 16,
 		.right_margin = 16,
 		.upper_margin = 3,
_

Patches currently in -mm which might be from mcuelenaere@gmail.com are

linux-next.patch
s3c-fb-automatically-calculate-pixel-clock-when-none-is-given.patch
arm-samsung-remove-pixclock-from-several-boards.patch

