From: akpm@osdl.org
Subject: + git-md-accel-warning-fixes.patch added to -mm tree
Date: Fri, 02 Feb 2007 18:11:11 -0800
Message-ID: <200702030212.l132CBZp028139@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52894 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946222AbXBCCMN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Feb 2007 21:12:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@osdl.org, dan.j.williams@intel.com


The patch titled
     git-md-accel-warning-fixes
has been added to the -mm tree.  Its filename is
     git-md-accel-warning-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: git-md-accel-warning-fixes
From: Andrew Morton <akpm@linux-foundation.org>

drivers/dma/async_tx.c: In function 'do_async_xor':
drivers/dma/async_tx.c:395: warning: format '%u' expects type 'unsigned int', but argument 3 has type 'size_t'
drivers/dma/async_tx.c: In function 'do_sync_xor':
drivers/dma/async_tx.c:425: warning: format '%u' expects type 'unsigned int', but argument 3 has type 'size_t'
drivers/dma/async_tx.c: In function 'async_xor_zero_sum':
drivers/dma/async_tx.c:619: warning: format '%u' expects type 'unsigned int', but argument 3 has type 'size_t'
drivers/dma/async_tx.c:635: warning: format '%u' expects type 'unsigned int', but argument 3 has type 'size_t'
drivers/dma/async_tx.c: In function 'async_memcpy':
drivers/dma/async_tx.c:690: warning: format '%u' expects type 'unsigned int', but argument 3 has type 'size_t'
drivers/dma/async_tx.c:708: warning: format '%u' expects type 'unsigned int', but argument 3 has type 'size_t'
drivers/dma/async_tx.c: In function 'async_memset':
drivers/dma/async_tx.c:774: warning: format '%u' expects type 'unsigned int', but argument 3 has type 'size_t'
drivers/dma/async_tx.c:785: warning: format '%u' expects type 'unsigned int', but argument 3 has type 'size_t'

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/async_tx.c |   16 ++++++++--------
 linux/raid/xor.h       |    0 
 2 files changed, 8 insertions(+), 8 deletions(-)

diff -puN arch/arm/Kconfig~git-md-accel-warning-fixes arch/arm/Kconfig
diff -puN drivers/Makefile~git-md-accel-warning-fixes drivers/Makefile
diff -puN drivers/dma/Kconfig~git-md-accel-warning-fixes drivers/dma/Kconfig
diff -puN drivers/dma/Makefile~git-md-accel-warning-fixes drivers/dma/Makefile
diff -puN drivers/dma/async_tx.c~git-md-accel-warning-fixes drivers/dma/async_tx.c
--- a/drivers/dma/async_tx.c~git-md-accel-warning-fixes
+++ a/drivers/dma/async_tx.c
@@ -392,7 +392,7 @@ do_async_xor(struct dma_async_tx_descrip
 	enum dma_data_direction dir;
 	int i;
 
-	PRINTK("%s: len: %u\n", __FUNCTION__, len);
+	PRINTK("%s: len: %zu\n", __FUNCTION__, len);
 
 	dir = (flags & ASYNC_TX_ASSUME_COHERENT) ?
 		DMA_NONE : DMA_FROM_DEVICE;
@@ -422,7 +422,7 @@ do_sync_xor(struct page *dest, struct pa
 	void *_dest;
 	int i;
 
-	PRINTK("%s: len: %u\n", __FUNCTION__, len);
+	PRINTK("%s: len: %zu\n", __FUNCTION__, len);
 
 	/* reuse the 'src_list' array to convert to buffer pointers */
 	for (i = 0; i < src_cnt; i++)
@@ -616,7 +616,7 @@ async_xor_zero_sum(struct page *dest, st
 		dma_addr_t dma_addr;
 		enum dma_data_direction dir;
 
-		PRINTK("%s: (async) len: %u\n", __FUNCTION__, len);
+		PRINTK("%s: (async) len: %zu\n", __FUNCTION__, len);
 
 		dir = (flags & ASYNC_TX_ASSUME_COHERENT) ?
 			DMA_NONE : DMA_TO_DEVICE;
@@ -632,7 +632,7 @@ async_xor_zero_sum(struct page *dest, st
 	} else {
 		unsigned long xor_flags = flags;
 
-		PRINTK("%s: (sync) len: %u\n", __FUNCTION__, len);
+		PRINTK("%s: (sync) len: %zu\n", __FUNCTION__, len);
 
 		xor_flags |= ASYNC_TX_XOR_DROP_DST;
 		xor_flags &= ~ASYNC_TX_ACK;
@@ -687,7 +687,7 @@ async_memcpy(struct page *dest, struct p
 		dma_addr_t dma_addr;
 		enum dma_data_direction dir;
 
-		PRINTK("%s: (async) len: %u\n", __FUNCTION__, len);
+		PRINTK("%s: (async) len: %zu\n", __FUNCTION__, len);
 
 		dir = (flags & ASYNC_TX_ASSUME_COHERENT) ?
 			DMA_NONE : DMA_FROM_DEVICE;
@@ -705,7 +705,7 @@ async_memcpy(struct page *dest, struct p
 			callback_param);
 	} else { /* run the memcpy synchronously */
 		void *dest_buf, *src_buf;
-		PRINTK("%s: (sync) len: %u\n", __FUNCTION__, len);
+		PRINTK("%s: (sync) len: %zu\n", __FUNCTION__, len);
 
 		/* wait for any prerequisite operations */
 		if (depend_tx) {
@@ -771,7 +771,7 @@ async_memset(struct page *dest, int val,
 		dma_addr_t dma_addr;
 		enum dma_data_direction dir;
 
-		PRINTK("%s: (async) len: %u\n", __FUNCTION__, len);
+		PRINTK("%s: (async) len: %zu\n", __FUNCTION__, len);
 		dir = (flags & ASYNC_TX_ASSUME_COHERENT) ?
 			DMA_NONE : DMA_FROM_DEVICE;
 
@@ -782,7 +782,7 @@ async_memset(struct page *dest, int val,
 			callback_param);
 	} else { /* run the memset synchronously */
 		void *dest_buf;
-		PRINTK("%s: (sync) len: %u\n", __FUNCTION__, len);
+		PRINTK("%s: (sync) len: %zu\n", __FUNCTION__, len);
 
 		dest_buf = (void *) (((char *) page_address(dest)) + offset);
 
diff -puN drivers/dma/dmaengine.c~git-md-accel-warning-fixes drivers/dma/dmaengine.c
diff -puN drivers/dma/ioatdma.c~git-md-accel-warning-fixes drivers/dma/ioatdma.c
diff -puN drivers/dma/ioatdma.h~git-md-accel-warning-fixes drivers/dma/ioatdma.h
diff -puN drivers/dma/iop-adma.c~git-md-accel-warning-fixes drivers/dma/iop-adma.c
diff -puN drivers/dma/xor.c~git-md-accel-warning-fixes drivers/dma/xor.c
diff -puN drivers/md/Kconfig~git-md-accel-warning-fixes drivers/md/Kconfig
diff -puN drivers/md/Makefile~git-md-accel-warning-fixes drivers/md/Makefile
diff -puN drivers/md/raid5.c~git-md-accel-warning-fixes drivers/md/raid5.c
diff -puN /dev/null /dev/null
diff -puN include/asm-arm/hardware/iop_adma.h~git-md-accel-warning-fixes include/asm-arm/hardware/iop_adma.h
diff -puN include/linux/async_tx.h~git-md-accel-warning-fixes include/linux/async_tx.h
diff -puN include/linux/dmaengine.h~git-md-accel-warning-fixes include/linux/dmaengine.h
diff -puN include/linux/raid/raid5.h~git-md-accel-warning-fixes include/linux/raid/raid5.h
diff -puN include/linux/raid/xor.h~git-md-accel-warning-fixes include/linux/raid/xor.h
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
git-libata-all-forward-declare-struct-device.patch
git-md-accel-fixes.patch
git-md-accel-warning-fixes.patch
knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses-tidy.patch
knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path-tidy.patch
