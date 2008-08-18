From: akpm@linux-foundation.org
Subject: + pvrusb2-use-proper-byteorder-interface.patch added to -mm tree
Date: Mon, 18 Aug 2008 16:31:50 -0700
Message-ID: <200808182331.m7INVp9A019488@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55435 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753215AbYHRXb4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Aug 2008 19:31:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, mchehab@infradead.org


The patch titled
     pvrusb2: use proper byteorder interface
has been added to the -mm tree.  Its filename is
     pvrusb2-use-proper-byteorder-interface.patch

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
Subject: pvrusb2: use proper byteorder interface
From: Harvey Harrison <harvey.harrison@gmail.com>

___swab32 is an internal detail of the implementation.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/pvrusb2/pvrusb2-hdw.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/media/video/pvrusb2/pvrusb2-hdw.c~pvrusb2-use-proper-byteorder-interface drivers/media/video/pvrusb2/pvrusb2-hdw.c
--- a/drivers/media/video/pvrusb2/pvrusb2-hdw.c~pvrusb2-use-proper-byteorder-interface
+++ a/drivers/media/video/pvrusb2/pvrusb2-hdw.c
@@ -1314,8 +1314,7 @@ int pvr2_upload_firmware2(struct pvr2_hd
 		memcpy(fw_ptr, fw_entry->data + fw_done, bcnt);
 		/* Usbsnoop log shows that we must swap bytes... */
 		for (icnt = 0; icnt < bcnt/4 ; icnt++)
-			((u32 *)fw_ptr)[icnt] =
-				___swab32(((u32 *)fw_ptr)[icnt]);
+			((u32 *)fw_ptr)[icnt] = swab32(((u32 *)fw_ptr)[icnt]);
 
 		ret |= usb_bulk_msg(hdw->usb_dev, pipe, fw_ptr,bcnt,
 				    &actual_length, HZ);
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
linux-next.patch
x86-fix-shadowed-variable-warning.patch
cifs-remove-global_extern-macro.patch
ppc-use-the-common-ascii-hex-helpers.patch
powerpc-replace-__function__-with-__func__.patch
v4l-drx397xdc-sparse-annotations.patch
input-ads7846c-sparse-lock-annotation.patch
kvm-make-functions-static.patch
misdn-endian-annotations-for-struct-zt.patch
misdn-annotate-iomem-pointer-and-add-statics.patch
drivers-net-replace-__function__-with-__func__.patch
scsi-replace-__inline-with-inline.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
wireless-replace-__function__-with-__func__.patch
xtensa-replace-remaining-__function__-occurences.patch
olpc-olpc_batteryc-sparse-endian-annotations.patch
include-replace-__function__-with-__func__.patch
misc-replace-__function__-with-__func__.patch
befs-annotate-fs32-on-tests-for-superblock-endianness.patch
byteorder-add-new-headers-for-make-headers-install.patch
pvrusb2-use-proper-byteorder-interface.patch

