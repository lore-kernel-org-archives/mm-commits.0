From: akpm@linux-foundation.org
Subject: + pata_amd-dropping-to-pio-on-resume.patch added to -mm tree
Date: Tue, 27 Feb 2007 12:37:42 -0800
Message-ID: <200702272037.l1RKbkx6027637@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50809 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933087AbXB0UiK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Feb 2007 15:38:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ranma+kernel@tdiedrich.de, alan@lxorguk.ukuu.org.uk


The patch titled
     pata_amd dropping to PIO on resume
has been added to the -mm tree.  Its filename is
     pata_amd-dropping-to-pio-on-resume.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pata_amd dropping to PIO on resume
From: Tobias Diedrich <ranma+kernel@tdiedrich.de>

Jeff Garzik wrote:
> Robert Hancock wrote:
> >Yes, the fact that it's going into simplex mode is the problem, it
> >wasn't in simplex to start with. It looks like pata_amd does an
> >ata_pci_clear_simplex only for certain chip models, maybe this model
> >needs it as well?
>
> Deleting the ata_pci_clear_simplex() call, then adding
> ATA_FLAG_IGN_SIMPLEX to the ata_port_info info[] array, is also worth
> trying.

I tried the latter option and it works fine.
I didn't delete the ata_pci_clear_simplex call, since it is not
called for this model.

BTW, this the nVidia MCP55 IDE controller:
00:04.0 IDE interface: nVidia Corporation MCP55 IDE (rev a1)
00:04.0 0101: 10de:036e (rev a1)

(akpm: needs sane changelog, no idea if it's right)

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_amd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/ata/pata_amd.c~pata_amd-dropping-to-pio-on-resume drivers/ata/pata_amd.c
--- a/drivers/ata/pata_amd.c~pata_amd-dropping-to-pio-on-resume
+++ a/drivers/ata/pata_amd.c
@@ -611,7 +611,7 @@ static int amd_init_one(struct pci_dev *
 		},
 		{	/* 8: Nvidia Nforce2 and later */
 			.sht = &amd_sht,
-			.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+			.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST | ATA_FLAG_IGN_SIMPLEX,
 			.pio_mask = 0x1f,
 			.mwdma_mask = 0x07,
 			.udma_mask = 0x7f,	/* UDMA 133, no swdma */
_

Patches currently in -mm which might be from ranma+kernel@tdiedrich.de are

pata_amd-dropping-to-pio-on-resume.patch
