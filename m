From: akpm@linux-foundation.org
Subject: [merged] sections-fix-section-conflicts-in-drivers-video.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:13:23 -0700
Message-ID: <20121005201324.17BF15C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:40398 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932804Ab2JEUN1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:13:27 -0400
Received: by mail-wi0-f202.google.com with SMTP id hr7so57806wib.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:13:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, FlorianSchandinat@gmx.de, mm-commits@vger.kernel.org


The patch titled
     Subject: sections: fix section conflicts in drivers/video
has been removed from the -mm tree.  Its filename was
     sections-fix-section-conflicts-in-drivers-video.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: sections: fix section conflicts in drivers/video

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/aty128fb.c     |    2 +-
 drivers/video/geode/gx1fb_core.c |    2 +-
 drivers/video/gxt4500.c          |    4 ++--
 drivers/video/i810/i810_main.c   |    2 +-
 drivers/video/jz4740_fb.c        |    2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/video/aty/aty128fb.c~sections-fix-section-conflicts-in-drivers-video drivers/video/aty/aty128fb.c
--- a/drivers/video/aty/aty128fb.c~sections-fix-section-conflicts-in-drivers-video
+++ a/drivers/video/aty/aty128fb.c
@@ -149,7 +149,7 @@ enum {
 };
 
 /* Must match above enum */
-static const char *r128_family[] __devinitdata = {
+static char * const r128_family[] __devinitconst = {
 	"AGP",
 	"PCI",
 	"PRO AGP",
diff -puN drivers/video/geode/gx1fb_core.c~sections-fix-section-conflicts-in-drivers-video drivers/video/geode/gx1fb_core.c
--- a/drivers/video/geode/gx1fb_core.c~sections-fix-section-conflicts-in-drivers-video
+++ a/drivers/video/geode/gx1fb_core.c
@@ -29,7 +29,7 @@ static int  crt_option = 1;
 static char panel_option[32] = "";
 
 /* Modes relevant to the GX1 (taken from modedb.c) */
-static const struct fb_videomode __devinitdata gx1_modedb[] = {
+static const struct fb_videomode __devinitconst gx1_modedb[] = {
 	/* 640x480-60 VESA */
 	{ NULL, 60, 640, 480, 39682,  48, 16, 33, 10, 96, 2,
 	  0, FB_VMODE_NONINTERLACED, FB_MODE_IS_VESA },
diff -puN drivers/video/gxt4500.c~sections-fix-section-conflicts-in-drivers-video drivers/video/gxt4500.c
--- a/drivers/video/gxt4500.c~sections-fix-section-conflicts-in-drivers-video
+++ a/drivers/video/gxt4500.c
@@ -156,7 +156,7 @@ struct gxt4500_par {
 static char *mode_option;
 
 /* default mode: 1280x1024 @ 60 Hz, 8 bpp */
-static const struct fb_videomode defaultmode __devinitdata = {
+static const struct fb_videomode defaultmode __devinitconst = {
 	.refresh = 60,
 	.xres = 1280,
 	.yres = 1024,
@@ -581,7 +581,7 @@ static int gxt4500_blank(int blank, stru
 	return 0;
 }
 
-static const struct fb_fix_screeninfo gxt4500_fix __devinitdata = {
+static const struct fb_fix_screeninfo gxt4500_fix __devinitconst = {
 	.id = "IBM GXT4500P",
 	.type = FB_TYPE_PACKED_PIXELS,
 	.visual = FB_VISUAL_PSEUDOCOLOR,
diff -puN drivers/video/i810/i810_main.c~sections-fix-section-conflicts-in-drivers-video drivers/video/i810/i810_main.c
--- a/drivers/video/i810/i810_main.c~sections-fix-section-conflicts-in-drivers-video
+++ a/drivers/video/i810/i810_main.c
@@ -97,7 +97,7 @@ static int i810fb_blank      (int blank_
 static void i810fb_release_resource       (struct fb_info *info, struct i810fb_par *par);
 
 /* PCI */
-static const char *i810_pci_list[] __devinitdata = {
+static const char * const i810_pci_list[] __devinitconst = {
 	"Intel(R) 810 Framebuffer Device"                                 ,
 	"Intel(R) 810-DC100 Framebuffer Device"                           ,
 	"Intel(R) 810E Framebuffer Device"                                ,
diff -puN drivers/video/jz4740_fb.c~sections-fix-section-conflicts-in-drivers-video drivers/video/jz4740_fb.c
--- a/drivers/video/jz4740_fb.c~sections-fix-section-conflicts-in-drivers-video
+++ a/drivers/video/jz4740_fb.c
@@ -136,7 +136,7 @@ struct jzfb {
 	uint32_t pseudo_palette[16];
 };
 
-static const struct fb_fix_screeninfo jzfb_fix __devinitdata = {
+static const struct fb_fix_screeninfo jzfb_fix __devinitconst = {
 	.id		= "JZ4740 FB",
 	.type		= FB_TYPE_PACKED_PIXELS,
 	.visual		= FB_VISUAL_TRUECOLOR,
_

Patches currently in -mm which might be from ak@linux.intel.com are

origin.patch
linux-next.patch
thp-x86-introduce-have_arch_transparent_hugepage.patch
thp-remove-assumptions-on-pgtable_t-type.patch
thp-introduce-pmdp_invalidate.patch
thp-make-madv_hugepage-check-for-mm-def_flags.patch
thp-s390-thp-splitting-backend-for-s390.patch
thp-s390-thp-pagetable-pre-allocation-for-s390.patch
thp-s390-disable-thp-for-kvm-host-on-s390.patch
thp-s390-architecture-backend-for-thp-on-s390.patch

