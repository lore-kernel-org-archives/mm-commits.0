From: akpm@linux-foundation.org
Subject: + acpi-toshiba_acpic-fix-sparse-signedness-mismatch-warnings.patch added to -mm tree
Date: Wed, 27 Aug 2008 20:23:07 -0700
Message-ID: <200808280323.m7S3N7Tc004851@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40893 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753591AbYH1DXY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Aug 2008 23:23:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, andi@firstfloor.org, hmh@hmh.eng.br, mjg59@srcf.ucam.org


The patch titled
     acpi: toshiba_acpi.c fix sparse signedness mismatch warnings
has been added to the -mm tree.  Its filename is
     acpi-toshiba_acpic-fix-sparse-signedness-mismatch-warnings.patch

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
Subject: acpi: toshiba_acpi.c fix sparse signedness mismatch warnings
From: Harvey Harrison <harvey.harrison@gmail.com>

set_bit expects unsigned int, and we start with a u32 anyway.
drivers/acpi/toshiba_acpi.c:397:14: warning: incorrect type in argument 1 (different signedness)
drivers/acpi/toshiba_acpi.c:397:14:    expected unsigned int [usertype] *word
drivers/acpi/toshiba_acpi.c:397:14:    got int *<noident>
drivers/acpi/toshiba_acpi.c:399:14: warning: incorrect type in argument 1 (different signedness)
drivers/acpi/toshiba_acpi.c:399:14:    expected unsigned int [usertype] *word
drivers/acpi/toshiba_acpi.c:399:14:    got int *<noident>
drivers/acpi/toshiba_acpi.c:401:14: warning: incorrect type in argument 1 (different signedness)
drivers/acpi/toshiba_acpi.c:401:14:    expected unsigned int [usertype] *word
drivers/acpi/toshiba_acpi.c:401:14:    got int *<noident>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/toshiba_acpi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/acpi/toshiba_acpi.c~acpi-toshiba_acpic-fix-sparse-signedness-mismatch-warnings drivers/acpi/toshiba_acpi.c
--- a/drivers/acpi/toshiba_acpi.c~acpi-toshiba_acpic-fix-sparse-signedness-mismatch-warnings
+++ a/drivers/acpi/toshiba_acpi.c
@@ -548,7 +548,7 @@ static unsigned long write_video(const c
 
 	hci_read1(HCI_VIDEO_OUT, &video_out, &hci_result);
 	if (hci_result == HCI_SUCCESS) {
-		int new_video_out = video_out;
+		unsigned int new_video_out = video_out;
 		if (lcd_out != -1)
 			_set_bit(&new_video_out, HCI_VIDEO_OUT_LCD, lcd_out);
 		if (crt_out != -1)
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

linux-next.patch
acpi-toshiba_acpic-fix-sparse-signedness-mismatch-warnings.patch
x86-fix-shadowed-variable-warning.patch
cifs-remove-global_extern-macro.patch
v4l-drx397xdc-sparse-annotations.patch
v4l-mt9m111c-make-function-static.patch
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
byteorder-add-new-headers-for-make-headers-install.patch
pvrusb2-use-proper-byteorder-interface.patch

