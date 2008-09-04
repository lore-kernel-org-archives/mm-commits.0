From: akpm@linux-foundation.org
Subject: + atmel_lcdfb-fix-oops-in-rmmod-when-framebuffer-fails-to-register.patch added to -mm tree
Date: Thu, 04 Sep 2008 14:03:03 -0700
Message-ID: <200809042103.m84L335E030962@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32829 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753829AbYIDVDo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Sep 2008 17:03:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stf_xl@wp.pl, hskinnemoen@atmel.com, krzysztof.h1@wp.pl, nicolas.ferre@atmel.com


The patch titled
     atmel_lcdfb: fix oops in rmmod when framebuffer fails to register
has been added to the -mm tree.  Its filename is
     atmel_lcdfb-fix-oops-in-rmmod-when-framebuffer-fails-to-register.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atmel_lcdfb: fix oops in rmmod when framebuffer fails to register
From: Stanislaw Gruszka <stf_xl@wp.pl>

If framebuffer registration failed in platform driver ->probe() callback,
dev_get_drvdata() points to freed memory region, but ->remove() function
try to use it and the following oops occurs:

Unable to handle kernel NULL pointer dereference at virtual address 00000228
pgd = c3a20000
[00000228] *pgd=23a2b031, *pte=00000000, *ppte=00000000
Internal error: Oops: 17 [#1]
Modules linked in: atmel_lcdfb(-) cfbcopyarea cfbimgblt cfbfillrect [last unloaded: atmel_lcdfb]
CPU: 0    Not tainted  (2.6.27-rc2 #116)
PC is at atmel_lcdfb_remove+0x14/0xf8 [atmel_lcdfb]
LR is at platform_drv_remove+0x20/0x24
pc : [<bf006bc4>]    lr : [<c0157d28>]    psr: a0000013
sp : c3a45e84  ip : c3a45ea0  fp : c3a45e9c
r10: 00000002  r9 : c3a44000  r8 : c0026c04
r7 : 00000880  r6 : c02bb228  r5 : 00000000  r4 : c02bb230
r3 : bf007e3c  r2 : c02bb230  r1 : 00000004  r0 : c02bb228
Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 0005317f  Table: 23a20000  DAC: 00000015
Process rmmod (pid: 6799, stack limit = 0xc3a44260)
Stack: (0xc3a45e84 to 0xc3a46000)
5e80:          c02bb230 bf007e3c bf007e3c c3a45eac c3a45ea0 c0157d28 bf006bc0
5ea0: c3a45ec4 c3a45eb0 c0156d20 c0157d18 c02bb230 c02bb2d8 c3a45ee0 c3a45ec8
5ec0: c0156da8 c0156cb8 bf007e3c bf007ee0 c02c8e14 c3a45efc c3a45ee4 c0156018
5ee0: c0156d50 bf007e3c bf007ee0 00000000 c3a45f18 c3a45f00 c0157220 c0155f9c
5f00: 00000000 bf007ee0 bf008000 c3a45f28 c3a45f1c c0157e34 c01571ec c3a45f38
5f20: c3a45f2c bf006ba8 c0157e30 c3a45fa4 c3a45f3c c005772c bf006ba4 656d7461
5f40: 636c5f6c 00626664 c004c988 c3a45f80 c3a45f5c 00000000 c3a45fb0 00000000
5f60: ffffffff becaccd8 00000880 00000000 000a5e80 00000001 bf007ee0 00000880
5f80: c3a45f84 00000000 becaccd4 00000002 000003df 00000081 00000000 c3a45fa8
5fa0: c0026a60 c0057584 00000002 000003df 00900081 000a5e80 00000880 00000000
5fc0: becaccd4 00000002 000003df 00000000 000a5e80 00000001 00000002 0000005f
5fe0: 4004f5ec becacbe8 0001a158 4004f5fc 20000010 00900081 f9ffbadf 7bbfb2bb
Backtrace:
[<bf006bb0>] (atmel_lcdfb_remove+0x0/0xf8 [atmel_lcdfb]) from [<c0157d28>] (platform_drv_remove+0x20/0x24)
 r6:bf007e3c r5:bf007e3c r4:c02bb230
[<c0157d08>] (platform_drv_remove+0x0/0x24) from [<c0156d20>] (__device_release_driver+0x78/0x98)
[<c0156ca8>] (__device_release_driver+0x0/0x98) from [<c0156da8>] (driver_detach+0x68/0x90)
 r5:c02bb2d8 r4:c02bb230
[<c0156d40>] (driver_detach+0x0/0x90) from [<c0156018>] (bus_remove_driver+0x8c/0xb4)
 r6:c02c8e14 r5:bf007ee0 r4:bf007e3c
[<c0155f8c>] (bus_remove_driver+0x0/0xb4) from [<c0157220>] (driver_unregister+0x44/0x48)
 r6:00000000 r5:bf007ee0 r4:bf007e3c
[<c01571dc>] (driver_unregister+0x0/0x48) from [<c0157e34>] (platform_driver_unregister+0x14/0x18)
 r6:bf008000 r5:bf007ee0 r4:00000000
[<c0157e20>] (platform_driver_unregister+0x0/0x18) from [<bf006ba8>] (atmel_lcdfb_exit+0x14/0x1c [atmel_lcdfb])
[<bf006b94>] (atmel_lcdfb_exit+0x0/0x1c [atmel_lcdfb]) from [<c005772c>] (sys_delete_module+0x1b8/0x22c)
[<c0057574>] (sys_delete_module+0x0/0x22c) from [<c0026a60>] (ret_fast_syscall+0x0/0x2c)
 r7:00000081 r6:000003df r5:00000002 r4:becaccd4
Code: e92dd870 e24cb004 e59050c4 e1a06000 (e5954228)
---[ end trace 85476b184d9e68d8 ]---

This patch fixes the oops.

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/atmel_lcdfb.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN drivers/video/atmel_lcdfb.c~atmel_lcdfb-fix-oops-in-rmmod-when-framebuffer-fails-to-register drivers/video/atmel_lcdfb.c
--- a/drivers/video/atmel_lcdfb.c~atmel_lcdfb-fix-oops-in-rmmod-when-framebuffer-fails-to-register
+++ a/drivers/video/atmel_lcdfb.c
@@ -943,7 +943,7 @@ static int __init atmel_lcdfb_probe(stru
 	ret = register_framebuffer(info);
 	if (ret < 0) {
 		dev_err(dev, "failed to register framebuffer device: %d\n", ret);
-		goto free_cmap;
+		goto reset_drvdata;
 	}
 
 	/* add selected videomode to modelist */
@@ -959,7 +959,8 @@ static int __init atmel_lcdfb_probe(stru
 
 	return 0;
 
-
+reset_drvdata:
+	dev_set_drvdata(dev, NULL);
 free_cmap:
 	fb_dealloc_cmap(&info->cmap);
 unregister_irqs:
@@ -996,10 +997,11 @@ static int __exit atmel_lcdfb_remove(str
 {
 	struct device *dev = &pdev->dev;
 	struct fb_info *info = dev_get_drvdata(dev);
-	struct atmel_lcdfb_info *sinfo = info->par;
+	struct atmel_lcdfb_info *sinfo;
 
-	if (!sinfo)
+	if (!info || !info->par)
 		return 0;
+	sinfo = info->par;
 
 	cancel_work_sync(&sinfo->task);
 	exit_backlight(sinfo);
_

Patches currently in -mm which might be from stf_xl@wp.pl are

atmel_lcdfb-fix-oops-in-rmmod-when-framebuffer-fails-to-register.patch

