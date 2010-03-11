From: akpm@linux-foundation.org
Subject: [to-be-updated] drivers-media-video-kconfig-add-video_dev-dependency-as-needed-in-drivers-media-video-kconfig.patch removed from -mm tree
Date: Thu, 11 Mar 2010 14:01:52 -0800
Message-ID: <201003112201.o2BM1qi6013105@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49841 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757330Ab0CKWCC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Mar 2010 17:02:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mpagano@gentoo.org, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     drivers/media/video/Kconfig: add VIDEO_DEV dependency as needed in drivers/media/video/Kconfig
has been removed from the -mm tree.  Its filename was
     drivers-media-video-kconfig-add-video_dev-dependency-as-needed-in-drivers-media-video-kconfig.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/media/video/Kconfig: add VIDEO_DEV dependency as needed in drivers/media/video/Kconfig
From: Mike Pagano <mpagano@gentoo.org>

Add VIDEO_DEV as dependency of VIDEO_CAPTURE_DRIVERS and all of the
devices listed under this setting.

Signed-off-by: Mike Pagano <mpagano@gentoo.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/Kconfig |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN drivers/media/video/Kconfig~drivers-media-video-kconfig-add-video_dev-dependency-as-needed-in-drivers-media-video-kconfig drivers/media/video/Kconfig
--- a/drivers/media/video/Kconfig~drivers-media-video-kconfig-add-video_dev-dependency-as-needed-in-drivers-media-video-kconfig
+++ a/drivers/media/video/Kconfig
@@ -51,14 +51,14 @@ config VIDEO_TUNER
 
 menuconfig VIDEO_CAPTURE_DRIVERS
 	bool "Video capture adapters"
-	depends on VIDEO_V4L2
+	depends on VIDEO_V4L2 && VIDEO_DEV
 	default y
 	---help---
 	  Say Y here to enable selecting the video adapters for
 	  webcams, analog TV, and hybrid analog/digital TV.
 	  Some of those devices also supports FM radio.
 
-if VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2
+if VIDEO_DEV && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2
 
 config VIDEO_ADV_DEBUG
 	bool "Enable advanced debug functionality"
@@ -509,7 +509,7 @@ endmenu # encoder / decoder chips
 
 config DISPLAY_DAVINCI_DM646X_EVM
 	tristate "DM646x EVM Video Display"
-	depends on VIDEO_DEV && MACH_DAVINCI_DM6467_EVM
+	depends on MACH_DAVINCI_DM6467_EVM
 	select VIDEOBUF_DMA_CONTIG
 	select VIDEO_DAVINCI_VPIF
 	select VIDEO_ADV7343
@@ -522,7 +522,7 @@ config DISPLAY_DAVINCI_DM646X_EVM
 
 config CAPTURE_DAVINCI_DM646X_EVM
 	tristate "DM646x EVM Video Capture"
-	depends on VIDEO_DEV && MACH_DAVINCI_DM6467_EVM
+	depends on MACH_DAVINCI_DM6467_EVM
 	select VIDEOBUF_DMA_CONTIG
 	select VIDEO_DAVINCI_VPIF
 	help
@@ -542,7 +542,7 @@ config VIDEO_DAVINCI_VPIF
 
 config VIDEO_VIVI
 	tristate "Virtual Video Driver"
-	depends on VIDEO_DEV && VIDEO_V4L2 && !SPARC32 && !SPARC64
+	depends on VIDEO_V4L2 && !SPARC32 && !SPARC64
 	select VIDEOBUF_VMALLOC
 	default n
 	---help---
@@ -910,7 +910,7 @@ config MX1_VIDEO
 
 config VIDEO_MX1
 	tristate "i.MX1/i.MXL CMOS Sensor Interface driver"
-	depends on VIDEO_DEV && ARCH_MX1 && SOC_CAMERA
+	depends on ARCH_MX1 && SOC_CAMERA
 	select FIQ
 	select VIDEOBUF_DMA_CONTIG
 	select MX1_VIDEO
@@ -922,7 +922,7 @@ config MX3_VIDEO
 
 config VIDEO_MX3
 	tristate "i.MX3x Camera Sensor Interface driver"
-	depends on VIDEO_DEV && MX3_IPU && SOC_CAMERA
+	depends on MX3_IPU && SOC_CAMERA
 	select VIDEOBUF_DMA_CONTIG
 	select MX3_VIDEO
 	---help---
@@ -930,21 +930,21 @@ config VIDEO_MX3
 
 config VIDEO_PXA27x
 	tristate "PXA27x Quick Capture Interface driver"
-	depends on VIDEO_DEV && PXA27x && SOC_CAMERA
+	depends on PXA27x && SOC_CAMERA
 	select VIDEOBUF_DMA_SG
 	---help---
 	  This is a v4l2 driver for the PXA27x Quick Capture Interface
 
 config VIDEO_SH_MOBILE_CEU
 	tristate "SuperH Mobile CEU Interface driver"
-	depends on VIDEO_DEV && SOC_CAMERA && HAS_DMA && HAVE_CLK
+	depends on SOC_CAMERA && HAS_DMA && HAVE_CLK
 	select VIDEOBUF_DMA_CONTIG
 	---help---
 	  This is a v4l2 driver for the SuperH Mobile CEU Interface
 
 config VIDEO_OMAP2
 	tristate "OMAP2 Camera Capture Interface driver"
-	depends on VIDEO_DEV && ARCH_OMAP2
+	depends on ARCH_OMAP2
 	select VIDEOBUF_DMA_SG
 	---help---
 	  This is a v4l2 driver for the TI OMAP2 camera capture interface
_

Patches currently in -mm which might be from mpagano@gentoo.org are

drivers-media-video-kconfig-add-video_dev-dependency-as-needed-in-drivers-media-video-kconfig.patch

