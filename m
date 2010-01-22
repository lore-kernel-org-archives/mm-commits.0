From: akpm@linux-foundation.org
Subject: + drivers-media-video-kconfig-add-video_dev-dependency-as-needed-in-drivers-media-video-kconfig.patch added to -mm tree
Date: Fri, 22 Jan 2010 15:59:49 -0800
Message-ID: <201001222359.o0MNxn9P004363@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52483 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752245Ab0AWAAC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Jan 2010 19:00:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mpagano@gentoo.org, mchehab@infradead.org


The patch titled
     drivers/media/video/Kconfig: add VIDEO_DEV dependency as needed in drivers/media/video/Kconfig
has been added to the -mm tree.  Its filename is
     drivers-media-video-kconfig-add-video_dev-dependency-as-needed-in-drivers-media-video-kconfig.patch

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
@@ -500,7 +500,7 @@ endmenu # encoder / decoder chips
 
 config DISPLAY_DAVINCI_DM646X_EVM
 	tristate "DM646x EVM Video Display"
-	depends on VIDEO_DEV && MACH_DAVINCI_DM6467_EVM
+	depends on MACH_DAVINCI_DM6467_EVM
 	select VIDEOBUF_DMA_CONTIG
 	select VIDEO_DAVINCI_VPIF
 	select VIDEO_ADV7343
@@ -513,7 +513,7 @@ config DISPLAY_DAVINCI_DM646X_EVM
 
 config CAPTURE_DAVINCI_DM646X_EVM
 	tristate "DM646x EVM Video Capture"
-	depends on VIDEO_DEV && MACH_DAVINCI_DM6467_EVM
+	depends on MACH_DAVINCI_DM6467_EVM
 	select VIDEOBUF_DMA_CONTIG
 	select VIDEO_DAVINCI_VPIF
 	help
@@ -533,7 +533,7 @@ config VIDEO_DAVINCI_VPIF
 
 config VIDEO_VIVI
 	tristate "Virtual Video Driver"
-	depends on VIDEO_DEV && VIDEO_V4L2 && !SPARC32 && !SPARC64
+	depends on VIDEO_V4L2 && !SPARC32 && !SPARC64
 	select VIDEOBUF_VMALLOC
 	default n
 	---help---
@@ -884,7 +884,7 @@ config MX1_VIDEO
 
 config VIDEO_MX1
 	tristate "i.MX1/i.MXL CMOS Sensor Interface driver"
-	depends on VIDEO_DEV && ARCH_MX1 && SOC_CAMERA
+	depends on ARCH_MX1 && SOC_CAMERA
 	select FIQ
 	select VIDEOBUF_DMA_CONTIG
 	select MX1_VIDEO
@@ -896,7 +896,7 @@ config MX3_VIDEO
 
 config VIDEO_MX3
 	tristate "i.MX3x Camera Sensor Interface driver"
-	depends on VIDEO_DEV && MX3_IPU && SOC_CAMERA
+	depends on MX3_IPU && SOC_CAMERA
 	select VIDEOBUF_DMA_CONTIG
 	select MX3_VIDEO
 	---help---
@@ -904,21 +904,21 @@ config VIDEO_MX3
 
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

