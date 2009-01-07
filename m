From: akpm@linux-foundation.org
Subject: - blackfin-remove-__function__-in-video-driver.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:19:40 -0800
Message-ID: <200901072219.n07MJeT6018963@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56255 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758119AbZAGWUZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:20:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, bryan.wu@analog.com, mm-commits@vger.kernel.org


The patch titled
     blackfin: remove __FUNCTION__ in video driver
has been removed from the -mm tree.  Its filename was
     blackfin-remove-__function__-in-video-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: blackfin: remove __FUNCTION__ in video driver
From: Harvey Harrison <harvey.harrison@gmail.com>

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Acked-by: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/bfin-t350mcqb-fb.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/video/bfin-t350mcqb-fb.c~blackfin-remove-__function__-in-video-driver drivers/video/bfin-t350mcqb-fb.c
--- a/drivers/video/bfin-t350mcqb-fb.c~blackfin-remove-__function__-in-video-driver
+++ a/drivers/video/bfin-t350mcqb-fb.c
@@ -255,7 +255,7 @@ static int bfin_t350mcqb_fb_check_var(st
 {
 
 	if (var->bits_per_pixel != LCD_BPP) {
-		pr_debug("%s: depth not supported: %u BPP\n", __FUNCTION__,
+		pr_debug("%s: depth not supported: %u BPP\n", __func__,
 			 var->bits_per_pixel);
 		return -EINVAL;
 	}
@@ -264,7 +264,7 @@ static int bfin_t350mcqb_fb_check_var(st
 	    info->var.xres_virtual != var->xres_virtual ||
 	    info->var.yres_virtual != var->yres_virtual) {
 		pr_debug("%s: Resolution not supported: X%u x Y%u \n",
-			 __FUNCTION__, var->xres, var->yres);
+			 __func__, var->xres, var->yres);
 		return -EINVAL;
 	}
 
@@ -274,7 +274,7 @@ static int bfin_t350mcqb_fb_check_var(st
 
 	if ((info->fix.line_length * var->yres_virtual) > info->fix.smem_len) {
 		pr_debug("%s: Memory Limit requested yres_virtual = %u\n",
-			 __FUNCTION__, var->yres_virtual);
+			 __func__, var->yres_virtual);
 		return -ENOMEM;
 	}
 
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
linux-next.patch
input-ads7846c-sparse-lock-annotation.patch
scsi-replace-__inline-with-inline.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-annotate-gdth_rdcap_data-gdth_rdcap16_data-endianness.patch
memstick-annotate-endianness-of-attribute-structs.patch
byteorder-add-load_-store_endian-api.patch
unaligned-consolidate-unaligned-headers-add-load_-store_endian_noalign.patch
unaligned-wire-up-trivial-arches-for-new-common-unaligned-header.patch
sh-wire-up-arch-overrides-for-unaligned-access-on-the-sh4a.patch
unaligned-wire-up-h8300-and-m32r-arches.patch
unaligned-wire-up-arm-arch-overrides-for-unaligned-access.patch
unaligned-remove-the-old-implementation.patch
ata-replace-byteshifting-with-unaligned-endian-helpers.patch
usb-use-unaligned-endian-helpers-in-storage-drivers.patch

