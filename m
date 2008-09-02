From: akpm@linux-foundation.org
Subject: - pvrusb2-use-proper-byteorder-interface.patch removed from -mm tree
Date: Tue, 02 Sep 2008 13:42:03 -0700
Message-ID: <200809022042.m82Kg3uH011688@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45080 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752632AbYIBUmH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Sep 2008 16:42:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     pvrusb2: use proper byteorder interface
has been removed from the -mm tree.  Its filename was
     pvrusb2-use-proper-byteorder-interface.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch
acpi-toshiba_acpic-fix-sparse-signedness-mismatch-warnings.patch
x86-fix-shadowed-variable-warning.patch
cifs-remove-global_extern-macro.patch
input-ads7846c-sparse-lock-annotation.patch
misdn-endian-annotations-for-struct-zt.patch
misdn-annotate-iomem-pointer-and-add-statics.patch
drivers-net-replace-__function__-with-__func__.patch
rcu-spinlocks-take-an-unsigned-long-flags.patch
rcu-fix-sparse-shadowed-variable-warning.patch
scsi-replace-__inline-with-inline.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
mm-hugetlbc-make-functions-static-use-null-rather-than-0.patch
olpc-olpc_batteryc-sparse-endian-annotations.patch
include-replace-__function__-with-__func__.patch
misc-replace-__function__-with-__func__.patch
befs-annotate-fs32-on-tests-for-superblock-endianness.patch
char-moxac-sparse-annotation.patch
byteorder-add-new-headers-for-make-headers-install.patch
byteorder-use-generic-c-version-for-value-byteswapping.patch

