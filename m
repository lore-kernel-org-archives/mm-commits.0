From: akpm@linux-foundation.org
Subject: + ide-cs-recognize-2gb-compactflash-from-transcend.patch added to -mm tree
Date: Wed, 25 Apr 2007 17:14:13 -0700
Message-ID: <200704260014.l3Q0EDVt016552@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45013 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750940AbXDZAOY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 20:14:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Fabrice.Aeschbacher@siemens.com, bzolnier@gmail.com, fabrice.aeschbacher@siemens.com, linux@dominikbrodowski.net


The patch titled
     ide-cs: recognize 2GB CompactFlash from Transcend
has been added to the -mm tree.  Its filename is
     ide-cs-recognize-2gb-compactflash-from-transcend.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ide-cs: recognize 2GB CompactFlash from Transcend
From: "Aeschbacher, Fabrice" <Fabrice.Aeschbacher@siemens.com>

Without the following patch, the kernel does not automatically detect
2GB CompactFlash cards from Transcend.

I'm not sure which correct values must be assigned to the 3th and 4th
parameters (here: 0x709b1bf1, 0xf54a91c8). Anyway, the patch is working
with these values. Tested on arch=mips.

Signed-off-by: Fabrice Aeschbacher <fabrice.aeschbacher@siemens.com>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ide/legacy/ide-cs.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/ide/legacy/ide-cs.c~ide-cs-recognize-2gb-compactflash-from-transcend drivers/ide/legacy/ide-cs.c
--- a/drivers/ide/legacy/ide-cs.c~ide-cs-recognize-2gb-compactflash-from-transcend
+++ a/drivers/ide/legacy/ide-cs.c
@@ -401,6 +401,7 @@ static struct pcmcia_device_id ide_ids[]
 	PCMCIA_DEVICE_PROD_ID12("TOSHIBA", "MK2001MPL", 0xb4585a1a, 0x3489e003),
 	PCMCIA_DEVICE_PROD_ID1("TRANSCEND    512M   ", 0xd0909443),
 	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS1GCF80", 0x709b1bf1, 0x2a54d4b1),
+	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS2GCF120", 0x709b1bf1, 0xf54a91c8),
 	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS4GCF120", 0x709b1bf1, 0xf54a91c8),
 	PCMCIA_DEVICE_PROD_ID12("WIT", "IDE16", 0x244e5994, 0x3e232852),
 	PCMCIA_DEVICE_PROD_ID12("WEIDA", "TWTTI", 0xcc7cf69c, 0x212bb918),
_

Patches currently in -mm which might be from Fabrice.Aeschbacher@siemens.com are

ide-cs-recognize-2gb-compactflash-from-transcend.patch
