From: akpm@linux-foundation.org
Subject: + arm-mmp-added-device-for-display-controller.patch added to -mm tree
Date: Fri, 01 Feb 2013 15:36:25 -0800
Message-ID: <20130201233626.40F8A31C1BF@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:47633 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756243Ab3BAXg1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Feb 2013 18:36:27 -0500
Received: by mail-qc0-f202.google.com with SMTP id s25so500882qcq.5
        for <mm-commits@vger.kernel.org>; Fri, 01 Feb 2013 15:36:27 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zzhu3@marvell.com, FlorianSchandinat@gmx.de, cldu@marvell.com, haojian.zhuang@gmail.com, ligq@marvell.com


The patch titled
     Subject: ARM: mmp: added device for display controller
has been added to the -mm tree.  Its filename is
     arm-mmp-added-device-for-display-controller.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zhou Zhu <zzhu3@marvell.com>
Subject: ARM: mmp: added device for display controller

Add device for display controller and fb support

Signed-off-by: Zhou Zhu <zzhu3@marvell.com>
Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Lisa Du <cldu@marvell.com>
Cc: Guoqing Li <ligq@marvell.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-mmp/include/mach/pxa910.h |    5 ++++-
 arch/arm/mach-mmp/pxa910.c              |    3 +++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff -puN arch/arm/mach-mmp/include/mach/pxa910.h~arm-mmp-added-device-for-display-controller arch/arm/mach-mmp/include/mach/pxa910.h
--- a/arch/arm/mach-mmp/include/mach/pxa910.h~arm-mmp-added-device-for-display-controller
+++ a/arch/arm/mach-mmp/include/mach/pxa910.h
@@ -8,6 +8,7 @@ extern void __init pxa910_init_irq(void)
 #include <linux/i2c/pxa-i2c.h>
 #include <mach/devices.h>
 #include <linux/platform_data/mtd-nand-pxa3xx.h>
+#include <video/mmp_disp.h>
 
 extern struct pxa_device_desc pxa910_device_uart1;
 extern struct pxa_device_desc pxa910_device_uart2;
@@ -21,7 +22,9 @@ extern struct pxa_device_desc pxa910_dev
 extern struct platform_device pxa168_device_u2o;
 extern struct platform_device pxa168_device_u2ootg;
 extern struct platform_device pxa168_device_u2oehci;
-
+extern struct pxa_device_desc pxa910_device_disp;
+extern struct pxa_device_desc pxa910_device_fb;
+extern struct pxa_device_desc pxa910_device_panel;
 extern struct platform_device pxa910_device_gpio;
 extern struct platform_device pxa910_device_rtc;
 
diff -puN arch/arm/mach-mmp/pxa910.c~arm-mmp-added-device-for-display-controller arch/arm/mach-mmp/pxa910.c
--- a/arch/arm/mach-mmp/pxa910.c~arm-mmp-added-device-for-display-controller
+++ a/arch/arm/mach-mmp/pxa910.c
@@ -134,6 +134,9 @@ PXA910_DEVICE(pwm2, "pxa910-pwm", 1, NON
 PXA910_DEVICE(pwm3, "pxa910-pwm", 2, NONE, 0xd401a800, 0x10);
 PXA910_DEVICE(pwm4, "pxa910-pwm", 3, NONE, 0xd401ac00, 0x10);
 PXA910_DEVICE(nand, "pxa3xx-nand", -1, NAND, 0xd4283000, 0x80, 97, 99);
+PXA910_DEVICE(disp, "mmp-disp", 0, LCD, 0xd420b000, 0x1ec);
+PXA910_DEVICE(fb, "mmp-fb", -1, NONE, 0, 0);
+PXA910_DEVICE(panel, "tpo-hvga", -1, NONE, 0, 0);
 
 struct resource pxa910_resource_gpio[] = {
 	{
_

Patches currently in -mm which might be from zzhu3@marvell.com are

video-mmp-display-subsystem.patch
video-mmp-fb-support.patch
video-mmp-display-controller-support.patch
video-mmp-add-tpo-hvga-panel-supported.patch
video-mmpdisp-add-spi-port-in-display-controller.patch
arm-mmp-added-device-for-display-controller.patch
arm-mmp-enable-display-in-ttc_dkb.patch
arm-mmp-add-display-and-fb-support-in-pxa910-defconfig.patch

