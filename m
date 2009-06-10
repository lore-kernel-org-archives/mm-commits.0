From: akpm@linux-foundation.org
Subject: - v4l2-timberdale-add-timberdale-logiwin-driver-in-kconfig-and-makefile.patch removed from -mm tree
Date: Tue, 09 Jun 2009 17:24:01 -0700
Message-ID: <200906100043.n5A0huQc012618@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33972 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751749AbZFJAoG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jun 2009 20:44:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard.rojfors.ext@mocean-labs.com, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     v4l2: timberdale: add Timberdale Logiwin driver in Kconfig and Mak=
efile
has been removed from the -mm tree.  Its filename was
     v4l2-timberdale-add-timberdale-logiwin-driver-in-kconfig-and-makef=
ile.patch

This patch was dropped because of build problems due to the missing xil=
inx patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: v4l2: timberdale: add Timberdale Logiwin driver in Kconfig and=
 Makefile
=46rom: Richard R=F6jfors <richard.rojfors.ext@mocean-labs.com>

Updates of Kconfig and Makefile for the Timberdale logiwin driver

Signed-off-by: Richard R=F6jfors <richard.rojfors.ext@mocean-labs.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/Kconfig  |    7 +++++++
 drivers/media/video/Makefile |    2 ++
 2 files changed, 9 insertions(+)

diff -puN drivers/media/video/Kconfig~v4l2-timberdale-add-timberdale-lo=
giwin-driver-in-kconfig-and-makefile drivers/media/video/Kconfig
--- a/drivers/media/video/Kconfig~v4l2-timberdale-add-timberdale-logiwi=
n-driver-in-kconfig-and-makefile
+++ a/drivers/media/video/Kconfig
@@ -808,6 +808,13 @@ config VIDEO_OMAP2
 	---help---
 	  This is a v4l2 driver for the TI OMAP2 camera capture interface
=20
+config VIDEO_TIMBERDALE
+	tristate "Support for timberdale Video In/LogiWIN"
+	depends on VIDEO_V4L2 && MFD_TIMBERDALE_DMA
+	select VIDEO_ADV7180
+	---help---
+	Add support for the Video In peripherial of the timberdale FPGA.
+
 #
 # USB Multimedia device configuration
 #
diff -puN drivers/media/video/Makefile~v4l2-timberdale-add-timberdale-l=
ogiwin-driver-in-kconfig-and-makefile drivers/media/video/Makefile
--- a/drivers/media/video/Makefile~v4l2-timberdale-add-timberdale-logiw=
in-driver-in-kconfig-and-makefile
+++ a/drivers/media/video/Makefile
@@ -153,6 +153,8 @@ obj-$(CONFIG_VIDEO_SH_MOBILE_CEU)	+=3D sh_
=20
 obj-$(CONFIG_VIDEO_AU0828) +=3D au0828/
=20
+obj-$(CONFIG_VIDEO_TIMBERDALE)	+=3D timblogiw.o
+
 obj-$(CONFIG_USB_VIDEO_CLASS)	+=3D uvc/
=20
 EXTRA_CFLAGS +=3D -Idrivers/media/dvb/dvb-core
_

Patches currently in -mm which might be from richard.rojfors.ext@mocean=
-labs.com are

linux-next.patch
v4l2-timberdale-add-timberdale-logiwin-driver-in-kconfig-and-makefile.p=
atch
mfd-timberdale-add-timberdale-driver.patch
serial-timberdale-add-timberdale-uart-driver.patch
gpio-timberdale-add-timbgpio.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
