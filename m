From: akpm@linux-foundation.org
Subject: - hecubafb-us-fb_sys_read.patch removed from -mm tree
Date: Tue, 08 May 2007 20:01:29 -0700
Message-ID: <200705090301.l4931T1J010700@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35292 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1033204AbXEIDBd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:01:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     hecubafb: use fb_sys_read()
has been removed from the -mm tree.  Its filename was
     hecubafb-us-fb_sys_read.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: hecubafb: use fb_sys_read()
From: "Antonino A. Daplas" <adaplas@gmail.com>

Since hecubafb's framebuffer is vmalloc'ed, use fb_sys_read().

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Kconfig    |    1 +
 drivers/video/hecubafb.c |    1 +
 2 files changed, 2 insertions(+)

diff -puN drivers/video/Kconfig~hecubafb-us-fb_sys_read drivers/video/Kconfig
--- a/drivers/video/Kconfig~hecubafb-us-fb_sys_read
+++ a/drivers/video/Kconfig
@@ -611,6 +611,7 @@ config FB_HECUBA
        select FB_SYS_FILLRECT
        select FB_SYS_COPYAREA
        select FB_SYS_IMAGEBLIT
+       select FB_SYS_FOPS
        select FB_DEFERRED_IO
        help
          This enables support for the Hecuba board. This driver was tested
diff -puN drivers/video/hecubafb.c~hecubafb-us-fb_sys_read drivers/video/hecubafb.c
--- a/drivers/video/hecubafb.c~hecubafb-us-fb_sys_read
+++ a/drivers/video/hecubafb.c
@@ -309,6 +309,7 @@ static ssize_t hecubafb_write(struct fb_
 
 static struct fb_ops hecubafb_ops = {
 	.owner		= THIS_MODULE,
+	.fb_read        = fb_sys_read,
 	.fb_write	= hecubafb_write,
 	.fb_fillrect	= hecubafb_fillrect,
 	.fb_copyarea	= hecubafb_copyarea,
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
