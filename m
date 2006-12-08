From: akpm@osdl.org
Subject: - annotate-some-variables-in-vesafb.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:13:28 -0800
Message-ID: <200612082013.kB8KDS1I003094@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59555 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946748AbWLHUNh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:13:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: deller@gmx.de, jsimmons@infradead.org, mm-commits@vger.kernel.org


The patch titled
     annotate some variables in vesafb driver as __read_mostly
has been removed from the -mm tree.  Its filename was
     annotate-some-variables-in-vesafb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: annotate some variables in vesafb driver as __read_mostly
From: Helge Deller <deller@gmx.de>

- annotate some variables in vesafb driver as __read_mostly

Signed-off-by: Helge Deller <deller@gmx.de>
Acked-by: James Simmons <jsimmons@infradead.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/vesafb.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff -puN drivers/video/vesafb.c~annotate-some-variables-in-vesafb drivers/video/vesafb.c
--- a/drivers/video/vesafb.c~annotate-some-variables-in-vesafb
+++ a/drivers/video/vesafb.c
@@ -47,17 +47,16 @@ static struct fb_fix_screeninfo vesafb_f
 	.accel	= FB_ACCEL_NONE,
 };
 
-static int             inverse   = 0;
-static int             mtrr      = 0; /* disable mtrr */
-static int	       vram_remap __initdata = 0; /* Set amount of memory to be used */
-static int	       vram_total __initdata = 0; /* Set total amount of memory */
-static int             pmi_setpal = 1;	/* pmi for palette changes ??? */
-static int             ypan       = 0;  /* 0..nothing, 1..ypan, 2..ywrap */
-static unsigned short  *pmi_base  = NULL;
-static void            (*pmi_start)(void);
-static void            (*pmi_pal)(void);
-static int             depth;
-static int             vga_compat;
+static int   inverse    __read_mostly;
+static int   mtrr       __read_mostly;		/* disable mtrr */
+static int   vram_remap __initdata;		/* Set amount of memory to be used */
+static int   vram_total __initdata;		/* Set total amount of memory */
+static int   pmi_setpal __read_mostly = 1;	/* pmi for palette changes ??? */
+static int   ypan       __read_mostly;		/* 0..nothing, 1..ypan, 2..ywrap */
+static void  (*pmi_start)(void) __read_mostly;
+static void  (*pmi_pal)  (void) __read_mostly;
+static int   depth      __read_mostly;
+static int   vga_compat __read_mostly;
 /* --------------------------------------------------------------------- */
 
 static int vesafb_pan_display(struct fb_var_screeninfo *var,
@@ -312,6 +311,7 @@ static int __init vesafb_probe(struct pl
 		ypan = pmi_setpal = 0; /* not available or some DOS TSR ... */
 
 	if (ypan || pmi_setpal) {
+		unsigned short *pmi_base;
 		pmi_base  = (unsigned short*)phys_to_virt(((unsigned long)screen_info.vesapm_seg << 4) + screen_info.vesapm_off);
 		pmi_start = (void*)((char*)pmi_base + pmi_base[1]);
 		pmi_pal   = (void*)((char*)pmi_base + pmi_base[2]);
_

Patches currently in -mm which might be from deller@gmx.de are

origin.patch
annotate-some-variables-in-vesafb.patch
constify-vga16fbc.patch

