From: akpm@linux-foundation.org
Subject: - nvidiafb-enable-debugging-messages-a-kconfig-option.patch removed from -mm tree
Date: Fri, 11 May 2007 22:35:45 -0700
Message-ID: <200705120535.l4C5Zjbr002322@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56599 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756545AbXELFgA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:36:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khali@linux-fr.org, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     nvidiafb: Enable debugging messages a Kconfig option
has been removed from the -mm tree.  Its filename was
     nvidiafb-enable-debugging-messages-a-kconfig-option.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: nvidiafb: Enable debugging messages a Kconfig option
From: Jean Delvare <khali@linux-fr.org>

Let the user enable debugging messages in nvidiafb.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Kconfig         |   11 ++++++++++-
 drivers/video/nvidia/nvidia.c |    1 -
 2 files changed, 10 insertions(+), 2 deletions(-)

diff -puN drivers/video/Kconfig~nvidiafb-enable-debugging-messages-a-kconfig-option drivers/video/Kconfig
--- a/drivers/video/Kconfig~nvidiafb-enable-debugging-messages-a-kconfig-option
+++ a/drivers/video/Kconfig
@@ -796,6 +796,15 @@ config FB_NVIDIA_I2C
 	  independently validate video mode parameters, you should say Y
 	  here.
 
+config FB_NVIDIA_DEBUG
+	bool "Lots of debug output"
+	depends on FB_NVIDIA
+	default n
+	help
+	  Say Y here if you want the nVidia driver to output all sorts
+	  of debugging information to provide to the maintainer when
+	  something goes wrong.
+
 config FB_NVIDIA_BACKLIGHT
 	bool "Support for backlight control"
 	depends on FB_NVIDIA
@@ -835,7 +844,7 @@ config FB_RIVA_I2C
 	  here.
 
 config FB_RIVA_DEBUG
-	bool "Lots of debug output from Riva(nVidia) driver"
+	bool "Lots of debug output"
 	depends on FB_RIVA
 	default n
 	help
diff -puN drivers/video/nvidia/nvidia.c~nvidiafb-enable-debugging-messages-a-kconfig-option drivers/video/nvidia/nvidia.c
--- a/drivers/video/nvidia/nvidia.c~nvidiafb-enable-debugging-messages-a-kconfig-option
+++ a/drivers/video/nvidia/nvidia.c
@@ -37,7 +37,6 @@
 #include "nv_proto.h"
 #include "nv_dma.h"
 
-#undef CONFIG_FB_NVIDIA_DEBUG
 #ifdef CONFIG_FB_NVIDIA_DEBUG
 #define NVTRACE          printk
 #else
_

Patches currently in -mm which might be from khali@linux-fr.org are

origin.patch
git-alsa.patch
git-dvb.patch
i2c-add-driver-for-dallas-ds1682-elapsed-time-recorder.patch
