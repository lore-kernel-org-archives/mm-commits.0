From: akpm@osdl.org
Subject: + usb-usbmixer-error-path-fix.patch added to -mm tree
Date: Tue, 02 Jan 2007 15:04:48 -0800
Message-ID: <200701022304.l02N4n9l000508@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:42056 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965026AbXABXFK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 18:05:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: m.kozlowski@tuxland.pl, greg@kroah.com


The patch titled
     usb: usbmixer error path fix
has been added to the -mm tree.  Its filename is
     usb-usbmixer-error-path-fix.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: usb: usbmixer error path fix
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>


Without the patch below namelist[0] will not be freed in case of kmalloc
error.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 sound/usb/usbmixer.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN sound/usb/usbmixer.c~usb-usbmixer-error-path-fix sound/usb/usbmixer.c
--- a/sound/usb/usbmixer.c~usb-usbmixer-error-path-fix
+++ a/sound/usb/usbmixer.c
@@ -1526,7 +1526,7 @@ static int parse_audio_selector_unit(str
 		namelist[i] = kmalloc(MAX_ITEM_NAME_LEN, GFP_KERNEL);
 		if (! namelist[i]) {
 			snd_printk(KERN_ERR "cannot malloc\n");
-			while (--i > 0)
+			while (i--)
 				kfree(namelist[i]);
 			kfree(namelist);
 			kfree(cval);
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

ppc-cs4218_tdm-remove-extra-brace.patch
mips-dbg_io-stray-brackets-fix.patch
git-mtd.patch
net-ifb-error-path-loop-fix.patch
scsi-sic7xxx-stray-bracket-fix.patch
scsi-53c7xx-brackets-fix.patch
scsi-lpfc-error-path-fix.patch
usb-usbmixer-error-path-fix.patch
