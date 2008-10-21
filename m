From: akpm@linux-foundation.org
Subject: + blackfin-remove-__function__-in-video-driver.patch added to -mm tree
Date: Tue, 21 Oct 2008 13:22:23 -0700
Message-ID: <200810212022.m9LKMNKv011698@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42748 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751500AbYJUUW1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Oct 2008 16:22:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, bryan.wu@analog.com


The patch titled
     blackfin: remove __FUNCTION__ in video driver
has been added to the -mm tree.  Its filename is
     blackfin-remove-__function__-in-video-driver.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: blackfin: remove __FUNCTION__ in video driver
From: Harvey Harrison <harvey.harrison@gmail.com>

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Bryan Wu <bryan.wu@analog.com>
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
byteorder-remove-direct-includes-of-linux-byteorder-swabh.patch
linux-next.patch
cifs-remove-global_extern-macro.patch
input-ads7846c-sparse-lock-annotation.patch
blackfin-remove-__function__-in-new-serial-driver.patch
blackfin-remove-__function__-in-video-driver.patch
scsi-replace-__inline-with-inline.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-annotate-gdth_rdcap_data-gdth_rdcap16_data-endianness.patch
scsi-remove-private-implementation-of-get_unaligned_be32.patch
usb-avoid-needless-address-taking-of-function-parameters.patch

