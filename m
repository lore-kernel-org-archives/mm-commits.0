From: akpm@linux-foundation.org
Subject: - ada-add-seagate-stt20000a-to-dma-blacklist.patch removed from -mm tree
Date: Mon, 21 May 2007 22:56:49 -0700
Message-ID: <200705220556.l4M5um51028413@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60822 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756515AbXEVGAm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 May 2007 02:00:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davej@redhat.com, alan@redhat.com, hancockr@shaw.ca, htejun@gmail.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     ata: add Seagate STT20000A to DMA blacklist.
has been removed from the -mm tree.  Its filename was
     ada-add-seagate-stt20000a-to-dma-blacklist.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-cpufreq.patch
ide-add-seagate-stt20000a-to-dma-blacklist.patch
fix-confusion-in-fusion-driver-update.patch
fix-up-codingstyle-in-isofs.patch
