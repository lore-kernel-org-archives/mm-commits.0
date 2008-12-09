From: akpm@linux-foundation.org
Subject: + radeonfb-disable-new-color-expand-acceleration-unless-explicitely-enabled.patch added to -mm tree
Date: Tue, 09 Dec 2008 00:51:32 -0800
Message-ID: <200812090851.mB98pW67003460@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37702 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751466AbYLIIvg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Dec 2008 03:51:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: benh@kernel.crashing.org, davem@davemloft.net


The patch titled
     radeonfb: disable new color expand acceleration unless explicitely enabled
has been added to the -mm tree.  Its filename is
     radeonfb-disable-new-color-expand-acceleration-unless-explicitely-enabled.patch

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
Subject: radeonfb: disable new color expand acceleration unless explicitely enabled
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

This new color expansion acceleration for radeonfb appears to trigger
problems with X on VT switch and suspend/resume on some machines.  It
might be a problem in the VT layer or in X, but I haven't quite found it
yet, so in the meantime, this disables the acceleration by default,
reverting to 2.6.27 state.  It can be enabled using the "accel_cexp"
module parameter or fbdev argument.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/radeon_accel.c |    3 ++-
 drivers/video/aty/radeon_base.c  |    6 ++++++
 drivers/video/aty/radeonfb.h     |    2 ++
 3 files changed, 10 insertions(+), 1 deletion(-)

diff -puN drivers/video/aty/radeon_accel.c~radeonfb-disable-new-color-expand-acceleration-unless-explicitely-enabled drivers/video/aty/radeon_accel.c
--- a/drivers/video/aty/radeon_accel.c~radeonfb-disable-new-color-expand-acceleration-unless-explicitely-enabled
+++ a/drivers/video/aty/radeon_accel.c
@@ -256,7 +256,8 @@ void radeonfb_imageblit(struct fb_info *
 		return;
 
 	/* We only do 1 bpp color expansion for now */
-	if (info->flags & FBINFO_HWACCEL_DISABLED || image->depth != 1)
+	if (!accel_cexp ||
+	    (info->flags & FBINFO_HWACCEL_DISABLED) || image->depth != 1)
 		goto fallback;
 
 	/* Fallback if running out of the screen. We may do clipping
diff -puN drivers/video/aty/radeon_base.c~radeonfb-disable-new-color-expand-acceleration-unless-explicitely-enabled drivers/video/aty/radeon_base.c
--- a/drivers/video/aty/radeon_base.c~radeonfb-disable-new-color-expand-acceleration-unless-explicitely-enabled
+++ a/drivers/video/aty/radeon_base.c
@@ -282,6 +282,8 @@ static int backlight = 1;
 static int backlight = 0;
 #endif
 
+int accel_cexp = 0;
+
 /*
  * prototypes
  */
@@ -2520,6 +2522,8 @@ static int __init radeonfb_setup (char *
 		} else if (!strncmp(this_opt, "ignore_devlist", 14)) {
 			ignore_devlist = 1;
 #endif
+		} else if (!strncmp(this_opt, "accel_cexp", 12)) {
+			accel_cexp = 1;
 		} else
 			mode_option = this_opt;
 	}
@@ -2567,6 +2571,8 @@ module_param(monitor_layout, charp, 0);
 MODULE_PARM_DESC(monitor_layout, "Specify monitor mapping (like XFree86)");
 module_param(force_measure_pll, bool, 0);
 MODULE_PARM_DESC(force_measure_pll, "Force measurement of PLL (debug)");
+module_param(accel_cexp, bool, 0);
+MODULE_PARM_DESC(accel_cexp, "Use acceleration engine for color expansion");
 #ifdef CONFIG_MTRR
 module_param(nomtrr, bool, 0);
 MODULE_PARM_DESC(nomtrr, "bool: disable use of MTRR registers");
diff -puN drivers/video/aty/radeonfb.h~radeonfb-disable-new-color-expand-acceleration-unless-explicitely-enabled drivers/video/aty/radeonfb.h
--- a/drivers/video/aty/radeonfb.h~radeonfb-disable-new-color-expand-acceleration-unless-explicitely-enabled
+++ a/drivers/video/aty/radeonfb.h
@@ -638,4 +638,6 @@ static inline void radeonfb_bl_init(stru
 static inline void radeonfb_bl_exit(struct radeonfb_info *rinfo) {}
 #endif
 
+extern int accel_cexp;
+
 #endif /* __RADEONFB_H__ */
_

Patches currently in -mm which might be from benh@kernel.crashing.org are

origin.patch
radeonfb-disable-new-color-expand-acceleration-unless-explicitely-enabled.patch
linux-next.patch
kprobes-add-kprobe_insn_mutex-and-cleanup-arch_remove_kprobe.patch
unaligned-wire-up-trivial-arches-for-new-common-unaligned-header.patch

