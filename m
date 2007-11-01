From: akpm@linux-foundation.org
Subject: + piix-add-support-for-ich7-on-acer-5602awlmi.patch added to -mm tree
Date: Thu, 01 Nov 2007 15:52:48 -0700
Message-ID: <200711012252.lA1Mqm1Q019647@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33688 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752410AbXKAWxH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Nov 2007 18:53:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sebdeg@ngi.it, alan@lxorguk.ukuu.org.uk, bzolnier@gmail.com


The patch titled
     piix: add support for ICH7 on Acer 5602aWLMi
has been added to the -mm tree.  Its filename is
     piix-add-support-for-ich7-on-acer-5602awlmi.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: piix: add support for ICH7 on Acer 5602aWLMi
From: "sebdeg@ngi.it" <sebdeg@ngi.it>

In piix.c (and in ata_piix.c) are already included some patches to skip the
cable check on some laptops and to enable UDMA>33 modes, but I've noticed
than theese doesn't work on my Acer Aspire 5602WLMi (maybe exist more
versions of this laptop).  With this simple patch I can set transfer mode
to UDMA100.

Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ide/pci/piix.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/ide/pci/piix.c~piix-add-support-for-ich7-on-acer-5602awlmi drivers/ide/pci/piix.c
--- a/drivers/ide/pci/piix.c~piix-add-support-for-ich7-on-acer-5602awlmi
+++ a/drivers/ide/pci/piix.c
@@ -302,6 +302,7 @@ struct ich_laptop {
 
 static const struct ich_laptop ich_laptop[] = {
 	/* devid, subvendor, subdev */
+	{ 0x27DF, 0x1025, 0x0102 },	/* ICH7 on Acer 5602aWLMi */
 	{ 0x27DF, 0x0005, 0x0280 },	/* ICH7 on Acer 5602WLMi */
 	{ 0x27DF, 0x1025, 0x0110 },	/* ICH7 on Acer 3682WLMi */
 	{ 0x27DF, 0x1043, 0x1267 },	/* ICH7 on Asus W5F */
_

Patches currently in -mm which might be from sebdeg@ngi.it are

piix-add-support-for-ich7-on-acer-5602awlmi.patch
