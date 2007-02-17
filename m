From: akpm@linux-foundation.org
Subject: - git-md-accel-warning-fixes.patch removed from -mm tree
Date: Fri, 16 Feb 2007 23:16:45 -0800
Message-ID: <200702170716.l1H7GjhK021735@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51159 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946508AbXBQHQs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 02:16:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dan.j.williams@intel.com, mm-commits@vger.kernel.org


The patch titled
     git-md-accel-warning-fixes
has been removed from the -mm tree.  Its filename was
     git-md-accel-warning-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 8 insertions(+), 8 deletions(-)

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
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
git-acpi.patch
git-arm.patch
git-powerpc.patch
git-drm.patch
git-dvb.patch
git-input.patch
setstream-param-for-psmouse-tweak.patch
sis-warning-fixes.patch
git-mips-fixup.patch
git-mtd.patch
git-netdev-all.patch
e1000-fix-shared-interrupt-warning-message-fix.patch
Fabric7-VIOC-driver-fixes.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
dmfe-add-support-for-suspend-resume-fix.patch
git-s390.patch
git-scsi-misc.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block-fixup.patch
git-unionfs-fixup.patch
after-before-x86_64-mm-mmconfig-share.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
kprobes-list-all-active-probes-in-the-system.patch
reduce-size-of-task_struct-on-64-bit-machines-fix.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
add-epoll-compat-code-to-kernel-compatc-tidy.patch
genalloc-warning-fixes.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
revert-x86_64-mm-putreg-check.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
git-gccbug-fixup.patch
