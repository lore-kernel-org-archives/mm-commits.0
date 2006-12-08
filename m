From: akpm@osdl.org
Subject: - atyfb-fix-__init-and-__devinit.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:14:05 -0800
Message-ID: <200612082014.kB8KE549003135@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59664 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946766AbWLHUOK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:14:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: syrjala@sci.fi, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     atyfb: Fix __init and __devinit annotations
has been removed from the -mm tree.  Its filename was
     atyfb-fix-__init-and-__devinit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: atyfb: Fix __init and __devinit annotations
From: Ville Syrjala <syrjala@sci.fi>

Fix some __init and __devinit annotations.

Signed-off-by: Ville Syrjala <syrjala@sci.fi>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/aty/atyfb_base.c |    8 ++++----
 drivers/video/aty/mach64_ct.c  |    8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/video/aty/atyfb_base.c~atyfb-fix-__init-and-__devinit drivers/video/aty/atyfb_base.c
--- a/drivers/video/aty/atyfb_base.c~atyfb-fix-__init-and-__devinit
+++ a/drivers/video/aty/atyfb_base.c
@@ -3181,7 +3181,7 @@ static int __devinit atyfb_setup_sparc(s
 
 #ifdef __i386__
 #ifdef CONFIG_FB_ATY_GENERIC_LCD
-static void aty_init_lcd(struct atyfb_par *par, u32 bios_base)
+static void __devinit aty_init_lcd(struct atyfb_par *par, u32 bios_base)
 {
 	u32 driv_inf_tab, sig;
 	u16 lcd_ofs;
@@ -3644,7 +3644,7 @@ err_release_mem:
 
 #ifdef CONFIG_ATARI
 
-static int __devinit atyfb_atari_probe(void)
+static int __init atyfb_atari_probe(void)
 {
 	struct atyfb_par *par;
 	struct fb_info *info;
@@ -3794,7 +3794,7 @@ static struct pci_driver atyfb_driver = 
 #endif /* CONFIG_PCI */
 
 #ifndef MODULE
-static int __devinit atyfb_setup(char *options)
+static int __init atyfb_setup(char *options)
 {
 	char *this_opt;
 
@@ -3866,7 +3866,7 @@ static int __devinit atyfb_setup(char *o
 }
 #endif  /*  MODULE  */
 
-static int __devinit atyfb_init(void)
+static int __init atyfb_init(void)
 {
     int err1 = 1, err2 = 1;
 #ifndef MODULE
diff -puN drivers/video/aty/mach64_ct.c~atyfb-fix-__init-and-__devinit drivers/video/aty/mach64_ct.c
--- a/drivers/video/aty/mach64_ct.c~atyfb-fix-__init-and-__devinit
+++ a/drivers/video/aty/mach64_ct.c
@@ -370,8 +370,8 @@ void aty_set_pll_ct(const struct fb_info
 #endif
 }
 
-static void __init aty_get_pll_ct(const struct fb_info *info,
-				  union aty_pll *pll)
+static void __devinit aty_get_pll_ct(const struct fb_info *info,
+				     union aty_pll *pll)
 {
 	struct atyfb_par *par = (struct atyfb_par *) info->par;
 	u8 tmp, clock;
@@ -394,8 +394,8 @@ static void __init aty_get_pll_ct(const 
 	}
 }
 
-static int __init aty_init_pll_ct(const struct fb_info *info,
-				 union aty_pll *pll)
+static int __devinit aty_init_pll_ct(const struct fb_info *info,
+				     union aty_pll *pll)
 {
 	struct atyfb_par *par = (struct atyfb_par *) info->par;
 	u8 mpost_div, xpost_div, sclk_post_div_real, sclk_fb_div, spll_cntl2;
_

Patches currently in -mm which might be from syrjala@sci.fi are

atyfb-fix-__init-and-__devinit.patch
atyfb-remove-aty_cmap_regs.patch
atyfb-improve-atyfb_atari_probe.patch
atyfb-improve-power-management.patch

