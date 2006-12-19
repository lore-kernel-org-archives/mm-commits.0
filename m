From: akpm@osdl.org
Subject: - libata-dont-initialize-sg-in-ata_exec_internal-if-dma_none-take-2.patch removed from -mm tree
Date: Tue, 19 Dec 2006 12:32:24 -0800
Message-ID: <200612192032.kBJKWO1q009520@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:60781 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932891AbWLSUeN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Dec 2006 15:34:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: htejun@gmail.com, arnd.bergmann@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     libata: don't initialize sg in ata_exec_internal() if DMA_NONE
has been removed from the -mm tree.  Its filename was
     libata-dont-initialize-sg-in-ata_exec_internal-if-dma_none-take-2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: libata: don't initialize sg in ata_exec_internal() if DMA_NONE
From: Tejun Heo <htejun@gmail.com>

Calling sg_init_one() with NULL buf causes oops on certain configurations. 
Don't initialize sg in ata_exec_internal() if DMA_NONE and make the
function complain if @buf is NULL when dma_dir isn't DMA_NONE.  While at
it, fix comment.

The problem is discovered and initial patch was submitted by Arnd Bergmann.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Arnd Bergmann <arnd.bergmann@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/ata/libata-core.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff -puN drivers/ata/libata-core.c~libata-dont-initialize-sg-in-ata_exec_internal-if-dma_none-take-2 drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~libata-dont-initialize-sg-in-ata_exec_internal-if-dma_none-take-2
+++ a/drivers/ata/libata-core.c
@@ -1168,7 +1168,7 @@ void ata_qc_complete_internal(struct ata
 }
 
 /**
- *	ata_exec_internal_sg - execute libata internal command
+ *	ata_exec_internal - execute libata internal command
  *	@dev: Device to which the command is sent
  *	@tf: Taskfile registers for the command and the result
  *	@cdb: CDB for packet command
@@ -1357,11 +1357,17 @@ unsigned ata_exec_internal(struct ata_de
 			   struct ata_taskfile *tf, const u8 *cdb,
 			   int dma_dir, void *buf, unsigned int buflen)
 {
-	struct scatterlist sg;
+	struct scatterlist *psg = NULL, sg;
+	unsigned int n_elem = 0;
 
-	sg_init_one(&sg, buf, buflen);
+	if (dma_dir != DMA_NONE) {
+		WARN_ON(!buf);
+		sg_init_one(&sg, buf, buflen);
+		psg = &sg;
+		n_elem++;
+	}
 
-	return ata_exec_internal_sg(dev, tf, cdb, dma_dir, &sg, 1);
+	return ata_exec_internal_sg(dev, tf, cdb, dma_dir, psg, n_elem);
 }
 
 /**
_

Patches currently in -mm which might be from htejun@gmail.com are

origin.patch
libata-dont-initialize-sg-in-ata_exec_internal-if-dma_none-take-2.patch
libata-wrong-sizeof-for-buffer.patch

