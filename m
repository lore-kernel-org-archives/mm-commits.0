From: akpm@osdl.org
Subject: - fb-get-the-geode-gx-frambuffer-size-from-the-bios.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:14:32 -0800
Message-ID: <200612082014.kB8KEWCj003182@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59820 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946857AbWLHUOm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:14:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jordan.crouse@amd.com, adaplas@pol.net, jsimmons@infradead.org, mm-commits@vger.kernel.org


The patch titled
     FB: Get the Geode GX frambuffer size from the BIOS
has been removed from the -mm tree.  Its filename was
     fb-get-the-geode-gx-frambuffer-size-from-the-bios.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: FB: Get the Geode GX frambuffer size from the BIOS
From: Jordan Crouse <jordan.crouse@amd.com>

Use the Geode GX BIOS virtual registers to get the actual size of the
framebuffer.

Signed-off-by: Jordan Crouse <jordan.crouse@amd.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Acked-by: James Simmons <jsimmons@infradead.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/geode/display_gx.c |   15 ++++++++++++---
 drivers/video/geode/display_gx.h |    2 +-
 2 files changed, 13 insertions(+), 4 deletions(-)

diff -puN drivers/video/geode/display_gx.c~fb-get-the-geode-gx-frambuffer-size-from-the-bios drivers/video/geode/display_gx.c
--- a/drivers/video/geode/display_gx.c~fb-get-the-geode-gx-frambuffer-size-from-the-bios
+++ a/drivers/video/geode/display_gx.c
@@ -21,10 +21,19 @@
 #include "geodefb.h"
 #include "display_gx.h"
 
-int gx_frame_buffer_size(void)
+unsigned int gx_frame_buffer_size(void)
 {
-	/* Assuming 16 MiB. */
-	return 16*1024*1024;
+	unsigned int val;
+
+	/* FB size is reported by a virtual register */
+	/* Virtual register class = 0x02 */
+	/* VG_MEM_SIZE(512Kb units) = 0x00 */
+
+	outw(0xFC53, 0xAC1C);
+	outw(0x0200, 0xAC1C);
+
+	val = (unsigned int)(inw(0xAC1E)) & 0xFFl;
+	return (val << 19);
 }
 
 int gx_line_delta(int xres, int bpp)
diff -puN drivers/video/geode/display_gx.h~fb-get-the-geode-gx-frambuffer-size-from-the-bios drivers/video/geode/display_gx.h
--- a/drivers/video/geode/display_gx.h~fb-get-the-geode-gx-frambuffer-size-from-the-bios
+++ a/drivers/video/geode/display_gx.h
@@ -11,7 +11,7 @@
 #ifndef __DISPLAY_GX_H__
 #define __DISPLAY_GX_H__
 
-int gx_frame_buffer_size(void);
+unsigned int gx_frame_buffer_size(void);
 int gx_line_delta(int xres, int bpp);
 
 extern struct geode_dc_ops gx_dc_ops;
_

Patches currently in -mm which might be from jordan.crouse@amd.com are

origin.patch
fb-get-the-geode-gx-frambuffer-size-from-the-bios.patch
gxfb-fixups-for-the-amd-geode-gx.patch
gxfb-support-flat-panel-timings.patch
gxfb-support-command-line-options.patch
gxfb-fixup-flatpanel-detection.patch
gxfb-turn-on-the-flatpanel-power-and-data.patch
acpi-clear-gpe-before-disabling-it.patch

