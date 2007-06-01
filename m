From: akpm@linux-foundation.org
Subject: - cfag12864bfb-use-sys_-instead-of-cfb_-framebuffer-accessors.patch removed from -mm tree
Date: Fri, 01 Jun 2007 10:47:34 -0700
Message-ID: <200706011747.l51HlXVs015135@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:39989 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761283AbXFARrf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2007 13:47:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avuton@gmail.com, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     cfag12864bfb: Use sys_ instead of cfb_ framebuffer accessors
has been removed from the -mm tree.  Its filename was
     cfag12864bfb-use-sys_-instead-of-cfb_-framebuffer-accessors.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cfag12864bfb: Use sys_ instead of cfb_ framebuffer accessors
From: Avuton Olrich <avuton@gmail.com>

Because the framebuffer memory is allocated system RAM, use the sys_ drawing
libraries. It also fixes the following compile error:

  LD      .tmp_vmlinux1
drivers/built-in.o:(.data+0x8b48): undefined reference to `cfb_fillrect'
drivers/built-in.o:(.data+0x8b50): undefined reference to `cfb_copyarea'
drivers/built-in.o:(.data+0x8b58): undefined reference to `cfb_imageblit'

[adaplas]
Use fb_sys_read/write for the same reasons as above.

Signed-off-by: Avuton Olrich <avuton@gmail.com>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/auxdisplay/Kconfig        |    4 ++++
 drivers/auxdisplay/cfag12864bfb.c |    8 +++++---
 2 files changed, 9 insertions(+), 3 deletions(-)

diff -puN drivers/auxdisplay/Kconfig~cfag12864bfb-use-sys_-instead-of-cfb_-framebuffer-accessors drivers/auxdisplay/Kconfig
--- a/drivers/auxdisplay/Kconfig~cfag12864bfb-use-sys_-instead-of-cfb_-framebuffer-accessors
+++ a/drivers/auxdisplay/Kconfig
@@ -68,6 +68,10 @@ config CFAG12864B
 	depends on X86
 	depends on FB
 	depends on KS0108
+	select FB_SYS_FILLRECT
+	select FB_SYS_COPYAREA
+	select FB_SYS_IMAGEBLIT
+	select FB_SYS_FOPS
 	default n
 	---help---
 	  If you have a Crystalfontz 128x64 2-color LCD, cfag12864b Series,
diff -puN drivers/auxdisplay/cfag12864bfb.c~cfag12864bfb-use-sys_-instead-of-cfb_-framebuffer-accessors drivers/auxdisplay/cfag12864bfb.c
--- a/drivers/auxdisplay/cfag12864bfb.c~cfag12864bfb-use-sys_-instead-of-cfb_-framebuffer-accessors
+++ a/drivers/auxdisplay/cfag12864bfb.c
@@ -73,9 +73,11 @@ static int cfag12864bfb_mmap(struct fb_i
 
 static struct fb_ops cfag12864bfb_ops = {
 	.owner = THIS_MODULE,
-	.fb_fillrect = cfb_fillrect,
-	.fb_copyarea = cfb_copyarea,
-	.fb_imageblit = cfb_imageblit,
+	.fb_read = fb_sys_read,
+	.fb_write = fb_sys_write,
+	.fb_fillrect = sys_fillrect,
+	.fb_copyarea = sys_copyarea,
+	.fb_imageblit = sys_imageblit,
 	.fb_mmap = cfag12864bfb_mmap,
 };
 
_

Patches currently in -mm which might be from avuton@gmail.com are

origin.patch
