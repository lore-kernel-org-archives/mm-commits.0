From: akpm@osdl.org
Subject: - video-get-the-default-mode-from-the-right-database.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:13:13 -0800
Message-ID: <200612082013.kB8KDDdl003076@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59552 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946746AbWLHUNg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:13:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jordan.crouse@amd.com, adaplas@pol.net, geert@linux-m68k.org, jsimmons@infradead.org, teanropo@jyu.fi, mm-commits@vger.kernel.org


The patch titled
     video: Get the default mode from the right database
has been removed from the -mm tree.  Its filename was
     video-get-the-default-mode-from-the-right-database.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: video: Get the default mode from the right database
From: Jordan Crouse <jordan.crouse@amd.com>

If no default mode is specified, it should be grabbed from the supplied
database, not the default one.

[teanropo@jyu.fi: fix it]
[akpm@osdl.org: simplify it]
[akpm@osdl.org: remove pointless DEFAULT_MODEDB_INDEX]
Signed-off-by: Jordan Crouse <jordan.crouse@amd.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Tero Roponen <teanropo@jyu.fi>
Cc: James Simmons <jsimmons@infradead.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/modedb.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/video/modedb.c~video-get-the-default-mode-from-the-right-database drivers/video/modedb.c
--- a/drivers/video/modedb.c~video-get-the-default-mode-from-the-right-database
+++ a/drivers/video/modedb.c
@@ -34,8 +34,6 @@ const char *global_mode_option;
      *  Standard video mode definitions (taken from XFree86)
      */
 
-#define DEFAULT_MODEDB_INDEX	0
-
 static const struct fb_videomode modedb[] = {
     {
 	/* 640x400 @ 70 Hz, 31.5 kHz hsync */
@@ -505,8 +503,10 @@ int fb_find_mode(struct fb_var_screeninf
 	db = modedb;
 	dbsize = ARRAY_SIZE(modedb);
     }
+
     if (!default_mode)
-	default_mode = &modedb[DEFAULT_MODEDB_INDEX];
+	default_mode = &db[0];
+
     if (!default_bpp)
 	default_bpp = 8;
 
_

Patches currently in -mm which might be from jordan.crouse@amd.com are

origin.patch
video-get-the-default-mode-from-the-right-database.patch
fb-get-the-geode-gx-frambuffer-size-from-the-bios.patch
gxfb-fixups-for-the-amd-geode-gx.patch
gxfb-support-flat-panel-timings.patch
gxfb-support-command-line-options.patch
gxfb-fixup-flatpanel-detection.patch
gxfb-turn-on-the-flatpanel-power-and-data.patch
acpi-clear-gpe-before-disabling-it.patch

