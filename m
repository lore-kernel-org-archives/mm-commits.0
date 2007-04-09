From: akpm@linux-foundation.org
Subject: + rivafb-handle-i2c-bus-creation-failure.patch added to -mm tree
Date: Mon, 09 Apr 2007 12:38:07 -0700
Message-ID: <200704091938.l39Jc78v021583@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57171 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753308AbXDITiW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 9 Apr 2007 15:38:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khali@linux-fr.org, adaplas@gmail.com


The patch titled
     rivafb: handle I2C bus creation failure
has been added to the -mm tree.  Its filename is
     rivafb-handle-i2c-bus-creation-failure.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: rivafb: handle I2C bus creation failure
From: Jean Delvare <khali@linux-fr.org>

I2C bus creation may fail, let rivafb handle that case properly.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/riva/fbdev.c |    2 ++
 1 files changed, 2 insertions(+)

diff -puN drivers/video/riva/fbdev.c~rivafb-handle-i2c-bus-creation-failure drivers/video/riva/fbdev.c
--- a/drivers/video/riva/fbdev.c~rivafb-handle-i2c-bus-creation-failure
+++ a/drivers/video/riva/fbdev.c
@@ -1789,6 +1789,8 @@ static int __devinit riva_get_EDID_i2c(s
 	NVTRACE_ENTER();
 	riva_create_i2c_busses(par);
 	for (i = 0; i < par->bus; i++) {
+		if (!par->chan[i].par)
+			continue;
 		riva_probe_i2c_connector(par, i+1, &par->EDID);
 		if (par->EDID && !fb_parse_edid(par->EDID, &var)) {
 			printk(PFX "Found EDID Block from BUS %i\n", i);
_

Patches currently in -mm which might be from khali@linux-fr.org are

x86-msr-add-support-for-safe-variants.patch
git-alsa.patch
git-dvb.patch
i2c-replace-more-deprecated-sa_xxx-interrupt-flags.patch
apple-smc-driver-hardware-monitoring-and-control.patch
git-ieee1394.patch
git-netdev-all.patch
git-net.patch
xtensa-strlcpy-is-smart-enough.patch
oss-strlcpy-is-smart-enough.patch
rtc-add-rtc-class-driver-for-the-maxim-max6900.patch
legacy-pc-parports-support-parport-dev.patch
layered-parport-code-uses-parport-dev.patch
fbdev-dont-show-logo-if-driver-or-fbcon-are-modular.patch
rivafb-handle-i2c-bus-creation-failure.patch
rivafb-nvidiafb-various-cleanups.patch
rivafb-fixed-reversed-ddc-ports.patch
