From: akpm@linux-foundation.org
Subject: - ps3fb-default-to-480p-on-dvi-d-hdmi-if-video=safe.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:45:44 -0700
Message-ID: <200710162045.l9GKjink016295@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37107 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935221AbXJPU44 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 16:56:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Geert.Uytterhoeven@sonycom.com, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     ps3fb: default to 480p on DVI-D/HDMI if video=safe
has been removed from the -mm tree.  Its filename was
     ps3fb-default-to-480p-on-dvi-d-hdmi-if-video=safe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ps3fb: default to 480p on DVI-D/HDMI if video=safe
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Default to the 480p video mode on DVI-D and HDMI displays if `video=safe' is
passed on the kernel command line.

This is intended to be used by `kboot'-style boot loaders (i.e. first-stage
kernels) for the PS3, to provide a failsafe video mode.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ps3/ps3av.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN drivers/ps3/ps3av.c~ps3fb-default-to-480p-on-dvi-d-hdmi-if-video=safe drivers/ps3/ps3av.c
--- a/drivers/ps3/ps3av.c~ps3fb-default-to-480p-on-dvi-d-hdmi-if-video=safe
+++ a/drivers/ps3/ps3av.c
@@ -23,6 +23,7 @@
 #include <linux/delay.h>
 #include <linux/notifier.h>
 #include <linux/ioctl.h>
+#include <linux/fb.h>
 
 #include <asm/firmware.h>
 #include <asm/ps3av.h>
@@ -33,6 +34,8 @@
 #define BUFSIZE          4096	/* vuart buf size */
 #define PS3AV_BUF_SIZE   512	/* max packet size */
 
+static int safe_mode;
+
 static int timeout = 5000;	/* in msec ( 5 sec ) */
 module_param(timeout, int, 0644);
 
@@ -639,6 +642,9 @@ static int ps3av_hdmi_get_id(struct ps3a
 {
 	int id;
 
+	if (safe_mode)
+		return PS3AV_DEFAULT_HDMI_MODE_ID_REG_60;
+
 	/* check native resolution */
 	id = ps3av_resbit2id(info->res_50.native, info->res_60.native,
 			     info->res_vesa.native);
@@ -1021,7 +1027,14 @@ static int ps3av_probe(struct ps3_system
 		       res);
 
 	ps3av_get_hw_conf(ps3av);
+
+#ifdef CONFIG_FB
+	if (fb_mode_option && !strcmp(fb_mode_option, "safe"))
+		safe_mode = 1;
+#endif /* CONFIG_FB */
 	id = ps3av_auto_videomode(&ps3av->av_hw_conf);
+	safe_mode = 0;
+
 	mutex_lock(&ps3av->mutex);
 	ps3av->ps3av_mode = id;
 	mutex_unlock(&ps3av->mutex);
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

origin.patch
