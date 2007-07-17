From: akpm@linux-foundation.org
Subject: - fb-epson1355fb-kill-off-dead-sh-support.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:08:01 -0700
Message-ID: <200707172308.l6HN81GV012241@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50405 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936014AbXGQXP0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lethal@linux-sh.org, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fb: epson1355fb: kill off dead sh support
has been removed from the -mm tree.  Its filename was
     fb-epson1355fb-kill-off-dead-sh-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fb: epson1355fb: kill off dead sh support
From: Paul Mundt <lethal@linux-sh.org>

The SH board that was the only user for this code was removed entirely from
the kernel quite some time ago, so there's no reason to leave the stubs in
place.  Additionally this driver was completely broken anyways, so there's
not really a lot of point in fixing it up either.

I can't imagine that this driver gets any testing on ARM either, given that
FB_BLANK_UNBLANKING doesn't exist, and kills the build regardless of which
platform is compiling.  This fixes that, too.

It wouldn't be a lot of work to finish the platform device conversion and
go with a generic 8-bit read/write_reg and kill off the architecture
dependence completely, should someone have any use for this driver.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Acked-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Kconfig       |    2 +-
 drivers/video/epson1355fb.c |   16 ++--------------
 2 files changed, 3 insertions(+), 15 deletions(-)

diff -puN drivers/video/Kconfig~fb-epson1355fb-kill-off-dead-sh-support drivers/video/Kconfig
--- a/drivers/video/Kconfig~fb-epson1355fb-kill-off-dead-sh-support
+++ a/drivers/video/Kconfig
@@ -812,7 +812,7 @@ config FB_PVR2
 
 config FB_EPSON1355
 	bool "Epson 1355 framebuffer support"
-	depends on (FB = y) && (SUPERH || ARCH_CEIVA)
+	depends on (FB = y) && ARCH_CEIVA
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
diff -puN drivers/video/epson1355fb.c~fb-epson1355fb-kill-off-dead-sh-support drivers/video/epson1355fb.c
--- a/drivers/video/epson1355fb.c~fb-epson1355fb-kill-off-dead-sh-support
+++ a/drivers/video/epson1355fb.c
@@ -68,19 +68,7 @@ struct epson1355_par {
 
 /* ------------------------------------------------------------------------- */
 
-#ifdef CONFIG_SUPERH
-
-static inline u8 epson1355_read_reg(int index)
-{
-	return ctrl_inb(par.reg_addr + index);
-}
-
-static inline void epson1355_write_reg(u8 data, int index)
-{
-	ctrl_outb(data, par.reg_addr + index);
-}
-
-#elif defined(CONFIG_ARM)
+#if defined(CONFIG_ARM)
 
 # ifdef CONFIG_ARCH_CEIVA
 #  include <asm/arch/hardware.h>
@@ -290,7 +278,7 @@ static int epson1355fb_blank(int blank_m
 	struct epson1355_par *par = info->par;
 
 	switch (blank_mode) {
-	case FB_BLANK_UNBLANKING:
+	case FB_BLANK_UNBLANK:
 	case FB_BLANK_NORMAL:
 		lcd_enable(par, 1);
 		backlight_enable(1);
_

Patches currently in -mm which might be from lethal@linux-sh.org are

origin.patch
git-sh.patch
nohz-fix-nohz-x86-dyntick-idle-handling.patch
