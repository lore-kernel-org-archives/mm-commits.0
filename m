From: akpm@linux-foundation.org
Subject: + rtc-rtc-ds1286-and-rtc-m48t35-need-linux-ioh.patch added to -mm tree
Date: Thu, 16 Oct 2008 15:44:20 -0700
Message-ID: <200810162244.m9GMiKE2000305@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48846 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755942AbYJPWpS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Oct 2008 18:45:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org, ralf@linux-mips.org, tsbogend@alpha.franken.de


The patch titled
     rtc: rtc-ds1286 and rtc-m48t35 need <linux/io.h>
has been added to the -mm tree.  Its filename is
     rtc-rtc-ds1286-and-rtc-m48t35-need-linux-ioh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: rtc-ds1286 and rtc-m48t35 need <linux/io.h>
From: Geert Uytterhoeven <geert@linux-m68k.org>

With m68k allmodconfig, I get:

| drivers/rtc/rtc-ds1286.c: In function 'ds1286_rtc_read':
| drivers/rtc/rtc-ds1286.c:33: error: implicit declaration of function '__raw_readl'
| drivers/rtc/rtc-ds1286.c: In function 'ds1286_rtc_write':
| drivers/rtc/rtc-ds1286.c:38: error: implicit declaration of function '__raw_writel'
| drivers/rtc/rtc-ds1286.c: In function 'ds1286_probe':
| drivers/rtc/rtc-ds1286.c:345: error: implicit declaration of function 'ioremap'
| drivers/rtc/rtc-ds1286.c:345: warning: assignment makes pointer from integer without a cast
| drivers/rtc/rtc-ds1286.c:365: error: implicit declaration of function 'iounmap'

and

| drivers/rtc/rtc-m48t35.c: In function 'm48t35_read_time':
| drivers/rtc/rtc-m48t35.c:59: error: implicit declaration of function 'readb'
| drivers/rtc/rtc-m48t35.c:60: error: implicit declaration of function 'writeb'
| drivers/rtc/rtc-m48t35.c: In function 'm48t35_probe':
| drivers/rtc/rtc-m48t35.c:168: error: implicit declaration of function 'ioremap'
| drivers/rtc/rtc-m48t35.c:168: warning: assignment makes pointer from integer without a cast
| drivers/rtc/rtc-m48t35.c:188: error: implicit declaration of function 'iounmap'

Include <linux/io.h> to get access to the I/O API.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1286.c |    1 +
 drivers/rtc/rtc-m48t35.c |    1 +
 2 files changed, 2 insertions(+)

diff -puN drivers/rtc/rtc-ds1286.c~rtc-rtc-ds1286-and-rtc-m48t35-need-linux-ioh drivers/rtc/rtc-ds1286.c
--- a/drivers/rtc/rtc-ds1286.c~rtc-rtc-ds1286-and-rtc-m48t35-need-linux-ioh
+++ a/drivers/rtc/rtc-ds1286.c
@@ -17,6 +17,7 @@
 #include <linux/platform_device.h>
 #include <linux/bcd.h>
 #include <linux/ds1286.h>
+#include <linux/io.h>
 
 #define DRV_VERSION		"1.0"
 
diff -puN drivers/rtc/rtc-m48t35.c~rtc-rtc-ds1286-and-rtc-m48t35-need-linux-ioh drivers/rtc/rtc-m48t35.c
--- a/drivers/rtc/rtc-m48t35.c~rtc-rtc-ds1286-and-rtc-m48t35-need-linux-ioh
+++ a/drivers/rtc/rtc-m48t35.c
@@ -18,6 +18,7 @@
 #include <linux/rtc.h>
 #include <linux/platform_device.h>
 #include <linux/bcd.h>
+#include <linux/io.h>
 
 #define DRV_VERSION		"1.0"
 
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
viafb-viafbmodes-viafbtxt.patch
viafb-makefile-kconfig.patch
viafb-accelc-accelh.patch
viafb-chiph-debugh.patch
viafb-dvic-dvih-globalc-and-globalh.patch
viafb-hwc-hwh.patch
viafb-ifacec-ifaceh-ioctlc-ioctlh.patch
viafb-lcdc-lcdh-lcdtblh.patch
viafb-makefile-shareh.patch
viafb-tbl1636c-tbl1636h-tbldpasettingc-tbldpasettingh.patch
viafb-viafbdevc-viafbdevh.patch
viafb-via_i2cc-via_i2ch-viamodec-viamodeh.patch
viafb-via_utilityc-via_utilityh-vt1636c-vt1636h.patch
fbdev-kconfig-update.patch
tdfxfb-do-not-make-changes-to-default-tdfx_fix.patch
cirrusfb-use-modedb-and-add-mode_option-parameter-2nd-rev.patch
cirrusfb-eliminate-crt-registers-from-global-structure.patch
fbdev-allow-more-chip-revisions-in-epson-s1d13-video-driver.patch
framebuffer-fix-carminefb-section-mismatch.patch
rtc-rtc-ds1286-and-rtc-m48t35-need-linux-ioh.patch
arch-m68k-bvme6000-rtcc-remove-duplicated-include.patch

