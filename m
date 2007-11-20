From: akpm@linux-foundation.org
Subject: + libata-add-toshiba-mk1637gsx-to-spurious-command-completion-list.patch added to -mm tree
Date: Mon, 19 Nov 2007 23:38:20 -0800
Message-ID: <200711200738.lAK7cKeM022940@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46928 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752383AbXKTHif (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 Nov 2007 02:38:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lakostis@altlinux.org, htejun@gmail.com, jeff@garzik.org, lakostis@altlinux.ru, thresh@altlinux.ru


The patch titled
     libata: add TOSHIBA MK1637GSX to spurious command completion list
has been added to the -mm tree.  Its filename is
     libata-add-toshiba-mk1637gsx-to-spurious-command-completion-list.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: libata: add TOSHIBA MK1637GSX to spurious command completion list
From: "Konstantin A. Lepikhov" <lakostis@altlinux.org>

ata1.00: exception Emask 0x2 SAct 0x1 SErr 0x0 action 0x2 frozen
ata1.00: spurious completions during NCQ issue=0x0 SAct=0x1 FIS=004040a1:00000020
ata1.00: cmd 60/70:00:83:a6:f0/00:00:04:00:00/40 tag 0 cdb 0x0 data 57344 in

Device Model:     TOSHIBA MK1637GSX
Serial Number:    77VBT1CRT
Firmware Version: DL040D

Blacklist it.

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=9410

Signed-off-by: Konstantin A. Lepikhov <lakostis@altlinux.ru>
Acked-by: Pavlov Konstantin <thresh@altlinux.ru>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-core.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/ata/libata-core.c~libata-add-toshiba-mk1637gsx-to-spurious-command-completion-list drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~libata-add-toshiba-mk1637gsx-to-spurious-command-completion-list
+++ a/drivers/ata/libata-core.c
@@ -4199,6 +4199,7 @@ static const struct ata_blacklist_entry 
 	{ "ST980813AS",		"3.ADB",	ATA_HORKAGE_NONCQ, },
 	{ "SAMSUNG HD401LJ",	"ZZ100-15",	ATA_HORKAGE_NONCQ, },
 	{ "Maxtor 7V300F0",	"VA111900",	ATA_HORKAGE_NONCQ, },
+	{ "TOSHIBA MK1637GSX",	"DL040D",	ATA_HORKAGE_NONCQ, },
 
 	/* devices which puke on READ_NATIVE_MAX */
 	{ "HDS724040KLSA80",	"KFAOA20N",	ATA_HORKAGE_BROKEN_HPA, },
_

Patches currently in -mm which might be from lakostis@altlinux.org are

libata-add-toshiba-mk1637gsx-to-spurious-command-completion-list.patch
