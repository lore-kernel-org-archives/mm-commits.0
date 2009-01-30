From: akpm@linux-foundation.org
Subject: + pata_legacy-for-vlb-32bit-pio-dont-try-tricks-with-slop.patch added to -mm tree
Date: Thu, 29 Jan 2009 16:36:10 -0800
Message-ID: <200901300036.n0U0aA5T002665@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38239 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754054AbZA3Agh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Jan 2009 19:36:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk


The patch titled
     pata_legacy: for VLB 32bit PIO don't try tricks with slop
has been added to the -mm tree.  Its filename is
     pata_legacy-for-vlb-32bit-pio-dont-try-tricks-with-slop.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pata_legacy: for VLB 32bit PIO don't try tricks with slop
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

These devices are generally used with ATA anyway and it seems that some
ATAPI will need us to issue the right number of words.  Therefore as we
can't switch mid burst on VLB devices we should only use 32bit I/O for
suitable block sizes.


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_legacy.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/ata/pata_legacy.c~pata_legacy-for-vlb-32bit-pio-dont-try-tricks-with-slop drivers/ata/pata_legacy.c
--- a/drivers/ata/pata_legacy.c~pata_legacy-for-vlb-32bit-pio-dont-try-tricks-with-slop
+++ a/drivers/ata/pata_legacy.c
@@ -283,9 +283,10 @@ static void pdc20230_set_piomode(struct 
 static unsigned int pdc_data_xfer_vlb(struct ata_device *dev,
 			unsigned char *buf, unsigned int buflen, int rw)
 {
-	if (ata_id_has_dword_io(dev->id)) {
+	int slop = buflen & 3;
+	/* 32bit I/O capable *and* we need to write a whole number of dwords */
+	if (ata_id_has_dword_io(dev->id) && (slop == 0 || slop == 3)) {
 		struct ata_port *ap = dev->link->ap;
-		int slop = buflen & 3;
 		unsigned long flags;
 
 		local_irq_save(flags);
@@ -735,7 +736,7 @@ static unsigned int vlb32_data_xfer(stru
 	struct ata_port *ap = adev->link->ap;
 	int slop = buflen & 3;
 
-	if (ata_id_has_dword_io(adev->id)) {
+	if (ata_id_has_dword_io(adev->id) && (slop == 0 || slop == 3)) {
 		if (rw == WRITE)
 			iowrite32_rep(ap->ioaddr.data_addr, buf, buflen >> 2);
 		else
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

linux-next.patch
max3100-spi-uart-driver.patch
libata-sff-32bit-pio-use-16bit-on-slop.patch
pata_amd-program-fifo.patch
pata_legacy-for-vlb-32bit-pio-dont-try-tricks-with-slop.patch
atmel_serial-might-lose-modem-status-change.patch
pci-use-pci_ioremap_bar-in-drivers-serial.patch
linuxpps-core-support.patch
pps-userland-header-file-for-pps-api.patch
pps-documentation-programs-and-examples.patch
pps-linuxpps-clients-support.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
pps-parallel-port-clients-support.patch

