From: akpm@linux-foundation.org
Subject: - fix-section-mismatch-in-chipsfb.patch removed from -mm tree
Date: Fri, 29 Jun 2007 13:40:47 -0700
Message-ID: <200706292040.l5TKelBJ022453@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51596 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755263AbXF2Uuv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Jun 2007 16:50:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: olaf@aepfle.de, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     fix section mismatch in chipsfb
has been removed from the -mm tree.  Its filename was
     fix-section-mismatch-in-chipsfb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix section mismatch in chipsfb
From: Olaf Hering <olaf@aepfle.de>

WARNING: drivers/built-in.o(.text+0x8742a): Section mismatch: reference to .init.data:chipsfb_fix (between 'chipsfb_pci_init' and 'chipsfb_set_par')
WARNING: drivers/built-in.o(.text+0x87432): Section mismatch: reference to .init.data:chipsfb_fix (between 'chipsfb_pci_init' and 'chipsfb_set_par')
WARNING: drivers/built-in.o(.text+0x87442): Section mismatch: reference to .init.data:chipsfb_var (between 'chipsfb_pci_init' and 'chipsfb_set_par')
WARNING: drivers/built-in.o(.text+0x8744a): Section mismatch: reference to .init.data:chipsfb_var (between 'chipsfb_pci_init' and 'chipsfb_set_par')

init_chips is only called from chipsfb_pci_init
chipsfb_fix and chipsfb_var are only referenced from init_chips

Signed-off-by: Olaf Hering <olaf@aepfle.de>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/chipsfb.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/video/chipsfb.c~fix-section-mismatch-in-chipsfb drivers/video/chipsfb.c
--- a/drivers/video/chipsfb.c~fix-section-mismatch-in-chipsfb
+++ a/drivers/video/chipsfb.c
@@ -292,7 +292,7 @@ static void __init chips_hw_init(void)
 		write_fr(chips_init_fr[i].addr, chips_init_fr[i].data);
 }
 
-static struct fb_fix_screeninfo chipsfb_fix __initdata = {
+static struct fb_fix_screeninfo chipsfb_fix __devinitdata = {
 	.id =		"C&T 65550",
 	.type =		FB_TYPE_PACKED_PIXELS,
 	.visual =	FB_VISUAL_PSEUDOCOLOR,
@@ -309,7 +309,7 @@ static struct fb_fix_screeninfo chipsfb_
 	.smem_len =	0x100000,	/* 1MB */
 };
 
-static struct fb_var_screeninfo chipsfb_var __initdata = {
+static struct fb_var_screeninfo chipsfb_var __devinitdata = {
 	.xres = 800,
 	.yres = 600,
 	.xres_virtual = 800,
@@ -330,7 +330,7 @@ static struct fb_var_screeninfo chipsfb_
 	.vsync_len = 8,
 };
 
-static void __init init_chips(struct fb_info *p, unsigned long addr)
+static void __devinit init_chips(struct fb_info *p, unsigned long addr)
 {
 	memset(p->screen_base, 0, 0x100000);
 
_

Patches currently in -mm which might be from olaf@aepfle.de are

origin.patch
keep-track-of-network-interface-renaming.patch
