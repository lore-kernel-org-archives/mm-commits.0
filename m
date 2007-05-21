From: akpm@linux-foundation.org
Subject: + ada-add-seagate-stt20000a-to-dma-blacklist.patch added to -mm tree
Date: Mon, 21 May 2007 15:41:03 -0700
Message-ID: <200705212241.l4LMf3ej021729@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36744 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765426AbXEUWo2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 18:44:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davej@redhat.com, alan@lxorguk.ukuu.org.uk, hancockr@shaw.ca, htejun@gmail.com, jeff@garzik.org


The patch titled
     ata: add Seagate STT20000A to DMA blacklist.
has been added to the -mm tree.  Its filename is
     ada-add-seagate-stt20000a-to-dma-blacklist.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ata: add Seagate STT20000A to DMA blacklist.
From: Dave Jones <davej@redhat.com>

http://bugzilla.kernel.org/show_bug.cgi?id=1044 points out an additional
hard disk that doesn't handle DMA transfers correctly.  This patch is the
libata variant of the earlier patch to drivers/ide/

Signed-off-by: Dave Jones <davej@redhat.com>
Cc: Robert Hancock <hancockr@shaw.ca>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-core.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN drivers/ata/libata-core.c~ada-add-seagate-stt20000a-to-dma-blacklist drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~ada-add-seagate-stt20000a-to-dma-blacklist
+++ a/drivers/ata/libata-core.c
@@ -3860,6 +3860,7 @@ static const struct ata_blacklist_entry 
 	{ "ATAPI CD-ROM DRIVE 40X MAXIMUM",NULL,ATA_HORKAGE_NODMA },
 	{ "_NEC DV5800A", 	NULL,		ATA_HORKAGE_NODMA },
 	{ "SAMSUNG CD-ROM SN-124","N001",	ATA_HORKAGE_NODMA },
+	{ "Seagate STT20000A", NULL,		ATA_HORKAGE_NODMA },
 
 	/* Weird ATAPI devices */
 	{ "TORiSAN DVD-ROM DRD-N216", NULL,	ATA_HORKAGE_MAX_SEC_128 |
_

Patches currently in -mm which might be from davej@redhat.com are

git-cpufreq.patch
ada-add-seagate-stt20000a-to-dma-blacklist.patch
ide-add-seagate-stt20000a-to-dma-blacklist.patch
