From: akpm@linux-foundation.org
Subject: - drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch removed from -mm tree
Date: Mon, 07 May 2007 14:12:48 -0700
Message-ID: <200705072112.l47LCnAk005472@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59513 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966725AbXEGVNc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 17:13:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amol@verismonetworks.com, James.Bottomley@steeleye.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     drivers/scsi/mca_53c9x.c : save_flags()/cli() removal
has been removed from the -mm tree.  Its filename was
     drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: drivers/scsi/mca_53c9x.c : save_flags()/cli() removal
From: Amol Lad <amol@verismonetworks.com>

Replaced save_flags()/cli() with spin_lock alternatives

[akpm@osdl.org: no longer BROKEN_ON_SMP]
Signed-off-by: Amol Lad <amol@verismonetworks.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/mca_53c9x.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff -puN drivers/scsi/mca_53c9x.c~drivers-scsi-mca_53c9xc-save_flags-cli-removal drivers/scsi/mca_53c9x.c
--- a/drivers/scsi/mca_53c9x.c~drivers-scsi-mca_53c9xc-save_flags-cli-removal
+++ a/drivers/scsi/mca_53c9x.c
@@ -341,9 +341,7 @@ static void dma_init_read(struct NCR_ESP
 {
 	unsigned long flags;
 
-
-	save_flags(flags);
-	cli();
+	spin_lock_irqsave(esp->ehost->host_lock, flags);
 
 	mca_disable_dma(esp->dma);
 	mca_set_dma_mode(esp->dma, MCA_DMA_MODE_XFER | MCA_DMA_MODE_16 |
@@ -352,16 +350,14 @@ static void dma_init_read(struct NCR_ESP
 	mca_set_dma_count(esp->dma, length / 2); /* !!! */
 	mca_enable_dma(esp->dma);
 
-	restore_flags(flags);
+	spin_unlock_irqrestore(esp->ehost->host_lock, flags);
 }
 
 static void dma_init_write(struct NCR_ESP *esp, __u32 addr, int length)
 {
 	unsigned long flags;
 
-
-	save_flags(flags);
-	cli();
+	spin_lock_irqsave(esp->ehost->host_lock, flags);
 
 	mca_disable_dma(esp->dma);
 	mca_set_dma_mode(esp->dma, MCA_DMA_MODE_XFER | MCA_DMA_MODE_WRITE |
@@ -370,7 +366,7 @@ static void dma_init_write(struct NCR_ES
 	mca_set_dma_count(esp->dma, length / 2); /* !!! */
 	mca_enable_dma(esp->dma);
 
-	restore_flags(flags);
+	spin_unlock_irqrestore(esp->ehost->host_lock, flags);
 }
 
 static void dma_ints_off(struct NCR_ESP *esp)
_

Patches currently in -mm which might be from amol@verismonetworks.com are

drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-megaraidc-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
