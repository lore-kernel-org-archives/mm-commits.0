From: akpm@linux-foundation.org
Subject: - atmel_lcdfb-disallow-setting-larger-resolution-than-the-framebuffer-memory-can-handle.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:17:31 -0700
Message-ID: <200810182317.m9INHVuH029107@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38416 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751246AbYJRXRf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:17:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stf_xl@wp.pl, hskinnemoen@atmel.com, krzysztof.h1@wp.pl, nicolas.ferre@atmel.com, mm-commits@vger.kernel.org


The patch titled
     atmel_lcdfb: disallow setting larger resolution than the framebuffer memory can handle
has been removed from the -mm tree.  Its filename was
     atmel_lcdfb-disallow-setting-larger-resolution-than-the-framebuffer-memory-can-handle.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atmel_lcdfb: disallow setting larger resolution than the framebuffer memory can handle
From: Stanislaw Gruszka <stf_xl@wp.pl>

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/atmel_lcdfb.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/video/atmel_lcdfb.c~atmel_lcdfb-disallow-setting-larger-resolution-than-the-framebuffer-memory-can-handle drivers/video/atmel_lcdfb.c
--- a/drivers/video/atmel_lcdfb.c~atmel_lcdfb-disallow-setting-larger-resolution-than-the-framebuffer-memory-can-handle
+++ a/drivers/video/atmel_lcdfb.c
@@ -372,6 +372,13 @@ static int atmel_lcdfb_check_var(struct 
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

origin.patch

