From: akpm@linux-foundation.org
Subject: - i-oat-tighten-descriptor-setup-performance-fix.patch removed from -mm tree
Date: Thu, 18 Oct 2007 01:57:44 -0700
Message-ID: <200710180857.l9I8vip5003146@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38819 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932666AbXJRI6Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 04:58:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dan.j.williams@intel.com, shannon.nelson@intel.com, mm-commits@vger.kernel.org


The patch titled
     i-oat-tighten-descriptor-setup-performance-fix
has been removed from the -mm tree.  Its filename was
     i-oat-tighten-descriptor-setup-performance-fix.patch

This patch was dropped because it was folded into i-oat-tighten-descriptor-setup-performance.patch

------------------------------------------------------
Subject: i-oat-tighten-descriptor-setup-performance-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Shannon Nelson <shannon.nelson@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/ioat_dma.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN drivers/dma/ioat_dma.c~i-oat-tighten-descriptor-setup-performance-fix drivers/dma/ioat_dma.c
--- a/drivers/dma/ioat_dma.c~i-oat-tighten-descriptor-setup-performance-fix
+++ a/drivers/dma/ioat_dma.c
@@ -46,8 +46,8 @@
 /* internal functions */
 static void ioat_dma_start_null_desc(struct ioat_dma_chan *ioat_chan);
 static void ioat_dma_memcpy_cleanup(struct ioat_dma_chan *ioat_chan);
-static inline struct ioat_desc_sw *ioat_dma_get_next_descriptor(
-					      struct ioat_dma_chan *ioat_chan);
+static struct ioat_desc_sw *
+ioat_dma_get_next_descriptor(struct ioat_dma_chan *ioat_chan);
 
 static inline struct ioat_dma_chan *ioat_lookup_chan_by_index(
 						struct ioatdma_device *device,
@@ -384,6 +384,7 @@ static void ioat_dma_free_chan_resources
 	ioat_chan->last_completion = ioat_chan->completion_addr = 0;
 	ioat_chan->pending = 0;
 }
+
 /**
  * ioat_dma_get_next_descriptor - return the next available descriptor
  * @ioat_chan: IOAT DMA channel handle
@@ -392,8 +393,8 @@ static void ioat_dma_free_chan_resources
  * channel's desc_lock held.  Allocates more descriptors if the channel
  * has run out.
  */
-static inline struct ioat_desc_sw *ioat_dma_get_next_descriptor(
-						struct ioat_dma_chan *ioat_chan)
+static struct ioat_desc_sw *
+ioat_dma_get_next_descriptor(struct ioat_dma_chan *ioat_chan)
 {
 	struct ioat_desc_sw *new = NULL;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
stop-using-dma_xxbit_mask.patch
fuse-fix-race-between-getattr-and-write.patch
fuse-add-file-handle-to-getattr-operation.patch
sparse-pointer-use-of-zero-as-null.patch
i-oat-tighten-descriptor-setup-performance.patch
i-oat-tighten-descriptor-setup-performance-fix.patch
i-oat-add-completion-callback-for-async_tx-interface-use-fix.patch
i-oat-add-completion-callback-for-async_tx-interface-use-fix-fix.patch
