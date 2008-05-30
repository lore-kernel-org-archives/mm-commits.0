From: akpm@linux-foundation.org
Subject: + usb-speedtchc-fix-sparse-shadowed-variable-warning.patch added to -mm tree
Date: Fri, 30 May 2008 13:40:08 -0700
Message-ID: <200805302040.m4UKe8FE010454@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41213 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752855AbYE3UkM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 May 2008 16:40:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, baldrick@free.fr, greg@kroah.com


The patch titled
     usb: speedtch.c fix sparse shadowed variable warning
has been added to the -mm tree.  Its filename is
     usb-speedtchc-fix-sparse-shadowed-variable-warning.patch

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
Subject: usb: speedtch.c fix sparse shadowed variable warning
From: Harvey Harrison <harvey.harrison@gmail.com>

i is used only as a for-loop index no need to declare another.
drivers/usb/atm/speedtch.c:832:7: warning: symbol 'i' shadows an earlier one
drivers/usb/atm/speedtch.c:766:6: originally declared here

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Greg KH <greg@kroah.com>
Cc: Duncan Sands <baldrick@free.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/atm/speedtch.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/usb/atm/speedtch.c~usb-speedtchc-fix-sparse-shadowed-variable-warning drivers/usb/atm/speedtch.c
--- a/drivers/usb/atm/speedtch.c~usb-speedtchc-fix-sparse-shadowed-variable-warning
+++ a/drivers/usb/atm/speedtch.c
@@ -829,7 +829,6 @@ static int speedtch_bind(struct usbatm_d
 	if (use_isoc) {
 		const struct usb_host_interface *desc = data_intf->cur_altsetting;
 		const __u8 target_address = USB_DIR_IN | usbatm->driver->isoc_in;
-		int i;
 
 		use_isoc = 0; /* fall back to bulk if endpoint not found */
 
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

linux-next.patch
kgdb-use-put_unaligned_be32-helper.patch
cifs-remove-global_extern-macro.patch
media-use-get_unaligned_-helpers.patch
mtd-mtdcharc-silence-sparse-warning.patch
mtd-mtdcharc-remove-shadowed-variable-warnings.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-use-get_unaligned_-helpers.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
block-use-get_unaligned_-helpers.patch
usb-host-use-get-put_unaligned_-helpers-to-fix-more-potential-unaligned-issues.patch
usb-cp2101c-fix-sparse-signedness-mismatch-warnings.patch
usb-speedtchc-fix-sparse-shadowed-variable-warning.patch
git-watchdog.patch
xfs-use-get_unaligned_-helpers.patch
xtensa-replace-remaining-__function__-occurences.patch
fs-ldm-use-get_unaligned_-helpers.patch
include-use-get-put_unaligned_-helpers.patch
lzo-use-get-put_unaligned_-helpers.patch
asm-generic-int-ll64h-always-provide-__su64.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
isdn-use-the-common-ascii-hex-helpers.patch
net-use-the-common-ascii-hex-helpers.patch
kgdb-use-the-common-ascii-hex-helpers.patch
cris-use-the-common-ascii-hex-helpers.patch
frv-use-the-common-ascii-hex-helpers.patch
mips-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
mn10300-use-the-common-ascii-hex-helpers.patch

