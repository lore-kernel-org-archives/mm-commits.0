From: akpm@linux-foundation.org
Subject: + s3c-fb-fix-distortedness-situation-for-the-mode-more-then-24bpp.patch added to -mm tree
Date: Fri, 09 Jul 2010 16:08:48 -0700
Message-ID: <201007092308.o69N8nXo030945@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60307 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755403Ab0GIXJV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jul 2010 19:09:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: inki.dae@samsung.com, ben-linux@fluff.org, m.szyprowski@samsung.com, p.osciak@samsung.com


The patch titled
     s3c-fb: fix distortedness situation for the mode more then 24bpp
has been added to the -mm tree.  Its filename is
     s3c-fb-fix-distortedness-situation-for-the-mode-more-then-24bpp.patch

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
Subject: s3c-fb: fix distortedness situation for the mode more then 24bpp
From: InKi Dae <inki.dae@samsung.com>

It has been working fine at 16bpp but in case of pixel format more then
24bpp it would occur distortedness situation on that mode.  so this patch
set the word swap control bit of WINCONx to 1 as default value.  but it
should be set to 0 in case that each ENLOCAL bit of WINCON0 ~ 2 registers
is enabled.  this issue would be solved with local path feature soon.

Signed-off-by: InKi Dae <inki.dae@samsung.com>
Reviewed-by: KyungMin Park <kyungmin.park.samsung.com>
Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/plat-samsung/include/plat/regs-fb.h |    1 +
 drivers/video/s3c-fb.c                       |    1 +
 2 files changed, 2 insertions(+)

diff -puN arch/arm/plat-samsung/include/plat/regs-fb.h~s3c-fb-fix-distortedness-situation-for-the-mode-more-then-24bpp arch/arm/plat-samsung/include/plat/regs-fb.h
--- a/arch/arm/plat-samsung/include/plat/regs-fb.h~s3c-fb-fix-distortedness-situation-for-the-mode-more-then-24bpp
+++ a/arch/arm/plat-samsung/include/plat/regs-fb.h
@@ -173,6 +173,7 @@
 #define WINCONx_BITSWP				(1 << 18)
 #define WINCONx_BYTSWP				(1 << 17)
 #define WINCONx_HAWSWP				(1 << 16)
+#define WINCONx_WSWP				(1 << 15)
 #define WINCONx_BURSTLEN_MASK			(0x3 << 9)
 #define WINCONx_BURSTLEN_SHIFT			(9)
 #define WINCONx_BURSTLEN_16WORD			(0x0 << 9)
diff -puN drivers/video/s3c-fb.c~s3c-fb-fix-distortedness-situation-for-the-mode-more-then-24bpp drivers/video/s3c-fb.c
--- a/drivers/video/s3c-fb.c~s3c-fb-fix-distortedness-situation-for-the-mode-more-then-24bpp
+++ a/drivers/video/s3c-fb.c
@@ -424,6 +424,7 @@ static int s3c_fb_set_par(struct fb_info
 		else
 			data |= WINCON0_BPPMODE_24BPP_888;
 
+		data |= WINCONx_WSWP;
 		data |= WINCONx_BURSTLEN_16WORD;
 		break;
 	}
_

Patches currently in -mm which might be from inki.dae@samsung.com are

s3c-fb-change-to-depending-on-config_s3c_fb_dev.patch
s3c-fb-add-default-window-feature.patch
s3c-fb-fix-distortedness-situation-for-the-mode-more-then-24bpp.patch
s3c-fb-only-init-window-colour-key-controls-for-windows-with-blending.patch
s3c-fb-initial-move-to-unifying-the-header-files.patch
s3c-fb-udpate-to-support-s3c2416-s3c2443-style-hardware.patch
s3c-fb-integrate-palette-setup-code-into-main-driver.patch
s3c-fb-fix-various-null-references-on-framebuffer-memory-alloc-failure.patch
s3c-fb-correct-framesel1-bitfield-defines-for-vidintcon0-register.patch
s3c-fb-separate-s5pc100-and-s5pv210-framebuffer-driver-data-structures.patch
s3c-fb-add-device-name-initialization.patch
s3c-fb-add-support-for-display-panning.patch
s3c-fb-add-wait-for-vsync-ioctl.patch
s3c-fb-window-3-of-64xx-does-not-have-an-osd_d-register.patch
s3c-fb-add-shadowcon-shadow-register-locking-support-for-s5pv210.patch
s3c-fb-correct-window-osd-size-and-alpha-register-handling.patch
s3c-fb-protect-window-specific-registers-during-updates.patch
s3c-fb-fix-section-mismatch.patch
s3c-fb-add-support-for-dma-channel-control-on-s5pv210.patch

