From: akpm@osdl.org
Subject: + usblpc-add-kyocera-mita-fs-820-to-list-of-quirky-printers.patch added to -mm tree
Date: Thu, 28 Dec 2006 15:59:42 -0800
Message-ID: <200612282359.kBSNxgLd016741@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:43745 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755011AbWL1X7q (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Dec 2006 18:59:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kernel@zut.de, greg@kroah.com


The patch titled
     usblp.c: add Kyocera Mita FS 820 to list of "quirky" printers
has been added to the -mm tree.  Its filename is
     usblpc-add-kyocera-mita-fs-820-to-list-of-quirky-printers.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: usblp.c: add Kyocera Mita FS 820 to list of "quirky" printers
From: Martin Williges <kernel@zut.de>

Get the Kyocera FS-820 working with cups 1.2 via usb again.  It adds the
printer to the list of "quirky" printers.  The printer seems not answer to
ID requests some seconds after plugging in.  Patch is based on
linux-2.6.19.1.

Background:

As far as I could see (strace, usbmon), the Kyocera FS-820 answers to ID
requests only a few seconds after plugging it in.  This applies to
detecting it with cups and is also true for the printing itself, which is
initiated with an ID request.  Since I have little usb knowledge, maybe
someone can interpret the data, especially the fist bulk transfer - why
request 8192 bytes?  This is the second version of the patch.

usbmon output of printing an email without patch:
tail -F /tmp/printlog.txt
c636e140 3374734463 S Bi:002:02 -115 8192 <
c9d43b40 3374734494 S Ci:002:00 s a1 00 0000 0000 03ff 1023 <
c9d43b40 3379732301 C Ci:002:00 -104 0
c636e140 3379733294 C Bi:002:02 -2 0
[...repeating...]

with patch:
tail -F /tmp/printlog.txt
d9cb82c0 3729790131 S Ci:002:00 s a1 00 0000 0000 03ff 1023 <
d9cb82c0 3729791725 C Ci:002:00 0 91 = 005b4944 3a46532d 3832303b 4d46473a
 4b796f63 6572613b 434d443a 50434c58 df956320 3732493190 S Bo:002:01 -115
 1347 = 1b252d31 32333435 5840504a 4c0a4050 4a4c2053 4554204d 414e5541
 4c464545 [...more data...]

Signed-off-by: Martin Williges <kernel@zut.de>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/usb/class/usblp.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN drivers/usb/class/usblp.c~usblpc-add-kyocera-mita-fs-820-to-list-of-quirky-printers drivers/usb/class/usblp.c
--- a/drivers/usb/class/usblp.c~usblpc-add-kyocera-mita-fs-820-to-list-of-quirky-printers
+++ a/drivers/usb/class/usblp.c
@@ -217,6 +217,7 @@ static const struct quirk_printer_struct
 	{ 0x0409, 0xbef4, USBLP_QUIRK_BIDIR }, /* NEC Picty760 (HP OEM) */
 	{ 0x0409, 0xf0be, USBLP_QUIRK_BIDIR }, /* NEC Picty920 (HP OEM) */
 	{ 0x0409, 0xf1be, USBLP_QUIRK_BIDIR }, /* NEC Picty800 (HP OEM) */
+	{ 0x0482, 0x0010, USBLP_QUIRK_BIDIR }, /* Kyocera Mita FS 820, by zut <kernel@zut.de> */
 	{ 0, 0 }
 };
 
_

Patches currently in -mm which might be from kernel@zut.de are

usblpc-add-kyocera-mita-fs-820-to-list-of-quirky-printers.patch

