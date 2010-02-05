From: akpm@linux-foundation.org
Subject: [alternative-merged] ata-call-flush_dcache_page-around-pio-data-transfers-in-libata-affc.patch removed from -mm tree
Date: Fri, 05 Feb 2010 11:56:52 -0800
Message-ID: <201002051956.o15JuqbB017794@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44664 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933823Ab0BET6o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Feb 2010 14:58:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: catalin.marinas@arm.com, James.Bottomley@HansenPartnership.com, alan@lxorguk.ukuu.org.uk, davem@davemloft.net, jgarzik@pobox.com, stable@kernel.org, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     ata: call flush_dcache_page() around PIO data transfers in libata-aff.c
has been removed from the -mm tree.  Its filename was
     ata-call-flush_dcache_page-around-pio-data-transfers-in-libata-affc.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ata: call flush_dcache_page() around PIO data transfers in libata-aff.c
From: Catalin Marinas <catalin.marinas@arm.com>

Depending on the direction of the transfer, flush_dcache_page() must be
called either before (ATA_TFLAG_WRITE) or after (!ATA_TFLAG_WRITE) the
data copying to avoid D-cache aliasing with user space or I-D cache
coherency issues (when reading data from an ATA device using PIO, the
kernel dirties the D-cache but there is no flush_dcache_page() required on
Harvard architectures).

This patch allows the ARM boards to use a rootfs on CompactFlash with the
PATA platform driver.

As Anfei Zhou mentioned in a recent patch ("flush dcache before writing
into page to avoid alias"), on some architectures there may be a
performance benefit in differentiating the flush_dcache_page() calls based
on whether the kernel or the user page needs flushing.

IMHO, we should differentiate based on the direction (kernel reading or
writing from/to such page).  In the ARM case with PIPT Harvard caches
(newer processors), the kernel reading from a page that may be mapped in
user space shouldn't need cache flushing.  The kernel writing to such page
would require D-cache flushing because of coherency with the I-cache. 
Currently on ARM, the latter happens in both cases.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Jeff Garzik <jgarzik@pobox.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-sff.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN drivers/ata/libata-sff.c~ata-call-flush_dcache_page-around-pio-data-transfers-in-libata-affc drivers/ata/libata-sff.c
--- a/drivers/ata/libata-sff.c~ata-call-flush_dcache_page-around-pio-data-transfers-in-libata-affc
+++ a/drivers/ata/libata-sff.c
@@ -874,6 +874,9 @@ static void ata_pio_sector(struct ata_qu
 
 	DPRINTK("data %s\n", qc->tf.flags & ATA_TFLAG_WRITE ? "write" : "read");
 
+	if (do_write)
+		flush_dcache_page(page);
+
 	if (PageHighMem(page)) {
 		unsigned long flags;
 
@@ -893,6 +896,9 @@ static void ata_pio_sector(struct ata_qu
 				       do_write);
 	}
 
+	if (!do_write)
+		flush_dcache_page(page);
+
 	qc->curbytes += qc->sect_size;
 	qc->cursg_ofs += qc->sect_size;
 
_

Patches currently in -mm which might be from catalin.marinas@arm.com are

origin.patch
linux-next.patch
ata-call-flush_dcache_page-around-pio-data-transfers-in-libata-affc.patch

