From: akpm@linux-foundation.org
Subject: + atmel_lcdfb-disallow-setting-larger-resolution-than-the-framebuffer-memory-can-handle.patch added to -mm tree
Date: Thu, 04 Sep 2008 14:04:37 -0700
Message-ID: <200809042104.m84L4bLw031011@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46893 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753434AbYIDVFL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Sep 2008 17:05:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stf_xl@wp.pl, hskinnemoen@atmel.com, krzysztof.h1@wp.pl, nicolas.ferre@atmel.com


The patch titled
     atmel_lcdfb: disallow setting larger resolution than the framebuffer memory can handle
has been added to the -mm tree.  Its filename is
     atmel_lcdfb-disallow-setting-larger-resolution-than-the-framebuffer-memory-can-handle.patch

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
Subject: atmel_lcdfb: disallow setting larger resolution than the framebuffer memory can handle
From: Stanislaw Gruszka <stf_xl@wp.pl>

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/atmel_lcdfb.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/video/atmel_lcdfb.c~atmel_lcdfb-disallow-setting-larger-resolution-than-the-framebuffer-memory-can-handle drivers/video/atmel_lcdfb.c
--- a/drivers/video/atmel_lcdfb.c~atmel_lcdfb-disallow-setting-larger-resolution-than-the-framebuffer-memory-can-handle
+++ a/drivers/video/atmel_lcdfb.c
@@ -342,6 +342,13 @@ static int atmel_lcdfb_check_var(struct 
 	var->transp.offset = var->transp.length = 0;
 	var->xoffset = var->yoffset = 0;
 
+	if (info->fix.smem_len) {
+		unsigned int smem_len = (var->xres_virtual * var->yres_virtual
+					 * ((var->bits_per_pixel + 7) / 8));
+		if (smem_len > info->fix.smem_len)
+			return -EINVAL;
+	}
+
 	/* Saturate vertical and horizontal timings at maximum values */
 	var->vsync_len = min_t(u32, var->vsync_len,
 			(ATMEL_LCDC_VPW >> ATMEL_LCDC_VPW_OFFSET) + 1);
_

Patches currently in -mm which might be from stf_xl@wp.pl are

atmel_lcdfb-fix-oops-in-rmmod-when-framebuffer-fails-to-register.patch
atmel_lcdfb-disallow-setting-larger-resolution-than-the-framebuffer-memory-can-handle.patch

