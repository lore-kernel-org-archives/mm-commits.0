From: akpm@linux-foundation.org
Subject: + libata-set-proper-ata-udma-mode-for-bf548-according-to-system-clock.patch added to -mm tree
Date: Thu, 29 Nov 2007 12:20:17 -0800
Message-ID: <200711292020.lATKKHAZ005541@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38311 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934045AbXK2UVC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Nov 2007 15:21:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sonic.adi@gmail.com, alan@lxorguk.ukuu.org.uk, htejun@gmail.com, jeff@garzik.org, sonic.zhang@analog.com


The patch titled
     libata: set proper ATA UDMA mode for bf548 according to system clock
has been added to the -mm tree.  Its filename is
     libata-set-proper-ata-udma-mode-for-bf548-according-to-system-clock.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: libata: set proper ATA UDMA mode for bf548 according to system clock
From: sonic zhang <sonic.adi@gmail.com>

UDMA Mode - Frequency compatibility

UDMA5 - 100 MB/s   - SCLK  = 133 MHz
UDMA4 - 66 MB/s    - SCLK >=  80 MHz
UDMA3 - 44.4 MB/s  - SCLK >=  50 MHz
UDMA2 - 33 MB/s    - SCLK >=  40 MHz

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Looks-fine-to: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_bf54x.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/ata/pata_bf54x.c~libata-set-proper-ata-udma-mode-for-bf548-according-to-system-clock drivers/ata/pata_bf54x.c
--- a/drivers/ata/pata_bf54x.c~libata-set-proper-ata-udma-mode-for-bf548-according-to-system-clock
+++ a/drivers/ata/pata_bf54x.c
@@ -1489,6 +1489,8 @@ static int __devinit bfin_atapi_probe(st
 	int board_idx = 0;
 	struct resource *res;
 	struct ata_host *host;
+	unsigned int fsclk = get_sclk();
+	int udma_mode = 5;
 	const struct ata_port_info *ppi[] =
 		{ &bfin_port_info[board_idx], NULL };
 
@@ -1507,6 +1509,11 @@ static int __devinit bfin_atapi_probe(st
 	if (res == NULL)
 		return -EINVAL;
 
+	while (bfin_port_info[board_idx].udma_mask>0 && udma_fsclk[udma_mode] > fsclk) {
+		udma_mode--;
+		bfin_port_info[board_idx].udma_mask >>= 1;
+	}
+
 	/*
 	 * Now that that's out of the way, wire up the port..
 	 */
_

Patches currently in -mm which might be from sonic.adi@gmail.com are

origin.patch
libata-set-proper-ata-udma-mode-for-bf548-according-to-system-clock.patch
