From: akpm@linux-foundation.org
Subject: + sections-fix-section-conflicts-in-drivers-video.patch added to -mm tree
Date: Thu, 13 Sep 2012 16:37:44 -0700
Message-ID: <20120913233745.A8E2C5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:58091 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759052Ab2IMXhs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Sep 2012 19:37:48 -0400
Received: by eekd4 with SMTP id d4so219193eek.1
        for <mm-commits@vger.kernel.org>; Thu, 13 Sep 2012 16:37:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ak@linux.intel.com, FlorianSchandinat@gmx.de


The patch titled
     Subject: sections: fix section conflicts in drivers/video
has been added to the -mm tree.  Its filename is
     sections-fix-section-conflicts-in-drivers-video.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

compilerh-add-__visible.patch
linux-next.patch
thp-x86-introduce-have_arch_transparent_hugepage.patch
thp-remove-assumptions-on-pgtable_t-type.patch
thp-introduce-pmdp_invalidate.patch
thp-make-madv_hugepage-check-for-mm-def_flags.patch
thp-s390-thp-splitting-backend-for-s390.patch
thp-s390-thp-pagetable-pre-allocation-for-s390.patch
thp-s390-disable-thp-for-kvm-host-on-s390.patch
thp-s390-architecture-backend-for-thp-on-s390.patch
sections-disable-const-sections-for-pa-risc-v2.patch
sections-fix-section-conflicts-in-arch-arm.patch
sections-fix-section-conflicts-in-arch-frv.patch
sections-fix-section-conflicts-in-arch-h8300.patch
sections-fix-section-conflicts-in-arch-ia64.patch
sections-fix-section-conflicts-in-arch-mips.patch
sections-fix-section-conflicts-in-arch-powerpc.patch
sections-fix-section-conflicts-in-arch-score.patch
sections-fix-section-conflicts-in-arch-sh.patch
sections-fix-section-conflicts-in-arch-x86.patch
sections-fix-section-conflicts-in-drivers-atm.patch
sections-fix-section-conflicts-in-drivers-char.patch
sections-fix-section-conflicts-in-drivers-cpufreq.patch
sections-fix-section-conflicts-in-drivers-ide.patch
sections-fix-section-conflicts-in-drivers-macintosh.patch
sections-fix-section-conflicts-in-drivers-mfd.patch
sections-fix-section-conflicts-in-drivers-mmc.patch
sections-fix-section-conflicts-in-drivers-net.patch
sections-fix-section-conflicts-in-drivers-net-hamradio.patch
sections-fix-section-conflicts-in-drivers-net-wan.patch
sections-fix-section-conflicts-in-drivers-platform-x86.patch
sections-fix-section-conflicts-in-drivers-scsi.patch
sections-fix-section-conflicts-in-drivers-video.patch
sections-fix-section-conflicts-in-mm-percpuc.patch
sections-fix-section-conflicts-in-net-can.patch
sections-fix-section-conflicts-in-net.patch
sections-fix-section-conflicts-in-sound.patch
sectons-fix-const-sections-for-crc32-table.patch
compat_ioctl-remove-unused-local-typedef.patch

