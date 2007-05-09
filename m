From: akpm@linux-foundation.org
Subject: - arcfb-us-fb_sys_read.patch removed from -mm tree
Date: Tue, 08 May 2007 20:01:27 -0700
Message-ID: <200705090301.l4931RNg010695@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:33394 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032789AbXEIDB3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:01:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     arcfb: use fb_sys_read()
has been removed from the -mm tree.  Its filename was
     arcfb-us-fb_sys_read.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: arcfb: use fb_sys_read()
From: "Antonino A. Daplas" <adaplas@gmail.com>

Since arcfb's framebuffer is vmalloc'ed, use the fb_sys_read().

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Kconfig |    1 +
 drivers/video/arcfb.c |    1 +
 2 files changed, 2 insertions(+)

diff -puN drivers/video/Kconfig~arcfb-us-fb_sys_read drivers/video/Kconfig
--- a/drivers/video/Kconfig~arcfb-us-fb_sys_read
+++ a/drivers/video/Kconfig
@@ -420,6 +420,7 @@ config FB_ARC
 	select FB_SYS_FILLRECT
 	select FB_SYS_COPYAREA
 	select FB_SYS_IMAGEBLIT
+	select FB_SYS_FOPS
 	help
 	  This enables support for the Arc Monochrome LCD board. The board
 	  is based on the KS-108 lcd controller and is typically a matrix
diff -puN drivers/video/arcfb.c~arcfb-us-fb_sys_read drivers/video/arcfb.c
--- a/drivers/video/arcfb.c~arcfb-us-fb_sys_read
+++ a/drivers/video/arcfb.c
@@ -494,6 +494,7 @@ static ssize_t arcfb_write(struct fb_inf
 static struct fb_ops arcfb_ops = {
 	.owner		= THIS_MODULE,
 	.fb_open	= arcfb_open,
+	.fb_read        = fb_sys_read,
 	.fb_write	= arcfb_write,
 	.fb_release	= arcfb_release,
 	.fb_pan_display	= arcfb_pan_display,
_

Patches currently in -mm which might be from adaplas@gmail.com are

origin.patch
vt8623fb-new-framebuffer-driver-for-via-vt8623.patch
vt8623fb-fix-compile-warnings.patch
vt8623fb-fix-compile-error-if-config_mtrr=n.patch
arkfb-new-framebuffer-driver-for-ark-logic-cards.patch
arkfb-fix-compiler-warnings.patch
arkfb-fix-compile-error-if-config_mtrr=n.patch
arkfb-new-framebuffer-driver-for-ark-logic-cards-fix.patch
svgalib-move-fb_get_caps-to-svgalib.patch
